// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-continue
// Source rule: tests/conformance/eslint/lib/rules/no-continue.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-continue",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `continue` statements",
};

pub const relevant_tags = [_]Node.Tag{.continue_stmt, .continue_label};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.reportWithMessageId(node, "unexpected");
}
