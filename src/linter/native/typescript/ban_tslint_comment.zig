// HAND-WRITTEN.
// Rule: @typescript-eslint/ban-tslint-comment
//
// Reports every `tslint:...` directive inside a source comment.
// Patterns covered:
//   /* tslint:disable */          /* tslint:enable */
//   /* tslint:disable:rule */     /* tslint:enable:rule */
//   // tslint:disable             // tslint:enable
//   // tslint:disable-next-line   // tslint:disable-line
// Trailing arguments (`rule1 rule2 ...`) are tolerated; the directive
// itself begins with `tslint:`.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "ban-tslint-comment",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `// tslint:<rule-flag>` comments",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    scanSource(ctx);
}

fn scanSource(ctx: *const LintContext) void {
    const src = ctx.ast.source;
    var i: usize = 0;
    while (i + 1 < src.len) {
        // `//` line comment
        if (src[i] == '/' and src[i + 1] == '/') {
            const start = i;
            i += 2;
            const body_start = i;
            while (i < src.len and src[i] != '\n') i += 1;
            const end = i;
            checkComment(src[body_start..end], start, end, ctx);
            continue;
        }
        // `/* */` block comment
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
        // String literals — skip to avoid matching `tslint:` inside strings.
        if (src[i] == '"' or src[i] == '\'' or src[i] == '`') {
            const quote = src[i];
            i += 1;
            while (i < src.len) : (i += 1) {
                if (src[i] == '\\') { i += 1; continue; }
                if (src[i] == quote) { i += 1; break; }
            }
            continue;
        }
        i += 1;
    }
}

fn checkComment(body: []const u8, start: usize, end: usize, ctx: *const LintContext) void {
    // Trim leading whitespace.
    var s: usize = 0;
    while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
    if (s >= body.len) return;
    const trimmed = body[s..];
    if (!std.mem.startsWith(u8, trimmed, "tslint:")) return;
    const rest = trimmed["tslint:".len..];
    // Look for one of the recognized directives at the start.
    const directives = [_][]const u8{
        "disable-next-line",
        "disable-line",
        "disable",
        "enable",
    };
    var ok = false;
    for (directives) |d| {
        if (std.mem.startsWith(u8, rest, d)) { ok = true; break; }
    }
    if (!ok) return;
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(end),
    }, "commentDetected");
}
