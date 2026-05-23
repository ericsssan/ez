// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-base-to-string
//
// Reports uses of objects in string contexts whose `.toString()`
// returns `[object Object]` (i.e. they don't override Object.prototype.
// toString).  Visitors: binary `+` / `+=` with a string operand,
// template-literal interpolations, `String(x)`, `.toString()` /
// `.toLocaleString()` method calls, and `.join()` on arrays.

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
    .name = "no-base-to-string",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow toString-coercion of objects without user toString()",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .add, .add_assign,
    .template_literal,
    .call_expr, .optional_call_expr,
};

pub const needs_semantic = true;

const Certainty = enum { always, sometimes, never };

const DEFAULT_IGNORED: []const []const u8 = &.{ "Error", "RegExp", "URL", "URLSearchParams" };

const Options = struct {
    check_unknown: bool = false,
    ignored: []const []const u8 = DEFAULT_IGNORED,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("checkUnknown")) |x| if (x == .bool) { opts.check_unknown = x.bool; };
    // Note: `ignoredTypeNames` from options would override DEFAULT_IGNORED.
    // We keep DEFAULT_IGNORED if no override; ESLint's default merges with
    // option, but TSe applies the option directly (when supplied, the
    // option replaces).  Honour the option when present.
    // `ignoredTypeNames` option: consulted lazily in the certainty
    // walk via `isOptionIgnored`.  We keep DEFAULT_IGNORED here to avoid
    // re-allocating per-call; the user's array is checked separately.
    _ = v.object.get("ignoredTypeNames");
    return opts;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .add, .add_assign => checkBinaryAdd(node, opts, ctx),
        .template_literal => checkTemplateLiteral(node, opts, ctx),
        .call_expr, .optional_call_expr => checkCall(node, opts, ctx),
        else => {},
    }
}

fn checkBinaryAdd(node: NodeIndex, opts: Options, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    // For `+=`, the LHS holds the assignment target (mutable string).
    const left_ty = ctx.typeOfNode(d.lhs);
    const right_ty = ctx.typeOfNode(d.rhs);
    if (ctx.typeIdIsStringy(left_ty)) {
        checkExpr(d.rhs, right_ty, opts, ctx);
    } else if (ctx.typeIdIsStringy(right_ty)) {
        checkExpr(d.lhs, left_ty, opts, ctx);
    }
}

fn checkTemplateLiteral(node: NodeIndex, opts: Options, ctx: *const LintContext) void {
    // Tagged templates (`tag`literal``) — don't check (tag has its own logic).
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .tagged_template) return;
    // template_literal.data is a SubRange into extra_data carrying parts.
    // Parts alternate template_element and expressions.  We only care
    // about non-template_element entries.
    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const part: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(part) == .template_element) continue;
        checkExpr(part, ctx.typeOfNode(part), opts, ctx);
    }
}

fn checkCall(node: NodeIndex, opts: Options, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    var callee = d.lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ctag = ctx.nodeTag(callee);
    // `String(x)` — global String identifier called.
    if (ctag == .identifier and std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "String")) {
        if (ctx.isGlobalReference(callee)) {
            const args = callArgs(node, ctx);
            if (args.len > 0) {
                const arg: NodeIndex = @enumFromInt(args[0]);
                if (ctx.nodeTag(arg) != .spread_element) {
                    checkExpr(arg, ctx.typeOfNode(arg), opts, ctx);
                }
            }
        }
        return;
    }
    // `<obj>.toString()` / `<obj>.toLocaleString()` / `<obj>.join()`.
    if (ctag == .member_expr or ctag == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs == .none) return;
        const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
        if (std.mem.eql(u8, prop, "toString") or std.mem.eql(u8, prop, "toLocaleString")) {
            const obj = md.lhs;
            checkExpr(obj, ctx.typeOfNode(obj), opts, ctx);
        } else if (std.mem.eql(u8, prop, "join")) {
            const obj = md.lhs;
            checkArrayJoin(obj, ctx.typeOfNode(obj), opts, ctx);
        }
    }
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) []const u32 {
    const d = ctx.nodeData(call);
    if (d.rhs == .none) return &.{};
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[sr.start..sr.end];
}

fn checkExpr(expr: NodeIndex, ty: TypeId, opts: Options, ctx: *const LintContext) void {
    // Literal nodes are never object-typed at the source level.
    const tag = ctx.nodeTag(expr);
    if (tag == .string_literal or tag == .number_literal or
        tag == .boolean_literal or tag == .bigint_literal or
        tag == .null_literal or tag == .regex_literal) return;
    // AST-level ignore check: the binding's declared type may be a
    // user-ignored type whose resolved TypeId lost the original name.
    if (exprAnnotationMatchesIgnored(expr, opts, ctx)) return;
    const cert = toStringCertainty(ty, opts, ctx, 0);
    if (cert == .always) return;
    report(expr, cert, opts, ctx, false);
}

/// Walk `expr`'s declared annotation and check whether the outermost
/// type-reference name is in `opts.ignored` or the rule's
/// `ignoredTypeNames` option.  Covers the case where the checker
/// resolved the reference to its structural body (object_t / class
/// instance) and lost the original name.
fn exprAnnotationMatchesIgnored(expr: NodeIndex, opts: Options, ctx: *const LintContext) bool {
    var e = expr;
    while (ctx.nodeTag(e) == .grouping_expr or ctx.nodeTag(e) == .ts_non_null_expr) {
        e = ctx.nodeData(e).lhs;
    }
    if (ctx.nodeTag(e) != .identifier) return false;
    const sym = symbolForIdent(e, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    var inner = ctx.nodeData(bd.rhs).lhs;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(inner));
    // Direct match.
    for (opts.ignored) |ig| if (std.mem.eql(u8, ig, name)) return true;
    if (optionIgnoredNamesContains(name, ctx)) return true;
    // Inheritance walk: `class Cat extends Animal {}` with ignored Animal.
    for (opts.ignored) |ig| {
        if (ctx.declaredTypeInheritsFrom(name, ig)) return true;
    }
    if (optionIgnoredNamesInheritedFrom(name, ctx)) return true;
    return false;
}

fn optionIgnoredNamesInheritedFrom(decl_name: []const u8, ctx: *const LintContext) bool {
    const v = ctx.rule_options orelse return false;
    if (v.* != .object) return false;
    const arr = v.object.get("ignoredTypeNames") orelse return false;
    if (arr != .array) return false;
    for (arr.array.items) |item| {
        if (item == .string and ctx.declaredTypeInheritsFrom(decl_name, item.string)) return true;
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

fn checkArrayJoin(obj: NodeIndex, ty: TypeId, opts: Options, ctx: *const LintContext) void {
    const cert = joinCertainty(ty, opts, ctx, 0);
    if (cert == .always) return;
    report(obj, cert, opts, ctx, true);
}

/// True when this property is one of `toString` / `toLocaleString` /
/// `valueOf` declared on the type's structural shape (i.e. NOT inherited
/// from Object.prototype).  My checker treats `class Foo { toString() }`
/// as a regular `object_t` prop, so any prop named one of those =
/// user override.
fn hasUserStringCoercion(id: TypeId, ctx: *const LintContext) bool {
    return ctx.typeIdHasProperty(id, "toString") or
        ctx.typeIdHasProperty(id, "toLocaleString") or
        ctx.typeIdHasProperty(id, "valueOf");
}

fn toStringCertainty(id: TypeId, opts: Options, ctx: *const LintContext, depth: u8) Certainty {
    if (depth > 8) return .always;
    // Primitives + null/undefined + symbol/bigint: their default toString
    // is meaningful.
    if (ctx.typeIdIsStringy(id)) return .always;
    if (ctx.typeIdIsExactlyNumber(id)) return .always;
    if (ctx.typeIdIsExactlyBigint(id)) return .always;
    if (ctx.typeIdIsExactlyBoolean(id)) return .always;
    if (id.eq(tymod.ID_NULL) or id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID) or id.eq(tymod.ID_SYMBOL)) return .always;
    if (ctx.typeIdIsAny(id)) return .always;
    if (ctx.typeIdIsUnknown(id)) return if (opts.check_unknown) .sometimes else .always;
    if (id.eq(tymod.ID_NEVER)) return .always;
    // Function values inherit Function.prototype.toString — meaningful
    // source-code stringification.
    if (ctx.typeIdIsFunction(id)) return .always;

    // Ignored types: defaults (Error, RegExp, URL, URLSearchParams)
    // plus user-supplied `ignoredTypeNames`.  Match against either
    // class/interface inheritance OR a direct type_ref name (covers
    // type aliases that don't appear in inheritance chains).
    for (opts.ignored) |name| {
        if (ctx.typeIdInheritsFrom(id, name)) return .always;
    }
    const ref_name_for_ignore = ctx.typeIdRefName(id);
    if (ref_name_for_ignore.len != 0) {
        for (opts.ignored) |name| {
            if (std.mem.eql(u8, ref_name_for_ignore, name)) return .always;
        }
        if (optionIgnoredNamesContains(ref_name_for_ignore, ctx)) return .always;
    }
    if (ctx.typeIdIsUnion(id) or ctx.typeIdIsIntersection(id)) {
        // Handled below.
    }

    // Union: all-always → always; all-never → never; else sometimes.
    if (ctx.typeIdIsUnion(id)) {
        var all_always = true;
        var all_never = true;
        for (ctx.typeIdUnionMembers(id)) |m| {
            const c = toStringCertainty(m, opts, ctx, depth + 1);
            if (c != .always) all_always = false;
            if (c != .never) all_never = false;
        }
        if (all_always) return .always;
        if (all_never) return .never;
        return .sometimes;
    }
    // Intersection: any-always → always.
    if (ctx.typeIdIsIntersection(id)) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (toStringCertainty(m, opts, ctx, depth + 1) == .always) return .always;
        }
        return .never;
    }
    // Tuple / array: element-driven.
    const elems = ctx.typeIdArrayLikeElems(id);
    if (elems.len > 0) {
        // For tuples, sum certainties; for arrays, single element.
        var saw_never = false;
        var saw_sometimes = false;
        for (elems) |el| {
            const c = toStringCertainty(el, opts, ctx, depth + 1);
            if (c == .never) saw_never = true;
            if (c == .sometimes) saw_sometimes = true;
        }
        if (saw_never) return .never;
        if (saw_sometimes) return .sometimes;
        return .always;
    }
    // Type alias / declared reference: resolve and recurse on the body.
    const ref_name = ctx.typeIdRefName(id);
    if (ref_name.len != 0) {
        if (ctx.resolveDeclaredTypeByName(ref_name)) |body| {
            if (!body.eq(id)) return toStringCertainty(body, opts, ctx, depth + 1);
        }
    }
    // Object with user-defined toString-like method: always-clean.
    if (hasUserStringCoercion(id, ctx)) return .always;
    // Default Object → "[object Object]" = never.
    return .never;
}

fn joinCertainty(id: TypeId, opts: Options, ctx: *const LintContext, depth: u8) Certainty {
    if (depth > 8) return .always;
    if (ctx.typeIdIsUnion(id)) {
        var all_always = true;
        var all_never = true;
        for (ctx.typeIdUnionMembers(id)) |m| {
            const c = joinCertainty(m, opts, ctx, depth + 1);
            if (c != .always) all_always = false;
            if (c != .never) all_never = false;
        }
        if (all_always) return .always;
        if (all_never) return .never;
        return .sometimes;
    }
    if (ctx.typeIdIsIntersection(id)) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (joinCertainty(m, opts, ctx, depth + 1) == .always) return .always;
        }
        return .never;
    }
    // For arrays/tuples, the join certainty equals the element's toString
    // certainty.
    const elems = ctx.typeIdArrayLikeElems(id);
    if (elems.len > 0) {
        // Tuple: ANY-never → never, ANY-sometimes → sometimes.
        var saw_never = false;
        var saw_sometimes = false;
        for (elems) |el| {
            const c = toStringCertainty(el, opts, ctx, depth + 1);
            if (c == .never) saw_never = true;
            if (c == .sometimes) saw_sometimes = true;
        }
        if (saw_never) return .never;
        if (saw_sometimes) return .sometimes;
        return .always;
    }
    // Non-array receiver — `.join()` doesn't fire here.
    return .always;
}

/// Check the rule's `ignoredTypeNames` option for `name`.  Reads
/// directly from `ctx.rule_options` so we don't have to allocate per
/// invocation.
fn optionIgnoredNamesContains(name: []const u8, ctx: *const LintContext) bool {
    const v = ctx.rule_options orelse return false;
    if (v.* != .object) return false;
    const arr = v.object.get("ignoredTypeNames") orelse return false;
    if (arr != .array) return false;
    for (arr.array.items) |item| {
        if (item == .string and std.mem.eql(u8, item.string, name)) return true;
    }
    return false;
}

fn report(node: NodeIndex, cert: Certainty, opts: Options, ctx: *const LintContext, is_join: bool) void {
    _ = opts;
    const certainty_text: []const u8 = switch (cert) {
        .never => "will",
        .sometimes => "may",
        .always => return,
    };
    const sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    const name = if (sp.end > sp.start and sp.end <= src.len) src[sp.start..sp.end] else "";
    const msg_id: []const u8 = if (is_join) "baseArrayJoin" else "baseToString";
    ctx.reportWithMessageIdAndData(node, msg_id, &[_]MessageDataEntry{
        .{ .key = "name", .val = name },
        .{ .key = "certainty", .val = certainty_text },
    });
}
