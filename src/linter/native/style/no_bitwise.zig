// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-bitwise
// Source rule: tests/conformance/eslint/lib/rules/no-bitwise.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-bitwise",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow bitwise operators",
};

pub const relevant_tags = [_]Node.Tag{.assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign, .equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right, .delete_expr, .void_expr, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not, .logical_not};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const BITWISE_OPERATORS = [_][]const u8{ "^", "|", "&", "<<", ">>", ">>>", "^=", "|=", "&=", "<<=", ">>=", ">>>=", "~" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign => {
            if (((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .bitwise_xor or __t == .bitwise_or or __t == .bitwise_and or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right or __t == .xor_assign or __t == .or_assign or __t == .and_assign or __t == .shl_assign or __t == .shr_assign or __t == .ushr_assign or __t == .bitwise_not); } and !(ctx.optionArrayContains("allow", ctx.tokenText(ctx.nodeMainToken(node))))) and !(((((ctx.getOptionBool("int32Hint", false) and (ctx.nodeTag(node) == .bitwise_or)) and (ctx.nodeData(node).rhs != .none)) and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and ctx.nodeNumericValueEquals(ctx.nodeData(node).rhs, 0))))) {
                ctx.reportWithMessageId(node, "unexpected");
            }
        },
        .equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right => {
            if (((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .bitwise_xor or __t == .bitwise_or or __t == .bitwise_and or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right or __t == .xor_assign or __t == .or_assign or __t == .and_assign or __t == .shl_assign or __t == .shr_assign or __t == .ushr_assign or __t == .bitwise_not); } and !(ctx.optionArrayContains("allow", ctx.tokenText(ctx.nodeMainToken(node))))) and !(((((ctx.getOptionBool("int32Hint", false) and (ctx.nodeTag(node) == .bitwise_or)) and (ctx.nodeData(node).rhs != .none)) and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and ctx.nodeNumericValueEquals(ctx.nodeData(node).rhs, 0))))) {
                ctx.reportWithMessageId(node, "unexpected");
            }
        },
        .delete_expr, .void_expr, .typeof_expr, .unary_plus, .unary_minus, .bitwise_not, .logical_not => {
            if (((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .bitwise_xor or __t == .bitwise_or or __t == .bitwise_and or __t == .shift_left or __t == .shift_right or __t == .unsigned_shift_right or __t == .xor_assign or __t == .or_assign or __t == .and_assign or __t == .shl_assign or __t == .shr_assign or __t == .ushr_assign or __t == .bitwise_not); } and !(ctx.optionArrayContains("allow", ctx.tokenText(ctx.nodeMainToken(node))))) and !(((((ctx.getOptionBool("int32Hint", false) and (ctx.nodeTag(node) == .bitwise_or)) and (ctx.nodeData(node).rhs != .none)) and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); }) and ctx.nodeNumericValueEquals(ctx.nodeData(node).rhs, 0))))) {
                ctx.reportWithMessageId(node, "unexpected");
            }
        },
        else => {},
    }
}
