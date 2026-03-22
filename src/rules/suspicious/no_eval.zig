const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.call_expr};

pub const meta = RuleMeta{
    .name = "no-eval",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of eval()",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;

    if (callee == .none) return;

    if (ctx.nodeTag(callee) == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(callee));
        if (std.mem.eql(u8, name, "eval")) {
            ctx.report(node, meta.name, "eval() is potentially dangerous and can be exploited", meta.default_severity);
        }
    }
}
