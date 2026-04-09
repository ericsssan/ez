const std = @import("std");
const float_fmt = std.fmt.float;
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-loss-of-precision",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow literal numbers that lose precision",
};

pub const relevant_tags = [_]Node.Tag{.number_literal};

// ── Scientific-notation helpers (mirrors ESLint's algorithm) ─────────────────

fn removeLeadingZeros(s: []const u8) []const u8 {
    var i: usize = 0;
    while (i < s.len and s[i] == '0') : (i += 1) {}
    return s[i..];
}

fn removeTrailingZeros(s: []const u8) []const u8 {
    if (s.len == 0) return s;
    var i: usize = s.len;
    while (i > 0 and s[i - 1] == '0') : (i -= 1) {}
    return s[0..i];
}

const SN = struct { coefficient: []const u8, magnitude: i32 };

/// normalizeFloat: convert a decimal-point string to SN (no trailing-zero removal).
fn normalizeFloat(s: []const u8, out: []u8) SN {
    const trimmed = removeLeadingZeros(s);
    if (trimmed.len == 0) return .{ .coefficient = out[0..0], .magnitude = 0 };

    const dot = std.mem.indexOf(u8, trimmed, ".") orelse {
        // No decimal point – treat as plain integer string.
        @memcpy(out[0..trimmed.len], trimmed);
        return .{ .coefficient = out[0..trimmed.len], .magnitude = @intCast(trimmed.len - 1) };
    };

    if (dot == 0) {
        // ".00123" style
        const after = trimmed[1..];
        const sig = removeLeadingZeros(after);
        if (sig.len == 0) return .{ .coefficient = out[0..0], .magnitude = 0 };
        @memcpy(out[0..sig.len], sig);
        const magnitude: i32 = @as(i32, @intCast(sig.len)) - @as(i32, @intCast(trimmed.len));
        return .{ .coefficient = out[0..sig.len], .magnitude = magnitude };
    } else {
        // "123.456" style: coefficient = digits without decimal point
        var j: usize = 0;
        for (trimmed) |c| {
            if (c != '.') {
                out[j] = c;
                j += 1;
            }
        }
        return .{ .coefficient = out[0..j], .magnitude = @intCast(dot - 1) };
    }
}

/// normalizeInteger: like normalizeFloat but removes trailing zeros from coefficient.
fn normalizeInteger(s: []const u8, out: []u8) SN {
    const trimmed = removeLeadingZeros(s);
    if (trimmed.len == 0) return .{ .coefficient = out[0..0], .magnitude = 0 };
    const sig = removeTrailingZeros(trimmed);
    if (sig.len == 0) return .{ .coefficient = out[0..0], .magnitude = 0 };
    @memcpy(out[0..sig.len], sig);
    return .{ .coefficient = out[0..sig.len], .magnitude = @intCast(trimmed.len - 1) };
}

/// Parse an 'e'-split exponent string ("+03", "-2", "15") to i32.
fn parseExponent(s: []const u8) i32 {
    if (s.len == 0) return 0;
    const sign: i32 = if (s[0] == '-') -1 else 1;
    const digits = if (s[0] == '+' or s[0] == '-') s[1..] else s;
    const v = std.fmt.parseInt(i32, digits, 10) catch return 0;
    return sign * v;
}

/// Convert a decimal number string to SN. pass_as_float=true forces float normalization.
fn toSN(s: []const u8, as_float: bool, out: []u8) SN {
    var coeff_s = s;
    var exp: i32 = 0;
    if (std.mem.indexOf(u8, s, "e")) |ep| {
        coeff_s = s[0..ep];
        exp = parseExponent(s[ep + 1 ..]);
    }
    var sn = if (as_float or std.mem.indexOf(u8, coeff_s, ".") != null)
        normalizeFloat(coeff_s, out)
    else
        normalizeInteger(coeff_s, out);
    sn.magnitude += exp;
    return sn;
}

/// Base-10 precision check: mirrors ESLint's baseTenLosesPrecision().
fn baseTenLosesPrecision(clean: []const u8) bool {
    const value = std.fmt.parseFloat(f64, clean) catch return false;
    if (!std.math.isFinite(value)) return false;

    var orig_buf: [512]u8 = undefined;
    const orig = toSN(clean, false, &orig_buf);
    const precision = orig.coefficient.len;
    if (precision == 0) return false;
    if (precision > 100) return true;

    // Format value with `precision` significant digits in scientific notation.
    // float_fmt.render with .scientific and precision = n-1 gives n sig figs.
    var sci_buf: [512]u8 = undefined;
    const sci = float_fmt.render(&sci_buf, value, .{
        .mode = .scientific,
        .precision = precision - 1,
    }) catch return false;

    var stored_buf: [512]u8 = undefined;
    const stored = toSN(sci, true, &stored_buf);

    return orig.magnitude != stored.magnitude or
        !std.mem.eql(u8, orig.coefficient, stored.coefficient);
}

/// Non-base-10 precision check: mirrors ESLint's notBaseTenLosesPrecision().
/// clean has underscores stripped and is the full literal (e.g. "0b1001").
fn notBaseTenLosesPrecision(clean: []const u8) bool {
    if (clean.len < 2) return false;
    const prefix = clean[1];
    const base: u8 = switch (prefix | 0x20) { // lowercase
        'x' => 16,
        'b' => 2,
        'o' => 8,
        else => return false,
    };
    const digits = clean[2..];
    if (digits.len == 0) return false;

    // Parse original value as u128 (handles up to 128-bit numbers).
    const int_val = std.fmt.parseInt(u128, digits, base) catch return true; // overflow → loss

    // Convert integer to float64, then back to integer, and compare.
    // Don't use parseFloat — it doesn't handle 0b/0x/0o prefixes.
    if (int_val > std.math.maxInt(u64)) {
        // Value doesn't fit in u64 (> 2^64), definitely > MAX_SAFE_INTEGER, loses precision.
        return true;
    }
    const as_u64: u64 = @intCast(int_val);
    const float_val: f64 = @floatFromInt(as_u64);
    if (!std.math.isFinite(float_val)) return true;
    // Convert back: if float_val rounds to a different integer, precision is lost.
    const round_tripped: u64 = @intFromFloat(float_val);
    return as_u64 != round_tripped;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    if (text.len == 0) return;

    // Skip BigInt literals.
    if (text[text.len - 1] == 'n') return;

    // Strip numeric separators.
    var buf: [256]u8 = undefined;
    var len: usize = 0;
    for (text) |ch| {
        if (ch != '_') {
            if (len >= buf.len) return;
            buf[len] = ch;
            len += 1;
        }
    }
    const clean = buf[0..len];
    if (clean.len == 0) return;

    const loses: bool = if (clean.len >= 2 and clean[0] == '0' and
        (clean[1] == 'x' or clean[1] == 'X' or
        clean[1] == 'b' or clean[1] == 'B' or
        clean[1] == 'o' or clean[1] == 'O'))
        notBaseTenLosesPrecision(clean)
    else
        baseTenLosesPrecision(clean);

    if (loses) {
        ctx.report(node);
    }
}
