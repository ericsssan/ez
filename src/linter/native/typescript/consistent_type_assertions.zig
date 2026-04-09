const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-type-assertions",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent usage of type assertions (prefer `as Type` over `<Type>expr`)",
};

pub const relevant_tags = [_]Node.Tag{.ts_type_assertion};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node);
}
