// HAND-WRITTEN.
// Rule: @typescript-eslint/no-duplicate-enum-values
//
// Reports an enum member whose value (number or string literal) is
// equal to an earlier member's value within the same enum body.
// Computed initializers (`A = f()`) and references to other members
// are skipped — TSe does the same.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-enum-values",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow duplicate enum member values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_decl};

const ValKind = enum { none, number, string };
const Value = struct {
    kind: ValKind = .none,
    /// For number: canonical form of the literal text (handles +/-/0
    /// prefix); for string: the inner quoted contents.
    text: []const u8 = "",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));
    if (ed.members_start >= ed.members_end or ed.members_end > ctx.ast.extra_data.len) return;
    var kinds: [64]ValKind = undefined;
    var bufs: [64][32]u8 = undefined;
    var lens: [64]u8 = undefined;
    var slots: [64][]const u8 = undefined;
    var n: usize = 0;
    for (ctx.ast.extra_data[ed.members_start..ed.members_end]) |raw| {
        if (n >= kinds.len) break;
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const md = ctx.nodeData(m);
        const v = literalValue(md.rhs, ctx);
        if (v.kind == .none) continue;
        // Store value text in this call's stack buffer.
        const len = if (v.text.len < bufs[n].len) v.text.len else bufs[n].len;
        @memcpy(bufs[n][0..len], v.text[0..len]);
        lens[n] = @intCast(len);
        slots[n] = bufs[n][0..len];
        kinds[n] = v.kind;
        // Look for an earlier member with the same value.
        var i: usize = 0;
        var dup = false;
        while (i < n) : (i += 1) {
            if (kinds[i] != v.kind) continue;
            if (std.mem.eql(u8, slots[i], slots[n])) { dup = true; break; }
        }
        n += 1;
        if (dup) ctx.reportWithMessageId(m, "duplicateValue");
    }
}

fn literalValue(init: NodeIndex, ctx: *const LintContext) Value {
    return literalValueSigned(init, ctx, false);
}

fn literalValueSigned(init: NodeIndex, ctx: *const LintContext, negate: bool) Value {
    if (init == .none) return .{};
    var n = init;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .string_literal) {
        if (negate) return .{};
        const span = ctx.nodeSpan(n);
        if (span.end <= span.start + 2) return .{};
        const raw = ctx.ast.source[span.start..span.end];
        if (raw.len < 2) return .{};
        return .{ .kind = .string, .text = raw[1 .. raw.len - 1] };
    }
    if (tag == .number_literal) {
        return canonicalNumber(ctx.tokenText(ctx.nodeMainToken(n)), negate);
    }
    if (tag == .unary_minus or tag == .unary_plus) {
        const inner = ctx.nodeData(n).lhs;
        if (inner == .none) return .{};
        // `+expr` / `-expr` — JS unary plus/minus coerces operand to a
        // Number.  When the operand is a string or template literal,
        // coerce it; when it's another unary, recurse with the sign
        // toggled.
        const child_tag = ctx.nodeTag(inner);
        const flip = (tag == .unary_minus);
        const new_negate = if (flip) !negate else negate;
        if (child_tag == .number_literal) {
            return canonicalNumber(ctx.tokenText(ctx.nodeMainToken(inner)), new_negate);
        }
        if (child_tag == .unary_minus or child_tag == .unary_plus) {
            return literalValueSigned(inner, ctx, new_negate);
        }
        if (child_tag == .string_literal or child_tag == .template_literal) {
            const coerced = coerceStringNodeToNumber(inner, ctx) orelse return .{};
            return canonicalNumber(coerced, new_negate);
        }
        return .{};
    }
    // Template literal without substitution.
    if (tag == .template_literal) {
        if (negate) return .{};
        const span = ctx.nodeSpan(n);
        if (span.end <= span.start + 2) return .{};
        const raw = ctx.ast.source[span.start..span.end];
        if (std.mem.indexOf(u8, raw, "${") != null) return .{};
        return .{ .kind = .string, .text = raw[1 .. raw.len - 1] };
    }
    return .{};
}

/// JS `Number(str)`: empty → 0, whitespace-only → 0, otherwise
/// std.fmt.parseFloat.  Returns the source text suitable for
/// canonicalNumber (the parser handles signs/exponents itself).
fn coerceStringNodeToNumber(n: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const span = ctx.nodeSpan(n);
    if (span.end < span.start + 2) return null;
    const raw = ctx.ast.source[span.start..span.end];
    if (raw.len < 2) return null;
    if (std.mem.indexOf(u8, raw, "${") != null) return null;
    const inner = raw[1 .. raw.len - 1];
    const trimmed = std.mem.trim(u8, inner, " \t\n\r");
    if (trimmed.len == 0) return "0";
    return trimmed;
}

/// Parse a numeric literal source to its canonical f64 representation
/// and emit a stable string form (`std.fmt.format` style).  TSe uses
/// JS `getStaticValue` semantics, which uses Map (SameValueZero) for
/// duplicate detection — BUT distinguishes the sign of zero per the
/// test suite (so we use Object.is-style here: -0 and +0 differ).
fn canonicalNumber(text: []const u8, negate: bool) Value {
    // Static formatting buffer (only one return at a time, content
    // copied into a per-call slot at the caller).
    const Buf = struct {
        var buf: [40]u8 = undefined;
    };
    // Strip underscores into a stack buffer for std parsing.
    var cleaned: [64]u8 = undefined;
    var clen: usize = 0;
    var i: usize = 0;
    if (text.len > 0 and text[0] == '+') i += 1;
    while (i < text.len) : (i += 1) {
        if (text[i] == '_') continue;
        if (clen >= cleaned.len) break;
        cleaned[clen] = text[i];
        clen += 1;
    }
    const slice = cleaned[0..clen];
    var v: f64 = 0;
    if (parseFloatPermissive(slice)) |x| {
        v = x;
    } else {
        // Fallback: compare textually with sign honored.
        const out = std.fmt.bufPrint(&Buf.buf, "{s}{s}", .{ if (negate) "-" else "", slice }) catch return .{};
        return .{ .kind = .number, .text = out };
    }
    if (negate) v = -v;
    // Distinguish -0 from +0 via sign bit so the rule matches TSe's
    // expected behavior on `enum { A = -0, B = +0 }` (NOT a dup).
    if (v == 0) {
        const out = if (std.math.signbit(v)) "-0" else "0";
        return .{ .kind = .number, .text = out };
    }
    if (std.math.isNan(v)) return .{ .kind = .number, .text = "NaN" };
    if (std.math.isInf(v)) {
        return .{ .kind = .number, .text = if (v < 0) "-Infinity" else "Infinity" };
    }
    const out = std.fmt.bufPrint(&Buf.buf, "{d}", .{v}) catch return .{};
    return .{ .kind = .number, .text = out };
}

fn parseFloatPermissive(s: []const u8) ?f64 {
    if (s.len == 0) return null;
    // Hex / binary / octal literals.
    if (s.len >= 2 and s[0] == '0' and (s[1] == 'x' or s[1] == 'X')) {
        return parseIntBase(s[2..], 16);
    }
    if (s.len >= 2 and s[0] == '0' and (s[1] == 'b' or s[1] == 'B')) {
        return parseIntBase(s[2..], 2);
    }
    if (s.len >= 2 and s[0] == '0' and (s[1] == 'o' or s[1] == 'O')) {
        return parseIntBase(s[2..], 8);
    }
    return std.fmt.parseFloat(f64, s) catch null;
}

fn parseIntBase(s: []const u8, base: u8) ?f64 {
    var v: f64 = 0;
    const fbase: f64 = @floatFromInt(base);
    for (s) |c| {
        const d: u8 = switch (c) {
            '0'...'9' => c - '0',
            'a'...'f' => 10 + (c - 'a'),
            'A'...'F' => 10 + (c - 'A'),
            else => return null,
        };
        if (d >= base) return null;
        v = v * fbase + @as(f64, @floatFromInt(d));
    }
    return v;
}
