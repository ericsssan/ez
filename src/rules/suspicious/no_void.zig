const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.void_expr};

pub const meta = RuleMeta{
    .name = "no-void",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow void operators",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected use of 'void' operator", meta.default_severity);
}
