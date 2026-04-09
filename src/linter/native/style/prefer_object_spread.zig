const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-object-spread",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `Object.assign` with an object literal as the first argument",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Must be `Object.assign`
    if (ctx.nodeTag(callee) != .member_expr) return;
    const member_data = ctx.nodeData(callee);
    const obj = member_data.lhs;
    if (obj == .none or member_data.rhs == .none) return;
    if (ctx.nodeTag(obj) != .identifier) return;

    const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
    if (!std.mem.eql(u8, obj_name, "Object")) return;

    const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));
    if (!std.mem.eql(u8, prop_name, "assign")) return;

    // First argument must be an object literal `{}`
    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len < 2) return; // Object.assign needs at least 2 args

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) return;
    if (ctx.nodeTag(first_arg) == .object_literal) {
        ctx.report(node);
    }
}
