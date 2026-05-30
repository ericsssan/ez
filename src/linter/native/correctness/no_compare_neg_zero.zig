// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-compare-neg-zero
// Source rule: tests/conformance/eslint/lib/rules/no-compare-neg-zero.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-compare-neg-zero",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow comparing against `-0`",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const OPERATORS_TO_CHECK = [_][]const u8{ ">", ">=", "<", "<=", "==", "===", "!=", "!==" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (blk: { const __t = ctx.nodeTag(node); break :blk (__t == .greater_than or __t == .greater_equal or __t == .less_than or __t == .less_equal or __t == .equal or __t == .strict_equal or __t == .not_equal or __t == .strict_not_equal); }) {
        if (((((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .unary_minus or __t == .subtract); }) and blk: { const __t = ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).lhs).lhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and ctx.nodeNumericValueEquals(ctx.nodeData(ctx.nodeData(node).lhs).lhs, 0)) or (((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .unary_minus or __t == .subtract); }) and blk: { const __t = ctx.nodeTag(ctx.nodeData(ctx.nodeData(node).rhs).lhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and ctx.nodeNumericValueEquals(ctx.nodeData(ctx.nodeData(node).rhs).lhs, 0)))) {
            ctx.reportWithMessageIdAndData(node, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "operator", .val = ctx.tokenText(ctx.nodeMainToken(node)) } });
        }
    }
}
