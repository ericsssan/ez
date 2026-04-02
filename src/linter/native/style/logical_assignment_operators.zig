const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "logical-assignment-operators",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow logical assignment operator shorthand",
};

pub const relevant_tags = [_]Node.Tag{.assign};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;

    if (lhs == .none or rhs == .none) return;

    const rhs_tag = ctx.nodeTag(rhs);
    // Pattern: `a = a || b`, `a = a && b`, `a = a ?? b`
    switch (rhs_tag) {
        .logical_or, .logical_and, .nullish_coalesce => {
            const inner = ctx.nodeData(rhs);
            const inner_lhs = inner.lhs;
            if (inner_lhs == .none) return;

            // Check if the lhs of assign == lhs of the logical expression
            if (nodesEqualSimple(lhs, inner_lhs, ctx)) {
                const op = switch (rhs_tag) {
                    .logical_or => "||=",
                    .logical_and => "&&=",
                    .nullish_coalesce => "??=",
                    else => unreachable,
                };
                _ = op;
                ctx.report(node, meta.name, "Assignment can be replaced with logical assignment operator", meta.default_severity);
            }
        },
        else => {},
    }
}

/// Simple structural equality check for identifiers only.
fn nodesEqualSimple(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == b) return true;
    if (a == .none or b == .none) return false;

    const ta = ctx.nodeTag(a);
    const tb = ctx.nodeTag(b);
    if (ta != tb) return false;

    if (ta == .identifier) {
        const na = ctx.tokenText(ctx.nodeMainToken(a));
        const nb = ctx.tokenText(ctx.nodeMainToken(b));
        return strEql(na, nb);
    }
    return false;
}

fn strEql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    for (a, b) |ca, cb| if (ca != cb) return false;
    return true;
}
