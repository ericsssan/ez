// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-var
// Source rule: tests/conformance/eslint/lib/rules/no-var.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-var",
    .category = .style,
    .default_severity = .warning,
    .description = "Require `let` or `const` instead of `var`",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.var_decl, .let_decl, .const_decl};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedVar,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((ctx.nodeTag(node) != .var_decl)) {
        return;
    }
    ctx.reportWithMessageId(node, "unexpectedVar");
}
