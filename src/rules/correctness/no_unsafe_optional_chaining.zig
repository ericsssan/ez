const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-optional-chaining",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow use of optional chaining in contexts where the undefined value is not allowed",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .new_expr };

fn isOptionalChain(tag: Node.Tag) bool {
    return switch (tag) {
        .optional_member_expr,
        .optional_computed_member_expr,
        .optional_call_expr,
        => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    const callee_tag = ctx.nodeTag(callee);

    // Direct optional chaining as callee: obj?.foo() used in new expression context
    // or optional chain used directly
    if (isOptionalChain(callee_tag)) {
        const node_tag = ctx.nodeTag(node);
        if (node_tag == .new_expr) {
            ctx.report(node, meta.name, "Unsafe use of optional chaining in 'new' expression; may evaluate to undefined", meta.default_severity);
        }
        return;
    }

    // Grouped optional chaining: (obj?.foo)() or new (obj?.foo)()
    if (callee_tag == .grouping_expr) {
        const inner_data = ctx.nodeData(callee);
        const inner = inner_data.lhs;
        if (inner == .none) return;

        const inner_tag = ctx.nodeTag(inner);
        if (isOptionalChain(inner_tag)) {
            ctx.report(node, meta.name, "Unsafe use of optional chaining in a non-optional context; may evaluate to undefined", meta.default_severity);
        }
    }
}
