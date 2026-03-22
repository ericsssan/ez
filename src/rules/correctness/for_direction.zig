const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.for_stmt};

pub const meta = RuleMeta{
    .name = "for-direction",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce `for` loop update clause moving the counter in the right direction",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));

    const condition = for_data.condition;
    const update = for_data.update;

    if (condition == .none or update == .none) return;

    const cond_tag = ctx.nodeTag(condition);
    const update_tag = ctx.nodeTag(update);

    const is_less = cond_tag == .less_than or cond_tag == .less_equal;
    const is_greater = cond_tag == .greater_than or cond_tag == .greater_equal;

    if (!is_less and !is_greater) return;

    const is_dec = update_tag == .prefix_dec or update_tag == .postfix_dec;
    const is_inc = update_tag == .prefix_inc or update_tag == .postfix_inc;

    if (is_less and is_dec) {
        ctx.report(node, meta.name, "Update clause moves counter in the wrong direction", meta.default_severity);
    } else if (is_greater and is_inc) {
        ctx.report(node, meta.name, "Update clause moves counter in the wrong direction", meta.default_severity);
    }
}
