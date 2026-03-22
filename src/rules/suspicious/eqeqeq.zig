const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal };

pub const meta = RuleMeta{
    .name = "eqeqeq",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require the use of === and !== instead of == and !=",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag == .equal) {
        ctx.report(node, meta.name, "Expected '===' but found '=='. Use strict equality", meta.default_severity);
    } else if (tag == .not_equal) {
        ctx.report(node, meta.name, "Expected '!==' but found '!='. Use strict inequality", meta.default_severity);
    }
}
