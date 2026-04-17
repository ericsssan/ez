const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "unicorn/no-zero-fractions",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow number literals with a zero fractional part",
};

pub const relevant_tags = [_]Node.Tag{.number_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Skip non-decimal bases (0x, 0o, 0b).
    if (text[0] == '0' and text.len > 1) {
        const second = text[1];
        if (second == 'x' or second == 'X' or
            second == 'o' or second == 'O' or
            second == 'b' or second == 'B') return;
    }
    // Skip BigInt literals (end with 'n').
    if (text[text.len - 1] == 'n') return;

    // Find the decimal point.
    const dot_pos = std.mem.indexOfScalar(u8, text, '.') orelse return;

    // Find where the fractional digits end (stop at exponent marker or end).
    var frac_end = dot_pos + 1;
    while (frac_end < text.len) : (frac_end += 1) {
        const c = text[frac_end];
        if (c == 'e' or c == 'E') break;
    }

    const frac = text[dot_pos + 1 .. frac_end];

    // Report if fraction is empty ("1.") or ends with a zero ("1.0", "1.50").
    if (frac.len == 0 or frac[frac.len - 1] == '0') {
        ctx.report(node);
    }
}
