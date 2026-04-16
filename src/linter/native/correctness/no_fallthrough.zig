const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub const meta = RuleMeta{
    .name = "no-fallthrough",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow fallthrough of case statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);
    if (cases.len == 0) return;

    // Check all cases except the last one.
    // The last case can exit without a terminator (switch exits naturally).
    for (cases[0 .. cases.len - 1]) |case_int| {
        const case_node = NodeIndex.fromInt(case_int);
        const case_tag = ctx.nodeTag(case_node);
        if (case_tag != .switch_case and case_tag != .switch_default) continue;

        const case_data = ctx.nodeData(case_node);
        if (case_data.rhs == .none) continue;

        const case_range = ctx.extraData(ast.SubRange, @intFromEnum(case_data.rhs));
        const stmts = ctx.extraSlice(case_range);

        // Empty case body is allowed to fall through intentionally.
        if (stmts.len == 0) continue;

        const last_stmt = NodeIndex.fromInt(stmts[stmts.len - 1]);
        if (alwaysTerminates(ctx, last_stmt)) continue;

        ctx.report(case_node);
    }
}

/// Returns true if the statement always transfers control out of the case
/// (break/return/throw/continue, or a block whose last statement does so).
fn alwaysTerminates(ctx: *const LintContext, node: NodeIndex) bool {
    return switch (ctx.nodeTag(node)) {
        .break_stmt, .break_label,
        .return_stmt, .throw_stmt,
        .continue_stmt, .continue_label => true,
        // Block: check if the last statement terminates.
        .block_stmt => blk: {
            const d = ctx.nodeData(node);
            if (d.rhs == .none) break :blk false;
            const r = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
            const stmts = ctx.extraSlice(r);
            if (stmts.len == 0) break :blk false;
            break :blk alwaysTerminates(ctx, NodeIndex.fromInt(stmts[stmts.len - 1]));
        },
        else => false,
    };
}
