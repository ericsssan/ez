const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.sequence_expr};

pub const meta = RuleMeta{
    .name = "no-sequences",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow comma operators",
};

/// Check if this sequence_expr is the init or update of a for_stmt (always allowed).
fn isForInitOrUpdate(seq: NodeIndex, ctx: *const LintContext) bool {
    const seq_int = @intFromEnum(seq);
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .for_stmt) continue;
        const data = ctx.nodeData(ni);
        const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
        if (@intFromEnum(for_data.init) == seq_int) return true;
        if (@intFromEnum(for_data.update) == seq_int) return true;
    }
    return false;
}

/// Check if this sequence_expr is directly the body of an arrow function
/// (not wrapped in a grouping_expr). Arrow body sequences need double-parens to
/// be allowed; single-paren is not sufficient.
fn isDirectArrowBody(seq: NodeIndex, ctx: *const LintContext) bool {
    const seq_int = @intFromEnum(seq);
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = ctx.nodeTag(ni);
        if (tag != .arrow_fn and tag != .async_arrow_fn) continue;
        const data = ctx.nodeData(ni);
        const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
        if (@intFromEnum(arrow_data.body) == seq_int) return true;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // For statement init/update: always allowed
    if (isForInitOrUpdate(node, ctx)) return;

    // Check if wrapped in parentheses (main token is '(')
    const main_tok = ctx.nodeMainToken(node);
    const in_parens = ctx.tokenTag(main_tok) == .l_paren;

    if (in_parens) {
        // Arrow function body requires double-parens; single-paren still flagged
        if (!isDirectArrowBody(node, ctx)) return;
    }

    ctx.report(node, meta.name, "Unexpected use of comma operator", meta.default_severity);
}
