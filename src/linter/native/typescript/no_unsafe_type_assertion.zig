// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-type-assertion
//
// Reports type assertions whose source type is not assignable to the
// asserted type — narrowing, any-leaks, or type-parameter assertions.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "no-unsafe-type-assertion",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow type assertions that narrow a type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_as_expr,
    .ts_type_assertion,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    check(node, ctx);
}

fn check(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    // For ts_as_expr: lhs = expression, rhs = type annotation
    // For ts_type_assertion: lhs = type annotation, rhs = expression
    var expr_node: NodeIndex = .none;
    var ty_node: NodeIndex = .none;
    if (ctx.nodeTag(node) == .ts_as_expr) {
        expr_node = d.lhs;
        ty_node = d.rhs;
    } else {
        expr_node = d.rhs;
        ty_node = d.lhs;
    }
    if (expr_node == .none or ty_node == .none) return;

    // Skip `as const`.
    if (isAsConst(ty_node, ctx)) return;

    const expr_ty = ctx.typeOfNode(expr_node);
    const asserted_ty = ctx.resolveTypeAnnotationNode(ty_node);

    // Type-parameter assertion has its own identity — `T` is NOT assignable
    // to anything except itself, even when its constraint equals the expr.
    // Resolve identity from the AST node, not the constraint-substituted
    // TypeId.  Done BEFORE the equality check below, since the asserted
    // TypeId resolves to the constraint and would falsely match.
    if (ctx.typeAnnotationIsTypeParameter(ty_node) and
        !exprIsSameTypeParameter(expr_node, ty_node, ctx))
    {
        const cstr_opt = ctx.typeParameterConstraintOf(ty_node);
        const type_text = annotationText(ty_node, ctx);
        if (cstr_opt) |cstr| {
            if (ctx.typeIdIsUnknown(cstr)) {
                report(node, "unsafeToUnconstrainedTypeAssertion", type_text, ty_node, ctx);
                return;
            }
            if (ctx.typeIdAssignableTo(expr_ty, cstr)) {
                report(node, "unsafeTypeAssertionAssignableToConstraint", type_text, ty_node, ctx);
                return;
            }
        }
        report(node, "unsafeTypeAssertion", type_text, ty_node, ctx);
        return;
    }

    if (expr_ty.eq(asserted_ty)) return;

    // any/unknown handling matches TSe ordering:
    //   1) unknown → any  → unsafeToAnyTypeAssertion
    //   2) X (where X contains any) → ...  → unsafeOfAnyTypeAssertion
    //   3) ... → X (where X contains any) → unsafeToAnyTypeAssertion
    if (ctx.typeIdIsAny(asserted_ty) and ctx.typeIdIsUnknown(expr_ty)) {
        report(node, "unsafeToAnyTypeAssertion", "`any`", ty_node, ctx);
        return;
    }

    // isUnsafeAssignment(expressionType, assertedType) — does the source
    // type contain `any` in a place that would corrupt the target?
    if (isUnsafeAssignment(expr_ty, asserted_ty, ctx)) {
        report(node, "unsafeOfAnyTypeAssertion", anyTypeName(expr_ty, ctx), ty_node, ctx);
        return;
    }
    // isUnsafeAssignment(assertedType, expressionType) — does the target
    // contain `any` in a place that the source can't supply?
    if (isUnsafeAssignment(asserted_ty, expr_ty, ctx)) {
        report(node, "unsafeToAnyTypeAssertion", anyTypeName(asserted_ty, ctx), ty_node, ctx);
        return;
    }

    // Safe if the expression's type is assignable to the asserted type.
    if (ctx.typeIdAssignableTo(expr_ty, asserted_ty)) return;

    const type_text = annotationText(ty_node, ctx);
    report(node, "unsafeTypeAssertion", type_text, ty_node, ctx);
}

/// Approximates TSe's `isUnsafeAssignment` (tsutils helper).  Returns
/// true when assigning `source` to `target` would leak `any` into a
/// non-`any` slot.  Cases that matter for this rule:
///   - source has `any` AND target is non-`any`/non-`unknown`
///   - source is `Promise<any>` (or similar generic-of-any) and target
///     is `Promise<T>` where T is not `any`
/// Conservatively: when source contains `any` at any depth AND target's
/// matching slot is non-`any`/non-`unknown`, treat as unsafe.
fn isUnsafeAssignment(source: TypeId, target: TypeId, ctx: *const LintContext) bool {
    // Top-level any → non-any/non-unknown.
    if (ctx.typeIdIsAny(source)) {
        return !ctx.typeIdIsAny(target) and !ctx.typeIdIsUnknown(target);
    }
    if (ctx.typeIdIsAny(target)) return false;
    return unsafeAssignmentRec(source, target, ctx, 0);
}

fn unsafeAssignmentRec(source: TypeId, target: TypeId, ctx: *const LintContext, depth: u8) bool {
    if (depth > 4) return false;
    if (source.eq(target)) return false;
    if (ctx.typeIdIsAny(source) and !ctx.typeIdIsAny(target) and !ctx.typeIdIsUnknown(target)) return true;
    if (ctx.typeIdIsAny(target) and !ctx.typeIdIsAny(source) and !ctx.typeIdIsUnknown(source)) return false; // handled at caller
    // Generic-of-any: same type_ref outer name, compare args.
    if (ctx.typeIdSameOuterRef(source, target)) {
        return positionwiseUnsafe(ctx.typeIdRefArgs(source), ctx.typeIdRefArgs(target), ctx, depth);
    }
    // Array element / tuple element comparison.
    const s_elems = arrayLikeElems(source, ctx);
    const t_elems = arrayLikeElems(target, ctx);
    if (s_elems.len > 0 and t_elems.len > 0) {
        return positionwiseUnsafe(s_elems, t_elems, ctx, depth);
    }
    return false;
}

fn positionwiseUnsafe(s_args: []const TypeId, t_args: []const TypeId, ctx: *const LintContext, depth: u8) bool {
    if (s_args.len == 0 or t_args.len == 0) return false;
    // For array/tuple cases the slices may differ in length — compare
    // by min length; mismatches at higher positions are handled by the
    // outer assignability gate.
    const n = @min(s_args.len, t_args.len);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const sa = s_args[i];
        const ta = t_args[i];
        if (sa.eq(ta)) continue;
        if (ctx.typeIdIsAny(sa) and !ctx.typeIdIsAny(ta) and !ctx.typeIdIsUnknown(ta)) return true;
        if (unsafeAssignmentRec(sa, ta, ctx, depth + 1)) return true;
    }
    return false;
}

fn arrayLikeElems(id: TypeId, ctx: *const LintContext) []const TypeId {
    return ctx.typeIdArrayLikeElems(id);
}

/// True when `expr_node`'s declared annotation is the SAME type parameter
/// as the assertion target, OR a type parameter whose constraint chain
/// includes that name.  Either way, the assertion can't narrow.
fn exprIsSameTypeParameter(expr_node: NodeIndex, asserted_ty_node: NodeIndex, ctx: *const LintContext) bool {
    var t = asserted_ty_node;
    if (ctx.nodeTag(t) == .ts_type_annotation) t = ctx.nodeData(t).lhs;
    while (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_reference) return false;
    const asserted_name = ctx.tokenText(ctx.nodeMainToken(t));

    // Resolve the expression's annotation-position type-parameter name.
    var e = expr_node;
    while (ctx.nodeTag(e) == .grouping_expr) e = ctx.nodeData(e).lhs;
    if (ctx.nodeTag(e) != .identifier) return false;
    const sym = symbolForIdent(e, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    var ann = ctx.nodeData(bd.rhs).lhs;
    while (ctx.nodeTag(ann) == .ts_parenthesized_type) ann = ctx.nodeData(ann).lhs;
    if (ctx.nodeTag(ann) != .ts_type_reference) return false;
    // Walk the constraint chain: if any name on the chain matches the
    // asserted type parameter name, the relationship is "subtype-or-eq".
    var cur_name = ctx.tokenText(ctx.nodeMainToken(ann));
    var depth: u8 = 0;
    while (depth < 8) : (depth += 1) {
        if (std.mem.eql(u8, cur_name, asserted_name)) return true;
        // Find the ts_type_parameter for cur_name; if it has a constraint
        // that's a ts_type_reference, follow it.
        const tp = findTypeParameterByName(cur_name, ann, ctx) orelse return false;
        const tp_data = ctx.nodeData(tp);
        if (tp_data.lhs == .none) return false;
        var c = tp_data.lhs;
        while (ctx.nodeTag(c) == .ts_parenthesized_type) c = ctx.nodeData(c).lhs;
        if (ctx.nodeTag(c) != .ts_type_reference) return false;
        cur_name = ctx.tokenText(ctx.nodeMainToken(c));
    }
    return false;
}

/// Walk the AST for a `ts_type_parameter` named `name` whose scope encloses
/// `ref_node`.  Returns the parameter NodeIndex or null.
fn findTypeParameterByName(name: []const u8, ref_node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    const ref_main_tok = ctx.nodeMainToken(ref_node);
    const ref_pos = tree.tokenStart(ref_main_tok);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_parameter) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ni)), name)) continue;
        const tp_pos = tree.tokenStart(ctx.nodeMainToken(ni));
        if (tp_pos >= ref_pos) continue;
        return ni;
    }
    return null;
}

fn symbolForIdent(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}

fn anyTypeName(id: TypeId, ctx: *const LintContext) []const u8 {
    if (ctx.typeIdIsError(id)) return "error typed";
    return "`any`";
}

fn isAsConst(ty: NodeIndex, ctx: *const LintContext) bool {
    var t = ty;
    if (ctx.nodeTag(t) == .ts_type_annotation) t = ctx.nodeData(t).lhs;
    while (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(t));
    return std.mem.eql(u8, name, "const");
}

fn annotationText(ty: NodeIndex, ctx: *const LintContext) []const u8 {
    if (ty == .none) return "";
    var inner = ty;
    if (ctx.nodeTag(inner) == .ts_type_annotation) inner = ctx.nodeData(inner).lhs;
    const sp = ctx.nodeSpan(inner);
    if (sp.end > sp.start and sp.end <= ctx.ast.source.len) {
        return ctx.ast.source[sp.start..sp.end];
    }
    return "";
}

fn report(node: NodeIndex, msg_id: []const u8, type_text: []const u8, ty_node: NodeIndex, ctx: *const LintContext) void {
    _ = ty_node;
    ctx.reportWithMessageIdAndData(node, msg_id, &[_]MessageDataEntry{
        .{ .key = "type", .val = type_text },
    });
}
