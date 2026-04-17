const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-literal-enum-member",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require all enum members to be literal values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_member};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const init = data.rhs;

    // No initializer — OK (auto-incremented)
    if (init == .none) return;

    const init_tag = ctx.nodeTag(init);
    switch (init_tag) {
        // Allowed literal types
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal, .template_literal,
        => return,
        // Unary minus for negative numbers: -42
        .unary_minus, .unary_plus => {
            // e.g. -1, +1
            const unary_data = ctx.nodeData(init);
            if (unary_data.lhs != .none) {
                const inner = ctx.nodeTag(unary_data.lhs);
                if (inner == .number_literal or inner == .bigint_literal) return;
            }
        },
        else => {},
    }

    ctx.report(node);
}
