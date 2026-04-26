const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .string_literal, .template_literal };
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-script-url",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `javascript:` URLs in string literals",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const tag = ctx.nodeTag(node);
    const text = ctx.tokenText(token);

    if (tag == .string_literal) {
        // Token text includes quotes ('' or "")
        if (text.len < 2) return;
        const content = text[1 .. text.len - 1];
        if (std.ascii.startsWithIgnoreCase(content, "javascript:")) {
            ctx.report(node);
        }
    } else if (tag == .template_literal) {
        // Skip tagged templates (foo`...`) — only plain template literals are flagged.
        const parent = ctx.parentOf(node);
        if (parent != .none and ctx.nodeTag(parent) == .tagged_template) return;

        // Template literal: check if it starts with javascript:
        // The main_token is the opening backtick. We need to check the source.
        const src = ctx.source();
        const start = ctx.tokenStart(token);
        if (start >= src.len or src[start] != '`') return;
        // Content starts after the backtick
        const content_start = start + 1;
        const remaining = src[content_start..];
        if (std.ascii.startsWithIgnoreCase(remaining, "javascript:")) {
            ctx.report(node);
        }
    }
}
