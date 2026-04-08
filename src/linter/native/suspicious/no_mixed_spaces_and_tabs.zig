const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.root};

pub const meta = RuleMeta{
    .name = "no-mixed-spaces-and-tabs",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow mixed spaces and tabs for indentation",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();

    var line_start: usize = 0;
    var line_num: u32 = 1;
    for (source, 0..) |c, idx| {
        if (c == '\n') {
            checkLine(source, line_start, idx, node, ctx, line_num);
            line_start = idx + 1;
            line_num += 1;
        }
    }
    // Check last line
    if (line_start < source.len) {
        checkLine(source, line_start, source.len, node, ctx, line_num);
    }
}

fn checkLine(source: []const u8, start: usize, end: usize, node: NodeIndex, ctx: *const LintContext, _: u32) void {
    var has_space = false;
    var has_tab = false;

    var i = start;
    while (i < end) : (i += 1) {
        const c = source[i];
        if (c == ' ') {
            has_space = true;
        } else if (c == '\t') {
            has_tab = true;
        } else {
            break;
        }
    }

    if (has_space and has_tab) {
        ctx.report(node, meta.name, "Mixed spaces and tabs.", meta.default_severity);
    }
}
