const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "func-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the consistent use of either function declarations or expressions",
};

// Flag function expressions used as variable initializers (prefer declarations)
pub const relevant_tags = [_]Node.Tag{ .fn_expr, .async_fn_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // fn_expr is flagged when used as a declarator initializer at top level
    // We check the parent context: if the function has a name (named fn expression
    // used as a const x = function foo(){}) it should be a declaration.
    // Simple check: named fn_expr should be fn_decl instead.
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;

    const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    // Only flag named function expressions (anonymous are fine in many contexts)
    if (fn_data.name == .none) return;

    ctx.report(node, meta.name, "Expected a function declaration instead of a function expression", meta.default_severity);
}
