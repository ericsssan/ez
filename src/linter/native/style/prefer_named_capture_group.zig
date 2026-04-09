const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-named-capture-group",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using named capture groups in regular expression",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal};

/// Check if regex body has unnamed capturing groups.
/// Named groups: (?<name>...)
/// Non-capturing: (?:...) (?=...) (?!...) (?<=...) (?<!...)
/// Unnamed capturing: (...)
fn hasUnnamedGroup(pattern: []const u8) bool {
    var i: usize = 0;
    while (i < pattern.len) : (i += 1) {
        if (pattern[i] == '\\') {
            i += 1;
            continue;
        }
        if (pattern[i] == '[') {
            i += 1;
            while (i < pattern.len and pattern[i] != ']') : (i += 1) {
                if (pattern[i] == '\\') i += 1;
            }
            continue;
        }
        if (pattern[i] == '(') {
            if (i + 1 >= pattern.len) return true; // trailing `(` — unnamed
            if (pattern[i + 1] != '?') return true; // plain `(` — unnamed capturing
            // pattern[i+1] == '?'
            if (i + 2 >= pattern.len) continue; // `(?` at end — unusual, skip
            const c = pattern[i + 2];
            // Non-capturing variants: `?:`, `?=`, `?!`
            if (c == ':' or c == '=' or c == '!') continue;
            // Lookbehind: `?<=` and `?<!` (non-capturing)
            if (c == '<' and i + 3 < pattern.len) {
                const d = pattern[i + 3];
                if (d == '=' or d == '!') continue; // lookbehind assertion
                // `?<name>` — named capturing group, OK
                continue;
            }
            if (c == '<') continue; // `(?<` = named group
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    if (text.len < 2) return;

    // Extract pattern between first and second slash
    var end: usize = 1;
    while (end < text.len) : (end += 1) {
        if (text[end] == '\\') {
            end += 1;
            continue;
        }
        if (text[end] == '/') break;
    }
    const pattern = text[1..end];

    if (hasUnnamedGroup(pattern)) {
        ctx.report(node);
    }
}
