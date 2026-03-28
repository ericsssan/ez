const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const meta = RuleMeta{
    .name = "no-regex-spaces",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow multiple consecutive spaces in regular expression literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    var in_class = false;
    var consecutive_spaces: u32 = 0;
    var i: usize = 1;
    while (i < text.len) : (i += 1) {
        // End of pattern at unescaped /
        if (text[i] == '/' and !in_class and (i == 0 or text[i - 1] != '\\')) break;

        if (text[i] == '\\') {
            consecutive_spaces = 0;
            i += 1; // skip escaped char
            continue;
        }

        if (text[i] == '[') {
            in_class = true;
            consecutive_spaces = 0;
            continue;
        }
        if (text[i] == ']') {
            in_class = false;
            consecutive_spaces = 0;
            continue;
        }

        if (text[i] == ' ' and !in_class) {
            consecutive_spaces += 1;
            if (consecutive_spaces >= 2) {
                ctx.report(node, meta.name, "Multiple consecutive spaces in regex. Use a quantifier instead, e.g. ' {2}'", meta.default_severity);
                return;
            }
        } else {
            consecutive_spaces = 0;
        }
    }
}
