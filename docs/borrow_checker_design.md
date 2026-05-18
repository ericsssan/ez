# Ez Escape Analyzer — Design

**Status:** week-1 draft.  Goal: define the architecture concretely enough to start implementing in week 2.

**One-line summary:** a Zig source escape analyzer + region-inference checker for our codebase, hosted in two layers (zlinter custom rules for annotation hygiene, a standalone tool for the dataflow analysis itself).

**Why we're building this:** see `memory/project_bun_left_zig.md`.  Bun left Zig over memory-safety pain at million-line scale.  We're 42k LOC with disciplined arena patterns; we don't have Bun's bug profile, but we can shore up the design-time guarantees we already follow informally so they're enforced at build time too — without porting to Rust.

## Invariants we want to enforce

| # | Invariant | Bug shape it prevents |
|---|---|---|
| 1 | A `NodeIndex` extracted from `Ast` A must only flow back into A | Using a node from one parse against another's AST |
| 2 | A slice borrowed from an `Ast`'s source buffer must not outlive that `Ast` | Use-after-free on `tokenText()` results once the parse arena is dropped |
| 3 | A pointer into the worker-thread bump partition must not be read by the main thread before the join point | Race in streaming-sem worker |
| 4 | A `ScopeId` / `SymbolId` from analysis pass N must not be used by pass M (M ≠ N) | Identity drift after passes that reorder/rewrite |
| 5 | After parse completion, the `Ast` is read-only — any mutating method invalidates derived data (parent_indices, tag CSRs) | Stale derived caches |

Anything else is out of scope for v1.  New invariants only when we have a real bug class to point at.

## Why escape analysis, not borrow checking

Our problem is **region/lifetime**, not **ownership/mutability**.  We have:
- No move semantics (arenas bulk-allocate, bulk-free)
- No `&mut` exclusivity (Ast is read-only after parse; we don't model mutation)
- No linear resources (everything is heap-or-arena-allocated, no destructor obligations)

What we *do* have:
- Region/arena lifetime tracking — does this slice outlive its arena?
- Tag identity — does this NodeIndex belong to the Ast we're passing it to?
- Thread/effect tracking — does this worker-bump-pointer flow into the main thread before join?

These are **escape analysis / region inference** problems.  Move's borrow checker, Rust's lifetimes, Polonius — all designed primarily for `&mut` exclusivity and linear-resource consumption.  We'd be using them for half their machinery and ignoring the other half.

Closer prior art:
- **Cyclone** (Cornell, ~2002) — safe C dialect with first-class regions.  Every allocation tagged with a region; pointers carry region info in their type (`int @region('r)`); compiler verifies `'r`-pointers don't outlive region `'r`.  Designed for our exact problem shape.
- **Escape analysis** (Choi/Gupta/Serrano 1999, used in HotSpot JVM, Go compiler) — the canonical compiler technique for "does this value escape its scope?"
- **Tofte–Talpin region inference** (1997) — academic foundation for both Cyclone and Rust lifetimes.

Move's bytecode verifier is still a useful reference for the *engineering* of abstract interpretation (worklist, join, fixed point), but its borrow-graph machinery is over-engineered for our domain.

## Two-layer architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Layer 1: zlinter custom rules (AST patterns)              │
│  - Enforce annotation presence on public APIs               │
│  - Enforce annotation consistency (no contradictions)       │
│  - Flag obvious anti-patterns                               │
│  - Output: standard zlinter LintProblems                    │
│  Runs as part of build.zig, IDE-integrated via zlinter ext  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼ (annotations guaranteed present)
┌─────────────────────────────────────────────────────────────┐
│  Layer 2: standalone escape analyzer (CFG + dataflow)      │
│  - Walks our binary AST buffer (post-parse)                 │
│  - Reads function annotations enforced by Layer 1           │
│  - Builds CFG, runs fixed-point escape analysis             │
│  - Reports violations of the 5 invariants                   │
│  Runs as: zig build borrow-check                            │
└─────────────────────────────────────────────────────────────┘
```

Layer 1 keeps the analysis-required annotations from rotting.  Layer 2 does the actual safety check.

## Layer 1: zlinter rules for annotation hygiene

Zlinter is per-document AST pattern matching — perfect for "every public function returning `[]const u8` from a `*const Ast` parameter must have `// @returns borrowed_from(<param>)`."  Mismatch is a syntactic pattern; zlinter catches it natively.

Rules we'd write (~5–10 total, ~50–100 LOC each):

| Rule ID | What it enforces |
|---|---|
| `ez/require-borrowed-from` | Public fn returning `[]const u8` / `*const T` from a borrowed param requires `// @returns borrowed_from(<param>)` |
| `ez/require-node-index-origin` | Public fn taking `NodeIndex` requires `// @takes node_index_of(<ast>)` or `// @takes node_index_any` |
| `ez/require-arena-kill-tag` | Calls to `ArenaAllocator.deinit()` require nearby `// @kills_arena(<name>)` comment |
| `ez/require-thread-join-tag` | `std.Thread.join()` calls require `// @thread_join` |
| `ez/no-contradicting-origin` | Function can't be both `// @returns owned` and return a borrowed-shape type |
| `ez/annotation-points-to-param` | The name inside `borrowed_from(X)` must match an actual parameter name |

### Sketch: `ez/require-borrowed-from` rule

Hypothetical `tools/zlinter/rules/require_borrowed_from.zig` (interface inferred from zlinter's `integration_tests/src/no_cats.zig`; **not yet verified against zlinter's current API**):

```zig
//! Enforce that any public function returning a borrowed-shape type
//! (`[]const u8`, `[]const T`, `*const T`, `*T`) from a borrowed
//! parameter (`*const Ast`, `*Ast`, `*const LintContext`, etc.) carries
//! a `// @returns borrowed_from(<param>)` doc comment.
//!
//! Without this annotation, Layer 2's escape analyzer can't determine
//! the return value's lifetime origin and falls back to "no constraint"
//! — which silently disables checking for that path.

const std = @import("std");
const zlinter = @import("zlinter");

pub const Config = struct {
    severity: zlinter.rules.LintProblemSeverity = .err,
    /// Type names whose pointer/slice forms count as "borrowed-shape sources".
    /// Functions taking these as `*const T` are subject to the rule.
    /// Override via build.zig if your project has different ownership wrappers.
    borrowed_source_types: []const []const u8 = &.{
        "Ast",
        "LintContext",
        "Source",
        "ArenaAllocator",
    },
};

pub fn buildRule(opts: zlinter.rules.LintRuleConfig) zlinter.rules.LintRule {
    return .{
        .rule_id = "ez/require-borrowed-from",
        .run = &run,
        .config = opts,
    };
}

fn run(
    rule: zlinter.rules.LintRule,
    _: *zlinter.session.LintContext,
    doc: *const zlinter.session.LintDocument,
    gpa: std.mem.Allocator,
    _: zlinter.rules.RunOptions,
) zlinter.rules.RunError!?zlinter.results.LintResult {
    const cfg = rule.config.cast(Config);
    const tree = &doc.handle.tree;

    var problems: std.ArrayListUnmanaged(zlinter.results.LintProblem) = .empty;
    defer problems.deinit(gpa);

    // Walk every top-level decl looking for fn_proto / fn_decl.
    for (tree.rootDecls()) |decl_idx| {
        const tag = tree.nodeTag(decl_idx);
        const is_fn = switch (tag) {
            .fn_decl, .fn_proto, .fn_proto_one, .fn_proto_simple, .fn_proto_multi => true,
            else => false,
        };
        if (!is_fn) continue;
        try checkFn(tree, decl_idx, cfg, &problems, gpa);
    }

    if (problems.items.len == 0) return null;
    return .{ .problems = try problems.toOwnedSlice(gpa) };
}

fn checkFn(
    tree: *const std.zig.Ast,
    fn_node: std.zig.Ast.Node.Index,
    cfg: Config,
    problems: *std.ArrayListUnmanaged(zlinter.results.LintProblem),
    gpa: std.mem.Allocator,
) !void {
    // 1) Is this function public? (look for `pub` token before the fn keyword)
    if (!isPublic(tree, fn_node)) return;

    // 2) Extract the return type. If not a borrowed-shape type, nothing to enforce.
    const ret_kind = classifyReturnType(tree, fn_node) orelse return;
    if (ret_kind == .not_borrowed) return;

    // 3) Find params that are borrowed-source types.
    //    If none, the return value can't be borrowed-from-param — skip.
    const borrowed_params = collectBorrowedParams(tree, fn_node, cfg.borrowed_source_types, gpa) catch return;
    defer gpa.free(borrowed_params);
    if (borrowed_params.len == 0) return;

    // 4) Inspect the doc comment immediately before the fn for `@returns`.
    const annotation = parseReturnsAnnotation(tree, fn_node);

    switch (annotation) {
        .borrowed_from => |param_name| {
            // Verify the named param exists.
            var found = false;
            for (borrowed_params) |bp| {
                if (std.mem.eql(u8, bp.name, param_name)) { found = true; break; }
            }
            if (!found) {
                try report(problems, gpa, tree, fn_node,
                    "borrowed_from(\"{s}\") names a parameter that doesn't exist or isn't a borrowed-source type",
                    .{param_name});
            }
        },
        .owned => {
            try report(problems, gpa, tree, fn_node,
                "fn returns a borrowed-shape type but is annotated @returns owned — annotation contradicts signature",
                .{});
        },
        .missing => {
            try report(problems, gpa, tree, fn_node,
                "fn returns a borrowed-shape type from a borrowed-source parameter; add `/// @returns borrowed_from(<param>)`",
                .{});
        },
    }
}

const ReturnKind = enum { not_borrowed, slice_borrowed, pointer_borrowed };

fn classifyReturnType(tree: *const std.zig.Ast, fn_node: std.zig.Ast.Node.Index) ?ReturnKind {
    // Use tree.fullFnProto to extract return-type node, then walk it:
    //   []const u8 / []const T  → .slice_borrowed
    //   *const T / *T           → .pointer_borrowed
    //   <value type>            → .not_borrowed
    //   ?T / !T                 → recurse into payload
    _ = tree; _ = fn_node;
    return null; // sketch — implementation TODO
}

const BorrowedParam = struct { name: []const u8, type_name: []const u8 };

fn collectBorrowedParams(
    tree: *const std.zig.Ast,
    fn_node: std.zig.Ast.Node.Index,
    source_types: []const []const u8,
    gpa: std.mem.Allocator,
) ![]BorrowedParam {
    // Walk fn_proto params. For each `name: *const T` or `name: *T`, check
    // if `T` is in source_types. Collect matches.
    _ = tree; _ = fn_node; _ = source_types;
    return gpa.alloc(BorrowedParam, 0);
}

const Annotation = union(enum) {
    missing,
    owned,
    borrowed_from: []const u8,
};

fn parseReturnsAnnotation(tree: *const std.zig.Ast, fn_node: std.zig.Ast.Node.Index) Annotation {
    // Scan doc comments preceding fn_node for `/// @returns borrowed_from(NAME)`
    // or `/// @returns owned`. Return the first match. Use tree.tokens to
    // walk backward from fn_node's first token through `.doc_comment` tokens.
    _ = tree; _ = fn_node;
    return .missing;
}

fn isPublic(tree: *const std.zig.Ast, fn_node: std.zig.Ast.Node.Index) bool {
    _ = tree; _ = fn_node;
    return true;
}

fn report(
    problems: *std.ArrayListUnmanaged(zlinter.results.LintProblem),
    gpa: std.mem.Allocator,
    tree: *const std.zig.Ast,
    fn_node: std.zig.Ast.Node.Index,
    comptime fmt: []const u8,
    args: anytype,
) !void {
    const span = tree.nodeSpan(fn_node); // approximate API
    const msg = try std.fmt.allocPrint(gpa, fmt, args);
    try problems.append(gpa, .{
        .rule_id = "ez/require-borrowed-from",
        .severity = .err,
        .start = span.start,
        .end = span.end,
        .message = msg,
    });
}
```

Wired into `build.zig` per zlinter's standard:

```zig
const zlinter = b.dependency("zlinter", .{});
const linter = zlinter.lintStep(b, .{});
linter.addRule(b, .{
    .custom = .{
        .name = "ez/require-borrowed-from",
        .path = "tools/zlinter/rules/require_borrowed_from.zig",
    },
}, .{});
```

What's left to verify before this compiles:
- The exact `LintRule.config` mechanism (the cast API isn't documented in their README)
- Whether `tree.nodeSpan` is the right span call or if we need to compose start/end ourselves
- Whether doc-comment scanning has helper functions on `std.zig.Ast` or we walk token tags manually

These are mechanical — discover when we write the first rule for real.

## Layer 2: standalone escape analyzer

### AbstractValue

```zig
pub const AbstractValue = union(enum) {
    /// No lifetime constraint (plain primitive, comptime const, etc.)
    plain,
    /// Borrowed from a particular arena. Use is invalid if the arena
    /// is no longer live at the use point.
    arena: ArenaId,
    /// NodeIndex tagged with the Ast it was extracted from. Use as an
    /// arg to an Ast method must match.
    node_index: AstId,
    /// ScopeId or SymbolId from a specific pass. Use in a different pass
    /// is invalid.
    pass_id: PassId,
    /// Composite — e.g. struct of borrows.
    composite: []const AbstractValue,
};
```

`ArenaId`, `AstId`, `PassId` are `u32` newtype wrappers minted at the function entry where the value originates.

### AbstractState

```zig
pub const AbstractState = struct {
    /// Each local's lifetime constraint at this program point.
    locals: std.AutoArrayHashMapUnmanaged(LocalId, AbstractValue),

    /// Which arenas are still live at this program point.
    /// Killed arenas remain mapped (with .dead) so we can report
    /// uses-after-kill with the kill location.
    arenas: std.AutoArrayHashMapUnmanaged(ArenaId, ArenaState),

    /// Thread context: main / worker / joined.
    /// Worker-arena borrows are unreadable from main until joined.
    thread: ThreadContext,
};

pub const ArenaState = struct { state: enum { live, dead }, killed_at: ?SourcePos };
pub const ThreadContext = enum { main, worker, joined };
```

**Note: no borrow graph.**  Each value carries its origin directly.  Use-validity is checked by looking up the origin in `arenas` (or the pass/ast table); no transitive borrow tracking needed.

### Transfer functions

| Operation | Transfer | Notes |
|---|---|---|
| Local decl | `locals[v] = .plain` initially | |
| Assignment | `locals[v] = rhs_origin` | Origin flows from RHS |
| Subscript `arr[a..b]` | inherit `arr`'s origin | |
| Address-of `&x` | new origin tied to enclosing arena | |
| Annotated call returning `borrowed_from(p)` | inherit `p`'s origin | from `// @returns` |
| Annotated call returning `owned` | `.plain` | |
| Call to `ArenaAllocator.deinit()` | mark arena `.dead` at this point | invariant #2 enforcement |
| Thread `join()` | switch `thread` from `.worker` → `.joined` | invariant #3 |
| Use of value `v` | check `v`'s origin is still live; else report | the actual safety check |
| Return `v` | check `v`'s origin outlives the caller scope | |

### Join (CFG merge)

```zig
fn join(self: *AbstractState, other: *const AbstractState) JoinResult {
    var changed = false;

    // Locals: per-variable join.  Same origin → keep.  Different → collapse
    // to .plain (conservative: lose origin info, fail-closed on next use).
    for (other.locals.keys(), other.locals.values()) |local, other_val| {
        const our_val = self.locals.get(local) orelse {
            try self.locals.put(local, other_val);
            changed = true;
            continue;
        };
        if (!our_val.eql(other_val)) {
            try self.locals.put(local, .plain);
            changed = true;
        }
    }

    // Arenas: dead-on-either-side wins (conservative).
    for (other.arenas.keys(), other.arenas.values()) |arena, other_state| {
        const our_state = self.arenas.get(arena) orelse continue;
        if (our_state.state == .live and other_state.state == .dead) {
            try self.arenas.put(arena, other_state);
            changed = true;
        }
    }

    // Thread mismatch: error.  CFG should never join across thread bounds.
    if (self.thread != other.thread) return error.thread_join_mismatch;

    return if (changed) .changed else .unchanged;
}
```

### Algorithm

Standard worklist fixed-point.  Same shape as Move's, same shape as Polonius's, same shape as any abstract interpretation:

```
for each function f:
    cfg = lower(f)
    states = {block_id → AbstractState}
    states[entry] = AbstractState.init()
    worklist = [entry]

    while worklist not empty:
        block = worklist.pop()
        state = states[block].clone()
        for each stmt in block:
            state = transfer(stmt, state) or report_error
        for each successor s:
            joined, result = join(states[s], state)
            states[s] = joined
            if result == .changed:
                worklist.push(s)
```

## Annotations spec

```zig
/// @origin self.arena
/// or
/// @returns borrowed_from(self)
pub fn tokenText(self: *const Ast, tok: TokenIdx) []const u8 { ... }

/// @returns owned
pub fn nodeSpan(self: *const Ast, n: NodeIndex) Span { ... }

/// @takes node_index_of(self)
pub fn nodeData(self: *const Ast, n: NodeIndex) Node.Data { ... }

/// @kills_arena(self.arena)
pub fn deinit(self: *Arena) void { ... }

/// @thread_join(self)
pub fn join(self: *Thread) void { ... }

/// @pass(name = "scope_resolve")
pub fn runScopeResolve(ast: *Ast) ScopeTable { ... }
```

Unannotated functions are treated conservatively — return `.plain`, take any value.  False positives possible (over-conservative inference), no false negatives.

## Implementation plan

### Phase 1: Layer 1 + annotations (2 weeks)
- Week 1: write 5 zlinter custom rules, wire into `build.zig`, integration tests
- Week 2: annotate the ~85 lifetime-bearing helpers in our codebase, fix anything Layer 1 catches

### Phase 2: Layer 2 skeleton (2 weeks)
- Week 3: `src/borrow_check/cfg.zig` (Zig AST → CFG; reuse ideas from `src/parser/code_path.zig`), `src/borrow_check/abstract_state.zig`
- Week 4: transfer functions for the common ops, annotations parser

### Phase 3: First invariant end-to-end (1 week)
- Week 5: invariant #2 (slice outlives arena) on `src/linter/lint_context.zig`.  Inject synthetic bug, verify catch.  Run on real codebase.

### Decision point (week 5)
- Real bugs found OR known bug classes pre-empted → continue with #1, #3, #4, #5
- No findings + checker is precise → architecture wins (good outcome)
- No findings + checker is over-conservative → tighten or kill

### Phase 4: scale + CI (2 weeks)
- Implement remaining invariants
- Wire to CI
- Error-mapping polish (source spans with notes)

**Total: ~7 weeks to "finds bugs in CI, complete coverage of 5 invariants."**

## Alternatives considered

- **Move-style borrow checker with full BorrowGraph + linear types.** Rejected: Move's machinery exists for `&mut` exclusivity and linear-resource consumption.  Our domain has neither.  Using Move's design would be ~5–10k LOC for a problem that's 2–3k LOC as escape analysis.

- **Surface-Rust shadow + `cargo check`.** Rejected: impedance mismatch with Zig's `defer`/`errdefer`/`comptime`/anonymous unions; lossy round-trip; ongoing Rust toolchain dependency.  Wins nothing over self-hosted escape analysis since our patterns are simpler than Rust's lifetime model anyway.

- **Polonius (Rust borrow-checker as a crate).** Rejected: research crate evolving with rustc; API churn; full lifetime/origin model is overkill for our patterns; couples us to Rust toolchain.

- **MIR / direct datalog facts.** Rejected: MIR is an unstable internal interface; generating MIR directly is much harder than escape analysis; Polonius's algorithm is more complex than what we need.

- **Host the analyzer in zlinter.** Rejected: zlinter is per-document AST patterns by design.  Our analysis is cross-function dataflow.  We'd build the entire analyzer inside a zlinter `run()` callback and gain nothing while coupling to zlinter's API and ZLS dependency.  **However** — Layer 1 (annotation hygiene rules) is exactly zlinter's wheelhouse, hence the two-layer architecture.

- **Just rely on arenas + ASan + fuzzing.** Already do all three; complementary, not substitutes.  ASan catches at runtime when exercised; this catches at build time on all paths.

## Why not port to Rust instead

See `memory/project_bun_left_zig.md` for the full argument.  Summary: Bun ported because they have ~1M LOC of long-lived stateful memory and the memory-bug debugging tax was crushing.  We have 42k LOC of arena-per-parse with disciplined patterns.  The bug-per-LOC math that pushed Bun over the edge doesn't bind us.  An escape analyzer gives us most of what Rust's borrow checker would, at a fraction of the cost and with no toolchain rewrite.

## References

- **Cyclone**: Greg Morrisett et al., "Region-based memory management in Cyclone" (PLDI 2002)
- **Tofte–Talpin region inference**: Mads Tofte & Jean-Pierre Talpin, "Region-based memory management" (Information and Computation, 1997)
- **HotSpot escape analysis**: Choi et al., "Escape Analysis for Java" (OOPSLA 1999)
- **Move bytecode verifier**: `aptos-labs/aptos-core` → `third_party/move/move-bytecode-verifier/src/reference_safety/` — algorithmic engineering reference for abstract interpretation
- **zlinter**: `KurtWagner/zlinter` — Layer 1 host
- **Our `src/parser/code_path.zig`** — prior art for fixed-point CFG analysis in this codebase
