const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.constructor_def};

pub const meta = RuleMeta{
    .name = "no-this-before-super",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `this`/`super` before calling `super()` in constructors",
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

    var super_called = false;

    for (stmts) |stmt_idx| {
        const stmt_node: NodeIndex = @enumFromInt(stmt_idx);
        const tag = ctx.nodeTag(stmt_node);

        // Check for super() call - expression_stmt wrapping call_expr with super_expr callee
        if (tag == .expression_stmt) {
            const expr = ctx.nodeData(stmt_node).lhs;
            if (expr != .none and ctx.nodeTag(expr) == .call_expr) {
                const call_data = ctx.nodeData(expr);
                if (call_data.lhs != .none and ctx.nodeTag(call_data.lhs) == .super_expr) {
                    super_called = true;
                    continue;
                }
            }
        }

        if (!super_called) {
            // Check if this statement uses `this`
            if (stmtUsesThis(stmt_node, ctx)) {
                ctx.report(stmt_node, meta.name, "Use of `this` before `super()` in constructor", meta.default_severity);
                return;
            }
        }
    }
}

fn stmtUsesThis(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;

    const tag = ctx.nodeTag(node);
    if (tag == .this_expr) return true;

    const data = ctx.nodeData(node);

    // Check lhs — safe for most node types (lhs is typically a child node).
    if (data.lhs != .none and stmtUsesThis(data.lhs, ctx)) return true;

    // Only check rhs for tags where rhs IS a child NodeIndex (not an
    // extra-data index).  Blindly recursing on rhs for tags like
    // if_else_stmt, for_stmt, try_stmt, etc. would read garbage.
    switch (tag) {
        .expression_stmt, .return_stmt, .throw_stmt,
        .assign, .add, .subtract, .multiply, .divide,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .member_expr, .computed_member_expr,
        .if_stmt, .while_stmt, .do_while_stmt,
        => {
            if (data.rhs != .none) {
                if (stmtUsesThis(data.rhs, ctx)) return true;
            }
        },
        else => {},
    }

    return false;
}
