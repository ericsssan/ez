const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

pub const meta = RuleMeta{
    .name = "no-explicit-any",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow the `any` type",
    .lang = .ts_only,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    if (std.mem.eql(u8, text, "any")) {
        ctx.report(node);
    }
}
