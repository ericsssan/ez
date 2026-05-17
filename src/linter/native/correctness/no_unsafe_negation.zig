// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-unsafe-negation
// Source rule: tests/conformance/eslint/lib/rules/no-unsafe-negation.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-negation",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow negating the left operand of relational operators",
};

pub const relevant_tags = [_]Node.Tag{.equal, .not_equal, .strict_equal, .strict_not_equal, .less_than, .greater_than, .less_equal, .greater_equal, .instanceof_expr, .in_expr, .add, .subtract, .multiply, .divide, .modulo, .exponentiate, .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    suggestNegatedExpression,
    suggestParenthesisedNegation,
};

const astUtils = [_][]const u8{ "COMMENTS_IGNORE_PATTERN", "LINEBREAKS", "LINEBREAK_MATCHER", "SHEBANG_MATCHER", "STATEMENT_LIST_PARENTS", "ECMASCRIPT_GLOBALS", "isTokenOnSameLine", "isNullOrUndefined", "isCallee", "isES5Constructor", "getUpperFunction", "isFunction", "isLoop", "isInLoop", "isArrayFromMethod", "isArrayFromAsyncMethod", "isParenthesised", "createGlobalLinebreakMatcher", "equalTokens", "isArrowToken", "isClosingBraceToken", "isClosingBracketToken", "isClosingParenToken", "isColonToken", "isCommaToken", "isCommentToken", "isDotToken", "isQuestionDotToken", "isKeywordToken", "isNotClosingBraceToken", "isNotClosingBracketToken", "isNotClosingParenToken", "isNotColonToken", "isNotCommaToken", "isNotDotToken", "isNotQuestionDotToken", "isNotOpeningBraceToken", "isNotOpeningBracketToken", "isNotOpeningParenToken", "isNotSemicolonToken", "isOpeningBraceToken", "isOpeningBracketToken", "isOpeningParenToken", "isSemicolonToken", "isEqToken", "isStringLiteral", "isBreakableStatement", "getModifyingReferences", "isSurroundedBy", "isDirectiveComment", "getTrailingStatement", "getVariableByName", "isDefaultThisBinding", "getPrecedence", "isEmptyBlock", "isEmptyFunction", "getDirectivePrologue", "isDecimalInteger", "isDecimalIntegerNumericToken", "getFunctionNameWithKind", "getFunctionHeadLoc", "getNextLocation", "getParenthesisedText", "couldBeError", "isNumericLiteral", "canTokensBeAdjacent", "getNameLocationInGlobalDirectiveComment", "hasOctalOrNonOctalDecimalEscapeSequence", "isStaticTemplateLiteral", "areBracesNecessary", "isReferenceToGlobalVariable", "isLogicalExpression", "isCoalesceExpression", "isMixedLogicalAndCoalesceExpressions", "isNullLiteral", "getStaticStringValue", "getStaticPropertyName", "skipChainExpression", "isSpecificId", "isSpecificMemberAccess", "equalLiteralValue", "isSameReference", "isLogicalAssignmentOperator", "getSwitchCaseColonToken", "getModuleExportName", "isConstant", "isTopLevelExpressionStatement", "isDirective", "isStartOfExpressionStatement", "needsPrecedingSemicolon", "isImportAttributeKey", "getOpeningParenOfParams" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if ((((((ctx.nodeTag(node) == .in_expr) or (ctx.nodeTag(node) == .instanceof_expr)) or (ctx.getOptionBool("enforceForOrderingRelations", false) and ((((ctx.nodeTag(node) == .less_than) or (ctx.nodeTag(node) == .greater_than)) or (ctx.nodeTag(node) == .greater_equal)) or (ctx.nodeTag(node) == .less_equal)))) and (blk: { const __t = ctx.nodeTag(ctx.nodeData(node).lhs); break :blk (__t == .delete_expr or __t == .void_expr or __t == .typeof_expr or __t == .unary_plus or __t == .unary_minus or __t == .bitwise_not or __t == .logical_not); } and (ctx.nodeTag(ctx.nodeData(node).lhs) == .logical_not))) and !((ctx.nodeTag(ctx.parentOf(ctx.nodeData(node).lhs)) == .grouping_expr)))) {
        ctx.reportSpanWithMessageId(.{ .start = ctx.nodeSpan(ctx.nodeData(node).lhs).start, .end = ctx.nodeSpan(ctx.nodeData(node).lhs).end }, "unexpected");
    }
}
