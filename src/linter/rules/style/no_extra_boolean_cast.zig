const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.logical_not};

pub const meta = RuleMeta{
    .name = "no-extra-boolean-cast",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary double-negation boolean casts (`!!x`)",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const operand = data.lhs;
    if (operand == .none) return;

    // Check if operand is also a logical_not (double negation !!x)
    if (ctx.nodeTag(operand) == .logical_not) {
        ctx.report(node, meta.name, "Unnecessary double negation (!!); value is already coerced to boolean", meta.default_severity);
    }
}
