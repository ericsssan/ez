const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-this-alias",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow aliasing `this`",
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const init = data.rhs;
    if (init == .none) return;

    // Check if init is `this` (possibly wrapped in grouping)
    var expr = init;
    while (ctx.nodeTag(expr) == .grouping_expr) {
        expr = ctx.nodeData(expr).lhs;
        if (expr == .none) return;
    }

    if (ctx.nodeTag(expr) != .this_expr) return;

    // Only flag simple identifier bindings (not destructuring)
    const binding = data.lhs;
    if (binding == .none) return;
    if (ctx.nodeTag(binding) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(binding));
    // Allow `_this` convention? ESLint flags everything except `self` as allowed opt-in.
    // We flag all `this` aliases.
    _ = name;

    ctx.report(node);
}
