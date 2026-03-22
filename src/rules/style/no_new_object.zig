const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub const meta = RuleMeta{
    .name = "no-new-object",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new Object()`; use object literal notation",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (std.mem.eql(u8, name, "Object")) {
        ctx.report(node, meta.name, "Do not use the Object constructor; use object literal notation instead", meta.default_severity);
    }
}
