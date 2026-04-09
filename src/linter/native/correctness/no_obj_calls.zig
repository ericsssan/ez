const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const meta = RuleMeta{
    .name = "no-obj-calls",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow calling global object properties as functions",
};

const non_callable_globals = [_][]const u8{ "Math", "JSON", "Reflect", "Atomics" };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;
    if (ctx.nodeTag(callee) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(callee));

    for (non_callable_globals) |global| {
        if (std.mem.eql(u8, name, global)) {
            ctx.report(node);
            return;
        }
    }
}

