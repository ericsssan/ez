// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unnecessary-condition

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "no-unnecessary-condition",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow conditions whose result is statically known",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .if_stmt, .while_stmt, .do_while_stmt, .for_stmt,
    .conditional, .logical_and, .logical_or, .logical_not,
    .nullish_coalesce,
    .optional_member_expr, .optional_call_expr,
    .optional_computed_member_expr,
    .equal, .not_equal, .strict_equal, .strict_not_equal,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .if_stmt, .while_stmt, .do_while_stmt => {
            checkTruthiness(d.lhs, ctx);
        },
        .for_stmt => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.ForData, @intFromEnum(d.lhs));
            if (fd.condition != .none) checkTruthiness(fd.condition, ctx);
        },
        .conditional => {
            checkTruthiness(d.lhs, ctx);
        },
        .logical_not => checkTruthiness(d.lhs, ctx),
        .logical_and, .logical_or => {
            // LHS is tested for truthiness.
            checkTruthiness(d.lhs, ctx);
        },
        .nullish_coalesce => {
            checkNullishCoalesce(d.lhs, ctx);
        },
        .optional_member_expr, .optional_call_expr, .optional_computed_member_expr => {
            checkOptionalChainReceiver(d.lhs, ctx);
        },
        .equal, .not_equal, .strict_equal, .strict_not_equal => {
            checkComparison(d.lhs, d.rhs, node, ctx);
        },
        else => {},
    }
}

fn checkTruthiness(expr: NodeIndex, ctx: *const LintContext) void {
    if (expr == .none) return;
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Skip when nested logicals — each operand is visited separately.
    const t = ctx.nodeTag(n);
    if (t == .logical_and or t == .logical_or or t == .logical_not) return;
    const ty = ctx.typeOfNode(n);
    const tr = truthiness(ty, ctx);
    switch (tr) {
        .always_truthy => ctx.reportWithMessageId(n, "alwaysTruthy"),
        .always_falsy => ctx.reportWithMessageId(n, "alwaysFalsy"),
        else => {},
    }
}

fn checkNullishCoalesce(lhs: NodeIndex, ctx: *const LintContext) void {
    if (lhs == .none) return;
    var n = lhs;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Conservative: skip expressions whose value depends on computed
    // index access — under `noUncheckedIndexedAccess` they may return
    // `undefined`, and we can't see that option from the AST alone.
    if (containsComputedAccess(n, ctx)) return;
    const ty = ctx.typeOfNode(n);
    const nul = nullability(ty, ctx);
    switch (nul) {
        .never_nullish => ctx.reportWithMessageId(n, "neverNullish"),
        .always_nullish => ctx.reportWithMessageId(n, "alwaysNullish"),
        else => {},
    }
}

fn checkOptionalChainReceiver(recv: NodeIndex, ctx: *const LintContext) void {
    if (recv == .none) return;
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (containsComputedAccess(n, ctx)) return;
    const ty = ctx.typeOfNode(n);
    const nul = nullability(ty, ctx);
    if (nul == .never_nullish) {
        ctx.reportWithMessageId(n, "neverOptionalChain");
    }
}

/// True when `expr` is or contains a computed member access
/// (`x[y]`).  Under noUncheckedIndexedAccess these can produce
/// `T | undefined` that we can't see from the resolved type alone.
fn containsComputedAccess(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    var depth: u32 = 0;
    while (depth < 16) : (depth += 1) {
        const tag = ctx.nodeTag(n);
        if (tag == .computed_member_expr or tag == .optional_computed_member_expr) return true;
        if (tag == .member_expr or tag == .optional_member_expr) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        if (tag == .call_expr or tag == .optional_call_expr) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        if (tag == .grouping_expr) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        return false;
    }
    return false;
}

fn checkComparison(lhs: NodeIndex, rhs: NodeIndex, node: NodeIndex, ctx: *const LintContext) void {
    if (lhs == .none or rhs == .none) return;
    const lt = ctx.typeOfNode(lhs);
    const rt = ctx.typeOfNode(rhs);
    // Both literal types?
    if (isLiteralType(lt, ctx) and isLiteralType(rt, ctx)) {
        if (!literalsOverlap(lt, rt, ctx)) {
            ctx.reportWithMessageId(node, "comparisonBetweenLiteralTypes");
        }
    }
}

const Truthiness = enum { always_truthy, always_falsy, indeterminate };

fn truthiness(id: TypeId, ctx: *const LintContext) Truthiness {
    return truthinessDepth(id, ctx, 0);
}

fn truthinessDepth(id: TypeId, ctx: *const LintContext, depth: u32) Truthiness {
    if (depth > 6) return .indeterminate;
    const kind = ctx.typeIdKind(id) orelse return .indeterminate;
    if (kind == .union_t) {
        var saw_truthy = false;
        var saw_falsy = false;
        for (ctx.typeIdUnionMembers(id)) |m| {
            switch (truthinessDepth(m, ctx, depth + 1)) {
                .always_truthy => saw_truthy = true,
                .always_falsy => saw_falsy = true,
                .indeterminate => return .indeterminate,
            }
        }
        if (saw_truthy and !saw_falsy) return .always_truthy;
        if (saw_falsy and !saw_truthy) return .always_falsy;
        return .indeterminate;
    }
    if (kind == .intersection_t) {
        // Branded / intersection types — be conservative.  String &
        // {brand} could be empty or non-empty; we can't tell.
        return .indeterminate;
    }
    return singleTruthiness(id, kind, ctx);
}

fn singleTruthiness(id: TypeId, kind: tymod.TypeKind, ctx: *const LintContext) Truthiness {
    switch (kind) {
        .null_t, .undefined_t, .void_t, .never => return .always_falsy,
        .object_t, .array_t, .readonly_array_t, .tuple_t, .function_t => return .always_truthy,
        .string_literal => {
            if (ctx.typeIdLiteralValue(id)) |v| switch (v) {
                .string => |s| return if (s.len == 0) .always_falsy else .always_truthy,
                else => {},
            };
            return .indeterminate;
        },
        .number_literal => {
            if (ctx.typeIdLiteralValue(id)) |v| switch (v) {
                .number => |n| return if (n == 0 or std.math.isNan(n)) .always_falsy else .always_truthy,
                else => {},
            };
            return .indeterminate;
        },
        .bigint_literal => {
            if (ctx.typeIdLiteralValue(id)) |v| switch (v) {
                .bigint => |b| return if (std.mem.eql(u8, b, "0")) .always_falsy else .always_truthy,
                else => {},
            };
            return .indeterminate;
        },
        .boolean_literal => {
            if (ctx.typeIdLiteralValue(id)) |v| switch (v) {
                .boolean => |b| return if (b) .always_truthy else .always_falsy,
                else => {},
            };
            return .indeterminate;
        },
        // Broad types — could be either truthy or falsy.
        .string, .number, .bigint, .boolean, .any, .unknown => return .indeterminate,
        else => return .indeterminate,
    }
}

const Nullability = enum { never_nullish, always_nullish, possibly_nullish };

fn nullability(id: TypeId, ctx: *const LintContext) Nullability {
    return nullabilityDepth(id, ctx, 0);
}

fn nullabilityDepth(id: TypeId, ctx: *const LintContext, depth: u32) Nullability {
    if (depth > 6) return .possibly_nullish;
    const kind = ctx.typeIdKind(id) orelse return .possibly_nullish;
    if (kind == .union_t) {
        var saw_null = false;
        var saw_non_null = false;
        var any_unknown = false;
        for (ctx.typeIdUnionMembers(id)) |m| {
            switch (nullabilityDepth(m, ctx, depth + 1)) {
                .always_nullish => saw_null = true,
                .never_nullish => saw_non_null = true,
                .possibly_nullish => any_unknown = true,
            }
        }
        if (any_unknown) return .possibly_nullish;
        if (saw_null and !saw_non_null) return .always_nullish;
        if (saw_non_null and !saw_null) return .never_nullish;
        return .possibly_nullish;
    }
    return switch (kind) {
        .null_t, .undefined_t, .void_t => .always_nullish,
        .any, .unknown => .possibly_nullish,
        // Primitives and object-ish types are never nullish on their own.
        .string, .string_literal,
        .number, .number_literal,
        .bigint, .bigint_literal,
        .boolean, .boolean_literal,
        .symbol,
        .object_t, .array_t, .readonly_array_t, .tuple_t, .function_t,
        .never => .never_nullish,
        else => .possibly_nullish,
    };
}

fn isLiteralType(id: TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeIdKind(id) orelse return false;
    return switch (kind) {
        .string_literal, .number_literal, .bigint_literal, .boolean_literal => true,
        else => false,
    };
}

fn literalsOverlap(a: TypeId, b: TypeId, ctx: *const LintContext) bool {
    const ka = ctx.typeIdKind(a) orelse return true;
    const kb = ctx.typeIdKind(b) orelse return true;
    if (ka != kb) return false;
    const va = ctx.typeIdLiteralValue(a) orelse return true;
    const vb = ctx.typeIdLiteralValue(b) orelse return true;
    return switch (va) {
        .string => |s| switch (vb) {
            .string => |t| std.mem.eql(u8, s, t),
            else => false,
        },
        .number => |n| switch (vb) {
            .number => |m| n == m,
            else => false,
        },
        .boolean => |x| switch (vb) {
            .boolean => |y| x == y,
            else => false,
        },
        .bigint => |s| switch (vb) {
            .bigint => |t| std.mem.eql(u8, s, t),
            else => false,
        },
        else => true,
    };
}
