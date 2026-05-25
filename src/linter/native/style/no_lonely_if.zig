// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-lonely-if
// Source rule: tests/conformance/eslint-plugin-unicorn/rules/no-lonely-if.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-lonely-if",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `if` statements as the only statement in `if` blocks without `else`.",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.if_stmt, .if_else_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    no_lonely_if,
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
    if (!(((blk: { const __t = ctx.nodeTag(node); break :blk (__t == .if_stmt or __t == .if_else_stmt); } and !((ctx.nodeSkipGrouping(conditionalChild(ctx, node, .alternate)) != .none))) and ((((((ctx.nodeTag(ctx.parentOf(node)) == .block_stmt) and (ctx.nodeBodyStmtCount(ctx.parentOf(node)) == 1)) and (ctx.nodeBodyStmtAt(ctx.parentOf(node), 0) == node)) and (blk: { const __t = ctx.nodeTag(ctx.parentOf(ctx.parentOf(node))); break :blk (__t == .if_stmt or __t == .if_else_stmt); } and !((ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.parentOf(ctx.parentOf(node)), .alternate)) != .none)))) and (ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.parentOf(ctx.parentOf(node)), .consequent)) == ctx.parentOf(node))) or ((blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .if_stmt or __t == .if_else_stmt); } and !((ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.parentOf(node), .alternate)) != .none))) and (ctx.nodeSkipGrouping(conditionalChild(ctx, ctx.parentOf(node), .consequent)) == node)))))) {
        return;
    }
    ctx.reportWithMessageId(node, "no-lonely-if");
    return;
}
