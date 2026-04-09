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

    // Scan string content (skip opening/closing quote)
    var i: usize = 1;
    while (i < text.len - 1) : (i += 1) {
        if (text[i] != '\\' or i + 1 >= text.len - 1) continue;
        const c1 = text[i + 1];
        if (c1 >= '1' and c1 <= '7') {
            // \1-\7 is always an octal escape
            ctx.report(node);
            return;
        }
        if (c1 == '0' and i + 2 < text.len - 1 and text[i + 2] >= '0' and text[i + 2] <= '9') {
            // \0 followed by any digit — deprecated octal/escape sequence (e.g. \01, \08)
            ctx.report(node);
            return;
        }
        // Skip escaped character(s): handle multi-char escape sequences
        // \\uXXXX, \\xXX consume extra chars but we only need to skip past the backslash
        i += 1;
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
