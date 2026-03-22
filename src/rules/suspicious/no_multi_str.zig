const ast = @import("../../ast.zig");
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

    // Look for \ followed by a newline inside the string
    var i: usize = 1;
    while (i < text.len - 1) : (i += 1) {
        if (text[i] == '\\' and i + 1 < text.len) {
            if (text[i + 1] == '\n' or text[i + 1] == '\r') {
                ctx.report(node, meta.name, "Multiline string using backslash continuation is not recommended", meta.default_severity);
                return;
            }
        }
    }
}
