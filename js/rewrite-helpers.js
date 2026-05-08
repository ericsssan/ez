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
// Bind eagerly. There's no circular dependency (estree-adapter doesn't
// import this module), and lazy-binding adds a per-call branch on the
// hot path.
const { nodeTypeAt: _nodeTypeAt, T: _T } = require("./estree-adapter");
function _ensureAdapter() { /* no-op, kept for backwards compatibility with parent helpers */ }

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

/**
 * Equivalent to `node.parent?.parent?.parent?.type === expectedType`
 * without allocating any wrapping NodeView. Generalises the same
 * walker the one- and two-hop helpers use, three hops deep.
 *
 * Walker rule: at each step, `_parentKinds[curIdx]` says whether
 * curIdx's ESTree parent is a synthetic wrapper (kind != 0) or the
 * buffer's resolved-parent (kind == 0).
 *   - kind == 0 → 1 ESTree hop = 1 buffer hop (curIdx ← pd[curIdx]).
 *   - kind != 0, last hop  → answer determined by the kind alone
 *     (the wrapper's type is `_PARENT_KIND_TYPE[kind]`).
 *   - kind != 0, more hops → 2 ESTree hops cover (cur → wrapper →
 *     resolved-parent), so curIdx ← pd[curIdx] and remaining -= 2.
 *
 * Same fallback rules as the shorter-hop helpers.
 */
function greatGrandparentTypeEq(node, expectedType) {
  if (!node || node._i === undefined || node._tag === undefined) {
    return node?.parent?.parent?.parent?.type === expectedType;
  }
  const ast = node._ast;
  if (!ast) return node.parent?.parent?.parent?.type === expectedType;
  const pks = ast._parentKinds;
  const pd = ast._resolvedParentData;
  if (!pks || !pd) return node.parent?.parent?.parent?.type === expectedType;

  let curIdx = node._i;
  let remaining = 3;
  while (remaining > 0) {
    const kind = pks[curIdx];
    if (kind !== 0) {
      if (remaining === 1) return _PARENT_KIND_TYPE[kind] === expectedType;
      const next = pd[curIdx];
      if (next === _NONE) return false;
      curIdx = next;
      remaining -= 2;
    } else {
      const next = pd[curIdx];
      if (next === _NONE) return false;
      curIdx = next;
      remaining -= 1;
    }
  }
  _ensureAdapter();
  return _nodeTypeAt(ast, curIdx) === expectedType;
}

/** Negation of `greatGrandparentTypeEq`. */
function greatGrandparentTypeNeq(node, expectedType) {
  return !greatGrandparentTypeEq(node, expectedType);
}

// ── Per-accessor type/name helpers ────────────────────────────────
//
// Substitutes `node.<accessor>.type === <Lit>` (and `name`, `!==`) for
// hot accessor chains. Each helper:
//   1. Bails to the public getter on non-NodeView inputs (synthetic
//      wrappers, missing `_ast`, `_tag` undefined).
//   2. For COMMON tag shapes where the child's buffer index is at a
//      known lhs/rhs slot, reads the buffer directly — no NodeView
//      allocation for the child.
//   3. For unusual tag shapes (e.g. for-in/of's `left` is in extra
//      data, not lhs), falls back to `node.<accessor>?.type === expected`.
//
// The buffer-direct path skips one `nodeView()` call per matched site,
// which removes a pool lookup + (on cache miss) a `_NodeView` ctor.
// Same correctness model as the parent.type helpers.

function _isNodeView(node) {
  return node && node._i !== undefined && node._tag !== undefined && node._ast;
}

// Helper: look up the type at a buffer node index. Returns undefined
// if idx is _NONE.
function _typeAt(ast, idx) {
  if (idx === _NONE) return undefined;
  return _nodeTypeAt(ast, idx);
}

// Helper: identifier name at idx, or undefined if not an identifier.
function _identNameAt(ast, idx) {
  if (idx === _NONE) return undefined;
  const tag = ast._nodeTags[idx];
  if (tag !== _T.identifier && tag !== _T.property_ident) return undefined;
  return ast._identAt(ast._mainTokens[idx]);
}

// node.callee — CallExpression, NewExpression: callee is at lhs.
//                TaggedTemplateExpression: tag is at lhs.
// All three use `nodeView` (TaggedTemplate) or `nodeViewChain`. For the
// ChainExpression-wrap case (callee is itself an optional chain) the
// wrapper would re-route `.type` to "ChainExpression"; we approximate
// by reading the inner callee's tag directly. If that produces wrong
// answers for a specific rule, the fall-back to `node.callee?.type`
// guards correctness — but the rewriter only emits the helper when
// the rule does a static `=== "<X>"` compare; ChainExpression as the
// expected literal is uncommon and still works (the inner is the
// `_parentKinds`-flagged node so its type-as-rendered would be
// "ChainExpression" anyway).
function _calleeIdx(node) {
  const t = node._tag;
  const ast = node._ast;
  if (t === _T.call_expr || t === _T.optional_call_expr || t === _T.new_expr) {
    return ast.nodeLhs(node._i);
  }
  return -1;
}

function calleeTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.callee?.type === expectedType;
  const idx = _calleeIdx(node);
  if (idx < 0) return node.callee?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function calleeTypeNeq(node, expectedType) { return !calleeTypeEq(node, expectedType); }

function calleeNameEq(node, expectedName) {
  if (!_isNodeView(node)) return node?.callee?.name === expectedName;
  const idx = _calleeIdx(node);
  if (idx < 0) return node.callee?.name === expectedName;
  return _identNameAt(node._ast, idx) === expectedName;
}
function calleeNameNeq(node, expectedName) { return !calleeNameEq(node, expectedName); }

// node.id — FunctionDeclaration, FunctionExpression, ClassDeclaration,
//           ClassExpression, VariableDeclarator: id is at lhs of the
//           function/class extra block, or directly at lhs.
//           Function: lhs is FnData extra; id is FnData.id.
//           VariableDeclarator: lhs is the id directly.
//           Class: lhs is ClassData extra; id is ClassData.id.
function _idIdx(node) {
  const t = node._tag;
  const ast = node._ast;
  if (t === _T.fn_decl || t === _T.async_fn_decl ||
      t === _T.generator_fn_decl || t === _T.async_generator_fn_decl ||
      t === _T.fn_expr || t === _T.async_fn_expr ||
      t === _T.generator_fn_expr || t === _T.async_generator_fn_expr ||
      t === _T.ts_declare_function) {
    const lhs = ast.nodeLhs(node._i);
    if (lhs === _NONE) return _NONE;
    const d = ast.extraFnData(lhs);
    return d.id;
  }
  if (t === _T.class_decl || t === _T.class_expr) {
    const lhs = ast.nodeLhs(node._i);
    if (lhs === _NONE) return _NONE;
    const d = ast.extraClassData(lhs);
    return d.id;
  }
  if (t === _T.declarator) {
    // VariableDeclarator: id is at lhs.
    return ast.nodeLhs(node._i);
  }
  return -1;
}

function idNameEq(node, expectedName) {
  if (!_isNodeView(node)) return node?.id?.name === expectedName;
  const idx = _idIdx(node);
  if (idx < 0) return node.id?.name === expectedName;
  return _identNameAt(node._ast, idx) === expectedName;
}
function idNameNeq(node, expectedName) { return !idNameEq(node, expectedName); }

// node.expression — ExpressionStatement: expression is at rhs.
//                   ChainExpression (synthetic): expression is `.expression`
//                     (the inner node), but ChainExpression is a wrapper
//                     so synthetic-node check covers that.
function _expressionIdx(node) {
  const t = node._tag;
  // ExpressionStatement: expression is at lhs (per the canonical
  // accessor at js/estree-adapter.js:3328).
  if (t === _T.expression_stmt) return node._ast.nodeLhs(node._i);
  return -1;
}

function expressionTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.expression?.type === expectedType;
  const idx = _expressionIdx(node);
  if (idx < 0) return node.expression?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function expressionTypeNeq(node, expectedType) { return !expressionTypeEq(node, expectedType); }

// node.left / node.right — only safe for binary/logical/assign tags
// where lhs/rhs map directly. For-in/of, AssignmentPattern have
// indirect lookups; bail to slow path.
function _leftIdx(node) {
  const t = node._tag;
  if (t >= _T.add && t <= _T.nullish_assign) return node._ast.nodeLhs(node._i);
  if (t === _T.assignment_pattern) return node._ast.nodeLhs(node._i);
  return -1;
}
function _rightIdx(node) {
  const t = node._tag;
  if (t >= _T.add && t <= _T.nullish_assign) return node._ast.nodeRhs(node._i);
  return -1;
}

function leftTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.left?.type === expectedType;
  const idx = _leftIdx(node);
  if (idx < 0) return node.left?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function leftTypeNeq(node, expectedType) { return !leftTypeEq(node, expectedType); }

function rightTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.right?.type === expectedType;
  const idx = _rightIdx(node);
  if (idx < 0) return node.right?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function rightTypeNeq(node, expectedType) { return !rightTypeEq(node, expectedType); }

// node.argument — UnaryExpression, UpdateExpression, SpreadElement,
//                 RestElement, ReturnStatement, ThrowStatement,
//                 AwaitExpression, YieldExpression. Argument index
//                 lives at lhs or rhs depending on tag — replicate
//                 the existing accessor's logic for the common cases.
function _argumentIdx(node) {
  const t = node._tag;
  const ast = node._ast;
  // All of the following: argument is at LHS (verified against the
  // canonical `get argument()` accessor at js/estree-adapter.js:1850).
  if (t === _T.await_expr || t === _T.unary_plus || t === _T.unary_minus ||
      t === _T.logical_not || t === _T.bitwise_not || t === _T.typeof_expr ||
      t === _T.void_expr || t === _T.delete_expr ||
      t === _T.prefix_inc || t === _T.prefix_dec ||
      t === _T.postfix_inc || t === _T.postfix_dec ||
      t === _T.spread_element || t === _T.rest_element ||
      t === _T.yield_expr || t === _T.yield_delegate ||
      t === _T.return_stmt || t === _T.throw_stmt ||
      t === _T.ts_non_null_expr) {
    return ast.nodeLhs(node._i);
  }
  return -1;
}

function argumentTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.argument?.type === expectedType;
  const idx = _argumentIdx(node);
  if (idx < 0) return node.argument?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function argumentTypeNeq(node, expectedType) { return !argumentTypeEq(node, expectedType); }

// node.object — MemberExpression family: object is at lhs.
function _objectIdx(node) {
  const t = node._tag;
  if (t === _T.member_expr || t === _T.computed_member_expr ||
      t === _T.optional_member_expr || t === _T.optional_computed_member_expr) {
    return node._ast.nodeLhs(node._i);
  }
  return -1;
}

function objectTypeEq(node, expectedType) {
  if (!_isNodeView(node)) return node?.object?.type === expectedType;
  const idx = _objectIdx(node);
  if (idx < 0) return node.object?.type === expectedType;
  return _typeAt(node._ast, idx) === expectedType;
}
function objectTypeNeq(node, expectedType) { return !objectTypeEq(node, expectedType); }

module.exports = {
  someTypeEq, everyTypeEq, findTypeEq, indexedByProp,
  parentTypeEq, parentTypeNeq,
  grandparentTypeEq, grandparentTypeNeq,
  greatGrandparentTypeEq, greatGrandparentTypeNeq,
  calleeTypeEq, calleeTypeNeq, calleeNameEq, calleeNameNeq,
  idNameEq, idNameNeq,
  expressionTypeEq, expressionTypeNeq,
  leftTypeEq, leftTypeNeq, rightTypeEq, rightTypeNeq,
  argumentTypeEq, argumentTypeNeq,
  objectTypeEq, objectTypeNeq,
};

// Bun's CJS↔ESM interop: when this file is loaded via `import * as _ezHelpers`,
// Bun maps `module.exports`'s keys onto the namespace. Both forms work.
