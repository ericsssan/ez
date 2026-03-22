const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.with_stmt};

pub const meta = RuleMeta{
    .name = "no-with",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow with statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected use of 'with' statement", meta.default_severity);
}
