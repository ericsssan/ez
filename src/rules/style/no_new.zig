const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.expression_stmt};

pub const meta = RuleMeta{
    .name = "no-new",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new` for side effects without storing the result",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const expr = data.lhs;
    if (expr == .none) return;

    if (ctx.nodeTag(expr) == .new_expr) {
        ctx.report(node, meta.name, "Do not use 'new' for side effects; store the result or use a function call", meta.default_severity);
    }
}
