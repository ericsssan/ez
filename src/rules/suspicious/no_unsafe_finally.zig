const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.try_stmt};

pub const meta = RuleMeta{
    .name = "no-unsafe-finally",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow control flow statements in finally blocks",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));

    const finally_body = try_data.finally_body;
    if (finally_body == .none) return;

    // Check statements in the finally block
    if (ctx.nodeTag(finally_body) != .block_stmt) return;

    const block_data = ctx.nodeData(finally_body);
    const range = ast.SubRange{
        .start = @intFromEnum(block_data.lhs),
        .end = @intFromEnum(block_data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(stmt);
        switch (tag) {
            .return_stmt, .throw_stmt, .break_stmt, .break_label, .continue_stmt, .continue_label => {
                ctx.report(stmt, meta.name, "Unsafe usage of control flow statement in a finally block", meta.default_severity);
            },
            else => {},
        }
    }
}
