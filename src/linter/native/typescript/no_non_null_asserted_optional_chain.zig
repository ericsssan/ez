// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-asserted-optional-chain
//
// Reports `<optional-chain>!` — applying `!` to the result of an
// optional chain re-introduces the very `null`/`undefined` the chain
// was protecting against.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-optional-chain",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions after an optional chain expression",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const inner = ctx.nodeData(node).lhs;
    if (inner == .none) return;
    if (!isOptionalChain(inner, ctx)) return;
    ctx.reportWithMessageId(node, "noNonNullOptionalChain");
}

/// Walk the expression rightward through member access / calls, looking
/// for an `?.` link.  `foo?.bar.baz` and `foo.bar?.()` both qualify
/// because the entire result is the optional-chain.
fn isOptionalChain(n: NodeIndex, ctx: *const LintContext) bool {
    var cur = n;
    while (true) {
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .optional_member_expr,
            .optional_computed_member_expr,
            .optional_call_expr,
            => return true,
            .member_expr, .computed_member_expr, .call_expr => {
                cur = ctx.nodeData(cur).lhs;
                if (cur == .none) return false;
            },
            .grouping_expr => cur = ctx.nodeData(cur).lhs,
            else => return false,
        }
    }
}
