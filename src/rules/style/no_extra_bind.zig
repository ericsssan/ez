const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const meta = RuleMeta{
    .name = "no-extra-bind",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary `.bind()` calls on arrow functions",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Check if callee is a member_expr with property "bind"
    if (ctx.nodeTag(callee) != .member_expr) return;

    const member_data = ctx.nodeData(callee);
    const prop_name = ctx.tokenText(@intFromEnum(member_data.rhs));
    if (!std.mem.eql(u8, prop_name, "bind")) return;

    // Check if the object of the member_expr is an arrow function
    const object = member_data.lhs;
    if (object == .none) return;
    const object_tag = ctx.nodeTag(object);
    if (object_tag == .arrow_fn or object_tag == .async_arrow_fn) {
        ctx.report(node, meta.name, "Unnecessary .bind() on arrow function; arrow functions inherit 'this'", meta.default_severity);
    }
}
