const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.ts_as_expr};

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-assertion",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary `as any` type assertions",
    .lang = .ts_only,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // ts_as_expr: lhs = expression, rhs = type node
    const rhs = data.rhs;
    if (rhs == .none) return;

    if (ctx.nodeTag(rhs) == .ts_type_reference) {
        const text = ctx.tokenText(ctx.nodeMainToken(rhs));
        if (std.mem.eql(u8, text, "any")) {
            ctx.report(node);
        }
    }
}
