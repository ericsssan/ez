const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow loops with a body that allows only one iteration",
};

pub const needs_semantic = true;

pub const relevant_tags = [_]Node.Tag{
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
    .for_await_of_stmt,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Use the Zig semantic analyzer's precomputed loop_exit_reachable.
    // body_alive = false means the loop body always exits on every path
    // (all paths return/throw, nested infinite loops, switch with all cases returning).
    // body_alive = true means the body CAN complete and loop back for another iteration.
    if (!ctx.loopBodyCanIterate(node)) {
        ctx.report(node);
    }
}
