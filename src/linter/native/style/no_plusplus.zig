const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec };
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-plusplus",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the unary `++` and `--` operators",
};

/// Check if `node` is in the afterthought (update) of a for loop.
/// Walks up through sequence_expr and grouping_expr.
fn isForLoopAfterthought(node: NodeIndex, ctx: *const LintContext) bool {
    var current = node;
    var depth: u32 = 0;
    while (current != .none and depth < 10) : (depth += 1) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return false;
        const parent_tag = ctx.nodeTag(parent);
        if (parent_tag == .for_stmt) {
            // Check if `current` is the update expression (not the body or init/cond).
            const data = ctx.nodeData(parent);
            const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            // The body is data.rhs. If current is in the update path, not the body.
            if (current == data.rhs) return false; // this is the body
            // Check if current is the update (or in the update).
            // The update is for_data.update. If current is in the update chain, return true.
            if (isAncestorOrSelf(for_data.update, current, ctx, 0)) return true;
            return false;
        }
        // Can walk through sequence_expr and grouping without leaving update context.
        if (parent_tag == .sequence_expr or parent_tag == .grouping_expr) {
            current = parent;
            continue;
        }
        return false;
    }
    return false;
}

fn isAncestorOrSelf(root: NodeIndex, target: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (root == .none or depth > 8) return false;
    if (root == target) return true;
    const tag = ctx.nodeTag(root);
    if (tag == .sequence_expr or tag == .grouping_expr) {
        const d = ctx.nodeData(root);
        if (tag == .grouping_expr) return isAncestorOrSelf(d.lhs, target, ctx, depth + 1);
        // sequence_expr: check all children
        const range = ctx.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
        for (range) |item| {
            const child: NodeIndex = @enumFromInt(item);
            if (isAncestorOrSelf(child, target, ctx, depth + 1)) return true;
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const allow_for_loop = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("allowForLoopAfterthoughts")) |v|
                if (v == .bool) break :blk v.bool;
        };
        break :blk false;
    };

    if (allow_for_loop and isForLoopAfterthought(node, ctx)) return;

    ctx.report(node);
}
