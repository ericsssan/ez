const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .getter_def, .computed_getter_def };

pub const meta = RuleMeta{
    .name = "getter-return",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Enforce `return` statements in getters",
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
        if (tag == .return_stmt) return;
    }

    ctx.report(node, meta.name, "Getter must return a value", meta.default_severity);
}
