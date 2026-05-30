// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-type-assertion
//
// Reports type assertions whose source type is not assignable to the
// asserted type — narrowing, any-leaks, or type-parameter assertions.

const std = @import("std");
const parser = @import("es_parser");
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

    var expr_ty = ctx.typeOfNode(expr_node);
    const asserted_ty = ctx.resolveTypeAnnotationNode(ty_node);
    // Unresolved value identifier — TS gives it an error/any type.
    // Our checker leaves it as `unknown` to avoid leaking `any` to
    // other rules; for this rule's purposes, treat it as error-typed.
    if (ctx.typeIdIsUnknown(expr_ty) and isUnresolvedIdent(expr_node, ctx)) {
        expr_ty = tymod.ID_ERROR;
    }

    // Self-assertion `T as T` is fine even for type parameters.
    if (expr_ty.eq(asserted_ty) and !ctx.typeAnnotationIsTypeParameter(ty_node)) return;
    if (ctx.typeAnnotationIsTypeParameter(ty_node) and
        exprIsSameTypeParameter(expr_node, ty_node, ctx)) return;

    // any/unknown handling matches TSe ordering (must precede the
    // type-parameter branches — TS reports the any-source first).
    if (ctx.typeIdIsAny(asserted_ty) and ctx.typeIdIsUnknown(expr_ty)) {
        report(node, "unsafeToAnyTypeAssertion", "`any`", ty_node, ctx);
        return;
    }
    if (isUnsafeAssignment(expr_ty, asserted_ty, ctx)) {
        report(node, "unsafeOfAnyTypeAssertion", anyTypeName(expr_ty, ctx), ty_node, ctx);
        return;
    }
    if (isUnsafeAssignment(asserted_ty, expr_ty, ctx)) {
        report(node, "unsafeToAnyTypeAssertion", anyTypeName(asserted_ty, ctx), ty_node, ctx);
        return;
    }

    // Type-parameter target gets its own messages — even when the
    // expression is assignable to the parameter's *constraint*, TS
    // can still pick a more specific subtype, so we must report.
    // Therefore the type-parameter branch runs BEFORE the safe-
    // assignable early return.
    if (ctx.typeAnnotationIsTypeParameter(ty_node)) {
        const type_text = annotationText(ty_node, ctx);
        // Walk the constraint chain to find the first concrete
        // constraint type-node (skipping type-parameter hops).
        const base_cstr_node = resolveBaseConstraintNode(ty_node, ctx);
        if (base_cstr_node == .none) {
            report(node, "unsafeToUnconstrainedTypeAssertion", type_text, ty_node, ctx);
            return;
        }
        const cstr_ty = ctx.resolveTypeAnnotationNode(base_cstr_node);
        if (ctx.typeIdAssignableTo(expr_ty, cstr_ty)) {
            report(node, "unsafeTypeAssertionAssignableToConstraint", type_text, ty_node, ctx);
            return;
        }
        report(node, "unsafeTypeAssertion", type_text, ty_node, ctx);
        return;
    }

    // Safe if the expression's type is assignable to the asserted
    // (non-type-parameter) type.
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
    // Top-level any/error → non-any/non-unknown.  TSe's checker treats
    // the intrinsic error type (TS's "couldn't resolve this name")
    // identically to `any` for unsafe-assignment purposes.
    if (isAnyLike(source, ctx)) {
        return !isAnyLike(target, ctx) and !ctx.typeIdIsUnknown(target);
    }
    if (isAnyLike(target, ctx)) return false;
    return unsafeAssignmentRec(source, target, ctx, 0);
}

fn isAnyLike(id: TypeId, ctx: *const LintContext) bool {
    return ctx.typeIdIsAny(id) or id.eq(tymod.ID_ERROR);
}

/// Walk the constraint chain `V extends T extends ...` until we find
/// a constraint node that isn't a reference to another type
/// parameter; return that node, or `.none` if the chain terminates
/// without an explicit constraint.
fn resolveBaseConstraintNode(ty_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = ty_node;
    var hop: u8 = 0;
    while (hop < 8) : (hop += 1) {
        const cstr_opt = ctx.typeParameterConstraintNodeOf(cur);
        const cstr = cstr_opt orelse return .none;
        var c = cstr;
        while (ctx.nodeTag(c) == .ts_parenthesized_type) c = ctx.nodeData(c).lhs;
        if (ctx.nodeTag(c) == .ts_type_reference and ctx.typeAnnotationIsTypeParameter(c)) {
            cur = c;
            continue;
        }
        return c;
    }
    return .none;
}


/// True when `expr_node` is a bare identifier whose semantic
/// reference can't be resolved (implicit global / undeclared name).
fn isUnresolvedIdent(expr_node: NodeIndex, ctx: *const LintContext) bool {
    var n = expr_node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    return ctx.isGlobalReference(n);
}

fn unsafeAssignmentRec(source: TypeId, target: TypeId, ctx: *const LintContext, depth: u8) bool {
    if (depth > 4) return false;
    if (source.eq(target)) return false;
    if (isAnyLike(source, ctx) and !isAnyLike(target, ctx) and !ctx.typeIdIsUnknown(target)) return true;
    if (isAnyLike(target, ctx) and !isAnyLike(source, ctx) and !ctx.typeIdIsUnknown(source)) return false; // handled at caller
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
