const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-non-null-assertion",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow extra non-null assertions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    if (ctx.nodeTag(data.lhs) == .ts_non_null_expr) {
        ctx.report(node);
    }
}
