const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.return_stmt};

pub const meta = RuleMeta{
    .name = "no-return-assign",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow assignment operators in `return` statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const expr = data.lhs;
    if (expr == .none) return;

    if (ctx.nodeTag(expr) == .assign) {
        ctx.report(node, meta.name, "Assignment in return statement; use a separate statement", meta.default_severity);
    }
}
