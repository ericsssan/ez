// Rule: no-tabs
// Reports tab characters in the source.  With `allowIndentationTabs: true`,
// permits tabs in the leading indentation portion of each line.
// Mirrors: tests/conformance/eslint/lib/rules/no-tabs.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-tabs",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow all tabs",
};

pub const relevant_tags = [_]Node.Tag{.root};

pub const needs_semantic = false;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.ast.nodeTag(node) != .root) return;
    var allow_indent_tabs = false;
    if (ctx.rule_options) |v| {
        if (v.* == .object) {
            if (v.object.get("allowIndentationTabs")) |x| {
                if (x == .bool) allow_indent_tabs = x.bool;
            }
        }
    }
    const src = ctx.ast.source;
    var line_start: usize = 0;
    var seen_non_ws_on_line = false;
    var i: usize = 0;
    while (i < src.len) : (i += 1) {
        const c = src[i];
        if (c == '\n') {
            line_start = i + 1;
            seen_non_ws_on_line = false;
            continue;
        }
        if (c == '\t') {
            // Find end of consecutive tabs.
            const tab_start = i;
            while (i + 1 < src.len and src[i + 1] == '\t') : (i += 1) {}
            const tab_end = i + 1;
            // If allowIndentationTabs is on AND nothing non-whitespace
            // appeared before this tab on this line, allow it.
            if (allow_indent_tabs and !seen_non_ws_on_line) {
                // The tab itself is whitespace; line still considered indent-only.
                continue;
            }
            ctx.reportSpanWithMessageId(
                .{ .start = @intCast(tab_start), .end = @intCast(tab_end) },
                "unexpectedTab",
            );
            continue;
        }
        if (c != ' ' and c != '\r') seen_non_ws_on_line = true;
    }
}
