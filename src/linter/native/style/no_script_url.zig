const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.string_literal};

pub const meta = RuleMeta{
    .name = "no-script-url",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `javascript:` URLs in string literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    // Token text includes quotes, so check after the opening quote character
    if (text.len < 2) return;
    const content = text[1 .. text.len - 1];
    if (std.ascii.startsWithIgnoreCase(content, "javascript:")) {
        ctx.report(node);
    }
}
