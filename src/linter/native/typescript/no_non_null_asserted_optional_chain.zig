// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-non-null-asserted-optional-chain

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-optional-chain",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions after an optional chain expression",
};

pub const relevant_tags = [_]Node.Tag{.optional_member_expr, .optional_computed_member_expr, .optional_call_expr, .ts_non_null_expr};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noNonNullOptionalChain,
    suggestRemovingNonNull,
};

const util_1 = [_][]const u8{ "applyDefault", "deepMerge", "getParserServices", "isObjectNotArray", "nullThrows", "NullThrowsReasons", "getNameLocationInGlobalDirectiveComment", "forEachReturnStatement", "forEachChildESTree", "getFunctionHeadLocation", "getFunctionNameWithKind", "getPropertyName", "getStaticValue", "getStringIfConstant", "hasSideEffect", "isParenthesized", "PatternMatcher", "isArrowToken", "isNotArrowToken", "isClosingBraceToken", "isNotClosingBraceToken", "isClosingBracketToken", "isNotClosingBracketToken", "isClosingParenToken", "isNotClosingParenToken", "isColonToken", "isNotColonToken", "isCommaToken", "isNotCommaToken", "isCommentToken", "isNotCommentToken", "isOpeningBraceToken", "isNotOpeningBraceToken", "isOpeningBracketToken", "isNotOpeningBracketToken", "isOpeningParenToken", "isNotOpeningParenToken", "isSemicolonToken", "isNotSemicolonToken", "ReferenceTracker", "findVariable", "getInnermostScope", "isNodeOfType", "isNodeOfTypes", "isNodeOfTypeWithConditions", "isTokenOfTypeWithConditions", "isNotTokenOfTypeWithConditions", "LINEBREAK_MATCHER", "isTokenOnSameLine", "isOptionalChainPunctuator", "isNotOptionalChainPunctuator", "isNonNullAssertionPunctuator", "isNotNonNullAssertionPunctuator", "isOptionalCallExpression", "isLogicalOrOperator", "isTypeAssertion", "isVariableDeclarator", "isFunction", "isFunctionType", "isFunctionOrFunctionType", "isTSFunctionType", "isTSConstructorType", "isClassOrTypeElement", "isConstructor", "isIdentifier", "isAwaitExpression", "isAwaitKeyword", "isTypeKeyword", "isImportKeyword", "isLoop", "isSetter", "hasBaseTypes", "matchesTypeOrBaseType", "collectVariables", "createRule", "getBaseTypesOfClassMember", "getFixOrSuggest", "getFunctionHeadLoc", "OperatorPrecedence", "getOperatorPrecedenceForNode", "getOperatorPrecedence", "getBinaryOperatorPrecedence", "getStaticStringValue", "getStringLength", "getTextWithParentheses", "getThisExpression", "getWrappingFixer", "getMovedNodeCode", "isStrongPrecedenceNode", "hasOverloadSignatures", "isArrayMethodCallWithPredicate", "isAssignee", "isNodeEqual", "isNullLiteral", "isStartOfExpressionStatement", "isUndefinedIdentifier", "MemberNameType", "isStaticMemberAccessOfValue", "isDefinitionFile", "upperCaseFirst", "arrayGroupByToMap", "arraysAreEqual", "findFirstResult", "getNameFromIndexSignature", "getNameFromMember", "getEnumNames", "formatWordList", "findLastIndex", "typeNodeRequiresParentheses", "isRestParameterDeclaration", "isParenlessArrowFunction", "getStaticMemberAccessValue", "needsPrecedingSemicolon", "objectForEachKey", "objectMapKey", "objectReduceKey", "Awaitable", "needsToBeAwaited", "isReferenceToGlobalFunction", "getConstraintInfo", "getValueOfLiteralType", "isHigherPrecedenceThanAwait", "skipChainExpression", "isPossiblyFalsy", "isPossiblyTruthy", "walkStatements", "getDecorators", "getModifiers", "typescriptVersionIsAtLeast", "isPromiseLike", "isPromiseConstructorLike", "isErrorLike", "isReadonlyErrorLike", "isReadonlyTypeLike", "isBuiltinTypeAliasLike", "isBuiltinSymbolLike", "isBuiltinSymbolLikeRecurser", "containsAllTypesByName", "getConstrainedTypeAtLocation", "getContextualType", "getDeclaration", "getSourceFileOfNode", "getTypeName", "isSymbolFromDefaultLibrary", "isTypeBrandedLiteralLike", "readonlynessOptionsSchema", "readonlynessOptionsDefaults", "isTypeReadonly", "isUnsafeAssignment", "isNullableType", "isTypeArrayTypeOrUnionOfArrayTypes", "isTypeNeverType", "isTypeUnknownType", "isTypeReferenceType", "isTypeAnyType", "isTypeAnyArrayType", "isTypeUnknownArrayType", "typeIsOrHasBaseType", "isTypeBigIntLiteralType", "isTypeTemplateLiteralType", "getTypeOfPropertyOfName", "getTypeOfPropertyOfType", "requiresQuoting", "getTypeFlags", "isTypeFlagSet", "typeOrValueSpecifiersSchema", "typeMatchesSomeSpecifier", "valueMatchesSomeSpecifier", "typeMatchesSpecifier", "valueMatchesSpecifier", "AnyType", "discriminateAnyType" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .optional_member_expr, .optional_computed_member_expr, .optional_call_expr => {
            if ((ctx.nodeTag(ctx.parentOf(node)) == .ts_non_null_expr)) {
                ctx.report(node);
            }
        },
        .ts_non_null_expr => {
            if (blk: { const __t = ctx.nodeTag(ctx.parentOf(node)); break :blk (__t == .optional_member_expr or __t == .optional_computed_member_expr or __t == .optional_call_expr); }) {
                ctx.report(node);
            }
        },
        else => {},
    }
}
