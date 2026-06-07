// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/non-nullable-type-assertion-style
//
// Reports `expr as Foo` / `<Foo>expr` where the original type is
// `Foo | null | undefined` and the asserted type is just `Foo` —
// the non-null assertion `expr!` is preferred.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("ez_checker").types;

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
    // Asserted type must NOT be nullable.
    const asserted_id = ctx.resolveTypeAnnotationNode(ty_node);
    if (ctx.typeIdIsAny(asserted_id) or ctx.typeIdContainsUnknown(asserted_id)) return;
    if (ctx.typeIdContainsNullish(asserted_id)) return;
    // Numeric-indexed access (`arr[n] as T`) — under TS strict-mode
    // `noUncheckedIndexedAccess`, `arr[n]` is `T | undefined`, so the
    // assertion `as T` is a no-op-modulo-undefined that the rule
    // flags as preferring `!`.  Detect the pattern syntactically
    // since our checker doesn't model unchecked-index widening.
    // Skip when the assertion target is an unconstrained type
    // parameter — TSe doesn't fire because `T` could still include
    // undefined, so the assertion isn't actually narrowing.
    if (isNumericIndexedAccess(expr, ctx) and
        assertedTypeExcludesUndefined(ty_node, ctx))
    {
        ctx.reportWithMessageId(node, "preferNonNullAssertion");
        return;
    }
    if (ctx.typeIdIsAny(expr_ty) or ctx.typeIdContainsUnknown(expr_ty)) return;
    // Expression's type must be a nullable form (contains null or
    // undefined as a union member).
    if (!ctx.typeIdContainsNullish(expr_ty)) return;
    // Asserted type must equal the expression's NonNullable form.
    const non_nullable = ctx.typeIdNonNullable(expr_ty);
    if (!non_nullable.eq(asserted_id)) return;
    ctx.reportWithMessageId(node, "preferNonNullAssertion");
}

/// True when `expr` is a numeric-indexed access of the form `X[N]`
/// where N is a number-typed expression.  Catches `arr[0] as T` /
/// `arr[i] as T` patterns regardless of whether the checker widens
/// the access to include undefined.
fn isNumericIndexedAccess(expr: NodeIndex, ctx: *const LintContext) bool {
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .computed_member_expr) return false;
    const d = ctx.nodeData(n);
    const idx_ty = ctx.typeOfNode(d.rhs);
    const idx_kind = ctx.typeKind(idx_ty);
    return idx_kind == .number or idx_kind == .number_literal;
}

/// True when the assertion target type definitely excludes undefined
/// — concrete primitives, references with a definite constraint, or
/// type parameters whose constraint excludes undefined.  An
/// unconstrained `T` returns false because `T` could itself be
/// undefined.
fn assertedTypeExcludesUndefined(ty_node: NodeIndex, ctx: *const LintContext) bool {
    // Type-parameter reference — its narrowing power depends on
    // the constraint.  An unconstrained `T` (declared `T`, no
    // `extends`) can itself be undefined, so the assertion isn't
    // narrowing — return false.
    if (ctx.typeParameterConstraintOf(ty_node)) |constraint| {
        const ckind = ctx.typeKind(constraint);
        if (ckind == .any or ckind == .unknown) return false;
        return !ctx.typeIdContainsUndefined(constraint);
    }
    const id = ctx.resolveTypeAnnotationNode(ty_node);
    return !ctx.typeIdContainsUndefined(id);
}

