// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-setter-return
// Source rule: tests/conformance/eslint/lib/rules/no-setter-return.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-setter-return",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow returning values from setters",
};

pub const relevant_tags = [_]Node.Tag{.return_stmt, .arrow_fn, .async_arrow_fn};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    returnsValue,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoSetterReturn(node);
}
