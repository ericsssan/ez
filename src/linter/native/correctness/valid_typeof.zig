// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: valid-typeof
// Source rule: tests/conformance/eslint/lib/rules/valid-typeof.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "valid-typeof",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce comparing `typeof` expressions against valid strings",
};

pub const relevant_tags = [_]Node.Tag{.typeof_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    invalidValue,
    notString,
    suggestString,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.nodeTag(node) != .typeof_expr) return;
    const sibling = ctx.validTypeofInvalidSibling(node);
    if (sibling == .none) return;
    const require_strings = ctx.validTypeofRequireStringLiterals();
    if (ctx.ast.nodeTag(sibling) == .identifier
        and std.mem.eql(u8, ctx.ast.tokenText(ctx.ast.nodeMainToken(sibling)), "undefined"))
    {
        const span = ctx.nodeSpan(sibling);
        const sugg = [_]LintContext.SuggestionInput{
            .{ .message_id = "suggestString", .fix_span = span, .fix_text = "\"undefined\"" },
        };
        const data = [_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "type", .val = "undefined" },
        };
        const mid: []const u8 = if (require_strings) "notString" else "invalidValue";
        ctx.reportSpanWithDataAndSuggestions(span, mid, &data, &sugg);
        return;
    }
    ctx.reportWithMessageId(sibling, ctx.validTypeofSiblingMessageId(sibling));
}
