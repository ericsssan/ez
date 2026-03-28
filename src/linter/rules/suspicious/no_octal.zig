const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.number_literal};

pub const meta = RuleMeta{
    .name = "no-octal",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow legacy octal literals (e.g. 010)",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Must start with 0
    if (text[0] != '0') return;

    // Exclude 0x, 0o, 0b, 0X, 0O, 0B (modern prefixes)
    if (text.len >= 2) {
        const second = text[1];
        if (second == 'x' or second == 'X' or
            second == 'o' or second == 'O' or
            second == 'b' or second == 'B' or
            second == '.')
        {
            return;
        }
    }

    // Check remaining chars are octal digits (0-7) - this is a legacy octal
    for (text[1..]) |c| {
        if (c < '0' or c > '7') return;
    }

    // It's a legacy octal literal like 010
    ctx.report(node, meta.name, "Legacy octal literal. Use '0o' prefix for octal notation", meta.default_severity);
}
