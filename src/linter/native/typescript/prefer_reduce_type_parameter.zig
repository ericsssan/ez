// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-reduce-type-parameter
//
// Reports `arr.reduce(fn, init as T)` where `arr` is array-like —
// suggests `arr.reduce<T>(fn, init)` (a real type parameter instead
// of an assertion).
//
// We mirror TSe's predicate without the full assignability check:
//   - callee is a (regular or optional) member expression with the
//     non-computed property `reduce`,
//   - the underlying object is array-like,
//   - the call has at least 2 args and arg[1] is a type assertion
//     (`expr as T` or `<T>expr`),
//   - the asserted value is "trivial" (literal / array_literal /
//     object_literal / Map/Set/Array-call), where assignability holds
//     by construction.  The trivial-only restriction avoids the
//     "isAssertionNecessary" check the upstream rule does to skip
//     necessary assertions.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-reduce-type-parameter",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using type parameter when calling `Array#reduce` instead of using a type assertion",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;

    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr or
        ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    const cb_tag = ctx.nodeTag(callee);
    var object: NodeIndex = .none;
    if (cb_tag == .member_expr or cb_tag == .optional_member_expr) {
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "reduce")) return;
        object = ctx.nodeData(callee).lhs;
    } else if (cb_tag == .computed_member_expr or cb_tag == .optional_computed_member_expr) {
        // arr['reduce'](...).  Computed key must be the string literal
        // "reduce".
        const md = ctx.nodeData(callee);
        if (md.rhs == .none or ctx.nodeTag(md.rhs) != .string_literal) return;
        const span = ctx.nodeSpan(md.rhs);
        if (span.end <= span.start + 2) return;
        const raw = ctx.ast.source[span.start..span.end];
        if (raw.len < 3) return;
        if (!std.mem.eql(u8, raw[1 .. raw.len - 1], "reduce")) return;
        object = md.lhs;
    } else return;
    if (object == .none) return;
    const obj_ty = ctx.typeOfNode(object);
    if (ctx.typeIdIsAny(obj_ty)) return;
    // Per TSe: every union/intersection branch must be array-like.  If
    // it's a union, only fire when ALL branches are arrays.  Use the
    // stricter `allBranches…` semantics here.
    if (ctx.typeIdIsUnion(obj_ty)) {
        const members = ctx.typeIdUnionMembers(obj_ty);
        if (members.len == 0) return;
        for (members) |m| if (!ctx.typeIdIsArrayLike(m)) return;
    } else if (!ctx.typeIdIsArrayLike(obj_ty) and !exprIsArrayLike(object, ctx)) {
        return;
    }

    const args = callArgs(node, ctx) orelse return;
    if (args.len < 2) return;
    const second: NodeIndex = @enumFromInt(args[1]);

    const second_tag = ctx.nodeTag(second);
    if (second_tag != .ts_as_expr and second_tag != .ts_type_assertion) return;

    // Layout differs:
    //   ts_as_expr        — data.lhs = value, data.rhs = type
    //   ts_type_assertion — data.lhs = type,  data.rhs = value
    const second_data = ctx.nodeData(second);
    const inner = if (second_tag == .ts_as_expr) second_data.lhs else second_data.rhs;
    const asserted_type = if (second_tag == .ts_as_expr) second_data.rhs else second_data.lhs;

    // Two acceptance paths:
    //   (a) Trivial-value form: literal/array_literal/object_literal/
    //       new_expr inner combined with a broad target (T[] / Array /
    //       Record<string,_>) — the assertion is structurally
    //       unnecessary by construction.
    //   (b) Assignability form: the inner expression's inferred type
    //       is already assignable to the asserted type — the assertion
    //       is unnecessary and a real type parameter would suffice.
    const trivial = isTrivialAssertedValue(inner, ctx);
    const broad_target = tsTypeIsArrayLike(asserted_type, ctx) or tsTypeIsIndexRecord(asserted_type, ctx);
    if (trivial and broad_target) {
        ctx.reportWithMessageId(second, "preferTypeParameter");
        return;
    }
    // Assignability path: only when the inner has a concrete inferred
    // type that's NOT any/unknown — otherwise we'd over-report.
    const inner_ty = ctx.typeOfNode(inner);
    if (ctx.typeIdIsAny(inner_ty) or ctx.typeIdContainsUnknown(inner_ty)) return;
    const asserted_id = ctx.resolveTypeAnnotationNode(asserted_type);
    if (ctx.typeIdIsAny(asserted_id) or ctx.typeIdContainsUnknown(asserted_id)) return;
    if (ctx.typeIdAssignableTo(inner_ty, asserted_id)) {
        ctx.reportWithMessageId(second, "preferTypeParameter");
    }
}

fn isTrivialAssertedValue(node: NodeIndex, ctx: *const LintContext) bool {
    return switch (ctx.nodeTag(node)) {
        .array_literal, .object_literal, .number_literal, .bigint_literal,
        .string_literal, .boolean_literal, .null_literal, .template_literal,
        // `new Map()` / `new Set()` etc.
        .new_expr => true,
        .grouping_expr => isTrivialAssertedValue(ctx.nodeData(node).lhs, ctx),
        else => false,
    };
}

fn callArgs(node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}

fn exprIsArrayLike(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .array_literal => return true,
        .identifier => {
            const sym = symbolForIdent(node, ctx) orelse return false;
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl == .none) return false;
            if (ctx.nodeTag(decl) != .identifier) return false;
            const bd = ctx.nodeData(decl);
            if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
                // Pass `decl` as the `at` anchor — it has proper parent
                // linkage for scope-walking.
                return tsTypeIsArrayLikeAt(ctx.nodeData(bd.rhs).lhs, decl, ctx);
            }
            const dparent = ctx.parentOf(decl);
            if (dparent != .none and ctx.nodeTag(dparent) == .declarator) {
                const init = ctx.nodeData(dparent).rhs;
                if (init != .none and ctx.nodeTag(init) == .array_literal) return true;
            }
            return false;
        },
        .grouping_expr, .ts_non_null_expr, .ts_satisfies_expr => return exprIsArrayLike(ctx.nodeData(node).lhs, ctx),
        else => return false,
    }
}

fn tsTypeIsIndexRecord(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsIndexRecord(ctx.nodeData(ty).lhs, ctx);
    if (tag != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ty));
    if (!std.mem.eql(u8, name, "Record")) return false;
    // ts_type_reference.data.rhs is an extra_data index into a
    // SubRange { start, end } of NodeIndex type args.
    const rhs = ctx.nodeData(ty).rhs;
    if (rhs == .none) return false;
    const idx = @intFromEnum(rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return false;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (start >= end or end > ctx.ast.extra_data.len) return false;
    const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[start]);
    if (ctx.nodeTag(first) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(first)), "string");
}

fn tsTypeIsArrayLike(ty: NodeIndex, ctx: *const LintContext) bool {
    return tsTypeIsArrayLikeAt(ty, ty, ctx);
}

/// Same as tsTypeIsArrayLike but takes an `at` site used as the
/// lookup anchor when chasing type-parameter constraints.
fn tsTypeIsArrayLikeAt(ty: NodeIndex, at: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsArrayLikeAt(ctx.nodeData(ty).lhs, at, ctx);
    if (tag == .ts_array_type or tag == .ts_tuple_type) return true;
    if (tag == .ts_union_type) {
        // ALL branches must be array-like for the union to safely reduce.
        const data = ctx.nodeData(ty);
        const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
        const s = @intFromEnum(data.lhs);
        const e = @intFromEnum(data.rhs);
        if (s >= e or e > ext_len) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (!tsTypeIsArrayLikeAt(m, at, ctx)) return false;
        }
        return true;
    }
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) return true;
        // Chase type-parameter constraints (`U extends T[]`).  Use the
        // `at` anchor — constraint nodes themselves often lack a
        // parent in the parent index.
        if (lookupNearestTypeParameter(at, name, ctx)) |constraint| {
            if (constraint != .none) return tsTypeIsArrayLikeAt(constraint, at, ctx);
        }
    }
    return false;
}

fn lookupNearestTypeParameter(at: NodeIndex, name: []const u8, ctx: *const LintContext) ?NodeIndex {
    const tree = ctx.ast;
    const from_span = ctx.nodeSpan(at);
    var enclosing: NodeIndex = ctx.parentOf(at);
    while (enclosing != .none) : (enclosing = ctx.parentOf(enclosing)) {
        const t = ctx.nodeTag(enclosing);
        if (t == .fn_decl or t == .async_fn_decl or t == .generator_fn_decl or
            t == .async_generator_fn_decl or t == .ts_declare_function or
            t == .fn_expr or t == .async_fn_expr or t == .generator_fn_expr or
            t == .async_generator_fn_expr or t == .arrow_fn or t == .async_arrow_fn or
            t == .method_def or t == .computed_method_def or
            t == .class_decl or t == .class_expr)
        {
            const enclosing_span = ctx.nodeSpan(enclosing);
            const total: u32 = @intCast(tree.nodes.len);
            var i: u32 = 0;
            while (i < total) : (i += 1) {
                const ni: NodeIndex = @enumFromInt(i);
                if (tree.nodeTag(ni) != .ts_type_parameter) continue;
                if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
                const tp_span = ctx.nodeSpan(ni);
                if (tp_span.start >= enclosing_span.start and
                    tp_span.end <= enclosing_span.end and
                    tp_span.end <= from_span.start)
                {
                    return tree.nodeData(ni).lhs;
                }
            }
        }
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
