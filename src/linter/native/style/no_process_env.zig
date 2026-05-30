// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-process-env
// Source rule: tests/conformance/eslint/lib/rules/no-process-env.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-process-env",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `process.env`",
};

pub const relevant_tags = [_]Node.Tag{.member_expr, .optional_member_expr, .computed_member_expr, .optional_computed_member_expr};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpectedProcessEnv,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "process")) and !((ctx.nodeTag(node) == .computed_member_expr or ctx.nodeTag(node) == .optional_computed_member_expr))) and (ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs)).len > 0)) and (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).rhs)), "env")))) {
        ctx.reportWithMessageId(node, "unexpectedProcessEnv");
    }
}
