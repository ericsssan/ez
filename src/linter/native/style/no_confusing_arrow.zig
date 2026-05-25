// Rule: no-confusing-arrow
// Reports arrow functions whose body is a ConditionalExpression — the `=>`
// can be confused with a `<=`/`>=` comparison.
// Mirrors: tests/conformance/eslint/lib/rules/no-confusing-arrow.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-confusing-arrow",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow arrow functions where they could be confused with comparisons",
};

pub const relevant_tags = [_]Node.Tag{ .arrow_fn, .async_arrow_fn };

pub const needs_semantic = false;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    if (tag != .arrow_fn and tag != .async_arrow_fn) return;
    const d = ctx.ast.nodeData(node);
    if (d.lhs == .none) return;
    const arrow = ctx.ast.extraData(ast.ArrowData, @intFromEnum(d.lhs));
    const body = arrow.body;
    if (body == .none) return;

    // Options
    var allow_parens = true; // default
    var only_one_simple_param = false;
    if (ctx.rule_options) |v| {
        if (v.* == .object) {
            if (v.object.get("allowParens")) |x| if (x == .bool) { allow_parens = x.bool; };
            if (v.object.get("onlyOneSimpleParam")) |x| if (x == .bool) { only_one_simple_param = x.bool; };
        }
    }

    // Body must be a conditional expression (or grouping around one when
    // allowParens=false).  When allowParens=true and body is wrapped in
    // grouping, we skip the report.
    var body_inner = body;
    var is_parenthesised = false;
    if (ctx.ast.nodeTag(body_inner) == .grouping_expr) {
        is_parenthesised = true;
        body_inner = ctx.ast.nodeData(body_inner).lhs;
    }
    if (body_inner == .none or ctx.ast.nodeTag(body_inner) != .conditional) return;

    if (allow_parens and is_parenthesised) return;

    if (only_one_simple_param) {
        const params = ctx.ast.extraSlice(.{ .start = arrow.params_start, .end = arrow.params_end });
        if (params.len != 1) return;
        const p0: NodeIndex = @enumFromInt(params[0]);
        if (ctx.ast.nodeTag(p0) != .identifier) return;
    }

    ctx.reportWithMessageId(node, "confusing");
}
