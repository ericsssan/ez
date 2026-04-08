const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow ternary operators",
};

pub const relevant_tags = [_]Node.Tag{.conditional};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.report(node, meta.name, "Ternary operator used.", meta.default_severity);
}
