const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "radix",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require a radix argument in `parseInt`",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "parseInt")) return;

    // Check arg count
    if (data.rhs == .none) {
        ctx.report(node, meta.name, "Missing radix argument in parseInt", meta.default_severity);
        return;
    }

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);

    if (args.len < 2) {
        ctx.report(node, meta.name, "Missing radix argument in parseInt", meta.default_severity);
    }
}
