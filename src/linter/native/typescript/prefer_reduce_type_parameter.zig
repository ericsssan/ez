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

    const callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr and cb_tag != .optional_member_expr) return;

    // Property must be `reduce`.
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "reduce")) return;

    const object = ctx.nodeData(callee).lhs;
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

    // Trivial-assertion gate: the asserted value should be a literal
    // that's structurally assignable to almost any T.  Without this
    // we'd also need a real assignability check to avoid reporting
    // necessary assertions.
    if (!isTrivialAssertedValue(inner, ctx)) return;

    // Asserted target must be a "broad" type — array-like or a
    // `Record<string, V>` (string index signature; `{}` is assignable).
    // Skip narrow targets like `Record<'a' | 'b', V>` whose required
    // keys make the assertion necessary.
    if (!tsTypeIsArrayLike(asserted_type, ctx) and !tsTypeIsIndexRecord(asserted_type, ctx)) return;

    ctx.reportWithMessageId(second, "preferTypeParameter");
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
                return tsTypeIsArrayLike(ctx.nodeData(bd.rhs).lhs, ctx);
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
    if (ty == .none) return false;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_parenthesized_type) return tsTypeIsArrayLike(ctx.nodeData(ty).lhs, ctx);
    if (tag == .ts_array_type or tag == .ts_tuple_type) return true;
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        return std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray");
    }
    return false;
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
