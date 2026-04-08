const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-exponentiation-operator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `Math.pow` in favor of the `**` operator",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Check callee is Math.pow
    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    const object = member_data.lhs;
    if (object == .none) return;
    if (ctx.nodeTag(object) != .identifier) return;

    const obj_name = ctx.tokenText(ctx.nodeMainToken(object));
    if (!std.mem.eql(u8, obj_name, "Math")) return;

    const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));
    if (std.mem.eql(u8, prop_name, "pow")) {
        ctx.report(node, meta.name, "Use the '**' operator instead of 'Math.pow'.", meta.default_severity);
    }
}
