const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.delete_expr};

pub const meta = RuleMeta{
    .name = "no-delete-var",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow deleting variables",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const operand = data.lhs;

    if (operand == .none) return;

    if (ctx.nodeTag(operand) == .identifier) {
        ctx.report(node, meta.name, "Variables should not be deleted.", meta.default_severity);
    }
}
