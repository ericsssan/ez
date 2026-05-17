// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-script-url
// Source rule: tests/conformance/eslint/lib/rules/no-script-url.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-script-url",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `javascript:` URLs",
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal, .template_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedScriptURL,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal => {
            if ((true and (ctx.nodeTag(node) == .string_literal))) {
                if (((ctx.nodeStaticStringValue(node) != null) and ctx.nodeStaticStringStartsWith(node, "javascript:", true))) {
                    ctx.reportWithMessageId(node, "unexpectedScriptURL");
                }
            }
        },
        .template_literal => {
            if (!(((ctx.parentOf(node) != .none) and (ctx.nodeTag(ctx.parentOf(node)) == .tagged_template)))) {
                if (((ctx.nodeStaticStringValue(node) != null) and ctx.nodeStaticStringStartsWith(node, "javascript:", true))) {
                    ctx.reportWithMessageId(node, "unexpectedScriptURL");
                }
            }
        },
        else => {},
    }
}
