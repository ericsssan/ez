const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const Span = @import("../../../parser/span.zig").Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-sparse-arrays",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow sparse arrays",
};

pub const relevant_tags = [_]Node.Tag{.array_literal};

/// Scan source from `start` to find the next top-level comma (depth=1 relative to `[`).
/// Skips strings, comments, and nested brackets. Returns the byte offset of the comma,
/// or null if the array ends first.
fn nextTopLevelComma(src: []const u8, start: usize) ?usize {
    var i = start;
    var depth: i32 = 1; // we start inside the array `[`
    while (i < src.len) {
        switch (src[i]) {
            '\\' => i += 2, // escape sequence
            '\'' , '"', '`' => {
                const q = src[i];
                i += 1;
                while (i < src.len and src[i] != q) {
                    if (src[i] == '\\') i += 1;
                    i += 1;
                }
                i += 1;
            },
            '/' => {
                if (i + 1 < src.len and src[i + 1] == '/') {
                    // line comment
                    while (i < src.len and src[i] != '\n') : (i += 1) {}
                } else if (i + 1 < src.len and src[i + 1] == '*') {
                    i += 2;
                    while (i + 1 < src.len and !(src[i] == '*' and src[i + 1] == '/')) : (i += 1) {}
                    i += 2;
                } else {
                    i += 1;
                }
            },
            '[', '(', '{' => { depth += 1; i += 1; },
            ']', ')', '}' => {
                depth -= 1;
                if (depth <= 0) return null; // exited our array
                i += 1;
            },
            ',' => {
                if (depth == 1) return i;
                i += 1;
            },
            else => i += 1,
        }
    }
    return null;
}


pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range = SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const items = ctx.extraSlice(range);

    // Quick check: any holes?
    var has_holes = false;
    for (items) |raw| {
        if (@as(NodeIndex, @enumFromInt(raw)) == .none) { has_holes = true; break; }
    }
    if (!has_holes) return;

    // Find the opening '[' in source and scan for commas matching each element slot.
    // This mirrors ESLint's commaToken tracking to report at the right line.
    const src = ctx.source();
    const open_tok = ctx.nodeMainToken(node);
    const open_pos = ctx.tokenStart(open_tok);
    if (open_pos >= src.len or src[open_pos] != '[') {
        ctx.report(node);
        return;
    }

    // Scan commas: comma[i] separates element[i] from element[i+1].
    // ESLint tracks `commaToken` per element: for a hole at index j,
    // commaToken = getTokenAfter(prevComma or prevElement, isComma).
    // We approximate this by collecting all top-level comma positions in order.
    var scan_pos: usize = open_pos + 1;
    var comma_positions: [256]usize = undefined;
    var comma_count: usize = 0;
    while (comma_count < 256) {
        const cp = nextTopLevelComma(src, scan_pos) orelse break;
        comma_positions[comma_count] = cp;
        comma_count += 1;
        scan_pos = cp + 1;
    }

    // ESLint's commaToken logic:
    // - commaToken starts as null (becomes '[' if first element is hole)
    // - For each element i: commaToken = getTokenAfter(element[i] ?? commaToken ?? '[', isComma)
    //   i.e., the comma immediately after the current element or the previous comma
    // Since our comma_positions is just the ordered list of commas, and each hole
    // increments the comma index, we can track which comma index corresponds to each hole.
    var comma_idx: usize = 0; // next comma to consume
    for (items, 0..) |raw, elem_idx| {
        const elem: NodeIndex = @enumFromInt(raw);
        // ESLint stops if last element is non-null
        if (elem_idx == items.len - 1 and elem != .none) break;

        if (comma_idx >= comma_count) break;
        const cp = comma_positions[comma_idx];
        comma_idx += 1;

        if (elem == .none) {
            // Report at the comma's source position (matching ESLint's commaToken.loc).
            ctx.reportSpan(.{ .start = @intCast(cp), .end = @intCast(cp + 1) });
        }
    }
}
