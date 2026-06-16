// Rule: new-parens
// Enforce or disallow parentheses when invoking a constructor with no arguments.
// Mirrors: tests/conformance/eslint/lib/rules/new-parens.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "new-parens",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce or disallow parentheses when invoking a constructor with no arguments",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

pub const needs_semantic = false;

fn argCount(ctx: *const LintContext, node: NodeIndex) usize {
    const d = ctx.ast.nodeData(node);
    if (d.rhs == .none) return 0;
    const sr = ctx.ast.extraData(ast.SubRange, @intFromEnum(d.rhs));
    return ctx.ast.extraSlice(sr).len;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (argCount(ctx, node) != 0) return;

    // `hasParens` is true only when the new expression ends with its OWN `()`:
    // the last token is `)`, the token before it is `(`, and the callee ends
    // before the node does (so the parens aren't a nested-new's or a grouping).
    const last = ctx.nodeLastToken(node);
    var has_parens = false;
    if (ctx.tokenTag(last) == .r_paren and last > 0 and ctx.tokenTag(last - 1) == .l_paren) {
        const callee = ctx.ast.nodeData(node).lhs;
        if (callee != .none and ctx.nodeSpan(callee).end < ctx.nodeSpan(node).end) {
            has_parens = true;
        }
    }

    const always = !ctx.optionEqualsString("never");
    const node_span = ctx.nodeSpan(node);

    if (always) {
        if (!has_parens) {
            ctx.reportSpanWithMessageId(node_span, "missing");
        }
    } else {
        if (has_parens) {
            ctx.reportSpanWithMessageId(node_span, "unnecessary");
        }
    }
}
