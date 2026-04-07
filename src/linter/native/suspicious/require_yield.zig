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
    .method_def,
    .computed_method_def,
};

pub const meta = RuleMeta{
    .name = "require-yield",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require generator functions to contain at least one yield expression",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);

    // For method_def / computed_method_def, only flag generator methods.
    // Object-literal generator methods: main_token IS the `*`.
    // Class generator methods: main_token is the key identifier; `*` is the token before it.
    if (tag == .method_def or tag == .computed_method_def) {
        const main_tok = ctx.nodeMainToken(node);
        const token_pkg = @import("../../../parser/token.zig");
        const is_generator = ctx.tokenTag(main_tok) == token_pkg.Tag.asterisk or
            (main_tok > 0 and ctx.tokenTag(main_tok - 1) == token_pkg.Tag.asterisk);
        if (!is_generator) return;
        const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
        const body = method_data.body;
        if (body == .none) return;
        const body_data = ctx.nodeData(body);
        const body_range = ast.SubRange{ .start = @intFromEnum(body_data.lhs), .end = @intFromEnum(body_data.rhs) };
        if (ctx.extraSlice(body_range).len == 0) return;
        if (!containsYieldInBlock(body, ctx)) {
            ctx.report(node, meta.name, "Generator function does not contain a yield expression", meta.default_severity);
        }
        return;
    }

    const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));

    const body = fn_data.body;
    if (body == .none) return;

    // Empty body is valid (no yield needed)
    const body_data = ctx.nodeData(body);
    const body_range = ast.SubRange{ .start = @intFromEnum(body_data.lhs), .end = @intFromEnum(body_data.rhs) };
    if (ctx.extraSlice(body_range).len == 0) return;

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
    if (@intFromEnum(node) >= ctx.nodeCount()) return false;

    const tag = ctx.nodeTag(node);

    // Direct yield.
    if (tag == .yield_expr or tag == .yield_delegate) return true;

    // Don't recurse into nested functions or class bodies (their lhs/rhs
    // are extra-data indices, not child node indices — misinterpretation
    // causes OOB access in ReleaseFast).
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .class_decl, .class_expr, .export_default_class,
        => return false,
        else => {},
    }

    const data = ctx.nodeData(node);

    // Only recurse into nodes where we KNOW lhs/rhs are child NodeIndices.
    // Many node types use lhs/rhs as extra-data indices — treating those as
    // NodeIndices causes OOB access.
    switch (tag) {
        .expression_stmt => return stmtContainsYield(data.lhs, ctx),
        .block_stmt => return containsYieldInBlock(node, ctx),
        .return_stmt, .throw_stmt => {
            if (data.lhs != .none and stmtContainsYield(data.lhs, ctx)) return true;
        },
        .if_stmt => {
            if (data.rhs != .none and stmtContainsYield(data.rhs, ctx)) return true;
        },
        .if_else_stmt => {
            if (data.lhs != .none and stmtContainsYield(data.lhs, ctx)) return true;
            if (data.rhs != .none and stmtContainsYield(data.rhs, ctx)) return true;
        },
        else => {},
    }

    return false;
}
