// HAND-WRITTEN.
// Rule: eqeqeq
// Require the use of === and !==

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Span = @import("es_parser").span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "eqeqeq",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Require the use of === and !==.",
};

pub const relevant_tags = [_]Node.Tag{
    .equal,
    .not_equal,
    .strict_equal,
    .strict_not_equal,
};

pub const needs_semantic = false;

// JS typeof-value group: determines areLiteralsAndSameType compatibility.
// null and regex both have typeof === "object" in JS.
fn literalGroup(ctx: *const LintContext, node: NodeIndex) u8 {
    return switch (ctx.nodeTag(node)) {
        .string_literal => 1,
        .number_literal => 2,
        .boolean_literal => 3,
        .null_literal, .regex_literal => 4,
        .bigint_literal => 5,
        else => 0,
    };
}

fn isNullLiteral(ctx: *const LintContext, node: NodeIndex) bool {
    return ctx.nodeTag(node) == .null_literal;
}

fn isTypeof(ctx: *const LintContext, node: NodeIndex) bool {
    return ctx.nodeTag(ctx.nodeSkipGrouping(node)) == .typeof_expr;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    const lhs_raw = d.lhs;
    const rhs_raw = d.rhs;
    const lhs = ctx.nodeSkipGrouping(lhs_raw);
    const rhs = ctx.nodeSkipGrouping(rhs_raw);

    // Read options
    // options[0]: "always" (default) | "smart" | "allow-null"
    const is_smart = ctx.optionEqualsString("smart");
    const is_allow_null = ctx.optionEqualsString("allow-null");

    // options[1]: { null: "always" | "never" | "ignore" }
    // Only meaningful in "always" mode. Default null option for "always" is "always".
    const null_option: ?[]const u8 = blk: {
        const opts2 = ctx.getOptions2() orelse break :blk null;
        if (opts2.* != .object) break :blk null;
        const v = opts2.object.get("null") orelse break :blk null;
        if (v != .string) break :blk null;
        break :blk v.string;
    };

    // For "always" mode: whether to enforce strict for null comparisons
    const null_opt_str = null_option orelse "always";
    const enforce_inverse_for_null = !is_smart and !is_allow_null and
        std.mem.eql(u8, null_opt_str, "never");
    const ignore_null = is_smart or is_allow_null or
        std.mem.eql(u8, null_opt_str, "ignore");

    const tag = ctx.nodeTag(node);
    const is_strict = (tag == .strict_equal or tag == .strict_not_equal);

    const is_null_check = isNullLiteral(ctx, lhs) or isNullLiteral(ctx, rhs);
    const is_typeof_binary = isTypeof(ctx, lhs_raw) or isTypeof(ctx, rhs_raw);

    const lhs_group = literalGroup(ctx, lhs);
    const rhs_group = literalGroup(ctx, rhs);
    const same_literal_type = (lhs_group != 0 and lhs_group == rhs_group);

    if (is_strict) {
        // === and !==: only flag when null:"never" and it's a null comparison
        if (enforce_inverse_for_null and is_null_check) {
            const op_tok = ctx.nodeMainToken(node);
            const op_span = Span{ .start = ctx.ast.tokenStart(op_tok), .end = ctx.tokenEnd(op_tok) };
            const fix_text: []const u8 = if (tag == .strict_equal) "==" else "!=";
            ctx.reportSpanWithFixAndMessageId(op_span, op_span, fix_text, "unexpected");
        }
        return;
    }

    // == and !=:
    // smart mode: exempt typeof, same-type literals, null comparisons
    if (is_smart) {
        if (is_typeof_binary or same_literal_type or is_null_check) return;
        // Flag (no fix in smart mode for non-typeof/non-literal violations)
        const op_tok = ctx.nodeMainToken(node);
        const op_span = Span{ .start = ctx.ast.tokenStart(op_tok), .end = ctx.tokenEnd(op_tok) };
        ctx.reportSpanWithMessageId(op_span, "unexpected");
        return;
    }

    // allow-null mode: exempt null comparisons, flag everything else
    if (is_allow_null) {
        if (is_null_check) return;
        const op_tok = ctx.nodeMainToken(node);
        const op_span = Span{ .start = ctx.ast.tokenStart(op_tok), .end = ctx.tokenEnd(op_tok) };
        if (is_typeof_binary or same_literal_type) {
            const fix_text = if (tag == .equal) "===" else "!==";
            ctx.reportSpanWithFixAndMessageId(op_span, op_span, fix_text, "unexpected");
        } else {
            ctx.reportSpanWithMessageId(op_span, "unexpected");
        }
        return;
    }

    // always mode (default):
    // skip null comparison if null option is "ignore" or "never"
    if (is_null_check and (ignore_null or enforce_inverse_for_null)) return;
    // For "never": null comparisons are already handled above (or skipped)

    const op_tok = ctx.nodeMainToken(node);
    const op_span = Span{ .start = ctx.ast.tokenStart(op_tok), .end = ctx.tokenEnd(op_tok) };
    const fix_text = if (tag == .equal) "===" else "!==";

    if (is_typeof_binary or same_literal_type) {
        ctx.reportSpanWithFixAndMessageId(op_span, op_span, fix_text, "unexpected");
    } else {
        ctx.reportSpanWithMessageId(op_span, "unexpected");
    }
}
