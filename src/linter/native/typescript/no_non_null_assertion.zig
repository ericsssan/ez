// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-assertion
//
// Reports every `<expr>!` non-null assertion.  The rule is opt-in
// and primarily for codebases that want strict null safety.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-assertion",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow non-null assertions using the `!` postfix operator",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_non_null_expr};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Span covers the operand + the `!` operator.
    const inner = ctx.nodeData(node).lhs;
    if (inner == .none) return;
    const inner_sp = ctx.nodeSpan(inner);
    const main_tok = ctx.nodeMainToken(node);
    const bang_start = ctx.ast.tokenStart(main_tok);
    const bang_len = ctx.ast.tokens.items(.len)[main_tok];
    const end: u32 = @intCast(bang_start + bang_len);
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(inner_sp.start),
        .end = end,
    }, "noNonNull");
}
