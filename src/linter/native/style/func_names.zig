// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: func-names
// Source rule: tests/conformance/eslint/lib/rules/func-names.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "func-names",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow named `function` expressions",
};

pub const relevant_tags = [_]Node.Tag{.fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr, .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unnamed,
    named,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkFuncNames(node);
}
