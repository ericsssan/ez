// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: id-denylist
// Source rule: tests/conformance/eslint/lib/rules/id-denylist.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "id-denylist",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow specified identifiers",
};

pub const relevant_tags = [_]Node.Tag{.identifier, .property_ident};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    restricted,
    restrictedPrivate,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkIdDenylist(node);
}
