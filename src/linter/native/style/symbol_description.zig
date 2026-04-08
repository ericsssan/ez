const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "symbol-description",
    .category = .style,
    .default_severity = .warning,
    .description = "Require symbol descriptions",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Symbol")) return;

    // Check there's at least one argument
    if (data.rhs == .none) {
        ctx.report(node, meta.name, "Expected Symbol to have a description.", meta.default_severity);
        return;
    }

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) {
        ctx.report(node, meta.name, "Expected Symbol to have a description.", meta.default_severity);
    }
}
