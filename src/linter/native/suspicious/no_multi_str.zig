// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-multi-str
// Source rule: tests/conformance/eslint/lib/rules/no-multi-str.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-multi-str",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow multiline strings",
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    multilineString,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeRawContainsLinebreak(node) and !(ctx.nodeIsJsx(ctx.parentOf(node))))) {
        ctx.reportWithMessageId(node, "multilineString");
    }
}
