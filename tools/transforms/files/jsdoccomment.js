// Programmatic transform for `@es-joy/jsdoccomment`'s ESM source
// (`src/jsdoccomment.js`). Bun.build resolves the package via the
// `import` condition — `dist/index.cjs.cjs` is unreachable from
// inside the bundle.
//
// What it changes
// ---------------
// `findJSDocComment(node, sourceCode, settings, opts)` and
// `getJSDocComment(sourceCode, node, settings, opts)` are called by
// every rule in `eslint-plugin-jsdoc` — once per AST node. The same
// `(sourceCode, node)` tuple is queried dozens of times per file
// across 30+ jsdoc rules. Each call walks tokens backward via
// `sourceCode.getTokenBefore(...)`.
//
// Strategy: change the upstream `const` declarations to `let`, then
// append an IIFE that captures the originals and reassigns the
// bindings to WeakMap-keyed memo wrappers. ESM exports are live
// bindings, so consumers (the index that re-exports via
// `export * from './jsdoccomment.js'`) automatically see the
// memoized versions.
//
// Per-rule wall time impact on typescript.js (5×): ~50% reduction on
// jsdoc rules — first rule pays the full token walk, rules 2..N hit
// cache.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@es-joy/jsdoccomment/src/jsdoccomment.js";

export function transform(src) {
  if (!src.includes("findJSDocComment")) throw new Error("upstream missing findJSDocComment");
  if (!src.includes("getJSDocComment"))  throw new Error("upstream missing getJSDocComment");
  if (src.includes("__ez_jsdoc_memo_installed")) return src; // idempotent

  // Sanity: the const declarations must match exactly so the
  // const → let swap is safe.
  if (!src.includes("const findJSDocComment = (")) throw new Error("upstream findJSDocComment declaration shape changed");
  if (!src.includes("const getJSDocComment = function (")) throw new Error("upstream getJSDocComment declaration shape changed");

  src = src.replace("const findJSDocComment = (", "let findJSDocComment = (");
  src = src.replace("const getJSDocComment = function (", "let getJSDocComment = function (");

  const memoFooter = `

// === ez build-time memo wrap (tools/transforms/files/jsdoccomment.js) ===
const __ez_jsdoc_memo_installed = true;
{
  const _origFind = findJSDocComment;
  const _origGet  = getJSDocComment;
  const _findCache = new WeakMap();
  const _getCache  = new WeakMap();

  findJSDocComment = (astNode, sourceCode, settings, opts) => {
    if (!sourceCode || !astNode) return _origFind(astNode, sourceCode, settings, opts);
    let byNode = _findCache.get(sourceCode);
    if (!byNode) { byNode = new WeakMap(); _findCache.set(sourceCode, byNode); }
    const s = settings || {};
    const o = opts || {};
    const minL = s.minLines != null ? s.minLines : 0;
    const maxL = s.maxLines != null ? s.maxLines : 1;
    const nonJ = o.nonJSDoc ? 1 : 0;
    let entries = byNode.get(astNode);
    if (entries) {
      for (let i = 0, n = entries.length; i < n; i++) {
        const e = entries[i];
        if (e[0] === minL && e[1] === maxL && e[2] === nonJ) return e[3];
      }
    } else {
      entries = [];
      byNode.set(astNode, entries);
    }
    const result = _origFind(astNode, sourceCode, settings, opts);
    entries.push([minL, maxL, nonJ, result]);
    return result;
  };

  getJSDocComment = (sourceCode, node, settings, opts) => {
    if (!sourceCode || !node) return _origGet(sourceCode, node, settings, opts);
    let byNode = _getCache.get(sourceCode);
    if (!byNode) { byNode = new WeakMap(); _getCache.set(sourceCode, byNode); }
    const s = settings || {};
    const o = opts || {};
    const minL = s.minLines != null ? s.minLines : 0;
    const maxL = s.maxLines != null ? s.maxLines : 1;
    const ckOv = o.checkOverloads ? 1 : 0;
    let entries = byNode.get(node);
    if (entries) {
      for (let i = 0, n = entries.length; i < n; i++) {
        const e = entries[i];
        if (e[0] === minL && e[1] === maxL && e[2] === ckOv) return e[3];
      }
    } else {
      entries = [];
      byNode.set(node, entries);
    }
    const result = _origGet(sourceCode, node, settings, opts);
    entries.push([minL, maxL, ckOv, result]);
    return result;
  };
}
`;
  return src + memoFooter;
}
