// HAND-WRITTEN.
// Rule: @typescript-eslint/no-dynamic-delete
//
// Disallow using the `delete` operator on computed key expressions
// unless the key is a static string/number literal (or `-N` with
// a number literal argument, which normalises to an integer index).
//
// Mirrors TSe's isAcceptableIndexExpression:
//   - Literal whose value is a number or string → acceptable
//   - UnaryExpression(-) on a number literal → acceptable
//   - Everything else → fire on the property node

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-dynamic-delete",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow using the `delete` operator on computed key expressions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.delete_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const arg = ctx.nodeData(node).lhs;
    if (arg == .none) return;
    const arg_tag = ctx.nodeTag(arg);
    if (arg_tag != .computed_member_expr and arg_tag != .optional_computed_member_expr) return;
    const prop = ctx.nodeData(arg).rhs;
    if (prop == .none) return;
    if (isAcceptableIndex(prop, ctx)) return;
    ctx.reportWithMessageId(prop, "dynamicDelete");
}

fn isAcceptableIndex(node: NodeIndex, ctx: *const LintContext) bool {
    switch (ctx.nodeTag(node)) {
        .number_literal, .string_literal => return true,
        .unary_minus => {
            const inner = ctx.nodeData(node).lhs;
            if (inner == .none) return false;
            return ctx.nodeTag(inner) == .number_literal;
        },
        else => return false,
    }
}
