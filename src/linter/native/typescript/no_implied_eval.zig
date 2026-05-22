// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-implied-eval
//
// Reports calls to eval-like globals (setTimeout/setInterval/
// setImmediate/execScript) with a non-function first argument, and
// uses of the Function constructor.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-implied-eval",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `eval()`-like functions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

const EVAL_LIKE_NAMES = [_][]const u8{
    "setTimeout", "setInterval", "setImmediate", "execScript",
};
const GLOBAL_CANDIDATES = [_][]const u8{ "global", "globalThis", "window" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const callee_name = getCalleeName(ctx.nodeData(node).lhs, ctx) orelse return;
    const tag = ctx.nodeTag(node);
    // Function constructor: `new Function(...)` / `Function(...)`.
    if (std.mem.eql(u8, callee_name, "Function")) {
        const callee = ctx.nodeData(node).lhs;
        // Reject when the callee resolves to global Function (or
        // unresolved — treat as global).
        var inner = callee;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) == .identifier and !ctx.isGlobalReference(inner)) return;
        ctx.reportWithMessageId(node, "noFunctionConstructor");
        return;
    }
    // eval-like globals.
    if (!isEvalLike(callee_name)) return;
    // Only fire on call_expr / optional_call_expr — not new_expr.
    if (tag == .new_expr) return;
    // Must be a reference to the global function.
    if (!calleeIsGlobalFunctionReference(ctx.nodeData(node).lhs, callee_name, ctx)) return;
    const args = callArgs(node, ctx) orelse return;
    if (args.len == 0) return;
    const handler: NodeIndex = @enumFromInt(args[0]);
    if (argLooksLikeFunction(handler, ctx)) return;
    ctx.reportSpanWithMessageId(ctx.nodeSpan(handler), "noImpliedEvalError");
}

fn getCalleeName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (callee == .none) return null;
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) return ctx.tokenText(ctx.nodeMainToken(n));
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(n);
        if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) return null;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
        var is_global_obj = false;
        for (GLOBAL_CANDIDATES) |g| if (std.mem.eql(u8, g, obj_name)) { is_global_obj = true; break; };
        if (!is_global_obj) return null;
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    // Computed property: `window['setTimeout']` / `globalThis["Function"]`.
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const md = ctx.nodeData(n);
        if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) return null;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
        var is_global_obj = false;
        for (GLOBAL_CANDIDATES) |g| if (std.mem.eql(u8, g, obj_name)) { is_global_obj = true; break; };
        if (!is_global_obj) return null;
        // Bracket key must be a string literal.
        if (md.rhs == .none) return null;
        if (ctx.nodeTag(md.rhs) != .string_literal) return null;
        return stringLiteralValue(md.rhs, ctx);
    }
    return null;
}

fn stringLiteralValue(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tok = ctx.nodeMainToken(node);
    const raw = ctx.tokenText(tok);
    if (raw.len < 2) return null;
    return raw[1 .. raw.len - 1];
}

fn isEvalLike(name: []const u8) bool {
    for (EVAL_LIKE_NAMES) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn calleeIsGlobalFunctionReference(callee: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), name)) return false;
        return ctx.isGlobalReference(n);
    }
    if (tag == .member_expr or tag == .optional_member_expr or
        tag == .computed_member_expr or tag == .optional_computed_member_expr)
    {
        // `window.setTimeout` / `window['setTimeout']` — already
        // validated by getCalleeName matching a GLOBAL_CANDIDATES object.
        return true;
    }
    return false;
}

fn argLooksLikeFunction(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (true) {
        const t = ctx.nodeTag(n);
        if (t == .grouping_expr) { n = ctx.nodeData(n).lhs; continue; }
        // TS casts/assertions: the asserted type is decorative; check the
        // EXPRESSION beneath, not the type.  `foo as any` should still
        // report when foo is a string.
        if (t == .ts_as_expr or t == .ts_satisfies_expr or t == .ts_type_assertion) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        // `!` non-null assertion.
        if (t == .ts_non_null_expr) { n = ctx.nodeData(n).lhs; continue; }
        break;
    }
    const tag = ctx.nodeTag(n);
    // Direct function-shaped literals.
    if (tag == .arrow_fn or tag == .async_arrow_fn or
        tag == .fn_expr or tag == .async_fn_expr or
        tag == .generator_fn_expr or tag == .async_generator_fn_expr) return true;
    // Non-function literals.
    if (tag == .string_literal or tag == .template_literal or
        tag == .number_literal or tag == .boolean_literal or
        tag == .null_literal or tag == .bigint_literal) return false;
    // `undefined` identifier specifically — TS treats this as undefined value.
    if (tag == .identifier and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined")) return false;
    // Conditional / logical_or / logical_nullish: both branches must
    // look like functions for the result to qualify.
    if (tag == .conditional) {
        const md = ctx.nodeData(n);
        const cons_alt = ctx.ast.extra_data;
        if (md.rhs != .none) {
            const idx = @intFromEnum(md.rhs);
            if (idx + 1 < cons_alt.len) {
                const cons: NodeIndex = @enumFromInt(cons_alt[idx]);
                const alt: NodeIndex = @enumFromInt(cons_alt[idx + 1]);
                return argLooksLikeFunction(cons, ctx) and argLooksLikeFunction(alt, ctx);
            }
        }
    }
    if (tag == .logical_or or tag == .nullish_coalesce) {
        const md = ctx.nodeData(n);
        return argLooksLikeFunction(md.lhs, ctx) and argLooksLikeFunction(md.rhs, ctx);
    }
    // For everything else, consult the type.  function_t types are
    // OK; anything else (string/number/object/etc.) is a violation.
    const ty = ctx.typeOfNode(n);
    // If the identifier's declared annotation is a union including a
    // non-function shape (e.g. `foo: string | any`), TSe still fires
    // even though typeOf collapses to `any`.  Walk the AST annotation
    // directly to defeat the union-with-any collapse.
    if (tag == .identifier and annotationCouldBeNonFunction(n, ctx)) return false;
    if (ctx.typeIdIsAny(ty) or ctx.typeIdContainsUnknown(ty)) return true; // lenient
    return ctx.typeIdIsFunction(ty);
}

fn annotationCouldBeNonFunction(ident: NodeIndex, ctx: *const LintContext) bool {
    // Resolve identifier to its declaration; the declaration carries
    // the type annotation in `rhs`.
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    const ann = ctx.nodeData(decl).rhs;
    if (ann == .none or ctx.nodeTag(ann) != .ts_type_annotation) return false;
    var inner = ctx.nodeData(ann).lhs;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_union_type) return false;
    const data = ctx.nodeData(inner);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (typeRefIsKnownNonFunction(m, ctx)) return true;
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

fn typeRefIsKnownNonFunction(n: NodeIndex, ctx: *const LintContext) bool {
    var t = n;
    while (ctx.nodeTag(t) == .ts_parenthesized_type) t = ctx.nodeData(t).lhs;
    if (ctx.nodeTag(t) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(t));
    const non_fn_names = [_][]const u8{
        "string", "number", "boolean", "bigint", "symbol", "void", "null", "undefined", "never",
    };
    for (non_fn_names) |b| if (std.mem.eql(u8, name, b)) return true;
    return false;
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}
