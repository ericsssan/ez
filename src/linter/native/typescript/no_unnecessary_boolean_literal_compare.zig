const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-boolean-literal-compare",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary equality comparisons against boolean literals",
};

pub const relevant_tags = [_]Node.Tag{
    .strict_equal, .strict_not_equal, .equal, .not_equal,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs != .none and ctx.nodeTag(data.lhs) == .boolean_literal) {
        ctx.report(node);
        return;
    }
    if (data.rhs != .none and ctx.nodeTag(data.rhs) == .boolean_literal) {
        ctx.report(node);
    }
}
