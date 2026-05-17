// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-octal-escape
// Source rule: tests/conformance/eslint/lib/rules/no-octal-escape.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-octal-escape",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow octal escape sequences in string literals",
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    octalEscapeSequence,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!((ctx.nodeTag(node) == .string_literal))) {
        return;
    }
    if (ctx.nodeRawHasOctalEscape(node)) {
        ctx.reportWithMessageId(node, "octalEscapeSequence");
    }
}
