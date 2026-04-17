const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-ts-expect-error",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using `@ts-expect-error` over `@ts-ignore`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const source = ctx.source();
    var i: usize = 0;
    while (i < source.len) {
        if (i + 1 < source.len and source[i] == '/' and source[i + 1] == '/') {
            var line_end = i + 2;
            while (line_end < source.len and source[line_end] != '\n') : (line_end += 1) {}
            const comment = source[i..line_end];
            if (std.mem.indexOf(u8, comment, "@ts-ignore") != null) {
                ctx.report(.root);
                return;
            }
            i = line_end;
        } else {
            i += 1;
        }
    }
}
