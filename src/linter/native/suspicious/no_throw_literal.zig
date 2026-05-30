// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-throw-literal
// Source rule: tests/conformance/eslint/lib/rules/no-throw-literal.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-throw-literal",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow throwing literals as exceptions",
};

pub const relevant_tags = [_]Node.Tag{.throw_stmt};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    object,
    undef,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!(ctx.couldBeError(ctx.nodeData(node).lhs))) {
        ctx.reportWithMessageId(node, "object");
    } else {
        if ((ctx.nodeTag(ctx.nodeData(node).lhs) == .identifier)) {
            if ((std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(ctx.nodeData(node).lhs)), "undefined"))) {
                ctx.reportWithMessageId(node, "undef");
            }
        }
    }
}
