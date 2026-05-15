// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-nested-ternary

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-nested-ternary",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow nested ternary expressions",
};

pub const relevant_tags = [_]Node.Tag{.conditional};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noNestedTernary,
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
    if (((ctx.nodeTag(conditionalChild(ctx, node, .alternate)) == .conditional) or (ctx.nodeTag(conditionalChild(ctx, node, .consequent)) == .conditional))) {
        ctx.reportWithMessageId(node, "noNestedTernary");
    }
}
