const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "yoda",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow Yoda conditions (literal on left side of comparison)",
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .less_than, .greater_than, .less_equal, .greater_equal,
};

fn isLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return switch (ctx.nodeTag(node)) {
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal,
        => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;

    // Flag: literal OP expression (yoda condition)
    if (isLiteral(data.lhs, ctx) and !isLiteral(data.rhs, ctx)) {
        ctx.report(node);
    }
}
