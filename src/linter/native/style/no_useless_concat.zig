// Rule: no-useless-concat
// Reports `BinaryExpression(+)` where the concatenation's leftmost-final and
// rightmost-initial operands are both string literals on the same line.
// Mirrors: tests/conformance/eslint/lib/rules/no-useless-concat.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-concat",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary concatenation of literals or template literals",
};

pub const relevant_tags = [_]Node.Tag{.add};

pub const needs_semantic = false;

fn isStringLikeLiteral(ctx: *const LintContext, n: NodeIndex) bool {
    const t = ctx.ast.nodeTag(n);
    return t == .string_literal or t == .template_literal;
}

fn stripGrouping(ctx: *const LintContext, n: NodeIndex) NodeIndex {
    var cur = n;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

/// Walk right-children of `+` chains starting from `left` to find the
/// rightmost-final string-side operand.  Strips grouping wrappers (our
/// parser keeps them; ESLint doesn't, so we mirror that behaviour).
fn rightmostOfLeftChain(ctx: *const LintContext, start: NodeIndex) NodeIndex {
    var cur = stripGrouping(ctx, start);
    while (cur != .none and ctx.ast.nodeTag(cur) == .add) {
        cur = stripGrouping(ctx, ctx.ast.nodeData(cur).rhs);
    }
    return cur;
}

/// Walk left-children of `+` chains starting from `right` to find the
/// leftmost-initial string-side operand.
fn leftmostOfRightChain(ctx: *const LintContext, start: NodeIndex) NodeIndex {
    var cur = stripGrouping(ctx, start);
    while (cur != .none and ctx.ast.nodeTag(cur) == .add) {
        cur = stripGrouping(ctx, ctx.ast.nodeData(cur).lhs);
    }
    return cur;
}

/// Find the byte offset of the `+` operator between `a_end` and `b_start`,
/// skipping whitespace, line comments, and block comments.
fn findPlusBetween(src: []const u8, a_end: u32, b_start: u32) ?u32 {
    var i: usize = a_end;
    while (i < b_start) {
        const c = src[i];
        if (c == ' ' or c == '\t' or c == '\n' or c == '\r') {
            i += 1;
            continue;
        }
        if (i + 1 < b_start and c == '/' and src[i + 1] == '/') {
            i += 2;
            while (i < b_start and src[i] != '\n') i += 1;
            continue;
        }
        if (i + 1 < b_start and c == '/' and src[i + 1] == '*') {
            i += 2;
            while (i + 1 < b_start) : (i += 1) {
                if (src[i] == '*' and src[i + 1] == '/') {
                    i += 2;
                    break;
                }
            } else i = b_start;
            continue;
        }
        if (c == '+') return @intCast(i);
        return null;
    }
    return null;
}

/// True when both spans land on the same source line.
fn sameLine(src: []const u8, a_end: u32, b_start: u32) bool {
    var i: usize = a_end;
    while (i < b_start) : (i += 1) {
        if (src[i] == '\n') return false;
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.ast.nodeTag(node) != .add) return;
    const d = ctx.ast.nodeData(node);
    const left = rightmostOfLeftChain(ctx, d.lhs);
    const right = leftmostOfRightChain(ctx, d.rhs);
    if (!isStringLikeLiteral(ctx, left) or !isStringLikeLiteral(ctx, right)) return;
    // Use the inner-string spans for the same-line check, but the operator
    // search runs in the gap between the OUTER operands (d.lhs and d.rhs),
    // since grouping parens may sit between the strings and the `+`.
    const left_span = ctx.nodeSpan(left);
    const right_span = ctx.nodeSpan(right);
    if (!sameLine(ctx.ast.source, left_span.end, right_span.start)) return;
    const outer_left_span = ctx.nodeSpan(d.lhs);
    const outer_right_span = ctx.nodeSpan(d.rhs);
    const plus_pos = findPlusBetween(ctx.ast.source, outer_left_span.end, outer_right_span.start) orelse return;
    ctx.reportSpanWithMessageId(.{ .start = plus_pos, .end = plus_pos + 1 }, "unexpectedConcat");
}
