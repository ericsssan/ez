// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-duplicate-case
// Source rule: tests/conformance/eslint/lib/rules/no-duplicate-case.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-case",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow duplicate case labels",
};

pub const relevant_tags = [_]Node.Tag{.switch_case, .switch_default};

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
    if (ctx.nodeHasDuplicatePrevCaseTest(node)) {
        ctx.reportWithMessageId(node, "unexpected");
    }
}
