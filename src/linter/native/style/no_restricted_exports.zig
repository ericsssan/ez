// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-restricted-exports
// Source rule: tests/conformance/eslint/lib/rules/no-restricted-exports.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-restricted-exports",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow specified names in exports",
};

pub const relevant_tags = [_]Node.Tag{.export_named, .export_named_from, .export_all, .export_default_expr, .export_default_fn, .export_default_class};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    restrictedNamed,
    restrictedDefault,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoRestrictedExports(node);
}
