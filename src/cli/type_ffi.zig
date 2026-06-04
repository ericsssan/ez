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

/// Invalidate any prior reuse stash on this thread.  Called by napi.parseImpl
/// at the start of a reuse-eligible parse: if that parse returns early (error /
/// unsupported path) without reaching `stashLastParse`, a later `openReuse`
/// must fall back to re-parsing rather than returning the previous file's stash.
pub fn invalidateReuseStash() void {
    tl_last_ast = null;
}

/// Stash the latest parse for reuse.  Called by napi.parseImpl with the live
/// `tree` (after `tree.parents` is set) and `sem`.  Zero-copy: the AST/sem
/// structs are shallow-copied and their backing arrays — including the token
/// starts, which parseImpl keeps in BYTE form (the UTF-16 conversion writes a
/// separate array for the JS side) so the checker can index the byte source —
/// stay in the shared buffer / sem arena, valid until the next parse reuses the
/// buffer.  The generation guard (`tl_tagged_gen`) rejects a stale stash.
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

// ── Call signatures ─────────────────────────────────────────────────────────
//
// A function/object type carries zero or more call `Signature`s (params + a
// return type).  These back `type.getCallSignatures()` / `signature.getReturnType()`
// in the facade, which `getCallSignaturesOfType` (no-unsafe-return) and a
// resolved-signature shim (no-unsafe-argument) consume.

fn sigAt(ctx: *TypeCtx, type_id: u32, sig_idx: u32) ?*const tymod.Signature {
    if (type_id >= ctx.checker.store.types.items.len) return null;
    const sl = ctx.checker.store.types.items[type_id].signatures;
    if (sig_idx >= sl.len()) return null;
    return &ctx.checker.store.signature_pool.items[sl.start + sig_idx];
}

/// Number of call signatures on a type (0 on bad handle/type or non-callable).
pub export fn ez_type_sig_count(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    return ctx.checker.store.types.items[type_id].signatures.len();
}

/// Return-type TypeId of a signature (0xFFFFFFFF on out-of-range).
pub export fn ez_type_sig_return(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const s = sigAt(ctx, type_id, sig_idx) orelse return NO_TYPE;
    return s.return_type.toInt();
}

/// Parameter count of a signature (0 on out-of-range).
pub export fn ez_type_sig_param_count(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    const s = sigAt(ctx, type_id, sig_idx) orelse return 0;
    return s.params_end - s.params_start;
}

/// `param_idx`-th parameter TypeId of a signature (0xFFFFFFFF on out-of-range).
pub export fn ez_type_sig_param(h: usize, type_id: u32, sig_idx: u32, param_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const s = sigAt(ctx, type_id, sig_idx) orelse return NO_TYPE;
    if (param_idx >= s.params_end - s.params_start) return NO_TYPE;
    return ctx.checker.store.signature_param_pool.items[s.params_start + param_idx].toInt();
}

/// Signature flag bits: 1 = async, 2 = generator (0 on out-of-range).
pub export fn ez_type_sig_flags(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    const s = sigAt(ctx, type_id, sig_idx) orelse return 0;
    var f: u32 = 0;
    if (s.is_async) f |= 1;
    if (s.is_generator) f |= 2;
    if (s.is_construct) f |= 4;
    if (s.is_assertion) f |= 8;
    return f;
}

/// Zero-based parameter index narrowed by a `name is X` / `asserts name is X`
/// type-predicate signature, or 0xFFFF when the signature isn't a type guard.
/// Backs the facade's getTypePredicateOfSignature (strict-boolean-expressions,
/// no-unnecessary-condition assertion-function handling).
pub export fn ez_type_sig_predicate_param(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0xFFFF;
    const s = sigAt(ctx, type_id, sig_idx) orelse return 0xFFFF;
    return s.predicate_param_index;
}

/// The predicate target type (`X` in `name is X`), or 0xFFFFFFFF when the
/// signature isn't a type guard or the predicate has no type (`asserts name`).
pub export fn ez_type_sig_predicate_target(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const s = sigAt(ctx, type_id, sig_idx) orelse return NO_TYPE;
    if (s.predicate_param_index == 0xFFFF or s.predicate_target == .none) return NO_TYPE;
    return s.predicate_target.toInt();
}

/// Zero-based index of the signature's rest parameter (`...args`), or 0xFFFF if
/// it has none.  no-unsafe-argument needs this to unwrap the spread.
pub export fn ez_type_sig_rest_index(h: usize, type_id: u32, sig_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0xFFFF;
    const s = sigAt(ctx, type_id, sig_idx) orelse return 0xFFFF;
    return s.rest_param_index;
}

/// Resolve a TS type-annotation AST node (`{a:number}`, `Foo<T>`, `number`, …)
/// to its TypeId — the checker types VALUE nodes via ez_type_of_node, but a type
/// node (e.g. the asserted type in `x as T`) must be resolved as a TYPE.  Returns
/// 0xFFFFFFFF on a bad handle / out-of-range node.
pub export fn ez_type_resolve_type_node(h: usize, node_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (node_idx >= ctx.ast.nodes.len) return NO_TYPE;
    return ctx.checker.resolveTypeNode(@enumFromInt(node_idx)).toInt();
}

// Like ez_type_resolve_type_node, but a bare in-scope type parameter resolves
// to a genuine `.type_param` (carrying its constraint) rather than to the
// constraint. The facade uses this for asserted types (`x as T`).
pub export fn ez_type_resolve_type_node_param(h: usize, node_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (node_idx >= ctx.ast.nodes.len) return NO_TYPE;
    return ctx.checker.resolveTypeNodeParamAware(@enumFromInt(node_idx)).toInt();
}

// The `.type_param` for an identifier value declared with a bare in-scope
// type-parameter annotation (`a: T`), else NO_TYPE. Lets the facade match
// `a as T` as a safe identity. Pure query — stored value types are unchanged.
pub export fn ez_type_of_node_param(h: usize, node_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (node_idx >= ctx.ast.nodes.len) return NO_TYPE;
    const t = ctx.checker.valueTypeParam(@enumFromInt(node_idx)) orelse return NO_TYPE;
    return t.toInt();
}

/// Three-valued assignability source→target: 0 = no, 1 = yes, 2 = unknown
/// (depends on machinery we don't implement — objects, structural, generics).
/// Callers map `unknown` per their FP-safe direction.
pub export fn ez_type_assignable(h: usize, source: u32, target: u32) callconv(.c) u8 {
    const ctx = ctxFrom(h) orelse return 2;
    if (source >= ctx.checker.store.types.items.len or target >= ctx.checker.store.types.items.len) return 2;
    return switch (ctx.checker.structuralAssignablePub(@enumFromInt(source), @enumFromInt(target))) {
        .no => 0,
        .yes => 1,
        .unknown => 2,
    };
}

/// Instantiated type of parameter `param_idx` for the GENERIC call at AST node
/// `call_node_idx` — the checker infers the callee's type args from the argument
/// types (any-wins, rest-spreading) and substitutes them into the param
/// annotation.  Returns 0xFFFFFFFF when the call isn't a resolvable generic call
/// (caller falls back to the un-instantiated signature param type).
pub export fn ez_type_call_param_type(h: usize, call_node_idx: u32, param_idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (call_node_idx >= ctx.ast.nodes.len) return NO_TYPE;
    const t = ctx.checker.inferGenericParamType(@enumFromInt(call_node_idx), param_idx) orelse return NO_TYPE;
    return t.toInt();
}

// ── Object properties ───────────────────────────────────────────────────────
//
// Named members of an object/class type, backing `type.getProperty(name)` and
// the method/field distinction `unbound-method` needs.  By-name lookup only
// (no string-out iteration yet) — the target rules query specific names
// (`length`, `toString`, the accessed member).

fn findProp(ctx: *TypeCtx, type_id: u32, name: []const u8) ?*const tymod.ObjectProp {
    if (type_id >= ctx.checker.store.types.items.len) return null;
    const pl = ctx.checker.store.types.items[type_id].object_props;
    const props = ctx.checker.store.object_prop_pool.items[pl.start..pl.end];
    for (props) |*p| if (std.mem.eql(u8, p.name, name)) return p;
    return null;
}

/// Number of own named properties of a type (0 on bad handle/type).
pub export fn ez_type_prop_count(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    return ctx.checker.store.types.items[type_id].object_props.len();
}

/// TypeId of the property named `name_ptr[0..name_len]`, or 0xFFFFFFFF if the
/// type has no such property.
pub export fn ez_type_prop_type_by_name(h: usize, type_id: u32, name_ptr: [*]const u8, name_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const p = findProp(ctx, type_id, name_ptr[0..name_len]) orelse return NO_TYPE;
    return p.type_id.toInt();
}

/// Property flag bits for `name`: 1 = optional, 2 = readonly, 4 = is_method,
/// 8 = is_fn_property.  Returns 0xFFFFFFFF when the property is absent (so the
/// caller distinguishes "absent" from "present with no flags").
pub export fn ez_type_prop_flags_by_name(h: usize, type_id: u32, name_ptr: [*]const u8, name_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const p = findProp(ctx, type_id, name_ptr[0..name_len]) orelse return NO_TYPE;
    var f: u32 = 0;
    if (p.optional) f |= 1;
    if (p.readonly) f |= 2;
    if (p.is_method) f |= 4;
    if (p.is_fn_property) f |= 8;
    return f;
}

/// 1 when `type_id` is a natively-bound builtin global object (Math, JSON,
/// console) whose methods are safe to extract unbound — backs unbound-method's
/// isNativelyBound type-level check. 0 otherwise.
pub export fn ez_type_is_natively_bound(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    return if (ctx.checker.natively_bound_type_ids.contains(tymod.TypeId.fromInt(type_id))) 1 else 0;
}

/// Name of the `idx`-th property copied into `out` (truncated to out_len),
/// returning its byte length. Backs the facade's getProperties() enumeration
/// (no-unsafe-assignment's object-destructure walk reads every property name).
pub export fn ez_type_prop_name_at(h: usize, type_id: u32, idx: u32, out: [*]u8, out_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const pl = ctx.checker.store.types.items[type_id].object_props;
    const props = ctx.checker.store.object_prop_pool.items[pl.start..pl.end];
    if (idx >= props.len) return 0;
    const name = props[idx].name;
    const n = @min(name.len, out_len);
    @memcpy(out[0..n], name[0..n]);
    return @intCast(n);
}

/// TypeId of the `idx`-th property (0xFFFFFFFF if out of range).
pub export fn ez_type_prop_type_at(h: usize, type_id: u32, idx: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const pl = ctx.checker.store.types.items[type_id].object_props;
    const props = ctx.checker.store.object_prop_pool.items[pl.start..pl.end];
    if (idx >= props.len) return NO_TYPE;
    return props[idx].type_id.toInt();
}

// ── Type arguments + name (type references, e.g. Promise<T>) ────────────────
//
// A `type_ref` (Foo<A,B>) and array/tuple kinds keep their type arguments in
// list_data.  Backs getTypeArguments + getAwaitedType's Promise<T> unwrap in
// the facade (the checker wraps async returns as a `Promise` type_ref).

/// Number of type arguments of a type_ref/array/tuple (0 otherwise).
pub export fn ez_type_type_arg_count(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const t = &ctx.checker.store.types.items[type_id];
    return switch (t.kind) {
        .type_ref, .tuple_t, .array_t, .readonly_array_t => t.list_data.len(),
        else => 0,
    };
}

/// Constraint of a `.type_param` (its sole `list_data` slot), or 0xFFFFFFFF when
/// unconstrained / not a type parameter. Backs the facade's getConstraint().
pub export fn ez_type_constraint(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const t = &ctx.checker.store.types.items[type_id];
    if (t.kind != .type_param or t.list_data.len() == 0) return NO_TYPE;
    return ctx.checker.store.idsOf(t.list_data)[0].toInt();
}

/// String value of a string- or bigint-literal type (copied into `out`,
/// truncated), returning the byte length. 0 for other types. Backs the facade's
/// `.value` (string literal) / `.value.base10Value` (bigint literal).
pub export fn ez_type_lit_string(h: usize, type_id: u32, out: [*]u8, out_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const s: []const u8 = switch (ctx.checker.store.types.items[type_id].literal_value) {
        .string => |x| x,
        .bigint => |x| x,
        else => return 0,
    };
    const n = @min(s.len, out_len);
    @memcpy(out[0..n], s[0..n]);
    return @intCast(n);
}

/// Numeric value of a number-literal type (0 otherwise). Backs `.value`.
pub export fn ez_type_lit_number(h: usize, type_id: u32) callconv(.c) f64 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    return switch (ctx.checker.store.types.items[type_id].literal_value) {
        .number => |x| x,
        else => 0,
    };
}

/// Boolean value of a boolean-literal type: 1 = true, 0 = false, 0xFF = not a
/// boolean literal. Backs `.intrinsicName` ('true' / 'false').
pub export fn ez_type_lit_bool(h: usize, type_id: u32) callconv(.c) u8 {
    const ctx = ctxFrom(h) orelse return 0xFF;
    if (type_id >= ctx.checker.store.types.items.len) return 0xFF;
    return switch (ctx.checker.store.types.items[type_id].literal_value) {
        .boolean => |b| if (b) 1 else 0,
        else => 0xFF,
    };
}

/// Number of direct base types of an interface object_t (its `extends` clause,
/// stored in list_data); 0 otherwise. Backs the facade's getBaseTypes().
pub export fn ez_type_base_count(h: usize, type_id: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const t = &ctx.checker.store.types.items[type_id];
    return if (t.kind == .object_t) t.list_data.len() else 0;
}

/// `i`-th base type of an interface object_t (0xFFFFFFFF if out of range).
pub export fn ez_type_base_at(h: usize, type_id: u32, i: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const t = &ctx.checker.store.types.items[type_id];
    if (t.kind != .object_t) return NO_TYPE;
    const ids = ctx.checker.store.idsOf(t.list_data);
    if (i >= ids.len) return NO_TYPE;
    return ids[i].toInt();
}

/// `i`-th type argument TypeId (0xFFFFFFFF if out of range).
pub export fn ez_type_type_arg(h: usize, type_id: u32, i: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    if (type_id >= ctx.checker.store.types.items.len) return NO_TYPE;
    const t = &ctx.checker.store.types.items[type_id];
    switch (t.kind) {
        .type_ref, .tuple_t, .array_t, .readonly_array_t => {
            const ids = ctx.checker.store.idsOf(t.list_data);
            if (i >= ids.len) return NO_TYPE;
            return ids[i].toInt();
        },
        else => return NO_TYPE,
    }
}

/// 1 if the type's name equals `name_ptr[0..name_len]` (type_ref/type_param
/// names like "Promise"), else 0.
pub export fn ez_type_name_eq(h: usize, type_id: u32, name_ptr: [*]const u8, name_len: u32) callconv(.c) u8 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const t = &ctx.checker.store.types.items[type_id];
    return if (std.mem.eql(u8, t.name, name_ptr[0..name_len])) 1 else 0;
}

// Copy a type's name into `out` (truncated to out_len). Returns the byte length
// written. The facade keys one synthetic ts.TypeReference.target object per
// generic name so isUnsafeAssignment only recurses into type args of same-named
// references (Set<any> vs Set<number> share target; Set vs ReadonlySet differ).
pub export fn ez_type_ref_name(h: usize, type_id: u32, out: [*]u8, out_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const name = ctx.checker.store.types.items[type_id].name;
    const n = @min(name.len, out_len);
    @memcpy(out[0..n], name[0..n]);
    return @intCast(n);
}

/// The enum name this literal is a member of (`Fruit.Apple` → "Fruit"), or
/// length 0 when the type is not an enum member. Backs the facade's
/// EnumLiteral flag + EnumMember symbol synthesis (no-unsafe-enum-comparison).
pub export fn ez_type_enum_name(h: usize, type_id: u32, out: [*]u8, out_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const name = ctx.checker.store.types.items[type_id].enum_name;
    const n = @min(name.len, out_len);
    @memcpy(out[0..n], name[0..n]);
    return @intCast(n);
}

// Resolve a declared type NAME (user interface/class/alias/enum) to its TypeId,
// or 0xFFFFFFFF if not declared in-file. Lets the facade replace a base
// `type_ref` with the base's structural object_t (with ITS bases) so
// matchesTypeOrBaseType walks a multi-level `extends` chain. Returns NO_TYPE for
// lib types (Promise/etc — not user-declared) so those keep their type_ref form.
pub export fn ez_type_resolve_declared(h: usize, name_ptr: [*]const u8, name_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return NO_TYPE;
    const t = ctx.checker.resolveDeclaredTypePub(name_ptr[0..name_len]) orelse return NO_TYPE;
    return t.toInt();
}

// The type-alias name a type was resolved from (`type Foo = …` → "Foo"),
// independent of the structural name — facade ts.Type.aliasSymbol.
pub export fn ez_type_alias_name(h: usize, type_id: u32, out: [*]u8, out_len: u32) callconv(.c) u32 {
    const ctx = ctxFrom(h) orelse return 0;
    if (type_id >= ctx.checker.store.types.items.len) return 0;
    const name = ctx.checker.store.types.items[type_id].alias_name;
    const n = @min(name.len, out_len);
    @memcpy(out[0..n], name[0..n]);
    return @intCast(n);
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
            try std.testing.expectEqual(@as(u32, 2048), ez_type_flags(h, tid)); // NumberLiteral
            saw_num = true;
        }
        if (tag == .string_literal) {
            const tid = ez_type_of_node(h, @intCast(i));
            try std.testing.expectEqual(@as(u32, 1024), ez_type_flags(h, tid)); // StringLiteral
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

test "type_ffi: call signatures (params + return type)" {
    const src = "function add(a: number, b: number): string { return ''; }";
    const h = ez_type_open(src.ptr, @intCast(src.len), @intFromEnum(Language.ts), 1);
    try std.testing.expect(h != 0);
    defer ez_type_close(h);
    const ctx = ctxFrom(h).?;
    // Find the function type (the binding `add` carries it).
    var fn_tid: u32 = NO_TYPE;
    for (0..ctx.ast.nodes.len) |i| {
        const tid = ez_type_of_node(h, @intCast(i));
        if (tid != NO_TYPE and ez_type_sig_count(h, tid) > 0) { fn_tid = tid; break; }
    }
    try std.testing.expect(fn_tid != NO_TYPE);
    try std.testing.expectEqual(@as(u32, 1), ez_type_sig_count(h, fn_tid));
    try std.testing.expectEqual(@as(u32, 2), ez_type_sig_param_count(h, fn_tid, 0));
    // param 0 is number (flags 8), return is string (flags 4).
    try std.testing.expectEqual(@as(u32, 64), ez_type_flags(h, ez_type_sig_param(h, fn_tid, 0, 0)));
    try std.testing.expectEqual(@as(u32, 32), ez_type_flags(h, ez_type_sig_return(h, fn_tid, 0)));
}

test "type_ffi: object property by name" {
    const src = "const o = { count: 3, label: 'x' };";
    const h = ez_type_open(src.ptr, @intCast(src.len), @intFromEnum(Language.ts), 1);
    try std.testing.expect(h != 0);
    defer ez_type_close(h);
    const ctx = ctxFrom(h).?;
    var obj_tid: u32 = NO_TYPE;
    for (0..ctx.ast.nodes.len) |i| {
        const tid = ez_type_of_node(h, @intCast(i));
        if (tid != NO_TYPE and ez_type_prop_count(h, tid) >= 2) { obj_tid = tid; break; }
    }
    try std.testing.expect(obj_tid != NO_TYPE);
    const cnt = "count";
    const count_tid = ez_type_prop_type_by_name(h, obj_tid, cnt.ptr, cnt.len);
    try std.testing.expect(count_tid != NO_TYPE);
    const cf = ez_type_flags(h, count_tid); // number (64) or number-literal (2048)
    try std.testing.expect(cf == 64 or cf == 2048);
    const missing = "nope";
    try std.testing.expectEqual(@as(u32, NO_TYPE), ez_type_prop_type_by_name(h, obj_tid, missing.ptr, missing.len));
}

test "type_ffi: Promise<T> type ref (name + type arg)" {
    // Async returns are wrapped Promise<T> by the checker; the signature return
    // type of `async function f(): string` is Promise<string>.
    const src = "async function f(): string { return ''; }";
    const h = ez_type_open(src.ptr, @intCast(src.len), @intFromEnum(Language.ts), 1);
    try std.testing.expect(h != 0);
    defer ez_type_close(h);
    const ctx = ctxFrom(h).?;
    var fn_tid: u32 = NO_TYPE;
    for (0..ctx.ast.nodes.len) |i| {
        const tid = ez_type_of_node(h, @intCast(i));
        if (tid != NO_TYPE and ez_type_sig_count(h, tid) > 0) { fn_tid = tid; break; }
    }
    try std.testing.expect(fn_tid != NO_TYPE);
    const ret = ez_type_sig_return(h, fn_tid, 0);
    try std.testing.expect(ret != NO_TYPE);
    const promise = "Promise";
    try std.testing.expectEqual(@as(u8, 1), ez_type_name_eq(h, ret, promise.ptr, promise.len));
    try std.testing.expect(ez_type_type_arg_count(h, ret) >= 1);
    // The awaited type arg is string (flags 4).
    try std.testing.expectEqual(@as(u32, 32), ez_type_flags(h, ez_type_type_arg(h, ret, 0)));
}

test "type_ffi: generic param instantiation (any-wins + rest spread)" {
    // Generic rest param: foo<E extends string[]>(...p: E). With an `any` in the
    // args, any-wins infers E=any, so the instantiated param type is `any`.
    const src = "declare function foo<E extends string[]>(...p: E): void; foo('a', 1 as any);";
    const h = ez_type_open(src.ptr, @intCast(src.len), @intFromEnum(Language.ts), 1);
    try std.testing.expect(h != 0);
    defer ez_type_close(h);
    const ctx = ctxFrom(h).?;
    const tags = ctx.ast.nodes.items(.tag);
    var call_idx: u32 = NO_TYPE;
    for (tags, 0..) |tag, i| {
        if (tag == .call_expr) { call_idx = @intCast(i); break; }
    }
    try std.testing.expect(call_idx != NO_TYPE);
    const pt = ez_type_call_param_type(h, call_idx, 0);
    try std.testing.expect(pt != NO_TYPE);
    try std.testing.expectEqual(@as(u32, 1), ez_type_flags(h, pt)); // any

    // Non-generic call → no instantiation (NO_TYPE).
    const src2 = "function g(x: number) {} g(1);";
    const h2 = ez_type_open(src2.ptr, @intCast(src2.len), @intFromEnum(Language.ts), 1);
    defer ez_type_close(h2);
    const ctx2 = ctxFrom(h2).?;
    const tags2 = ctx2.ast.nodes.items(.tag);
    var call2: u32 = NO_TYPE;
    for (tags2, 0..) |tag, i| if (tag == .call_expr) { call2 = @intCast(i); break; };
    try std.testing.expect(call2 != NO_TYPE);
    try std.testing.expectEqual(@as(u32, NO_TYPE), ez_type_call_param_type(h2, call2, 0));
}
