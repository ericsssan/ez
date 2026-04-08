const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-div-regex",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow division operators explicitly at beginning of regular expression",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tok = ctx.nodeMainToken(node);
    const text = ctx.tokenText(tok);

    // Regex text starts with `/`. Check if body starts with `=`
    // e.g. `/=foo/` looks like a division-assignment
    if (text.len < 2) return;
    if (text[0] != '/') return;
    if (text[1] == '=') {
        ctx.report(node, meta.name, "A regular expression literal can be confused with '/='.", meta.default_severity);
    }
}
