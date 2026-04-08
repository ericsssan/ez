const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-multi-str",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow multiline strings using backslash continuation",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Look for \ followed by a line terminator inside the string.
    // Line terminators: LF (0x0A), CR (0x0D), U+2028 LS (E2 80 A8), U+2029 PS (E2 80 A9)
    var i: usize = 1;
    while (i < text.len - 1) : (i += 1) {
        if (text[i] != '\\') continue;
        const next = i + 1;
        if (next >= text.len) break;
        if (text[next] == '\n' or text[next] == '\r') {
            ctx.report(node, meta.name, "Multiline support is limited to browsers supporting ES5 only.", meta.default_severity);
            return;
        }
        // U+2028 LINE SEPARATOR (UTF-8: E2 80 A8) or U+2029 PARAGRAPH SEPARATOR (E2 80 A9)
        if (next + 2 < text.len and text[next] == 0xE2 and text[next + 1] == 0x80 and
            (text[next + 2] == 0xA8 or text[next + 2] == 0xA9))
        {
            ctx.report(node, meta.name, "Multiline support is limited to browsers supporting ES5 only.", meta.default_severity);
            return;
        }
    }
}
