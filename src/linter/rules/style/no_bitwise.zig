const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    .bitwise_and,
    .bitwise_or,
    .bitwise_xor,
    .shift_left,
    .shift_right,
    .unsigned_shift_right,
    .bitwise_not,
};

pub const meta = RuleMeta{
    .name = "no-bitwise",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow bitwise operators",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Unexpected use of bitwise operator", meta.default_severity);
}
