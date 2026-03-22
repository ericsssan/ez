const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "use-isnan",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Require use of isNaN() when checking for NaN",
};

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal, .strict_equal, .strict_not_equal };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    if (isNaN(data.lhs, ctx) or isNaN(data.rhs, ctx)) {
        ctx.report(
            node,
            meta.name,
            "Use Number.isNaN() instead of comparison with NaN",
            meta.default_severity,
        );
    }
}

fn isNaN(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    if (ctx.nodeTag(idx) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(idx)), "NaN");
}
