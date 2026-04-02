const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "operator-assignment",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow assignment operator shorthand where possible",
};

// Detect `x = x + y` → should be `x += y`
pub const relevant_tags = [_]Node.Tag{.assign};

fn identName(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (node == .none) return null;
    if (ctx.nodeTag(node) != .identifier) return null;
    return ctx.tokenText(ctx.nodeMainToken(node));
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;
    if (lhs == .none or rhs == .none) return;

    // LHS must be a simple identifier
    const lhs_name = identName(lhs, ctx) orelse return;

    // RHS must be a binary expression
    const rhs_tag = ctx.nodeTag(rhs);
    const is_arithmetic = switch (rhs_tag) {
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        => true,
        else => false,
    };
    if (!is_arithmetic) return;

    // The LHS of the binary expression must be the same identifier
    const bin_data = ctx.nodeData(rhs);
    const bin_lhs_name = identName(bin_data.lhs, ctx) orelse return;

    if (!std.mem.eql(u8, lhs_name, bin_lhs_name)) return;

    ctx.report(node, meta.name, "Assignment can be simplified using an assignment operator shorthand", meta.default_severity);
}
