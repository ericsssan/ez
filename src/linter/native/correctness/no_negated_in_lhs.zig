// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-negated-in-lhs
// Source rule: tests/conformance/eslint/lib/rules/no-negated-in-lhs.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-negated-in-lhs",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow negating the left operand in `in` expressions",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    negatedLHS,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((((ctx.nodeTag(node) == .in_expr) and blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); }) and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not))) {
        ctx.reportWithMessageId(node, "negatedLHS");
    }
}
