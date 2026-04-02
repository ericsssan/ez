const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-namespace-keyword",
    .category = .style,
    .default_severity = .warning,
    .description = "Require using `namespace` keyword instead of `module` for declaring namespaces",
};

pub const relevant_tags = [_]Node.Tag{.ts_module_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Use `namespace` instead of `module` to declare TypeScript namespaces", meta.default_severity);
}
