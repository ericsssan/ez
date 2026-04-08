const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-rest-params",
    .category = .style,
    .default_severity = .warning,
    .description = "Require rest parameters instead of `arguments`",
};

pub const relevant_tags = [_]Node.Tag{.identifier};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    if (!std.mem.eql(u8, text, "arguments")) return;
    ctx.report(node, meta.name, "Use the rest parameters instead of 'arguments'.", meta.default_severity);
}
