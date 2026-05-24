// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-string-starts-ends-with

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-string-starts-ends-with",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer String.prototype.startsWith / .endsWith",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .call_expr, .optional_call_expr,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .equal, .not_equal, .strict_equal, .strict_not_equal => checkCompare(node, ctx),
        .call_expr, .optional_call_expr => checkCall(node, ctx),
        else => {},
    }
}

fn checkCompare(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    if (tryPatternCompare(node, d.lhs, d.rhs, ctx)) return;
    _ = tryPatternCompare(node, d.rhs, d.lhs, ctx);
}

fn tryPatternCompare(node: NodeIndex, expr: NodeIndex, other: NodeIndex, ctx: *const LintContext) bool {
    var e = expr;
    while (ctx.nodeTag(e) == .grouping_expr) e = ctx.nodeData(e).lhs;
    const tag = ctx.nodeTag(e);
    // s[N] / s?.[N]
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const d = ctx.nodeData(e);
        if (!isStringSubject(d.lhs, ctx)) return false;
        const idx = indexKindOf(d.rhs, d.lhs, ctx);
        if (!isStringTypedOrLiteral(other, ctx)) return false;
        if (allowSingleElementEquality(ctx)) return false;
        if (idx == .start_zero) {
            ctx.reportWithMessageId(node, "preferStartsWith");
            return true;
        }
        if (idx == .end_minus_one) {
            ctx.reportWithMessageId(node, "preferEndsWith");
            return true;
        }
        return false;
    }
    // method calls
    if (tag != .call_expr and tag != .optional_call_expr) return false;
    const cd = ctx.nodeData(e);
    var callee = cd.lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const method = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const subject = md.lhs;
    if (!isStringSubject(subject, ctx)) return false;
    const args = callArgs(e, ctx);
    // s.charAt(N) === <string>
    if (std.mem.eql(u8, method, "charAt")) {
        if (args.len != 1) return false;
        const arg0: NodeIndex = @enumFromInt(args[0]);
        const idx = indexKindOf(arg0, subject, ctx);
        if (!isStringTypedOrLiteral(other, ctx)) return false;
        if (allowSingleElementEquality(ctx)) return false;
        if (idx == .start_zero) {
            ctx.reportWithMessageId(node, "preferStartsWith");
            return true;
        }
        if (idx == .end_minus_one) {
            ctx.reportWithMessageId(node, "preferEndsWith");
            return true;
        }
        return false;
    }
    // s.indexOf(needle) === 0 / !== 0 / == 0 / != 0
    if (std.mem.eql(u8, method, "indexOf")) {
        if (args.len < 1) return false;
        if (!isNumberLitEq(other, 0, ctx)) return false;
        ctx.reportWithMessageId(node, "preferStartsWith");
        return true;
    }
    // s.lastIndexOf(needle) === s.length - needle.length
    if (std.mem.eql(u8, method, "lastIndexOf")) {
        if (args.len < 1) return false;
        const needle: NodeIndex = @enumFromInt(args[0]);
        if (isLengthMinusNeedle(other, subject, needle, ctx)) {
            ctx.reportWithMessageId(node, "preferEndsWith");
            return true;
        }
        return false;
    }
    // s.slice(0, N) / s.substring(0, N) === literal — only safe when the
    // 2nd arg matches the literal/needle length.  `s.slice(0, -N)` and
    // `s.slice(0, varLen)` aren't equivalent to startsWith and are skipped.
    if (std.mem.eql(u8, method, "slice") or std.mem.eql(u8, method, "substring")) {
        if (args.len < 1) return false;
        const a0: NodeIndex = @enumFromInt(args[0]);
        // s.slice(-N) (single arg, negative literal or -needle.length) — endsWith.
        if (args.len == 1 and ctx.nodeTag(a0) == .unary_minus) {
            const ud = ctx.nodeData(a0);
            if (ctx.nodeTag(ud.lhs) == .number_literal) {
                ctx.reportWithMessageId(node, "preferEndsWith");
                return true;
            }
            // s.slice(-needle.length) === needle — allow when -length expr
            // refers to a member of the compared value (`Y.length` matches Y).
            if (ctx.nodeTag(ud.lhs) == .member_expr) {
                const md2 = ctx.nodeData(ud.lhs);
                if (md2.rhs != .none and
                    std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(md2.rhs)), "length") and
                    sameExpr(md2.lhs, other, ctx))
                {
                    ctx.reportWithMessageId(node, "preferEndsWith");
                    return true;
                }
            }
            return false;
        }
        // s.slice(s.length - N) (single arg) — endsWith.
        if (args.len == 1 and ctx.nodeTag(a0) == .subtract) {
            const sd = ctx.nodeData(a0);
            if (isMemberLength(sd.lhs, subject, ctx)) {
                ctx.reportWithMessageId(node, "preferEndsWith");
                return true;
            }
            return false;
        }
        // s.slice(0, N) — startsWith when N == needle length (literal or
        // needle.length expression).
        if (args.len == 2 and isNumberLitEq(a0, 0, ctx)) {
            const a1: NodeIndex = @enumFromInt(args[1]);
            // Reject negative second arg (e.g. s.slice(0, -4)).
            if (ctx.nodeTag(a1) == .unary_minus) return false;
            if (sliceLengthMatchesNeedle(a1, other, ctx)) {
                ctx.reportWithMessageId(node, "preferStartsWith");
                return true;
            }
            return false;
        }
        // s.substring(s.length - N, s.length) — endsWith when N matches
        // needle length (or `s.length - needle.length` form).
        if (args.len == 2) {
            const a1: NodeIndex = @enumFromInt(args[1]);
            if (isMemberLength(a1, subject, ctx) and
                isLengthMinusNeedle(a0, subject, other, ctx))
            {
                ctx.reportWithMessageId(node, "preferEndsWith");
                return true;
            }
        }
        return false;
    }
    // s.match(/^.../) !== null
    if (std.mem.eql(u8, method, "match")) {
        if (args.len != 1) return false;
        if (!isNullish(other, ctx)) return false;
        const arg0: NodeIndex = @enumFromInt(args[0]);
        const anchor = anchoredRegex(arg0, ctx) orelse return false;
        // Span: TSe reports only the call expression (receiver+args), not
        // the surrounding equality.
        ctx.reportWithMessageId(e, switch (anchor) {
            .start => "preferStartsWith",
            .end => "preferEndsWith",
        });
        return true;
    }
    return false;
}

fn checkCall(node: NodeIndex, ctx: *const LintContext) void {
    // /^pat/.test(s) → startsWith ; /pat$/.test(s) → endsWith
    // Accepts both regex literals and effective-const bindings to a regex
    // literal or `new RegExp('^...')` call.
    const d = ctx.nodeData(node);
    var callee = d.lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ctag = ctx.nodeTag(callee);
    if (ctag != .member_expr and ctag != .optional_member_expr) return;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return;
    const method = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, method, "test")) return;
    const args = callArgs(node, ctx);
    if (args.len != 1) return;
    const anchor = anchoredRegex(md.lhs, ctx) orelse return;
    ctx.reportWithMessageId(node, switch (anchor) {
        .start => "preferStartsWith",
        .end => "preferEndsWith",
    });
}

// =====================================================================

const IndexKind = enum { other, start_zero, end_minus_one };

fn indexKindOf(idx_node: NodeIndex, subject: NodeIndex, ctx: *const LintContext) IndexKind {
    var n = idx_node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (isNumberLitEq(n, 0, ctx)) return .start_zero;
    if (ctx.nodeTag(n) == .subtract) {
        const d = ctx.nodeData(n);
        if (isMemberLength(d.lhs, subject, ctx) and isNumberLitEq(d.rhs, 1, ctx)) {
            return .end_minus_one;
        }
    }
    return .other;
}

fn isStringSubject(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const ty = ctx.typeOfNode(n);
    return ctx.typeIdIsStringy(ty);
}

/// True when `node` is either a syntactic string literal/template,
/// or has a string-typed expression value.  Used to validate the
/// "compared against a string" side of `s[N] === <X>` patterns.
fn isStringTypedOrLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .string_literal or tag == .template_literal) return true;
    const ty = ctx.typeOfNode(n);
    return ctx.typeIdIsStringy(ty);
}

/// Does the slice-end-index expression match the comparison-needle's
/// length?  Accepts:
///   * numeric literal equal to needle's string-literal length
///   * `needle.length` expression (when needle is a variable)
fn sliceLengthMatchesNeedle(end_idx: NodeIndex, needle: NodeIndex, ctx: *const LintContext) bool {
    var n = needle;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .string_literal) {
        const raw = ctx.tokenText(ctx.nodeMainToken(n));
        if (raw.len < 2) return false;
        const expected: i64 = @intCast(countChars(raw[1 .. raw.len - 1]));
        return isNumberLitEq(end_idx, expected, ctx);
    }
    // needle is a variable — match `needle.length`.
    return isMemberLength(end_idx, needle, ctx);
}

fn callArgs(call_node: NodeIndex, ctx: *const LintContext) []const u32 {
    const d = ctx.nodeData(call_node);
    if (d.rhs == .none) return &.{};
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return &.{};
    return ctx.ast.extra_data[sr.start..sr.end];
}

fn isNumberLitEq(node: NodeIndex, expected: i64, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    var neg = false;
    if (ctx.nodeTag(n) == .unary_minus) {
        neg = true;
        n = ctx.nodeData(n).lhs;
        while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    }
    if (ctx.nodeTag(n) != .number_literal) return false;
    const txt = ctx.tokenText(ctx.nodeMainToken(n));
    const v = std.fmt.parseInt(i64, txt, 10) catch return false;
    return (if (neg) -v else v) == expected;
}

fn isMemberLength(node: NodeIndex, subject: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .member_expr) return false;
    const d = ctx.nodeData(n);
    if (d.rhs == .none) return false;
    const prop = ctx.tokenText(ctx.nodeMainToken(d.rhs));
    if (!std.mem.eql(u8, prop, "length")) return false;
    return sameExpr(d.lhs, subject, ctx);
}

fn sameExpr(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    var x = a;
    var y = b;
    while (ctx.nodeTag(x) == .grouping_expr) x = ctx.nodeData(x).lhs;
    while (ctx.nodeTag(y) == .grouping_expr) y = ctx.nodeData(y).lhs;
    if (ctx.nodeTag(x) != ctx.nodeTag(y)) return false;
    if (ctx.nodeTag(x) == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)),
            ctx.tokenText(ctx.nodeMainToken(y)));
    }
    if (ctx.nodeTag(x) == .member_expr) {
        const xd = ctx.nodeData(x);
        const yd = ctx.nodeData(y);
        if (!sameExpr(xd.lhs, yd.lhs, ctx)) return false;
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(xd.rhs)),
            ctx.tokenText(ctx.nodeMainToken(yd.rhs)));
    }
    if (ctx.nodeTag(x) == .string_literal or ctx.nodeTag(x) == .number_literal) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(x)),
            ctx.tokenText(ctx.nodeMainToken(y)));
    }
    return false;
}

fn isSingleCharStringLit(other: NodeIndex, ctx: *const LintContext) bool {
    var n = other;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .string_literal) return false;
    const raw = ctx.tokenText(ctx.nodeMainToken(n));
    if (raw.len < 2) return false;
    return countChars(raw[1 .. raw.len - 1]) == 1;
}

fn countChars(s: []const u8) usize {
    var n: usize = 0;
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == '\\' and i + 1 < s.len) {
            const e = s[i + 1];
            if (e == 'x') {
                i = @min(s.len, i + 4);
            } else if (e == 'u') {
                if (i + 2 < s.len and s[i + 2] == '{') {
                    var j = i + 3;
                    while (j < s.len and s[j] != '}') j += 1;
                    i = @min(s.len, j + 1);
                } else {
                    i = @min(s.len, i + 6);
                }
            } else {
                i += 2;
            }
            n += 1;
            continue;
        }
        const c = s[i];
        if (c < 0x80) i += 1
        else if (c < 0xE0) i += 2
        else if (c < 0xF0) i += 3
        else { return 2; } // surrogate pair counts as 2 UTF-16 units
        n += 1;
    }
    return n;
}

fn isNullish(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const t = ctx.nodeTag(n);
    if (t == .null_literal) return true;
    if (t == .identifier) return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined");
    if (t == .void_expr) return true;
    return false;
}

const Anchor = enum { start, end };

fn anchoredRegex(node: NodeIndex, ctx: *const LintContext) ?Anchor {
    return anchoredRegexDepth(node, ctx, 0);
}

fn anchoredRegexDepth(node: NodeIndex, ctx: *const LintContext, depth: u32) ?Anchor {
    if (depth > 2) return null;
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .regex_literal) return classifyRegex(n, ctx);
    if (tag == .new_expr or tag == .call_expr) {
        // new RegExp('^bar')  /  RegExp('^bar')
        const cd = ctx.nodeData(n);
        var callee = cd.lhs;
        while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        if (ctx.nodeTag(callee) != .identifier) return null;
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (!std.mem.eql(u8, name, "RegExp")) return null;
        const args = callArgs(n, ctx);
        if (args.len < 1) return null;
        const arg0: NodeIndex = @enumFromInt(args[0]);
        var a = arg0;
        while (ctx.nodeTag(a) == .grouping_expr) a = ctx.nodeData(a).lhs;
        if (ctx.nodeTag(a) != .string_literal) return null;
        const raw = ctx.tokenText(ctx.nodeMainToken(a));
        if (raw.len < 2) return null;
        const inner = raw[1 .. raw.len - 1];
        // Flags arg disallows anchor optimisation when contains 'i','m','s'.
        if (args.len >= 2) {
            const arg1: NodeIndex = @enumFromInt(args[1]);
            var b = arg1;
            while (ctx.nodeTag(b) == .grouping_expr) b = ctx.nodeData(b).lhs;
            if (ctx.nodeTag(b) != .string_literal) return null;
            const fraw = ctx.tokenText(ctx.nodeMainToken(b));
            if (fraw.len < 2) return null;
            const flags = fraw[1 .. fraw.len - 1];
            for (flags) |f| if (f != 'u') return null;
        }
        return classifyRegexPattern(inner);
    }
    if (tag == .identifier) {
        const init = ctx.constInitializerOf(n) orelse return null;
        return anchoredRegexDepth(init, ctx, depth + 1);
    }
    return null;
}

fn classifyRegexPattern(pat: []const u8) ?Anchor {
    if (pat.len < 2) return null;
    if (pat[0] == '^') {
        if (hasRegexMeta(pat[1..])) return null;
        return .start;
    }
    if (pat[pat.len - 1] == '$') {
        if (hasRegexMeta(pat[0 .. pat.len - 1])) return null;
        return .end;
    }
    return null;
}

fn classifyRegex(node: NodeIndex, ctx: *const LintContext) ?Anchor {
    const raw = ctx.tokenText(ctx.nodeMainToken(node));
    if (raw.len < 3) return null;
    // Split pat / flags at last `/`.
    var flags_start: usize = raw.len;
    var i = raw.len - 1;
    while (i > 0) : (i -= 1) {
        if (raw[i] == '/') {
            flags_start = i;
            break;
        }
    }
    if (flags_start <= 1) return null;
    const pat = raw[1..flags_start];
    const flags = raw[flags_start + 1 ..];
    for (flags) |f| {
        if (f != 'u') return null; // only `u` is harmless
    }
    if (pat.len < 2) return null;
    if (pat[0] == '^') {
        if (hasRegexMeta(pat[1..])) return null;
        return .start;
    }
    if (pat[pat.len - 1] == '$') {
        if (hasRegexMeta(pat[0 .. pat.len - 1])) return null;
        return .end;
    }
    return null;
}

fn hasRegexMeta(s: []const u8) bool {
    var i: usize = 0;
    while (i < s.len) : (i += 1) {
        const c = s[i];
        if (c == '\\') {
            if (i + 1 < s.len) i += 1;
            continue;
        }
        switch (c) {
            '*', '+', '?', '(', ')', '[', ']', '{', '}', '|', '^', '$', '.' => return true,
            else => {},
        }
    }
    return false;
}

fn allowSingleElementEquality(ctx: *const LintContext) bool {
    const v = ctx.getOptionString("allowSingleElementEquality") orelse return false;
    return std.mem.eql(u8, v, "always");
}

fn isLengthMinusNeedle(other: NodeIndex, subject: NodeIndex, needle: NodeIndex, ctx: *const LintContext) bool {
    var n = other;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .subtract) return false;
    const d = ctx.nodeData(n);
    if (!isMemberLength(d.lhs, subject, ctx)) return false;
    // RHS may be: numeric literal matching needle length, OR
    // `needle.length` expression (works for both string literals
    // and variables — sameExpr handles string_literal too).
    var nn = needle;
    while (ctx.nodeTag(nn) == .grouping_expr) nn = ctx.nodeData(nn).lhs;
    if (ctx.nodeTag(nn) == .string_literal) {
        const raw = ctx.tokenText(ctx.nodeMainToken(nn));
        if (raw.len >= 2) {
            const expected: i64 = @intCast(countChars(raw[1 .. raw.len - 1]));
            if (isNumberLitEq(d.rhs, expected, ctx)) return true;
        }
    }
    return isMemberLength(d.rhs, needle, ctx);
}
