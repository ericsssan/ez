const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-negation",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow negating the left operand of relational operators",
};

pub const relevant_tags = [_]Node.Tag{ .instanceof_expr, .in_expr };

const msg_instanceof = "Unexpected negation of left operand of 'instanceof' operator. Use '!(a instanceof b)' instead";
const msg_in = "Unexpected negation of left operand of 'in' operator. Use '!(a in b)' instead";

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;

    if (lhs == .none) return;

    if (ctx.nodeTag(lhs) == .logical_not) {
        ctx.report(node);
    }
}
