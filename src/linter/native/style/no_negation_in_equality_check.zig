// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-negation-in-equality-check
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/no-negation-in-equality-check.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-negation-in-equality-check",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow negated expression in equality check.",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    no_negation_in_equality_check_error,
    no_negation_in_equality_check_suggestion,
};

const EQUALITY_OPERATORS = [_][]const u8{ "===", "!==", "==", "!=" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!((((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .equal or __t == .not_equal or __t == .strict_equal or __t == .strict_not_equal or __t == .less_than or __t == .greater_than or __t == .less_equal or __t == .greater_equal or __t == .instanceof_expr or __t == .in_expr or __t == .add or __t == .subtract or __t == .multiply or __t == .divide or __t == .modulo or __t == .exponentiate or __t == .bitwise_and or __t == .bitwise_or or __t == .bitwise_xor or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right); } and blk: { const __t = ctx.nodeTag(node); break :blk (__t == .strict_equal or __t == .strict_not_equal or __t == .equal or __t == .not_equal); }) and ((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and true) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not))) and !(((blk: { const __t = ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and true) and (ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs) == .logical_not)))))) {
        return;
    }
    ctx.reportSpanWithMessageId(.{ .start = ctx.ast.tokenStart(ctx.nodeMainToken(ctx.nodeData(node).lhs)), .end = ctx.tokenEnd(ctx.nodeMainToken(ctx.nodeData(node).lhs)) }, "no-negation-in-equality-check/error");
    return;
}
