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
    .less_than, .less_equal, .greater_than, .greater_equal,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .if_stmt => checkTruthiness(d.lhs, ctx),
        .while_stmt, .do_while_stmt => {
            // `while (true)` / `do {} while (true)` are exempt when
            // `allowConstantLoopConditions` is enabled.
            if (allowsConstantLoopConditions(ctx) and isConstantLoopGuard(d.lhs, ctx)) return;
            checkTruthiness(d.lhs, ctx);
        },
        .for_stmt => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.ForData, @intFromEnum(d.lhs));
            if (fd.condition != .none) {
                if (allowsConstantLoopConditions(ctx) and isConstantLoopGuard(fd.condition, ctx)) return;
                checkTruthiness(fd.condition, ctx);
            }
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
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .less_equal, .greater_than, .greater_equal => {
            checkComparison(d.lhs, d.rhs, node, ctx);
        },
        else => {},
    }
}

fn allowsConstantLoopConditions(ctx: *const LintContext) bool {
    const v = ctx.rule_options orelse return false;
    if (v.* != .object) return false;
    const k = v.object.get("allowConstantLoopConditions") orelse return false;
    return switch (k) {
        .bool => |b| b,
        .string => |s|
            std.mem.eql(u8, s, "always") or std.mem.eql(u8, s, "only-allowed-literals"),
        else => false,
    };
}

fn isConstantLoopGuard(expr: NodeIndex, ctx: *const LintContext) bool {
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const t = ctx.nodeTag(n);
    if (t != .boolean_literal and t != .number_literal and t != .null_literal) return false;
    return true;
}

fn checkTruthiness(expr: NodeIndex, ctx: *const LintContext) void {
    if (expr == .none) return;
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const t = ctx.nodeTag(n);
    if (t == .logical_and or t == .logical_or or t == .logical_not) return;
    // Skip computed-access expressions — under noUncheckedIndexedAccess
    // they can return T | undefined that we can't see from the type.
    if (containsComputedAccess(n, ctx)) return;
    // Use flow-narrowed type so guards in enclosing scopes refine the
    // tested expression's type — `if (x !== undefined) { if (x) … }`
    // becomes `if (string)` once null/undefined are stripped.
    const ty = ctx.narrowedTypeOf(n);
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
    if (containsComputedAccess(n, ctx)) return;
    const ty = ctx.narrowedTypeOf(n);
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
    const ty = ctx.narrowedTypeOf(n);
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
    const op = ctx.nodeTag(node);
    const loose = (op == .equal or op == .not_equal);
    const lt = effectiveLiteralType(lhs, ctx);
    const rt = effectiveLiteralType(rhs, ctx);
    if (isLiteralType(lt, ctx) and isLiteralType(rt, ctx)) {
        ctx.reportWithMessageId(node, "comparisonBetweenLiteralTypes");
        return;
    }
    // Skip when either side has any/unknown/type-param — could overlap.
    if (involvesIndeterminateType(lt, ctx) or involvesIndeterminateType(rt, ctx)) return;
    if (!typesCanOverlap(lt, rt, ctx)) {
        // For loose == with null literal, undefined matches too.  Skip
        // when the other side might be undefined.
        if (loose and (isNullishLiteral(lt) or isNullishLiteral(rt))) {
            const other = if (isNullishLiteral(lt)) rt else lt;
            if (typeContainsNullish(other, ctx)) return;
        }
        ctx.reportWithMessageId(node, "noOverlapBooleanExpression");
    }
}

fn isNullishLiteral(id: tymod.TypeId) bool {
    return id.eq(tymod.ID_NULL) or id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID);
}

fn involvesIndeterminateType(id: tymod.TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeIdKind(id) orelse return true;
    return switch (kind) {
        .any, .unknown, .error_t, .type_param => true,
        // Type refs to unrecognised names (often unresolved type
        // parameters / generics) are conservatively indeterminate.
        .type_ref => isUnresolvedRef(id, ctx),
        .union_t, .intersection_t => blk: {
            for (ctx.typeIdUnionMembers(id)) |m| {
                if (involvesIndeterminateType(m, ctx)) break :blk true;
            }
            break :blk false;
        },
        else => false,
    };
}

fn isUnresolvedRef(id: tymod.TypeId, ctx: *const LintContext) bool {
    const name = ctx.typeIdRefName(id);
    if (name.len == 0) return true;
    // Single-uppercase type-parameter-style names: conservatively
    // indeterminate.  Concrete lib classes (Number / String / Promise /
    // ...) are known and resolved by their structural rules elsewhere.
    if (name.len <= 2) {
        for (name) |ch| if (ch < 'A' or ch > 'Z') return false;
        return true;
    }
    return false;
}

fn typeContainsNullish(id: tymod.TypeId, ctx: *const LintContext) bool {
    const kind = ctx.typeIdKind(id) orelse return false;
    if (kind == .null_t or kind == .undefined_t or kind == .void_t) return true;
    if (kind == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| if (typeContainsNullish(m, ctx)) return true;
    }
    return false;
}

/// True when types `a` and `b` could share at least one runtime value.
/// Conservative: returns true when uncertain.
fn typesCanOverlap(a: tymod.TypeId, b: tymod.TypeId, ctx: *const LintContext) bool {
    // Expand unions on both sides; if any pair overlaps, true.
    const ka = ctx.typeIdKind(a) orelse return true;
    const kb = ctx.typeIdKind(b) orelse return true;
    if (ka == .any or kb == .any or ka == .unknown or kb == .unknown) return true;
    if (ka == .union_t) {
        for (ctx.typeIdUnionMembers(a)) |m| {
            if (typesCanOverlap(m, b, ctx)) return true;
        }
        return false;
    }
    if (kb == .union_t) {
        for (ctx.typeIdUnionMembers(b)) |m| {
            if (typesCanOverlap(a, m, ctx)) return true;
        }
        return false;
    }
    if (ka == .intersection_t or kb == .intersection_t) return true;
    // Singleton kinds first.
    if (ka == .null_t and kb == .null_t) return true;
    if (ka == .undefined_t or ka == .void_t) {
        return kb == .undefined_t or kb == .void_t;
    }
    if (kb == .undefined_t or kb == .void_t) return false;
    if (ka == .null_t) return false;
    if (kb == .null_t) return false;
    // Same broad family.
    if (kindFamily(ka) == kindFamily(kb)) {
        // Same family — possibly overlap.  For literal-vs-literal, defer
        // to literalsOverlap; otherwise assume overlap.
        if (ka == kb and (ka == .string_literal or ka == .number_literal or ka == .boolean_literal or ka == .bigint_literal)) {
            return literalsOverlap(a, b, ctx);
        }
        // string-literal vs string is overlap.
        return true;
    }
    return false;
}

fn kindFamily(k: tymod.TypeKind) u8 {
    return switch (k) {
        .string, .string_literal => 1,
        .number, .number_literal => 2,
        .bigint, .bigint_literal => 3,
        .boolean, .boolean_literal => 4,
        .symbol => 5,
        .object_t, .object_keyword, .array_t, .readonly_array_t, .tuple_t, .function_t, .type_ref => 6,
        .null_t => 7,
        .undefined_t, .void_t => 8,
        .never => 9,
        else => 0, // unknown/any/error/etc.
    };
}

/// Returns the literal type of an expression, peeking past `-expr`
/// for negative numeric/bigint literals (the parser emits `unary_minus`
/// around the inner literal).
fn effectiveLiteralType(node: NodeIndex, ctx: *const LintContext) tymod.TypeId {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .unary_minus) {
        const inner = ctx.nodeData(n).lhs;
        const inner_ty = ctx.typeOfNode(inner);
        if (isLiteralType(inner_ty, ctx)) return inner_ty;
    }
    // Treat the bare global `undefined` identifier as the undefined
    // type so comparisons recognise it.
    if (ctx.nodeTag(n) == .identifier and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined") and
        ctx.isGlobalReference(n))
    {
        return tymod.ID_UNDEFINED;
    }
    if (ctx.nodeTag(n) == .null_literal) return tymod.ID_NULL;
    // For identifier references, use flow-narrowed type so guards in
    // enclosing scopes refine the compared value's type.
    if (ctx.nodeTag(n) == .identifier) return ctx.narrowedTypeOf(n);
    return ctx.typeOfNode(n);
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
        .object_t, .object_keyword, .array_t, .readonly_array_t, .tuple_t, .function_t => return .always_truthy,
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
        .string_literal, .number_literal, .bigint_literal, .boolean_literal,
        .null_t, .undefined_t, .void_t => true,
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
