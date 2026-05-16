// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-ex-assign
// Source rule: tests/conformance/eslint/lib/rules/no-ex-assign.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-ex-assign",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow reassigning exceptions in `catch` clauses",
};

pub const relevant_tags = [_]Node.Tag{};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
};

const astUtils = [_][]const u8{ "COMMENTS_IGNORE_PATTERN", "LINEBREAKS", "LINEBREAK_MATCHER", "SHEBANG_MATCHER", "STATEMENT_LIST_PARENTS", "ECMASCRIPT_GLOBALS", "isTokenOnSameLine", "isNullOrUndefined", "isCallee", "isES5Constructor", "getUpperFunction", "isFunction", "isLoop", "isInLoop", "isArrayFromMethod", "isArrayFromAsyncMethod", "isParenthesised", "createGlobalLinebreakMatcher", "equalTokens", "isArrowToken", "isClosingBraceToken", "isClosingBracketToken", "isClosingParenToken", "isColonToken", "isCommaToken", "isCommentToken", "isDotToken", "isQuestionDotToken", "isKeywordToken", "isNotClosingBraceToken", "isNotClosingBracketToken", "isNotClosingParenToken", "isNotColonToken", "isNotCommaToken", "isNotDotToken", "isNotQuestionDotToken", "isNotOpeningBraceToken", "isNotOpeningBracketToken", "isNotOpeningParenToken", "isNotSemicolonToken", "isOpeningBraceToken", "isOpeningBracketToken", "isOpeningParenToken", "isSemicolonToken", "isEqToken", "isStringLiteral", "isBreakableStatement", "getModifyingReferences", "isSurroundedBy", "isDirectiveComment", "getTrailingStatement", "getVariableByName", "isDefaultThisBinding", "getPrecedence", "isEmptyBlock", "isEmptyFunction", "getDirectivePrologue", "isDecimalInteger", "isDecimalIntegerNumericToken", "getFunctionNameWithKind", "getFunctionHeadLoc", "getNextLocation", "getParenthesisedText", "couldBeError", "isNumericLiteral", "canTokensBeAdjacent", "getNameLocationInGlobalDirectiveComment", "hasOctalOrNonOctalDecimalEscapeSequence", "isStaticTemplateLiteral", "areBracesNecessary", "isReferenceToGlobalVariable", "isLogicalExpression", "isCoalesceExpression", "isMixedLogicalAndCoalesceExpressions", "isNullLiteral", "getStaticStringValue", "getStaticPropertyName", "skipChainExpression", "isSpecificId", "isSpecificMemberAccess", "equalLiteralValue", "isSameReference", "isLogicalAssignmentOperator", "getSwitchCaseColonToken", "getModuleExportName", "isConstant", "isTopLevelExpressionStatement", "isDirective", "isStartOfExpressionStatement", "needsPrecedingSemicolon", "isImportAttributeKey", "getOpeningParenOfParams" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const symbols = ctx.symbols();
    const count = refs.count();
    var prev_reported_node: NodeIndex = .none;
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const kind = refs.getKind(ref_id);
        // ESLint's getModifyingReferences = isWrite() && !init.
        // Our .write_init kind == ESLint's reference.init === true.
        if (!kind.isWrite()) continue;
        if (kind == .write_init) continue;
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;
        switch (symbols.getBindingKind(sym_id)) {
            .catch_param => {},
            else => continue,
        }
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        // Destructuring with defaults can yield two write references that share
        // their identifier node ({Foo = 0} pattern); suppress the duplicate.
        if (id_node == prev_reported_node) continue;
        ctx.reportWithMessageId(id_node, "unexpected");
        prev_reported_node = id_node;
    }
}
