// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-for-in-array
//
// Reports `for (k in arr)` where `arr` is array-like.  TS's
// `for...in` iterates property names (including the prototype chain
// and string-coerced indices), which is almost always wrong for
// arrays — use `for...of` or `arr.forEach` instead.
//
// We check whether the right-hand side's inferred type is:
//   * array_t / readonly_array_t (T[] / readonly T[])
//   * tuple_t (fixed-shape arrays)
//   * type_ref to Array / ReadonlyArray
//   * union/intersection where any member is array-like
//
// Annotation-only checks (no syntactic `as Array<T>` requirement) —
// the checker drives this rule.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-for-in-array",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow iterating over an array with a for-in loop",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.for_in_stmt};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    // for_in_stmt layout: data.lhs is the iteration variable binding,
    // data.rhs is `extra index → ForLikeData` with `right` carrying the
    // iterated expression.  But our parser commonly stores the right
    // side directly in the stmt's data — walk children to be safe.
    const right = findForInRight(node, ctx);
    if (right == .none) return;
    const right_ty = ctx.typeOfNode(right);
    // Suppress only on `any` — TSe's rule still fires when the type
    // happens to be `error`/`unknown` if the declared annotation looks
    // array-like, so we don't bail on those before the AST fallback.
    if (ctx.typeIdIsAny(right_ty)) return;
    if (!ctx.typeIdIsArrayLike(right_ty) and !exprDeclaredArrayLike(right, ctx)) return;
    // Report at the for-stmt header (mirror ESLint's
    // getForStatementHeadLoc): from `for` to the closing `)` —
    // approximate by going from stmt start up to the body start, then
    // back over whitespace.  TSe oracle uses the same span shape.
    const stmt_span = ctx.nodeSpan(node);
    const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(ctx.nodeData(node).lhs));
    var end_pos = stmt_span.end;
    if (fd.body != .none) {
        const body_start = ctx.nodeSpan(fd.body).start;
        if (body_start > stmt_span.start) end_pos = body_start;
        // Walk back over whitespace so the span ends at `)` not ` {`.
        const src = ctx.ast.source;
        while (end_pos > stmt_span.start) {
            const c = src[end_pos - 1];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') {
                end_pos -= 1;
            } else break;
        }
    }
    ctx.reportSpanWithMessageId(.{ .start = stmt_span.start, .end = end_pos }, "forInViolation");
}

fn findForInRight(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    // for_in_stmt.data.lhs is an extra index to ForInOfData
    // (binding, expr, body).  Pull `expr`.
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return .none;
    const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
    return fd.expr;
}

/// AST-level fallback: walks an identifier's declared type annotation
/// for array-like shapes.  Handles type aliases (one hop) and
/// unions/intersections.
fn exprDeclaredArrayLike(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    // `arguments` is the IArguments object inside a regular function
    // (not arrow).  IArguments is array-like (numeric index + length).
    if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "arguments")) {
        var p = ctx.parentOf(node);
        while (p != .none) : (p = ctx.parentOf(p)) {
            switch (ctx.nodeTag(p)) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                .method_def, .computed_method_def,
                .getter_def, .setter_def, .computed_getter_def, .computed_setter_def,
                .constructor_def => return true,
                .arrow_fn, .async_arrow_fn => continue, // arrow inherits arguments
                else => {},
            }
        }
        return false;
    }
    const sym = symbolForIdent(node, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) {
        // No annotation — check declarator init for known array-like
        // factory calls.
        const dparent = ctx.parentOf(decl);
        if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
            const init = ctx.nodeData(dparent).rhs;
            if (initIsArrayLike(init, ctx)) return true;
        }
        return false;
    }
    return tsTypeIsArrayLike(ctx.nodeData(bd.rhs).lhs, ctx);
}

/// Heuristic: detects expressions that return array-like values.
/// Specifically `/regex/.exec(...)` (returns RegExpMatchArray | null).
fn initIsArrayLike(init: NodeIndex, ctx: *const LintContext) bool {
    if (init == .none) return false;
    const tag = ctx.nodeTag(init);
    if (tag == .array_literal) return true;
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const callee = ctx.nodeData(init).lhs;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const pname = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, pname, "exec")) return false;
    return ctx.nodeTag(md.lhs) == .regex_literal;
}

fn tsTypeIsArrayLike(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    switch (ctx.nodeTag(ty)) {
        .ts_parenthesized_type => return tsTypeIsArrayLike(ctx.nodeData(ty).lhs, ctx),
        .ts_array_type, .ts_tuple_type => return true,
        .ts_type_literal => {
            // Type literal with a numeric index signature `[key:number]: T`
            // AND a `length` property is array-like (matches TSe's
            // isArrayLikeType which requires both).
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ext_len) return false;
            var has_numeric_index = false;
            var has_length = false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                const mt = ctx.nodeTag(m);
                if (mt == .ts_index_signature) {
                    const sig_param = ctx.nodeData(m).lhs;
                    if (sig_param == .none or ctx.nodeTag(sig_param) != .identifier) continue;
                    const pd = ctx.nodeData(sig_param);
                    if (pd.rhs == .none or ctx.nodeTag(pd.rhs) != .ts_type_annotation) continue;
                    const key_ty = ctx.nodeData(pd.rhs).lhs;
                    if (key_ty == .none or ctx.nodeTag(key_ty) != .ts_type_reference) continue;
                    if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key_ty)), "number")) {
                        has_numeric_index = true;
                    }
                } else if (mt == .ts_property_signature) {
                    const name_tok = ctx.nodeMainToken(m);
                    if (std.mem.eql(u8, ctx.tokenText(name_tok), "length")) has_length = true;
                }
            }
            return has_numeric_index and has_length;
        },
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(ty);
            const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s > e or e > ext_len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (tsTypeIsArrayLike(m, ctx)) return true;
            }
            return false;
        },
        .ts_type_reference => {
            const name = ctx.tokenText(ctx.nodeMainToken(ty));
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) return true;
            // DOM and lib array-like types we don't model in the type store.
            if (std.mem.eql(u8, name, "HTMLCollection") or std.mem.eql(u8, name, "NodeList") or
                std.mem.eql(u8, name, "RegExpMatchArray") or std.mem.eql(u8, name, "RegExpExecArray") or
                std.mem.eql(u8, name, "IArguments") or
                std.mem.eql(u8, name, "ArrayLike") or
                std.mem.eql(u8, name, "Iterable") or std.mem.eql(u8, name, "IterableIterator") or
                std.mem.eql(u8, name, "Generator")) return true;
            // Walk type aliases / type-parameter constraints (one hop each).
            const tree = ctx.ast;
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                const tag = tree.nodeTag(ni);
                if (tag == .ts_type_alias_decl) {
                    const data = tree.nodeData(ni);
                    const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
                    if (!std.mem.eql(u8, tree.tokenText(ad.name), name)) continue;
                    return tsTypeIsArrayLike(ad.type_node, ctx);
                }
                if (tag == .ts_type_parameter) {
                    const tp_name = tree.tokenText(tree.nodeMainToken(ni));
                    if (!std.mem.eql(u8, tp_name, name)) continue;
                    const data = tree.nodeData(ni);
                    // Per parser layout: lhs = constraint, rhs = default.
                    if (data.lhs == .none) continue;
                    return tsTypeIsArrayLike(data.lhs, ctx);
                }
            }
            return false;
        },
        else => return false,
    }
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
