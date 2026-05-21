// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-member-access
//
// Reports when the receiver of a member access has type `any`:
//   * `const a: any = ...; a.b`       → unsafe (computed=false, name access)
//   * `const a: any = ...; a[x]`      → unsafe (computed=true, index access)
//   * `const a: any = ...; a?.b`      → unsafe (optional chain)
//   * tag\`x\` where tag is any       → not handled here (no-unsafe-call covers it)
//
// We do NOT fire on bracketed access where only the INDEX is any:
// `const a: number[] = []; const k: any = 0; a[k];` — typescript-eslint
// also doesn't fire that, since the receiver `a` is well-typed.  (This
// matches typescript-eslint v8; older versions flagged the computed key
// too with messageId `unsafeComputedMemberAccess`.)

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-member-access",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow member access on a value of type any",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr,
    .computed_member_expr,
    .optional_member_expr,
    .optional_computed_member_expr,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    // Suppress when the member access is in TS type position — a qualified
    // type name like `FG.A` (in `implements FG.A`, `extends FG.A`, or in
    // any ts_type_annotation / ts_type_reference parent context) parses
    // as member_expr at the AST level even though it's a type, not a
    // runtime expression.  Walk up to find a TS-type ancestor and skip.
    if (inTypePosition(node, ctx)) return;
    const allow_opt_chain = optionAllowOptionalChaining(ctx);
    const tag = ctx.nodeTag(node);
    // Second TSe selector: for computed member access (`obj[key]`), the
    // KEY itself may be any.  Fires `unsafeComputedMemberAccess` at the
    // key node.  Skipped for literal keys and update expressions (TSe
    // perf optimization — those types are never any).
    if (isComputedMemberExpr(tag)) {
        checkComputedKey(node, allow_opt_chain, ctx);
    }
    const state = computeState(node, allow_opt_chain, ctx);
    if (state != .unsafe) return;
    // We're at the firing position — only fire if our receiver isn't
    // itself an Unsafe member access (that one will report instead).
    const data = ctx.nodeData(node);
    const obj = data.lhs;
    if (isMemberExpr(ctx.nodeTag(obj))) {
        const inner = computeState(obj, allow_opt_chain, ctx);
        if (inner == .unsafe) return; // already reported on the inner
    }
    // Report at the property identifier, not the whole expression — TSe
    // reports `node.property` so column data points at the offending
    // property.  For `x.a` we want the span of `a`.
    // Distinguish error-typed receiver: TSe fires `errorMemberExpression`
    // when the type checker couldn't resolve the receiver's type.
    const msg = if (ctx.typeNodeIsError(obj))
        "errorMemberExpression"
    else
        "unsafeMemberExpression";
    const prop_span = propertySpan(node, ctx);
    ctx.reportSpanWithMessageId(prop_span, msg);
}

fn checkComputedKey(node: NodeIndex, allow_opt_chain: bool, ctx: *const LintContext) void {
    if (allow_opt_chain and isOptionalMemberExpr(ctx.nodeTag(node))) return;
    var key = ctx.nodeData(node).rhs;
    if (key == .none) return;
    // Peel grouping_expr wrappers — TSe's `node.property` selector
    // reports the inner expression's span, not the parens.
    while (ctx.nodeTag(key) == .grouping_expr) {
        const inner = ctx.nodeData(key).lhs;
        if (inner == .none) break;
        key = inner;
    }
    switch (ctx.nodeTag(key)) {
        .string_literal, .number_literal, .boolean_literal, .null_literal,
        .bigint_literal, .regex_literal,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => return,
        else => {},
    }
    const is_any = ctx.typeNodeIsAny(key);
    const is_error = !is_any and ctx.typeNodeIsError(key);
    if (!is_any and !is_error) return;
    const msg = if (is_error) "errorComputedMemberAccess" else "unsafeComputedMemberAccess";
    ctx.reportSpanWithMessageId(ctx.nodeSpan(key), msg);
}

fn isComputedMemberExpr(tag: Node.Tag) bool {
    return switch (tag) {
        .computed_member_expr, .optional_computed_member_expr => true,
        else => false,
    };
}

/// State of a member access for the chain algorithm.  Mirrors TSe's
/// internal enum:
///   * unsafe: receiver is `any`; this access reports.
///   * chained: this is an optional access (`?.`) and allowOptionalChaining
///     is on — suppress this access but DON'T propagate Unsafe upward.
///   * safe: receiver is not `any` — no report.
const State = enum { unsafe, chained, safe };

fn computeState(node: NodeIndex, allow_opt_chain: bool, ctx: *const LintContext) State {
    const tag = ctx.nodeTag(node);
    if (allow_opt_chain and isOptionalMemberExpr(tag)) return .chained;
    const data = ctx.nodeData(node);
    const obj = data.lhs;
    // `this` is checked through its inferred type — when the class
    // shape resolves to a real object_t we want member access on it
    // to follow the usual any/error propagation.  Only suppress when
    // we can't resolve it (which inferThis returns as unknown).
    if (isMemberExpr(ctx.nodeTag(obj))) {
        const inner = computeState(obj, allow_opt_chain, ctx);
        if (inner == .unsafe) return .unsafe;
    }
    // Both `any` and TS error type fire — TSe treats both as "type
    // is not safely resolvable" and reports the relevant variant.
    if (ctx.typeNodeIsAny(obj) or ctx.typeNodeIsError(obj)) return .unsafe;
    return .safe;
}

fn isOptionalMemberExpr(tag: Node.Tag) bool {
    return switch (tag) {
        .optional_member_expr, .optional_computed_member_expr => true,
        else => false,
    };
}

fn optionAllowOptionalChaining(ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const v = opts.object.get("allowOptionalChaining") orelse return false;
    return v == .bool and v.bool;
}

fn isMemberExpr(tag: Node.Tag) bool {
    return switch (tag) {
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => true,
        else => false,
    };
}

/// Span of the property identifier / computed key — matches typescript-eslint's
/// `node.property` location reporting.  For `obj.prop` returns the span of
/// `prop`; for `obj[expr]` returns the span of `expr`.
fn propertySpan(node: NodeIndex, ctx: *const LintContext) @import("../../../parser/span.zig").Span {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    switch (tag) {
        .computed_member_expr, .optional_computed_member_expr => {
            return ctx.nodeSpan(data.rhs);
        },
        .member_expr, .optional_member_expr => {
            // rhs is a property_ident node whose main_token IS the property identifier.
            return ctx.nodeSpan(data.rhs);
        },
        else => return ctx.nodeSpan(node),
    }
}

/// Walk up from `node` looking for a TS type-position ancestor.  When
/// the member access lives inside a ts_type_reference (qualified type
/// name) or any ts_* type node, it's a TYPE — no-unsafe-member-access
/// must not fire.
fn inTypePosition(node: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        switch (ctx.nodeTag(p)) {
            .ts_type_reference, .ts_type_annotation, .ts_type_query,
            .ts_typeof_type, .ts_indexed_access_type,
            .ts_union_type, .ts_intersection_type, .ts_array_type,
            .ts_tuple_type, .ts_conditional_type, .ts_mapped_type,
            .ts_type_literal, .ts_parenthesized_type,
            .ts_function_type, .ts_constructor_type,
            .ts_keyof_type, .ts_template_literal_type,
            .ts_type_predicate, .ts_infer_type,
            .ts_type_parameter, .ts_import_type => return true,
            // Stop walking at clear value-position boundaries.
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .class_decl, .class_expr, .class_body,
            .method_def, .computed_method_def, .constructor_def,
            .block_stmt, .expression_stmt, .return_stmt,
            .if_stmt, .if_else_stmt, .while_stmt, .for_stmt,
            .root => return false,
            else => {},
        }
    }
    return false;
}
