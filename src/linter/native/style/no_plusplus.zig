const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec };

pub const meta = RuleMeta{
    .name = "no-plusplus",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the unary `++` and `--` operators",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unary operator '++/--' used; use '+= 1' or '-= 1' instead", meta.default_severity);
}
