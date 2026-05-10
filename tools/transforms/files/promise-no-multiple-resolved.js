// Programmatic transform for eslint-plugin-promise's
// `rules/no-multiple-resolved.js`.
//
// What it changes
// ---------------
// The rule attaches CodePath listeners (segment enter/exit etc.) plus
// an exit selector on every CallExpression / MemberExpression / etc.
// that exists only to support detecting `resolve()` paths inside an
// inline `new Promise(...)` executor. If the source has no `new Promise`
// at all, none of those listeners can produce a diagnostic — bail at
// `create()` with an empty visitor map. Avoids hundreds of thousands of
// CFG-segment dispatches on files that don't construct Promises.

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-promise/rules/no-multiple-resolved.js";

export function transform(src) {
  if (!src.includes("create(context) {")) {
    throw new Error("upstream no-multiple-resolved create shape changed");
  }
  if (!src.includes("const codePathInfoStack = []")) {
    throw new Error("upstream no-multiple-resolved codePathInfoStack anchor missed");
  }

  // Insert the text-presence guard right at the top of `create(context)`,
  // before any state is initialised. typescript.js has only 4 occurrences
  // in 8.7 MB; truly Promise-free files skip everything.
  src = src.replace(
    "create(context) {",
    "create(context) {\n    // ez fast-path: no `new Promise` in source → nothing to do.\n    if (context.sourceCode && context.sourceCode.text && !context.sourceCode.text.includes('new Promise')) return {};",
  );

  return src;
}
