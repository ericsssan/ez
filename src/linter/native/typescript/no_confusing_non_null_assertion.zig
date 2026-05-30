// HAND-WRITTEN.
// Rule: @typescript-eslint/no-confusing-non-null-assertion
//
// Reports `a! == b`, `a! === b`, `a! != b`, `a! !== b`, `a! < b`,
// `a! > b`, `a! <= b`, `a! >= b`, `a! in b`, `a! instanceof b`, and
// `a! = b` — patterns where the trailing `!` looks confusingly like
// part of the operator.  Only the left-hand operand is checked, and
// only when its outermost expression is a ts_non_null_expr.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-confusing-non-null-assertion",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow non-null assertion in locations that may be confusing",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .equal,        .strict_equal,
    .not_equal,    .strict_not_equal,
    .assign,
    .in_expr,      .instanceof_expr,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;
    if (!leftEndsWithNonNullAssertion(lhs, ctx)) return;
    const tag = ctx.nodeTag(node);
    const id: []const u8 = switch (tag) {
        .assign => "confusingAssign",
        .in_expr, .instanceof_expr => "confusingOperator",
        else => "confusingEqual",
    };
    ctx.reportWithMessageId(node, id);
}

fn leftEndsWithNonNullAssertion(n: NodeIndex, ctx: *const LintContext) bool {
    var cur = n;
    while (true) {
        const t = ctx.nodeTag(cur);
        if (t == .ts_non_null_expr) return true;
        if (t == .grouping_expr) {
            // `(a)! ==` — but if the `!` is INSIDE the grouping it would
            // be ts_non_null_expr above; if not, the grouping itself is
            // the LHS without a trailing `!`.
            return false;
        }
        // Binary operators with a RIGHT operand we can dive into.
        const data = ctx.nodeData(cur);
        if (data.rhs == .none) return false;
        switch (t) {
            .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .equal, .strict_equal, .not_equal, .strict_not_equal,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            .logical_and, .logical_or, .nullish_coalesce,
            => cur = data.rhs,
            else => return false,
        }
    }
}
