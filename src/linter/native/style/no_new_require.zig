// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-new-require
// Source rule: tests/conformance/eslint/lib/rules/no-new-require.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-new-require",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new` operators with calls to `require`",
};

pub const relevant_tags = [_]Node.Tag{.new_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noNewRequire,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "require")))) {
        ctx.reportWithMessageId(node, "noNewRequire");
    }
}
