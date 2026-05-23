// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/non-nullable-type-assertion-style
//
// Reports `expr as Foo` / `<Foo>expr` where the original type is
// `Foo | null | undefined` and the asserted type is just `Foo` —
// the non-null assertion `expr!` is preferred.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "non-nullable-type-assertion-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce non-null assertions over explicit type assertions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_as_expr, .ts_type_assertion };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);
    // ts_as_expr        — data.lhs = value, data.rhs = type
    // ts_type_assertion — data.lhs = type,  data.rhs = value
    const expr = if (tag == .ts_as_expr) data.lhs else data.rhs;
    const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
    if (expr == .none or ty_node == .none) return;
    // Skip `as const` — that's a different kind of assertion.
    if (ctx.nodeTag(ty_node) == .ts_type_reference and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ty_node)), "const")) return;
    const expr_ty = ctx.typeOfNode(expr);
    if (ctx.typeIdIsAny(expr_ty) or ctx.typeIdContainsUnknown(expr_ty)) return;
    // Expression's type must be a nullable form (contains null or
    // undefined as a union member).
    if (!ctx.typeIdContainsNullish(expr_ty)) return;
    // Asserted type must NOT be nullable.
    const asserted_id = ctx.resolveTypeAnnotationNode(ty_node);
    if (ctx.typeIdIsAny(asserted_id) or ctx.typeIdContainsUnknown(asserted_id)) return;
    if (ctx.typeIdContainsNullish(asserted_id)) return;
    // Asserted type must equal the expression's NonNullable form.
    const non_nullable = ctx.typeIdNonNullable(expr_ty);
    if (!non_nullable.eq(asserted_id)) return;
    ctx.reportWithMessageId(node, "preferNonNullAssertion");
}

