const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;
const ReferenceKind = ref_mod.ReferenceKind;
const code_path_mod = @import("../../../parser/code_path.zig");
const NONE_SEG = code_path_mod.NONE_SEG;
const NONE_CP = code_path_mod.NONE_CP;
const SegmentId = code_path_mod.SegmentId;
const CodePathId = code_path_mod.CodePathId;
const EventType = code_path_mod.EventType;

pub const meta = RuleMeta{
    .name = "no-useless-assignment",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow variable assignments when the value is not used",
};

pub const needs_ref_ranges = true;

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const scopes = ctx.scopes();
    const ref_by_sym = ctx.semantic.ref_by_sym;
    const cpr = ctx.semantic.code_path_result orelse return;
    const source = ctx.source();
    const seg_count = cpr.seg_count;

    // Collect all exported-directive names in one pass over source, then use
    // a hash set for O(1) per-symbol lookup instead of O(source) per symbol.
    var exported_set = std.StringHashMap(void).init(ctx.allocator);
    defer exported_set.deinit();
    collectExportedDirectives(source, &exported_set);

    // CFG-only data (depends on segment topology, NOT on symbols). Built
    // once and reused across every analyzed symbol.
    var cfg_arena = std.heap.ArenaAllocator.init(ctx.allocator);
    defer cfg_arena.deinit();
    const cfg = buildCfgAdj(cfg_arena.allocator(), &cpr) catch return;

    // Per-CP segment lists — also CFG-only, built once. Each symbol's
    // analysis loops only over its own CP's segs (~tens) instead of every
    // segment in the file (~hundreds of thousands).
    const cp_segs = buildCpSegs(cfg_arena.allocator(), &cpr) catch return;

    // Global→local seg-id map. Re-populated lazily for each CP we touch
    // by writing local indices into the slots for that CP's segs. Stale
    // entries from a previous CP are harmless because every code path is
    // closed (segments don't cross CP boundaries in the live data we
    // dereference).
    const seg_to_local = cfg_arena.allocator().alloc(u32, seg_count) catch return;
    @memset(seg_to_local, std.math.maxInt(u32));

    // Pre-compute scope→nearestVarScope mapping. We call nearestVarScope
    // O(refs) times across the run — caching turns each call into a single
    // array load instead of a parent-chain walk. Bottom-up: each scope's
    // var-scope is itself if is_var_scope, else its parent's cached
    // var-scope. Relies on parent IDs being smaller than child IDs
    // (construction order).
    const scope_count = scopes.len();
    const var_scope_of = cfg_arena.allocator().alloc(u32, scope_count) catch return;
    {
        const NONE: u32 = std.math.maxInt(u32);
        var s: u32 = 0;
        while (s < scope_count) : (s += 1) {
            const sid: @import("../../../parser/scope.zig").ScopeId = @enumFromInt(s);
            if (scopes.getFlags(sid).is_var_scope) {
                var_scope_of[s] = s;
            } else {
                const p = scopes.parent(sid);
                if (p == .none) {
                    var_scope_of[s] = NONE;
                } else {
                    var_scope_of[s] = var_scope_of[@intFromEnum(p)];
                }
            }
        }
    }

    // Per-segment source range: bytes [first..=last] of the first/last
    // identifier reference in each segment. ESLint's no-useless-assignment
    // uses this to determine "is identifier I in segment S" — checking if
    // I's byte range falls within S's first..last identifier byte range.
    // Without this, our seg-id-strict check misses reads that span ezlint's
    // segment boundaries (e.g. RHS of an assign in a separate segment from
    // the LHS).
    //
    // We use ALL references (not just our tracked symbols) to define seg
    // ranges, mirroring ESLint's per-identifier visit.
    const SENTINEL_HI: u32 = 0;
    const SENTINEL_LO: u32 = std.math.maxInt(u32);
    const seg_first_byte = cfg_arena.allocator().alloc(u32, seg_count) catch return;
    const seg_last_byte = cfg_arena.allocator().alloc(u32, seg_count) catch return;
    @memset(seg_first_byte, SENTINEL_LO);
    @memset(seg_last_byte, SENTINEL_HI);
    {
        const total_refs = refs.count();
        var rid: u32 = 0;
        while (rid < total_refs) : (rid += 1) {
            const ref_id: ReferenceId = @enumFromInt(rid);
            const seg = refs.getSegId(ref_id);
            if (seg == NONE_SEG or seg >= seg_count) continue;
            const node = refs.getNode(ref_id);
            const main_tok = ctx.nodeMainToken(node);
            const bs = ctx.tokenStart(main_tok);
            const be = bs + ctx.tokenLen(main_tok);
            if (bs < seg_first_byte[seg]) seg_first_byte[seg] = bs;
            if (be > seg_last_byte[seg]) seg_last_byte[seg] = be;
        }
    }

    // Per-symbol scratch arena, reset (NOT deinit'd) between symbols.
    // retain_capacity keeps the largest allocation alive for reuse, so
    // 4334 symbols don't each pay a fresh sbrk/mmap.
    var sym_arena = std.heap.ArenaAllocator.init(ctx.allocator);
    defer sym_arena.deinit();

    // Collect filtered symbols into a list, then sort by cp_id. Processing
    // all symbols in a CP together lets us build the CP-local successor
    // adjacency once and reuse it for every symbol in the group.
    var batch: std.ArrayList(SymBatch) = .empty;
    defer batch.deinit(ctx.allocator);

    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const sym_id = SymbolId.fromInt(i);

        // Skip binding kinds that aren't reassignable JS values. Type-only
        // bindings have no runtime presence; import bindings are read-only.
        // JS reports useless writes to fn_expr_name / class_expr_name /
        // implicit_global, so we keep those.
        const bk = symbols.getBindingKind(sym_id);
        switch (bk) {
            .import_binding,
            .type_import_binding,
            .type_decl,
            .interface_decl,
            .enum_decl,
            .namespace_decl,
            .type_param,
            => continue,
            else => {},
        }

        const ref_range = symbols.getRefRange(sym_id);
        if (ref_range.start >= ref_range.end) continue;

        // Skip symbols exported via ES module export statement
        if (isExportedSymbol(ctx, sym_id)) continue;

        // Skip symbols exported via /* exported name */ directive
        const sym_name = symbols.getName(sym_id);
        if (exported_set.contains(sym_name)) continue;

        const sym_scope = symbols.getScope(sym_id);
        const sym_var_scope_int: u32 = var_scope_of[@intFromEnum(sym_scope)];
        if (sym_var_scope_int == std.math.maxInt(u32)) continue;
        const sym_var_scope: @import("../../../parser/scope.zig").ScopeId = @enumFromInt(sym_var_scope_int);

        var has_write = false;
        // A symbol with only a declaration-site write (no explicit re-assignment)
        // is an unused-variable, not a useless assignment — skip it.
        // Unused now; kept for parity with the old filter. has_write is the
        // gate (any write at all qualifies the symbol for analysis).
        // var has_explicit_write: bool = false;
        // Symbols with NO read references at all (in any scope) belong to
        // no-unused-vars, not no-useless-assignment — skip them.
        var has_any_read = false;
        const decl_node = symbols.getDeclNode(sym_id);
        // Cross-scope = different var scope. Previous version also walked
        // the AST for enclosingFunction as a belt-and-braces check, but
        // that over-skipped (a hoisted var whose var-scope is the same but
        // whose AST enclosing function differs was wrongly tagged as a
        // closure ref).
        // Single fused scan: compute has_* flags AND discover the symbol's
        // code path (first in-scope ref's segment's cp_id) AND detect
        // captured reads. Saves a second ref-range walk.
        var sym_cp: CodePathId = NONE_CP;
        var has_captured_read = false;
        // AST-walk fallback: the scope module sometimes attributes references
        // inside arrow-function bodies to the enclosing var-scope, which
        // makes `var_scope_of[ref_scope] == sym_var_scope_int` even though
        // the ref is across a function boundary. Compute the symbol's
        // enclosing function node once and compare per ref.
        const sym_enclosing_fn = bindingEnclosingFunction(ctx, decl_node);
        {
            var r = ref_range.start;
            while (r < ref_range.end) : (r += 1) {
                const ref_id = ref_by_sym[r];
                const kind = refs.getKind(ref_id);
                const ref_scope = refs.getScope(ref_id);
                const ref_var_scope_int = var_scope_of[@intFromEnum(ref_scope)];
                const is_read_kind = kind == .read or kind == .type_of or kind == .type_read or kind == .read_write;
                if (is_read_kind) has_any_read = true;
                const ref_node_check = refs.getNode(ref_id);
                const ref_enclosing_fn = enclosingFunction(ctx, ref_node_check);
                const is_cross_fn = ref_enclosing_fn != sym_enclosing_fn;
                const is_cross_scope = ref_var_scope_int != sym_var_scope_int or is_cross_fn;
                if (is_cross_scope) {
                    // Cross-scope read = closure capture. The value escapes
                    // and could be observed at any later point by the
                    // capturing function, so writes in this scope can't be
                    // proven dead.
                    if (is_read_kind) has_captured_read = true;
                    continue;
                }
                if (sym_cp == NONE_CP) {
                    const seg = refs.getSegId(ref_id);
                    if (seg != NONE_SEG and seg < seg_count) sym_cp = cpr.seg_codepath[seg];
                }
                if (kind == .write or kind == .read_write or kind == .write_init) {
                    has_write = true;
                }
            }
        }
        if (!has_any_read) continue;
        if (!has_write) continue;
        // NOTE: previously bailed on `!has_explicit_write`. ESLint reports
        // init-only dead writes (e.g. `let x = 1; x = 2; use(x)` flags the
        // init), so we let the forward walk decide per-write.
        if (sym_cp == NONE_CP) continue;

        batch.append(ctx.allocator, .{
            .sym_id = sym_id,
            .sym_var_scope = sym_var_scope,
            .cp_id = sym_cp,
            .has_captured_read = has_captured_read,
        }) catch return;
    }

    if (batch.items.len == 0) return;

    // Sort by cp_id so we process all symbols in a CP together.
    std.mem.sort(SymBatch, batch.items, {}, struct {
        fn lt(_: void, a: SymBatch, b: SymBatch) bool {
            return a.cp_id < b.cp_id;
        }
    }.lt);

    // Process per-CP groups. Build the CP-local successor adjacency once,
    // then run every symbol in this CP against the same tiny arrays. Reset
    // sym_arena BEFORE each CP build so both the CP adjacency and the per-
    // symbol allocations share one bumping region — no fresh sbrk.
    var gi: usize = 0;
    while (gi < batch.items.len) {
        const cur_cp = batch.items[gi].cp_id;
        var gj = gi + 1;
        while (gj < batch.items.len and batch.items[gj].cp_id == cur_cp) gj += 1;

        _ = sym_arena.reset(.retain_capacity);
        const cpa = buildCpLocalAdj(sym_arena.allocator(), &cpr, &cfg, cp_segs, seg_to_local, var_scope_of, seg_first_byte, seg_last_byte, cur_cp) catch {
            gi = gj;
            continue;
        };

        var k = gi;
        while (k < gj) : (k += 1) {
            const item = batch.items[k];
            analyzeSymbolCpLocal(ctx, &cpa, &sym_arena, item.sym_id, item.sym_var_scope, item.has_captured_read);
        }
        gi = gj;
    }
}

const SymBatch = struct {
    sym_id: SymbolId,
    sym_var_scope: @import("../../../parser/scope.zig").ScopeId,
    cp_id: CodePathId,
    /// Any READ of this symbol happens in a different var-scope (i.e., the
    /// value is captured by a closure). When true, the report pass
    /// suppresses ALL writes for this symbol — they may be observed by the
    /// closure at some later point, so we can't prove they're dead. Mirrors
    /// oxlint's `has_captured_read` and ESLint's per-reference skip
    /// behavior for the no-useless-assignment rule.
    has_captured_read: bool,
};

/// CP-local adjacency. All arrays are sized cp_seg_count (~tens) instead of
/// the global seg_count (~hundreds of thousands), so the fixed-point loop
/// stays in L1.  Successors are stored as local indices — no remap needed
/// in the hot loop.
const CpLocalAdj = struct {
    cp_id: CodePathId,
    cp_seg_count: u32,
    cp_segs: []const u32,            // local → global seg id (for ref-bucket build + reporting)
    seg_to_local: []const u32,       // global → local (read-only, shared across CPs)
    succ_start: []const u32,         // [cp_seg_count + 1]
    succ_local: []const u32,         // flat successor list, local indices
    loop_next_start: []const u32,    // [cp_seg_count + 1]
    loop_next_local: []const u32,    // flat back-edge list, local indices
    var_scope_of: []const u32,       // global: scope id → nearest var-scope id (or maxInt)
    seg_first_byte: []const u32,     // global seg → first identifier byte in seg (or maxInt)
    seg_last_byte: []const u32,      // global seg → last identifier byte (or 0)
};

fn buildCpLocalAdj(
    alloc: std.mem.Allocator,
    cpr: *const code_path_mod.CodePathBuilder.Result,
    cfg: *const CfgAdj,
    cp_segs_all: CpSegs,
    seg_to_local: []u32,
    var_scope_of: []const u32,
    seg_first_byte: []const u32,
    seg_last_byte: []const u32,
    cp: CodePathId,
) !CpLocalAdj {
    const cp_segs = cp_segs_all.slice(cp);
    const cp_seg_count: u32 = @intCast(cp_segs.len);

    // Populate seg_to_local for this CP (overwrites stale entries from
    // previous CPs — only the entries for our cp_segs are read below).
    for (cp_segs, 0..) |g, li| seg_to_local[g] = @intCast(li);

    // Count successors per local index. Use the UNION of:
    //   (a) inverted prev_targets — strictly bidirectional
    //   (b) next_targets[A] → B ONLY when B.prev_targets includes A
    //       (next_targets in the parser is populated during incremental
    //       construction and can contain stale entries to segments that
    //       no longer list A as a predecessor; following those produces
    //       spurious forward edges that let the BFS bypass writes.)
    const succ_start = try alloc.alloc(u32, cp_seg_count + 1);
    @memset(succ_start, 0);
    const inPrev = struct {
        // A next_targets[src] → target edge is "consistent" if target lists
        // src as a predecessor in EITHER prev_targets (normal forward) or
        // looped_prev_targets (loop back-edge). Without this, back-edges
        // get filtered out and the BFS can't see "value used in next
        // iteration" patterns (case 8 in the conformance corpus).
        fn check(cpr2: *const code_path_mod.CodePathBuilder.Result, target: u32, src: u32) bool {
            const ps = cpr2.seg_prev_start[target];
            const pe = cpr2.seg_prev_end[target];
            for (cpr2.prev_targets[ps..pe]) |p| {
                if (p == src) return true;
            }
            const lp_start = cpr2.seg_looped_prev_start[target];
            const lp_end = cpr2.seg_looped_prev_end[target];
            for (cpr2.looped_targets[lp_start..lp_end]) |p| {
                if (p == src) return true;
            }
            return false;
        }
    }.check;
    for (cp_segs) |g| {
        const g32: u32 = @intCast(g);
        const gs = cfg.succ_start[g32];
        const ge = cfg.succ_start[g32 + 1];
        for (cfg.succ_flat[gs..ge]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            succ_start[seg_to_local[g32] + 1] += 1;
        }
        const ni = cpr.seg_next[g32];
        for (cpr.next_targets[ni.next_start..ni.next_end]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            // Consistency check: only follow if target lists src as prev.
            if (!inPrev(cpr, s_global, g32)) continue;
            succ_start[seg_to_local[g32] + 1] += 1;
        }
        // Loop back-edges via the dedicated `looped_targets` pool — a
        // segment that is the FROM end of a `continue` (or natural loop
        // back-edge) gets the destination recorded here. These don't
        // necessarily appear in next_targets but MUST be followed for
        // forward-walk correctness ("value used in next iteration").
        // Walk all segs to find which list this g as a prev.
        // For perf, derive forward edges from looped_prev once per seg:
        // for each seg X, X.looped_prev_targets are segs that end with a
        // back-edge into X. The reverse: g's looped_next_targets is the
        // set of segs that have g in their looped_prev list.
        // (Currently inferred lazily inside the BFS via inPrev; baking
        // it into succ_start avoids a per-step scan.)
    }
    // Build a forward-loop-edge index: forward_loop[src] → list of dst.
    const forward_loop_count = try alloc.alloc(u32, cp_seg_count);
    @memset(forward_loop_count, 0);
    for (cp_segs) |g_dst| {
        const dst_local = seg_to_local[g_dst];
        if (dst_local >= cp_seg_count) continue;
        const lps = cpr.seg_looped_prev_start[g_dst];
        const lpe = cpr.seg_looped_prev_end[g_dst];
        for (cpr.looped_targets[lps..lpe]) |g_src| {
            if (cpr.seg_codepath[g_src] != cp) continue;
            const src_local = seg_to_local[g_src];
            if (src_local >= cp_seg_count) continue;
            forward_loop_count[src_local] += 1;
        }
    }
    for (0..cp_seg_count) |li| {
        succ_start[li + 1] += forward_loop_count[li];
    }
    var acc: u32 = 0;
    for (0..cp_seg_count) |li| {
        const c = succ_start[li + 1];
        succ_start[li] = acc;
        acc += c;
        succ_start[li + 1] = acc;
    }
    const succ_local = try alloc.alloc(u32, if (acc > 0) acc else 1);
    const succ_cursor = try alloc.alloc(u32, cp_seg_count);
    defer alloc.free(succ_cursor);
    @memcpy(succ_cursor, succ_start[0..cp_seg_count]);
    for (cp_segs, 0..) |g, li_usize| {
        const li: u32 = @intCast(li_usize);
        const g32: u32 = @intCast(g);
        const gs = cfg.succ_start[g32];
        const ge = cfg.succ_start[g32 + 1];
        for (cfg.succ_flat[gs..ge]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            succ_local[succ_cursor[li]] = sl_local;
            succ_cursor[li] += 1;
        }
        const ni = cpr.seg_next[g32];
        for (cpr.next_targets[ni.next_start..ni.next_end]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            if (!inPrev(cpr, s_global, g32)) continue;
            succ_local[succ_cursor[li]] = sl_local;
            succ_cursor[li] += 1;
        }
    }
    // Add forward loop back-edges: for each cp seg X with looped_prev
    // entries, append edges Y → X for each Y in X's looped_prev.
    for (cp_segs) |g_dst| {
        const dst_local = seg_to_local[g_dst];
        if (dst_local >= cp_seg_count) continue;
        const lps = cpr.seg_looped_prev_start[g_dst];
        const lpe = cpr.seg_looped_prev_end[g_dst];
        for (cpr.looped_targets[lps..lpe]) |g_src| {
            if (cpr.seg_codepath[g_src] != cp) continue;
            const src_local = seg_to_local[g_src];
            if (src_local >= cp_seg_count) continue;
            succ_local[succ_cursor[src_local]] = dst_local;
            succ_cursor[src_local] += 1;
        }
    }

    // Same for loop-back-edge targets.
    const loop_next_start = try alloc.alloc(u32, cp_seg_count + 1);
    @memset(loop_next_start, 0);
    for (cp_segs) |g| {
        const g32: u32 = @intCast(g);
        const ls = cfg.loop_next_start[g32];
        const le = cfg.loop_next_start[g32 + 1];
        for (cfg.loop_next_targets[ls..le]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            loop_next_start[seg_to_local[g32] + 1] += 1;
        }
    }
    var acc2: u32 = 0;
    for (0..cp_seg_count) |li| {
        const c = loop_next_start[li + 1];
        loop_next_start[li] = acc2;
        acc2 += c;
        loop_next_start[li + 1] = acc2;
    }
    const loop_next_local = try alloc.alloc(u32, if (acc2 > 0) acc2 else 1);
    const loop_cursor = try alloc.alloc(u32, cp_seg_count);
    defer alloc.free(loop_cursor);
    @memcpy(loop_cursor, loop_next_start[0..cp_seg_count]);
    for (cp_segs, 0..) |g, li_usize| {
        const li: u32 = @intCast(li_usize);
        const g32: u32 = @intCast(g);
        const ls = cfg.loop_next_start[g32];
        const le = cfg.loop_next_start[g32 + 1];
        for (cfg.loop_next_targets[ls..le]) |s_global| {
            if (cpr.seg_codepath[s_global] != cp) continue;
            const sl_local = seg_to_local[s_global];
            if (sl_local >= cp_seg_count) continue;
            loop_next_local[loop_cursor[li]] = sl_local;
            loop_cursor[li] += 1;
        }
    }

    return .{
        .cp_id = cp,
        .cp_seg_count = cp_seg_count,
        .cp_segs = cp_segs,
        .seg_to_local = seg_to_local,
        .succ_start = succ_start,
        .succ_local = succ_local,
        .loop_next_start = loop_next_start,
        .loop_next_local = loop_next_local,
        .var_scope_of = var_scope_of,
        .seg_first_byte = seg_first_byte,
        .seg_last_byte = seg_last_byte,
    };
}

/// Group segments by their owning CodePath. Indexed by cp_id; each entry
/// is a slice into a flat `seg_pool` buffer. O(seg_count) one-time build.
const CpSegs = struct {
    /// For cp `c`: segs[start[c]..start[c+1]] is the slice.
    start: []u32,
    pool: []u32,

    pub fn slice(self: CpSegs, cp: CodePathId) []const u32 {
        const c: usize = cp;
        return self.pool[self.start[c]..self.start[c + 1]];
    }
};

fn buildCpSegs(alloc: std.mem.Allocator, cpr: *const code_path_mod.CodePathBuilder.Result) !CpSegs {
    const seg_count = cpr.seg_count;
    const cp_count: u32 = @intCast(cpr.codepaths.len);
    const start = try alloc.alloc(u32, cp_count + 1);
    @memset(start, 0);
    for (0..seg_count) |s| {
        const cp = cpr.seg_codepath[s];
        if (cp == NONE_CP) continue;
        const ci: usize = cp;
        if (ci >= cp_count) continue;
        start[ci + 1] += 1;
    }
    var acc: u32 = 0;
    for (0..cp_count) |c| {
        const next = start[c + 1];
        start[c] = acc;
        acc += next;
        start[c + 1] = acc;
    }
    const pool = try alloc.alloc(u32, if (acc > 0) acc else 1);
    const cursor = try alloc.alloc(u32, cp_count);
    defer alloc.free(cursor);
    @memcpy(cursor, start[0..cp_count]);
    for (0..seg_count) |s| {
        const cp = cpr.seg_codepath[s];
        if (cp == NONE_CP) continue;
        const ci: usize = cp;
        if (ci >= cp_count) continue;
        pool[cursor[ci]] = @intCast(s);
        cursor[ci] += 1;
    }
    return .{ .start = start, .pool = pool };
}

/// CFG-only data structures — depend on segment topology, not on any
/// particular symbol. Built once per `runOnSymbols` and shared across
/// all per-symbol analyses.
const CfgAdj = struct {
    /// succ_start[s..s+1] indexes into succ_flat the successors of s.
    succ_start: []u32,
    succ_flat: []u32,
    succ_count: []u32,
    /// loop_next_start[s..s+1] indexes into loop_next_targets the
    /// supplementary back-edges originating at s (recovered from seg_loop
    /// events, retargeted to the loop's test segment for correct backward
    /// liveness).
    loop_next_start: []u32,
    loop_next_targets: []u32,
};

fn buildCfgAdj(alloc: std.mem.Allocator, cpr: *const code_path_mod.CodePathBuilder.Result) !CfgAdj {
    const seg_count = cpr.seg_count;

    const succ_count = try alloc.alloc(u32, seg_count);
    @memset(succ_count, 0);
    for (0..seg_count) |s| {
        const s32: u32 = @intCast(s);
        if (cpr.seg_reachable[s32] == 0) continue;
        const ps = cpr.seg_prev_start[s32];
        const pe = cpr.seg_prev_end[s32];
        for (cpr.prev_targets[ps..pe]) |prev| {
            if (prev < seg_count) succ_count[prev] += 1;
        }
    }
    const succ_start = try alloc.alloc(u32, seg_count + 1);
    succ_start[0] = 0;
    for (0..seg_count) |s| succ_start[s + 1] = succ_start[s] + succ_count[s];
    const total_succ = succ_start[seg_count];
    const succ_flat = try alloc.alloc(u32, if (total_succ > 0) total_succ else 1);
    const succ_cursor = try alloc.alloc(u32, seg_count);
    defer alloc.free(succ_cursor);
    @memcpy(succ_cursor, succ_start[0..seg_count]);
    for (0..seg_count) |s| {
        const s32: u32 = @intCast(s);
        if (cpr.seg_reachable[s32] == 0) continue;
        const ps = cpr.seg_prev_start[s32];
        const pe = cpr.seg_prev_end[s32];
        for (cpr.prev_targets[ps..pe]) |prev| {
            if (prev < seg_count) {
                succ_flat[succ_cursor[prev]] = s32;
                succ_cursor[prev] += 1;
            }
        }
    }

    // Supplementary back-edge map from seg_loop events. Retarget at the
    // loop-test segment so liveness flows body→test→after-loop.
    const loop_next_count = try alloc.alloc(u32, seg_count);
    @memset(loop_next_count, 0);
    for (cpr.events) |ev| {
        if (ev.type != .seg_loop) continue;
        if (ev.data1 < seg_count) loop_next_count[ev.data1] += 1;
    }
    const loop_next_start = try alloc.alloc(u32, seg_count + 1);
    loop_next_start[0] = 0;
    for (0..seg_count) |s| loop_next_start[s + 1] = loop_next_start[s] + loop_next_count[s];
    const loop_next_total = loop_next_start[seg_count];
    const loop_next_targets = try alloc.alloc(u32, if (loop_next_total > 0) loop_next_total else 1);
    const loop_next_cursor = try alloc.alloc(u32, seg_count);
    defer alloc.free(loop_next_cursor);
    @memcpy(loop_next_cursor, loop_next_start[0..seg_count]);
    for (cpr.events) |ev| {
        if (ev.type != .seg_loop) continue;
        if (ev.data1 < seg_count and ev.data2 < seg_count) {
            const body = ev.data2;
            var test_seg: u32 = body;
            const ps = cpr.seg_prev_start[body];
            const pe = cpr.seg_prev_end[body];
            for (cpr.prev_targets[ps..pe]) |p| {
                if (p >= seg_count) continue;
                if (succ_count[p] > 1) {
                    test_seg = @intCast(p);
                    break;
                }
            }
            loop_next_targets[loop_next_cursor[ev.data1]] = test_seg;
            loop_next_cursor[ev.data1] += 1;
        }
    }

    return .{
        .succ_start = succ_start,
        .succ_flat = succ_flat,
        .succ_count = succ_count,
        .loop_next_start = loop_next_start,
        .loop_next_targets = loop_next_targets,
    };
}

// Per-symbol ref info used by the forward-walk algorithm. Captures
// everything the walk needs without re-querying refs/AST.
const RefInfo = struct {
    ref_id: ReferenceId,
    kind: ReferenceKind,
    local_seg: u32,
    byte_start: u32,
    byte_end: u32,
    node: NodeIndex,
    /// For writes: the enclosing assignment-like node (`.assign`,
    /// `.add_assign`, `.declarator`, `.prefix_inc`, `.postfix_inc`, etc.).
    /// Used to decide whether a read identifier is inside this write's
    /// RHS-evaluation range (evaluated BEFORE the write in execution
    /// order, so it doesn't observe the write's new value).
    assign_node: NodeIndex,
};

/// Find the enclosing assignment-like node for a write reference.
fn findAssignNode(ctx: *const LintContext, write_node: NodeIndex) NodeIndex {
    var cur = write_node;
    var depth: u32 = 0;
    while (depth < 8) : (depth += 1) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return .none;
        switch (ctx.nodeTag(parent)) {
            .assign,
            .add_assign,
            .sub_assign,
            .mul_assign,
            .div_assign,
            .mod_assign,
            .exp_assign,
            .and_assign,
            .or_assign,
            .xor_assign,
            .shl_assign,
            .shr_assign,
            .ushr_assign,
            .logical_and_assign,
            .logical_or_assign,
            .nullish_assign,
            .declarator,
            .prefix_inc,
            .postfix_inc,
            .prefix_dec,
            .postfix_dec,
            => return parent,
            else => cur = parent,
        }
    }
    return .none;
}

/// True when `node` is inside the default-value expression of a destructuring
/// `.assignment_pattern` (i.e., the `(a = 2)` in `let {b = (a = 2)} = obj`).
/// Such writes are conditional — they fire only when the corresponding source
/// property is `undefined`. They cannot be treated as unconditional overwrites
/// of sibling bindings on the no-default path.
fn isInDestructuringDefault(ctx: *const LintContext, node: NodeIndex) bool {
    var cur = node;
    var depth: u32 = 0;
    while (depth < 32) : (depth += 1) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        if (ctx.nodeTag(parent) == .assignment_pattern) {
            const data = ctx.nodeData(parent);
            // Inside the default-value expression (rhs), not the target (lhs).
            if (data.rhs == cur) return true;
        }
        cur = parent;
    }
    return false;
}

/// Returns the node representing what evaluates BEFORE the write fires.
/// For declarators, this is the init (RHS of `=`), NOT the binding pattern
/// — defaults inside the binding are evaluated as separate writes, in
/// declaration order. For regular assignments, this is the RHS. For
/// inc/dec, the operand is read before the write.
inline fn assignRhsRange(ctx: *const LintContext, assign_node: NodeIndex) NodeIndex {
    if (assign_node == .none) return .none;
    const data = ctx.nodeData(assign_node);
    return switch (ctx.nodeTag(assign_node)) {
        .declarator => data.rhs,
        .assign,
        .add_assign,
        .sub_assign,
        .mul_assign,
        .div_assign,
        .mod_assign,
        .exp_assign,
        .and_assign,
        .or_assign,
        .xor_assign,
        .shl_assign,
        .shr_assign,
        .ushr_assign,
        .logical_and_assign,
        .logical_or_assign,
        .nullish_assign,
        => data.rhs,
        .prefix_inc, .postfix_inc, .prefix_dec, .postfix_dec => data.lhs,
        else => .none,
    };
}

/// Determine whether `identifier` is evaluated AFTER the given write in
/// execution order — i.e. whether the write's new value could be observed
/// by this read. Mirrors ESLint's `isIdentifierEvaluatedAfterAssignment`.
inline fn isEvaluatedAfter(ctx: *const LintContext, w: RefInfo, ident: RefInfo) bool {
    if (ident.byte_start < w.byte_end) return false;
    // For x = expr or let x = expr: the RHS is evaluated BEFORE the
    // write. If the identifier is anywhere inside the RHS-range, it's
    // evaluated before the write.
    const rhs = assignRhsRange(ctx, w.assign_node);
    if (rhs != .none and isDescendantOf(ctx, ident.node, rhs)) return false;
    return true;
}

/// Forward-walk algorithm: ports ESLint's no-useless-assignment per-write
/// liveness check. For each write, BFS through reachable segments looking
/// for a read of the same symbol that isn't intercepted by another write.
fn analyzeSymbolCpLocal(
    ctx: *const LintContext,
    cpa: *const CpLocalAdj,
    sym_arena: *std.heap.ArenaAllocator,
    sym_id: SymbolId,
    sym_var_scope: @import("../../../parser/scope.zig").ScopeId,
    has_captured_read: bool,
) void {
    if (has_captured_read) return;

    const symbols = ctx.symbols();
    const refs = ctx.references();
    const ref_by_sym = ctx.semantic.ref_by_sym;
    // NOTE: do NOT reset sym_arena here — `cpa` was allocated from it for
    // this CP group and must outlive every analyzeSymbol call in the group.
    const alloc = sym_arena.allocator();

    const cp_seg_count = cpa.cp_seg_count;
    const seg_to_local = cpa.seg_to_local;
    const succ_start = cpa.succ_start;
    const succ_local = cpa.succ_local;
    const var_scope_of = cpa.var_scope_of;
    const sym_var_scope_int: u32 = @intFromEnum(sym_var_scope);

    const ref_range = symbols.getRefRange(sym_id);
    const sym_enclosing_fn = bindingEnclosingFunction(ctx, symbols.getDeclNode(sym_id));

    // Phase 1: collect in-scope refs into RefInfo records.
    var writes: std.ArrayList(RefInfo) = .empty;
    var reads: std.ArrayList(RefInfo) = .empty;
    var r_idx = ref_range.start;
    while (r_idx < ref_range.end) : (r_idx += 1) {
        const ref_id = ref_by_sym[r_idx];
        const ref_scope = refs.getScope(ref_id);
        if (var_scope_of[@intFromEnum(ref_scope)] != sym_var_scope_int) continue;
        const ref_node = refs.getNode(ref_id);
        if (enclosingFunction(ctx, ref_node) != sym_enclosing_fn) continue;
        const seg_id = refs.getSegId(ref_id);
        if (seg_id == NONE_SEG or seg_id >= seg_to_local.len) continue;
        const li = seg_to_local[seg_id];
        if (li >= cp_seg_count) continue;
        const kind = refs.getKind(ref_id);
        const node = ref_node;
        const main_tok = ctx.nodeMainToken(node);
        const byte_start = ctx.tokenStart(main_tok);
        const byte_end = byte_start + ctx.tokenLen(main_tok);

        const is_write = kind == .write or kind == .write_init or kind == .read_write;
        const is_read = kind == .read or kind == .type_of or kind == .type_read or kind == .read_write;

        const assign_node: NodeIndex = if (is_write) findAssignNode(ctx, node) else .none;

        const info: RefInfo = .{
            .ref_id = ref_id,
            .kind = kind,
            .local_seg = li,
            .byte_start = byte_start,
            .byte_end = byte_end,
            .node = node,
            .assign_node = assign_node,
        };
        if (is_write) writes.append(alloc, info) catch return;
        if (is_read) reads.append(alloc, info) catch return;
    }

    if (writes.items.len == 0 or reads.items.len == 0) return;

    // Scratch BFS buffers — sized to cp_seg_count, reused across writes.
    const visited = alloc.alloc(bool, cp_seg_count) catch return;
    // Queue uses `enqueued` to dedupe at enqueue time (taking the union
    // of prev_targets-inversion and next_targets can produce duplicate
    // edges between the same pair of segments).
    const queue = alloc.alloc(u32, cp_seg_count) catch return;
    const enqueued = alloc.alloc(bool, cp_seg_count) catch return;

    // Phase 2: per-write forward walk.
    for (writes.items) |w| {
        if (isInTryBody(ctx, w.node)) continue;
        if (!ctx.nodeReachable(w.node)) continue;

        // Find the earliest other write in w's segment that overwrites w.
        // Two ways to overwrite:
        //   (A) Sequential: w2 appears after w in source AND is not inside
        //       w's RHS (e.g. `x = 1; x = 2;` — the second overwrites).
        //   (B) Enclosing: w2's assign_node encloses w's assign_node, so
        //       w fires while evaluating w2's RHS, then w2 overwrites it
        //       (e.g. `x = x++` — the outer `x =` overwrites `x++`'s write).
        var next_write_in_seg: ?RefInfo = null;
        for (writes.items) |w2| {
            if (w2.ref_id == w.ref_id) continue;
            if (w2.local_seg != w.local_seg) continue;
            // Conditional writes inside a destructuring default (`b = (x = 2)`)
            // fire only when the source property is `undefined` — they cannot
            // be treated as unconditional overwrites of sibling bindings.
            if (isInDestructuringDefault(ctx, w2.node)) continue;
            // Enclosing-overwrite: w fires while evaluating w2's RHS, then
            // w2 overwrites it (e.g. `x = x++` — inner x++ is in outer's RHS).
            // Tightened: require w.assign_node to be inside w2's RHS-eval,
            // not merely inside w2.assign_node — destructuring `let {b=(a=2)}`
            // has both bindings under the declarator, but they are sequential
            // siblings, not nested overwrites.
            const w2_rhs = assignRhsRange(ctx, w2.assign_node);
            const is_enclosing = w.assign_node != .none and w2_rhs != .none and
                w.assign_node != w2.assign_node and
                (w.assign_node == w2_rhs or isDescendantOf(ctx, w.assign_node, w2_rhs));
            if (is_enclosing) {
                next_write_in_seg = w2;
                break;
            }
            if (w2.byte_start <= w.byte_end) continue;
            const w_rhs = assignRhsRange(ctx, w.assign_node);
            if (w_rhs != .none and isDescendantOf(ctx, w2.node, w_rhs)) continue;
            if (next_write_in_seg) |nw| {
                if (w2.byte_start < nw.byte_start) next_write_in_seg = w2;
            } else {
                next_write_in_seg = w2;
            }
        }

        // Per-read check — exactly mirrors ESLint's structure: for each
        // read, decide whether it uses this write.
        var used = false;
        for (reads.items) |rd| {
            // Case 1: same-seg read evaluated after w
            if (rd.local_seg == w.local_seg and isEvaluatedAfter(ctx, w, rd)) {
                // If a same-seg overwrite happens before this read, the
                // read sees the overwrite — not w.
                if (next_write_in_seg) |nw| {
                    if (isEvaluatedAfter(ctx, nw, rd)) continue;
                }
                used = true;
                break;
            }

            // Case 2: same-seg overwrite present — this read can't be in
            // w's segment after w (case 1 covered that). Any forward
            // reachability would see the overwrite first, UNLESS the read
            // is inside the overwrite's RHS (i.e., evaluated before the
            // overwrite fires). Walk the BFS and look for the read.
            //
            // Case 3: no same-seg overwrite — walk forward looking for r.
            //
            // Both cases use the same forward BFS, but case 2 additionally
            // requires the found read to be inside next_write_in_seg's
            // assign_node (so it's evaluated before the overwrite fires).
            @memset(visited, false);
            @memset(enqueued, false);
            var q_lo: u32 = 0;
            var q_hi: u32 = 0;
            for (succ_local[succ_start[w.local_seg]..succ_start[w.local_seg + 1]]) |succ| {
                if (enqueued[succ]) continue;
                if (q_hi >= cp_seg_count) break;
                enqueued[succ] = true;
                queue[q_hi] = succ;
                q_hi += 1;
            }
            // Also seed loop back-edges from w's own seg — when the write is
            // immediately followed by `continue` or sits at a loop body end,
            // the only way to a next-iter read is via the loop back-edge.
            {
                const lns0 = cpa.loop_next_start[w.local_seg];
                const lne0 = cpa.loop_next_start[w.local_seg + 1];
                for (cpa.loop_next_local[lns0..lne0]) |succ| {
                    if (enqueued[succ]) continue;
                    if (q_hi >= cp_seg_count) break;
                    enqueued[succ] = true;
                    queue[q_hi] = succ;
                    q_hi += 1;
                }
            }

            var found_in_walk = false;
            while (q_lo < q_hi) {
                const s = queue[q_lo];
                q_lo += 1;
                if (visited[s]) continue;
                visited[s] = true;

                // ESLint-style: is r within seg s's source range? Use the
                // first/last identifier byte of any reference in seg s.
                // This is broader than `rd.local_seg == s` and matches reads
                // whose ezlint seg-id differs from s but whose byte falls
                // within s's identifier-spanned range (e.g. RHS of an
                // assignment in a separate segment from its LHS).
                const s_global = cpa.cp_segs[s];
                const s_first = cpa.seg_first_byte[s_global];
                const s_last = cpa.seg_last_byte[s_global];
                const r_in_s_range = s_first != std.math.maxInt(u32) and
                    rd.byte_start >= s_first and rd.byte_end <= s_last;

                if (r_in_s_range) {
                    // Find the FIRST assignment to our symbol in this seg
                    // (by source order). It's the "subseg.assignment" in
                    // ESLint terms.
                    var first_assign_in_s: ?RefInfo = null;
                    for (writes.items) |w2| {
                        if (w2.local_seg != s) continue;
                        if (w2.ref_id == w.ref_id) continue;
                        if (isInDestructuringDefault(ctx, w2.node)) continue;
                        if (first_assign_in_s) |fa| {
                            if (w2.byte_start < fa.byte_start) first_assign_in_s = w2;
                        } else {
                            first_assign_in_s = w2;
                        }
                    }
                    // r uses w iff there's no intervening assignment that
                    // r is past in execution order.
                    var consumed = false;
                    if (first_assign_in_s) |fa| {
                        if (isEvaluatedAfter(ctx, fa, rd)) consumed = true;
                    }
                    if (!consumed) {
                        // Same-seg overwrite gate (case 2 from earlier):
                        // when w has a same-seg next_write, r only uses w
                        // when r is inside next_write's RHS evaluation.
                        if (next_write_in_seg) |nw| {
                            if (nw.assign_node != .none and
                                isDescendantOf(ctx, rd.node, nw.assign_node))
                            {
                                found_in_walk = true;
                            }
                        } else {
                            found_in_walk = true;
                        }
                    }
                    if (found_in_walk) break;
                }

                // Continue walking if no write to this symbol exists in s
                // (otherwise the write kills any further propagation).
                var has_write_in_s = false;
                var write_in_s: ?RefInfo = null;
                for (writes.items) |w2| {
                    if (w2.local_seg != s) continue;
                    if (w2.ref_id == w.ref_id) continue;
                    if (isInDestructuringDefault(ctx, w2.node)) continue;
                    has_write_in_s = true;
                    if (write_in_s) |existing| {
                        if (w2.byte_start < existing.byte_start) write_in_s = w2;
                    } else {
                        write_in_s = w2;
                    }
                }
                // Even when the in-seg write would otherwise kill propagation,
                // any read of our symbol that sits INSIDE the in-seg write's
                // RHS-eval evaluates BEFORE the in-seg write fires — so it
                // uses w, not the in-seg write. The RHS may span successor
                // segs (e.g. ternaries, short-circuits), and a strict BFS
                // would never reach those.
                if (has_write_in_s) {
                    if (write_in_s) |wis| {
                        if (wis.assign_node != .none and isDescendantOf(ctx, rd.node, wis.assign_node)) {
                            // next_write_in_seg gate (case 2): when w has a
                            // same-seg overwrite, r must be inside its RHS.
                            if (next_write_in_seg) |nw| {
                                if (nw.assign_node != .none and
                                    isDescendantOf(ctx, rd.node, nw.assign_node))
                                {
                                    found_in_walk = true;
                                }
                            } else {
                                found_in_walk = true;
                            }
                            if (found_in_walk) break;
                        }
                    }
                }
                if (!has_write_in_s) {
                    for (succ_local[succ_start[s]..succ_start[s + 1]]) |succ| {
                        if (enqueued[succ]) continue;
                        if (q_hi >= cp_seg_count) break;
                        enqueued[succ] = true;
                        queue[q_hi] = succ;
                        q_hi += 1;
                    }
                    // Loop back-edges from `seg_loop` events.
                    const lns = cpa.loop_next_start[s];
                    const lne = cpa.loop_next_start[s + 1];
                    for (cpa.loop_next_local[lns..lne]) |succ| {
                        if (enqueued[succ]) continue;
                        if (q_hi >= cp_seg_count) break;
                        enqueued[succ] = true;
                        queue[q_hi] = succ;
                        q_hi += 1;
                    }
                }
            }

            if (found_in_walk) {
                used = true;
                break;
            }
        }

        if (used) continue;

        // Dead write — report (subject to read_write's dead-for-update gate).
        if (w.kind == .read_write and isInDeadForLoopUpdate(ctx, w.node)) continue;
        ctx.report(w.node);
    }
}

/// Walk parent chain to find the enclosing function-like node for `node`.
/// Returns `.none` if `node` is at module/script top level.
fn enclosingFunction(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    var cur = node;
    var depth: u32 = 0;
    while (depth < 64) : (depth += 1) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return .none;
        switch (ctx.nodeTag(parent)) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .method_def, .computed_method_def,
            .getter_def, .setter_def,
            .computed_getter_def, .computed_setter_def,
            .static_block,
            => return parent,
            else => cur = parent,
        }
    }
    return .none;
}

/// Like enclosingFunction, but returns the function in whose scope the BINDING
/// lives — not the function inside which the binding's declaration node sits.
/// They differ for function declarations: `function foo() {}` hoists `foo` to
/// the enclosing function's scope, but the declaration node lives inside its
/// own function body, so a naive enclosingFunction(decl) returns the wrong fn.
fn bindingEnclosingFunction(ctx: *const LintContext, decl_node: NodeIndex) NodeIndex {
    if (decl_node == .none) return .none;
    var start = decl_node;
    // If decl_node is the NAME identifier of a function declaration, the
    // binding is hoisted to the outer scope — step past the fn_decl. Params
    // and inner declarations stay inside the fn_decl's own scope, so we
    // only skip when decl_node IS the function's name child.
    const parent = ctx.parentOf(start);
    if (parent != .none) {
        switch (ctx.nodeTag(parent)) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
                const pdata = ctx.nodeData(parent);
                const fn_data = ctx.extraData(@import("../../../parser/ast.zig").FnData, @intFromEnum(pdata.lhs));
                if (fn_data.name == start) start = parent;
            },
            else => {},
        }
    }
    return enclosingFunction(ctx, start);
}

fn isInDeadForLoopUpdate(ctx: *const LintContext, node: NodeIndex) bool {
    var current = node;
    var depth: u32 = 0;
    while (depth < 12) : (depth += 1) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return false;
        if (ctx.nodeTag(parent) == .for_stmt) {
            const pdata = ctx.nodeData(parent);
            const for_data = ctx.extraData(ast.ForData, @intFromEnum(pdata.lhs));
            if (for_data.update == .none) return false;
            const in_update = for_data.update == node or isDescendantOf(ctx, node, for_data.update);
            if (!in_update) return false;
            return !ctx.loopBodyCanIterate(parent);
        }
        current = parent;
    }
    return false;
}

fn isInTryBody(ctx: *const LintContext, node: NodeIndex) bool {
    var current = node;
    var depth: u32 = 0;
    while (depth < 16) : (depth += 1) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return false;
        switch (ctx.nodeTag(parent)) {
            .catch_clause => return false,
            .try_stmt => return true,
            else => current = parent,
        }
    }
    return false;
}

fn isDescendantOf(ctx: *const LintContext, node: NodeIndex, ancestor: NodeIndex) bool {
    var current = node;
    var depth: u32 = 0;
    while (depth < 16) : (depth += 1) {
        current = ctx.parentOf(current);
        if (current == .none) return false;
        if (current == ancestor) return true;
    }
    return false;
}

fn isExportedSymbol(ctx: *const LintContext, sym_id: SymbolId) bool {
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const ref_by_sym = ctx.semantic.ref_by_sym;

    // Check if declaration is directly under an export statement
    const decl_node = symbols.getDeclNode(sym_id);
    if (decl_node != .none) {
        var p = ctx.parentOf(decl_node);
        var depth: u32 = 0;
        while (p != .none and depth < 5) : (depth += 1) {
            switch (ctx.nodeTag(p)) {
                .export_named, .export_default_fn, .export_default_class, .export_default_expr => return true,
                else => p = ctx.parentOf(p),
            }
        }
    }

    // Check if any reference to this symbol is inside an export specifier (export { foo })
    const ref_range = symbols.getRefRange(sym_id);
    var r = ref_range.start;
    while (r < ref_range.end) : (r += 1) {
        const ref_id = ref_by_sym[r];
        const ref_node = refs.getNode(ref_id);
        const p = ctx.parentOf(ref_node);
        if (p == .none) continue;
        const ptag = ctx.nodeTag(p);
        if (ptag == .export_specifier) return true;
        // Also check one level up (export_named contains export_specifiers)
        const pp = ctx.parentOf(p);
        if (pp != .none and ctx.nodeTag(pp) == .export_named) {
            if (ptag == .export_specifier or ptag == .identifier) return true;
        }
    }

    return false;
}

/// Parse `/* exported foo, bar */` block-comment directives. ESLint sets
/// `variable.eslintUsed` for these names — we mirror that by populating a
/// hash set. Only `/* */` block comments count; line comments and the literal
/// "exported " in strings/JSDoc/code do NOT.
fn collectExportedDirectives(source: []const u8, set: *std.StringHashMap(void)) void {
    var i: usize = 0;
    while (i + 1 < source.len) {
        if (source[i] != '/' or source[i + 1] != '*') {
            i += 1;
            continue;
        }
        const body_start = i + 2;
        const end_off = std.mem.indexOfPos(u8, source, body_start, "*/") orelse return;
        const body = source[body_start..end_off];
        i = end_off + 2;

        // Trim leading whitespace + `*` (JSDoc-style padding).
        var j: usize = 0;
        while (j < body.len and (body[j] == ' ' or body[j] == '\t' or body[j] == '\n' or body[j] == '\r' or body[j] == '*')) j += 1;
        const directive = "exported";
        if (j + directive.len > body.len) continue;
        if (!std.mem.eql(u8, body[j .. j + directive.len], directive)) continue;
        // "exported" must be followed by whitespace, not be a prefix of a longer word.
        const after_dir = j + directive.len;
        if (after_dir >= body.len) continue;
        const c0 = body[after_dir];
        if (c0 != ' ' and c0 != '\t' and c0 != '\n' and c0 != '\r') continue;

        // Parse comma-separated identifier list from the rest of the body.
        var k: usize = after_dir;
        while (k < body.len) {
            while (k < body.len and (body[k] == ' ' or body[k] == '\t' or body[k] == '\n' or body[k] == '\r' or body[k] == ',')) k += 1;
            if (k >= body.len) break;
            if (!isIdentChar(body[k])) break;
            const name_start = k;
            while (k < body.len and isIdentChar(body[k])) k += 1;
            set.put(body[name_start..k], {}) catch {};
        }
    }
}

inline fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}
