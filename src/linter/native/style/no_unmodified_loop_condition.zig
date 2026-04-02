const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unmodified-loop-condition",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unmodified loop conditions",
};

// This is complex to implement properly (requires data flow analysis).
// Skip for now.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
