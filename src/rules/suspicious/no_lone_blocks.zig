const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.block_stmt};

pub const meta = RuleMeta{
    .name = "no-lone-blocks",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary nested blocks",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only flag blocks that appear inside another block's statement list
    // (i.e., standalone blocks that serve no purpose).
    //
    // Strategy: scan the parent block's statement list.  A block_stmt is
    // "lone" when it is a direct child of another block_stmt — this means
    // it was written as a bare { } inside a block, not as the required body
    // of an if/while/for/function/etc.
    //
    // We walk all nodes looking for block_stmts whose statement lists
    // contain `node`.  If found, the enclosing block is the parent.
    // Because we can't cheaply walk parents, we use a heuristic:
    // only flag root-level blocks (the root node's direct children).
    const root_data = ctx.nodeData(.root);
    const root_range = ast.SubRange{
        .start = @intFromEnum(root_data.lhs),
        .end = @intFromEnum(root_data.rhs),
    };
    const root_stmts = ctx.extraSlice(root_range);

    const node_int = @intFromEnum(node);
    for (root_stmts) |raw| {
        if (raw == node_int) {
            // This block_stmt is a direct child of the root — check contents
            const data = ctx.nodeData(node);
            const range = ast.SubRange{
                .start = @intFromEnum(data.lhs),
                .end = @intFromEnum(data.rhs),
            };
            const stmts = ctx.extraSlice(range);

            // If it contains block-scoped declarations, the block serves a purpose
            for (stmts) |stmt_raw| {
                const stmt: NodeIndex = @enumFromInt(stmt_raw);
                const tag = ctx.nodeTag(stmt);
                switch (tag) {
                    .let_decl, .const_decl, .class_decl, .fn_decl, .async_fn_decl => return,
                    else => {},
                }
            }

            ctx.report(node, meta.name, "Block is unnecessary", meta.default_severity);
            return;
        }
    }
}
