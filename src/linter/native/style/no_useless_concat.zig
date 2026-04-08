const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-concat",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary concatenation of literals or template literals",
};

pub const relevant_tags = [_]Node.Tag{.add};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    if (isStringLiteral(lhs, ctx) and isStringLiteral(rhs, ctx)) {
        ctx.report(node, meta.name, "Unexpected string concatenation of literals.", meta.default_severity);
    }
}

fn isStringLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    return ctx.nodeTag(node) == .string_literal;
}
