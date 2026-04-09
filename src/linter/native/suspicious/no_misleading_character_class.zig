const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const meta = RuleMeta{
    .name = "no-misleading-character-class",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow characters which are made with multiple code points in character class syntax",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    var in_class = false;
    var i: usize = 1;
    while (i < text.len) {
        // End of pattern at unescaped /
        if (text[i] == '/' and !in_class and (i == 0 or text[i - 1] != '\\')) break;

        if (text[i] == '\\') {
            if (i + 1 < text.len) {
                // Check for surrogate pair patterns inside character classes
                if (in_class and text[i + 1] == 'u' and i + 5 < text.len) {
                    // Check for \uD800-\uDFFF range (surrogate pairs)
                    if (text[i + 2] == 'D' or text[i + 2] == 'd') {
                        ctx.report(node);
                        return;
                    }
                }
            }
            i += 2;
            continue;
        }

        if (text[i] == '[') {
            in_class = true;
        } else if (text[i] == ']') {
            in_class = false;
        }

        // Check for combining marks inside character classes (U+0300-U+036F)
        if (in_class and text[i] >= 0xCC and i + 1 < text.len and text[i + 1] >= 0x80) {
            ctx.report(node);
            return;
        }

        i += 1;
    }
}
