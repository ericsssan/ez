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

    // ESLint no-octal: flag any numeric literal starting with `0` followed by
    // a digit (matches /^0\d/). This includes 010, 07, 08, 09.1, 09e1, etc.
    if (text[1] < '0' or text[1] > '9') return;

    ctx.report(node, meta.name, "Octal literals should not be used.", meta.default_severity);
}
