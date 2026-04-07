const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .if_else_stmt, .conditional };

pub const meta = RuleMeta{
    .name = "no-negated-condition",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow negated conditions in `if-else` statements",
};

fn isNegated(condition: NodeIndex, ctx: *const LintContext) bool {
    if (condition == .none) return false;
    return switch (ctx.nodeTag(condition)) {
        .logical_not, .not_equal, .strict_not_equal => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    if (tag == .if_else_stmt) {
        const data = ctx.nodeData(node);
        const condition = data.lhs;
        if (!isNegated(condition, ctx)) return;

        // Skip if the alternate is another if (else-if chain)
        const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
        const alt_tag = ctx.nodeTag(if_data.alternate);
        if (alt_tag == .if_stmt or alt_tag == .if_else_stmt) return;

        ctx.report(node, meta.name, "Unexpected negated condition; swap the if/else branches instead", meta.default_severity);
        return;
    }

    if (tag == .conditional) {
        const data = ctx.nodeData(node);
        const condition = data.lhs;
        if (isNegated(condition, ctx)) {
            ctx.report(node, meta.name, "Unexpected negated condition; swap the consequent/alternate instead", meta.default_severity);
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
