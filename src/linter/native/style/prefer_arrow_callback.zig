const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-arrow-callback",
    .category = .style,
    .default_severity = .warning,
    .description = "Require arrow functions as callbacks",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);

    for (args) |arg_idx| {
        const arg: NodeIndex = @enumFromInt(arg_idx);
        if (arg == .none) continue;
        const arg_tag = ctx.nodeTag(arg);
        // Flag anonymous function expressions as callbacks
        if (arg_tag == .fn_expr or arg_tag == .async_fn_expr) {
            ctx.report(arg);
        }
    }
}
