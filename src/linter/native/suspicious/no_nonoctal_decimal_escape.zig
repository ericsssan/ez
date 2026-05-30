// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-nonoctal-decimal-escape
// Source rule: tests/conformance/eslint/lib/rules/no-nonoctal-decimal-escape.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-nonoctal-decimal-escape",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `\\8` and `\\9` escape sequences in string literals",
};

pub const relevant_tags = [_]Node.Tag{.string_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    decimalEscape,
    refactor,
    escapeBackslash,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoNonoctalDecimalEscape(node);
}
