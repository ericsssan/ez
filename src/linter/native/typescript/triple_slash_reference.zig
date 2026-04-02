const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "triple-slash-reference",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow certain triple slash directives in favor of ES6-style import declarations",
};

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const source = ctx.source();
    var i: usize = 0;
    while (i < source.len) {
        // Look for `///` comment
        if (i + 2 < source.len and source[i] == '/' and source[i + 1] == '/' and source[i + 2] == '/') {
            var line_end = i + 3;
            while (line_end < source.len and source[line_end] != '\n') : (line_end += 1) {}
            const comment = source[i..line_end];
            if (std.mem.indexOf(u8, comment, "<reference") != null or
                std.mem.indexOf(u8, comment, "<amd-module") != null)
            {
                ctx.report(.root, meta.name, "Do not use triple-slash references", meta.default_severity);
                return;
            }
            i = line_end;
        } else {
            i += 1;
        }
    }
}
