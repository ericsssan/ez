const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const meta = RuleMeta{
    .name = "no-empty-character-class",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow empty character classes in regular expressions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Scan for empty character class [] (not [^])
    var i: usize = 1;
    while (i < text.len) {
        // End of pattern at unescaped /
        if (text[i] == '/' and (i == 0 or text[i - 1] != '\\')) break;

        if (text[i] == '[' and i + 1 < text.len) {
            // Skip escaped [
            if (i > 0 and text[i - 1] == '\\') {
                i += 1;
                continue;
            }
            // Check for empty class [] (not [^])
            if (text[i + 1] == ']') {
                ctx.report(node, meta.name, "Empty character class '[]' will never match anything", meta.default_severity);
                return;
            }
        }

        // Skip escaped characters
        if (text[i] == '\\') {
            i += 2;
        } else {
            i += 1;
        }
    }
}
