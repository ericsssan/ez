const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "new-cap",
    .category = .style,
    .default_severity = .warning,
    .description = "Require constructor names to begin with an uppercase letter",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (name.len == 0) return;

    const first = name[0];
    if (first >= 'a' and first <= 'z') {
        ctx.report(node, meta.name, "A constructor name should start with an uppercase letter", meta.default_severity);
    }
}
