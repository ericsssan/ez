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

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var current = node;
    var depth: u32 = 0;
    while (current != .none and depth < 5) : (depth += 1) {
        if (ctx.nodeTag(current) != .grouping_expr) break;
        current = ctx.nodeData(current).lhs;
    }
    return current;
}

fn isStaticString(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .string_literal) return true;
    if (tag == .template_literal) {
        const d = ctx.nodeData(node);
        return @intFromEnum(d.rhs) - @intFromEnum(d.lhs) == 1; // no substitutions
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee_raw = data.lhs;
    if (callee_raw == .none or data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len != 2) return;

    // First arg must be a string literal (or static template).
    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (!isStaticString(first_arg, ctx)) return;

    // Second arg must be a number literal (radix).
    const second_arg: NodeIndex = @enumFromInt(args[1]);
    if (second_arg == .none) return;
    if (ctx.nodeTag(second_arg) != .number_literal) return;
    const radix_text = ctx.tokenText(ctx.nodeMainToken(second_arg));
    const radix = std.fmt.parseInt(u8, radix_text, 10) catch return;
    if (radix != 2 and radix != 8 and radix != 16) return;

    // Unwrap grouping.
    const callee = unwrapGrouping(callee_raw, ctx);
    if (callee == .none) return;
    const callee_tag = ctx.nodeTag(callee);

    if (callee_tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (std.mem.eql(u8, name, "parseInt")) ctx.report(node);
        return;
    }

    if (callee_tag == .member_expr or callee_tag == .optional_member_expr) {
        const member_data = ctx.nodeData(callee);
        const obj = unwrapGrouping(member_data.lhs, ctx);
        if (obj == .none or member_data.rhs == .none) return;
        if (ctx.nodeTag(obj) != .identifier) return;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Number")) return;
        if (!std.mem.eql(u8, ctx.memberPropertyName(member_data.rhs), "parseInt")) return;
        ctx.report(node);
    }
}
