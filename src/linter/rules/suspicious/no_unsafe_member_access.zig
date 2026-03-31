const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-prototype-builtins",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow calling some Object.prototype methods directly on object instances",
};

// NOTE: This rule already exists as correctness/no_prototype_builtins.zig
// This file is not registered.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
