// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-array-flat-map
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-array-flat-map.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-array-flat-map",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `.flatMap(…)` over `.map(…).flat()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prefer_array_flat_map,
};

const ignored = [_][]const u8{ "React.Children", "Children" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

fn nodeArgsCount(c: *const LintContext, n: NodeIndex) usize {
    if (n == .none) return 0;
    const d = c.nodeData(n);
    if (d.rhs == .none) return 0;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len;
}

fn nodeArgsLenZero(c: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    const d = c.nodeData(n);
    if (d.rhs == .none) return true;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len == 0;
}

fn nodeArgAt(c: *const LintContext, n: NodeIndex, idx: u32) NodeIndex {
    if (n == .none) return .none;
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = c.extraSlice(sr);
    if (idx >= args.len) return .none;
    return @enumFromInt(args[idx]);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!(((((ctx.nodeTag(node) == .call_expr) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "flat")) and (nodeArgsLenZero(ctx, node) or (((nodeArgsCount(ctx, node) == 1) and blk: { const __t = ctx.nodeTag(nodeArgAt(ctx, node, 0)); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(nodeArgAt(ctx, node, 0))), "1"))))) and ((ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs) == .call_expr) and (ctx.nodeTag(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs) == .optional_member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).rhs)), "map"))))) {
        return;
    }
    if (blk: { break :blk (ctx.nodeTag(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs) == .member_expr and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs).rhs)), "Children") and ctx.nodeTag(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs).lhs) == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs).lhs)), "React")) or (ctx.nodeTag(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs) == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).lhs)), "Children")); }) {
        return;
    }
    {
        const __fix_text = std.fmt.allocPrint(ctx.allocator, "flatMap({s})", .{ ctx.argsTextBetweenParens(ctx.nodeData(ctx.nodeData(node).lhs).lhs) }) catch return;
        defer ctx.allocator.free(__fix_text);
        ctx.reportSpanWithFixAndMessageId(.{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).rhs).start, .end = ctx.nodeSpan(node).end }, .{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(ctx.nodeData(ctx.nodeData(node).lhs).lhs).lhs).rhs).start, .end = ctx.nodeSpan(node).end }, __fix_text, "prefer-array-flat-map");
    }
    return;
}
