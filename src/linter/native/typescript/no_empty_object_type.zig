const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-object-type",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of the empty object type `{}`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_type_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const start = @intFromEnum(data.lhs);
    const end = @intFromEnum(data.rhs);
    if (start == end) {
        ctx.report(node);
    }
}
