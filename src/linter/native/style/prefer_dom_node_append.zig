// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: prefer-dom-node-append
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/prefer-dom-node-append.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-dom-node-append",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `Node#append()` over `Node#appendChild()`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    prefer_dom_node_append,
};

const __isNodeValueNotDomNode_types__ = [_][]const u8{ "ArrayExpression", "ArrowFunctionExpression", "ClassExpression", "FunctionExpression", "Literal", "ObjectExpression", "TemplateLiteral" };

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
    if (((!(((ctx.nodeTag(node) == .call_expr) and (nodeArgsCount(ctx, node) == 1) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .member_expr or ctx.nodeTag(ctx.nodeData(node).lhs) == .optional_member_expr) and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).rhs)), "appendChild"))) or (blk: { const __tis = ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs); break :blk (__tis == .array_literal or __tis == .arrow_fn or __tis == .fn_expr or __tis == .number_literal or __tis == .string_literal or __tis == .boolean_literal or __tis == .null_literal or __tis == .regex_literal or __tis == .bigint_literal or __tis == .object_literal or __tis == .template_literal); } or ((ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs) == .identifier) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(ctx.nodeData(node).lhs).lhs)), "undefined"))))) or (blk: { const __tis = ctx.nodeTag(nodeArgAt(ctx, node, 0)); break :blk (__tis == .array_literal or __tis == .arrow_fn or __tis == .fn_expr or __tis == .number_literal or __tis == .string_literal or __tis == .boolean_literal or __tis == .null_literal or __tis == .regex_literal or __tis == .bigint_literal or __tis == .object_literal or __tis == .template_literal); } or ((ctx.nodeTag(nodeArgAt(ctx, node, 0)) == .identifier) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(nodeArgAt(ctx, node, 0))), "undefined")))))) {
        return;
    }
    ctx.reportWithMessageId(node, "prefer-dom-node-append");
    return;
}
