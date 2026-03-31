const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-this",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent naming when capturing the current execution context",
};

/// The canonical alias for `this`. ESLint default is "that".
const ALLOWED_ALIAS = "that";

pub const relevant_tags = [_]Node.Tag{.declarator};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // rhs must be `this`
    if (data.rhs == .none) return;
    if (ctx.nodeTag(data.rhs) != .this_expr) return;

    // lhs must be an identifier binding
    if (data.lhs == .none) return;
    const lhs_tag = ctx.nodeTag(data.lhs);
    if (lhs_tag != .identifier) return;

    const name_token = ctx.nodeMainToken(data.lhs);
    const name = ctx.tokenText(name_token);

    if (!std.mem.eql(u8, name, ALLOWED_ALIAS)) {
        ctx.report(node, meta.name, "Unexpected alias for 'this'", meta.default_severity);
    }
}
