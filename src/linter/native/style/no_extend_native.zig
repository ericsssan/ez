// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-extend-native
// Source rule: tests/conformance/eslint/lib/rules/no-extend-native.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-extend-native",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow extending native types",
};

pub const relevant_tags = [_]Node.Tag{.identifier};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoExtendNative(node);
}
