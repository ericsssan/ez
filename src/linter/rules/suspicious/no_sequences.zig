const ast = @import("../../../parser/ast.zig");
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
    // ESLint allows comma operator when explicitly wrapped in parentheses.
    // When parsed inside parens, the sequence_expr's main_token IS the '('.
    const main_tok = ctx.ast.nodeMainToken(node);
    if (ctx.ast.tokenTag(main_tok) == .l_paren) return;

    ctx.report(node, meta.name, "Unexpected use of comma operator", meta.default_severity);
}
