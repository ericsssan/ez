const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};

pub const meta = RuleMeta{
    .name = "no-dupe-else-if",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate conditions in if-else-if chains",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Collect all conditions in the if-else-if chain
    var conditions = std.ArrayList(NodeIndex){};
    defer conditions.deinit(ctx.allocator);

    // Add the first condition
    const first_cond = ctx.nodeData(node).lhs;
    if (first_cond == .none) return;
    conditions.append(ctx.allocator, first_cond) catch return;

    // Walk the else-if chain
    var current = node;
    while (true) {
        const cur_data = ctx.nodeData(current);
        const cur_tag = ctx.nodeTag(current);

        if (cur_tag != .if_else_stmt) break;

        const if_data = ctx.extraData(ast.IfData, @intFromEnum(cur_data.rhs));
        const alternate = if_data.alternate;

        if (alternate == .none) break;

        const alt_tag = ctx.nodeTag(alternate);
        if (alt_tag != .if_stmt and alt_tag != .if_else_stmt) break;

        const alt_cond = ctx.nodeData(alternate).lhs;
        if (alt_cond == .none) break;

        // Check if this condition duplicates any previous one.
        // Use main token text (since nodeSpan.end is not yet implemented).
        const alt_token = ctx.nodeMainToken(alt_cond);
        const alt_text = ctx.tokenText(alt_token);

        for (conditions.items) |prev_cond| {
            const prev_token = ctx.nodeMainToken(prev_cond);
            const prev_text = ctx.tokenText(prev_token);

            if (std.mem.eql(u8, alt_text, prev_text)) {
                ctx.report(alternate, meta.name, "Duplicate condition in if-else-if chain", meta.default_severity);
                break;
            }
        }

        conditions.append(ctx.allocator, alt_cond) catch return;
        current = alternate;
    }
}
