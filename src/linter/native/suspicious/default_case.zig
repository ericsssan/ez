const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require a `default` case in switch statements",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // rhs = extra index to SubRange of cases
    if (data.rhs == .none) {
        ctx.report(node, meta.name, "Expected a default case", meta.default_severity);
        return;
    }

    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(range);

    for (cases) |case_idx| {
        const case_node: NodeIndex = @enumFromInt(case_idx);
        if (ctx.nodeTag(case_node) == .switch_default) return;
    }

    ctx.report(node, meta.name, "Expected a default case", meta.default_severity);
}
