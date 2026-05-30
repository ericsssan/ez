// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: max-classes-per-file
// Source rule: tests/conformance/eslint/lib/rules/max-classes-per-file.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-classes-per-file",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce a maximum number of classes per file",
};

pub const relevant_tags = [_]Node.Tag{.root};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    maximumExceeded,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkMaxClassesPerFile(node);
}
