const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-backreference",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow useless backreferences in regular expressions",
};

pub const relevant_tags = [_]Node.Tag{.regex_literal};

/// Check for forward backreferences or refs to groups that don't exist.
/// Only detects trivially useless patterns: \1 where no groups exist.
fn countGroups(pattern: []const u8) u8 {
    var count: u8 = 0;
    var i: usize = 0;
    while (i < pattern.len) : (i += 1) {
        if (pattern[i] == '\\') { i += 1; continue; }
        if (pattern[i] == '[') {
            i += 1;
            while (i < pattern.len and pattern[i] != ']') : (i += 1) {
                if (pattern[i] == '\\') i += 1;
            }
            continue;
        }
        if (pattern[i] == '(') {
            if (i + 1 < pattern.len and pattern[i + 1] == '?') {
                // Non-capturing or named
                if (i + 2 < pattern.len and pattern[i + 2] != ':' and
                    pattern[i + 2] != '=' and pattern[i + 2] != '!') {
                    count += 1; // named group also captures
                }
            } else {
                count += 1;
            }
        }
    }
    return count;
}

fn maxBackref(pattern: []const u8) u8 {
    var max: u8 = 0;
    var i: usize = 0;
    while (i < pattern.len) : (i += 1) {
        if (pattern[i] == '\\' and i + 1 < pattern.len) {
            const next = pattern[i + 1];
            if (next >= '1' and next <= '9') {
                const ref = next - '0';
                if (ref > max) max = ref;
            }
            i += 1;
        }
    }
    return max;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const text = ctx.tokenText(ctx.nodeMainToken(node));
    if (text.len < 2) return;

    var end: usize = 1;
    while (end < text.len) : (end += 1) {
        if (text[end] == '\\') { end += 1; continue; }
        if (text[end] == '/') break;
    }
    const pattern = text[1..end];

    const groups = countGroups(pattern);
    const max_ref = maxBackref(pattern);

    if (max_ref > 0 and max_ref > groups) {
        ctx.report(node, meta.name, "Backreference references a group that does not exist", meta.default_severity);
    }
}
