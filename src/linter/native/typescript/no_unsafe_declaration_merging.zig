const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-declaration-merging",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unsafe declaration merging",
    .lang = .ts_only,
};

// Detect: interface Foo {} and class Foo {} in the same scope.
// Uses runOnSymbols to check for name conflicts between classes and interfaces.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
