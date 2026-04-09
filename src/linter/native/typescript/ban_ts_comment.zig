const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;
const std = @import("std");

pub const meta = RuleMeta{
    .name = "ban-ts-comment",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow `@ts-<directive>` comments that suppress TypeScript compiler errors",
};

pub const relevant_tags = [_]Node.Tag{.root};

const ts_directives = [_][]const u8{
    "@ts-ignore",
    "@ts-nocheck",
    "@ts-expect-error",
};

pub fn run(_: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();

    var i: usize = 0;
    while (i < source.len) {
        // Fast scan for '/' which starts comments
        if (source[i] != '/') {
            i += 1;
            continue;
        }

        // Single-line comment: //
        if (i + 1 < source.len and source[i + 1] == '/') {
            const comment_start = i;
            i += 2;
            // Skip leading whitespace inside comment
            while (i < source.len and (source[i] == ' ' or source[i] == '\t')) {
                i += 1;
            }
            // Check for @ts-* directive
            for (ts_directives) |directive| {
                if (i + directive.len <= source.len and
                    std.mem.eql(u8, source[i .. i + directive.len], directive))
                {
                    ctx.reportSpan(.{ .start = @intCast(comment_start), .end = @intCast(i + directive.len) });
                    break;
                }
            }
            // Advance to end of line
            while (i < source.len and source[i] != '\n') {
                i += 1;
            }
            continue;
        }

        // Block comment: /* ... */
        if (i + 1 < source.len and source[i + 1] == '*') {
            i += 2;
            // Scan for end of block comment
            while (i + 1 < source.len) {
                if (source[i] == '*' and source[i + 1] == '/') {
                    i += 2;
                    break;
                }
                i += 1;
            }
            continue;
        }

        i += 1;
    }
}
