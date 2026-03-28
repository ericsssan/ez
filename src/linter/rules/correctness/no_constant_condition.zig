const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constant-condition",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow constant expressions in conditions",
};

pub const relevant_tags = [_]Node.Tag{ .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt };

fn isConstantExpr(tag: Node.Tag) bool {
    return switch (tag) {
        .boolean_literal,
        .number_literal,
        .string_literal,
        .null_literal,
        .array_literal,
        .object_literal,
        // Assignments in conditions always evaluate to the RHS value
        .assign,
        => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // For do-while, the condition is in rhs; for others it's in lhs
    const condition = if (tag == .do_while_stmt) data.rhs else data.lhs;

    if (condition == .none) return;

    const cond_tag = ctx.nodeTag(condition);
    if (isConstantExpr(cond_tag)) {
        ctx.report(node, meta.name, "Unexpected constant condition", meta.default_severity);
    }
}
