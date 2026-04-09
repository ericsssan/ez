const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const meta = RuleMeta{
    .name = "no-control-regex",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow control characters in regular expressions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    // Regex literal is /pattern/flags - skip leading /
    var i: usize = 1;
    while (i < text.len) : (i += 1) {
        // End of pattern at unescaped /
        if (text[i] == '/' and (i == 0 or text[i - 1] != '\\')) break;

        // Check for literal control characters (0x00-0x1f)
        if (text[i] < 0x20) {
            ctx.report(node);
            return;
        }

        // Check for \x00-\x1f hex escape patterns
        if (text[i] == '\\' and i + 3 < text.len and text[i + 1] == 'x') {
            const h1 = hexVal(text[i + 2]);
            const h2 = hexVal(text[i + 3]);
            if (h1 != null and h2 != null) {
                const val = (h1.? << 4) | h2.?;
                if (val < 0x20) {
                    ctx.report(node);
                    return;
                }
            }
            i += 3;
        }
    }
}

fn hexVal(c: u8) ?u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => null,
    };
}
