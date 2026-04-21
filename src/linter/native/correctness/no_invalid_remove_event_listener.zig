// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-invalid-remove-event-listener

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-invalid-remove-event-listener",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Prevent calling `EventTarget#removeEventListener()` with the result of an expression.",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    no_invalid_remove_event_listener,
};

const __inline_types_1__ = [_][]const u8{ "ArrowFunctionExpression", "FunctionExpression" };

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
    if (!(((((ctx.nodeTag(node) == .call_expr) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(node).lhs) == .optional_member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "removeEventListener")) and !((ctx.nodeTag(nodeArgAt(ctx, node, 0)) == .spread_element))) and (((ctx.nodeTag(nodeArgAt(ctx, node, 1)) == .fn_expr) or (ctx.nodeTag(nodeArgAt(ctx, node, 1)) == .arrow_fn)) or ((ctx.nodeTag(nodeArgAt(ctx, node, 1)) == .call_expr) and (ctx.nodeTag(ctx.nodeData(nodeArgAt(ctx, node, 1)).lhs) == .member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 1)).lhs).rhs)), "bind")))))) {
        return;
    }
    if (blk: { const __tis = ctx.nodeTag(nodeArgAt(ctx, node, 1)); break :blk (__tis == .arrow_fn or __tis == .fn_expr); }) {
        ctx.report(nodeArgAt(ctx, node, 1));
    }
    ctx.report(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 1)).lhs).rhs);
}
