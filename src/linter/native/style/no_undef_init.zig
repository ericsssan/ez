// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-undef-init
// Source rule: tests/conformance/eslint/lib/rules/no-undef-init.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-undef-init",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow initializing variables to `undefined`",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnecessaryUndefinedInit,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const init_node = ctx.nodeData(node).rhs;
    if (init_node == .none) return;
    if (ctx.nodeTag(init_node) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(init_node)), "undefined")) return;
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    const parent_tag = ctx.nodeTag(parent);
    if (parent_tag == .const_decl) return;
    if (!ctx.nameHasNoUserBinding(init_node, "undefined")) return;
    const id_node = ctx.nodeData(node).lhs;
    const id_tag = ctx.nodeTag(id_node);
    const can_fix = (parent_tag == .let_decl) and (id_tag == .identifier);
    const data = [_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "name", .val = ctx.sourceText(id_node) } };
    if (can_fix) {
        const id_span = ctx.nodeSpan(id_node);
        const decl_span = ctx.nodeSpan(node);
        if (!ctx.rangeContainsComment(id_span.end, decl_span.end)) {
            ctx.reportSpanWithFixAndMessageId(decl_span, .{ .start = id_span.end, .end = decl_span.end }, "", "unnecessaryUndefinedInit");
            return;
        }
    }
    ctx.reportWithMessageIdAndData(node, "unnecessaryUndefinedInit", &data);
}
