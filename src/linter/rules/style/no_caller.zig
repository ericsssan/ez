const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.member_expr};

pub const meta = RuleMeta{
    .name = "no-caller",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow use of `arguments.caller` and `arguments.callee`",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const object = data.lhs;
    if (object == .none) return;
    if (ctx.nodeTag(object) != .identifier) return;
    const obj_name = ctx.tokenText(ctx.nodeMainToken(object));
    if (!std.mem.eql(u8, obj_name, "arguments")) return;
    const prop_name = ctx.tokenText(@intFromEnum(data.rhs));
    if (std.mem.eql(u8, prop_name, "caller") or std.mem.eql(u8, prop_name, "callee")) {
        ctx.report(node, meta.name, "Avoid using arguments.caller or arguments.callee", meta.default_severity);
    }
}
