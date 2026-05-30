// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-blob-reading-methods
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-blob-reading-methods.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-blob-reading-methods",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `Blob#arrayBuffer()` over `FileReader#readAsArrayBuffer(…)` and `Blob#text()` over `FileReader#readAsText(…)`.",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    @"error",
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
    if (!(((ctx.nodeTag(node) == .call_expr) and (nodeArgsCount(ctx, node) == 1) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr) and containsStr(&[_][]const u8{"readAsText", "readAsArrayBuffer"}, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)))))) {
        return;
    }
    ctx.reportWithMessageId(ctx.nodeData(ctx.nodeData(node).lhs).rhs, "error");
    return;
}
