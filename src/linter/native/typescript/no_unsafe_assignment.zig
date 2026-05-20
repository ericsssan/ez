// HAND-WRITTEN — type-aware rule.  Does not fit the IR codegen pipeline
// because it queries the TS type checker; the IR has no type-level ops.
// Rule: @typescript-eslint/no-unsafe-assignment
//
// Reports when a value of type `any` (or a value reaching `any`) flows
// into a typed target.  Mirrors typescript-eslint's behavior:
//   * `const x: number = anyVal;`         → unsafe
//   * `const x: { a: number } = json;`    → unsafe (json is any)
//   * `const x: number[] = anyArr;`       → unsafe
//   * `arr[i] = anyVal;`                  → unsafe (array element assignment)
//
// Triggers on:
//   * variable declarator with an explicit type annotation
//   * assignment expressions where the LHS has a known declared type
//   * object literal properties whose declared shape carries non-any types
//
// We do NOT yet handle:
//   * function call arguments (that's no-unsafe-argument)
//   * function return values (that's no-unsafe-return)
//   * member expressions on any (that's no-unsafe-member-access)

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-assignment",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow assigning a value of type any to typed variables",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .declarator, .assign };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx),
        .assign => checkAssign(node, ctx),
        else => {},
    }
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return; // no initializer
    // Find the type annotation on the binding identifier (the parser
    // attaches it to identifier.data.rhs as a ts_type_annotation node).
    if (ctx.nodeTag(data.lhs) != .identifier) return;
    const binding_data = ctx.nodeData(data.lhs);
    if (binding_data.rhs == .none) return; // no annotation → no rule trigger
    if (ctx.nodeTag(binding_data.rhs) != .ts_type_annotation) return;
    const lhs_ty_node = ctx.nodeData(binding_data.rhs).lhs;
    reportIfUnsafe(node, lhs_ty_node, data.rhs, ctx);
}

fn checkAssign(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // For plain identifier assignment `x = anyVal`, look up x's binding
    // and consult its declared type via the inferred type of the LHS.
    const lhs_ty = ctx.typeOfNode(data.lhs);
    // Skip when LHS resolves to any — that's the "no rule" case.
    if (ctx.typeIdIsAny(lhs_ty)) return;
    // Skip when RHS is plainly typed (not any).
    if (!ctx.typeNodeContainsAny(data.rhs)) return;
    // Skip when RHS is plainly typed via an `as` cast OTHER than `as any`
    // — typescript-eslint suppresses no-unsafe-assignment for explicit casts.
    if (rhsIsExplicitNonAnyCast(data.rhs, ctx)) return;
    ctx.reportWithMessageId(node, "anyAssignment");
}

fn reportIfUnsafe(
    decl_node: NodeIndex,
    lhs_ty_node: NodeIndex,
    rhs: NodeIndex,
    ctx: *const LintContext,
) void {
    const lhs_ty = ctx.resolveTypeAnnotationNode(lhs_ty_node);
    if (ctx.typeIdIsAny(lhs_ty)) return; // explicit `: any` → no warning
    if (ctx.typeIdContainsAny(lhs_ty)) {
        // Declared type itself contains any (e.g. `any[]`) — the user is
        // already opting into anyness on the LHS; suppress to match TSe.
        return;
    }
    if (!ctx.typeNodeContainsAny(rhs)) return;
    if (rhsIsExplicitNonAnyCast(rhs, ctx)) return;
    ctx.reportWithMessageId(decl_node, "anyAssignment");
}

fn rhsIsExplicitNonAnyCast(rhs: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(rhs);
    switch (tag) {
        .ts_as_expr, .ts_type_assertion => {
            const data = ctx.nodeData(rhs);
            const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
            const cast_ty = ctx.resolveTypeAnnotationNode(ty_node);
            // `x as any` is still unsafe; only non-any casts suppress.
            return !ctx.typeIdIsAny(cast_ty);
        },
        else => return false,
    }
}
