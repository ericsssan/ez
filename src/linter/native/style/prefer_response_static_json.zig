// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-response-static-json
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-response-static-json.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-response-static-json",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `Response.json()` over `new Response(JSON.stringify())`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prefer_response_static_json,
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
    if (!(((ctx.nodeTag(node) == .new_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "Response")))) {
        return;
    }
    if (!(((ctx.nodeTag(nodeArgAt(ctx, node, 0)) == .call_expr) and (nodeArgsCount(ctx, nodeArgAt(ctx, node, 0)) == 1) and (ctx.nodeTag(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs) == .member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs).rhs)), "stringify") and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs).lhs)), "JSON")))) {
        return;
    }
    ctx.reportWithMessageId(ctx.nodeData(nodeArgAt(ctx, node, 0)).lhs, "prefer-response-static-json");
    return;
}
