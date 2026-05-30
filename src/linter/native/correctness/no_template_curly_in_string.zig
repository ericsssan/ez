// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-template-curly-in-string
// Source rule: tests/conformance/eslint/lib/rules/no-template-curly-in-string.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-template-curly-in-string",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow template literal placeholder syntax in regular strings",
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedTemplateExpression,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeTag(node) == .string_literal) and ((std.mem.indexOf(u8, ctx.tokenText(ctx.nodeMainToken(node)), "${") != null) and (std.mem.indexOf(u8, ctx.tokenText(ctx.nodeMainToken(node)), "}") != null)))) {
        ctx.reportWithMessageId(node, "unexpectedTemplateExpression");
    }
}
