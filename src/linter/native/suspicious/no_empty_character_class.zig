const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.regex_literal};

pub const meta = RuleMeta{
    .name = "no-empty-character-class",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow empty character classes in regular expressions",
};

/// Scan a character class starting at `pos` (which points to `[`).
/// Returns the position after the closing `]`, or null if an empty class was found.
/// In v-mode (Unicode sets), `[` inside a class opens a nested class.
fn scanClass(text: []const u8, pos: usize, v_mode: bool) ?usize {
    var i = pos + 1; // skip opening '['
    // [^] is valid (matches any character) — skip negation but don't flag.
    const negated = i < text.len and text[i] == '^';
    if (negated) i += 1;
    // Empty class: [] only (not [^])
    if (!negated and i < text.len and text[i] == ']') return null;
    // Scan to closing ']'
    while (i < text.len) {
        switch (text[i]) {
            '\\' => i += 2,
            '[' => if (v_mode) {
                // Nested class in v-mode
                i = scanClass(text, i, true) orelse return null;
            } else {
                i += 1;
            },
            ']' => return i + 1,
            else => i += 1,
        }
    }
    return i;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    if (text.len < 2) return;

    // Detect 'v' flag (Unicode sets mode, enables nested classes).
    // The token is /pattern/flags — scan from the end for the closing '/'.
    var last_slash = text.len - 1;
    while (last_slash > 0 and text[last_slash] != '/') : (last_slash -= 1) {}
    const flags = text[last_slash + 1 ..];
    const v_mode = std.mem.indexOf(u8, flags, "v") != null;

    var i: usize = 1;
    while (i < text.len) {
        switch (text[i]) {
            '\\' => i += 2,
            '/' => break,
            '[' => {
                i = scanClass(text, i, v_mode) orelse {
                    ctx.report(node, meta.name, "Empty character class '[]' will never match anything", meta.default_severity);
                    return;
                };
            },
            else => i += 1,
        }
    }
}
