const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.labeled_stmt};

pub const meta = RuleMeta{
    .name = "no-labels",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow labeled statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node);
}
