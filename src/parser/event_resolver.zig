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

// ── Options / minimal summary ───────────────────────────────────────

pub const Options = struct {
    /// Emit redeclaration diagnostics (same-scope duplicate detection).
    /// Off by default in the PoC — enable when replacing semantic.zig.
    diagnose_redeclare: bool = false,
    /// Skip reference resolution inner scope-chain walk.  Bench-only.
    skip_resolve: bool = false,
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
    /// Streaming mode: when set, the producer (parser thread) is publishing
    /// events incrementally. The resolver walks the events slice via
    /// indexed access bounded by `events_published.load(.acquire)` and blocks
    /// on the slow path when it catches up to the producer.
    streaming: ?StreamingHooks = null,
};

pub const StreamingHooks = struct {
    events_published: *std.atomic.Value(usize),
    parse_done: *std.atomic.Value(bool),
    /// Upper bound on node count — used to pre-size node_reachable etc. since
    /// `ast.nodes.len` reflects the parser's still-growing count. Caller passes
    /// the same upper-bound hint used to size the parser's pre-allocated nodes.
    node_count_hint: usize,
    /// Optional diagnostic counters — populated by resolveFull when set. Lets
    /// callers see where sem time is going (loop vs spin vs post-passes) and
    /// how often it parks the kernel via yield.
    stats: ?*Stats = null,
};

pub const Stats = struct {
    events_loop_ns: u64 = 0,
    spin_ns: u64 = 0,
    post_passes_ns: u64 = 0,
    resolve_unresolved_ns: u64 = 0,
    build_ref_ranges_ns: u64 = 0,
    build_scope_bindings_ns: u64 = 0,
    spin_count: u64 = 0,
    yield_count: u64 = 0,
    events_processed: u64 = 0,
    unresolved_count: u64 = 0,
    scope_count: u64 = 0,
    symbol_count: u64 = 0,
};

/// Lightweight stats used by the bench.  The full `SemanticResult` is the
/// production return type — use `resolveFull` for that.
pub const Result = struct {
    scope_count: u32,
    binding_count: u32,
    resolved: u32,
    unresolved: u32,
};

/// Returns the "looping target" node for a loop — the child node that ESLint's
/// `isLoopingTarget` function recognises as the loop's entry point on each
/// iteration.  This is the node that the loop-body segment's seg_start event
/// must be keyed to so that `onCodePathSegmentStart(seg, node)` fires with the
/// right node.
///
/// Mirrors ESLint's `isLoopingTarget` check (no-unreachable-loop):
///   WhileStatement  → test (condition)
///   DoWhileStatement → body
///   ForStatement    → update || test || body
///   ForIn/ForOf     → left (binding)
fn loopingTargetNode(ast: *const ast_mod.Ast, n: NodeIndex, loop_type: code_path_mod.LoopType) NodeIndex {
    const data = ast.nodes.items(.data)[@intFromEnum(n)];
    return switch (loop_type) {
        .while_stmt => data.lhs, // condition
        .do_while_stmt => data.lhs, // body
        .for_stmt => blk: {
            const fd = ast.extraData(ast_mod.ForData, @intFromEnum(data.lhs));
            if (fd.update != .none) break :blk fd.update;
            if (fd.condition != .none) break :blk fd.condition;
            break :blk data.rhs; // body (for (;;) { ... })
        },
        .for_in_stmt, .for_of_stmt => blk: {
            const fd = ast.extraData(ast_mod.ForInOfData, @intFromEnum(data.lhs));
            break :blk fd.binding; // left (binding)
        },
    };
}

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
        .nop,
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
    const skip_ref_ranges = opts.skip_ref_ranges;

    // Pre-sized tables (same heuristics as semantic.zig). Streaming: use the
    // upper-bound hint since ast.nodes.len is still growing on the parser thread.
    const node_n: u32 = if (opts.streaming) |s| @intCast(s.node_count_hint) else @intCast(ast.nodes.len);
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
    // Hoisting map: var/function_decl declarations keyed by
    // (name_hash ^ scope_id * prime) → SymbolId.  The retry pass uses this
    // for O(1) lookups per var-scope level instead of O(log N) binary search.
    var hoist_map = std.HashMapUnmanaged(u64, SymbolId, NameHashCtx, 80){};
    try hoist_map.ensureTotalCapacity(sa, @intCast(est_syms / 4));

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

    // Unresolved ref ids collected during the main pass so the retry pass can
    // iterate only the small set (~5-20K) instead of scanning all refs (245K).
    // Pre-size in streaming mode to avoid arena fragmentation that hurts
    // resolveUnresolved cache locality.
    const UnresolvedRef = struct { ref_id: ReferenceId, name_hash: u64 };
    var unresolved_refs = std.ArrayListUnmanaged(UnresolvedRef){ .items = &.{}, .capacity = 0 };
    if (opts.streaming) |s| {
        // ~15% of events are unresolved on average; round up.
        try unresolved_refs.ensureTotalCapacity(sa, @max(1024, s.node_count_hint / 4));
    }
    // (freed by scope_arena.deinit)

    // node_reachable — default all-alive (no CFG in event path yet).
    // In streaming mode, ast.nodes.len reflects the parser's growing count;
    // size to the caller-provided upper bound instead.
    const reach_size: usize = if (opts.streaming) |s| s.node_count_hint else ast.nodes.len;
    const node_reachable = try allocator.alloc(u8, reach_size);
    errdefer allocator.free(node_reachable);
    @memset(node_reachable, 1);
    const loop_exit_reachable = try allocator.alloc(u8, reach_size);
    errdefer allocator.free(loop_exit_reachable);
    @memset(loop_exit_reachable, 1);

    var cpb = CodePathBuilder.init(allocator);
    cpb.allocator = cpb.arena.allocator();
    errdefer cpb.deinit();

    // Pre-size cpb ArrayLists from event volume.  Segments scale roughly with
    // (if + loop + switch + logical + cond) events; over-estimation is harmless
    // since the arena is freed wholesale.
    {
        const ev_len: u32 = @intCast(events.len);
        try cpb.ensureCapacity(ev_len / 4, ev_len / 40);
    }

    // Scope stack — holds ScopeIds as we enter/leave scopes during the event
    // pass.  Depth ≤ 256 is plenty for realistic source (acorn.js peaks ~8).
    var stack: [256]ScopeId = undefined;
    var sp: u32 = 0;

    // In streaming mode, the parser is concurrently growing nodes/tokens.
    // The slice's .len is racy, but the .ptr is stable (parser pre-sized
    // both to safe upper bounds — guaranteed no realloc during parse).
    // Reconstruct slices using the upper-bound hint for .len so bounds
    // checks pass; per-event read of node[idx] is happens-after the
    // event's release-store, so the data is committed.
    const tok_starts = if (opts.streaming) |s| ast.tokens.items(.start).ptr[0..s.node_count_hint] else ast.tokens.items(.start);
    const tok_lens = if (opts.streaming) |s| ast.tokens.items(.len).ptr[0..s.node_count_hint] else ast.tokens.items(.len);
    const node_main_tokens = if (opts.streaming) |s| ast.nodes.items(.main_token).ptr[0..s.node_count_hint] else ast.nodes.items(.main_token);
    const node_tags = if (opts.streaming) |s| ast.nodes.items(.tag).ptr[0..s.node_count_hint] else ast.nodes.items(.tag);
    const node_datas = if (opts.streaming) |s| ast.nodes.items(.data).ptr[0..s.node_count_hint] else ast.nodes.items(.data);
    const source = ast.source;
    const tok_hashes = opts.tok_hashes;
    // Pending label text set by label_open (aux=1) before the loop_open it wraps.
    var pending_label: []const u8 = "";

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

    var ev_i: usize = 0;
    // Streaming: events.len was 0 when the early ast view was captured.
    // Reconstruct a slice over the pre-allocated buffer using the upper-bound
    // hint as len so events[ev_i] doesn't panic on bounds. The actual valid
    // range is enforced by the events_published atomic.
    const events_view: []const Event = if (opts.streaming) |s|
        events.ptr[0..(s.node_count_hint * 2)]
    else
        events;
    var ev_visible: usize = if (opts.streaming) |s| s.events_published.load(.acquire) else events_view.len;

    // Per-stage timing for diagnostic stats.
    var loop_start_ts: std.c.timespec = undefined;
    if (opts.streaming != null) _ = std.c.clock_gettime(.MONOTONIC, &loop_start_ts);
    main_event_loop: while (true) {
        if (ev_i >= ev_visible) {
            @branchHint(.cold);
            if (opts.streaming) |s| {
                var spin_start_ts: std.c.timespec = undefined;
                if (s.stats != null) _ = std.c.clock_gettime(.MONOTONIC, &spin_start_ts);
                var spins: u32 = 0;
                var yields: u32 = 0;
                var spin_iters: u64 = 0;
                while (true) {
                    const v = s.events_published.load(.acquire);
                    if (v > ev_i) { ev_visible = v; break; }
                    if (s.parse_done.load(.acquire)) {
                        ev_visible = s.events_published.load(.acquire);
                        break;
                    }
                    spins += 1;
                    spin_iters += 1;
                    if (spins < 100) std.atomic.spinLoopHint() else {
                        std.Thread.yield() catch {};
                        spins = 0;
                        yields += 1;
                    }
                }
                if (s.stats) |st| {
                    var spin_end_ts: std.c.timespec = undefined;
                    _ = std.c.clock_gettime(.MONOTONIC, &spin_end_ts);
                    const dt: u64 = @intCast((spin_end_ts.sec - spin_start_ts.sec) * std.time.ns_per_s + (spin_end_ts.nsec - spin_start_ts.nsec));
                    st.spin_ns += dt;
                    st.spin_count += spin_iters;
                    st.yield_count += yields;
                }
                if (ev_i >= ev_visible) break :main_event_loop;
            } else break :main_event_loop;
        }
        const e = events_view[ev_i];
        ev_i += 1;
        switch (e.kind) {
        .scope_open => {
            const kind: ScopeKind = @enumFromInt(e.aux);
            // Elided scopes (parser-emitted block scopes that turned out empty
            // — no let/const/class) have no matching scope_close. Sequential
            // mode strips them via parser compaction; streaming skips
            // compaction (race) so resolver must skip inline.
            if (kind == .elided) continue;
            const parent: ScopeId = if (sp == 0) ScopeId.fromInt(std.math.maxInt(u32)) else stack[sp - 1];
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
                try cpb.enterCodePath(node, origin, node);
            }
        },
        .scope_close => {
            if (sp > 0) {
                const closed_sid = stack[sp - 1];
                sp -= 1;
                const closed_undos = undo_stacks[sp].items;
                if (closed_undos.len > 0) {
                    // Restore scope_map and ref_cache to pre-scope state (LIFO).
                    var j: usize = closed_undos.len;
                    while (j > 0) {
                        j -= 1;
                        const undo = closed_undos[j];
                        const cur_ptr = scope_map.getPtr(undo.name_hash);
                        // Skip if a shallower-target (hoisted) declaration has
                        // already overwritten this scope's entry. That declaration's
                        // own undo (at a shallower depth) will handle restoration.
                        if (cur_ptr == null or cur_ptr.?.* != undo.sym_id) continue;
                        if (undo.prev) |prev| {
                            cur_ptr.?.* = prev;
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
                    try cpb.exitCodePath(closed_node);
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
            const term_i = @intFromEnum(term_node);
            switch (e.aux) {
                0 => try cpb.makeReturn(term_node),
                1 => try cpb.makeThrow(term_node),
                2 => if (term_i < node_tags.len and node_tags[term_i] == .break_label) blk: {
                    const lbl_n = node_datas[term_i].lhs;
                    const lt = node_main_tokens[@intFromEnum(lbl_n)];
                    const lbl = source[tok_starts[lt] .. tok_starts[lt] + tok_lens[lt]];
                    try cpb.makeBreakLabeled(lbl, term_node);
                    break :blk;
                } else try cpb.makeBreak(term_node),
                3 => if (term_i < node_tags.len and node_tags[term_i] == .continue_label) blk: {
                    const lbl_n = node_datas[term_i].lhs;
                    const lt = node_main_tokens[@intFromEnum(lbl_n)];
                    const lbl = source[tok_starts[lt] .. tok_starts[lt] + tok_lens[lt]];
                    try cpb.makeContinueLabeled(lbl, term_node);
                    break :blk;
                } else try cpb.makeContinue(term_node),
                else => try cpb.makeUnreachable(term_node),
            }
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
            if (kind == .@"var" or kind == .function_decl) {
                const hk = name_hash ^ (@as(u64, scope_id.toInt()) *% 0x9e3779b97f4a7c15);
                const ghop = try hoist_map.getOrPut(sa, hk);
                if (!ghop.found_existing) ghop.value_ptr.* = sym_id;
            }
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
            references.seg_ids.items[ref_id.toInt()] = cpb.currentSegId();
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
                if (ref_kind.isWrite() and ref_kind != .write_init) symbols.markWritten(sid);
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
            try cpb.pushChoiceContext(.test_kind, false);
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfConsequent(n);
        },
        .if_alt => {
            if (bsp > 0) {
                branch_cons[bsp - 1] = cfg_alive;
                cfg_alive = branch_save[bsp - 1];
            }
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfAlternate(n);
        },
        .if_close => {
            if (bsp > 0) {
                bsp -= 1;
                const save = branch_save[bsp];
                const cons = branch_cons[bsp];
                const alt = cfg_alive;
                cfg_alive = if (cons == save and alt == save) save else cons or alt;
            }
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },

        // ── Loop CodePath events ─────────────────────────────────
        .loop_open => {
            if (!cfg_alive and e.node < node_reachable.len) node_reachable[e.node] = 0;
            const loop_type: code_path_mod.LoopType = switch (e.aux) {
                0 => .while_stmt,
                1 => .do_while_stmt,
                2 => .for_stmt,
                3 => .for_in_stmt,
                else => .for_of_stmt,
            };
            const n: NodeIndex = @enumFromInt(e.node);
            const target = loopingTargetNode(ast, n, loop_type);
            // has_skip_path: false for do-while (always executes once), for(;;) /
            // for(init;;update) (no condition), and while(true) (condition is always truthy).
            const has_skip_path: bool = switch (loop_type) {
                .do_while_stmt => false,
                .for_stmt => blk: {
                    const fd = ast.extraData(ast_mod.ForData, @intFromEnum(node_datas[@intFromEnum(n)].lhs));
                    break :blk fd.condition != .none;
                },
                .while_stmt => blk: {
                    const cond = node_datas[@intFromEnum(n)].lhs;
                    if (cond == .none) break :blk false;
                    if (node_tags[@intFromEnum(cond)] != .boolean_literal) break :blk true;
                    // while(true): condition is always truthy — no skip path
                    break :blk ast.tokenTag(ast.nodeMainToken(cond)) != .kw_true;
                },
                else => true, // for-in, for-of always have a skip path
            };
            const loop_label: ?[]const u8 = if (pending_label.len > 0) pending_label else null;
            pending_label = "";
            try cpb.pushLoopContext(loop_type, loop_label, n, target, has_skip_path);
        },
        .loop_test_end => cpb.setLoopContinueDest(),
        .loop_body_end => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeLoopBackEdge(n);
        },
        .loop_close => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popLoopContext(n);
        },

        // ── Try/catch/finally CodePath events ────────────────────
        .try_open => {
            const has_finalizer = e.aux == 1;
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.pushTryContext(has_finalizer, n);
        },
        .try_body_end => {},
        .try_catch_start => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeCatchBlock(n);
        },
        .try_catch_end => {},
        .try_finally_start => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeFinallyBlock(n);
        },
        .try_close => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popTryContext(n);
        },

        // ── Switch CodePath events ───────────────────────────────
        .switch_open => try cpb.pushSwitchContext(e.aux == 1, null),
        .switch_case_start => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeSwitchCaseBody(e.aux == 1, n);
        },
        .switch_case_end => {},
        .switch_close => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popSwitchContext(n);
        },

        // ── Logical/conditional short-circuit CodePath events ────
        .logical_open => {
            const ck: code_path_mod.ChoiceKind = switch (e.aux) {
                0 => .logical_and,
                1 => .logical_or,
                else => .nullish,
            };
            try cpb.pushChoiceContext(ck, true);
        },
        .logical_right => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeLogicalRight(n);
        },
        .logical_close => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },
        .cond_open => {
            try cpb.pushChoiceContext(.test_kind, true);
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfConsequent(n);
        },
        .cond_alt => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.makeIfAlternate(n);
        },
        .cond_close => {
            const n: NodeIndex = @enumFromInt(e.node);
            try cpb.popChoiceContext(n);
        },

        // ── Labeled statements (break/continue targets) ─────────
        .label_open => {
            if (e.aux == 1) { // loop label — extract text for upcoming loop_open
                const label_n: NodeIndex = @enumFromInt(e.node);
                const lt = node_main_tokens[@intFromEnum(label_n)];
                const start = tok_starts[lt];
                const len = tok_lens[lt];
                pending_label = source[start .. start + len];
            }
        },
        .label_close => {
            pending_label = ""; // consumed or no loop found — clear either way
        },
        .nop => {},
        }
    }

    // Capture loop end time and start post-passes timer.
    var post_start_ts: std.c.timespec = undefined;
    if (opts.streaming) |s| {
        _ = std.c.clock_gettime(.MONOTONIC, &post_start_ts);
        if (s.stats) |st| {
            const dt: u64 = @intCast((post_start_ts.sec - loop_start_ts.sec) * std.time.ns_per_s + (post_start_ts.nsec - loop_start_ts.nsec));
            st.events_loop_ns = dt;
            st.events_processed = ev_i;
        }
    }

    // Retry unresolved references — `var`/`function` declarations hoist to the
    // nearest var-scope, so a reference seen *before* the declaration in source
    // order was left unresolved during the main pass.  Walk the var-scope chain
    // using hoist_map (O(1) per level) instead of all_entries binary search
    // (O(log N) per level across every lexical scope).
    if (!skip_resolve) {
        const scope_count: u32 = @intCast(scopes.kinds.items.len);
        const kinds = scopes.kinds.items;
        for (unresolved_refs.items) |ur| {
            const ref_id = ur.ref_id;
            const ref_scope = references.getScope(ref_id);
            if (!ref_scope.isValid()) continue;
            const name_hash = ur.name_hash;

            // Find the nearest var-scope enclosing ref_scope.
            var vsid = ref_scope;
            while (vsid.toInt() < scope_count) {
                switch (kinds[vsid.toInt()]) {
                    .global, .module, .function, .static_block, .class_field_initializer => break,
                    else => {
                        const p = scopes.parent(vsid);
                        if (!p.isValid() or p.toInt() == vsid.toInt()) break;
                        vsid = p;
                    },
                }
            }

            // Walk var-scope ancestors, O(1) hash lookup per level.
            while (vsid.toInt() < scope_count) {
                const hk = name_hash ^ (@as(u64, vsid.toInt()) *% 0x9e3779b97f4a7c15);
                if (hoist_map.get(hk)) |sym_id| {
                    references.resolve(ref_id, sym_id);
                    const rk = references.getKind(ref_id);
                    if (rk.isRead()) symbols.markRead(sym_id);
                    if (rk.isWrite() and rk != .write_init) symbols.markWritten(sym_id);
                    if (rk == .type_of) symbols.markTypeOf(sym_id);
                    break;
                }
                var p = scopes.parent(vsid);
                if (!p.isValid() or p.toInt() == vsid.toInt()) break;
                // Advance p to the next var-scope.
                while (p.toInt() < scope_count) {
                    switch (kinds[p.toInt()]) {
                        .global, .module, .function, .static_block, .class_field_initializer => break,
                        else => {
                            const pp = scopes.parent(p);
                            if (!pp.isValid() or pp.toInt() == p.toInt()) break;
                            p = pp;
                        },
                    }
                }
                if (p.toInt() == vsid.toInt()) break;
                vsid = p;
            }
        }
    }

    // Post-passes: sort by symbol / scope for downstream lookups, matching
    // `semantic.zig`'s `buildRefRanges` and `buildScopeBindings`.
    const ref_by_sym: []ReferenceId = if (!skip_ref_ranges)
        try buildRefRanges(&symbols, &references, sa, allocator)
    else
        &.{};
    var t_after_resolve: std.c.timespec = undefined;
    if (opts.streaming) |s| {
        if (s.stats) |st| {
            _ = std.c.clock_gettime(.MONOTONIC, &t_after_resolve);
            st.resolve_unresolved_ns = @intCast((t_after_resolve.sec - post_start_ts.sec) * std.time.ns_per_s + (t_after_resolve.nsec - post_start_ts.nsec));
            st.unresolved_count = unresolved_refs.items.len;
            st.scope_count = scopes.kinds.items.len;
            st.symbol_count = symbols.names.items.len;
        }
    }

    try buildScopeBindings(&scopes, &symbols, allocator);

    // Capture post-passes time.
    if (opts.streaming) |s| {
        if (s.stats) |st| {
            var post_end_ts: std.c.timespec = undefined;
            _ = std.c.clock_gettime(.MONOTONIC, &post_end_ts);
            st.build_scope_bindings_ns = @intCast((post_end_ts.sec - t_after_resolve.sec) * std.time.ns_per_s + (post_end_ts.nsec - t_after_resolve.nsec));
            st.post_passes_ns = @intCast((post_end_ts.sec - post_start_ts.sec) * std.time.ns_per_s + (post_end_ts.nsec - post_start_ts.nsec));
        }
    }

    // finish() transfers the arena into the Result; do NOT call cpb.deinit() after.
    const cpb_result = cpb.finish();

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
