const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.switch_case};

pub const meta = RuleMeta{
    .name = "no-fallthrough",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow fallthrough of case statements",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    if (data.rhs == .none) return;

    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const stmts = ctx.extraSlice(sub_range);

    // Empty case body is allowed (falls through to next case intentionally)
    if (stmts.len == 0) return;

    // Check if the last statement is a terminator
    const last_stmt: NodeIndex = @enumFromInt(stmts[stmts.len - 1]);
    const last_tag = ctx.nodeTag(last_stmt);

    if (isTerminator(last_tag)) return;

    ctx.report(node, meta.name, "Expected a `break`, `return`, `throw`, or `continue` statement", meta.default_severity);
}

fn isTerminator(tag: Node.Tag) bool {
    return switch (tag) {
        .break_stmt, .break_label, .return_stmt, .throw_stmt, .continue_stmt, .continue_label => true,
        else => false,
    };
}
