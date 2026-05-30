// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unsafe-negation
// Source rule: tests/conformance/eslint/lib/rules/no-unsafe-negation.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-negation",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow negating the left operand of relational operators",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    suggestNegatedExpression,
    suggestParenthesisedNegation,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((((((ctx.nodeTag(node) == .in_expr) or (ctx.nodeTag(node) == .instanceof_expr)) or (ctx.getOptionBool("enforceForOrderingRelations", false) and ((((ctx.nodeTag(node) == .less_than) or (ctx.nodeTag(node) == .greater_than)) or (ctx.nodeTag(node) == .greater_equal)) or (ctx.nodeTag(node) == .less_equal)))) and (blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not))) and !((ctx.nodeTag(ctx.parentOf(ctx.nodeData(node).lhs)) == .grouping_expr)))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.nodeSpan(ctx.nodeData(node).lhs).start, .end = ctx.nodeSpan(ctx.nodeData(node).lhs).end }, "unexpected");
    }
}
