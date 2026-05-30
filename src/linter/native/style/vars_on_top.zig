// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: vars-on-top
// Source rule: tests/conformance/eslint/lib/rules/vars-on-top.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "vars-on-top",
    .category = .style,
    .default_severity = .warning,
    .description = "Require `var` declarations be placed at the top of their containing scope",
};

pub const relevant_tags = [_]Node.Tag{.var_decl};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    top,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkVarsOnTop(node);
}
