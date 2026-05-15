// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-eq-null

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-eq-null",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `null` comparisons without type-checking operators",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).rhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); } and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs)), "null"))) and ((ctx.nodeTag(node) == .equal) or (ctx.nodeTag(node) == .not_equal))) or ((blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .number_literal or __t == .string_literal or __t == .boolean_literal or __t == .null_literal or __t == .regex_literal or __t == .bigint_literal); } and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "null"))) and ((ctx.nodeTag(node) == .equal) or (ctx.nodeTag(node) == .not_equal))))) {
        ctx.reportWithMessageId(node, "unexpected");
    }
}
