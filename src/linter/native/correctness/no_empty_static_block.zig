const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Span = @import("../../../parser/span.zig").Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-static-block",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty static blocks",
};

pub const relevant_tags = [_]Node.Tag{.static_block};

/// Find the opening '{' and closing '}' of the static block in source.
/// main_token is 'static', so we scan forward to find '{'.
fn findBlockBraces(node: NodeIndex, ctx: *const LintContext) ?struct { open: usize, close: usize } {
    const src = ctx.source();
    const main_tok = ctx.nodeMainToken(node);
    const start_pos = ctx.tokenStart(main_tok);

    // Find the opening '{' after 'static'
    var i: usize = start_pos;
    while (i < src.len and src[i] != '{') i += 1;
    if (i >= src.len) return null;
    const open_pos = i;
    i += 1;

    // Find matching '}'
    var depth: u32 = 1;
    while (i < src.len and depth > 0) {
        if (src[i] == '{') depth += 1
        else if (src[i] == '}') depth -= 1;
        i += 1;
    }
    if (depth != 0) return null;
    const close_pos = i - 1;

    return .{ .open = open_pos, .close = close_pos };
}

/// Check if there's a comment between open_pos+1 and close_pos in source.
fn hasCommentInBlock(src: []const u8, open_pos: usize, close_pos: usize) bool {
    var i: usize = open_pos + 1;
    while (i + 1 < close_pos) {
        if (src[i] == '/' and src[i + 1] == '/') return true;
        if (src[i] == '/' and src[i + 1] == '*') return true;
        i += 1;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // static_block: lhs = SubRange.start, rhs = SubRange.end (direct encoding)
    // If not empty (has statements), skip.
    if (data.lhs != data.rhs) return;

    // Empty block (no statements). Check if there are comments inside.
    const src = ctx.source();
    const braces = findBlockBraces(node, ctx) orelse {
        ctx.report(node);
        return;
    };

    if (hasCommentInBlock(src, braces.open, braces.close)) return;

    // Report at the opening '{' of the static block (not the 'static' keyword).
    // ESLint reports at the StaticBlock node which starts at '{'.
    ctx.reportSpan(.{ .start = @intCast(braces.open), .end = @intCast(braces.close + 1) });
}

pub fn runOnSymbols(_: *const LintContext) void {}
