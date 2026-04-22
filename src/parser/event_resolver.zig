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

// ── Per-scope binding table ─────────────────────────────────────────
// Replaces the global HashMap with per-scope sorted arrays.
// Each scope owns a []const BindingEntry sorted by name_hash.
// Main-pass lookups use linear scan (builders are unsorted/growing);
// retry-pass lookups use binary search (arrays finalised at scope_close).

const BindingEntry = struct {
    name_hash: u64,
    sym_id: SymbolId,
};

fn bindingLessThan(_: void, a: BindingEntry, b: BindingEntry) bool {
    return a.name_hash < b.name_hash;
}

fn scopeSearch(entries: []const BindingEntry, name_hash: u64, name: []const u8, sym_names: []const []const u8) ?SymbolId {
    var lo: usize = 0;
    var hi: usize = entries.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        const h = entries[mid].name_hash;
        if (h < name_hash) {
            lo = mid + 1;
        } else if (h > name_hash) {
            hi = mid;
        } else {
            var i: usize = mid;
            while (true) {
                if (std.mem.eql(u8, sym_names[entries[i].sym_id.toInt()], name)) return entries[i].sym_id;
                if (i == 0 or entries[i - 1].name_hash != name_hash) break;
                i -= 1;
            }
            i = mid + 1;
            while (i < entries.len and entries[i].name_hash == name_hash) : (i += 1) {
                if (std.mem.eql(u8, sym_names[entries[i].sym_id.toInt()], name)) return entries[i].sym_id;
            }
            return null;
        }
    }
    return null;
}

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
    /// Skip buildRefRanges (the counting sort that groups references by symbol).
    /// Enable when no active rule calls symbols.getRefRange().  Currently only
    /// no_func_assign uses ref ranges.
    skip_ref_ranges: bool = false,
    /// Null-separated list of global names to pre-declare in the global scope
    /// (ESLint `languageOptions.globals` whose value is anything other than
    /// `"off"`).  References to these names resolve to the pre-declared
    /// implicit-global symbol instead of remaining unresolved.
    globals: []const u8 = &.{},
    /// Precomputed wyhash(0, name) per token index from the lexer.  When
    /// non-empty, eliminates runtime Wyhash calls in the identifier resolve loop.
    tok_hashes: []const u64 = &.{},
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
    const StatsEntry = struct { name_hash: u64, name: []const u8 };
    var builders: [256]std.ArrayListUnmanaged(StatsEntry) = undefined;
    for (&builders) |*b| b.* = .{ .items = &.{}, .capacity = 0 };
    defer for (&builders) |*b| b.deinit(allocator);

    var sp: u32 = 0;
    var scope_count: u32 = 0;

    const tok_starts = ast.tokens.items(.start);
    const tok_lens = ast.tokens.items(.len);
    const node_main_tokens = ast.nodes.items(.main_token);
    const source = ast.source;

    var binding_count: u32 = 0;
    var resolved: u32 = 0;
    var unresolved: u32 = 0;

    for (events) |e| switch (e.kind) {
        .scope_open => {
            if (sp < builders.len) sp += 1;
            scope_count += 1;
        },
        .scope_close => if (sp > 0) {
            builders[sp - 1].clearRetainingCapacity();
            sp -= 1;
        },
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
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            const name_hash = std.hash.Wyhash.hash(0, name);
            try builders[sp - 1].append(allocator, .{ .name_hash = name_hash, .name = name });
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
            done: while (i >= 0) : (i -= 1) {
                for (builders[@intCast(i)].items) |entry| {
                    if (entry.name_hash == name_hash and std.mem.eql(u8, entry.name, name)) {
                        found = true;
                        break :done;
                    }
                }
            }
            if (found) resolved += 1 else unresolved += 1;
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
    const skip_ref_ranges = opts.skip_ref_ranges;

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

    // Dedicated arena for ephemeral scope-resolution data.
    // Scope builders, the sorted flat entry buffer, and scope-range table are
    // all freed together at function exit — no per-scope allocations hit the
    // outer allocator, giving FixedBufferAllocator-like throughput in production.
    var scope_arena = std.heap.ArenaAllocator.init(allocator);
    defer scope_arena.deinit();
    const sa = scope_arena.allocator();

    // Single HashMap from name_hash → sym_id for all currently-visible names.
    // Updated on every declare (add) and scope_close (undo).
    // O(1) reference resolution instead of O(depth × entries_per_scope) linear scan.
    // Identity hash context: our keys are already Wyhash-derived u64s — skip the
    // redundant re-hash that AutoHashMapUnmanaged would apply.
    const NameHashCtx = struct {
        pub fn hash(_: @This(), key: u64) u64 { return key; }
        pub fn eql(_: @This(), a: u64, b: u64) bool { return a == b; }
    };
    var scope_map = std.HashMapUnmanaged(u64, SymbolId, NameHashCtx, 80){};
    try scope_map.ensureTotalCapacity(sa, @intCast(est_syms));

    // Direct-mapped L1 cache in front of scope_map.  Absorbs repeated lookups
    // for the same identifier (common in any function body) without hitting the
    // HashMap.  512 entries × 12 bytes = 6 KB — stays hot in L1D.
    // Entry is "empty" when hash == 0 (Wyhash(0, name) == 0 is negligibly rare).
    const RefCacheEntry = struct { hash: u64, sym: SymbolId };
    var ref_cache = [_]RefCacheEntry{.{ .hash = 0, .sym = .none }} ** 512;

    // Per-depth undo stacks: on declare we record (name_hash, sym_id, prev) at
    // target_depth so scope_close can restore the previous binding in scope_map.
    const UndoEntry = struct { name_hash: u64, sym_id: SymbolId, prev: ?SymbolId };
    var undo_stacks: [256]std.ArrayListUnmanaged(UndoEntry) = undefined;
    for (&undo_stacks) |*u| u.* = .{ .items = &.{}, .capacity = 0 };
    // (freed by scope_arena.deinit)

    // Flat sorted binding store for the retry pass.
    // all_entries: one big contiguous buffer; scope_ranges maps scope_id → [start,end).
    const ScopeRange = struct { start: u32, end: u32 };
    var scope_ranges = std.ArrayListUnmanaged(ScopeRange){ .items = &.{}, .capacity = 0 };
    try scope_ranges.ensureTotalCapacity(sa, est_scopes);

    var all_entries = std.ArrayListUnmanaged(BindingEntry){ .items = &.{}, .capacity = 0 };
    try all_entries.ensureTotalCapacity(sa, est_syms);

    // Unresolved ref ids collected during the main pass so the retry pass can
    // iterate only the small set (~5-20K) instead of scanning all refs (245K).
    const UnresolvedRef = struct { ref_id: ReferenceId, name_hash: u64 };
    var unresolved_refs = std.ArrayListUnmanaged(UnresolvedRef){ .items = &.{}, .capacity = 0 };
    // (freed by scope_arena.deinit)

    // node_reachable — default all-alive (no CFG in event path yet).
    const node_reachable = try allocator.alloc(u8, ast.nodes.len);
    errdefer allocator.free(node_reachable);
    @memset(node_reachable, 1);
    const loop_exit_reachable = try allocator.alloc(u8, ast.nodes.len);
    errdefer allocator.free(loop_exit_reachable);
    @memset(loop_exit_reachable, 1);

    var cpb = CodePathBuilder.init(allocator);
    cpb.allocator = cpb.arena.allocator();
    errdefer cpb.deinit();

    // Pre-size cpb ArrayLists from event volume.  Segments scale roughly with
    // (if + loop + switch + logical + cond) events; over-estimation is harmless
    // since the arena is freed wholesale.
    if (!skip_cfg) {
        const ev_len: u32 = @intCast(events.len);
        try cpb.ensureCapacity(ev_len / 4, ev_len / 40);
    }

    // Scope stack — holds ScopeIds as we enter/leave scopes during the event
    // pass.  Depth ≤ 256 is plenty for realistic source (acorn.js peaks ~8).
    var stack: [256]ScopeId = undefined;
    var sp: u32 = 0;

    const tok_starts = ast.tokens.items(.start);
    const tok_lens = ast.tokens.items(.len);
    const node_main_tokens = ast.nodes.items(.main_token);
    const source = ast.source;
    const tok_hashes = opts.tok_hashes;

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
            try scope_ranges.append(sa, .{ .start = 0, .end = 0 });
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
                const closed_undos = undo_stacks[sp].items;
                if (closed_undos.len > 0) {
                    // Build retry-pass flat buffer from this scope's declared symbols.
                    const start: u32 = @intCast(all_entries.items.len);
                    for (closed_undos) |undo| {
                        try all_entries.append(sa, .{ .name_hash = undo.name_hash, .sym_id = undo.sym_id });
                    }
                    sortBindings(all_entries.items[start..]);
                    scope_ranges.items[closed_sid.toInt()] = .{ .start = start, .end = @intCast(all_entries.items.len) };
                    // Restore scope_map and ref_cache to pre-scope state (LIFO).
                    var j: usize = closed_undos.len;
                    while (j > 0) {
                        j -= 1;
                        const undo = closed_undos[j];
                        if (undo.prev) |prev| {
                            scope_map.getPtr(undo.name_hash).?.* = prev;
                            ref_cache[undo.name_hash & 511] = .{ .hash = undo.name_hash, .sym = prev };
                        } else {
                            _ = scope_map.remove(undo.name_hash);
                            ref_cache[undo.name_hash & 511] = .{ .hash = undo.name_hash, .sym = .none };
                        }
                    }
                    undo_stacks[sp].clearRetainingCapacity();
                }
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
            const target_depth: u32 = blk: {
                if (kind == .@"var" or kind == .function_decl) {
                    var j: i32 = @as(i32, @intCast(sp)) - 1;
                    while (j >= 0) : (j -= 1) {
                        const sid = stack[@intCast(j)];
                        const sk = scopes.kinds.items[sid.toInt()];
                        switch (sk) {
                            .global, .module, .function, .static_block, .class_field_initializer => break :blk @intCast(j),
                            else => {},
                        }
                    }
                }
                break :blk sp - 1;
            };
            const scope_id = stack[target_depth];
            const main_tok = node_main_tokens[e.node];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            const name_hash = if (tok_hashes.len != 0) tok_hashes[main_tok] else std.hash.Wyhash.hash(0, name);
            const flags = symbol_mod.flagsFromBindingKind(kind);
            const decl_node: NodeIndex = @enumFromInt(e.node);
            const sym_id = try symbols.addSymbol(name, flags, kind, scope_id, decl_node);
            const gop = try scope_map.getOrPut(sa, name_hash);
            const prev: ?SymbolId = if (gop.found_existing) gop.value_ptr.* else null;
            try undo_stacks[target_depth].append(sa, .{ .name_hash = name_hash, .sym_id = sym_id, .prev = prev });
            gop.value_ptr.* = sym_id;
            ref_cache[name_hash & 511] = .{ .hash = name_hash, .sym = sym_id };
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

            // Compute name_hash before the sp==0 branch so it can be stored in
            // both unresolved-append paths (avoids L3 tok_hashes re-fetch in retry).
            if (skip_resolve) continue;
            const main_tok = node_main_tokens[e.node];
            const name_hash = if (tok_hashes.len != 0) tok_hashes[main_tok] else blk: {
                const start = tok_starts[main_tok];
                const len = tok_lens[main_tok];
                break :blk std.hash.Wyhash.hash(0, source[start .. start + len]);
            };

            // O(1) resolve via the scope_map (name_hash → sym_id for all visible names).
            if (sp == 0) {
                try unresolved_refs.append(sa, .{ .ref_id = ref_id, .name_hash = name_hash });
                continue;
            }
            const cache_slot = &ref_cache[name_hash & 511];
            const sym_id: ?SymbolId = if (cache_slot.hash == name_hash) blk: {
                // Cache hit — sym may be .none (known-unresolved in current scope).
                break :blk if (cache_slot.sym != .none) cache_slot.sym else null;
            } else blk: {
                // Cache miss — probe scope_map and populate cache.
                const result = scope_map.get(name_hash);
                cache_slot.* = .{ .hash = name_hash, .sym = result orelse .none };
                break :blk result;
            };
            if (sym_id) |sid| {
                references.resolve(ref_id, sid);
                if (ref_kind.isRead()) symbols.markRead(sid);
                if (ref_kind.isWrite()) symbols.markWritten(sid);
                if (ref_kind == .type_of) symbols.markTypeOf(sid);
            } else {
                // Unresolved → retry pass handles forward refs (hoisted var/function).
                try unresolved_refs.append(sa, .{ .ref_id = ref_id, .name_hash = name_hash });
            }
        },

        // ── If statement CodePath events ─────────────────────────
        // cfg_alive logic merged here (branch_open/else/close no longer
        // emitted for if-statements; branch_* still fired by loops/try).
        .if_open => {
            if (bsp < branch_save.len) {
                branch_save[bsp] = cfg_alive;
                branch_cons[bsp] = cfg_alive;
                bsp += 1;
            }
            if (!skip_cfg) {
                try cpb.pushChoiceContext(.test_kind, false);
                const n: NodeIndex = @enumFromInt(e.node);
                try cpb.makeIfConsequent(n);
            }
        },
        .if_alt => {
            if (bsp > 0) {
                branch_cons[bsp - 1] = cfg_alive;
                cfg_alive = branch_save[bsp - 1];
            }
            if (!skip_cfg) {
                const n: NodeIndex = @enumFromInt(e.node);
                try cpb.makeIfAlternate(n);
            }
        },
        .if_close => {
            if (bsp > 0) {
                bsp -= 1;
                const save = branch_save[bsp];
                const cons = branch_cons[bsp];
                const alt = cfg_alive;
                cfg_alive = if (cons == save and alt == save) save else cons or alt;
            }
            if (!skip_cfg) {
                const n: NodeIndex = @enumFromInt(e.node);
                try cpb.popChoiceContext(n);
            }
        },

        // ── Loop CodePath events ─────────────────────────────────
        .loop_open => {
            if (!cfg_alive and e.node < node_reachable.len) node_reachable[e.node] = 0;
            if (!skip_cfg) {
                const loop_type: code_path_mod.LoopType = switch (e.aux) {
                    0 => .while_stmt,
                    1 => .do_while_stmt,
                    2 => .for_stmt,
                    3 => .for_in_stmt,
                    else => .for_of_stmt,
                };
                const n: NodeIndex = @enumFromInt(e.node);
                try cpb.pushLoopContext(loop_type, null, n, n);
            }
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

    // Retry unresolved references — `var`/`function` declarations hoist to the
    // nearest var-scope, so a reference seen *before* the declaration in source
    // order was left unresolved during the main pass.  Walk the scope chain
    // using the now-complete binding_map.
    if (!skip_resolve) {
        for (unresolved_refs.items) |ur| {
            const ref_id = ur.ref_id;
            const ref_scope = references.getScope(ref_id);
            if (!ref_scope.isValid()) continue;
            const ref_node = references.getNode(ref_id);
            const node_i = @intFromEnum(ref_node);
            if (node_i >= node_main_tokens.len) continue;
            const main_tok = node_main_tokens[node_i];
            const start = tok_starts[main_tok];
            const len = tok_lens[main_tok];
            const name = source[start .. start + len];
            const name_hash = ur.name_hash; // precomputed — no tok_hashes lookup
            const sym_names = symbols.names.items;
            var sid = ref_scope;
            const scope_count: u32 = @intCast(scopes.kinds.items.len);
            while (sid.toInt() < scope_count) {
                if (sid.toInt() < scope_ranges.items.len) {
                    const range = scope_ranges.items[sid.toInt()];
                    if (range.end > range.start) {
                        const entries = all_entries.items[range.start..range.end];
                        if (scopeSearch(entries, name_hash, name, sym_names)) |sym_id| {
                            references.resolve(ref_id, sym_id);
                            const rk = references.getKind(ref_id);
                            if (rk.isRead()) symbols.markRead(sym_id);
                            if (rk.isWrite()) symbols.markWritten(sym_id);
                            if (rk == .type_of) symbols.markTypeOf(sym_id);
                            break;
                        }
                    }
                }
                const parent_sid = scopes.parent(sid);
                if (parent_sid.toInt() == sid.toInt()) break; // root
                if (!parent_sid.isValid()) break;
                sid = parent_sid;
            }
        }
    }

    // Post-passes: sort by symbol / scope for downstream lookups, matching
    // `semantic.zig`'s `buildRefRanges` and `buildScopeBindings`.
    const ref_by_sym: []ReferenceId = if (!skip_ref_ranges)
        try buildRefRanges(&symbols, &references, sa, allocator)
    else
        &.{};
    try buildScopeBindings(&scopes, &symbols, allocator);

    const cpb_result = if (skip_cfg) blk: {
        cpb.deinit();
        break :blk @as(?CodePathBuilder.Result, null);
    } else blk: {
        // finish() transfers the arena into the Result; do NOT call cpb.deinit() after.
        break :blk cpb.finish();
    };

    return .{
        .scopes = scopes,
        .symbols = symbols,
        .references = references,
        .ref_by_sym = ref_by_sym,
        .diagnostics = &.{},
        .node_reachable = node_reachable,
        .loop_exit_reachable = loop_exit_reachable,
        .code_path_result = cpb_result,
    };
}

// ── Post-passes (copied from semantic.zig internals) ────────────────

/// Inline sort for small binding-entry slices.  Avoids the sortUnstable
/// function-call overhead for the common case of 1-4 declarations per scope.
fn sortBindings(slice: []BindingEntry) void {
    if (slice.len <= 1) return;
    if (slice.len == 2) {
        if (slice[0].name_hash > slice[1].name_hash)
            std.mem.swap(BindingEntry, &slice[0], &slice[1]);
        return;
    }
    if (slice.len <= 12) {
        var i: usize = 1;
        while (i < slice.len) : (i += 1) {
            const key = slice[i];
            var j: usize = i;
            while (j > 0 and slice[j - 1].name_hash > key.name_hash) : (j -= 1)
                slice[j] = slice[j - 1];
            slice[j] = key;
        }
        return;
    }
    std.mem.sortUnstable(BindingEntry, slice, {}, bindingLessThan);
}

// buildRefRanges builds an indirect ref-by-symbol index without touching the
// main reference arrays.  Instead of permuting all 5 SoA columns in place
// (the old sortBySymbolWithMax approach, ~12 passes + 5 dupe allocs ≈ 6 MB),
// we do a 3-pass counting sort over a single new array:
//
//   ref_by_sym[i]  — ref_id at sorted position i  (owned by SemanticResult)
//   sym_ref_range  — [start, end) into ref_by_sym per symbol
//
// Total: 3 passes over N refs + 1 pass over K symbols, 1.76 MB temp (arena).
// Callers access refs as: ref_by_sym[range.start .. range.end].
fn buildRefRanges(
    symbols: *SymbolTable,
    references: *ReferenceTable,
    sa: std.mem.Allocator,   // scope_arena — temp arrays freed in bulk
    allocator: std.mem.Allocator, // outer allocator — ref_by_sym persists
) ![]ReferenceId {
    const sym_count: u32 = @intCast(symbols.names.items.len);
    const ref_count: u32 = references.count();
    if (ref_count == 0 or sym_count == 0) return &.{};

    const sym_ids = references.symbol_ids.items;
    const buckets = sym_count + 1; // last bucket holds unresolved (.none)

    // Pass 1: count refs per symbol.
    const counts = try sa.alloc(u32, buckets);
    @memset(counts, 0);
    for (sym_ids) |s| {
        counts[if (s == .none) sym_count else s.toInt()] += 1;
    }

    // Pass 2: prefix sum → per-symbol start positions.
    // Only valid symbol IDs (0..sym_count-1) get entries in the symbol table.
    // The last bucket (index sym_count) holds unresolved refs — no symbol entry.
    const starts = try sa.alloc(u32, buckets);
    var acc: u32 = 0;
    for (0..sym_count) |i| {
        starts[i] = acc;
        symbols.setRefRange(@enumFromInt(i), .{ .start = acc, .end = acc + counts[i] });
        acc += counts[i];
    }
    starts[sym_count] = acc;

    // Pass 3: scatter ref_ids into the sorted index.
    const ref_by_sym = try allocator.alloc(ReferenceId, ref_count);
    const cursor = try sa.alloc(u32, buckets);
    @memcpy(cursor, starts);
    for (sym_ids, 0..) |s, old| {
        const b = if (s == .none) sym_count else s.toInt();
        ref_by_sym[cursor[b]] = ReferenceId.fromInt(@intCast(old));
        cursor[b] += 1;
    }

    return ref_by_sym;
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
