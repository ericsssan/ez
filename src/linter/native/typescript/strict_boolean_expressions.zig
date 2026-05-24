// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/strict-boolean-expressions

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
    .name = "strict-boolean-expressions",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow non-boolean values in boolean contexts",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .if_stmt, .while_stmt, .do_while_stmt, .for_stmt,
    .conditional, .logical_and, .logical_or, .logical_not,
    .call_expr,
};

pub const needs_semantic = true;

const Options = struct {
    allow_any: bool = false,
    allow_nullable_boolean: bool = false,
    allow_nullable_enum: bool = false,
    allow_nullable_number: bool = false,
    allow_nullable_object: bool = true,
    allow_nullable_string: bool = false,
    allow_number: bool = true,
    allow_string: bool = true,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("allowAny")) |x| if (x == .bool) { opts.allow_any = x.bool; };
    if (v.object.get("allowNullableBoolean")) |x| if (x == .bool) { opts.allow_nullable_boolean = x.bool; };
    if (v.object.get("allowNullableEnum")) |x| if (x == .bool) { opts.allow_nullable_enum = x.bool; };
    if (v.object.get("allowNullableNumber")) |x| if (x == .bool) { opts.allow_nullable_number = x.bool; };
    if (v.object.get("allowNullableObject")) |x| if (x == .bool) { opts.allow_nullable_object = x.bool; };
    if (v.object.get("allowNullableString")) |x| if (x == .bool) { opts.allow_nullable_string = x.bool; };
    if (v.object.get("allowNumber")) |x| if (x == .bool) { opts.allow_number = x.bool; };
    if (v.object.get("allowString")) |x| if (x == .bool) { opts.allow_string = x.bool; };
    return opts;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .if_stmt, .while_stmt, .do_while_stmt => {
            walkBoolCtx(d.lhs, opts, ctx, 0);
        },
        .for_stmt => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.ForData, @intFromEnum(d.lhs));
            if (fd.condition != .none) walkBoolCtx(fd.condition, opts, ctx, 0);
        },
        .conditional => {
            walkBoolCtx(d.lhs, opts, ctx, 0);
        },
        .logical_not => {
            walkBoolCtx(d.lhs, opts, ctx, 0);
        },
        .logical_and, .logical_or => {
            // LHS is always tested for truthiness.  When this logical is
            // not itself in a boolean-context entry point, recurse into
            // the LHS treating each leaf as bool ctx.  Otherwise the
            // entry-point walk already does this for us.
            if (!parentIsBoolCtxEntry(node, ctx)) {
                walkBoolCtx(d.lhs, opts, ctx, 0);
            }
        },
        .call_expr => {
            // `Boolean(x)` — check the first argument.
            var callee = d.lhs;
            while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
            if (ctx.nodeTag(callee) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Boolean") and
                ctx.isGlobalReference(callee))
            {
                if (d.rhs == .none) return;
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return;
                const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[sr.start]);
                walkBoolCtx(arg, opts, ctx, 0);
                return;
            }
            // Assertion functions: `declare function assert(x): asserts x;
            // assert(value)` — the argument is being implicitly tested.
            const callee_ty = ctx.typeOfNode(callee);
            if (ctx.functionAssertionInfo(callee_ty)) |info| {
                if (d.rhs == .none) return;
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return;
                const args = ctx.ast.extra_data[sr.start..sr.end];
                if (info.param_index >= args.len) return;
                const arg: NodeIndex = @enumFromInt(args[info.param_index]);
                walkBoolCtx(arg, opts, ctx, 0);
                return;
            }
        },
        else => {},
    }
}

/// Walk a boolean-context expression: descend through `&&` / `||`,
/// checking each leaf operand as if it were in boolean context.  For
/// any non-logical operand, classify and report.
fn walkBoolCtx(expr: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) void {
    if (expr == .none or depth > 64) return;
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .logical_and or tag == .logical_or) {
        const d = ctx.nodeData(n);
        walkBoolCtx(d.lhs, opts, ctx, depth + 1);
        walkBoolCtx(d.rhs, opts, ctx, depth + 1);
        return;
    }
    if (tag == .logical_not) return; // ! result is boolean
    checkBoolLeaf(n, opts, ctx);
}

fn checkBoolLeaf(expr: NodeIndex, opts: Options, ctx: *const LintContext) void {
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Use flow-narrowed type so enclosing guards refine which messageId
    // applies (e.g. `if (x !== null) { if (x) … }` — at the inner test
    // x is non-null and conditionErrorNullableString shouldn't fire).
    const ty = ctx.narrowedTypeOf(n);
    const classification = classify(ty, opts, ctx);
    const msg = messageFor(classification, opts);
    if (msg) |m| ctx.reportWithMessageId(n, m);
}

/// True when `node`'s parent puts it in a boolean context that will
/// be walked from a top-level entry point (so we avoid double-firing
/// when this is also visited by the dedicated logical visitor).
fn parentIsBoolCtxEntry(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .if_stmt, .while_stmt, .do_while_stmt => return true,
            .for_stmt => return true,
            .conditional => {
                // We're in bool ctx only when we're the test (lhs).
                return ctx.nodeData(cur).lhs == node;
            },
            .logical_not => return true,
            .logical_and, .logical_or => {
                // Inherit bool-ctx status from this logical's parent.
            },
            .grouping_expr => {},
            else => return false,
        }
        const next = ctx.parentOf(cur);
        if (next == .none) return false;
        cur = next;
    }
    return false;
}

const Class = enum {
    boolean_ok,
    string,
    number,
    object,
    any,
    unknown,
    never,
    nullish_only,
    nullable_boolean,
    nullable_string,
    nullable_number,
    nullable_object,
    nullable_enum,
    mixed, // unclassifiable
};

const Family = struct {
    has_string: bool = false,
    has_number: bool = false,
    has_boolean: bool = false,
    has_object: bool = false,
    has_null: bool = false,
    has_undef: bool = false,
    has_any: bool = false,
    has_unknown: bool = false,
    has_never: bool = false,
    has_enum: bool = false,
    has_other: bool = false,
    // Tracks falsy possibilities — broad `string` could be empty, broad
    // `number` could be 0 / NaN, etc.  When a union mixes "always-
    // truthy" literals with nullish, the rule shouldn't fire (the test
    // is unambiguous: nullish vs truthy).
    string_possibly_falsy: bool = false,
    number_possibly_falsy: bool = false,
    boolean_possibly_falsy: bool = false,
};

fn classify(id: TypeId, opts: Options, ctx: *const LintContext) Class {
    _ = opts;
    var fam = Family{};
    walkType(id, &fam, ctx, 0);

    // Pure-nullish (null | undefined).
    const has_nullish = fam.has_null or fam.has_undef;
    const has_non_nullish = fam.has_string or fam.has_number or fam.has_boolean or fam.has_object or fam.has_any or fam.has_unknown or fam.has_enum or fam.has_other;
    if (has_nullish and !has_non_nullish) return .nullish_only;

    // Single-family + optional nullish.
    if (fam.has_any) return .any;
    if (fam.has_unknown) return .unknown;
    if (only_boolean(&fam)) {
        if (!has_nullish) return .boolean_ok;
        if (!fam.boolean_possibly_falsy) return .boolean_ok; // `true | null`
        return .nullable_boolean;
    }
    if (only_string(&fam)) {
        if (!has_nullish) return .string;
        // Nullable single-truthy-string-literal union narrows cleanly.
        if (!fam.string_possibly_falsy) return .boolean_ok;
        return .nullable_string;
    }
    if (only_number(&fam)) {
        if (!has_nullish) return .number;
        if (!fam.number_possibly_falsy) return .boolean_ok;
        return .nullable_number;
    }
    if (only_object(&fam)) return if (has_nullish) .nullable_object else .object;
    if (only_enum(&fam)) return if (has_nullish) .nullable_enum else .boolean_ok;
    if (fam.has_never and !has_non_nullish) return .never;
    return .mixed;
}

fn only_boolean(f: *const Family) bool {
    return f.has_boolean and !f.has_string and !f.has_number and !f.has_object and !f.has_any and !f.has_unknown and !f.has_enum and !f.has_other;
}
fn only_string(f: *const Family) bool {
    return f.has_string and !f.has_boolean and !f.has_number and !f.has_object and !f.has_any and !f.has_unknown and !f.has_enum and !f.has_other;
}
fn only_number(f: *const Family) bool {
    return f.has_number and !f.has_string and !f.has_boolean and !f.has_object and !f.has_any and !f.has_unknown and !f.has_enum and !f.has_other;
}
fn only_object(f: *const Family) bool {
    return f.has_object and !f.has_string and !f.has_number and !f.has_boolean and !f.has_any and !f.has_unknown and !f.has_enum and !f.has_other;
}
fn only_enum(f: *const Family) bool {
    return f.has_enum and !f.has_string and !f.has_number and !f.has_boolean and !f.has_object and !f.has_any and !f.has_unknown and !f.has_other;
}

fn walkType(id: TypeId, fam: *Family, ctx: *const LintContext, depth: u32) void {
    if (depth > 6) {
        fam.has_other = true;
        return;
    }
    if (id.eq(tymod.ID_ANY)) {
        fam.has_any = true;
        return;
    }
    if (id.eq(tymod.ID_UNKNOWN)) {
        fam.has_unknown = true;
        return;
    }
    const kind = ctx.typeIdKind(id) orelse {
        fam.has_any = true;
        return;
    };
    if (kind == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| walkType(m, fam, ctx, depth + 1);
        return;
    }
    if (kind == .intersection_t) {
        // Pick the first classifiable.  Conservative: classify each.
        for (ctx.typeIdUnionMembers(id)) |m| walkType(m, fam, ctx, depth + 1);
        return;
    }
    switch (kind) {
        .string => {
            fam.has_string = true;
            fam.string_possibly_falsy = true; // broad string includes ''
        },
        .string_literal => {
            fam.has_string = true;
            // Empty string literal type is the only falsy string literal.
            if (ctx.typeIdLiteralValue(id)) |lv| switch (lv) {
                .string => |s| if (s.len == 0) {
                    fam.string_possibly_falsy = true;
                },
                else => {},
            };
        },
        .number => {
            fam.has_number = true;
            fam.number_possibly_falsy = true;
        },
        .number_literal => {
            fam.has_number = true;
            if (ctx.typeIdLiteralValue(id)) |lv| switch (lv) {
                .number => |n| if (n == 0 or std.math.isNan(n)) {
                    fam.number_possibly_falsy = true;
                },
                else => {},
            };
        },
        .bigint => {
            fam.has_number = true;
            fam.number_possibly_falsy = true;
        },
        .bigint_literal => {
            fam.has_number = true;
            if (ctx.typeIdLiteralValue(id)) |lv| switch (lv) {
                .bigint => |b| if (std.mem.eql(u8, b, "0")) {
                    fam.number_possibly_falsy = true;
                },
                else => {},
            };
        },
        .boolean => {
            fam.has_boolean = true;
            fam.boolean_possibly_falsy = true;
        },
        .boolean_literal => {
            fam.has_boolean = true;
            if (ctx.typeIdLiteralValue(id)) |lv| switch (lv) {
                .boolean => |b| if (!b) {
                    fam.boolean_possibly_falsy = true;
                },
                else => {},
            };
        },
        .null_t => fam.has_null = true,
        .undefined_t, .void_t => fam.has_undef = true,
        .object_t, .object_keyword, .array_t, .readonly_array_t, .tuple_t, .function_t => fam.has_object = true,
        .never => fam.has_never = true,
        .error_t => fam.has_any = true,
        .type_ref => {
            const name = ctx.typeIdRefName(id);
            if (name.len > 0 and ctx.typeNameIsEnum(name)) {
                fam.has_enum = true;
            } else {
                // Other type_ref (e.g. user type alias resolved here) —
                // treat as object-like.
                fam.has_object = true;
            }
        },
        .type_param => fam.has_other = true,
        else => fam.has_other = true,
    }
}

fn messageFor(c: Class, opts: Options) ?[]const u8 {
    return switch (c) {
        .boolean_ok => null,
        .never => null,
        .any => if (opts.allow_any) null else "conditionErrorAny",
        .unknown => "conditionErrorAny",
        .string => if (opts.allow_string) null else "conditionErrorString",
        .number => if (opts.allow_number) null else "conditionErrorNumber",
        .object => "conditionErrorObject",
        .nullish_only => "conditionErrorNullish",
        .nullable_boolean => if (opts.allow_nullable_boolean) null else "conditionErrorNullableBoolean",
        .nullable_string => if (opts.allow_nullable_string) null else "conditionErrorNullableString",
        .nullable_number => if (opts.allow_nullable_number) null else "conditionErrorNullableNumber",
        .nullable_object => if (opts.allow_nullable_object) null else "conditionErrorNullableObject",
        .nullable_enum => if (opts.allow_nullable_enum) null else "conditionErrorNullableEnum",
        .mixed => "conditionErrorOther",
    };
}
