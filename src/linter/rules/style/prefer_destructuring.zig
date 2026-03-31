const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-destructuring",
    .category = .style,
    .default_severity = .warning,
    .description = "Require destructuring from arrays and/or objects",
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;

    if (binding == .none or init == .none) return;

    // `const x = obj.prop` → suggest `const { prop: x } = obj` or `const { x } = obj`
    if (ctx.nodeTag(binding) != .identifier) return;
    if (ctx.nodeTag(init) != .member_expr) return;

    const member_data = ctx.nodeData(init);
    if (member_data.lhs == .none or member_data.rhs == .none) return;

    // Skip computed member access obj[0] — that's index-based
    // member_expr uses rhs as token index, not a node. So it's always a property name.
    const binding_name = ctx.tokenText(ctx.nodeMainToken(binding));
    const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));

    // Only flag when binding name matches the property name: `const foo = obj.foo`
    if (!std.mem.eql(u8, binding_name, prop_name)) return;

    ctx.report(node, meta.name, "Prefer destructuring over member expression assignment", meta.default_severity);
}
