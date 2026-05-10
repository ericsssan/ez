// Programmatic transform for eslint-plugin-promise's `rules/always-return.js`.
//
// What it changes
// ---------------
// The rule wires up CodePath segment-start / segment-end / Return-statement
// listeners to detect `then(...)` callbacks that don't always return. The
// CFG bookkeeping fires for every segment in the file (~323K calls on
// typescript.js). If the source has no `.then(` at all, none of that
// bookkeeping can produce a diagnostic — bail at `create()` with an
// empty visitor map.

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-promise/rules/always-return.js";

export function transform(src) {
  if (!src.includes("create(context) {")) {
    throw new Error("upstream always-return create shape changed");
  }
  src = src.replace(
    "create(context) {",
    "create(context) {\n    // ez fast-path: no `.then(` in source → nothing to do.\n    if (context.sourceCode && context.sourceCode.text && !context.sourceCode.text.includes('.then(')) return {};",
  );
  return src;
}
