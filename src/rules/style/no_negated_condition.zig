const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};

pub const meta = RuleMeta{
    .name = "no-negated-condition",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow negated conditions in `if-else` statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const condition = data.lhs;
    if (condition == .none) return;

    if (ctx.nodeTag(condition) == .logical_not) {
        ctx.report(node, meta.name, "Unexpected negated condition; swap the if/else branches instead", meta.default_severity);
    }
}
