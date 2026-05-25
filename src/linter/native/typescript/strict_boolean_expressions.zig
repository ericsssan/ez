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
            // Array predicate methods: `arr.{some,every,filter,find,
            // findIndex,findLast,findLastIndex}(cb)` — cb's return is
            // implicitly tested for truthiness.  Walk the body's
            // return / expression target.
            checkArrayPredicateCallback(callee, d.rhs, opts, ctx);
            // Assertion functions: `declare function assert(x): asserts x;
            // assert(value)` — the argument is being implicitly tested.
            const callee_ty = ctx.typeOfNode(callee);
            if (ctx.functionAssertionInfo(callee_ty)) |info| {
                // `asserts x is X` is a type-narrowing assertion, not a
                // truthiness test — don't apply boolean-context rules
                // to the asserted argument.
                if (!info.target.eq(tymod.TypeId.none)) return;
                if (d.rhs == .none) return;
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return;
                const args = ctx.ast.extra_data[sr.start..sr.end];
                // Spread arguments make positional indexing unreliable
                // (`f(...xs, y)` could put `y` at any param slot).
                // Bail out conservatively.
                for (args) |raw| {
                    if (ctx.nodeTag(@enumFromInt(raw)) == .spread_element) return;
                }
                if (info.param_index >= args.len) return;
                const arg: NodeIndex = @enumFromInt(args[info.param_index]);
                walkBoolCtx(arg, opts, ctx, 0);
                return;
            }
        },
        else => {},
    }
}

fn isArrayPredicateMethod(name: []const u8) bool {
    return std.mem.eql(u8, name, "filter") or
        std.mem.eql(u8, name, "find") or
        std.mem.eql(u8, name, "findIndex") or
        std.mem.eql(u8, name, "findLast") or
        std.mem.eql(u8, name, "findLastIndex") or
        std.mem.eql(u8, name, "some") or
        std.mem.eql(u8, name, "every");
}

fn checkArrayPredicateCallback(callee: NodeIndex, args_rhs: NodeIndex, opts: Options, ctx: *const LintContext) void {
    if (ctx.nodeTag(callee) != .member_expr and ctx.nodeTag(callee) != .optional_member_expr) return;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return;
    const method = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    // Only the *boolean*-result predicate methods participate here.
    // `.map` / `.forEach` / `.flatMap` callbacks aren't tested for
    // truthiness even though their first param gets contextual typing.
    if (!isArrayPredicateMethod(method)) return;
    if (!ctx.typeIsArrayLikeOrUnresolved(ctx.narrowedTypeOf(md.lhs))) return;
    if (args_rhs == .none) return;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(args_rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return;
    const arg: NodeIndex = @enumFromInt(ctx.ast.extra_data[sr.start]);
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .async_arrow_fn or tag == .async_fn_expr) {
        ctx.reportWithMessageId(n, "predicateCannotBeAsync");
        return;
    }
    if (tag == .arrow_fn) {
        const ad_d = ctx.nodeData(n);
        if (ad_d.lhs == .none) return;
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ad_d.lhs));
        if (ad.body == .none) return;
        if (ctx.nodeTag(ad.body) == .block_stmt) {
            // For block-body callbacks, TS-eslint reports the diagnostic
            // on the callback node, not on the return value.
            checkPredicateReturnsOnCallback(n, ad.body, opts, ctx);
        } else {
            // Expression-body arrow — TS-eslint also reports on the
            // arrow itself, not on the inner expression.
            const klass = classify(ctx.narrowedTypeOf(ad.body), opts, ctx);
            if (messageFor(klass, opts)) |id| ctx.reportWithMessageId(n, id);
        }
        return;
    }
    if (tag == .fn_expr) {
        const fd_d = ctx.nodeData(n);
        if (fd_d.lhs == .none) return;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(fd_d.lhs));
        if (fd.body == .none) return;
        checkPredicateReturnsOnCallback(n, fd.body, opts, ctx);
        return;
    }
    if (tag == .identifier) {
        // Named function reference — classify by its declared return type.
        const callee_ty = ctx.typeOfNode(n);
        const ret_ty = ctx.functionReturnType(callee_ty) orelse return;
        const klass = classify(ret_ty, opts, ctx);
        if (messageFor(klass, opts)) |id| ctx.reportWithMessageId(n, id);
        return;
    }
}

fn checkPredicateReturnsOnCallback(cb: NodeIndex, body: NodeIndex, opts: Options, ctx: *const LintContext) void {
    // When the callback has an explicit return type annotation, use
    // it directly — that's what TS-eslint sees.
    if (callbackReturnTypeAnnotation(cb, ctx)) |ret_ann| {
        const ty = ctx.resolveTypeAnnotationNode(ret_ann);
        const klass = classify(ty, opts, ctx);
        if (messageFor(klass, opts)) |id| ctx.reportWithMessageId(cb, id);
        return;
    }
    if (ctx.nodeTag(body) != .block_stmt) return;
    const d = ctx.nodeData(body);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    var saw_return = false;
    var any_indeterminate = false;
    var combined_id: ?[]const u8 = null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(stmt) != .return_stmt) continue;
        saw_return = true;
        const rd = ctx.nodeData(stmt);
        const id: []const u8 = if (rd.lhs == .none)
            "conditionErrorNullish"
        else blk: {
            const ty = ctx.narrowedTypeOf(rd.lhs);
            const klass = classify(ty, opts, ctx);
            break :blk messageFor(klass, opts) orelse {
                any_indeterminate = true;
                continue;
            };
        };
        if (combined_id == null) {
            combined_id = id;
        } else if (!std.mem.eql(u8, combined_id.?, id)) {
            any_indeterminate = true;
        }
    }
    if (saw_return) {
        if (!any_indeterminate) {
            if (combined_id) |id| ctx.reportWithMessageId(cb, id);
        }
        return;
    }
    // No return statement seen at the top level — the callback might
    // still return via nested blocks/if/try.  Bail unless we're sure
    // the function returns void.  Use the explicit return annotation
    // if present: a callback annotated `: boolean` clearly returns;
    // one without an annotation that we can prove has no nested
    // returns implicitly returns `undefined`.
    // No top-level return, no nested return — implicit undefined.
    if (callbackHasAnyReturnRecursive(body, ctx)) return;
    ctx.reportWithMessageId(cb, "conditionErrorNullish");
}

fn callbackReturnTypeAnnotation(cb: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const tag = ctx.nodeTag(cb);
    const d = ctx.nodeData(cb);
    if (d.lhs == .none) return null;
    if (tag == .arrow_fn or tag == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
        if (ad.return_type == .none) return null;
        // The annotation is a ts_type_annotation; peel to inner type.
        if (ctx.nodeTag(ad.return_type) == .ts_type_annotation) {
            const inner = ctx.nodeData(ad.return_type).lhs;
            if (inner == .none) return null;
            return inner;
        }
        return ad.return_type;
    }
    if (tag == .fn_expr or tag == .async_fn_expr or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr)
    {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        if (fd.return_type == .none) return null;
        if (ctx.nodeTag(fd.return_type) == .ts_type_annotation) {
            const inner = ctx.nodeData(fd.return_type).lhs;
            if (inner == .none) return null;
            return inner;
        }
        return fd.return_type;
    }
    return null;
}

fn callbackHasExplicitReturnAnnotation(cb: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(cb);
    const d = ctx.nodeData(cb);
    if (d.lhs == .none) return false;
    if (tag == .arrow_fn or tag == .async_arrow_fn) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
        return ad.return_type != .none;
    }
    if (tag == .fn_expr or tag == .async_fn_expr or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr)
    {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
        return fd.return_type != .none;
    }
    return false;
}

fn callbackHasAnyReturnRecursive(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    const tag = ctx.nodeTag(body);
    if (tag == .return_stmt) return true;
    // Only walk known statement containers — generic d.lhs/d.rhs
    // walks are unsafe because many nodes store extra-data indices
    // there, not NodeIndex.
    const d = ctx.nodeData(body);
    if (tag == .block_stmt) {
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (callbackHasAnyReturnRecursive(@enumFromInt(raw), ctx)) return true;
            }
        }
        return false;
    }
    if (tag == .if_stmt) {
        // d.lhs = cond, d.rhs = then-body.  Else-body lives elsewhere.
        return callbackHasAnyReturnRecursive(d.rhs, ctx);
    }
    if (tag == .if_else_stmt) {
        const ed = ctx.extraData(ast.IfData, @intFromEnum(d.rhs));
        return callbackHasAnyReturnRecursive(ed.consequent, ctx) or
            callbackHasAnyReturnRecursive(ed.alternate, ctx);
    }
    if (tag == .try_stmt) {
        const ed = ctx.extraData(ast.TryData, @intFromEnum(d.rhs));
        return callbackHasAnyReturnRecursive(d.lhs, ctx) or
            callbackHasAnyReturnRecursive(ed.catch_node, ctx) or
            callbackHasAnyReturnRecursive(ed.finally_body, ctx);
    }
    if (tag == .switch_stmt) {
        if (d.rhs == .none) return false;
        const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
        if (sr.end <= sr.start or sr.end > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
            if (callbackHasAnyReturnRecursive(@enumFromInt(raw), ctx)) return true;
        }
        return false;
    }
    if (tag == .switch_case or tag == .switch_default) {
        if (d.rhs == .none) return false;
        const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
        if (sr.end <= sr.start or sr.end > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
            if (callbackHasAnyReturnRecursive(@enumFromInt(raw), ctx)) return true;
        }
        return false;
    }
    if (tag == .for_stmt or tag == .for_in_stmt or
        tag == .for_of_stmt or tag == .for_await_of_stmt or
        tag == .while_stmt or tag == .do_while_stmt or
        tag == .labeled_stmt)
    {
        // Body is in d.rhs for these statement kinds.
        return callbackHasAnyReturnRecursive(d.rhs, ctx);
    }
    return false;
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
    var ty = ctx.narrowedTypeOf(n);
    // TS treats un-annotated function-param identifiers as implicit
    // `any` (not `unknown`).  Our checker stores them as UNKNOWN to
    // keep no-unsafe-* quiet; bridge the gap here so allowAny works.
    if (ty.eq(@import("../../../checker/types.zig").ID_UNKNOWN) and isUnannotatedParamRef(n, ctx)) {
        ty = @import("../../../checker/types.zig").ID_ANY;
    }
    const classification = classify(ty, opts, ctx);
    const msg = messageFor(classification, opts);
    if (msg) |m| ctx.reportWithMessageId(n, m);
}

fn isUnannotatedParamRef(n: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(n) != .identifier) return false;
    const decl = ctx.declOf(n) orelse return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    // Param identifiers have no annotation when rhs is .none AND the
    // parent is an arrow_fn / fn_expr / similar function-like node.
    const ann = ctx.nodeData(decl).rhs;
    if (ann != .none) return false;
    var p = ctx.parentOf(decl);
    var depth: u32 = 0;
    while (p != .none and depth < 4) : ({ p = ctx.parentOf(p); depth += 1; }) {
        switch (ctx.nodeTag(p)) {
            .arrow_fn, .async_arrow_fn,
            .fn_expr, .async_fn_expr,
            .generator_fn_expr, .async_generator_fn_expr,
            .fn_decl, .async_fn_decl,
            .generator_fn_decl, .async_generator_fn_decl,
            .method_def, .computed_method_def,
            .constructor_def,
            => return true,
            // Skip pattern wrappers between identifier and the function.
            .ts_parameter_property, .assignment_pattern, .rest_element,
            .array_pattern, .object_pattern,
            .property, .shorthand_property,
            => {},
            else => return false,
        }
    }
    return false;
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
        // Branded primitives like `string & { __BRAND: 'X' }` should
        // classify as the primitive — the object brand marker doesn't
        // change the boolean-context behavior.  Walk each member with
        // a temp family first; if any member is a primitive, keep only
        // primitive contributions (skip the brand objects).
        var sub: Family = .{};
        for (ctx.typeIdUnionMembers(id)) |m| walkType(m, &sub, ctx, depth + 1);
        const has_primitive = sub.has_string or sub.has_number or sub.has_boolean;
        if (has_primitive) {
            fam.has_string = fam.has_string or sub.has_string;
            fam.string_possibly_falsy = fam.string_possibly_falsy or sub.string_possibly_falsy;
            fam.has_number = fam.has_number or sub.has_number;
            fam.number_possibly_falsy = fam.number_possibly_falsy or sub.number_possibly_falsy;
            fam.has_boolean = fam.has_boolean or sub.has_boolean;
            fam.boolean_possibly_falsy = fam.boolean_possibly_falsy or sub.boolean_possibly_falsy;
            return;
        }
        // No primitive — merge whatever sub captured.
        fam.has_object = fam.has_object or sub.has_object;
        fam.has_null = fam.has_null or sub.has_null;
        fam.has_undef = fam.has_undef or sub.has_undef;
        fam.has_any = fam.has_any or sub.has_any;
        fam.has_unknown = fam.has_unknown or sub.has_unknown;
        fam.has_never = fam.has_never or sub.has_never;
        fam.has_enum = fam.has_enum or sub.has_enum;
        fam.has_other = fam.has_other or sub.has_other;
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
        .object_t, .object_keyword, .array_t, .readonly_array_t, .tuple_t, .function_t, .symbol => fam.has_object = true,
        .never => fam.has_never = true,
        .error_t => fam.has_any = true,
        .type_ref => {
            const name = ctx.typeIdRefName(id);
            if (name.len > 0 and ctx.typeNameIsEnum(name)) {
                fam.has_enum = true;
            } else if (name.len > 0 and ctx.typeDeclNode(name) == .none) {
                // Not a user-declared interface/alias/class — likely
                // a type parameter (or external name we can't resolve).
                // TS-eslint treats `<T>(x: T)` boolean tests as if x
                // were `any`.  Default to has_any so allowAny applies.
                fam.has_any = true;
            } else {
                fam.has_object = true;
            }
        },
        .type_param => fam.has_any = true,
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
