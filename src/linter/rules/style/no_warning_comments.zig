const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const meta = RuleMeta{
    .name = "no-warning-comments",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow specified warning terms in comments",
};

pub const relevant_tags = [_]Node.Tag{.root};

const WARNING_TERMS = [_][]const u8{ "TODO", "FIXME", "HACK", "XXX" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const source = ctx.source();
    var i: usize = 0;
    while (i < source.len) {
        // Look for `//` comment start
        if (i + 1 < source.len and source[i] == '/' and source[i + 1] == '/') {
            // Find end of line
            const line_start = i;
            var line_end = i + 2;
            while (line_end < source.len and source[line_end] != '\n') : (line_end += 1) {}
            const comment = source[line_start..line_end];
            for (WARNING_TERMS) |term| {
                if (std.mem.indexOf(u8, comment, term) != null) {
                    ctx.reportSpan(
                        Span{ .start = @intCast(line_start), .end = @intCast(line_end) },
                        meta.name,
                        "Unexpected warning comment",
                        meta.default_severity,
                    );
                    break;
                }
            }
            i = line_end;
        } else {
            i += 1;
        }
    }
}
