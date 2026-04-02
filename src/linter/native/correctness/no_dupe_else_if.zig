const std = @import("std");
const ast = @import("../../../parser/ast.zig");
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
    // Use a HashMap for O(1) duplicate detection instead of O(n) linear scan.
    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    const first_cond = ctx.nodeData(node).lhs;
    if (first_cond == .none) return;
    seen.put(ctx.tokenText(ctx.nodeMainToken(first_cond)), {}) catch return;

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

        const alt_text = ctx.tokenText(ctx.nodeMainToken(alt_cond));

        const result = seen.getOrPut(alt_text) catch return;
        if (result.found_existing) {
            ctx.report(alternate, meta.name, "Duplicate condition in if-else-if chain", meta.default_severity);
        }

        current = alternate;
    }
}
