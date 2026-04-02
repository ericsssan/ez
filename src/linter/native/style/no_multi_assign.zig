const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.assign};

pub const meta = RuleMeta{
    .name = "no-multi-assign",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow chained assignment expressions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const rhs = data.rhs;
    if (rhs == .none) return;

    if (ctx.nodeTag(rhs) == .assign) {
        ctx.report(node, meta.name, "Unexpected chained assignment; use separate statements", meta.default_severity);
    }
}
