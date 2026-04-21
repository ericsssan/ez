const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;
const std = @import("std");

pub const meta = RuleMeta{
    .name = "prefer-ts-expect-error",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using `@ts-expect-error` over `@ts-ignore`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

const ts_ignore = "@ts-ignore";

pub fn run(_: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();
    var i: usize = 0;
    while (i < source.len) {
        if (source[i] != '/') { i += 1; continue; }

        // Line comment: //
        if (i + 1 < source.len and source[i + 1] == '/') {
            const comment_start = i;
            i += 2;
            // Matches /^\s*\/?\s*@ts-ignore/ applied to comment value
            while (i < source.len and (source[i] == ' ' or source[i] == '\t')) i += 1;
            if (i < source.len and source[i] == '/') i += 1;
            while (i < source.len and (source[i] == ' ' or source[i] == '\t')) i += 1;
            if (i + ts_ignore.len <= source.len and
                std.mem.eql(u8, source[i .. i + ts_ignore.len], ts_ignore))
            {
                ctx.reportSpan(.{ .start = @intCast(comment_start), .end = @intCast(i + ts_ignore.len) });
            }
            while (i < source.len and source[i] != '\n') i += 1;
            continue;
        }

        // Block comment: /* ... */
        if (i + 1 < source.len and source[i + 1] == '*') {
            const comment_start = i;
            i += 2;
            // Track last line start within comment body
            var last_line_start: usize = i;
            var found_end = false;
            while (i + 1 < source.len) {
                if (source[i] == '*' and source[i + 1] == '/') { found_end = true; break; }
                if (source[i] == '\n') last_line_start = i + 1;
                i += 1;
            }
            if (found_end) {
                // Check last line of body: matches /^\s*(?:\/|\*)*\s*@ts-ignore/
                var j = last_line_start;
                while (j < i and (source[j] == ' ' or source[j] == '\t')) j += 1;
                while (j < i and (source[j] == '/' or source[j] == '*')) j += 1;
                while (j < i and (source[j] == ' ' or source[j] == '\t')) j += 1;
                if (j + ts_ignore.len <= i and
                    std.mem.eql(u8, source[j .. j + ts_ignore.len], ts_ignore))
                {
                    ctx.reportSpan(.{ .start = @intCast(comment_start), .end = @intCast(i + 2) });
                }
                i += 2;
            } else {
                i = source.len;
            }
            continue;
        }

        i += 1;
    }
}
