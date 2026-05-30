// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-useless-call
// Source rule: tests/conformance/eslint/lib/rules/no-useless-call.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-call",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary calls to `.call()` and `.apply()`",
};

pub const relevant_tags = [_]Node.Tag{.call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnecessaryCall,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoUselessCall(node);
}
