const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.var_decl};

pub const meta = RuleMeta{
    .name = "no-var",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of `var`; prefer `let` or `const`",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected var, use let or const instead", meta.default_severity);
}
