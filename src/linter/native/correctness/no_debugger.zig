// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-debugger
// Source rule: tests/conformance/eslint/lib/rules/no-debugger.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-debugger",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow the use of `debugger`",
};

pub const relevant_tags = [_]Node.Tag{.debugger_stmt};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.reportWithMessageId(node, "unexpected");
}
