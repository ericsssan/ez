const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub const meta = RuleMeta{
    .name = "no-async-promise-executor",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow using an async function as a Promise executor",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    // Check if callee is "Promise"
    if (ctx.nodeTag(callee) != .identifier) return;
    const callee_name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, callee_name, "Promise")) return;

    // Check args
    if (data.rhs == .none) return;
    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(sub_range);

    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    const arg_tag = ctx.nodeTag(first_arg);

    if (arg_tag == .async_fn_expr or arg_tag == .async_arrow_fn) {
        ctx.report(node, meta.name, "Promise executor should not be an async function", meta.default_severity);
    }
}

