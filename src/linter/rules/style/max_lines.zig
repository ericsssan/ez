const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-lines",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum number of lines per file",
};

const MAX_LINES: usize = 300;

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const src = ctx.source();
    var lines: usize = 1;
    for (src) |c| {
        if (c == '\n') lines += 1;
    }
    if (lines > MAX_LINES) {
        ctx.report(.root, meta.name, "File has too many lines", meta.default_severity);
    }
}
