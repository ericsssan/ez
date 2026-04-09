const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-numeric-literals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow parseInt() and Number.parseInt() in favor of binary, octal, and hexadecimal literals",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    // Need exactly 2 args: parseInt(str, radix)
    if (args.len != 2) return;

    const second_arg: NodeIndex = @enumFromInt(args[1]);
    if (second_arg == .none) return;
    if (ctx.nodeTag(second_arg) != .number_literal) return;

    const radix_text = ctx.tokenText(ctx.nodeMainToken(second_arg));
    const radix = std.fmt.parseInt(u8, radix_text, 10) catch return;
    // Only flag base-2, base-8, base-16 — those have literal syntax
    if (radix != 2 and radix != 8 and radix != 16) return;

    // Check if callee is `parseInt` or `Number.parseInt`
    const callee_tag = ctx.nodeTag(callee);
    if (callee_tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (std.mem.eql(u8, name, "parseInt")) {
            ctx.report(node);
        }
        return;
    }

    if (callee_tag == .member_expr) {
        const member_data = ctx.nodeData(callee);
        const obj = member_data.lhs;
        if (obj == .none or member_data.rhs == .none) return;
        if (ctx.nodeTag(obj) != .identifier) return;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
        if (!std.mem.eql(u8, obj_name, "Number")) return;
        const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));
        if (!std.mem.eql(u8, prop_name, "parseInt")) return;
        ctx.report(node);
    }
}
