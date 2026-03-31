const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "id-length",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce minimum identifier length of 2 characters",
};

pub const relevant_tags = [_]Node.Tag{ .declarator };

// Common single-char names that are exceptions
const allowed_short = [_][]const u8{ "i", "j", "k", "n", "x", "y", "z", "e", "_", "a", "b" };

fn isAllowed(name: []const u8) bool {
    for (allowed_short) |a| {
        if (std.mem.eql(u8, name, a)) return true;
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    if (binding == .none) return;
    if (ctx.nodeTag(binding) != .identifier) return;

    const name = ctx.tokenText(ctx.nodeMainToken(binding));
    if (name.len == 0) return;
    if (name.len >= 2) return; // long enough
    if (isAllowed(name)) return;

    ctx.report(node, meta.name, "Identifier is too short (minimum 2 characters)", meta.default_severity);
}
