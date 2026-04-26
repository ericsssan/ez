const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-dynamic-delete",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow using the `delete` operator on computed member expressions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.delete_expr};

fn isStaticKey(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return switch (ctx.nodeTag(node)) {
        .string_literal, .number_literal, .boolean_literal,
        .null_literal, .bigint_literal,
        => true,
        // -7, +7: unary minus/plus on a number literal
        .unary_minus, .unary_plus => blk: {
            const d = ctx.nodeData(node);
            break :blk d.lhs != .none and ctx.nodeTag(d.lhs) == .number_literal;
        },
        // Static template literal (no substitutions)
        .template_literal => blk: {
            const d = ctx.nodeData(node);
            break :blk @intFromEnum(d.rhs) - @intFromEnum(d.lhs) == 1;
        },
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const inner_tag = ctx.nodeTag(data.lhs);
    if (inner_tag != .computed_member_expr and inner_tag != .optional_computed_member_expr) return;

    // Skip static literal keys — only dynamic expressions should be flagged.
    const key = ctx.nodeData(data.lhs).rhs;
    if (isStaticKey(key, ctx)) return;

    ctx.report(node);
}
