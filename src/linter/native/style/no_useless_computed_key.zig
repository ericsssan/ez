const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    .computed_property,
    .computed_method_def,
    .computed_property_def,
    .computed_getter_def,
    .computed_setter_def,
};

pub const meta = RuleMeta{
    .name = "no-useless-computed-key",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary computed property keys (e.g., `{[\"x\"]: y}`)",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const key = data.lhs;
    if (key == .none) return;

    const key_tag = ctx.nodeTag(key);
    if (key_tag == .string_literal or key_tag == .number_literal) {
        ctx.report(node);
    }
}
