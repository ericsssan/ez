// HAND-WRITTEN.
// Rule: unicorn/no-static-only-class
//
// Flags a class whose every member is a public, non-TS static member — such a
// class should be a plain object instead.
// Mirrors: tests/conformance/eslint-plugin-unicorn/rules/no-static-only-class.js

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const ModifierBit = ast.ModifierBit;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "no-static-only-class",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow classes that only have static members.",
};

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub const needs_semantic = false;

const TokenIndex = u32;

/// `isStaticMember`: a public, non-private, non-TS static property/method.
fn memberIsStaticOnly(ctx: *const LintContext, member: NodeIndex) bool {
    const tag = ctx.ast.nodeTag(member);
    const is_method = switch (tag) {
        .method_def, .computed_method_def,
        .getter_def, .computed_getter_def,
        .setter_def, .computed_setter_def => true,
        else => false,
    };
    const is_property = tag == .property_def or tag == .computed_property_def;
    // Only PropertyDefinition / MethodDefinition qualify (excludes static blocks,
    // TS index signatures, etc.).
    if (!is_method and !is_property) return false;

    // Must be static.
    if (!ctx.classMemberIsStatic(member)) return false;

    // Private (`#x`) key is excluded.
    if (tag != .computed_method_def and tag != .computed_property_def) {
        const key = ctx.ast.nodeData(member).lhs;
        if (key != .none) {
            const ktext = ctx.tokenText(ctx.nodeMainToken(key));
            if (ktext.len > 0 and ktext[0] == '#') return false;
        }
    }

    // Member-level decorator → excluded.
    if (memberHasDecorator(ctx, member)) return false;

    if (is_method) {
        const d = ctx.ast.nodeData(member);
        if (d.rhs != .none) {
            const md = ctx.ast.extraData(ast.MethodData, @intFromEnum(d.rhs));
            // TS: accessibility modifier, readonly, declare → excluded.
            if ((md.modifiers & ModifierBit.accessibility_mask) != ModifierBit.acc_none) return false;
            if ((md.modifiers & ModifierBit.readonly) != 0) return false;
            if ((md.modifiers & ModifierBit.declare) != 0) return false;
        }
    } else {
        // Property: no modifier bits in PropertyData; scan the prefix tokens.
        if (memberHasTsModifier(ctx, member)) return false;
    }

    return true;
}

/// Scan modifier tokens before a property's key for TS modifiers
/// (accessibility / readonly / declare).
fn memberHasTsModifier(ctx: *const LintContext, member: NodeIndex) bool {
    const main = ctx.nodeMainToken(member);
    var t: TokenIndex = main;
    while (t > 0) {
        t -= 1;
        const txt = ctx.ast.tokenText(t);
        if (std.mem.eql(u8, txt, "public") or std.mem.eql(u8, txt, "private") or
            std.mem.eql(u8, txt, "protected") or std.mem.eql(u8, txt, "readonly") or
            std.mem.eql(u8, txt, "declare")) return true;
        if (std.mem.eql(u8, txt, "static") or std.mem.eql(u8, txt, "abstract") or
            std.mem.eql(u8, txt, "override") or std.mem.eql(u8, txt, "accessor") or
            std.mem.eql(u8, txt, "async") or std.mem.eql(u8, txt, "*")) continue;
        break;
    }
    return false;
}

/// True when a `@decorator` token immediately precedes the member's modifiers.
fn memberHasDecorator(ctx: *const LintContext, member: NodeIndex) bool {
    const start = ctx.nodeSpan(member).start;
    const tok = firstTokenAtOrAfter(ctx, start);
    var t: TokenIndex = tok;
    // Walk backwards over modifier keywords; if we reach a `)` or identifier that
    // is part of a decorator, a `@` will appear.  Simpler: scan back to the prior
    // member boundary looking for `@`.
    while (t > 0) {
        t -= 1;
        const txt = ctx.ast.tokenText(t);
        if (txt.len == 1 and txt[0] == '@') return true;
        if (txt.len == 1 and (txt[0] == '{' or txt[0] == ';' or txt[0] == '}')) return false;
        // keep scanning across the decorator's own tokens
        if (txt.len == 1 and txt[0] == ')') {
            // could be `@deco(...)` — keep scanning back to the `@`
            continue;
        }
    }
    return false;
}

fn firstTokenAtOrAfter(ctx: *const LintContext, pos: u32) TokenIndex {
    const starts = ctx.ast.tokens.items(.start);
    var lo: usize = 0;
    var hi: usize = starts.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        if (starts[mid] < pos) lo = mid + 1 else hi = mid;
    }
    return @intCast(lo);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const cd = ctx.ast.extraData(ast.ClassData, @intFromEnum(ctx.ast.nodeData(node).lhs));

    // Skip: extends clause, or class-level decorators.
    if (cd.super_class != .none) return;
    if (classHasDecorator(ctx, node)) return;

    const body = cd.body;
    if (body == .none or ctx.ast.nodeTag(body) != .class_body) return;

    // Defensive: an `extends` keyword before the body means a superclass exists
    // (handles any parse path where ClassData.super_class is not populated).
    {
        const body_start = ctx.nodeSpan(body).start;
        var t: TokenIndex = ctx.nodeMainToken(node); // `class` keyword
        const limit = firstTokenAtOrAfter(ctx, body_start);
        while (t < limit) : (t += 1) {
            if (std.mem.eql(u8, ctx.ast.tokenText(t), "extends")) return;
        }
    }
    const bd = ctx.ast.nodeData(body);
    const members = ctx.ast.extraSlice(.{ .start = @intFromEnum(bd.lhs), .end = @intFromEnum(bd.rhs) });
    if (members.len == 0) return; // empty body

    for (members) |mi| {
        const member: NodeIndex = @enumFromInt(mi);
        if (!memberIsStaticOnly(ctx, member)) return;
    }

    ctx.reportSpanWithMessageId(classHeadLocation(ctx, node, cd), "no-static-only-class");
}

/// `@decorator` immediately before the `class` keyword.
fn classHasDecorator(ctx: *const LintContext, node: NodeIndex) bool {
    const main = ctx.nodeMainToken(node); // `class` keyword
    if (main == 0) return false;
    // Walk back over `abstract`/`declare`/`export`/`default`; a `@` before means decorated.
    var t: TokenIndex = main;
    while (t > 0) {
        t -= 1;
        const txt = ctx.ast.tokenText(t);
        if (txt.len == 1 and txt[0] == '@') return true;
        if (std.mem.eql(u8, txt, "abstract") or std.mem.eql(u8, txt, "declare") or
            std.mem.eql(u8, txt, "export") or std.mem.eql(u8, txt, "default") or
            std.mem.eql(u8, txt, ")")) continue;
        break;
    }
    return false;
}

/// `getClassHeadLocation`: from the class node start (including leading
/// `abstract`/`declare` modifiers) to the end of the token before the body `{`.
fn classHeadLocation(ctx: *const LintContext, node: NodeIndex, cd: ast.ClassData) Span {
    var start = ctx.nodeSpan(node).start;
    // Extend start over leading `abstract`/`declare` modifiers.
    const main = ctx.nodeMainToken(node);
    var t: TokenIndex = main;
    while (t > 0) {
        const prev = t - 1;
        const txt = ctx.ast.tokenText(prev);
        if (std.mem.eql(u8, txt, "abstract") or std.mem.eql(u8, txt, "declare")) {
            start = ctx.tokenStart(prev);
            t = prev;
        } else break;
    }

    // End: token immediately before the body's `{`.
    const body_tok = firstTokenAtOrAfter(ctx, ctx.nodeSpan(cd.body).start);
    const end = if (body_tok > 0) ctx.tokenEnd(body_tok - 1) else ctx.nodeSpan(node).start;
    return .{ .start = start, .end = end };
}
