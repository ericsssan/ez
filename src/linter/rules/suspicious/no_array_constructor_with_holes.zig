const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-new-array",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow Array constructor with a single numeric argument (creates holey array)",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "Array")) return;

    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);

    // new Array(n) with exactly one numeric arg creates holey array
    if (args.len == 1) {
        const arg: NodeIndex = @enumFromInt(args[0]);
        if (arg != .none and ctx.nodeTag(arg) == .number_literal) {
            ctx.report(node, meta.name, "Use Array.from() or array literals instead of new Array(n)", meta.default_severity);
        }
    }
}
