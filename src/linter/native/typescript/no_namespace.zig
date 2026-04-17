const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.ts_namespace_decl};

pub const meta = RuleMeta{
    .name = "no-namespace",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow TypeScript namespaces",
    .lang = .ts_only,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node);
}
