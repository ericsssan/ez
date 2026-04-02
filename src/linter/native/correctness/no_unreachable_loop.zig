const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow loops with a body that allows only one iteration",
};

pub const relevant_tags = [_]Node.Tag{
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    const body: NodeIndex = switch (tag) {
        .while_stmt => data.rhs,
        .do_while_stmt => data.lhs,
        .for_stmt => data.rhs,
        .for_in_stmt, .for_of_stmt => blk: {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            break :blk for_data.body;
        },
        else => return,
    };

    if (body == .none) return;

    if (ctx.nodeTag(body) == .block_stmt) {
        const block_data = ctx.nodeData(body);
        if (block_data.lhs == .none or block_data.rhs == .none) return;
        const range = ast.SubRange{
            .start = @intFromEnum(block_data.lhs),
            .end = @intFromEnum(block_data.rhs),
        };
        const stmts = ctx.extraSlice(range);
        if (stmts.len > 0) {
            const first: NodeIndex = @enumFromInt(stmts[0]);
            if (first != .none and isExitTerminator(ctx.nodeTag(first))) {
                ctx.report(node, meta.name, "Loop body always exits on first iteration", meta.default_severity);
            }
        }
    } else {
        if (isExitTerminator(ctx.nodeTag(body))) {
            ctx.report(node, meta.name, "Loop body always exits on first iteration", meta.default_severity);
        }
    }
}

/// Returns true for statements that exit the loop (not continue which stays in the loop).
fn isExitTerminator(tag: Node.Tag) bool {
    return switch (tag) {
        .return_stmt, .throw_stmt, .break_stmt, .break_label => true,
        else => false,
    };
}
