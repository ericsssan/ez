const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-optional-chain",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce using concise optional chain expressions instead of chained logical ands",
};

pub const relevant_tags = [_]Node.Tag{.logical_and};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    // Pattern: `a && a.b` or `a && a.b.c`
    // The LHS must be an identifier or member expression
    // The RHS must be a member access on LHS
    const lhs_tag = ctx.nodeTag(lhs);
    if (lhs_tag != .identifier and lhs_tag != .member_expr and lhs_tag != .computed_member_expr) return;

    const rhs_tag = ctx.nodeTag(rhs);
    if (rhs_tag != .member_expr and rhs_tag != .computed_member_expr and rhs_tag != .call_expr) return;

    // Get the root object of the RHS access chain
    const rhs_root = getMemberRoot(rhs, ctx);
    if (rhs_root == .none) return;
    if (ctx.nodeTag(rhs_root) != .identifier) return;

    // Get the root of the LHS
    const lhs_root = getMemberRoot(lhs, ctx);
    if (lhs_root == .none) return;
    if (ctx.nodeTag(lhs_root) != .identifier) return;

    // Check if both start with the same identifier
    const lhs_name = ctx.tokenText(ctx.nodeMainToken(lhs_root));
    const rhs_name = ctx.tokenText(ctx.nodeMainToken(rhs_root));

    if (!strEql(lhs_name, rhs_name)) return;

    ctx.report(node, meta.name, "Prefer optional chain `?.` over `&&` for nullish checks", meta.default_severity);
}

fn getMemberRoot(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = node;
    while (true) {
        if (cur == .none) return .none;
        if (@intFromEnum(cur) >= ctx.ast.nodes.len) return .none;
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .identifier => return cur,
            .member_expr, .computed_member_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            .call_expr => {
                cur = ctx.nodeData(cur).lhs;
            },
            else => return .none,
        }
    }
}

fn strEql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    for (a, b) |ca, cb| {
        if (ca != cb) return false;
    }
    return true;
}
