// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-extra-boolean-cast
// Source rule: tests/conformance/eslint/lib/rules/no-extra-boolean-cast.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extra-boolean-cast",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary double-negation boolean casts (`!!x`)",
};

pub const relevant_tags = [_]Node.Tag{.logical_not, .call_expr, .optional_call_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedNegation,
    unexpectedCall,
};

pub fn run(__node__: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(__node__)) {
        .logical_not => {
            if (((ctx.nodeTag(ctx.nodeData(__node__).lhs) == .logical_not) and ((ctx.nodeTag(ctx.nodeMainChildSkipGrouping(ctx.nodeData(__node__).lhs)) == .logical_not) or ctx.nodeInBooleanCtx(__node__)))) {
                ctx.report(__node__);
            }
        },
        .call_expr, .optional_call_expr => {
            if ((ctx.nodeIsBooleanCall(__node__) and ctx.nodeInBooleanCtx(__node__))) {
                ctx.report(__node__);
            }
        },
        else => {},
    }
}
