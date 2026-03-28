const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-sparse-arrays",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow sparse arrays",
};

pub const relevant_tags = [_]Node.Tag{.array_literal};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range = SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const items = ctx.extraSlice(range);
    for (items) |raw| {
        const elem: NodeIndex = @enumFromInt(raw);
        if (elem == .none) {
            ctx.report(node, meta.name, "Unexpected comma in array literal creates a sparse array", meta.default_severity);
            return;
        }
    }
}
