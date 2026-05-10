// Programmatic transform for ESLint core's `rules/func-style.js`.
//
// What it changes
// ---------------
// `isOverloadedFunction(node)` is called from every FunctionDeclaration
// visit and iterates the parent's body (or grandparent's body) via
// Array#some looking for a sibling `TSDeclareFunction` with the same
// name. On compiled-JS files, NO `TSDeclareFunction` nodes can exist
// (those come exclusively from `declare function` in TypeScript),
// so the iteration is pure waste — but currently runs ~thousands of
// siblings × ~thousands of FunctionDeclarations.
//
// Profile of typescript.js attributed 79 ms of self-time inside Array#some
// to this one function. Pre-checking `sourceCode.text.includes('declare')`
// short-circuits on every JS-only file.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/func-style.js";

const ANCHOR = `function isOverloadedFunction(node) {
			const functionName = node.id.name;`;

const FAST = `function isOverloadedFunction(node) {
			// ez fast-path: TSDeclareFunction nodes can only originate from a
			// 'declare function' keyword in source. Skip the iteration when
			// the source has no 'declare' token (~all JS-only files).
			if (_ezSourceLacksDeclare) return false;
			const functionName = node.id.name;`;

export function transform(src) {
  if (!src.includes(ANCHOR)) {
    throw new Error("upstream func-style isOverloadedFunction shape changed");
  }
  // Hoist the source-text check to once per `create()` call. The
  // `_ezSourceLacksDeclare` variable is referenced by the patched function
  // body via closure.
  const createOpener = "create(context) {";
  if (!src.includes(createOpener)) {
    throw new Error("upstream func-style create opener changed");
  }
  src = src.replace(
    createOpener,
    createOpener +
      "\n\t\tconst _ezSourceLacksDeclare = !context.sourceCode.text.includes('declare');",
  );
  src = src.replace(ANCHOR, FAST);
  return src;
}
