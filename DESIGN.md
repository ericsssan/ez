# Sx3lint — A High-Performance JavaScript/TypeScript Linter in Zig

> Inspired by and indebted to the [Oxc project](https://github.com/oxc-project/oxc) and the work of Boshen Chen and the Oxc team. Oxlint proved that a linter can be 50-100x faster than ESLint through data-oriented design, arena allocation, and systems-language implementation. Sx3lint aims to explore whether Zig's unique strengths — first-class SIMD, comptime metaprogramming, native allocator interfaces, and MultiArrayList — can push these ideas further.
>
> This project stands on the shoulders of the Oxc team's research, benchmarks, and open documentation of their architectural decisions.

## Why This Exists

Oxlint is already excellent. But it's written in Rust, and there are specific areas where Zig's design offers structural advantages:

| Oxc/Rust Constraint | Zig Opportunity |
|---|---|
| `bumpalo` requires forked collections (`bumpalo::Vec`, etc.) | Every Zig stdlib collection accepts an `Allocator` parameter natively |
| SIMD requires nightly Rust or platform-specific `core::arch` intrinsics | Zig has stable, first-class `@Vector(N, T)` with portable operations |
| `string-cache` global `Mutex<HashMap>` caused 30% parallel slowdown | Zig's explicit allocator model avoids hidden global state by design |
| Enum variants are sized to the largest variant (wastes memory) | `MultiArrayList` on tagged unions separates tags from data, eliminating padding |
| Proc-macros for code generation (separate compilation unit, slow) | `comptime` runs at build time in the same language, same compilation |
| Borrow checker prevents parent pointers in AST | Zig allows mutable parent pointers freely |
| Incremental compilation is slow (23-min rebuilds reported in deep deps) | Zig's lazy compilation + upcoming incremental: sub-second rebuilds |

The goal is not to "beat Oxc" but to explore a different design space and provide an alternative for developers who prefer Zig's philosophy.

## Architecture Overview

```
┌────────────────────────────────────────────┐
│  CLI + File Discovery                      │
│  - kqueue file watching (macOS)            │
│  - std.Thread.Pool for file parallelism    │
├────────────────────────────────────────────┤
│  Per-File Pipeline (arena-scoped)          │
│                                            │
│  ┌──────────┐  ┌──────────┐  ┌─────────┐  │
│  │  Lexer   │  │  Parser  │  │Semantic │  │
│  │          │  │          │  │Analysis │  │
│  │  SIMD    │  │  Arena-  │  │         │  │
│  │  accel.  │  │  alloc'd │  │ Scopes  │  │
│  │  tokens  │  │  AST     │  │ Symbols │  │
│  └──────────┘  └──────────┘  └─────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │  Lint Rule Dispatch                  │  │
│  │  comptime-generated visitor table    │  │
│  │  single-pass AST traversal           │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  Arena freed — all AST memory reclaimed    │
├────────────────────────────────────────────┤
│  Diagnostics (block-buffered output)       │
└────────────────────────────────────────────┘
```

Each file gets its own arena allocator. Parse, analyze, lint, report, then free the entire arena in one shot. No per-node deallocation. No GC.

## Core Design Decisions

### 1. AST Representation: MultiArrayList

This is Sx3lint's key structural advantage over Oxc.

**The Oxc problem**: Rust enums are sized to their largest variant. An `Expression` enum with 45 variants is 200+ bytes unboxed. Oxc mitigates this by boxing every variant (`Box<'a, T>`) reducing the enum to 16 bytes (pointer + tag), but every field access is now a pointer chase.

**The Zig approach**: Use `MultiArrayList` to store AST nodes in struct-of-arrays layout:

```zig
const Node = struct {
    tag: Tag,           // u8 — what kind of node
    main_token: u32,    // index into token array
    lhs: Index,         // left child (or special data)
    rhs: Index,         // right child (or special data)
};

// MultiArrayList stores each field in a separate contiguous array:
// tags:        [.fn_decl, .binary_op, .literal, .ident, ...]
// main_tokens: [42,       67,         89,       91,     ...]
// lhs_values:  [1,        2,          0,        0,      ...]
// rhs_values:  [5,        3,          0,        0,      ...]
```

Benefits:
- **Tag-only iteration**: When a rule only needs to check node types (e.g., "find all `debugger` statements"), it reads the `tags` array sequentially — never touching `main_tokens`, `lhs`, or `rhs`. Perfect cache utilization.
- **No variant padding**: Each field array is packed. No wasted bytes from Rust's "size of largest variant" rule.
- **~37.5% memory savings** over traditional AST layouts (demonstrated by the Zig self-hosted compiler).
- **Node index is a `u32`** — 4 bytes, not 8-byte pointers. Halves the cost of every AST reference.

This is the same design used by Bun's `js_parser.zig` and the Zig self-hosted compiler. It's proven at scale.

### Extra Data Array

Nodes with more than 2 children (e.g., function parameter lists, array literals) store overflow data in a separate `extra_data: []u32` array. The `lhs`/`rhs` fields become offset+length into `extra_data`:

```zig
// For a function call `foo(a, b, c)`:
// Node: { .tag = .call_expr, .main_token = <foo>, .lhs = <callee_node>, .rhs = <extra_offset> }
// extra_data[extra_offset..extra_offset+3] = [arg_a_node, arg_b_node, arg_c_node]
```

This keeps the base `Node` struct at **16 bytes** regardless of how many children a node has.

### 2. Lexer: SIMD-Accelerated Scanning

Oxc uses SIMD for whitespace skipping and gained "a few percent." Zig's first-class `@Vector` makes this cleaner:

```zig
const Vec16 = @Vector(16, u8);

fn skipWhitespace(src: [*]const u8, pos: usize, len: usize) usize {
    var i = pos;
    // Process 16 bytes at a time
    while (i + 16 <= len) {
        const chunk: Vec16 = src[i..][0..16].*;
        const spaces = chunk == @as(Vec16, @splat(@as(u8, ' ')));
        const tabs = chunk == @as(Vec16, @splat(@as(u8, '\t')));
        const newlines = chunk == @as(Vec16, @splat(@as(u8, '\n')));
        const returns = chunk == @as(Vec16, @splat(@as(u8, '\r')));
        const ws = spaces | tabs | newlines | returns;
        // Find first non-whitespace byte
        const mask = ~@as(u16, @bitCast(ws));
        if (mask != 0) {
            return i + @ctz(mask);
        }
        i += 16;
    }
    // Scalar fallback for remaining bytes
    while (i < len and isWhitespace(src[i])) : (i += 1) {}
    return i;
}
```

Additional SIMD opportunities:
- **Identifier scanning**: ASCII letter/digit/underscore detection in 16-byte chunks
- **String literal scanning**: Find closing quote or escape character
- **Comment skipping**: Find `*/` end of block comment
- **Line counting**: Count `\n` bytes in 16-byte chunks for source mapping

Zig's `@Vector` is stable and portable. The same code targets ARM NEON (Apple Silicon) and x86 SSE/AVX without platform-specific intrinsics.

### 3. Arena Allocation (Zig's Native Advantage)

Oxc wraps `bumpalo` and must use custom `Box<'a, T>` and `Vec<'a, T>` types that thread lifetime annotations through the entire AST. In Zig, every stdlib collection already accepts an `Allocator`:

```zig
const arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
defer arena.deinit(); // free everything at once

// All standard collections work with the arena — no special types
var nodes = std.ArrayList(Node).init(arena.allocator());
var scopes = std.ArrayList(Scope).init(arena.allocator());
var strings = std.ArrayList(u8).init(arena.allocator()); // string buffer
```

No lifetime annotations. No special arena-aware collection types. No `'a` threaded through every function signature. The allocator is passed explicitly, and every data structure cooperates.

### 4. Lint Rule Dispatch: comptime-Generated Visitor

Oxc uses Rust traits for rule dispatch. Zig has no traits, but `comptime` can generate equivalent dispatch tables with zero runtime overhead:

```zig
// Each rule is a struct with known methods
const NoDebugger = struct {
    pub fn run(node: Node, ctx: *LintContext) void {
        if (node.tag == .debugger_stmt) {
            ctx.report(.{
                .message = "`debugger` statement is not allowed",
                .span = node.span(ctx.source),
                .severity = .warning,
            });
        }
    }
};

const NoConsoleLog = struct {
    pub fn run(node: Node, ctx: *LintContext) void {
        if (node.tag == .call_expr and ctx.isConsoleMethod(node, "log")) {
            ctx.report(.{
                .message = "Unexpected `console.log`",
                .span = node.span(ctx.source),
                .severity = .warning,
            });
        }
    }
};

// Compile-time rule registration
const all_rules = .{
    NoDebugger,
    NoConsoleLog,
    NoVar,
    NoUnusedVars,
    // ... 300+ rules
};

// comptime generates a dispatch function with zero overhead
fn runAllRules(node: Node, ctx: *LintContext) void {
    inline for (all_rules) |Rule| {
        // Compile-time check: does this rule have a `run` method?
        if (@hasDecl(Rule, "run")) {
            Rule.run(node, ctx);
        }
    }
}
```

`inline for` unrolls at compile time — the generated code is equivalent to hand-writing each rule call. No vtable. No dynamic dispatch. No trait object indirection.

**Rule interface validation at compile time:**

```zig
fn validateRule(comptime Rule: type) void {
    if (!@hasDecl(Rule, "run")) {
        @compileError("Rule " ++ @typeName(Rule) ++ " must have a `run` method");
    }
    // Validate function signature
    const RunFn = @TypeOf(Rule.run);
    const info = @typeInfo(RunFn).@"fn";
    if (info.params.len != 2) {
        @compileError("Rule.run must accept (Node, *LintContext)");
    }
}

// Validated at compile time for every rule
comptime {
    inline for (all_rules) |Rule| {
        validateRule(Rule);
    }
}
```

This gives compile-time errors when a rule doesn't conform to the interface — similar to Rust traits but without the trait system.

### 5. Semantic Analysis: Struct-of-Arrays Symbol Table

Following Oxc's SoA design (which they found critical for cache performance):

```zig
const SymbolTable = struct {
    // Struct-of-Arrays: each field is a separate contiguous array
    names: std.ArrayList([]const u8),
    spans: std.ArrayList(Span),
    flags: std.ArrayList(SymbolFlags),
    scope_ids: std.ArrayList(ScopeId),
    declarations: std.ArrayList(NodeIndex),
    references: std.ArrayList(std.ArrayList(ReferenceId)),

    pub fn getName(self: *const SymbolTable, id: SymbolId) []const u8 {
        return self.names.items[@intFromEnum(id)];
    }
};
```

When a rule iterates over all symbol names (e.g., checking naming conventions), it reads a contiguous array of name slices without loading spans, flags, or other metadata into cache.

### 6. Parallelism: Per-File Thread Pool

```zig
const LintRunner = struct {
    pool: std.Thread.Pool,
    diagnostics: std.Thread.Mutex = .{},
    results: std.ArrayList(FileResult),

    pub fn lintFiles(self: *LintRunner, files: []const []const u8) void {
        for (files) |file_path| {
            self.pool.spawn(lintOneFile, .{ self, file_path });
        }
        self.pool.waitForAll();
    }

    fn lintOneFile(self: *LintRunner, path: []const u8) void {
        // Each file gets its own arena — zero shared state
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        const source = readFile(arena.allocator(), path);
        const tokens = Lexer.tokenize(arena.allocator(), source);
        const ast = Parser.parse(arena.allocator(), tokens);
        const semantic = SemanticAnalyzer.analyze(arena.allocator(), ast);
        const file_diags = Linter.lint(ast, semantic);

        // Only lock to append results
        self.diagnostics.lock();
        defer self.diagnostics.unlock();
        self.results.appendSlice(file_diags);
    }
};
```

No shared mutable state during linting. The mutex is only held for the brief moment of appending results. This avoids Oxc's `string-cache` global lock problem by design — Zig's explicit allocator model means there are no hidden global allocations.

### 7. Flat Index-Addressed AST with Parent Pointers

Oxc builds a secondary `indextree` structure for parent-pointing traversal because Rust's borrow checker prevents adding parent pointers to a borrowed AST. In Zig, we can add parent indices directly:

```zig
const Node = struct {
    tag: Tag,
    main_token: u32,
    lhs: Index,
    rhs: Index,
    parent: Index,    // direct parent pointer — impossible in safe Rust
};
```

Rules that need to check parent context (very common — e.g., "is this expression inside a `try` block?") get O(1) parent access without a secondary data structure.

### 8. String Handling: Zero-Copy Source Slices

Source code is loaded into a single contiguous buffer. All string references in the AST are `[]const u8` slices into this buffer — pointer + length, no allocation, no copying:

```zig
const Token = struct {
    tag: TokenTag,
    start: u32,       // offset into source buffer
    end: u32,         // offset into source buffer
};

fn tokenText(token: Token, source: []const u8) []const u8 {
    return source[token.start..token.end];
}
```

For the rare case of strings with escape sequences (where the parsed value differs from source text), an `extra_strings` buffer in the arena stores the unescaped version. This matches Oxc's `Cow`/`RefOrOwned` pattern.

**Short string optimization**: For identifiers and diagnostic messages, use a comptime-generated inline string type:

```zig
const InlineStr = extern struct {
    data: [23]u8,
    len: u8,        // if len <= 23, string is inline; otherwise, data[0..8] is a pointer

    pub fn fromSlice(s: []const u8) InlineStr {
        var result: InlineStr = undefined;
        if (s.len <= 23) {
            @memcpy(result.data[0..s.len], s);
            result.len = @intCast(s.len);
        } else {
            // Store pointer + length for long strings
            @as(*[*]const u8, @ptrCast(&result.data)).* = s.ptr;
            @as(*usize, @ptrCast(result.data[8..])).* = s.len;
            result.len = 0xFF; // sentinel for "pointer mode"
        }
        return result;
    }
};
```

24 bytes total — same size as Oxc's `CompactStr`, but implemented with Zig's low-level control.

### 9. Zero-Copy AST Transfer to JavaScript Plugins

This is Oxlint's breakthrough for JS plugin support, and Zig has a **structural advantage** here.

#### How Oxlint Does It (The Problem They Had to Solve)

Oxlint needed to support ESLint-compatible JavaScript plugins while keeping the Rust-native performance. The naive approach — serialize AST to JSON, pass to JS, deserialize — would destroy all performance gains. Their solution:

1. JS allocates an `ArrayBuffer` and passes it to Rust via napi-rs
2. Rust creates a `bumpalo::Bump` allocator using that buffer as its backing memory (via a hack on bumpalo internals — technically undefined behavior)
3. Rust parses the AST **directly into the JS-owned buffer** using `#[repr(C)]` types at known offsets
4. Control returns to JS — **JS already has the data** since it owns the buffer
5. JS reads the raw bytes using a **code-generated deserializer** that knows the exact memory layout of every Rust struct
6. Deserialization is **lazy** — only nodes that rules actually access get materialized as JS objects

Result: **86% faster** than their previous approach. The Rust side does **zero serialization**. The JS side does minimal deserialization, only on demand.

#### Why This Is Hacky in Rust

Oxlint's implementation has significant technical debt:

- **`Allocator::from_raw_parts`** is described by the author as "extremely hacky" — it creates a `bumpalo::Bump` from external memory, which bumpalo doesn't officially support
- It depends on **unspecified internals of bumpalo** — version is pinned at 3.19.1
- It's technically **undefined behavior** per Rust's memory model
- Requires **6 GiB buffer allocation** to guarantee 4 GiB alignment (for 32-bit pointer offsets readable by JS `Number`)
- This caused **memory exhaustion on Windows**
- All AST types must be `#[repr(C)]` — fighting Rust's default layout randomization
- A separate `oxc_ast_tools` crate must analyze every AST type and generate the JS deserializer

#### Why Zig Solves This Cleanly

Every problem Oxlint has with raw transfer **disappears in Zig**:

| Oxlint/Rust Problem | Zig Reality |
|---|---|
| Must hack bumpalo to allocate into external memory | Zig's `ArenaAllocator` accepts any backing allocator — wrap the JS buffer as a `FixedBufferAllocator`, done |
| Must annotate every type with `#[repr(C)]` | Zig `extern struct` is C-layout by default. This is the natural way to define types in Zig. |
| Must generate deserializer code from Rust type info | `comptime` introspects struct layouts at build time — field offsets, sizes, alignments are all available via `@offsetOf`, `@sizeOf`, `@alignOf` |
| Undefined behavior from bumpalo internals | No UB. Zig's allocator interface is designed for exactly this use case. |
| 6 GiB buffer for 4 GiB alignment hack | Zig's `std.heap.page_allocator` + `@alignCast` give direct control over alignment. Request a 4 GiB-aligned allocation explicitly. |
| Version pinning on bumpalo | No third-party allocator dependency. Zig's allocator is part of the standard library. |

#### Implementation in Zig

```zig
// JS passes an ArrayBuffer via Node-API (napi)
// Zig uses it directly as the arena's backing memory

const JsBufferAllocator = struct {
    buffer: []align(8) u8,
    offset: usize,

    pub fn allocator(self: *JsBufferAllocator) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .free = free,
            },
        };
    }

    fn alloc(ctx: *anyopaque, len: usize, ptr_align: u8, _: usize) ?[*]u8 {
        const self: *JsBufferAllocator = @ptrCast(@alignCast(ctx));
        const aligned_offset = std.mem.alignForward(usize, self.offset, @as(usize, 1) << @intCast(ptr_align));
        if (aligned_offset + len > self.buffer.len) return null;
        const result = self.buffer[aligned_offset..][0..len];
        self.offset = aligned_offset + len;
        return result.ptr;
    }

    // resize and free are no-ops for a bump allocator
    fn resize(_: *anyopaque, _: []u8, _: u8, _: usize) bool { return false; }
    fn free(_: *anyopaque, _: []u8, _: u8) void {}
};

// Usage with Node-API:
pub export fn parse_into_buffer(
    buffer_ptr: [*]align(8) u8,
    buffer_len: usize,
    source_ptr: [*]const u8,
    source_len: usize,
) u32 {
    var backing = JsBufferAllocator{
        .buffer = buffer_ptr[0..buffer_len],
        .offset = 0,
    };

    // Parse AST directly into the JS-owned buffer
    var parser = Parser.init(backing.allocator());
    const ast = parser.parse(source_ptr[0..source_len]);

    // Return the offset where data ends — JS reads [0..offset]
    return @intCast(backing.offset);
}
```

No hack. No UB. No pinned dependency. The allocator interface does exactly what it was designed to do.

#### JS-Side: comptime-Generated Layout Descriptors

Oxlint uses `oxc_ast_tools` (a separate Rust crate) to analyze types and generate JS deserializer code. Sx3lint uses `comptime`:

```zig
// At compile time, generate a layout descriptor for each AST type
fn generateLayoutDescriptor(comptime T: type) []const FieldDescriptor {
    const fields = @typeInfo(T).@"struct".fields;
    var descriptors: [fields.len]FieldDescriptor = undefined;
    inline for (fields, 0..) |field, i| {
        descriptors[i] = .{
            .name = field.name,
            .offset = @offsetOf(T, field.name),
            .size = @sizeOf(field.type),
            .type_tag = typeToTag(field.type),
        };
    }
    return &descriptors;
}

// This compiles to constant data — zero runtime cost
const node_layout = comptime generateLayoutDescriptor(Node);

// Export as C ABI for the JS deserializer generator to consume
pub export fn get_node_field_count() u32 {
    return node_layout.len;
}
pub export fn get_node_field_offset(index: u32) u32 {
    return @intCast(node_layout[index].offset);
}
pub export fn get_node_field_size(index: u32) u32 {
    return @intCast(node_layout[index].size);
}
```

The JS-side deserializer reads the buffer using these offsets:

```javascript
// Generated from Zig's comptime layout descriptors
class NodeView {
  constructor(buffer, offset) {
    this._buf = new DataView(buffer);
    this._off = offset;
  }
  // Field offsets are constants from comptime
  get tag()        { return this._buf.getUint8(this._off + 0); }
  get mainToken()  { return this._buf.getUint32(this._off + 4, true); }
  get lhs()        { return this._buf.getUint32(this._off + 8, true); }
  get rhs()        { return this._buf.getUint32(this._off + 12, true); }
  get parent()     { return this._buf.getUint32(this._off + 16, true); }
}
```

Lazy — JS only materializes a `NodeView` when a rule accesses that node. The `DataView` reads directly from the shared buffer. Zero copy. Zero serialization.

#### 32-Bit Pointer Advantage

Sx3lint's MultiArrayList AST already uses **u32 indices** for all node references (not 64-bit pointers). This means:

- Every node reference fits in a JS `Number` with no precision loss
- No need for Oxlint's 4 GiB alignment trick to truncate 64-bit pointers
- The buffer can be any size — no 6 GiB over-allocation
- Works on all platforms including Windows without memory exhaustion

#### Summary: Zig's Raw Transfer vs Oxlint's

| | Oxlint (Rust) | Sx3lint (Zig) |
|---|---|---|
| Allocate into external buffer | Hack on bumpalo internals (UB) | Standard `Allocator` interface (designed for this) |
| Deterministic memory layout | Opt-in `#[repr(C)]` on every type | Default for `extern struct` |
| Layout introspection | Separate `oxc_ast_tools` crate | `comptime` `@offsetOf` / `@sizeOf` |
| JS deserializer generation | Generated Rust → TypeScript codegen | comptime layout descriptors → thin JS DataView wrappers |
| Pointer size in buffer | 64-bit (needs 4 GiB alignment trick) | 32-bit u32 indices (fits in JS Number natively) |
| Buffer size requirement | 6 GiB to guarantee alignment | Any size (no alignment constraint) |
| Windows compatibility | Memory exhaustion reported | No issue (no over-allocation) |
| Undefined behavior | Yes (bumpalo internal dependency) | None |

## Known Zig Limitations & Mitigations

### 1. No Borrow Checker — Use-After-Free Risk

**Risk**: Holding a slice into an `ArrayList` buffer, then appending to the list (which may reallocate), invalidates the slice.

**Mitigation**:
- Arena allocation means we rarely resize after initial construction. The AST is built once, then read-only during linting.
- `GeneralPurposeAllocator` in debug mode detects use-after-free with stack traces.
- Use indices (u32) instead of pointers for all AST references — indices survive reallocation.
- Fuzz testing with `zig test --fuzz` to catch memory bugs.

### 2. No Traits — Rule Interface Enforcement

**Risk**: A rule struct missing the `run` method or having the wrong signature produces cryptic errors.

**Mitigation**: `comptime` validation (shown above) gives clear compile-time errors. Not as ergonomic as Rust's `impl Rule for MyRule`, but functionally equivalent.

### 3. No Closures — Verbose Callback Patterns

**Risk**: Visitor patterns that need state require explicit context passing.

**Mitigation**: Every lint rule is a struct. Rule state (if any) lives in struct fields. The `run` method receives a `*LintContext` with all necessary context. This is actually clearer than closure-based approaches — state is always explicit.

### 4. No Rich Error Payloads

**Risk**: Zig's `error` type carries only a code, not a payload. Parser error recovery needs rich context.

**Mitigation**: Use a separate `diagnostics: ArrayList(Diagnostic)` attached to the parser context. Errors are accumulated there with full span, message, and severity info. The error union is used only for fatal/unrecoverable errors.

```zig
const Parser = struct {
    diagnostics: std.ArrayList(Diagnostic),

    fn parseExpression(self: *Parser) !Node {
        // Recoverable error — accumulate diagnostic, continue parsing
        if (self.current().tag != .lparen) {
            self.diagnostics.append(.{
                .message = "Expected '(' after function name",
                .span = self.current().span(),
                .severity = .@"error",
            });
            // Error recovery: skip to next synchronization point
            self.synchronize();
            return self.makeErrorNode();
        }
        // ...
    }
};
```

### 5. No Rayon-Style Parallel Iterators

**Risk**: More boilerplate for parallel file processing.

**Mitigation**: File-level parallelism is simple — spawn one task per file into `std.Thread.Pool`. The linter doesn't need fine-grained data parallelism within a file. A channel pattern (producer thread discovers files, worker threads lint them) requires ~30 lines of code vs 1 line with Rayon, but the performance is equivalent.

### 6. Pattern Matching Ergonomics

**Risk**: Nested destructuring (`match expr { BinaryOp { left: Literal(n), .. } => ... }`) requires chained `if`/`switch` in Zig.

**Mitigation**: Since AST nodes are stored as flat indices with tags, most rule logic is simple tag checks:

```zig
// Zig — flat tag check
if (node.tag == .debugger_stmt) { ... }

// Equivalent to Rust:
// if let AstKind::DebuggerStatement(_) = node.kind() { ... }
```

For rules needing deeper matching, helper functions abstract the pattern:

```zig
fn isMemberExpression(ast: *const Ast, node: Index, object: []const u8, property: []const u8) bool {
    const n = ast.nodes.get(node);
    if (n.tag != .member_expr) return false;
    const obj = ast.nodes.get(n.lhs);
    const prop = ast.nodes.get(n.rhs);
    return obj.tag == .identifier and
           ast.tokenText(obj.main_token).eql(object) and
           prop.tag == .identifier and
           ast.tokenText(prop.main_token).eql(property);
}

// Usage in a rule:
if (isMemberExpression(ast, node, "console", "log")) { ... }
```

## Platform: macOS-Only Target

iOS/mobile development happens on macOS. Sx3lint targets macOS exclusively.

**macOS APIs used:**
| Need | macOS API | Notes |
|---|---|---|
| File watching | `kqueue` + `EVFILT_VNODE` | Watch mode for re-linting on save |
| File reading | `mmap` (POSIX) | Memory-map large source files instead of reading into buffer |
| Thread pool | `std.Thread.Pool` | Portable, uses pthreads on macOS |
| Output | `stdout` with block buffering | Avoid lock contention in parallel output |

**Not needed:**
- `io_uring` — kqueue covers our needs
- `inotify` — kqueue's `EVFILT_VNODE` is the macOS equivalent

## Performance Targets

| Metric | ESLint | Oxlint (Rust) | Sx3lint (Target) |
|---|---|---|---|
| VSCode codebase lint | ~20s | ~100ms | ~100ms (parity) |
| Parse time vs SWC | baseline | 3x faster | 3-4x faster (MultiArrayList advantage) |
| Memory per file | high (V8 heap) | low (arena) | lower (MultiArrayList eliminates padding) |
| Rule dispatch overhead | AST visitor + JS calls | trait dispatch | zero (comptime inline) |
| SIMD usage | none | nightly/platform-specific | stable, first-class `@Vector` |
| Incremental recompile | N/A | ~minutes (Rust) | sub-second (Zig) |

The honest target is **parity with Oxlint** on linting speed, with advantages in:
- **Memory efficiency** (MultiArrayList AST)
- **Compile-time iteration speed** (faster rebuilds when developing rules)
- **SIMD ergonomics** (stable, portable)
- **Simpler codebase** (no lifetime annotations, no borrow checker workarounds)

## ESLint Rule Compatibility Strategy

Phase 1: Implement the most impactful rules first, matching Oxlint's categories:

```
Category         Priority   Example Rules
─────────────────────────────────────────────────────────
correctness      P0         no-debugger, no-unused-vars, no-undef,
                            no-constant-condition, no-dupe-keys
suspicious       P1         no-shadow, no-fallthrough, eqeqeq
style            P2         no-var, prefer-const, no-nested-ternary
typescript       P3         no-explicit-any, no-non-null-assertion
react            P3         rules-of-hooks, no-direct-mutation-state
```

Phase 2: ESLint config compatibility — read `.eslintrc` / `eslint.config.js` and map known rules to Sx3lint equivalents.

Phase 3: Plugin system — comptime-loaded rule modules that conform to the rule interface.

## Project Structure

```
sx3lint/
├── build.zig
├── src/
│   ├── main.zig              # CLI entry point
│   ├── lexer.zig             # SIMD-accelerated tokenizer
│   ├── parser.zig            # Recursive descent parser
│   ├── ast.zig               # Node tags, MultiArrayList storage
│   ├── semantic.zig          # Scope tree, symbol table (SoA)
│   ├── linter.zig            # Rule dispatch, comptime visitor
│   ├── diagnostic.zig        # Error/warning reporting
│   ├── parallel.zig          # File discovery + thread pool
│   └── rules/
│       ├── correctness/
│       │   ├── no_debugger.zig
│       │   ├── no_unused_vars.zig
│       │   └── ...
│       ├── suspicious/
│       ├── style/
│       ├── typescript/
│       └── react/
├── tests/
│   ├── parser_test.zig
│   ├── linter_test.zig
│   └── fixtures/             # test262 + real-world JS/TS files
└── bench/
    ├── bench_parser.zig
    └── bench_linter.zig
```

## Milestones

### v0.1 — Parser Foundation
- Lexer with SIMD whitespace/comment skipping
- Recursive descent parser for ES2024 subset (expressions, statements, functions, classes)
- MultiArrayList AST storage
- Benchmark against Oxc parser on real-world files
- Test against test262 parser tests (target: 95%+ pass rate)

### v0.2 — Semantic Analysis
- Scope tree construction
- Symbol table (struct-of-arrays)
- Reference resolution
- Identifier binding (BindingIdentifier vs IdentifierReference distinction)

### v0.3 — Linter Core + 20 Rules
- comptime rule dispatch
- LintContext with scope/symbol access
- 20 correctness rules (no-debugger, no-unused-vars, no-undef, etc.)
- Diagnostic output (text + JSON formats)
- Benchmark against Oxlint

### v0.4 — Parallelism + 100 Rules
- std.Thread.Pool file-level parallelism
- File discovery with gitignore support
- Block-buffered diagnostic output
- 100 rules across correctness/suspicious/style categories

### v0.5 — TypeScript Support
- TypeScript syntax in parser (type annotations, generics, enums, interfaces)
- TypeScript-specific lint rules
- `.tsx` / JSX support

### v0.6 — Configuration
- `sx3lint.config.json` / `sx3lint.config.zig` configuration
- ESLint config compatibility layer (read `.eslintrc`, map rules)
- `// sx3lint-disable` inline comments
- Per-directory config inheritance

### v0.7 — JS Plugin Support (Zero-Copy Raw Transfer)
- `JsBufferAllocator` — parse AST into JS-owned `ArrayBuffer`
- comptime layout descriptor generation for all AST types
- JS-side lazy deserializer (DataView-based `NodeView` facades)
- ESLint-compatible plugin API (`create(context) → { NodeType(node) { ... } }`)
- Node-API (napi) native addon for Node.js integration
- Benchmark: JS plugin overhead vs Oxlint's raw transfer

### v1.0 — Production Ready
- 300+ rules
- test262 100% parser pass rate
- Benchmarks on real-world codebases (VSCode, Sentry, Next.js)
- Watch mode with kqueue
- CLI with `--fix` for auto-fixable rules
- Documentation site

## Acknowledgments

This project is directly inspired by and would not exist without:

- **[Oxc](https://github.com/oxc-project/oxc)** — Boshen Chen, @overlookmotel, and the Oxc team's architectural documentation, performance research, and open benchmarks form the foundation of Sx3lint's design. Their work on arena allocation, enum size optimization, SIMD lexing, SoA symbol tables, parallel linting architecture, and the raw transfer mechanism for zero-copy JS plugin support ([PR #9516](https://github.com/oxc-project/oxc/pull/9516)) informed every major decision in this document.
- **[Bun](https://github.com/oven-sh/bun)** — Jarred Sumner and the Bun team proved that a production-quality JS parser can be written in Zig. Bun's `js_parser.zig` and its MultiArrayList-based AST design are direct inspirations for Sx3lint's AST representation.
- **[Jam](https://github.com/srijan-paul/jam)** — Srijan Paul's work on a Zig JS parser/linter demonstrates the feasibility of this approach and provided early reference for Zig-specific patterns.
- **The Zig self-hosted compiler** — Andrew Kelley's MultiArrayList-based AST, which achieves 37.5% memory savings, is the canonical example of data-oriented AST design in Zig.

## Related Projects

- **Membrane** — Zero-copy cross-language bridge (sibling project)
- **Weave** — Comptime binding generator (sibling project)
- **Rush** — High-performance RN bundler (sibling project, could share parser)
- **Conductor** — Mobile build orchestrator (sibling project)
- **Silo** — Memory-mapped build cache (sibling project)
