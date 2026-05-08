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

module.exports = { someTypeEq, everyTypeEq, findTypeEq };
