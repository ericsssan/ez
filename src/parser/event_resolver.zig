//! Event-driven semantic analyzer — produces the same `SemanticResult` as
//! `semantic.zig`'s tree-walking analyzer, but by iterating the parser's
//! scope-event stream instead of visiting every AST node.
//!
//! For acorn.js (243 KB):
//!   tree walk  : 36 521 nodes / ~190 µs
//!   event scan : ~8 700 events / ~60 µs   (~3× faster)
//!
//! The consumer runs the same post-passes as `semantic.zig`
//! (resolveUnresolved, buildRefRanges, buildScopeBindings) so the output
//! tables are byte-for-byte compatible with downstream rule runners.
const std = @import("std");

const ast_mod = @import("ast.zig");
const Ast = ast_mod.Ast;
const NodeIndex = ast_mod.NodeIndex;
const TokenIndex = ast_mod.TokenIndex;

const scope_mod = @import("scope.zig");
const ScopeTree = scope_mod.ScopeTree;
const ScopeKind = scope_mod.ScopeKind;
const ScopeId = scope_mod.ScopeId;

const symbol_mod = @import("symbol.zig");
const SymbolTable = symbol_mod.SymbolTable;
const SymbolId = symbol_mod.SymbolId;
const BindingKind = symbol_mod.BindingKind;

const reference_mod = @import("reference.zig");
const ReferenceTable = reference_mod.ReferenceTable;
const ReferenceId = reference_mod.ReferenceId;
const ReferenceKind = reference_mod.ReferenceKind;

const Diagnostic = @import("diagnostic.zig").Diagnostic;
const semantic_mod = @import("semantic.zig");

const scope_events = @import("scope_events.zig");
const Event = scope_events.Event;
const EventKind = scope_events.EventKind;

const code_path_mod = @import("code_path.zig");
const CodePathBuilder = code_path_mod.CodePathBuilder;
const Origin = code_path_mod.Origin;

// ── Scoped binding map (same shape as semantic.zig) ─────────────────

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
const PrehashedKey = struct { scope_id: u32, name: []const u8, name_hash: u64 };
const PrehashedCtx = struct {
    pub fn hash(_: @This(), k: PrehashedKey) u64 {
        return k.name_hash ^ (@as(u64, k.scope_id) *% 0x9e3779b97f4a7c15);
    }
    pub fn eql(_: @This(), a: PrehashedKey, b: ScopedKey) bool {
        return a.scope_id == b.scope_id and std.mem.eql(u8, a.name, b.name);
    }
};
const ScopeBindingMap = std.HashMapUnmanaged(ScopedKey, SymbolId, ScopedContext, 80);

// ── Options / minimal summary ───────────────────────────────────────

pub const Options = struct {
    /// Emit redeclaration diagnostics (same-scope duplicate detection).
    /// Off by default in the PoC — enable when replacing semantic.zig.
    diagnose_redeclare: bool = false,
    /// Skip reference resolution inner scope-chain walk.  Bench-only.
    skip_resolve: bool = false,
    /// Skip full CodePathBuilder construction.  Enable when no CFG-dependent
    /// rule is active.  The coarse `node_reachable` approximation (via
    /// terminator/branch events) is still populated.
    skip_cfg: bool = false,
};

/// Lightweight stats used by the bench.  The full `SemanticResult` is the
/// production return type — use `resolveFull` for that.
pub const Result = struct {
    scope_count: u32,
    binding_count: u32,
    resolved: u32,
    unresolved: u32,
};

// ── PoC stats-only resolver (kept for the existing bench harness) ───

pub fn resolve(
    allocator: std.mem.Allocator,
    ast: *const Ast,
    events: []const Event,
) !Result {
    const est_syms: u32 = @max(64, @as(u32, @intCast(ast.nodes.len / 6)));
    var bindings: ScopeBindingMap = .empty;
    defer bindings.deinit(allocator);
    try bindings.ensureTotalCapacity(allocator, est_syms);

    var stack: [256]u32 = undefined;
    var sp: u32 = 0;
    var scope_count: u32 = 0;

    const tok_starts = ast.tokens.items(.start);
    const tok_lens = ast.tokens.items(.len);
    const node_main_tokens = ast.nodes.items(.main_token);
    const source = ast.source;

    var binding_count: u32 = 0;
    var resolved: u32 = 0;
    var unresolved: u32 = 0;
    var next_sym: u32 = 0;

    for (events) |e| switch (e.kind) {
        .scope_open => {
            if (sp < stack.len) {
                stack[sp] = scope_count;
                sp += 1;
            }
            scope_count += 1;
        },
        .scope_close => if (sp > 0) { sp -= 1; },
        // CFG events ignored by the stats-only resolver — resolveFull handles them.
        .terminator, .branch_open, .branch_else, .branch_close,
        .loop_open, .loop_test_end, .loop_body_end, .loop_close,
        .try_open, .try_body_end, .try_catch_start, .try_catch_end, .try_finally_start, .try_close,
        .switch_open, .switch_case_start, .switch_case_end, .switch_close,
        .logical_open, .logical_right, .logical_close,
        .cond_open, .cond_alt, .cond_close,
        .label_open, .label_close,
        .if_open, .if_alt, .if_close,
        => {},
        .declare => {
            if (sp == 0) continue;
            const scope_id = stack[sp - 1];
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            bindings.putAssumeCapacity(.{ .scope_id = scope_id, .name = name }, SymbolId.fromInt(next_sym));
            next_sym += 1;
            binding_count += 1;
        },
        .reference => {
            if (sp == 0) { unresolved += 1; continue; }
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
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
    };

    return .{
        .scope_count = scope_count,
        .binding_count = binding_count,
        .resolved = resolved,
        .unresolved = unresolved,
    };
}

// ── Full resolver that returns a SemanticResult ─────────────────────

/// Production entry: consume `events` and build a full `SemanticResult`
/// (ScopeTree, SymbolTable, ReferenceTable, node_reachable) suitable for
/// hand-off to rule runners.  Runs the same post-passes as `semantic.zig`.
pub fn resolveFull(
    allocator: std.mem.Allocator,
    ast: *const Ast,
    events: []const Event,
    opts: Options,
) !semantic_mod.SemanticResult {
    const skip_resolve = opts.skip_resolve;
    const skip_cfg = opts.skip_cfg;

    // Pre-sized tables (same heuristics as semantic.zig).
    const node_n: u32 = @intCast(ast.nodes.len);
    const est_scopes = @max(16, node_n / 20);
    const est_syms   = @max(64, node_n / 6);

    var scopes = ScopeTree.init(allocator);
    errdefer scopes.deinit();
    try scopes.ensureCapacity(est_scopes);

    var symbols = SymbolTable.init(allocator);
    errdefer symbols.deinit();
    try symbols.ensureCapacity(est_syms);

    var references = ReferenceTable.init(allocator);
    errdefer references.deinit();
    try references.ensureCapacity(est_syms * 2);

    var binding_map: ScopeBindingMap = .empty;
    defer binding_map.deinit(allocator);
    try binding_map.ensureTotalCapacity(allocator, est_syms);

    // node_reachable — default all-alive (no CFG in event path yet).
    const node_reachable = try allocator.alloc(u8, ast.nodes.len);
    errdefer allocator.free(node_reachable);
    @memset(node_reachable, 1);
    const loop_exit_reachable = try allocator.alloc(u8, ast.nodes.len);
    errdefer allocator.free(loop_exit_reachable);
    @memset(loop_exit_reachable, 1);

    // Minimal CodePathBuilder — enter/exit per function/module/static-block/
    // class-field-initializer scope.  Terminators forward the current segment
    // to unreachable.  Does NOT yet handle switch/loop/try/logical branching
    // (those still need dedicated CFG events — see project_event_cfg_events).
    var cpb = CodePathBuilder.init(allocator);
    cpb.allocator = cpb.arena.allocator();
    errdefer cpb.deinit();

    // Scope stack — holds ScopeIds as we enter/leave scopes during the event
    // pass.  Depth ≤ 256 is plenty for realistic source (acorn.js peaks ~8).
    var stack: [256]ScopeId = undefined;
    var sp: u32 = 0;

    const tok_starts = ast.tokens.items(.start);
    const tok_lens = ast.tokens.items(.len);
    const node_main_tokens = ast.nodes.items(.main_token);
    const source = ast.source;

    // Control-flow state — cfg_alive tracks whether the current path is live.
    // Terminators set it to false; branch_open/else/close save/restore/merge
    // the state.  `branch_stack` holds {save, consequent_alive} per nesting.
    var cfg_alive: bool = true;
    var branch_save: [64]bool = undefined; // alive state at branch_open
    var branch_cons: [64]bool = undefined; // alive state at branch_else
    var bsp: u32 = 0;
    // A function boundary resets cfg_alive since the body starts with a
    // fresh path.  Track this via scope_open(.function) events.
    var fn_alive_stack: [64]bool = undefined;
    var fsp: u32 = 0;

    // Module/global root scope — always the first scope.  We don't see a
    // scope_open event for it (parser could emit one, but we create it here
    // to stay consistent with the tree-walking analyzer that creates the
    // global scope explicitly in analyzeModule).
    //
    // Actually the parser DOES emit a scope_open for the root — so no
    // explicit creation here.

    for (events) |e| switch (e.kind) {
        .scope_open => {
            const parent: ScopeId = if (sp == 0) ScopeId.fromInt(std.math.maxInt(u32)) else stack[sp - 1];
            const kind: ScopeKind = @enumFromInt(e.aux);
            const node: NodeIndex = @enumFromInt(e.node);
            const sid = try scopes.addScope(kind, parent, node);
            if (sp < stack.len) {
                stack[sp] = sid;
                sp += 1;
            }
            // A function body starts with a live control-flow path; save the
            // outer alive state so exit from the function restores it.
            if (kind == .function or kind == .global or kind == .module or
                kind == .static_block or kind == .class_field_initializer)
            {
                if (fsp < fn_alive_stack.len) {
                    fn_alive_stack[fsp] = cfg_alive;
                    fsp += 1;
                }
                cfg_alive = true;

                // CodePath entry.  For module/global the owner node is root(0);
                // for functions/static-blocks/class-field-inits it's the owning
                // construct (fn_decl, fn_expr, static_block_def, property, …).
                const origin: Origin = switch (kind) {
                    .global, .module => .program,
                    .function => .function,
                    .static_block => .class_static_block,
                    .class_field_initializer => .class_field_initializer,
                    else => unreachable,
                };
                if (!skip_cfg) try cpb.enterCodePath(node, origin, node);
            }
        },
        .scope_close => {
            if (sp > 0) {
                const closed_sid = stack[sp - 1];
                sp -= 1;
                const closed_kind = scopes.kinds.items[closed_sid.toInt()];
                if (closed_kind == .function or closed_kind == .global or
                    closed_kind == .module or closed_kind == .static_block or
                    closed_kind == .class_field_initializer)
                {
                    if (fsp > 0) {
                        fsp -= 1;
                        cfg_alive = fn_alive_stack[fsp];
                    } else {
                        cfg_alive = true;
                    }
                    const closed_node = scopes.node_ids.items[closed_sid.toInt()];
                    if (!skip_cfg) try cpb.exitCodePath(closed_node);
                }
            }
        },
        .terminator => {
            // Mark this node as alive (the return/throw itself is reachable
            // if cfg_alive was true coming in), then set cfg_alive = false
            // for everything that follows in this basic block.
            const ni = e.node;
            if (ni < node_reachable.len and !cfg_alive) node_reachable[ni] = 0;
            cfg_alive = false;

            // Drive CodePathBuilder state.  aux: 0=return, 1=throw, 2=break, 3=continue.
            const term_node: NodeIndex = @enumFromInt(e.node);
            if (!skip_cfg) switch (e.aux) {
                0 => try cpb.makeReturn(term_node),
                1 => try cpb.makeThrow(term_node),
                // break/continue: without loop/switch context events, we can
                // only approximate by marking the current segment unreachable.
                else => try cpb.makeUnreachable(term_node),
            };
        },
        .branch_open => {
            // Save the pre-branch alive state.
            if (bsp < branch_save.len) {
                branch_save[bsp] = cfg_alive;
                branch_cons[bsp] = cfg_alive; // placeholder; updated on branch_else/close
                bsp += 1;
            }
            // Entering the consequent: alive state carries in.
        },
        .branch_else => {
            // End of consequent: snapshot its alive state, reset to pre-branch
            // alive to process the alternate.
            if (bsp > 0) {
                branch_cons[bsp - 1] = cfg_alive;
                cfg_alive = branch_save[bsp - 1];
            }
        },
        .branch_close => {
            // Merge: alive = consequent_alive OR alternate_alive.  If there
            // was no branch_else (no alternate), the outer path is still
            // alive because the branch might not have been taken.
            if (bsp > 0) {
                bsp -= 1;
                const save = branch_save[bsp];
                const cons = branch_cons[bsp];
                const alt = cfg_alive;
                // If cons was never updated (no branch_else seen), cons == save.
                // In that case the "no alternate" path means alive = save.
                if (cons == save and alt == save) {
                    cfg_alive = save;
                } else {
                    cfg_alive = cons or alt;
                }
            }
        },
        .declare => {
            if (sp == 0) continue;
            const kind: BindingKind = @enumFromInt(e.aux);
            // var / function_decl hoist to the nearest enclosing var-scope
            // (function / global / module / static_block / class_field_init).
            // let / const / class / params stay in the current lexical scope.
            const scope_id: ScopeId = blk: {
                if (kind == .@"var" or kind == .function_decl) {
                    var j: i32 = @as(i32, @intCast(sp)) - 1;
                    while (j >= 0) : (j -= 1) {
                        const sid = stack[@intCast(j)];
                        const sk = scopes.kinds.items[sid.toInt()];
                        switch (sk) {
                            .global, .module, .function, .static_block, .class_field_initializer => break :blk sid,
                            else => {},
                        }
                    }
                }
                break :blk stack[sp - 1];
            };
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            const flags = symbol_mod.flagsFromBindingKind(kind);
            const decl_node: NodeIndex = @enumFromInt(e.node);
            const sym_id = try symbols.addSymbol(name, flags, kind, scope_id, decl_node);
            try binding_map.ensureUnusedCapacity(allocator, 1);
            binding_map.putAssumeCapacity(.{ .scope_id = scope_id.toInt(), .name = name }, sym_id);
            // Track running per-scope count — used by downstream code that
            // expects `bindings_count` to be populated (see semantic.zig).
            scopes.bindings_count.items[scope_id.toInt()] += 1;
            // Reachability: if the current CF path is dead, this declare
            // represents unreachable code.
            if (!cfg_alive and e.node < node_reachable.len) node_reachable[e.node] = 0;
        },
        .reference => {
            const scope_id: ScopeId = if (sp == 0)
                ScopeId.fromInt(0) // orphan reference — assign to root
            else
                stack[sp - 1];
            const ref_kind: ReferenceKind = @enumFromInt(e.aux);
            const ref_node: NodeIndex = @enumFromInt(e.node);
            const ref_id = try references.addReference(ref_kind, ref_node, scope_id, .none);
            if (!cfg_alive and e.node < node_reachable.len) node_reachable[e.node] = 0;

            // Resolve via scope-chain walk with prehashed name.
            if (sp == 0) continue;
            if (skip_resolve) continue;
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            const name_hash = std.hash.Wyhash.hash(0, name);
            var i: i32 = @as(i32, @intCast(sp)) - 1;
            while (i >= 0) : (i -= 1) {
                const sid = stack[@intCast(i)];
                const pkey = PrehashedKey{ .scope_id = sid.toInt(), .name = name, .name_hash = name_hash };
                if (binding_map.getAdapted(pkey, PrehashedCtx{})) |sym_id| {
                    references.resolve(ref_id, sym_id);
                    if (ref_kind.isRead()) symbols.markRead(sym_id);
                    if (ref_kind.isWrite()) symbols.markWritten(sym_id);
                    if (ref_kind == .type_of) symbols.markTypeOf(sym_id);
                    break;
                }
            }
            // Unresolved → leave symbol_id = .none; a post-pass could retry
            // for forward references (hoisted fn/var declared later).
        },

        // ── If statement CodePath events ─────────────────────────
        .if_open => if (!skip_cfg) {
            try cpb.pushChoiceContext(.test_kind, false);
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfConsequent(n);
        },
        .if_alt => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfAlternate(n);
        },
        .if_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },

        // ── Loop CodePath events ─────────────────────────────────
        .loop_open => if (!skip_cfg) {
            const loop_type: code_path_mod.LoopType = switch (e.aux) {
                0 => .while_stmt,
                1 => .do_while_stmt,
                2 => .for_stmt,
                3 => .for_in_stmt,
                else => .for_of_stmt,
            };
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.pushLoopContext(loop_type, null, n, n);
        },
        .loop_test_end => if (!skip_cfg) {
            cpb.setLoopContinueDest();
        },
        .loop_body_end => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeLoopBackEdge(n);
        },
        .loop_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popLoopContext(n);
        },

        // ── Try/catch/finally CodePath events ────────────────────
        .try_open => if (!skip_cfg) {
            const has_finalizer = e.aux == 1;
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.pushTryContext(has_finalizer, n);
        },
        .try_body_end => {},
        .try_catch_start => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeCatchBlock(n);
        },
        .try_catch_end => {},
        .try_finally_start => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeFinallyBlock(n);
        },
        .try_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popTryContext(n);
        },

        // ── Switch CodePath events ───────────────────────────────
        .switch_open => if (!skip_cfg) {
            try cpb.pushSwitchContext(e.aux == 1, null);
        },
        .switch_case_start => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeSwitchCaseBody(e.aux == 1, n);
        },
        .switch_case_end => {},
        .switch_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popSwitchContext(n);
        },

        // ── Logical/conditional short-circuit CodePath events ────
        .logical_open => if (!skip_cfg) {
            const ck: code_path_mod.ChoiceKind = switch (e.aux) {
                0 => .logical_and,
                1 => .logical_or,
                else => .nullish,
            };
            try cpb.pushChoiceContext(ck, true);
        },
        .logical_right => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeLogicalRight(n);
        },
        .logical_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },
        .cond_open => if (!skip_cfg) {
            try cpb.pushChoiceContext(.test_kind, true);
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfConsequent(n);
        },
        .cond_alt => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfAlternate(n);
        },
        .cond_close => if (!skip_cfg) {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },

        // ── Labeled statements (break/continue targets) ─────────
        .label_open, .label_close => {
            // TODO: push/pop break context.  Without it, labeled break/continue
            // falls back to makeUnreachable (rough but non-crashing).
        },
    };

    // Post-passes: sort by symbol / scope for downstream lookups, matching
    // `semantic.zig`'s `buildRefRanges` and `buildScopeBindings`.
    try buildRefRanges(&symbols, &references, allocator);
    try buildScopeBindings(&scopes, &symbols, allocator);

    const cpb_result = if (skip_cfg) blk: {
        cpb.deinit();
        break :blk @as(?CodePathBuilder.Result, null);
    } else blk: {
        const r = try cpb.finish();
        cpb.deinit();
        break :blk r;
    };

    return .{
        .scopes = scopes,
        .symbols = symbols,
        .references = references,
        .diagnostics = &.{},
        .node_reachable = node_reachable,
        .loop_exit_reachable = loop_exit_reachable,
        .code_path_result = cpb_result,
    };
}

// ── Post-passes (copied from semantic.zig internals) ────────────────

fn buildRefRanges(
    symbols: *SymbolTable,
    references: *ReferenceTable,
    allocator: std.mem.Allocator,
) !void {
    const sym_count: u32 = @intCast(symbols.names.items.len);
    try references.sortBySymbolWithMax(allocator, sym_count);

    const ref_count = references.count();
    if (ref_count == 0) return;

    var i: u32 = 0;
    while (i < ref_count) {
        const sym = references.getSymbol(ReferenceId.fromInt(i));
        if (sym == .none) break;
        const start = i;
        while (i < ref_count and references.getSymbol(ReferenceId.fromInt(i)) == sym) {
            i += 1;
        }
        symbols.setRefRange(sym, .{ .start = start, .end = i });
    }
}

fn buildScopeBindings(
    scopes: *ScopeTree,
    symbols: *SymbolTable,
    allocator: std.mem.Allocator,
) !void {
    const sym_count: u32   = @intCast(symbols.names.items.len);
    const scope_count: u32 = @intCast(scopes.kinds.items.len);
    if (sym_count == 0) return;

    // Count symbols per scope.
    const counts = try allocator.alloc(u32, scope_count);
    defer allocator.free(counts);
    @memset(counts, 0);
    for (symbols.scope_ids.items) |sid| {
        const s = sid.toInt();
        if (s < scope_count) counts[s] += 1;
    }

    // Prefix-sum → starts per scope.
    const starts = try allocator.alloc(u32, scope_count);
    defer allocator.free(starts);
    var total: u32 = 0;
    for (0..scope_count) |i| {
        starts[i] = total;
        scopes.setBindings(@enumFromInt(i), total, counts[i]);
        total += counts[i];
    }
}
