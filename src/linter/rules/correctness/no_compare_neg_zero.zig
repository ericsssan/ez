const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal, .strict_equal, .strict_not_equal };

pub const meta = RuleMeta{
    .name = "no-compare-neg-zero",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow comparing against -0",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    if (isNegZero(data.lhs, ctx) or isNegZero(data.rhs, ctx)) {
        ctx.report(node, meta.name, "Do not use the `===` operator to compare against -0, use `Object.is(x, -0)` instead", meta.default_severity);
    }
}

fn isNegZero(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    if (ctx.nodeTag(idx) != .unary_minus) return false;

    const operand = ctx.nodeData(idx).lhs;
    if (operand == .none) return false;
    if (ctx.nodeTag(operand) != .number_literal) return false;

    const text = ctx.tokenText(ctx.nodeMainToken(operand));
    return std.mem.eql(u8, text, "0");
}

