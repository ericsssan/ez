const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub const meta = RuleMeta{
    .name = "no-duplicate-case",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate case labels in switch statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    if (data.rhs == .none) return;

    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(sub_range);

    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    for (cases) |case_idx| {
        const case_node: NodeIndex = @enumFromInt(case_idx);
        const case_tag = ctx.nodeTag(case_node);

        if (case_tag != .switch_case) continue;

        const test_expr = ctx.nodeData(case_node).lhs;
        if (test_expr == .none) continue;

        const token = ctx.nodeMainToken(test_expr);
        const text = ctx.tokenText(token);

        if (seen.contains(text)) {
            ctx.report(case_node, meta.name, "Duplicate case label", meta.default_severity);
        } else {
            seen.put(text, {}) catch {};
        }
    }
}
