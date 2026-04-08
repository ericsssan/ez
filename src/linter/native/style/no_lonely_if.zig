const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};

pub const meta = RuleMeta{
    .name = "no-lonely-if",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `if` as the only statement in an `else` block",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
    const alternate = if_data.alternate;
    if (alternate == .none) return;

    // Only flag `else { if (...) {} }` — an if wrapped in a block.
    // Do NOT flag `else if (...)` which is idiomatic and parsed as
    // the alternate being a direct if_stmt/if_else_stmt.
    if (ctx.nodeTag(alternate) != .block_stmt) return;

    // Check if the block contains exactly one statement, and it's an if.
    const block_data = ctx.nodeData(alternate);
    const range = ast.SubRange{
        .start = @intFromEnum(block_data.lhs),
        .end = @intFromEnum(block_data.rhs),
    };
    const stmts = ctx.extraSlice(range);
    if (stmts.len != 1) return;

    const only_stmt: NodeIndex = @enumFromInt(stmts[0]);
    const stmt_tag = ctx.nodeTag(only_stmt);
    if (stmt_tag == .if_stmt or stmt_tag == .if_else_stmt) {
        ctx.report(only_stmt, meta.name, "Unexpected if as the only statement in an else block.", meta.default_severity);
    }
}
