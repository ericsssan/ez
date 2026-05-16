// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: default-param-last
// Source rule: tests/conformance/eslint/lib/rules/default-param-last.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "default-param-last",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce default parameters to be last",
};

pub const relevant_tags = [_]Node.Tag{.fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl, .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr, .arrow_fn, .async_arrow_fn};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    shouldBeLast,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.reportDefaultParamLast(node, "shouldBeLast");
}
