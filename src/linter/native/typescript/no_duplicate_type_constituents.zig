// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-duplicate-type-constituents
//
// Reports duplicate constituents within union/intersection types:
// `string | string`, `Foo & Foo`, etc.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-type-constituents",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow duplicate constituents of union or intersection types",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_union_type, .ts_intersection_type };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    // Honor ignoreUnions / ignoreIntersections options.
    if (tag == .ts_union_type and optionBool(ctx, "ignoreUnions", false)) return;
    if (tag == .ts_intersection_type and optionBool(ctx, "ignoreIntersections", false)) return;
    // Skip when this node is itself a constituent of an outer union/
    // intersection of the same kind — only the outermost reports.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == tag) return;
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    // Flatten nested same-kind unions to compare leaves.
    var leaves_buf: [32]NodeIndex = undefined;
    var n: usize = 0;
    collectLeaves(node, &leaves_buf, &n, ctx);
    if (n < 2) return;
    // O(n^2) pair check — n is bounded.
    var i: usize = 1;
    while (i < n) : (i += 1) {
        // Skip when this constituent's resolved type is `error` —
        // TS treats unresolved names as different non-equivalent
        // error types, so we shouldn't equate them.
        if (typeNodeIsError(leaves_buf[i], ctx)) continue;
        var j: usize = 0;
        while (j < i) : (j += 1) {
            if (typeNodeIsError(leaves_buf[j], ctx)) continue;
            if (typeNodesEqual(leaves_buf[j], leaves_buf[i], ctx)) {
                ctx.reportWithMessageId(leaves_buf[i], "duplicate");
                break;
            }
        }
    }
}

fn typeNodeIsError(node: NodeIndex, ctx: *const LintContext) bool {
    const tid = ctx.resolveTypeAnnotationNode(node);
    return ctx.typeIdIsError(tid);
}

fn collectLeaves(node: NodeIndex, buf: *[32]NodeIndex, n: *usize, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) == tag) {
            collectLeaves(m, buf, n, ctx);
        } else if (n.* < buf.len) {
            buf[n.*] = m;
            n.* += 1;
        }
    }
}

/// True when two TS type nodes are structurally equivalent.  Compares
/// tags + main_token text + recursively compares children.  Falls back
/// to textual comparison via source spans when a node has no
/// recursive children we model.
fn typeNodesEqual(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == b) return true;
    if (a == .none or b == .none) return false;
    const at = ctx.nodeTag(a);
    const bt = ctx.nodeTag(b);
    if (at != bt) return false;
    switch (at) {
        // Compare the inner type and recurse.
        .ts_parenthesized_type => return typeNodesEqual(ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, ctx),
        .ts_array_type => return typeNodesEqual(ctx.nodeData(a).lhs, ctx.nodeData(b).lhs, ctx),
        .ts_type_reference => {
            const an = ctx.tokenText(ctx.nodeMainToken(a));
            const bn = ctx.tokenText(ctx.nodeMainToken(b));
            if (!std.mem.eql(u8, an, bn)) return false;
            // Compare type args if any.
            const a_args = ctx.nodeData(a).rhs;
            const b_args = ctx.nodeData(b).rhs;
            if (a_args == .none and b_args == .none) return true;
            if (a_args == .none or b_args == .none) return false;
            const a_range = ctx.extraData(ast.SubRange, @intFromEnum(a_args));
            const b_range = ctx.extraData(ast.SubRange, @intFromEnum(b_args));
            const a_len = a_range.end - a_range.start;
            const b_len = b_range.end - b_range.start;
            if (a_len != b_len) return false;
            if (a_range.end > ctx.ast.extra_data.len or b_range.end > ctx.ast.extra_data.len) return false;
            const a_slice = ctx.ast.extra_data[a_range.start..a_range.end];
            const b_slice = ctx.ast.extra_data[b_range.start..b_range.end];
            for (a_slice, b_slice) |aa, bb| {
                const an_arg: NodeIndex = @enumFromInt(aa);
                const bn_arg: NodeIndex = @enumFromInt(bb);
                if (!typeNodesEqual(an_arg, bn_arg, ctx)) return false;
            }
            return true;
        },
        .ts_union_type, .ts_intersection_type => {
            // For nested unions/intersections, compare as sets (since
            // order doesn't matter semantically).
            const a_data = ctx.nodeData(a);
            const b_data = ctx.nodeData(b);
            const as = @intFromEnum(a_data.lhs);
            const ae = @intFromEnum(a_data.rhs);
            const bs = @intFromEnum(b_data.lhs);
            const be = @intFromEnum(b_data.rhs);
            if ((ae - as) != (be - bs)) return false;
            if (ae > ctx.ast.extra_data.len or be > ctx.ast.extra_data.len) return false;
            // Order-insensitive: each in `a` must have a match in `b`.
            const av = ctx.ast.extra_data[as..ae];
            const bv = ctx.ast.extra_data[bs..be];
            for (av) |raw_a| {
                const na: NodeIndex = @enumFromInt(raw_a);
                var matched = false;
                for (bv) |raw_b| {
                    const nb: NodeIndex = @enumFromInt(raw_b);
                    if (typeNodesEqual(na, nb, ctx)) { matched = true; break; }
                }
                if (!matched) return false;
            }
            return true;
        },
        // For everything else, compare textual source span.
        else => return textuallyEqual(a, b, ctx),
    }
}

fn optionBool(ctx: *const LintContext, key: []const u8, default_value: bool) bool {
    const opts = ctx.rule_options orelse return default_value;
    if (opts.* != .object) return default_value;
    const v = opts.object.get(key) orelse return default_value;
    if (v != .bool) return default_value;
    return v.bool;
}

fn textuallyEqual(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    const a_sp = ctx.nodeSpan(a);
    const b_sp = ctx.nodeSpan(b);
    const src = ctx.ast.source;
    if (a_sp.end > src.len or b_sp.end > src.len) return false;
    return std.mem.eql(u8, src[a_sp.start..a_sp.end], src[b_sp.start..b_sp.end]);
}
