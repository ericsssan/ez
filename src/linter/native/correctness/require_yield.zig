// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: require-yield
// Source rule: tests/conformance/eslint/lib/rules/require-yield.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "require-yield",
    .category = .style,
    .default_severity = .warning,
    .description = "Require generator functions to contain `yield`",
};

pub const relevant_tags = [_]Node.Tag{.generator_fn_decl, .generator_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr, .method_def, .computed_method_def};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    missingYield,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.isGeneratorFunctionOrMethod(node) and (!(ctx.subtreeContainsTag(node, .yield_expr)) and (ctx.nodeBodyStmtCount(ctx.nodeBodyBlock(node)) > 0)))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.nodeFunctionHeadSpan(node).start, .end = ctx.nodeFunctionHeadSpan(node).end }, "missingYield");
    }
}
