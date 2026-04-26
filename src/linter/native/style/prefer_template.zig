const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.add};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "prefer-template",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest using template literals instead of string concatenation",
};

/// Returns true if `node` evaluates to a string type.
fn isStringLike(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    // String and template literals always evaluate to strings.
    if (tag == .string_literal or tag == .template_literal) return true;
    return false;
}

/// Check if the concatenation chain contains at least one non-string operand.
fn chainHasNonString(node: NodeIndex, ctx: *const LintContext, out_has_string: *bool) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);

    if (tag == .add) {
        const d = ctx.nodeData(node);
        const lhs = chainHasNonString(d.lhs, ctx, out_has_string);
        const rhs = chainHasNonString(d.rhs, ctx, out_has_string);
        return lhs or rhs;
    }

    // Unwrap grouping: ('a' + 'b') is still a string result from string chain.
    if (tag == .grouping_expr) {
        return chainHasNonString(ctx.nodeData(node).lhs, ctx, out_has_string);
    }

    if (isStringLike(node, ctx)) {
        out_has_string.* = true;
        return false;
    }

    // Non-string: variable, expression, etc.
    return true;
}

fn leftmostInChain(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var current = node;
    var depth: u32 = 0;
    while (depth < 64) : (depth += 1) {
        const tag = ctx.nodeTag(current);
        if (tag != .add and tag != .grouping_expr) break;
        const d = ctx.nodeData(current);
        if (d.lhs == .none) break;
        current = d.lhs;
    }
    return current;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only process the TOP-LEVEL add in a string concatenation chain.
    // If parent is also .add, skip (handled by parent).
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .add) return;

    var has_string = false;
    const has_non_string = chainHasNonString(node, ctx, &has_string);

    // Flag only when: there's at least one string AND at least one non-string in the chain.
    if (has_string and has_non_string) {
        // Report the leftmost node of the concatenation chain for correct line number.
        const report_node = leftmostInChain(node, ctx);
        ctx.report(report_node);
    }
}
