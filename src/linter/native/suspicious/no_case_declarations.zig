const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .switch_case, .switch_default };

pub const meta = RuleMeta{
    .name = "no-case-declarations",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow lexical declarations in case clauses without block wrapping",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // For switch_case: lhs = test, rhs = extra to SubRange of stmts
    // For switch_default: lhs = none, rhs = extra to SubRange of stmts
    if (data.rhs == .none) return;

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const stmts = ctx.extraSlice(range);

    // If the case has a single block_stmt wrapping everything, it's fine
    if (stmts.len == 1) {
        const single: NodeIndex = @enumFromInt(stmts[0]);
        if (ctx.nodeTag(single) == .block_stmt) return;
    }

    // Check if any statement is a lexical declaration without a block wrapper
    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const stmt_tag = ctx.nodeTag(stmt);
        switch (stmt_tag) {
            .let_decl, .const_decl, .class_decl, .fn_decl, .async_fn_decl => {
                ctx.report(stmt);
            },
            else => {},
        }
    }
}
