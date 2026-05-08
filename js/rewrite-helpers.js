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

// ── Direct buffer-read helpers ─────────────────────────────────────
//
// Rule bodies frequently do `node.parent.type === "FunctionDeclaration"`,
// `node.parent.parent.type === "..."`, etc. Each `.parent` access goes
// through a getter that materializes a fresh NodeView object (allocated
// once per node-pair, then cached), then `.type` reads the wrapper.
// But the answer is sitting in the Zig buffer:
//   - `_parentKinds[i]`: u8, indicates synthetic wrapper kind
//   - `_resolvedParentData[i]`: u32, resolved parent's node index
//   - `_nodeTags[parentIdx]`: u8, parent's ez tag
//   - `effectiveTypeName(tag, ast, idx)`: string ESTree type
//
// These helpers read those arrays directly. No NodeView allocation,
// no getter dispatch — O(1) Uint8Array/Uint32Array reads. The
// `effectiveTypeName` call is the existing string-returning helper
// in estree-adapter.js (cached by tag for hot tags).
//
// Fallback path: when `node` isn't an ez NodeView (e.g. one of the
// synthetic Property/JSXOpeningElement wrappers built inside the
// `parent` getter), we don't have a buffer index and must fall back
// to the original property chain. The rewriter only emits the helper
// call when the LHS is a name that *could* be a NodeView; the helper
// itself self-checks before reading the buffer.

const _NONE = 0xFFFFFFFF;
let _nodeTypeAt = null;
function _ensureAdapter() {
  if (_nodeTypeAt === null) _nodeTypeAt = require("./estree-adapter").nodeTypeAt;
}

// `_parentKinds[i] === k` for k in 1..5 means the parent the rule sees
// is a synthetic wrapper whose `.type` is determined entirely by `k`.
// Index 0 is unused (real parent path).
const _PARENT_KIND_TYPE = [
  null,                  // 0: real parent (look up tag)
  "ChainExpression",     // 1: ChainExpression wrap
  "FunctionExpression",  // 2: method-def synthetic FunctionExpression
  "Property",            // 3: ObjectPattern child synthetic Property
  "JSXOpeningElement",   // 4: jsx_self_closing wrap
  "TSEnumBody",          // 5: TSEnumMember → TSEnumBody
  "TSInterfaceBody",     // 6: TSInterfaceDeclaration member → TSInterfaceBody
];

/**
 * Equivalent to `node.parent?.type === expectedType` without allocating
 * the parent NodeView. Reads `_parentKinds[i]` and `_nodeTags[parentIdx]`
 * directly from the buffer.
 */
function parentTypeEq(node, expectedType) {
  // Bail to the public API for anything that isn't a real NodeView.
  // Real NodeViews always have `_tag !== undefined` (set by ctors);
  // synthetic wrappers (e.g. the FunctionExpression for method-def
  // values, ChainExpression wrappers, TS synthetic nodes) have `_i`
  // accidentally added by other paths but no `_tag` — relying on `_i`
  // alone is unsafe. The wrapper's `.parent` is set as a regular
  // property so the slow path is correct.
  if (!node || node._i === undefined || node._tag === undefined) {
    return node?.parent?.type === expectedType;
  }
  const ast = node._ast;
  if (!ast) return node.parent?.type === expectedType;
  const kind = ast._parentKinds ? ast._parentKinds[node._i] : 0;
  if (kind !== 0) return _PARENT_KIND_TYPE[kind] === expectedType;
  const pd = ast._resolvedParentData;
  if (!pd) return node.parent?.type === expectedType;
  const pIdx = pd[node._i];
  if (pIdx === _NONE) return false;
  _ensureAdapter();
  return _nodeTypeAt(ast, pIdx) === expectedType;
}

/** Negation of `parentTypeEq`. */
function parentTypeNeq(node, expectedType) {
  return !parentTypeEq(node, expectedType);
}

/**
 * Equivalent to `node.parent?.parent?.type === expectedType` without
 * allocating either NodeView. The grandparent is determined entirely
 * by `_parentKinds[node._i]` and `_resolvedParentData[]`:
 *
 *   nodeKind != 0 (synthetic parent wraps the buffer-parent):
 *     ESTree chain is  node → synth → buffer-parent
 *     so grandparent (in ESTree) = buffer-parent of node.
 *     For all 6 synthesis kinds the wrapper's `.parent` is exactly the
 *     resolved-parent NodeView, so `_resolvedParentData[node._i]` is
 *     the grandparent.
 *
 *   nodeKind == 0 (real parent):
 *     parentIdx = _resolvedParentData[node._i]
 *     parentKind = _parentKinds[parentIdx]
 *     if parentKind != 0, grandparent is the synthetic wrapper of
 *       parent, type fully determined by parentKind.
 *     else, grandparent = nodeTypeAt at _resolvedParentData[parentIdx].
 *
 * Same fall-back rules as `parentTypeEq`.
 */
function grandparentTypeEq(node, expectedType) {
  if (!node || node._i === undefined || node._tag === undefined) {
    return node?.parent?.parent?.type === expectedType;
  }
  const ast = node._ast;
  if (!ast) return node.parent?.parent?.type === expectedType;
  const pks = ast._parentKinds;
  const pd = ast._resolvedParentData;
  if (!pks || !pd) return node.parent?.parent?.type === expectedType;

  const nodeKind = pks[node._i];
  if (nodeKind !== 0) {
    const gpIdx = pd[node._i];
    if (gpIdx === _NONE) return false;
    _ensureAdapter();
    return _nodeTypeAt(ast, gpIdx) === expectedType;
  }

  const parentIdx = pd[node._i];
  if (parentIdx === _NONE) return false;
  const parentKind = pks[parentIdx];
  if (parentKind !== 0) {
    return _PARENT_KIND_TYPE[parentKind] === expectedType;
  }
  const gpIdx = pd[parentIdx];
  if (gpIdx === _NONE) return false;
  _ensureAdapter();
  return _nodeTypeAt(ast, gpIdx) === expectedType;
}

/** Negation of `grandparentTypeEq`. */
function grandparentTypeNeq(node, expectedType) {
  return !grandparentTypeEq(node, expectedType);
}

module.exports = { someTypeEq, everyTypeEq, findTypeEq, indexedByProp, parentTypeEq, parentTypeNeq, grandparentTypeEq, grandparentTypeNeq };

// Bun's CJS↔ESM interop: when this file is loaded via `import * as _ezHelpers`,
// Bun maps `module.exports`'s keys onto the namespace. Both forms work.
