// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: consistent-date-clone
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/consistent-date-clone.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-date-clone",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer passing `Date` directly to the constructor when cloning.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    consistent_date_clone_error,
};

fn nodeArgsCount(c: *const LintContext, n: NodeIndex) usize {
    if (n == .none) return 0;
    const d = c.nodeData(n);
    if (d.rhs == .none) return 0;
    const sr = c.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return c.extraSlice(sr).len;
}

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
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
    if (!(((ctx.nodeTag(node) == .new_expr) and (nodeArgsCount(ctx, node) == 1) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Date")))) {
        return;
    }
    if (!(((ctx.nodeTag(nodeArgAt(ctx, node, 0)) == .call_expr) and (nodeArgsCount(ctx, nodeArgAt(ctx, node, 0)) == 0) and (ctx.nodeTag(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs) == .member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs).rhs)), "getTime")))) {
        return;
    }
    ctx.reportSpanWithFixAndMessageId(.{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs).rhs).start, .end = ctx.nodeSpan(nodeArgAt(ctx, node, 0)).end }, .{ .start = ctx.ast.tokenStart((ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs).rhs) - 1)), .end = ctx.nodeSpan(nodeArgAt(ctx, node, 0)).end }, "", "consistent-date-clone/error");
    return;
}
