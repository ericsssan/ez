const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-process-exit",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `process.exit()`",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Callee must be `process.exit` — a member_expr
    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    const obj = member_data.lhs;
    if (obj == .none or member_data.rhs == .none) return;

    if (ctx.nodeTag(obj) != .identifier) return;

    const obj_text = ctx.tokenText(ctx.nodeMainToken(obj));
    // member_expr: rhs stores the property token index directly
    const prop_text = ctx.tokenText(@intFromEnum(member_data.rhs));

    if (std.mem.eql(u8, obj_text, "process") and std.mem.eql(u8, prop_text, "exit")) {
        ctx.report(node);
    }
}
