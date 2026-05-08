// Programmatic transform for eslint-plugin-unicorn's
// `rules/rule/unicorn-listeners.js`.
//
// What it changes
// ---------------
// Upstream's `toEslintListeners()` registers each selector handler as
// a generator pipeline:
//
//   eslintListeners[selector] = toEslintListener(
//     this.#context,
//     function * (...args) { for (const l of listeners) yield l(...args); }
//   );
//
// `toEslintListener` then drains that generator via
// `iterateFixOrProblems` (recursive `yield*`) and reports each problem.
// Profile of typescript.js attributes ~25% of unicorn rule cost to
// the generator dispatch (`isIterable`, `iterateFixOrProblems`,
// `copyDataProperties`, `generatorResume`).
//
// We replace it with direct iteration:
//
//   eslintListeners[selector] = (...args) => {
//     for (let i = 0, n = listeners.length; i < n; i++) {
//       _drainAndReport(context, listeners[i](...args));
//     }
//   };
//
// `_drainAndReport` is a non-generator equivalent of
// `iterateFixOrProblems + toEslintListener`'s body. Same observable
// behavior, no generator state alloc on the per-node common path.
// `_toEslintProblem` is inlined to avoid one more import hop.
//
// The rest-spread fan-out pattern in `tools/rule-rewriter-patterns.js`
// further rewrites the `(...args)` shape to `(__ezA0, __ezA1)` since
// ESLint visitors are at most 2-arg — eliminating V8's
// `copyDataProperties` cost on entry and at every callee dispatch.
//
// Brittle? Yes — textual edits anchored on the upstream `function*`
// keyword and `iterateFixOrProblems` import. If upstream restructures
// the file, the transform throws (caught and logged by the build),
// surfacing the drift instead of silently shipping stale optimizations.

export const upstreamPath = "/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js";

export function transform(src) {
  // Sanity checks — if any of these fail, upstream changed and the
  // transform's edits aren't applicable. Throw so the build surfaces
  // a clear error instead of silently producing a broken substitute.
  if (!src.includes("toEslintListeners()")) throw new Error("upstream missing toEslintListeners() method");
  if (!src.includes("import toEslintListener from './to-eslint-listener.js'")) throw new Error("upstream import shape changed");
  if (!src.includes("function * (...listenerArguments)")) throw new Error("upstream generator dispatch shape changed");

  // Replace the toEslintListener import with toEslintFixer (used by
  // the inlined `_toEslintProblem` for fix unwrapping).
  src = src.replace(
    "import toEslintListener from './to-eslint-listener.js';",
    "import toEslintFixer from './to-eslint-rule-fixer.js';"
  );

  // Replace the toEslintListeners method body with the direct-iteration
  // version. Anchored on the `for (const [selector, listeners]` loop
  // line which is unique in the file.
  const oldBody = `for (const [selector, listeners] of this.#listeners) {
\t\t\teslintListeners[selector] = toEslintListener(
\t\t\t\tthis.#context,
\t\t\t\tfunction * (...listenerArguments) {
\t\t\t\t\tfor (const listener of listeners) {
\t\t\t\t\t\tyield listener(...listenerArguments);
\t\t\t\t\t}
\t\t\t\t},
\t\t\t);
\t\t}`;
  const newBody = `const context = this.#context;
\t\tfor (const [selector, listeners] of this.#listeners) {
\t\t\teslintListeners[selector] = (...listenerArguments) => {
\t\t\t\tfor (let i = 0, n = listeners.length; i < n; i++) {
\t\t\t\t\t_drainAndReport(context, listeners[i](...listenerArguments));
\t\t\t\t}
\t\t\t};
\t\t}`;
  if (!src.includes(oldBody)) throw new Error("upstream toEslintListeners loop body shape changed");
  src = src.replace(oldBody, newBody);

  // Append the helpers + drainer before the default export.
  const helpers = `

function _drainAndReport(context, value) {
\tif (value === undefined || value === null) return;
\tif (Array.isArray(value)) {
\t\tfor (let i = 0, n = value.length; i < n; i++) _drainAndReport(context, value[i]);
\t\treturn;
\t}
\tif (typeof value === 'object' && typeof value[Symbol.iterator] === 'function') {
\t\tfor (const item of value) _drainAndReport(context, item);
\t\treturn;
\t}
\tif (typeof value === 'object') {
\t\tcontext.report(_toEslintProblem(value));
\t}
}

function _toEslintProblem(unicornProblem) {
\tconst eslintProblem = {...unicornProblem};
\tif (unicornProblem.fix) {
\t\teslintProblem.fix = toEslintFixer(unicornProblem.fix);
\t}
\tif (Array.isArray(unicornProblem.suggest)) {
\t\teslintProblem.suggest = unicornProblem.suggest.map(unicornSuggest => ({
\t\t\t...unicornSuggest,
\t\t\tfix: toEslintFixer(unicornSuggest.fix),
\t\t\tdata: {
\t\t\t\t...unicornProblem.data,
\t\t\t\t...unicornSuggest.data,
\t\t\t},
\t\t}));
\t}
\treturn eslintProblem;
}
`;
  src = src.replace("export default UnicornListeners;", helpers + "\nexport default UnicornListeners;");
  return src;
}
