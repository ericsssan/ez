// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: guard-for-in
// Source rule: tests/conformance/eslint/lib/rules/guard-for-in.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "guard-for-in",
    .category = .style,
    .default_severity = .warning,
    .description = "Require `for-in` loops to include an `if` statement",
};

pub const relevant_tags = [_]Node.Tag{.for_in_stmt};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    wrap,
};

fn conditionalChild(c: *const LintContext, n: NodeIndex, which: enum { consequent, alternate }) NodeIndex {
    const d = c.nodeData(n);
    if (d.rhs == .none) return .none;
    const tag = c.nodeTag(n);
    // if_stmt: rhs = consequent directly (no alternate); if_else_stmt: rhs = IfData index
    if (tag == .if_stmt) return if (which == .consequent) d.rhs else .none;
    const idx = @intFromEnum(d.rhs);
    if (tag == .if_else_stmt) {
        const e = c.extraData(ast.IfData, idx);
        return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
    }
    const e = c.extraData(ast.Conditional, idx);
    return switch (which) { .consequent => e.consequent, .alternate => e.alternate };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeTag(ctx.nodeBodyBlock(node)) == .empty_stmt)) {
        return;
    }
    if (blk: { const __t = ctx.nodeTag(ctx.nodeBodyBlock(node)); break :blk (__t == .if_stmt or __t == .if_else_stmt); }) {
        return;
    }
    if (((ctx.nodeTag(ctx.nodeBodyBlock(node)) == .block_stmt) and (ctx.nodeBodyStmtCount(ctx.nodeBodyBlock(node)) == 0))) {
        return;
    }
    if ((((ctx.nodeTag(ctx.nodeBodyBlock(node)) == .block_stmt) and (ctx.nodeBodyStmtCount(ctx.nodeBodyBlock(node)) == 1)) and blk: { const __t = ctx.nodeTag(ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0)); break :blk (__t == .if_stmt or __t == .if_else_stmt); })) {
        return;
    }
    if ((((ctx.nodeTag(ctx.nodeBodyBlock(node)) == .block_stmt) and (ctx.nodeBodyStmtCount(ctx.nodeBodyBlock(node)) >= 1)) and blk: { const __t = ctx.nodeTag(ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0)); break :blk (__t == .if_stmt or __t == .if_else_stmt); })) {
        if (blk: { const __t = ctx.nodeTag(ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0), .consequent))); break :blk (__t == .continue_stmt or __t == .continue_label); }) {
            return;
        }
        if ((((ctx.nodeTag(ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0), .consequent))) == .block_stmt) and (ctx.nodeBodyStmtCount(ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0), .consequent))) == 1)) and blk: { const __t = ctx.nodeTag(ctx.nodeBodyStmtAt(ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.nodeBodyStmtAt(ctx.nodeBodyBlock(node), 0), .consequent)), 0)); break :blk (__t == .continue_stmt or __t == .continue_label); })) {
            return;
        }
    }
    ctx.reportWithMessageId(node, "wrap");
}
