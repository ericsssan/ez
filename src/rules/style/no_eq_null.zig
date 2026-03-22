const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal };

pub const meta = RuleMeta{
    .name = "no-eq-null",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `== null` or `!= null` comparisons; use `===` or `!==`",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;
    const lhs_is_null = lhs != .none and ctx.nodeTag(lhs) == .null_literal;
    const rhs_is_null = rhs != .none and ctx.nodeTag(rhs) == .null_literal;
    if (lhs_is_null or rhs_is_null) {
        ctx.report(node, meta.name, "Use '===' or '!==' to compare with null", meta.default_severity);
    }
}
