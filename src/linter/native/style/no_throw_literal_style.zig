const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-shadow-outer",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow variable declarations that shadow variables in outer scopes",
};

// NOTE: Shadowing analysis is already covered by suspicious/no_shadow.zig
// This file is intentionally empty.
pub const relevant_tags = [_]Node.Tag{};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    _ = ctx;
}
