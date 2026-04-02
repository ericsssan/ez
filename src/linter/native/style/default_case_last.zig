const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-case-last",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce default clauses in switch statements to be last",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(sub_range);

    var default_idx: ?usize = null;
    for (cases, 0..) |case_raw, i| {
        if (ctx.nodeTag(@enumFromInt(case_raw)) == .switch_default) {
            default_idx = i;
        }
    }

    if (default_idx) |idx| {
        if (idx != cases.len - 1) {
            ctx.report(
                @enumFromInt(cases[idx]),
                meta.name,
                "Default clause should be last",
                meta.default_severity,
            );
        }
    }
}
