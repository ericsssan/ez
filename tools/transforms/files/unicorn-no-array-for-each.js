// Programmatic transform for unicorn's `rules/no-array-for-each.js`.
//
// What it changes
// ---------------
// The rule listens to every `Identifier` in the file (to build
// `allIdentifiers` for later scope-rewrite analysis), every function
// enter/exit, every ReturnStatement, every CallExpression. On
// typescript.js that's hundreds of thousands of dispatches, all to
// support a fixer that only matters when the file actually contains
// `.forEach(...)` method calls.
//
// If the source text doesn't contain the substring "forEach", no
// such call can exist — the rule has nothing to do. Bail at the
// top of `create(context)` with an empty visitor map. Skips the
// Identifier-walk entirely.
//
// Saves ~70-100ms isolated-rule cost on typescript.js.

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js";

export function transform(src) {
  if (!src.includes("const create = context => {")) {
    throw new Error("upstream no-array-for-each `create` shape changed");
  }
  if (!src.includes("const {sourceCode} = context;")) {
    throw new Error("upstream no-array-for-each sourceCode destructure changed");
  }

  // Insert text-presence guard right after `const {sourceCode} = context;`.
  // If the file has no "forEach" substring, no `.forEach()` call can
  // exist — return empty visitors immediately.
  src = src.replace(
    "const {sourceCode} = context;",
    "const {sourceCode} = context;\n\t// ez fast-path: no forEach in source → nothing to do.\n\tif (sourceCode.text && !sourceCode.text.includes('forEach')) return {};",
  );

  return src;
}
