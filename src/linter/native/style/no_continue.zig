const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .continue_stmt, .continue_label };

pub const meta = RuleMeta{
    .name = "no-continue",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of `continue` statement",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node);
}
