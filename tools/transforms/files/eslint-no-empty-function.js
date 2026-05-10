// Programmatic transform for ESLint core's `rules/no-empty-function.js`.
//
// What it changes
// ---------------
// `reportIfEmpty(node)` runs on every FunctionDeclaration / FunctionExpression
// / ArrowFunctionExpression. Stock implementation eagerly computes
//   - `astUtils.getFunctionNameWithKind(node)`
//   - `sourceCode.getTokens(node.body, {...})`  ← scans the entire body's tokens
// before checking whether the body is even empty. The vast majority of
// functions have non-empty bodies, so the token scan is wasted.
//
// Reorder: check `node.body.type === 'BlockStatement' && node.body.body.length === 0`
// FIRST, then the allowed-list, then the inner-comments scan, then the
// name (only when actually reporting).
//
// Behaviour is preserved.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-empty-function.js";

const STOCK_BODY = `function reportIfEmpty(node) {
			const name = astUtils.getFunctionNameWithKind(node);
			const innerComments = sourceCode.getTokens(node.body, {
				includeComments: true,
				filter: astUtils.isCommentToken,
			});

			if (
				!isAllowedEmptyFunction(node) &&
				node.body.type === "BlockStatement" &&
				node.body.body.length === 0 &&
				innerComments.length === 0
			) {
				context.report({
					node,
					loc: node.body.loc,
					messageId: "unexpected",
					data: { name },`;

const FAST_BODY = `function reportIfEmpty(node) {
			// ez fast-path: bail before the expensive token scan when the body
			// is non-empty (the rule never reports in that case).
			if (node.body.type !== "BlockStatement" || node.body.body.length !== 0) return;
			if (isAllowedEmptyFunction(node)) return;
			const innerComments = sourceCode.getTokens(node.body, {
				includeComments: true,
				filter: astUtils.isCommentToken,
			});
			if (innerComments.length !== 0) return;
			const name = astUtils.getFunctionNameWithKind(node);

			if (
				true
			) {
				context.report({
					node,
					loc: node.body.loc,
					messageId: "unexpected",
					data: { name },`;

export function transform(src) {
  if (!src.includes(STOCK_BODY)) {
    throw new Error("upstream no-empty-function reportIfEmpty shape changed");
  }
  return src.replace(STOCK_BODY, FAST_BODY);
}
