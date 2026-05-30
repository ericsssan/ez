// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-string-trim-start-end
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-string-trim-start-end.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-string-trim-start-end",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `String#trimStart()` / `String#trimEnd()` over `String#trimLeft()` / `String#trimRight()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prefer_string_trim_start_end,
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

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!(((ctx.nodeTag(node) == .call_expr) and (nodeArgsCount(ctx, node) == 0) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(node).lhs) == .optional_member_expr) and containsStr(&[_][]const u8{"trimLeft", "trimRight"}, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)))))) {
        return;
    }
    if ((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "trimLeft"))) {
        const __fix_text = std.fmt.allocPrint(ctx.allocator, "{s}", .{ "trimStart" }) catch return;
        defer ctx.allocator.free(__fix_text);
        ctx.reportWithFixAndMessageId(ctx.nodeData(ctx.nodeData(node).lhs).rhs, (.{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(node).lhs).rhs).start, .end = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(node).lhs).rhs).end }), __fix_text, "prefer-string-trim-start-end");
    } else {
        const __fix_text = std.fmt.allocPrint(ctx.allocator, "{s}", .{ "trimEnd" }) catch return;
        defer ctx.allocator.free(__fix_text);
        ctx.reportWithFixAndMessageId(ctx.nodeData(ctx.nodeData(node).lhs).rhs, (.{ .start = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(node).lhs).rhs).start, .end = ctx.nodeSpan(ctx.nodeData(ctx.nodeData(node).lhs).rhs).end }), __fix_text, "prefer-string-trim-start-end");
    }
    return;
}
