// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-div-regex
// Source rule: tests/conformance/eslint/lib/rules/no-div-regex.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-div-regex",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow equal signs explicitly at the beginning of regular expressions",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.number_literal, .string_literal, .boolean_literal, .null_literal, .regex_literal, .bigint_literal};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (((ctx.nodeTag(node) == .regex_literal) and (blk: { const __t = ctx.tokenText(ctx.nodeMainToken(node)); break :blk __t.len > 1 and __t[1] == 61; }))) {
        ctx.reportWithFixAndMessageId(node, (.{ .start = (ctx.ast.tokenStart(ctx.nodeMainToken(node)) + 1), .end = (ctx.ast.tokenStart(ctx.nodeMainToken(node)) + 2) }), "[=]", "unexpected");
    }
}
