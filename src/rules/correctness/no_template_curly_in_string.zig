const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-template-curly-in-string",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow template literal placeholder syntax in regular strings",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);

    // String literal includes quotes, scan the content for "${"
    if (text.len < 3) return; // at minimum: "X"

    // Search within the string content (skip opening quote)
    var i: usize = 1;
    while (i + 1 < text.len) : (i += 1) {
        if (text[i] == '$' and text[i + 1] == '{') {
            ctx.report(node, meta.name, "Unexpected template string expression in a regular string", meta.default_severity);
            return;
        }
    }
}
