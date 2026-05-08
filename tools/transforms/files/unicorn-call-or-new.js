// Programmatic transform for unicorn's
// `rules/ast/call-or-new-expression.js`.
//
// What it changes
// ---------------
// `isCallExpression(node)` etc. are called pervasively by unicorn
// rules (and other plugins re-export the same helpers). Profile of
// typescript.js attributes ~5% Total to `isCallExpression` and ~7%
// to `isMethodCall` (which calls `isCallExpression` internally),
// almost all in the underlying `create(node, options, types)`
// helper.
//
// The vast majority of those calls pass NO options — just
// `isCallExpression(node)`. With no options, all of `create()`'s
// option-parsing, default-merging, length checks, name checks etc.
// are wasted work. Add a fast-path: if `options === undefined`,
// the test reduces to a single type check.
//
// Also short-circuit the three exported wrappers (`isCallExpression`,
// `isNewExpression`, `isCallOrNewExpression`) so the no-options case
// skips the `create()` call frame entirely — V8 inlines the type
// check directly into the rule body.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js";

export function transform(src) {
  if (!src.includes("function create(node, options, types)")) {
    throw new Error("upstream `create` shape changed (transform anchor missed)");
  }
  if (!src.includes("export const isCallExpression = (node, options) => create(node, options, ['CallExpression']);")) {
    throw new Error("upstream `isCallExpression` shape changed");
  }

  // 1. Fast-path inside `create()` when options is undefined.
  src = src.replace(
    "function create(node, options, types) {\n\tif (!types.includes(node?.type)) {\n\t\treturn false;\n\t}",
    "function create(node, options, types) {\n\tif (!types.includes(node?.type)) {\n\t\treturn false;\n\t}\n\tif (options === undefined) {\n\t\treturn true;\n\t}"
  );

  // 2. Inline the no-options branch of the three exported wrappers.
  src = src.replace(
    "export const isCallExpression = (node, options) => create(node, options, ['CallExpression']);",
    "export const isCallExpression = (node, options) => options === undefined ? node?.type === 'CallExpression' : create(node, options, ['CallExpression']);"
  );

  src = src.replace(
    "export const isCallOrNewExpression = (node, options) => create(node, options, ['CallExpression', 'NewExpression']);",
    "export const isCallOrNewExpression = (node, options) => options === undefined ? (node?.type === 'CallExpression' || node?.type === 'NewExpression') : create(node, options, ['CallExpression', 'NewExpression']);"
  );

  // isNewExpression has its own no-options-friendly throw guard already,
  // so the fast-path can be added cleanly.
  src = src.replace(
    "export const isNewExpression = (node, options) => {\n\tif (typeof options?.optional === 'boolean') {\n\t\tthrow new TypeError('Cannot check node.optional in `isNewExpression`.');\n\t}\n\n\treturn create(node, options, ['NewExpression']);\n};",
    "export const isNewExpression = (node, options) => {\n\tif (options === undefined) return node?.type === 'NewExpression';\n\tif (typeof options?.optional === 'boolean') {\n\t\tthrow new TypeError('Cannot check node.optional in `isNewExpression`.');\n\t}\n\treturn create(node, options, ['NewExpression']);\n};"
  );

  return src;
}
