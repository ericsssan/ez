//! Persistent type-query handle for the lazy type-aware JS bridge.
//!
//! A `TypeCtx` owns a full parse + semantic + checker for one source file in
//! its own arena, kept alive across calls so the JS `ts.Type` facade can query
//! node types on demand (the lazy transport — vs eager whole-file
//! serialization).  The JS side `ez_type_open`s a handle, issues
//! getTypeAtLocation-style queries, then `ez_type_close`s it.
//!
//! These are bun:ffi entry points: C ABI, primitive args only.  TypeIds and
//! node indices cross as plain u32; the JS facade maps `ts.TypeFlags` from
//! `ez_type_flags` and walks structure via the accessor calls.  String-valued
//! data (prop / ref names) is added in a later phase via a caller buffer.

const std = @import("std");
const parser = @import("es_parser");
const Ast = parser.ast.Ast;
const Lexer = parser.Lexer;
const Parser = parser.Parser;
const semantic = parser.semantic;
const parent_builder = parser.parent_builder;
const Language = parser.token.Language;
const checker_mod = @import("../checker/root.zig");
const tymod = checker_mod.types;
const Checker = checker_mod.Checker;

const NO_TYPE: u32 = 0xFFFFFFFF;

/// One resident parse+sem+checker, arena-owned.  Close frees the whole arena
/// in one shot (the checker allocates through the arena, so no separate
/// `Checker.deinit` is needed).
const TypeCtx = struct {
    arena: std.heap.ArenaAllocator,
    ast: Ast,
    sem: semantic.SemanticResult,
    checker: Checker,
};

/// Handle registry.  FFI handles are *indices* (slot+1, so 0 = invalid) into a
/// mutex-guarded slot table — never raw pointers, so a garbage or stale handle
/// from JS is bounds-checked to null instead of dereferenced.  Slots are reused
/// after close.
var g_mutex: std.atomic.Mutex = .unlocked;
var g_handles: std.ArrayListUnmanaged(?*TypeCtx) = .empty;

// ── Parse reuse (kill the facade double-parse) ─────────────────────────────
//
// `napi.parseImpl` stashes the just-built `tree`+`sem` here (cheap struct
// copies) after every non-streaming parse, so the type facade can build a
// checker over the RUNNER's parse instead of re-parsing the file.  The stash's
// arrays live in the JS buffer (tree) and `tl_sem_arena` (sem) — both valid
// only until the next parse on this thread, so a reuse handle MUST be closed
// before the next parse (the JS runner closes it after the file's lint walk).
// `ez_type_tag_last` stamps a JS-assigned generation; the facade passes it back
// to `ez_type_open_reuse`, which only reuses on an exact generation match — so
// a stale stash (shared buffer, LSP recheck, interleaving) falls back to a
// re-parse instead of returning the wrong file's types.
threadlocal var tl_last_ast: ?Ast = null;
threadlocal var tl_last_sem: ?semantic.SemanticResult = null;
threadlocal var tl_tagged_gen: u32 = 0;

/// Stash the latest parse for reuse.  Called by napi.parseImpl with the live
/// `tree` (after `tree.parents` is set) and `sem`.  Copies the structs; their
/// backing arrays are NOT copied (they stay in the buffer / sem arena).
pub fn stashLastParse(ast: *const Ast, sem: *const semantic.SemanticResult) void {
    tl_last_ast = ast.*;
    tl_last_sem = sem.*;
}

/// JS stamps the generation of the parse it just completed; the facade passes
/// the same value to `ez_type_open_reuse`. Stash + tag happen together per
/// parse (with no intervening parse before the lint), so a matching generation
/// means `tl_last_*` is exactly that parse.
pub export fn ez_type_tag_last(gen: u32) callconv(.c) void {
    tl_tagged_gen = gen;
}

fn lockG() void {
    while (!g_mutex.tryLock()) std.atomic.spinLoopHint();
}
fn unlockG() void {
    g_mutex.unlock();
}

fn ctxFrom(h: usize) ?*TypeCtx {
    if (h == 0) return null;
    lockG();
    defer unlockG();
    const idx = h - 1;
    if (idx >= g_handles.items.len) return null;
    return g_handles.items[idx];
}

fn registerCtx(ctx: *TypeCtx) !usize {
    lockG();
    defer unlockG();
    for (g_handles.items, 0..) |slot, i| {
        if (slot == null) {
            g_handles.items[i] = ctx;
            return i + 1;
        }
    }
    try g_handles.append(std.heap.page_allocator, ctx);
    return g_handles.items.len;
}

fn openImpl(source_ptr: [*]const u8, source_len: u32, lang_val: u8, is_module: u8) !usize {
    const gpa = std.heap.page_allocator;
    const ctx = try gpa.create(TypeCtx);
    errdefer gpa.destroy(ctx);
    ctx.arena = std.heap.ArenaAllocator.init(gpa);
    errdefer ctx.arena.deinit();
    const a = ctx.arena.allocator();
    const lang: Language = @enumFromInt(lang_val);
    const mod = is_module != 0;

    const src = try a.dupe(u8, source_ptr[0..source_len]);
    var lex = try Lexer.tokenizeWithLanguage(a, src, lang);
    ctx.ast = try Parser.parseWithOptions(a, src, lex.tokens.slice(), .{
        .language = lang, .is_module = mod, .emit_events = true,
    });
    // The checker reads `ast.parents`; the lint pipeline populates it the same
    // way.  Set it before semantic so analyze just dups it.
    ctx.ast.parents = try parent_builder.buildParentsOnly(&ctx.ast, a);
    ctx.sem = try semantic.SemanticAnalyzer.analyzeWithOptions(a, &ctx.ast, .{
        .is_module = mod, .globals = &.{}, .build_parents = true,
    });
    ctx.checker = try Checker.init(a, &ctx.ast, &ctx.sem);
    return registerCtx(ctx);
}

/// Open a type-query handle for `source`.  Returns a handle (>=1) or 0 on
/// failure.  `lang_val` matches `token.Language`; `is_module` toggles module
/// scope.  Caller must `ez_type_close`.
pub export fn ez_type_open(source_ptr: [*]const u8, source_len: u32, lang_val: u8, is_module: u8) callconv(.c) usize {
    return openImpl(source_ptr, source_len, lang_val, is_module) catch 0;
}

fn openReuseImpl(gen: u32) !usize {
    // Reuse only the exact parse JS tagged with this generation. The stash is
    // overwritten every parse, so a mismatch means it's stale → return 0 and
    // let JS fall back to a fresh parse (ez_type_open).
    if (tl_last_ast == null or gen == 0 or tl_tagged_gen != gen) return 0;
    const gpa = std.heap.page_allocator;
    const ctx = try gpa.create(TypeCtx);
    errdefer gpa.destroy(ctx);
    ctx.arena = std.heap.ArenaAllocator.init(gpa);
    errdefer ctx.arena.deinit();
    // Struct copies — the backing arrays stay in the JS buffer (ast) and sem
    // arena (sem); the checker only allocates through ctx.arena.
    ctx.ast = tl_last_ast.?;
    ctx.sem = tl_last_sem.?;
    ctx.checker = try Checker.init(ctx.arena.allocator(), &ctx.ast, &ctx.sem);
    return registerCtx(ctx);
}

/// Open a type-query handle that REUSES the runner's just-completed parse
/// (tagged with `gen`), avoiding a second parse.  Returns 0 if the tagged parse
/// isn't available (caller re-parses via `ez_type_open`).  The handle is only
/// valid until the next parse on this thread, so it must be closed before then.
pub export fn ez_type_open_reuse(gen: u32) callconv(.c) usize {
    return openReuseImpl(gen) catch 0;
}

pub export fn ez_type_close(h: usize) callconv(.c) void {
    if (h == 0) return;
    lockG();
    const idx = h - 1;
    if (idx >= g_handles.items.len) {
        unlockG();
        return;
    }
    const ctx = g_handles.items[idx];
    g_handles.items[idx] = null;
    unlockG();
    if (ctx) |c| {
        c.arena.deinit();
        std.heap.page_allocator.destroy(c);
    }
}

/// Number of AST nodes in the handle's parse (0 on bad handle).  Lets the JS
/// side bound node-index queries.
pub export fn ez_type_node_count(h: usize) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    return @intCast(ctx.ast.nodes.len);
}

/// TypeId of the expression at AST node `node_idx` (0xFFFFFFFF on bad handle or
/// out-of-range node).
pub export fn ez_type_of_node(h: usize, node_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (node_idx >= ctx.ast.nodes.len) return NO_TYPE;
    return ctx.checker.typeOf(@enumFromInt(node_idx)).toInt();
}

/// `TypeKind` (u8) behind a TypeId (0xFF on bad handle/type).
pub export fn ez_type_kind(h: usize, type_id: u32) callconv(.c) u8 {
    const ctx = ctxFrom(h) orelse return 0xFF;
    if (type_id >= ctx.checker.store.types.items.len) return 0xFF;
    return @intFromEnum(ctx.checker.store.types.items[type_id].kind);
}

/// `ts.TypeFlags` bitmask for a TypeId (0 on bad handle/type) — what the
/// type-aware rules classify on via `isTypeFlagSet`.
pub export fn ez_type_flags(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    return tymod.tsTypeFlags(ctx.checker.store.types.items[type_id].kind);
}

/// Element TypeId of an array/readonly-array/tuple-first / single-member
/// composite, else 0xFFFFFFFF.  (Phase-1 structural accessor; union/object
/// walks come next.)
pub export fn ez_type_array_elem(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const t = &ctx.checker.store.types.items[type_id];
    switch (t.kind) {
        .array_t, .readonly_array_t => {
            const ids = ctx.checker.store.idsOf(t.list_data);
            if (ids.len == 0) return NO_TYPE;
            return ids[0].toInt();
        },
        else => return NO_TYPE,
    }
}

/// Number of members of a union/intersection TypeId (0 otherwise).
pub export fn ez_type_member_count(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const t = &ctx.checker.store.types.items[type_id];
    return switch (t.kind) {
        .union_t, .intersection_t => t.list_data.len(),
        else => 0,
    };
}

/// `i`-th member TypeId of a union/intersection (0xFFFFFFFF if out of range).
pub export fn ez_type_member_at(h: usize, type_id: u32, i: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const t = &ctx.checker.store.types.items[type_id];
    switch (t.kind) {
        .union_t, .intersection_t => {
            const ids = ctx.checker.store.idsOf(t.list_data);
            if (i >= ids.len) return NO_TYPE;
            return ids[i].toInt();
        },
        else => return NO_TYPE,
    }
}

// ── Tests ─────────────────────────────────────────────────────────────────

test "type_ffi: open → typeOf → kind/flags → close" {
    const src = "const x = 42; const s = 'hi'; const arr: number[] = [];";
    const h = ez_type_open(src.ptr, @intCast(src.len), @intFromEnum(Language.ts), 1);
    try std.testing.expect(h != 0);
    defer ez_type_close(h);

    const ctx = ctxFrom(h).?;
    const tags = ctx.ast.nodes.items(.tag);
    var saw_num = false;
    var saw_str = false;
    for (tags, 0..) |tag, i| {
        if (tag == .number_literal) {
            const tid = ez_type_of_node(h, @intCast(i));
            try std.testing.expect(tid != NO_TYPE);
            try std.testing.expectEqual(@intFromEnum(tymod.TypeKind.number_literal), ez_type_kind(h, tid));
            try std.testing.expectEqual(@as(u32, 256), ez_type_flags(h, tid)); // NumberLiteral
            saw_num = true;
        }
        if (tag == .string_literal) {
            const tid = ez_type_of_node(h, @intCast(i));
            try std.testing.expectEqual(@as(u32, 128), ez_type_flags(h, tid)); // StringLiteral
            saw_str = true;
        }
    }
    try std.testing.expect(saw_num);
    try std.testing.expect(saw_str);
}

test "type_ffi: bad handle is safe" {
    try std.testing.expectEqual(@as(u32, NO_TYPE), ez_type_of_node(0, 0));
    try std.testing.expectEqual(@as(u8, 0xFF), ez_type_kind(12345, 0));
    ez_type_close(0); // no crash
}
