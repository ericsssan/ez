// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-ts-expect-error
//
// Reports `// @ts-ignore` / `/* @ts-ignore */` comments and prefers
// `// @ts-expect-error` (which errors when the next line has no
// actual error, providing better feedback).

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-ts-expect-error",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce using `@ts-expect-error` over `@ts-ignore`",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const src = ctx.ast.source;
    var i: usize = 0;
    while (i + 1 < src.len) {
        // Line comments.
        if (src[i] == '/' and src[i + 1] == '/') {
            const start = i;
            i += 2;
            const body_start = i;
            while (i < src.len and src[i] != '\n') i += 1;
            const end = i;
            checkComment(src[body_start..end], start, end, ctx);
            continue;
        }
        // Block comments.
        if (src[i] == '/' and src[i + 1] == '*') {
            const start = i;
            i += 2;
            const body_start = i;
            while (i + 1 < src.len and !(src[i] == '*' and src[i + 1] == '/')) i += 1;
            const body_end = i;
            const end = if (i + 1 < src.len) i + 2 else src.len;
            checkComment(src[body_start..body_end], start, end, ctx);
            i = end;
            continue;
        }
        // Skip string literals to avoid matching `@ts-ignore` inside them.
        if (src[i] == '"' or src[i] == '\'' or src[i] == '`') {
            const q = src[i];
            i += 1;
            while (i < src.len) : (i += 1) {
                if (src[i] == '\\') { i += 1; continue; }
                if (src[i] == q) { i += 1; break; }
            }
            continue;
        }
        i += 1;
    }
}

fn checkComment(body: []const u8, start: usize, end: usize, ctx: *const LintContext) void {
    // Scan each line of the comment body; for each line, strip
    // leading whitespace, `*` (JSDoc continuation), and `//` (block
    // comments containing line-comment style directives), then test
    // for `@ts-ignore` directly.
    var line_start: usize = 0;
    while (line_start <= body.len) : (line_start += 1) {
        // Find line end.
        var line_end = line_start;
        while (line_end < body.len and body[line_end] != '\n') line_end += 1;
        if (lineStartsWithIgnore(body[line_start..line_end])) {
            ctx.reportSpanWithMessageId(.{
                .start = @intCast(start),
                .end = @intCast(end),
            }, "preferExpectErrorComment");
            return;
        }
        if (line_end >= body.len) break;
        line_start = line_end;
    }
}

fn lineStartsWithIgnore(line: []const u8) bool {
    var s: usize = 0;
    while (s < line.len) {
        const c = line[s];
        if (c == ' ' or c == '\t' or c == '*' or c == '/') {
            s += 1;
            continue;
        }
        break;
    }
    const directive = "@ts-ignore";
    if (s + directive.len > line.len) return false;
    return std.mem.eql(u8, line[s .. s + directive.len], directive);
}
