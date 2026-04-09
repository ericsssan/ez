const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.number_literal};

pub const meta = RuleMeta{
    .name = "no-floating-decimal",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow leading or trailing decimal points in numeric literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    if (text.len == 0) return;

    if (text[0] == '.') {
        ctx.report(node);
    } else if (text[text.len - 1] == '.') {
        ctx.report(node);
    }
}
