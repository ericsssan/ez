const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .setter_def, .computed_setter_def };

pub const meta = RuleMeta{
    .name = "no-setter-return",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow returning values from setters",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    const body = method_data.body;

    if (body == .none) return;

    if (ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const sub_range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };

    const stmts = ctx.extraSlice(sub_range);

    for (stmts) |stmt_idx| {
        const stmt_node: NodeIndex = @enumFromInt(stmt_idx);
        const tag = ctx.nodeTag(stmt_node);
        if (tag == .return_stmt) {
            const return_data = ctx.nodeData(stmt_node);
            if (return_data.lhs != .none) {
                ctx.report(stmt_node);
            }
        }
    }
}
