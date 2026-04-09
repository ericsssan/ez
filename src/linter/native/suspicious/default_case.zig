const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require a `default` case in switch statements",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // rhs = extra index to SubRange of cases
    if (data.rhs == .none) {
        ctx.report(node);
        return;
    }

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);

    for (cases) |case_idx| {
        const case_node: NodeIndex = @enumFromInt(case_idx);
        if (ctx.nodeTag(case_node) == .switch_default) return;
    }

    // Check for "no default" comment pattern in the switch body.
    // ESLint accepts commentPattern option (default: /^no default$/i).
    // Check if any comment in the switch contains "no default".
    const src = ctx.source();
    const span = ctx.nodeSpan(node);
    if (hasNoDefaultComment(src, span.start, span.end)) return;

    ctx.report(node);
}

fn hasNoDefaultComment(source: []const u8, start: u32, end: u32) bool {
    const region = source[start..@min(end, @as(u32, @intCast(source.len)))];
    // Search for "no default" in line comments (// no default) or block comments (/* no default */)
    var i: usize = 0;
    while (i + 1 < region.len) {
        if (region[i] == '/' and region[i + 1] == '/') {
            // Line comment — check rest of line
            const comment_start = i + 2;
            var line_end = comment_start;
            while (line_end < region.len and region[line_end] != '\n') line_end += 1;
            if (containsNoDefault(region[comment_start..line_end])) return true;
            i = line_end;
        } else if (region[i] == '/' and region[i + 1] == '*') {
            // Block comment
            const comment_start = i + 2;
            var comment_end = comment_start;
            while (comment_end + 1 < region.len) {
                if (region[comment_end] == '*' and region[comment_end + 1] == '/') break;
                comment_end += 1;
            }
            if (containsNoDefault(region[comment_start..comment_end])) return true;
            i = if (comment_end + 1 < region.len) comment_end + 2 else region.len;
        } else {
            i += 1;
        }
    }
    return false;
}

fn containsNoDefault(text: []const u8) bool {
    // Case-insensitive search for "no default"
    const trimmed = std.mem.trim(u8, text, " \t\r\n");
    if (trimmed.len < 10) return false; // "no default" is 10 chars
    var lower: [256]u8 = undefined;
    const len = @min(trimmed.len, 256);
    for (trimmed[0..len], 0..) |c, j| {
        lower[j] = if (c >= 'A' and c <= 'Z') c + 32 else c;
    }
    return std.mem.indexOf(u8, lower[0..len], "no default") != null;
}
