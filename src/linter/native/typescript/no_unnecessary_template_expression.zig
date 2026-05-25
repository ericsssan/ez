// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unnecessary-template-expression
//
// Reports template literals whose interpolations could be expressed
// inline.  An interpolation is unnecessary when it is:
//   * a fixable identifier (`undefined`, `Infinity`, `NaN`)
//   * a primitive literal (string / number / boolean / null / bigint
//     / regex)
//   * another template literal
// Trivial templates with one interpolation that's already string-typed
// (e.g. `${aString}`) also fire.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-unnecessary-template-expression",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary template expressions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .template_literal,
    .ts_template_literal_type,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .template_literal => checkTemplateLiteral(node, ctx),
        .ts_template_literal_type => checkTemplateLiteralType(node, ctx),
        else => {},
    }
}

/// `template_literal.data` is a SubRange of NodeIndex values whose
/// children alternate `template_element` (quasi) and expression nodes
/// in source order.  We rely on that ordering rather than a separate
/// quasis/expressions split.
const MAX_PARTS = 32;
const Parts = struct {
    quasis: [MAX_PARTS]NodeIndex,
    exprs: [MAX_PARTS]NodeIndex,
    n_quasis: usize,
    n_exprs: usize,
};

fn collectParts(node: NodeIndex, ctx: *const LintContext) ?Parts {
    var out = Parts{
        .quasis = undefined,
        .exprs = undefined,
        .n_quasis = 0,
        .n_exprs = 0,
    };
    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const part: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(part) == .template_element) {
            if (out.n_quasis >= MAX_PARTS) return null;
            out.quasis[out.n_quasis] = part;
            out.n_quasis += 1;
        } else {
            if (out.n_exprs >= MAX_PARTS) return null;
            out.exprs[out.n_exprs] = part;
            out.n_exprs += 1;
        }
    }
    return out;
}

fn checkTemplateLiteral(node: NodeIndex, ctx: *const LintContext) void {
    // Skip tagged templates — the tag function may consume raw parts.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .tagged_template) return;

    const parts = collectParts(node, ctx) orelse return;
    if (parts.n_exprs == 0) return;

    // Trivial template: ``${X}`` (two empty quasis, one interpolation).
    if (parts.n_quasis == 2 and parts.n_exprs == 1 and
        quasiIsEmpty(parts.quasis[0], ctx) and quasiIsEmpty(parts.quasis[1], ctx))
    {
        const expr = parts.exprs[0];
        if (interpolationIsUnnecessary(expr, parts.quasis[0], parts.quasis[1], ctx, false)) {
            reportInterpolation(expr, ctx);
            return;
        }
        if (hasCommentsBetweenQuasis(parts.quasis[0], parts.quasis[1], ctx)) return;
        // String-typed expression (and the interpolation isn't covered
        // by the literal/fixable path above) — TSe fires for trivial
        // templates whose single interpolation has a string-like type.
        if (ctx.hasTypeChecker()) {
            const ty = ctx.typeOfNode(expr);
            if (ctx.typeIdIsStringy(ty) or isGlobalStringCall(expr, ctx)) {
                reportInterpolation(expr, ctx);
                return;
            }
        }
    }

    // Per-interpolation: report each unnecessary one.
    var i: usize = 0;
    while (i < parts.n_exprs) : (i += 1) {
        const prev_q = parts.quasis[i];
        const next_q = if (i + 1 < parts.n_quasis) parts.quasis[i + 1] else parts.quasis[parts.n_quasis - 1];
        if (interpolationIsUnnecessary(parts.exprs[i], prev_q, next_q, ctx, false)) {
            reportInterpolation(parts.exprs[i], ctx);
        }
    }
}

fn checkTemplateLiteralType(node: NodeIndex, ctx: *const LintContext) void {
    const parts = collectParts(node, ctx) orelse return;
    if (parts.n_exprs == 0) return;

    // Trivial type template: `` `${X}` `` with a string-like interpolation.
    if (parts.n_quasis == 2 and parts.n_exprs == 1 and
        quasiIsEmpty(parts.quasis[0], ctx) and quasiIsEmpty(parts.quasis[1], ctx))
    {
        const expr = parts.exprs[0];
        if (interpolationIsUnnecessary(expr, parts.quasis[0], parts.quasis[1], ctx, true)) {
            reportInterpolation(expr, ctx);
            return;
        }
        if (hasCommentsBetweenQuasis(parts.quasis[0], parts.quasis[1], ctx)) return;
        // Type parameter (`<T extends string>` → `${T}`) — TSe excludes
        // type parameters from the trivial path.
        if (ctx.hasTypeChecker()) {
            if (ctx.typeAnnotationIsTypeParameter(expr)) return;
            if (typeNodeMentionsEnumMember(expr, ctx)) return;
            if (typeNodeReferencesUndeclared(expr, ctx)) return;
            const ty = ctx.resolveTypeAnnotationNode(expr);
            if (ctx.typeIdIsStringy(ty)) {
                reportInterpolation(expr, ctx);
                return;
            }
        }
    }

    var i: usize = 0;
    while (i < parts.n_exprs) : (i += 1) {
        const prev_q = parts.quasis[i];
        const next_q = if (i + 1 < parts.n_quasis) parts.quasis[i + 1] else parts.quasis[parts.n_quasis - 1];
        if (interpolationIsUnnecessary(parts.exprs[i], prev_q, next_q, ctx, true)) {
            reportInterpolation(parts.exprs[i], ctx);
        }
    }
}

/// True when `node` is a call to the global `String(...)` — TS infers
/// its return type as `string`, but our checker doesn't yet model
/// global constructor return types, so this mirrors that inference
/// at the AST level.
fn isGlobalStringCall(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    var callee = ctx.nodeData(n).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "String")) return false;
    return ctx.isGlobalReference(callee);
}

/// True when any `ts_type_reference` in `node` names a type that
/// isn't declared anywhere in this file (and isn't a TS keyword).
/// TSe's type checker would resolve such a reference to an error
/// type, which neutralises the "string-like" inference, so we mirror
/// that bail-out conservatively.
fn typeNodeReferencesUndeclared(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const d = ctx.nodeData(node);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeNodeReferencesUndeclared(m, ctx)) return true;
            }
        }
        return false;
    }
    if (tag == .ts_parenthesized_type) return typeNodeReferencesUndeclared(ctx.nodeData(node).lhs, ctx);
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (name.len == 0) return false;
        // Quoted / numeric literal types — these are typed directly.
        const c0 = name[0];
        if (c0 == '\'' or c0 == '"' or c0 == '`') return false;
        if (c0 >= '0' and c0 <= '9') return false;
        return !ctx.typeNameIsKnown(name);
    }
    return false;
}

/// True when the type-position expression mentions an enum member —
/// e.g. `Enum1.A`, `Enum1.A | Enum1.B`, `Enum1.A & string`.  TSe
/// excludes such interpolations from the trivial-template path even
/// when their constraint is string-like, because removing the
/// template would strip the enum-member nominal narrowing.
fn typeNodeMentionsEnumMember(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const d = ctx.nodeData(node);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                if (typeNodeMentionsEnumMember(m, ctx)) return true;
            }
        }
        return false;
    }
    if (tag == .ts_parenthesized_type) return typeNodeMentionsEnumMember(ctx.nodeData(node).lhs, ctx);
    // Member expression `Foo.Bar` in type position parses as a chained
    // ts_type_reference / member_expr — the root identifier's name is
    // the enum.
    if (tag == .member_expr or tag == .optional_member_expr) {
        var n = node;
        while (true) {
            const nt = ctx.nodeTag(n);
            if (nt != .member_expr and nt != .optional_member_expr) break;
            n = ctx.nodeData(n).lhs;
        }
        if (ctx.nodeTag(n) == .identifier) {
            const name = ctx.tokenText(ctx.nodeMainToken(n));
            return ctx.typeNameIsEnum(name);
        }
    }
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (ctx.typeNameIsEnum(name)) return true;
        // Namespaced reference like `Enum1.A` — the parser nests a
        // member_expr (or chain of qualified names) under the type ref.
        const inner = ctx.nodeData(node).lhs;
        if (inner != .none) return typeNodeMentionsEnumMember(inner, ctx);
    }
    return false;
}

/// Strip the surrounding `` ` `` / `${` / `}` markers from a quasi's
/// source-span so callers see the raw value the rule reasons about.
fn quasiRaw(q: NodeIndex, ctx: *const LintContext) []const u8 {
    const sp = ctx.nodeSpan(q);
    const src = ctx.ast.source;
    if (sp.end <= sp.start or sp.end > src.len) return &.{};
    var start: u32 = sp.start;
    var end: u32 = sp.end;
    if (start < end and (src[start] == '`' or src[start] == '}')) start += 1;
    if (end >= start + 2 and src[end - 1] == '{' and src[end - 2] == '$') {
        end -= 2;
    } else if (end > start and src[end - 1] == '`') {
        end -= 1;
    }
    return src[start..end];
}

fn quasiIsEmpty(q: NodeIndex, ctx: *const LintContext) bool {
    return quasiRaw(q, ctx).len == 0;
}

/// Is the interpolation a fixable identifier (`undefined`, `Infinity`,
/// `NaN`) referencing the global binding?
fn isFixableIdentifier(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (!std.mem.eql(u8, name, "undefined") and
        !std.mem.eql(u8, name, "Infinity") and
        !std.mem.eql(u8, name, "NaN")) return false;
    return ctx.isGlobalReference(node);
}

/// Primitive literal at the AST level.  In value position the parser
/// emits the literal node directly; in type position the parser wraps
/// numeric/string/bigint/boolean literals as `ts_type_reference`
/// whose main_token is the literal text, so we also accept that form
/// when the token looks like a literal.
fn isPrimitiveLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(node);
    if (t == .string_literal or t == .number_literal or
        t == .boolean_literal or t == .null_literal or
        t == .bigint_literal or t == .regex_literal) return true;
    if (t == .ts_type_reference) {
        const raw = ctx.tokenText(ctx.nodeMainToken(node));
        if (raw.len == 0) return false;
        const c = raw[0];
        if (c == '\'' or c == '"' or c == '`') return true;
        if (c >= '0' and c <= '9') return true;
        if (std.mem.eql(u8, raw, "null") or
            std.mem.eql(u8, raw, "true") or
            std.mem.eql(u8, raw, "false")) return true;
    }
    return false;
}

/// In type position TSe treats the `null`/`undefined` keywords as
/// literals too; the parser models them as `ts_null_keyword` /
/// `ts_undefined_keyword` (or `ts_type_reference` for some shapes).
fn isTypeNullishKeyword(node: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(node);
    if (t == .ts_type_reference) {
        const raw = ctx.tokenText(ctx.nodeMainToken(node));
        return std.mem.eql(u8, raw, "null") or std.mem.eql(u8, raw, "undefined");
    }
    return false;
}

/// For a string literal interpolation, decide whether the trailing
/// whitespace exception applies — TSe allows a whitespace-only string
/// interpolation when the next quasi begins with a newline (covers the
/// common "prepend indentation" pattern).
fn nextQuasiStartsWithNewline(q: NodeIndex, ctx: *const LintContext) bool {
    const raw = quasiRaw(q, ctx);
    if (raw.len == 0) return false;
    if (raw[0] == '\n') return true;
    if (raw.len >= 2 and raw[0] == '\r' and raw[1] == '\n') return true;
    return false;
}

fn stringIsAllWhitespace(s: []const u8) bool {
    for (s) |c| {
        switch (c) {
            ' ', '\t', '\n', '\r' => {},
            else => return false,
        }
    }
    return true;
}

/// Scan the `${...}` source range between two quasis looking for `//`
/// or `/*` markers.  `//` inside a string within the interpolation can
/// theoretically produce a false positive, but legitimate
/// "unnecessary" expressions (literals, identifiers, nested templates)
/// don't contain those markers — so the scan stays accurate in
/// practice.
fn hasCommentsBetweenQuasis(prev_q: NodeIndex, next_q: NodeIndex, ctx: *const LintContext) bool {
    const prev_sp = ctx.nodeSpan(prev_q);
    const next_sp = ctx.nodeSpan(next_q);
    const src = ctx.ast.source;
    if (prev_sp.end > next_sp.start or next_sp.start > src.len) return false;
    var i: u32 = prev_sp.end;
    while (i + 1 < next_sp.start) : (i += 1) {
        if (src[i] == '/' and (src[i + 1] == '/' or src[i + 1] == '*')) return true;
    }
    return false;
}

fn interpolationIsUnnecessary(
    expr: NodeIndex,
    prev_quasi: NodeIndex,
    next_quasi: NodeIndex,
    ctx: *const LintContext,
    type_position: bool,
) bool {
    if (hasCommentsBetweenQuasis(prev_quasi, next_quasi, ctx)) return false;

    if (type_position and isTypeNullishKeyword(expr, ctx)) return true;
    if (isFixableIdentifier(expr, ctx)) return true;

    if (isPrimitiveLiteral(expr, ctx)) {
        if (nextQuasiStartsWithNewline(next_quasi, ctx)) {
            // Only suppress whitespace-string literals — other literal
            // kinds still fire.  In type position the parser stores the
            // literal text on the wrapping `ts_type_reference` token.
            const expr_tag = ctx.nodeTag(expr);
            if (expr_tag == .string_literal or expr_tag == .ts_type_reference) {
                const raw = blk: {
                    if (expr_tag == .string_literal) {
                        const sp = ctx.nodeSpan(expr);
                        const src = ctx.ast.source;
                        if (sp.end > sp.start and sp.end <= src.len) break :blk src[sp.start..sp.end];
                        break :blk "";
                    }
                    break :blk ctx.tokenText(ctx.nodeMainToken(expr));
                };
                if (raw.len >= 2 and (raw[0] == '\'' or raw[0] == '"' or raw[0] == '`')) {
                    const inner = raw[1 .. raw.len - 1];
                    return !stringIsAllWhitespace(inner);
                }
            }
        }
        return true;
    }

    if (ctx.nodeTag(expr) == .template_literal or ctx.nodeTag(expr) == .ts_template_literal_type) {
        if (nextQuasiStartsWithNewline(next_quasi, ctx)) {
            // Allow inner template whose single quasi is whitespace.
            const inner = collectParts(expr, ctx) orelse return true;
            if (inner.n_quasis == 1 and inner.n_exprs == 0) {
                return !stringIsAllWhitespace(quasiRaw(inner.quasis[0], ctx));
            }
            return true;
        }
        return true;
    }

    return false;
}

/// Report the `${...}` span around `expr` — TSe locates the diagnostic
/// at the markers, not the interpolation expression itself.
fn reportInterpolation(expr: NodeIndex, ctx: *const LintContext) void {
    const sp = ctx.nodeSpan(expr);
    const src_len: u32 = @intCast(ctx.ast.source.len);
    const start: u32 = if (sp.start >= 2) sp.start - 2 else 0;
    const end: u32 = if (sp.end + 1 <= src_len) sp.end + 1 else src_len;
    ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, "noUnnecessaryTemplateExpression");
}
