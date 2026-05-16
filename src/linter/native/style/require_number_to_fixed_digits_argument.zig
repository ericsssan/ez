// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: require-number-to-fixed-digits-argument
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/require-number-to-fixed-digits-argument.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "require-number-to-fixed-digits-argument",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using the digits argument with `Number#toFixed()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    require_number_to_fixed_digits_argument,
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
    if ((!(((ctx.nodeTag(node) == .call_expr) and (nodeArgsCount(ctx, node) == 0) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(node).lhs) == .optional_member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "toFixed"))) or (ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs) == .new_expr))) {
        return;
    }
    ctx.reportWithMessageId(node, "require-number-to-fixed-digits-argument");
    return;
}
