const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-switch-case",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow useless case clauses in switch statements that fall through to the default",
};

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

/// Returns true if the switch_case node has no statements (falls through).
fn caseIsEmpty(case_node: NodeIndex, ctx: *const LintContext) bool {
    const case_data = ctx.nodeData(case_node);
    // switch_case: rhs = extra index to SubRange of statements
    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(case_data.rhs));
    const stmts = ctx.extraSlice(sub_range);
    return stmts.len == 0;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(sub_range);
    if (cases.len < 2) return;

    for (cases, 0..) |case_raw, i| {
        const case_node: NodeIndex = @enumFromInt(case_raw);
        if (ctx.nodeTag(case_node) != .switch_case) continue;
        if (!caseIsEmpty(case_node, ctx)) continue;

        // Check if the next case is switch_default
        if (i + 1 < cases.len) {
            const next: NodeIndex = @enumFromInt(cases[i + 1]);
            if (ctx.nodeTag(next) == .switch_default) {
                ctx.report(case_node);
            }
        }
    }
}
