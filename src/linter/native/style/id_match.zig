// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: id-match
// Source rule: tests/conformance/eslint/lib/rules/id-match.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "id-match",
    .category = .style,
    .default_severity = .warning,
    .description = "Require identifiers to match a specified regular expression",
};

pub const relevant_tags = [_]Node.Tag{.identifier, .property_ident};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    notMatch,
    notMatchPrivate,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkIdMatch(node);
}
