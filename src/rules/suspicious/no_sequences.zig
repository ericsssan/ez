const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.sequence_expr};

pub const meta = RuleMeta{
    .name = "no-sequences",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow comma operators",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected use of comma operator", meta.default_severity);
}
