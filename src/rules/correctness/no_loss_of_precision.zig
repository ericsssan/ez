const std = @import("std");
const ast = @import("../../ast.zig");
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

/// Maximum safe integer in JavaScript: 2^53 - 1
const MAX_SAFE_INTEGER: i128 = 9007199254740991;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    if (text.len == 0) return;

    // Skip hex, octal, binary literals
    if (text.len >= 2 and text[0] == '0') {
        const second = text[1];
        if (second == 'x' or second == 'X' or
            second == 'o' or second == 'O' or
            second == 'b' or second == 'B') return;
    }

    // Skip float literals for now (contain '.', 'e', or 'E')
    for (text) |ch| {
        if (ch == '.' or ch == 'e' or ch == 'E') return;
    }

    // Skip BigInt literals (suffix 'n')
    if (text.len > 0 and text[text.len - 1] == 'n') return;

    // Strip numeric separators ('_') for parsing
    var buf: [128]u8 = undefined;
    var len: usize = 0;
    for (text) |ch| {
        if (ch != '_') {
            if (len >= buf.len) return; // Too long, skip
            buf[len] = ch;
            len += 1;
        }
    }
    const clean = buf[0..len];

    // Parse as i128 to handle large values
    const value = std.fmt.parseInt(i128, clean, 10) catch return;

    // Number literal tokens are always non-negative (negation is a separate unary node)
    if (value > MAX_SAFE_INTEGER) {
        ctx.report(node, meta.name, "Number literal loses precision at runtime", meta.default_severity);
    }
}
