const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-array-delete",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow using the `delete` operator on array elements",
};

pub const relevant_tags = [_]Node.Tag{.delete_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const operand = data.lhs;
    if (operand == .none) return;

    // Flag `delete arr[numericIndex]` — computed member access with numeric key
    if (ctx.nodeTag(operand) == .computed_member_expr) {
        const member_data = ctx.nodeData(operand);
        const key = member_data.rhs;
        if (key == .none) return;
        if (ctx.nodeTag(key) == .number_literal) {
            ctx.report(node);
        }
    }
}
