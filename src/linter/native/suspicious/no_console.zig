const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-console",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `console`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    // Detect console.* and console?.* patterns
    const callee_tag = ctx.nodeTag(callee);
    if (callee_tag != .member_expr and callee_tag != .optional_member_expr) return;

    const member_data = ctx.nodeData(callee);
    const object = member_data.lhs;
    if (object == .none) return;
    if (ctx.nodeTag(object) != .identifier) return;

    const obj_name = ctx.tokenText(ctx.nodeMainToken(object));
    if (std.mem.eql(u8, obj_name, "console")) {
        ctx.report(node);
    }
}
