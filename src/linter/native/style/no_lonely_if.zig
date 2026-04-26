const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.if_else_stmt};
pub const needs_semantic = true;

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
        // Don't flag when the current if_else_stmt is the consequent (not else) of another if.
        // Simplifying the lonely if in that case would cause dangling else issues.
        const parent = ctx.parentOf(node);
        if (parent != .none) {
            const ptag = ctx.nodeTag(parent);
            if (ptag == .if_stmt or ptag == .if_else_stmt) {
                // Check if `node` is the consequent (lhs) of parent, not the else
                if (ptag == .if_stmt) {
                    // if_stmt: lhs=condition, rhs=consequent
                    if (ctx.nodeData(parent).rhs == node) return; // node is consequent
                } else {
                    // if_else_stmt: lhs=condition, rhs=extra index to IfData
                    const pid = ctx.extraData(ast.IfData, @intFromEnum(ctx.nodeData(parent).rhs));
                    if (pid.consequent == node) return; // node is consequent of outer if_else
                }
            }
        }
        ctx.report(only_stmt);
    }
}
