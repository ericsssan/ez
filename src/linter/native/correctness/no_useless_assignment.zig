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

    // Collect all exported-directive names in one pass over source, then use
    // a hash set for O(1) per-symbol lookup instead of O(source) per symbol.
    var exported_set = std.StringHashMap(void).init(ctx.allocator);
    defer exported_set.deinit();
    collectExportedDirectives(source, &exported_set);

    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const sym_id = SymbolId.fromInt(i);

        // Skip binding kinds that don't apply to value assignments
        const bk = symbols.getBindingKind(sym_id);
        switch (bk) {
            .parameter,
            .catch_param,
            .import_binding,
            .type_import_binding,
            .implicit_global,
            .fn_expr_name,
            .class_expr_name,
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
        const sym_var_scope = scopes.nearestVarScope(sym_scope);

        // Check for closure reads (any read in a different var scope) and count writes
        var has_closure_read = false;
        var has_write = false;
        // A symbol with only a declaration-site write (no explicit re-assignment)
        // is an unused-variable, not a useless assignment — skip it.
        var has_explicit_write = false;
        const decl_node = symbols.getDeclNode(sym_id);
        {
            var r = ref_range.start;
            while (r < ref_range.end) : (r += 1) {
                const ref_id = ref_by_sym[r];
                const kind = refs.getKind(ref_id);
                const ref_scope = refs.getScope(ref_id);
                const ref_var_scope = scopes.nearestVarScope(ref_scope);
                if (ref_var_scope != sym_var_scope) {
                    if (kind == .read or kind == .type_of or kind == .read_write) {
                        has_closure_read = true;
                        break;
                    }
                    continue;
                }
                if (kind == .write or kind == .read_write or kind == .write_init) {
                    has_write = true;
                    if (kind != .write_init and refs.getNode(ref_id) != decl_node) has_explicit_write = true;
                }
            }
        }
        if (has_closure_read) continue;
        if (!has_write) continue;
        if (!has_explicit_write) continue;

        analyzeSymbol(ctx, &cpr, sym_id, sym_var_scope);
    }
}

fn analyzeSymbol(
    ctx: *const LintContext,
    cpr: *const code_path_mod.CodePathBuilder.Result,
    sym_id: SymbolId,
    sym_var_scope: @import("../../../parser/scope.zig").ScopeId,
) void {
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const scopes = ctx.scopes();
    const ref_by_sym = ctx.semantic.ref_by_sym;
    var arena = std.heap.ArenaAllocator.init(ctx.allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    const ref_range = symbols.getRefRange(sym_id);
    const seg_count = cpr.seg_count;

    // Find the code path for this symbol from the first same-var-scope ref
    var cp_id: CodePathId = NONE_CP;
    {
        var r = ref_range.start;
        while (r < ref_range.end) : (r += 1) {
            const ref_id = ref_by_sym[r];
            const ref_scope = refs.getScope(ref_id);
            if (scopes.nearestVarScope(ref_scope) != sym_var_scope) continue;
            const seg_id = refs.getSegId(ref_id);
            if (seg_id == NONE_SEG or seg_id >= seg_count) continue;
            cp_id = cpr.seg_codepath[seg_id];
            break;
        }
    }
    if (cp_id == NONE_CP) return;

    // Build per-segment reference lists.
    // Use two flat arrays: seg_ref_start[s] = index into flat_refs where seg s's refs begin.

    const seg_ref_count = alloc.alloc(u32, seg_count) catch return;
    @memset(seg_ref_count, 0);

    {
        var r = ref_range.start;
        while (r < ref_range.end) : (r += 1) {
            const ref_id = ref_by_sym[r];
            const ref_scope = refs.getScope(ref_id);
            if (scopes.nearestVarScope(ref_scope) != sym_var_scope) continue;
            const seg_id = refs.getSegId(ref_id);
            if (seg_id == NONE_SEG or seg_id >= seg_count) continue;
            seg_ref_count[seg_id] += 1;
        }
    }

    // Compute prefix sums
    const seg_ref_start = alloc.alloc(u32, seg_count + 1) catch return;
    seg_ref_start[0] = 0;
    for (0..seg_count) |s| {
        seg_ref_start[s + 1] = seg_ref_start[s] + seg_ref_count[s];
    }
    const total = seg_ref_start[seg_count];
    if (total == 0) return;

    const flat_refs = alloc.alloc(ReferenceId, total) catch return;
    const cursor = alloc.alloc(u32, seg_count) catch return;
    @memcpy(cursor, seg_ref_start[0..seg_count]);

    {
        var r = ref_range.start;
        while (r < ref_range.end) : (r += 1) {
            const ref_id = ref_by_sym[r];
            const ref_scope = refs.getScope(ref_id);
            if (scopes.nearestVarScope(ref_scope) != sym_var_scope) continue;
            const seg_id = refs.getSegId(ref_id);
            if (seg_id == NONE_SEG or seg_id >= seg_count) continue;
            flat_refs[cursor[seg_id]] = ref_id;
            cursor[seg_id] += 1;
        }
    }

    // Build correct successor arrays from prev_targets.
    // cpr.next_targets has non-contiguous ranges due to incremental construction;
    // prev_targets is set at segment-creation time and is always correct.
    const succ_count = alloc.alloc(u32, seg_count) catch return;
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
    const succ_start = alloc.alloc(u32, seg_count + 1) catch return;
    succ_start[0] = 0;
    for (0..seg_count) |s| succ_start[s + 1] = succ_start[s] + succ_count[s];
    const total_succ = succ_start[seg_count];
    const succ_flat = alloc.alloc(u32, if (total_succ > 0) total_succ else 1) catch return;
    const succ_cursor = alloc.alloc(u32, seg_count) catch return;
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

    // Reorder write-then-read pairs where the read is in the RHS of the same
    // assignment. This matches ESLint's eslint-scope which emits RHS reads before
    // LHS writes. For `a = expr(a)`, our parser emits write(a_LHS) then read(a_RHS)
    // in source order, but semantically the RHS read should come first.
    for (0..seg_count) |s| {
        const seg_id: u32 = @intCast(s);
        if (cpr.seg_codepath[seg_id] != cp_id) continue;
        const rstart = seg_ref_start[seg_id];
        const rend_seg = seg_ref_start[seg_id + 1];
        if (rend_seg <= rstart + 1) continue;
        var ri: u32 = rstart;
        while (ri < rend_seg - 1) : (ri += 1) {
            const ref_id = flat_refs[ri];
            if (refs.getKind(ref_id) != .write) continue;
            const next_ref_id = flat_refs[ri + 1];
            const nk = refs.getKind(next_ref_id);
            if (nk != .read and nk != .type_of and nk != .read_write) continue;
            // Check if the write is the LHS of a plain `=` assignment and the read
            // is somewhere inside that same assignment expression (i.e., the RHS).
            // Our parser emits write(LHS) before read(RHS), but ESLint scope emits
            // read(RHS) before write(LHS). Swapping fixes backward liveness order.
            const write_node = refs.getNode(ref_id);
            const assign_node = ctx.parentOf(write_node);
            if (assign_node == .none) continue;
            if (ctx.nodeTag(assign_node) != .assign) continue;
            if (isDescendantOf(ctx, refs.getNode(next_ref_id), assign_node)) {
                std.mem.swap(ReferenceId, &flat_refs[ri], &flat_refs[ri + 1]);
            }
        }
    }

    // Build supplementary back-edge map from seg_loop events.
    // `continue` statements make their segment unreachable, so the back-edge to
    // the loop header is missing from next_targets. We recover it from seg_loop events.
    const loop_next_count = alloc.alloc(u32, seg_count) catch return;
    @memset(loop_next_count, 0);
    for (cpr.events) |ev| {
        if (ev.type != .seg_loop) continue;
        if (ev.data1 < seg_count) loop_next_count[ev.data1] += 1;
    }
    const loop_next_start = alloc.alloc(u32, seg_count + 1) catch return;
    loop_next_start[0] = 0;
    for (0..seg_count) |s| loop_next_start[s + 1] = loop_next_start[s] + loop_next_count[s];
    const loop_next_total = loop_next_start[seg_count];
    const loop_next_targets = alloc.alloc(u32, loop_next_total) catch return;
    const loop_next_cursor = alloc.alloc(u32, seg_count) catch return;
    @memcpy(loop_next_cursor, loop_next_start[0..seg_count]);
    for (cpr.events) |ev| {
        if (ev.type != .seg_loop) continue;
        if (ev.data1 < seg_count and ev.data2 < seg_count) {
            loop_next_targets[loop_next_cursor[ev.data1]] = ev.data2;
            loop_next_cursor[ev.data1] += 1;
        }
    }

    // Iterative backward liveness analysis.
    // live_entry[s] = true if the variable is live at the entry of segment s.
    const live_entry = alloc.alloc(bool, seg_count) catch return;
    @memset(live_entry, false);

    const MAX_ITERS = 8;
    for (0..MAX_ITERS) |_| {
        for (0..seg_count) |s| {
            const seg_id: u32 = @intCast(s);
            if (cpr.seg_codepath[seg_id] != cp_id) continue;

            // live_exit = OR of live_entry of reachable successors + loop back-edges
            var live: bool = false;
            for (succ_flat[succ_start[seg_id]..succ_start[seg_id + 1]]) |succ| {
                if (succ < seg_count and live_entry[succ]) {
                    live = true;
                    break;
                }
            }
            if (!live) {
                const ls = loop_next_start[seg_id];
                const le = loop_next_start[seg_id + 1];
                for (loop_next_targets[ls..le]) |succ| {
                    if (succ < seg_count and live_entry[succ]) {
                        live = true;
                        break;
                    }
                }
            }

            // Walk refs in this segment backward
            const rstart = seg_ref_start[seg_id];
            const rend = seg_ref_start[seg_id + 1];
            var ri: u32 = rend;
            while (ri > rstart) {
                ri -= 1;
                switch (refs.getKind(flat_refs[ri])) {
                    .read, .type_of => live = true,
                    .write, .write_init => live = false,
                    .read_write => live = true,
                }
            }

            live_entry[seg_id] = live;
        }
    }

    // Final pass: report useless writes
    for (0..seg_count) |s| {
        const seg_id: u32 = @intCast(s);
        if (cpr.seg_codepath[seg_id] != cp_id) continue;

        var live: bool = false;
        for (succ_flat[succ_start[seg_id]..succ_start[seg_id + 1]]) |succ| {
            if (succ < seg_count and live_entry[succ]) {
                live = true;
                break;
            }
        }
        if (!live) {
            const ls = loop_next_start[seg_id];
            const le = loop_next_start[seg_id + 1];
            for (loop_next_targets[ls..le]) |succ| {
                if (succ < seg_count and live_entry[succ]) {
                    live = true;
                    break;
                }
            }
        }

        const rstart = seg_ref_start[seg_id];
        const rend = seg_ref_start[seg_id + 1];
        var ri: u32 = rend;
        while (ri > rstart) {
            ri -= 1;
            const ref_id = flat_refs[ri];
            const ref_node = refs.getNode(ref_id);
            switch (refs.getKind(ref_id)) {
                .read, .type_of => live = true,
                .write, .write_init => {
                    if (!live and ctx.nodeReachable(ref_node) and !isInTryBody(ctx, ref_node)) {
                        ctx.report(ref_node);
                    }
                    live = false;
                },
                .read_write => {
                    if (!live and ctx.nodeReachable(ref_node) and !isInTryBody(ctx, ref_node) and !isInDeadForLoopUpdate(ctx, ref_node)) {
                        ctx.report(ref_node);
                    }
                    live = true;
                },
            }
        }
    }
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

fn collectExportedDirectives(source: []const u8, set: *std.StringHashMap(void)) void {
    const needle = "exported ";
    var i: usize = 0;
    while (true) {
        const pos = std.mem.indexOfPos(u8, source, i, needle) orelse break;
        const after = pos + needle.len;
        if (after < source.len and isIdentChar(source[after])) {
            var end = after;
            while (end < source.len and isIdentChar(source[end])) end += 1;
            set.put(source[after..end], {}) catch {};
        }
        i = pos + 1;
    }
}

inline fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}
