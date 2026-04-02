const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-alert",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow the use of alert, confirm, and prompt",
};

// NOTE: This duplicates no_alert.zig — use that file instead.
// This file is not registered and exists only as a placeholder.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
