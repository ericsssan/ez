// HAND-WRITTEN.
// Rule: radix
// Enforce the consistent use of the radix argument when using parseInt().

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "radix",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Enforce the consistent use of the radix argument when using parseInt().",
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr,
    .optional_call_expr,
};

pub const needs_semantic = true;

/// Returns the global parseInt callee node if this call is a
/// global parseInt() or Number.parseInt() call; else .none.
fn getParseIntCallee(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    const d = ctx.nodeData(node);
    const raw_callee = d.lhs;
    if (raw_callee == .none) return .none;
    const callee = ctx.nodeSkipGrouping(raw_callee);
    const ctag = ctx.nodeTag(callee);
    switch (ctag) {
        .identifier => {
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "parseInt")) return .none;
            if (!ctx.isGlobalReference(callee)) return .none;
            // Honour /* globals parseInt:off */ and globals: {"parseInt": "off"}.
            if (ctx.globalIsOff("parseInt")) return .none;
            return node;
        },
        .member_expr, .optional_member_expr => {
            const prop = ctx.staticPropertyName(callee) orelse return .none;
            if (!std.mem.eql(u8, prop, "parseInt")) return .none;
            const obj = ctx.nodeData(callee).lhs;
            if (obj == .none) return .none;
            if (ctx.nodeTag(obj) != .identifier) return .none;
            if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Number")) return .none;
            if (!ctx.isGlobalReference(obj)) return .none;
            // Honour globals: {"Number": "off"}.
            if (ctx.globalIsOff("Number")) return .none;
            return node;
        },
        else => return .none,
    }
}

/// Try to parse a number token text as a numeric radix value.
/// Returns the float value or null if unparseable.
fn parseRadixValue(text: []const u8) ?f64 {
    // Try integer first: handles 0x, 0o, 0b prefixes and plain ints.
    if (std.fmt.parseInt(i64, text, 0)) |n| {
        return @as(f64, @floatFromInt(n));
    } else |_| {}
    // Fallback: handles 1.6e1, 10.0, 10.5 etc.
    if (std.fmt.parseFloat(f64, text)) |f| {
        return f;
    } else |_| {}
    return null;
}

fn isValidRadix(ctx: *const LintContext, arg: NodeIndex) bool {
    const a = ctx.nodeSkipGrouping(arg);
    const tag = ctx.nodeTag(a);
    if (tag == .number_literal) {
        const text = ctx.tokenText(ctx.nodeMainToken(a));
        const val = parseRadixValue(text) orelse return false;
        // Must be an integer in [2..36].
        if (@rem(val, 1.0) != 0.0) return false;
        // Guard the @intFromFloat cast: a value outside i64's range would be
        // UB with runtime safety disabled (e.g. `parseInt(x, 1e30)`). The only
        // values we accept are the radix band [2, 36], so range-check first.
        if (val < 2.0 or val > 36.0) return false;
        const int_val = @as(i64, @intFromFloat(val));
        return int_val >= 2 and int_val <= 36;
    }
    // undefined identifier → invalid.
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(a));
        if (std.mem.eql(u8, name, "undefined")) return false;
        // Other identifiers or expressions → can't check statically → valid.
        return true;
    }
    // Null/boolean/string/regex literals → invalid.
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (getParseIntCallee(ctx, node) == .none) return;

    // Get the args SubRange.
    const d = ctx.nodeData(node);
    if (d.rhs == .none) {
        ctx.reportWithMessageId(node, "missingParameters");
        return;
    }
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    const args = ctx.extraSlice(sr);

    if (args.len == 0) {
        ctx.reportWithMessageId(node, "missingParameters");
        return;
    }

    if (args.len == 1) {
        ctx.reportWithMessageId(node, "missingRadix");
        return;
    }

    // args.len >= 2 — validate radix (second argument).
    const radix_node: NodeIndex = @enumFromInt(args[1]);
    if (!isValidRadix(ctx, radix_node)) {
        ctx.reportWithMessageId(node, "invalidRadix");
    }
}
