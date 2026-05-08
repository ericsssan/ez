"use strict";
//
// Hand-tuned helpers injected into rewritten rule sources by the
// idiomatic-pattern rewriter (tools/rule-rewriter-patterns.js).
//
// Each helper replaces a common idiomatic ESLint rule pattern with a
// V8-friendly equivalent: for-loops over array methods, manual type
// compares over closure-based predicates. Same observable behavior,
// fewer closure allocations, fewer iterator-protocol hops.
//
// V8 may inline `Array.prototype.some` etc. when it sees a monomorphic
// callsite — but in real rule code the closures often go polymorphic
// (different node shapes flow in across many AST visits), and
// allocation-per-call still happens. Manual loops dodge both costs.

/**
 * Equivalent to `arr.some(x => x.type === type)` but without the closure
 * allocation or iterator-protocol overhead. Pure replacement.
 *
 * @param {Array<{type: string}>} arr
 * @param {string} type
 * @returns {boolean}
 */
function someTypeEq(arr, type) {
  // Length cached locally; V8 hoists this anyway but explicit is cheap.
  for (let i = 0, n = arr.length; i < n; i++) {
    if (arr[i].type === type) return true;
  }
  return false;
}

/**
 * Equivalent to `arr.every(x => x.type === type)`.
 */
function everyTypeEq(arr, type) {
  for (let i = 0, n = arr.length; i < n; i++) {
    if (arr[i].type !== type) return false;
  }
  return true;
}

/**
 * Equivalent to `arr.find(x => x.type === type)` returning the matched
 * element or undefined.
 */
function findTypeEq(arr, type) {
  for (let i = 0, n = arr.length; i < n; i++) {
    if (arr[i].type === type) return arr[i];
  }
  return undefined;
}

/**
 * Build (or reuse) a Map<key, T[]> keyed by `arr[i][prop]`. Cached on the
 * array itself via a non-enumerable property so repeated calls within a
 * single rule run reuse the same index — turns
 *
 *     for (const x of arr) { if (x[prop] !== key) continue; ... }
 *
 * (an O(N×Q) scan when looped Q times) into
 *
 *     const matches = indexedByProp(arr, prop).get(key);
 *     if (matches) for (const x of matches) { ... }
 *
 * (O(N) build amortized + O(matches) per query).
 *
 * Validity preconditions enforced by the rewriter (not by this helper):
 *   - `arr` doesn't mutate during the rule's run (no push/pop/etc).
 *   - Elements have a stable `[prop]` value matching JS `===`.
 *
 * The cached index lives on the array via a Symbol-keyed slot, one per
 * (prop) value. Different rewriter sites indexing the same array on the
 * same prop reuse one index; sites indexing on a different prop get a
 * different one.
 *
 * @param {Array} arr
 * @param {string} prop
 * @returns {Map<any, Array>}
 */
const _IDX_SLOTS = Object.create(null);
function indexedByProp(arr, prop) {
  // Symbol-per-prop so multiple rewriter sites on different props on
  // the same array don't clobber each other.
  let slotKey = _IDX_SLOTS[prop];
  if (!slotKey) {
    slotKey = Symbol("ezIdx_" + prop);
    _IDX_SLOTS[prop] = slotKey;
  }
  let m = arr[slotKey];
  if (m) return m;
  m = new Map();
  for (let i = 0, n = arr.length; i < n; i++) {
    const el = arr[i];
    const k = el[prop];
    let v = m.get(k);
    if (!v) { v = []; m.set(k, v); }
    v.push(el);
  }
  // Non-enumerable, configurable so a future GC sweep / rule reload can
  // overwrite. Writable so the cache can be invalidated externally if needed.
  Object.defineProperty(arr, slotKey, {
    value: m, writable: true, enumerable: false, configurable: true,
  });
  return m;
}

module.exports = { someTypeEq, everyTypeEq, findTypeEq, indexedByProp };

// Bun's CJS↔ESM interop: when this file is loaded via `import * as _ezHelpers`,
// Bun maps `module.exports`'s keys onto the namespace. Both forms work.
