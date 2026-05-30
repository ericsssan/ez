// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-asserted-optional-chain
//
// Reports `<optional-chain>!` — applying `!` to the result of an
// optional chain re-introduces the very `null`/`undefined` the chain
// was protecting against.

const std = @import("std");
const parser = @import("es_parser");
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
    // The `!` must be the END of the chain — when its parent extends
    // the access (member/computed/call), `foo?.bar!.baz` style, the
    // outer access on the asserted result is unrelated to the chain.
    const parent = ctx.parentOf(node);
    if (parent != .none) {
        const pt = ctx.nodeTag(parent);
        switch (pt) {
            .member_expr, .computed_member_expr, .call_expr,
            .optional_member_expr, .optional_computed_member_expr, .optional_call_expr,
            => return,
            else => {},
        }
    }
    ctx.reportWithMessageId(node, "noNonNullOptionalChain");
}

/// Walk the expression rightward through member access / calls, looking
/// for an `?.` link.  `foo?.bar.baz` and `foo.bar?.()` both qualify
/// because the entire result is the optional-chain.
fn isOptionalChain(n: NodeIndex, ctx: *const LintContext) bool {
    // Walk left-leaning through member/call access only — grouping
    // terminates the chain in TS semantics (`(foo?.bar).baz!` is not
    // a chained access).
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
            else => return false,
        }
    }
}
