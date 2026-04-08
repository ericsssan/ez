const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-spread",
    .category = .style,
    .default_severity = .warning,
    .description = "Require spread operators instead of `.apply()`",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Callee must be `fn.apply` — member_expr where prop is "apply"
    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    if (member_data.rhs == .none) return;

    // member_expr: rhs stores the property token index directly
    const prop_text = ctx.tokenText(@intFromEnum(member_data.rhs));
    if (!std.mem.eql(u8, prop_text, "apply")) return;

    ctx.report(node, meta.name, "Use the spread operator instead of '.apply()'.", meta.default_severity);
}
