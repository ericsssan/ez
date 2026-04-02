const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-dynamic-delete",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow using the `delete` operator on computed member expressions",
};

pub const relevant_tags = [_]Node.Tag{.delete_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const inner_tag = ctx.nodeTag(data.lhs);
    if (inner_tag == .computed_member_expr or inner_tag == .optional_computed_member_expr) {
        ctx.report(node, meta.name, "Do not delete dynamically computed property keys", meta.default_severity);
    }
}
