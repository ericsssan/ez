const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-octal-escape",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow octal escape sequences in string literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    if (text.len < 3) return;

    // Scan string content (skip opening quote)
    var i: usize = 1;
    while (i < text.len - 1) : (i += 1) {
        if (text[i] == '\\' and i + 1 < text.len - 1) {
            const next = text[i + 1];
            // Octal escape: \1-\7 (not just \0 which is null char)
            if (next >= '1' and next <= '7') {
                ctx.report(node, meta.name, "Don't use octal escape sequences; use Unicode escapes instead", meta.default_severity);
                return;
            }
            // Skip the escaped character
            i += 1;
        }
    }
}
