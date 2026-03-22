const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.try_stmt};

pub const meta = RuleMeta{
    .name = "no-useless-catch",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unnecessary catch clauses that just rethrow",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    if (data.rhs == .none) return;

    const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));

    const catch_param = try_data.catch_param;
    const catch_body = try_data.catch_body;

    if (catch_param == .none or catch_body == .none) return;

    // Get catch param name
    if (ctx.nodeTag(catch_param) != .identifier) return;
    const param_name = ctx.tokenText(ctx.nodeMainToken(catch_param));

    // Check if catch body has exactly one statement
    if (ctx.nodeTag(catch_body) != .block_stmt) return;

    const body_data = ctx.nodeData(catch_body);
    const sub_range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const stmts = ctx.extraSlice(sub_range);

    if (stmts.len != 1) return;

    const stmt_node: NodeIndex = @enumFromInt(stmts[0]);

    // Check if the single statement is `throw <param>`
    if (ctx.nodeTag(stmt_node) != .throw_stmt) return;

    const thrown_expr = ctx.nodeData(stmt_node).lhs;
    if (thrown_expr == .none) return;

    if (ctx.nodeTag(thrown_expr) != .identifier) return;

    const thrown_name = ctx.tokenText(ctx.nodeMainToken(thrown_expr));

    if (std.mem.eql(u8, thrown_name, param_name)) {
        ctx.report(node, meta.name, "Unnecessary catch clause that just rethrows the error", meta.default_severity);
    }
}

