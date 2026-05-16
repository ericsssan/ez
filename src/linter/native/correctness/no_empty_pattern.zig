// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-empty-pattern
// Source rule: tests/conformance/eslint/lib/rules/no-empty-pattern.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-pattern",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty destructuring patterns",
};

pub const relevant_tags = [_]Node.Tag{.object_pattern, .array_pattern};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const astUtils = [_][]const u8{ "COMMENTS_IGNORE_PATTERN", "LINEBREAKS", "LINEBREAK_MATCHER", "SHEBANG_MATCHER", "STATEMENT_LIST_PARENTS", "ECMASCRIPT_GLOBALS", "isTokenOnSameLine", "isNullOrUndefined", "isCallee", "isES5Constructor", "getUpperFunction", "isFunction", "isLoop", "isInLoop", "isArrayFromMethod", "isArrayFromAsyncMethod", "isParenthesised", "createGlobalLinebreakMatcher", "equalTokens", "isArrowToken", "isClosingBraceToken", "isClosingBracketToken", "isClosingParenToken", "isColonToken", "isCommaToken", "isCommentToken", "isDotToken", "isQuestionDotToken", "isKeywordToken", "isNotClosingBraceToken", "isNotClosingBracketToken", "isNotClosingParenToken", "isNotColonToken", "isNotCommaToken", "isNotDotToken", "isNotQuestionDotToken", "isNotOpeningBraceToken", "isNotOpeningBracketToken", "isNotOpeningParenToken", "isNotSemicolonToken", "isOpeningBraceToken", "isOpeningBracketToken", "isOpeningParenToken", "isSemicolonToken", "isEqToken", "isStringLiteral", "isBreakableStatement", "getModifyingReferences", "isSurroundedBy", "isDirectiveComment", "getTrailingStatement", "getVariableByName", "isDefaultThisBinding", "getPrecedence", "isEmptyBlock", "isEmptyFunction", "getDirectivePrologue", "isDecimalInteger", "isDecimalIntegerNumericToken", "getFunctionNameWithKind", "getFunctionHeadLoc", "getNextLocation", "getParenthesisedText", "couldBeError", "isNumericLiteral", "canTokensBeAdjacent", "getNameLocationInGlobalDirectiveComment", "hasOctalOrNonOctalDecimalEscapeSequence", "isStaticTemplateLiteral", "areBracesNecessary", "isReferenceToGlobalVariable", "isLogicalExpression", "isCoalesceExpression", "isMixedLogicalAndCoalesceExpressions", "isNullLiteral", "getStaticStringValue", "getStaticPropertyName", "skipChainExpression", "isSpecificId", "isSpecificMemberAccess", "equalLiteralValue", "isSameReference", "isLogicalAssignmentOperator", "getSwitchCaseColonToken", "getModuleExportName", "isConstant", "isTopLevelExpressionStatement", "isDirective", "isStartOfExpressionStatement", "needsPrecedingSemicolon", "isImportAttributeKey", "getOpeningParenOfParams" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .object_pattern => {
            if ((ctx.nodeData(node).lhs != ctx.nodeData(node).rhs)) {
                return;
            }
            if ((ctx.getOptionBool("allowObjectPatternsAsParameters", false) and (blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .fn_decl or __t == .async_fn_decl or __t == .generator_fn_decl or __t == .async_generator_fn_decl or __t == .fn_expr or __t == .async_fn_expr or __t == .generator_fn_expr or __t == .async_generator_fn_expr or __t == .arrow_fn or __t == .async_arrow_fn); } or ((((ctx.nodeTag(ctx.parentOf(node)) == .assignment_pattern) and blk: { const __t = ctx.nodeTag(ctx.parentOf(ctx.parentOf(node))); break :blk (__t == .fn_decl or __t == .async_fn_decl or __t == .generator_fn_decl or __t == .async_generator_fn_decl or __t == .fn_expr or __t == .async_fn_expr or __t == .generator_fn_expr or __t == .async_generator_fn_expr or __t == .arrow_fn or __t == .async_arrow_fn); }) and (ctx.nodeTag(ctx.nodeData(ctx.parentOf(node)).rhs) == .object_literal)) and (ctx.nodeData(ctx.nodeData(ctx.parentOf(node)).rhs).lhs == ctx.nodeData(ctx.nodeData(ctx.parentOf(node)).rhs).rhs))))) {
                return;
            }
            ctx.reportWithMessageIdAndData(node, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "type", .val = "object" } });
        },
        .array_pattern => {
            if ((ctx.nodeData(node).lhs == ctx.nodeData(node).rhs)) {
                ctx.reportWithMessageIdAndData(node, "unexpected", &[_]@import("../../lint_context.zig").MessageDataEntry{ .{ .key = "type", .val = "array" } });
            }
        },
        else => {},
    }
}
