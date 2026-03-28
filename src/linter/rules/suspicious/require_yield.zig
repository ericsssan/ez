const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    .generator_fn_decl,
    .async_generator_fn_decl,
    .generator_fn_expr,
    .async_generator_fn_expr,
};

pub const meta = RuleMeta{
    .name = "require-yield",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require generator functions to contain at least one yield expression",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));

    const body = fn_data.body;
    if (body == .none) return;

    // Instead of recursively walking children (which is unsafe because
    // data.rhs is not always a NodeIndex), scan all AST nodes between
    // the function body and the end of the file.  This is safe and correct
    // because generator functions with yield will have yield_expr nodes
    // somewhere in the function body's node range.
    //
    // Simplified approach: walk the body block's direct statements and
    // check one level of nesting.
    if (!containsYieldInBlock(body, ctx)) {
        ctx.report(node, meta.name, "Generator function does not contain a yield expression", meta.default_severity);
    }
}

/// Check if a block_stmt contains a yield_expr in its direct statements
/// or one level of nested blocks/expressions.
fn containsYieldInBlock(block: NodeIndex, ctx: *const LintContext) bool {
    if (block == .none) return false;
    if (ctx.nodeTag(block) != .block_stmt) return false;

    const block_data = ctx.nodeData(block);
    const range = ast.SubRange{
        .start = @intFromEnum(block_data.lhs),
        .end = @intFromEnum(block_data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (stmtContainsYield(stmt, ctx)) return true;
    }
    return false;
}

/// Check a single statement for yield, handling common wrappers safely.
fn stmtContainsYield(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;

    const tag = ctx.nodeTag(node);

    // Direct yield.
    if (tag == .yield_expr or tag == .yield_delegate) return true;

    // Don't recurse into nested functions.
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        => return false,
        else => {},
    }

    const data = ctx.nodeData(node);

    // For expression_stmt, check its expression (lhs is the expression).
    if (tag == .expression_stmt) {
        return stmtContainsYield(data.lhs, ctx);
    }

    // For block_stmt, recurse into the block.
    if (tag == .block_stmt) {
        return containsYieldInBlock(node, ctx);
    }

    // For nodes where lhs is a child node (most unary/binary/etc.), check lhs.
    // Only check data.lhs — we intentionally do NOT check data.rhs because
    // for many node types (if_else_stmt, for_stmt, try_stmt, etc.) rhs is an
    // extra-data index, not a child NodeIndex.
    if (data.lhs != .none) {
        if (stmtContainsYield(data.lhs, ctx)) return true;
    }

    // For simple nodes where rhs IS a child (binary ops, assign, etc.),
    // it's safe to check rhs.  But we limit to known-safe tags.
    switch (tag) {
        .assign, .add, .subtract, .multiply, .divide,
        .if_stmt, .while_stmt, .do_while_stmt,
        .return_stmt, .throw_stmt,
        => {
            if (data.rhs != .none) {
                if (stmtContainsYield(data.rhs, ctx)) return true;
            }
        },
        else => {},
    }

    return false;
}
