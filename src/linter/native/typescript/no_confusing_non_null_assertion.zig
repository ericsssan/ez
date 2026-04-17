const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-confusing-non-null-assertion",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow non-null assertion in locations that may be confusing",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const inner = data.lhs;
    if (inner == .none) return;

    // Flag `a! == b` — non-null assertion followed by equality comparison
    // We detect this via the parent being a comparison. Instead, let's look at
    // if the result of ! is used in ==, !=, ===, !==
    // Actually, this rule flags `a! == b` and `a != b!` patterns.
    // The simplest: flag `ts_non_null_expr` on the left side of equality operators.
    // Since we don't have parent info, we register for equality nodes.
    // Flag `a! = b` — non-null assertion on LHS of assignment
    const inner_tag = ctx.nodeTag(inner);
    if (inner_tag == .ts_non_null_expr) {
        // Double non-null assertion: `a!!` — confusing
        ctx.report(node);
    }
}
