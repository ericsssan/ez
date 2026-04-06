const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .if_stmt, .if_else_stmt };

pub const meta = RuleMeta{
    .name = "no-else-return",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `else` blocks after `return` in `if` statements",
};

/// Check if `node` is a simple return/throw (naiveHasReturn).
fn naiveHasReturn(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .return_stmt or tag == .throw_stmt) return true;
    if (tag == .block_stmt) {
        const data = ctx.nodeData(node);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        const stmts = ctx.extraSlice(range);
        if (stmts.len == 0) return false;
        const last: NodeIndex = @enumFromInt(stmts[stmts.len - 1]);
        const last_tag = ctx.nodeTag(last);
        return last_tag == .return_stmt or last_tag == .throw_stmt;
    }
    return false;
}

/// Check if `node` is an if_else_stmt where both branches naiveHasReturn.
fn checkForIf(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .if_else_stmt) return false;
    const data = ctx.nodeData(node);
    const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
    return naiveHasReturn(if_data.consequent, ctx) and naiveHasReturn(if_data.alternate, ctx);
}

/// Check if `node` (a consequent branch) always returns.
/// For a block: any statement is a return/throw or an always-returning if-else.
/// For a bare statement: is a return/throw, or is an always-returning if-else.
fn alwaysReturns(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    if (tag == .return_stmt or tag == .throw_stmt) return true;
    if (tag == .block_stmt) {
        const data = ctx.nodeData(node);
        const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
        for (ctx.extraSlice(range)) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            const stag = ctx.nodeTag(stmt);
            if (stag == .return_stmt or stag == .throw_stmt) return true;
            if (checkForIf(stmt, ctx)) return true;
        }
        return false;
    }
    return checkForIf(node, ctx);
}

/// Check if `node` (if_stmt or if_else_stmt) is in a "statement list" position.
/// i.e., its parent is root/block_stmt/switch_case/switch_default.
/// Also check that this node is NOT the alternate of another if statement
/// (to avoid double-reporting in else-if chains).
fn isTopLevelIfInStatementList(node: NodeIndex, ctx: *const LintContext) bool {
    const node_int = @intFromEnum(node);
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = ctx.nodeTag(ni);
        const data = ctx.nodeData(ni);

        switch (tag) {
            // Statement list parents: root, block_stmt (direct SubRange)
            .root, .block_stmt, .static_block => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                for (ctx.extraSlice(range)) |raw| {
                    if (raw == node_int) return true;
                }
            },
            // switch_case, switch_default: rhs = extra SubRange
            .switch_case, .switch_default => {
                if (data.rhs == .none) continue;
                const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(range)) |raw| {
                    if (raw == node_int) return true;
                }
            },
            // If this node is the alternate of another if statement: NOT top-level
            .if_else_stmt => {
                const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
                if (@intFromEnum(if_data.alternate) == node_int) return false;
            },
            else => {},
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only process if_else_stmt (if_stmt with else clause)
    if (ctx.nodeTag(node) != .if_else_stmt) return;

    // Only process if this is the top of an if-else chain in a statement list
    if (!isTopLevelIfInStatementList(node, ctx)) return;

    // Walk the else-if chain: collect all consequents until we reach a non-if alternate
    var current = node;
    while (true) {
        if (ctx.nodeTag(current) != .if_else_stmt) break;

        const data = ctx.nodeData(current);
        const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
        const alternate = if_data.alternate;

        // If the alternate is itself an if statement, continue the chain
        const alt_tag = ctx.nodeTag(alternate);
        if (alt_tag == .if_stmt or alt_tag == .if_else_stmt) {
            // Check if current consequent always returns; if not, the chain isn't clean
            if (!alwaysReturns(if_data.consequent, ctx)) return;
            current = alternate;
        } else {
            // This is the final else block
            if (alwaysReturns(if_data.consequent, ctx)) {
                ctx.report(alternate, meta.name, "Unnecessary 'else' after 'return'", meta.default_severity);
            }
            return;
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
