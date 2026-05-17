// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unneeded-ternary
// Source rule: tests/conformance/eslint/lib/rules/no-unneeded-ternary.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unneeded-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow ternary operators when simpler alternatives exist",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.conditional};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnecessaryConditionalExpression,
    unnecessaryConditionalAssignment,
};

fn conditionalChild(c: *const LintContext, n: NodeIndex, which: enum { consequent, alternate }) NodeIndex {
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const tag = c.nodeTag(n);
    // if_stmt: rhs = consequent directly (no alternate); if_else_stmt: rhs = IfData index
    if (tag == .if_stmt) return if (which == .consequent) d.rhs else .none;
    const idx = @intFromEnum(d.rhs);
    if (tag == .if_else_stmt) {
        const e = c.extraData(ast.IfData, idx);
        return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
    }
    const e = c.extraData(ast.Conditional, idx);
    return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((blk: { const __t = ctx.nodeTag(conditionalChild(ctx, node, .alternate)); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); } and (ctx.nodeTag(conditionalChild(ctx, node, .alternate)) == .boolean_literal)) and (blk: { const __t = ctx.nodeTag(conditionalChild(ctx, node, .consequent)); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); } and (ctx.nodeTag(conditionalChild(ctx, node, .consequent)) == .boolean_literal)))) {
        ctx.reportWithMessageId(node, "unnecessaryConditionalExpression");
    } else {
        if ((!(ctx.getOptionBool("defaultAssignment", true)) and (((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier) and (ctx.nodeTag(conditionalChild(ctx, node, .consequent)) == .identifier)) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), ctx.tokenText(ctx.nodeMainToken(conditionalChild(ctx, node, .consequent)))))))) {
            ctx.reportWithMessageId(node, "unnecessaryConditionalAssignment");
        }
    }
}
