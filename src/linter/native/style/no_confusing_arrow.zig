const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-confusing-arrow",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow arrow functions where they could be confused with comparisons",
};

// Flag arrow functions with a conditional expression body (could look like >)
pub const relevant_tags = [_]Node.Tag{ .arrow_fn, .async_arrow_fn };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
    const body = arrow_data.body;

    if (body == .none) return;
    if (ctx.nodeTag(body) == .conditional) {
        ctx.report(node, meta.name, "Arrow function used ambiguously with a conditional expression.", meta.default_severity);
    }
}
