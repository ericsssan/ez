// Rule: arrow-parens
// Require parens around a single arrow-function parameter ("always") or forbid
// them where they're not needed ("as-needed", optionally requiring them when
// the body is a block via { requireForBlockBody: true }).
// Mirrors: tests/conformance/eslint/lib/rules/arrow-parens.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const TokenIndex = u32;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "arrow-parens",
    .category = .style,
    .default_severity = .warning,
    .description = "Require parentheses around arrow function arguments",
};

pub const relevant_tags = [_]Node.Tag{ .arrow_fn, .async_arrow_fn };

pub const needs_semantic = false;

/// First token index of a node (smallest token whose start >= span.start).
fn firstTokenOf(ctx: *const LintContext, n: NodeIndex) TokenIndex {
    const span = ctx.nodeSpan(n);
    const starts = ctx.ast.tokens.items(.start);
    var lo: usize = 0;
    var hi: usize = starts.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        if (starts[mid] < span.start) lo = mid + 1 else hi = mid;
    }
    return @intCast(lo);
}

/// True when `getOptions2().requireForBlockBody === true`.
fn requireForBlockBodyOpt(ctx: *const LintContext) bool {
    const opts2 = ctx.getOptions2() orelse return false;
    if (opts2.* != .object) return false;
    const v = opts2.object.get("requireForBlockBody") orelse return false;
    return v == .bool and v.bool;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    const is_async = tag == .async_arrow_fn;

    const arrow = ctx.ast.extraData(ast.ArrowData, @intFromEnum(ctx.ast.nodeData(node).lhs));
    const params = ctx.ast.extraSlice(.{ .start = arrow.params_start, .end = arrow.params_end });
    if (params.len != 1) return;
    const param: NodeIndex = @enumFromInt(params[0]);
    if (param == .none) return;

    const block_body = ctx.ast.nodeTag(arrow.body) == .block_stmt;
    const as_needed = ctx.optionEqualsString("as-needed");
    const require_block = as_needed and requireForBlockBodyOpt(ctx);
    const should_have_parens = !as_needed or (require_block and block_body);

    // findOpeningParenOfParams: token before params[0] is `(`, within the arrow.
    const param_first = firstTokenOf(ctx, param);
    var has_parens = false;
    var opening_paren: TokenIndex = 0;
    if (param_first > 0) {
        const before = param_first - 1;
        if (ctx.tokenTag(before) == .l_paren and ctx.tokenStart(before) >= ctx.nodeSpan(node).start) {
            has_parens = true;
            opening_paren = before;
        }
    }

    // Report location is the parameter itself.
    const pmt = ctx.nodeMainToken(param);
    const param_span = Span{ .start = ctx.tokenStart(pmt), .end = ctx.tokenEnd(pmt) };

    if (should_have_parens and !has_parens) {
        ctx.reportSpanWithMessageId(param_span, if (require_block) "expectedParensBlock" else "expectedParens");
        return;
    }

    if (!should_have_parens and has_parens) {
        // Only strip parens around a plain identifier with no type annotation,
        // no arrow return type, no comments inside the parens, and no tokens
        // before the opening paren (e.g. TS type params `<T>(a) => b`).
        if (ctx.ast.nodeTag(param) != .identifier) return;
        if (ctx.ast.nodeData(param).rhs != .none) return; // typeAnnotation
        if (arrow.return_type != .none) return;

        // hasCommentsInParensOfParams: comments anywhere inside the parens.
        const close_paren = closeParenOf(ctx, param);
        if (close_paren != 0) {
            if (ctx.rangeContainsComment(ctx.tokenStart(opening_paren), ctx.tokenEnd(close_paren))) return;
        }

        // hasUnexpectedTokensBeforeOpeningParen: first token (skipping `async`)
        // must be the opening paren.
        const expected_count: TokenIndex = if (is_async) 1 else 0;
        const first_tok = firstTokenOf(ctx, node);
        if (first_tok + expected_count != opening_paren) return;

        ctx.reportSpanWithMessageId(param_span, if (require_block) "unexpectedParensInline" else "unexpectedParens");
    }
}

/// Closing paren token of a single parenthesized param: the first `)` after
/// the param's last token.
fn closeParenOf(ctx: *const LintContext, param: NodeIndex) TokenIndex {
    const last = ctx.nodeLastToken(param);
    const count: TokenIndex = @intCast(ctx.ast.tokens.items(.start).len);
    var i: TokenIndex = last + 1;
    while (i < count) : (i += 1) {
        if (ctx.tokenTag(i) == .r_paren) return i;
    }
    return 0;
}
