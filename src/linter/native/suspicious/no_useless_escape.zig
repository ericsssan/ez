const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-useless-escape",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary escape characters",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    const quote = text[0];

    var i: usize = 1;
    while (i < text.len - 1) : (i += 1) {
        if (text[i] != '\\') continue;
        if (i + 1 >= text.len - 1) break;

        const next = text[i + 1];

        // Valid escape sequences in strings
        const is_valid = switch (next) {
            'n', 'r', 't', 'b', 'f', 'v', '0', 'x', 'u', '\\' => true,
            '\'' => quote == '\'',
            '"' => quote == '"',
            '`' => quote == '`',
            '$' => quote == '`', // template literal
            '\n', '\r' => true, // line continuation
            else => false,
        };

        if (!is_valid) {
            ctx.report(node);
            return;
        }

        i += 1; // skip the escaped character
    }
}
