//! Event-driven scope resolver.
//!
//! Processes a scope event stream emitted by the parser to build the same
//! scope/symbol/reference tables that `semantic.zig` builds by walking the AST,
//! but with ~4× fewer iterations (only semantic-relevant events vs every node).
//!
//! This is a PoC to measure whether the event-driven architecture pays off
//! before replacing the full tree-walking analyzer.
const std = @import("std");

const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const TokenIndex = ast_mod.TokenIndex;

const scope_mod = @import("scope.zig");
const ScopeKind = scope_mod.ScopeKind;
const ScopeId = scope_mod.ScopeId;

const symbol_mod = @import("symbol.zig");
const SymbolId = symbol_mod.SymbolId;
const BindingKind = symbol_mod.BindingKind;

const reference_mod = @import("reference.zig");
const ReferenceKind = reference_mod.ReferenceKind;

const scope_events = @import("scope_events.zig");
const Event = scope_events.Event;
const EventKind = scope_events.EventKind;

/// Minimal result type — just what a real event-driven semantic would need.
/// For PoC, we only track counts to prove the timing.
pub const Result = struct {
    scope_count: u32,
    binding_count: u32,
    resolved: u32,
    unresolved: u32,
};

// ── Scoped-binding hash key (same shape as semantic.zig) ─────────────
const ScopedKey = struct { scope_id: u32, name: []const u8 };
const ScopedContext = struct {
    pub fn hash(_: @This(), k: ScopedKey) u64 {
        const nh = std.hash.Wyhash.hash(0, k.name);
        return nh ^ (@as(u64, k.scope_id) *% 0x9e3779b97f4a7c15);
    }
    pub fn eql(_: @This(), a: ScopedKey, b: ScopedKey) bool {
        return a.scope_id == b.scope_id and std.mem.eql(u8, a.name, b.name);
    }
};
const ScopeBindingMap = std.HashMapUnmanaged(ScopedKey, SymbolId, ScopedContext, 80);

/// Prehashed key — name hash computed once, scope_id mixed in per lookup.
const PrehashedKey = struct { scope_id: u32, name: []const u8, name_hash: u64 };
const PrehashedCtx = struct {
    pub fn hash(_: @This(), k: PrehashedKey) u64 {
        return k.name_hash ^ (@as(u64, k.scope_id) *% 0x9e3779b97f4a7c15);
    }
    pub fn eql(_: @This(), a: PrehashedKey, b: ScopedKey) bool {
        return a.scope_id == b.scope_id and std.mem.eql(u8, a.name, b.name);
    }
};

/// Run the full event-stream resolver on `events` using `ast` for name lookup.
/// Returns summary counts.  The scope stack is a small fixed-size array — we
/// don't expect JS source to exceed 256 scope levels of nesting.
pub fn resolve(
    allocator: std.mem.Allocator,
    ast: *const Ast,
    events: []const Event,
) !Result {
    // Pre-sized tables.  Heuristic: ~1 symbol per 6 nodes (same as semantic).
    const est_syms: u32 = @max(64, @as(u32, @intCast(ast.nodes.len / 6)));
    var bindings: ScopeBindingMap = .empty;
    defer bindings.deinit(allocator);
    try bindings.ensureTotalCapacity(allocator, est_syms);

    // Parent-chain array: parents[scope_id] = parent_scope_id.  Sized by
    // bumping as new scopes are opened; shared 1024-slot scratch is plenty
    // for realistic JS.
    var parents: [1024]u32 = undefined;
    var scope_count: u32 = 0;

    // Active scope stack — depth never exceeds actual source nesting.
    var stack: [256]u32 = undefined;
    var sp: u32 = 0;

    const tok_starts = ast.tokens.items(.start);
    const tok_lens = ast.tokens.items(.len);
    const node_main_tokens = ast.nodes.items(.main_token);
    const source = ast.source;

    var binding_count: u32 = 0;
    var resolved: u32 = 0;
    var unresolved: u32 = 0;
    var next_symbol_id: u32 = 0;

    for (events) |e| {
        switch (e.kind) {
            .scope_open => {
                const parent_id: u32 = if (sp == 0) std.math.maxInt(u32) else stack[sp - 1];
                const new_id = scope_count;
                if (new_id < parents.len) parents[new_id] = parent_id;
                scope_count += 1;
                if (sp < stack.len) {
                    stack[sp] = new_id;
                    sp += 1;
                }
            },
            .scope_close => {
                if (sp > 0) sp -= 1;
            },
            .declare => {
                if (sp == 0) continue; // event stream malformed — skip
                const scope_id = stack[sp - 1];
                const node = e.node;
                const main_tok = node_main_tokens[node];
                const start = tok_starts[main_tok];
                const len = tok_lens[main_tok];
                const name = source[start .. start + len];
                const key = ScopedKey{ .scope_id = scope_id, .name = name };
                const sym_id = SymbolId.fromInt(next_symbol_id);
                next_symbol_id += 1;
                // Put into the map (overwrite is fine for PoC; real impl would
                // detect redeclaration and diagnose).
                bindings.putAssumeCapacity(key, sym_id);
                binding_count += 1;
            },
            .reference => {
                if (sp == 0) { unresolved += 1; continue; }
                const node = e.node;
                const main_tok = node_main_tokens[node];
                const start = tok_starts[main_tok];
                const len = tok_lens[main_tok];
                const name = source[start .. start + len];
                // Hash once, reuse at each scope level.
                const name_hash = std.hash.Wyhash.hash(0, name);
                var i: i32 = @as(i32, @intCast(sp)) - 1;
                var found = false;
                while (i >= 0) : (i -= 1) {
                    const sid = stack[@intCast(i)];
                    const pkey = PrehashedKey{ .scope_id = sid, .name = name, .name_hash = name_hash };
                    if (bindings.getAdapted(pkey, PrehashedCtx{}) != null) {
                        resolved += 1;
                        found = true;
                        break;
                    }
                }
                if (!found) unresolved += 1;
            },
        }
    }

    return .{
        .scope_count = scope_count,
        .binding_count = binding_count,
        .resolved = resolved,
        .unresolved = unresolved,
    };
}
