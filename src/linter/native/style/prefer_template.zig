const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.add};

pub const meta = RuleMeta{
    .name = "prefer-template",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest using template literals instead of string concatenation",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    const lhs_is_string = lhs != .none and ctx.nodeTag(lhs) == .string_literal;
    const rhs_is_string = rhs != .none and ctx.nodeTag(rhs) == .string_literal;

    if (lhs_is_string or rhs_is_string) {
        ctx.report(node, meta.name, "Unexpected string concatenation.", meta.default_severity);
    }
}
