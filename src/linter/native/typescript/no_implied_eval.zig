// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-implied-eval
//
// Reports calls to eval-like globals (setTimeout/setInterval/
// setImmediate/execScript) with a non-function first argument, and
// uses of the Function constructor.

const std = @import("std");
const parser = @import("es_parser");
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
    .lang = .all,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

const EVAL_LIKE_NAMES = [_][]const u8{
    "setTimeout", "setInterval", "setImmediate", "execScript",
};
const GLOBAL_CANDIDATES = [_][]const u8{ "global", "globalThis", "window", "self" };

/// True when `name` resolves to a recognized global in the linted file's
/// scope — either an explicit `languageOptions.globals` entry, or a
/// commonjs-source-type built-in (`global`).  Matches ESLint core's
/// `getVariableByName` gate so we don't fire on `window.setTimeout(...)`
/// when `window` isn't enabled.  `globalThis` is added via the env
/// config in modern setups, so we rely on the same explicit-enable
/// check rather than hardcoding it.
fn isKnownGlobalName(name: []const u8, ctx: *const LintContext) bool {
    // `globalThis` is a built-in starting ES2020.
    if (std.mem.eql(u8, name, "globalThis") and ctx.getEcmaVersion() >= 2020) return true;
    // `global` is a Node.js built-in under `sourceType: "commonjs"`.
    if (std.mem.eql(u8, name, "global")) {
        if (ctx.getLanguageOptionString("sourceType")) |st| {
            if (std.mem.eql(u8, st, "commonjs")) return true;
        }
    }
    return ctx.globalIsExplicitlyEnabled(name);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const is_ts = ctx.isTypeScript();
    const callee_name = getCalleeName(ctx.nodeData(node).lhs, ctx) orelse return;
    const tag = ctx.nodeTag(node);
    // Function constructor: `new Function(...)` / `Function(...)`.
    // ESLint core ignores Function-constructor — only the TSe variant flags it.
    if (std.mem.eql(u8, callee_name, "Function")) {
        if (!is_ts) return;
        const callee = ctx.nodeData(node).lhs;
        var inner = callee;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) == .identifier and !ctx.isGlobalReference(inner)) return;
        ctx.reportWithMessageId(node, "noFunctionConstructor");
        return;
    }
    // eval-like globals.
    if (!isEvalLike(callee_name)) return;
    if (tag == .new_expr) return;
    if (!calleeIsGlobalFunctionReference(ctx.nodeData(node).lhs, callee_name, ctx)) return;
    const args = callArgs(node, ctx) orelse return;
    if (args.len == 0) return;
    const handler: NodeIndex = @enumFromInt(args[0]);
    if (is_ts) {
        // TSe: fire if the arg's TYPE isn't function-shaped.
        if (argLooksLikeFunction(handler, ctx)) return;
        ctx.reportSpanWithMessageId(ctx.nodeSpan(handler), "noImpliedEvalError");
    } else {
        // ESLint core: fire only if the arg STATICALLY looks like a string
        // (literal, template, or `+` chain with any string operand).  Bare
        // identifiers / numbers don't qualify even if their type narrows
        // to a string-like at runtime.
        if (!isEvaluatedString(handler, ctx)) return;
        const msg_id: []const u8 = if (std.mem.eql(u8, callee_name, "execScript"))
            "execScript"
        else
            "impliedEval";
        ctx.reportWithMessageId(node, msg_id);
    }
}

/// Mirrors ESLint core's `isEvaluatedString` + the `getStaticValue`
/// follow-on path used by `reportImpliedEvalCallExpression` — string
/// literal, template literal, `+` BinaryExpression with one string
/// operand, `String(...)` constructor call, or a const-bound identifier
/// whose initializer is itself an evaluated string.
fn isEvaluatedString(n: NodeIndex, ctx: *const LintContext) bool {
    var cur = n;
    while (ctx.nodeTag(cur) == .grouping_expr) cur = ctx.nodeData(cur).lhs;
    const tag = ctx.nodeTag(cur);
    if (tag == .string_literal or tag == .template_literal) return true;
    if (tag == .add) {
        const d = ctx.nodeData(cur);
        return isEvaluatedString(d.lhs, ctx) or isEvaluatedString(d.rhs, ctx);
    }
    // `String('foo')` evaluates to the string 'foo'.  Conservatively
    // accept any bare-call to the global `String` identifier.
    if (tag == .call_expr) {
        const d = ctx.nodeData(cur);
        const callee = d.lhs;
        if (ctx.nodeTag(callee) == .identifier and
            std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "String") and
            ctx.isGlobalReference(callee))
        {
            return true;
        }
    }
    // Const-bound identifier with a string-evaluating initializer.
    if (tag == .identifier) {
        const sym = symbolForIdent(cur, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
        const parent = ctx.parentOf(decl);
        if (parent == .none or ctx.nodeTag(parent) != .declarator) return false;
        const init = ctx.nodeData(parent).rhs;
        if (init == .none) return false;
        // Walk up to the const/let declaration to confirm const.
        const decl_parent = ctx.parentOf(parent);
        if (decl_parent == .none) return false;
        if (ctx.nodeTag(decl_parent) != .const_decl) return false;
        return isEvaluatedString(init, ctx);
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

fn getCalleeName(callee: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (callee == .none) return null;
    var n = callee;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) return ctx.tokenText(ctx.nodeMainToken(n));
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(n);
        if (!isGlobalCandidateReceiver(md.lhs, ctx)) return null;
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const md = ctx.nodeData(n);
        if (!isGlobalCandidateReceiver(md.lhs, ctx)) return null;
        if (md.rhs == .none) return null;
        const key_tag = ctx.nodeTag(md.rhs);
        if (key_tag == .string_literal) return stringLiteralValue(md.rhs, ctx);
        if (key_tag == .template_literal) return simpleTemplateValue(md.rhs, ctx);
        return null;
    }
    return null;
}

/// True when `obj` is a recognized global candidate identifier or a chain
/// of member accesses on global candidates (`window.window.window`...).
/// Both dot and computed-with-string forms are accepted at each step.
fn isGlobalCandidateReceiver(obj: NodeIndex, ctx: *const LintContext) bool {
    var n = obj;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        if (!isGlobalCandidate(name, ctx.isTypeScript())) return false;
        if (!ctx.isGlobalReference(n)) return false;
        if (!ctx.isTypeScript() and !isKnownGlobalName(name, ctx)) return false;
        return true;
    }
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(n);
        const prop = ctx.tokenText(ctx.nodeMainToken(n));
        if (!isGlobalCandidate(prop, ctx.isTypeScript())) return false;
        return isGlobalCandidateReceiver(md.lhs, ctx);
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const md = ctx.nodeData(n);
        if (md.rhs == .none) return false;
        const key_tag = ctx.nodeTag(md.rhs);
        var key: []const u8 = "";
        if (key_tag == .string_literal) {
            key = stringLiteralValue(md.rhs, ctx) orelse return false;
        } else if (key_tag == .template_literal) {
            key = simpleTemplateValue(md.rhs, ctx) orelse return false;
        } else return false;
        if (!isGlobalCandidate(key, ctx.isTypeScript())) return false;
        return isGlobalCandidateReceiver(md.lhs, ctx);
    }
    return false;
}

/// TSe's GLOBAL_CANDIDATES omits `self`; ESLint core includes it.
fn isGlobalCandidate(name: []const u8, is_ts: bool) bool {
    if (std.mem.eql(u8, name, "global")) return true;
    if (std.mem.eql(u8, name, "globalThis")) return true;
    if (std.mem.eql(u8, name, "window")) return true;
    if (!is_ts and std.mem.eql(u8, name, "self")) return true;
    return false;
}

/// For a template literal with NO interpolation expressions (e.g.
/// `` `setInterval` ``), return the literal text between the backticks.
/// A no-interpolation template has exactly one entry in the parts
/// SubRange (the single template_element).
fn simpleTemplateValue(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const data = ctx.nodeData(node);
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    if (end <= start or end > ctx.ast.extra_data.len) return null;
    if (end - start != 1) return null; // had interpolation
    const sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    if (sp.end > sp.start + 1 and sp.end <= src.len) {
        const raw = src[sp.start..sp.end];
        if (raw.len >= 2 and raw[0] == '`' and raw[raw.len - 1] == '`') {
            return raw[1 .. raw.len - 1];
        }
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
        if (!ctx.isGlobalReference(n)) return false;
        // ESLint core requires the function name to be a KNOWN global
        // (env or explicit).  TSe is content with the reference being
        // free / escaping to the global scope.
        if (!ctx.isTypeScript() and !ctx.globalIsExplicitlyEnabled(name)) return false;
        return true;
    }
    if (tag == .member_expr or tag == .optional_member_expr or
        tag == .computed_member_expr or tag == .optional_computed_member_expr)
    {
        // `window.setTimeout` etc. — `getCalleeName` already validated
        // the receiver, including the "is the receiver a known global?"
        // check for the JS path.  But the receiver also needs to be the
        // BUILT-IN global, not a local binding with the same name.
        const md = ctx.nodeData(n);
        if (md.lhs != .none and ctx.nodeTag(md.lhs) == .identifier) {
            if (!ctx.isGlobalReference(md.lhs)) return false;
        }
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
