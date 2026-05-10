// Programmatic transform for unicorn's `rules/no-thenable.js`.
//
// What it changes
// ---------------
// Two of the rule's selectors are bare `'Identifier'`. The visitor's
// first action is `if (node.name !== 'then') return;` — meaning ~99.9%
// of dispatches do nothing. Per-rule attribution showed 1.07M visitor
// invocations on typescript.js for ~tens of `then` matches.
//
// Push the name filter into the selector itself (`Identifier[name="then"]`).
// ez's selector engine pre-filters at dispatch time, skipping the
// visitor entirely on every other identifier.

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-thenable.js";

export function transform(src) {
  // Two `selector: 'Identifier'` entries — the export-specifier case and
  // the export-function/class-declaration case. Both gated on `node.name === 'then'`.
  const before = src;
  src = src.replace(
    /selector: 'Identifier',\n\t\t\* getNodes\(node\) \{\n\t\t\tif \(\n\t\t\t\tnode\.name === 'then'/g,
    `selector: 'Identifier[name="then"]',\n\t\t* getNodes(node) {\n\t\t\tif (\n\t\t\t\tnode.name === 'then'`,
  );
  if (src === before) {
    throw new Error("upstream no-thenable Identifier-selector anchor missed");
  }
  return src;
}
