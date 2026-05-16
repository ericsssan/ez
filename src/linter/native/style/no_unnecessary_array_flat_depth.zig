// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unnecessary-array-flat-depth
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/no-unnecessary-array-flat-depth.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-array-flat-depth",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow using `1` as the `depth` argument of `Array#flat()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    no_unnecessary_array_flat_depth,
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
    if (!((((ctx.nodeTag(node) == .call_expr) and (nodeArgsCount(ctx, node) == 1) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(node).lhs) == .optional_member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "flat")) and ctx.nodeNumericValueEquals(nodeArgAt(ctx, node, 0), 1)))) {
        return;
    }
    ctx.reportWithFixAndMessageId(nodeArgAt(ctx, node, 0), ctx.nodeSpan(nodeArgAt(ctx, node, 0)), "", "no-unnecessary-array-flat-depth");
    return;
}
