const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub const meta = RuleMeta{
    .name = "no-non-null-assertion",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow non-null assertion `!` operator",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Non-null assertion `!` is forbidden. Use proper null checks instead.", meta.default_severity);
}
