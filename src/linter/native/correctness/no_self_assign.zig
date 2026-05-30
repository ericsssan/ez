// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-self-assign
// Source rule: tests/conformance/eslint/lib/rules/no-self-assign.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-self-assign",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow assignments where both sides are exactly the same",
};

pub const relevant_tags = [_]Node.Tag{.assign, .logical_and_assign, .logical_or_assign, .nullish_assign};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    selfAssignment,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only consider plain/logical-assign forms — compound math
    // assignments (+=, *=, etc.) aren't "self" assignments.
    switch (ctx.nodeTag(node)) {
        .assign, .logical_and_assign, .logical_or_assign, .nullish_assign => {},
        else => return,
    }
    const left = ctx.nodeSkipGrouping(ctx.nodeData(node).lhs);
    const right = ctx.nodeSkipGrouping(ctx.nodeData(node).rhs);
    if (left == .none or right == .none) return;
    const lt = ctx.nodeTag(left);
    const rt = ctx.nodeTag(right);
    if (lt == .identifier and rt == .identifier) {
        const ln = ctx.tokenText(ctx.nodeMainToken(left));
        const rn = ctx.tokenText(ctx.nodeMainToken(right));
        if (std.mem.eql(u8, ln, rn)) {
            ctx.reportWithMessageIdAndData(right, "selfAssignment", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "name", .val = rn },
            });
        }
        return;
    }
    if (!ctx.getOptionBool("props", true)) return;
    const lm = lt == .member_expr or lt == .optional_member_expr
        or lt == .computed_member_expr or lt == .optional_computed_member_expr;
    const rm = rt == .member_expr or rt == .optional_member_expr
        or rt == .computed_member_expr or rt == .optional_computed_member_expr;
    if (lm and rm and ctx.nodeSameReference(left, right)) {
        if (!ctx.isSimpleMemberChain(left) or !ctx.isSimpleMemberChain(right)) return;
        ctx.reportWithMessageIdAndData(right, "selfAssignment", &[_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "name", .val = ctx.sourceText(right) },
        });
        return;
    }
    if ((lt == .array_pattern and rt == .array_literal)
        or (lt == .object_pattern and rt == .object_literal)) {
        ctx.checkSelfAssignArrayPattern(left, right, "selfAssignment");
    }
}
