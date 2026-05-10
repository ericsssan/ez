// Programmatic transform for unicorn's `rules/no-useless-undefined.js`.
//
// What it changes
// ---------------
// The rule registers five separate `context.on('Identifier', ...)`
// listeners (return, yield, arrow body, var initializer, default value).
// Each starts with `if (isUndefined(node) && ...)` where `isUndefined`
// is `node?.type === 'Identifier' && node.name === 'undefined'`.
// Per-rule attribution showed 2.1M visitor invocations on typescript.js,
// almost all of which bail at the name check.
//
// Push the name filter into the selector itself
// (`Identifier[name="undefined"]`). ez's selector engine pre-filters
// at dispatch time, skipping the visitor entirely on every other
// identifier. Keeps the inner `isUndefined()` call as a no-op safety
// (still cheap once we're already known to be the right shape).

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-useless-undefined.js";

export function transform(src) {
  const before = src;
  // Replace each `context.on('Identifier', node => {` opener used by the
  // five gated handlers. Leave the CallExpression listener (last argument
  // of a call) alone since it doesn't pre-filter on Identifier name.
  src = src.replace(
    /context\.on\('Identifier', node => \{/g,
    `context.on('Identifier[name="undefined"]', node => {`,
  );
  if (src === before) {
    throw new Error("upstream no-useless-undefined Identifier listener anchor missed");
  }
  return src;
}
