const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.ts_as_expr};

pub const meta = RuleMeta{
    .name = "prefer-as-const",
    .category = .style,
    .default_severity = .warning,
    .description = "Prefer `as const` over literal type assertions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // lhs = expression, rhs = type node
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    const lhs_tag = ctx.nodeTag(lhs);
    const rhs_tag = ctx.nodeTag(rhs);

    // Only flag when lhs is a literal and rhs is a type reference (not `as const`)
    const is_literal = lhs_tag == .string_literal or lhs_tag == .number_literal or lhs_tag == .boolean_literal;
    if (!is_literal) return;
    if (rhs_tag != .ts_type_reference) return;

    // Check that the type reference is not already "const"
    const rhs_text = ctx.tokenText(ctx.nodeMainToken(rhs));
    if (std.mem.eql(u8, rhs_text, "const")) return;

    // Check if the type reference text matches the literal value
    const lhs_text = ctx.tokenText(ctx.nodeMainToken(lhs));
    if (std.mem.eql(u8, lhs_text, rhs_text)) {
        ctx.report(node);
    }
}
