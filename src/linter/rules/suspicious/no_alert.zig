const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-alert",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of `alert`, `confirm`, and `prompt`",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

const alert_fns = [_][]const u8{ "alert", "confirm", "prompt" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    for (alert_fns) |fn_name| {
        if (std.mem.eql(u8, name, fn_name)) {
            ctx.report(node, meta.name, "Unexpected alert/confirm/prompt statement", meta.default_severity);
            return;
        }
    }
}
