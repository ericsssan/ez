const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-nonoctal-decimal-escape",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow \\8 and \\9 escape sequences in string literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    if (text.len < 2) return;

    var i: usize = 1;
    while (i < text.len - 1) {
        if (text[i] == '\\' and i + 1 < text.len) {
            const next = text[i + 1];
            if (next == '8' or next == '9') {
                ctx.report(node);
                return;
            }
            // Skip this escape sequence (2 chars: backslash + escaped char).
            i += 2;
        } else {
            i += 1;
        }
    }
}
