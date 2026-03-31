const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "guard-for-in",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Require for-in loops to include an if statement",
};

pub const relevant_tags = [_]Node.Tag{.for_in_stmt};

/// Returns true if the block body starts with an if-statement (guard).
fn bodyHasGuard(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    const tag = ctx.nodeTag(body);
    // Direct if-statement as body
    if (tag == .if_stmt or tag == .if_else_stmt) return true;
    // Block — check if first statement is an if
    if (tag == .block_stmt) {
        const data = ctx.nodeData(body);
        const start = @intFromEnum(data.lhs);
        const end = @intFromEnum(data.rhs);
        if (start >= end) return false; // empty block
        const stmts = ctx.extraSlice(.{ .start = start, .end = end });
        if (stmts.len == 0) return false;
        const first_tag = ctx.nodeTag(@enumFromInt(stmts[0]));
        return first_tag == .if_stmt or first_tag == .if_else_stmt;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
    if (!bodyHasGuard(for_data.body, ctx)) {
        ctx.report(node, meta.name, "The body of a for-in should be wrapped in an if statement", meta.default_severity);
    }
}
