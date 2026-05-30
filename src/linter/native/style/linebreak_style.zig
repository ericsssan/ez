// Rule: linebreak-style
// Enforces a single linebreak style: "unix" (LF, default) or "windows" (CRLF).
// Mirrors: tests/conformance/eslint/lib/rules/linebreak-style.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "linebreak-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent linebreak style",
};

pub const relevant_tags = [_]Node.Tag{.root};

pub const needs_semantic = false;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.ast.nodeTag(node) != .root) return;
    var want_unix = true;
    if (ctx.rule_options_all) |all| {
        for (all) |item| {
            if (item == .string and std.mem.eql(u8, item.string, "windows")) {
                want_unix = false;
                break;
            }
        }
    }
    const src = ctx.ast.source;
    var i: usize = 0;
    while (i < src.len) : (i += 1) {
        const c = src[i];
        if (c != '\r' and c != '\n') continue;
        const start = i;
        var len: usize = 1;
        if (c == '\r' and i + 1 < src.len and src[i + 1] == '\n') {
            len = 2;
            i += 1;
        }
        // Got a linebreak of length `len` at byte `start`.
        const is_crlf = len == 2;
        const is_lf = !is_crlf and c == '\n';
        const is_cr_only = !is_crlf and c == '\r';
        const ok = if (want_unix) is_lf else is_crlf;
        if (ok) continue;
        // Skip lone CR linebreaks that the source has, since the ESLint pattern
        // matches `\r\n|[\r\n  ]` — a lone `\r` IS matched.  Keep
        // reporting them too.
        _ = is_cr_only;
        const msg = if (want_unix) "expectedLF" else "expectedCRLF";
        ctx.reportSpanWithMessageId(
            .{ .start = @intCast(start), .end = @intCast(start + len) },
            msg,
        );
    }
}
