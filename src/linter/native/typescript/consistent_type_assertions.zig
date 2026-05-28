// HAND-WRITTEN.
// Rule: @typescript-eslint/consistent-type-assertions
//
// Enforces consistent use of type assertions.
// Options (first option object):
//   assertionStyle: "as" (default) | "angle-bracket" | "never"
//   objectLiteralTypeAssertions: "allow" (default) | "allow-as-parameter" | "never"
//   arrayLiteralTypeAssertions:  "allow" (default) | "allow-as-parameter" | "never"

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-type-assertions",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent usage of type assertions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_as_expr,
    .ts_type_assertion,
};

pub const needs_semantic = true;

const AssertionStyle = enum { as, angle_bracket, never };
const LiteralPolicy = enum { allow, allow_as_parameter, never };

fn assertionStyle(ctx: *const LintContext) AssertionStyle {
    const s = ctx.getOptionString("assertionStyle") orelse return .as;
    if (std.mem.eql(u8, s, "angle-bracket")) return .angle_bracket;
    if (std.mem.eql(u8, s, "never")) return .never;
    return .as;
}

fn objectPolicy(ctx: *const LintContext) LiteralPolicy {
    const s = ctx.getOptionString("objectLiteralTypeAssertions") orelse return .allow;
    if (std.mem.eql(u8, s, "allow-as-parameter")) return .allow_as_parameter;
    if (std.mem.eql(u8, s, "never")) return .never;
    return .allow;
}

fn arrayPolicy(ctx: *const LintContext) LiteralPolicy {
    const s = ctx.getOptionString("arrayLiteralTypeAssertions") orelse return .allow;
    if (std.mem.eql(u8, s, "allow-as-parameter")) return .allow_as_parameter;
    if (std.mem.eql(u8, s, "never")) return .never;
    return .allow;
}

/// True when the assertion node is in a "parameter" context.
fn isAsParameter(node: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(node);
    if (parent == .none) return false;
    switch (ctx.nodeTag(parent)) {
        .call_expr, .optional_call_expr, .new_expr, .throw_stmt, .assignment_pattern => return true,
        .jsx_expression_container => return true,
        .template_literal => {
            const gp = ctx.parentOf(parent);
            if (gp == .none) return false;
            return ctx.nodeTag(gp) == .tagged_template;
        },
        else => return false,
    }
}

/// True when `type_node` is the unqualified `const` keyword (i.e. `as const`).
fn isConstType(type_node: NodeIndex, ctx: *const LintContext) bool {
    if (type_node == .none) return false;
    if (ctx.nodeTag(type_node) != .ts_type_reference) return false;
    const tok = ctx.nodeMainToken(type_node);
    return ctx.tokenTag(tok) == .kw_const and ctx.nodeData(type_node).lhs == .none;
}

/// True when the object/array literal assertion should fire based on the type.
/// Mirrors TSe's checkType: returns false for `any`, `unknown`, and bare `const`.
fn checkType(type_node: NodeIndex, ctx: *const LintContext) bool {
    if (type_node == .none) return false;
    if (ctx.nodeTag(type_node) != .ts_type_reference) return true;
    const tok = ctx.nodeMainToken(type_node);
    // bare `const` (unqualified)
    if (ctx.tokenTag(tok) == .kw_const and ctx.nodeData(type_node).lhs == .none) return false;
    const text = ctx.tokenText(tok);
    if (std.mem.eql(u8, text, "any") or std.mem.eql(u8, text, "unknown")) return false;
    return true;
}

fn checkLiteralAssertion(node: NodeIndex, expr_node: NodeIndex, type_node: NodeIndex, ctx: *const LintContext) void {
    if (expr_node == .none) return;
    switch (ctx.nodeTag(expr_node)) {
        .object_literal => {
            const pol = objectPolicy(ctx);
            if (pol == .allow) return;
            if (pol == .allow_as_parameter and isAsParameter(node, ctx)) return;
            if (!checkType(type_node, ctx)) return;
            ctx.reportWithMessageId(node, "unexpectedObjectTypeAssertion");
        },
        .array_literal => {
            const pol = arrayPolicy(ctx);
            if (pol == .allow) return;
            if (pol == .allow_as_parameter and isAsParameter(node, ctx)) return;
            if (!checkType(type_node, ctx)) return;
            ctx.reportWithMessageId(node, "unexpectedArrayTypeAssertion");
        },
        else => {},
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const style = assertionStyle(ctx);
    switch (ctx.nodeTag(node)) {
        .ts_as_expr => {
            const type_node = ctx.nodeData(node).rhs;
            if (style != .as) {
                if (style == .never and isConstType(type_node, ctx)) return;
                ctx.reportWithMessageId(node, if (style == .never) "never" else "angle-bracket");
                return;
            }
            checkLiteralAssertion(node, ctx.nodeData(node).lhs, type_node, ctx);
        },
        .ts_type_assertion => {
            const type_node = ctx.nodeData(node).lhs;
            if (style != .angle_bracket) {
                if (style == .never and isConstType(type_node, ctx)) return;
                ctx.reportWithMessageId(node, if (style == .never) "never" else "as");
                return;
            }
            checkLiteralAssertion(node, ctx.nodeData(node).rhs, type_node, ctx);
        },
        else => {},
    }
}
