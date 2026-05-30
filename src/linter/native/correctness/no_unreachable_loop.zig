// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unreachable-loop
// Source rule: tests/conformance/eslint/lib/rules/no-unreachable-loop.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow loops with a body that allows only one iteration",
};

pub const relevant_tags = [_]Node.Tag{.while_stmt, .do_while_stmt, .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    invalid,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeReachable(node) and !(ctx.optionIgnoreContainsNodeType(node))) and !(ctx.loopHasIterationBackEdge(node)))) {
        ctx.reportWithMessageId(node, "invalid");
    }
}
