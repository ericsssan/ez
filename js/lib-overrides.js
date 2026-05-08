"use strict";
//
// Load-time swap of selected helpers from libraries that ESLint rules depend on.
// Re-implements hot paths using ez's native primitives (direct buffer reads,
// numeric tag compares) rather than going through ESTree-shaped property
// getters. The swap is a feasibility prototype — a JS-side demonstration that
// (a) the require-cache patch reaches every consumer of the helper,
// (b) the re-implementation is observably equivalent on the differential corpus,
// (c) future Zig-backed implementations only need to slot a NAPI call into the
//     same JS shim — the swap mechanism itself is unchanged.
//
// Loaded once at startup before any rule's `require()` resolves the helper
// module. Subsequent `require('eslint/lib/rules/utils/ast-utils')` returns the
// same exports object with our overrides in place; rules that destructure
// `const { getStaticPropertyName } = require(...)` capture the patched
// reference at top-level evaluation time.

const path = require("node:path");
const T = require("./tags").T;

// Helper-tag bitsets. AoS Set<number>.has() is fast and IC-friendly.
const _MEMBER_EXPR_TAGS = new Set([
  T.member_expr, T.computed_member_expr,
  T.optional_member_expr, T.optional_computed_member_expr,
]);
const _MEMBER_EXPR_COMPUTED_TAGS = new Set([
  T.computed_member_expr, T.optional_computed_member_expr,
]);
// Property-like nodes whose `key` is at lhs in the ez buffer. The `computed`
// flag is implicit in the tag (computed_* variants).
const _PROPERTY_KEY_LHS_TAGS = new Set([
  T.property, T.shorthand_property, T.computed_property,
  T.method_def, T.computed_method_def,
  T.getter_def, T.computed_getter_def,
  T.setter_def, T.computed_setter_def,
  T.constructor_def,
  T.ts_property_signature, T.ts_method_signature,
]);
const _PROPERTY_LIKE_COMPUTED_TAGS = new Set([
  T.computed_property, T.computed_method_def,
  T.computed_getter_def, T.computed_setter_def,
]);

const NONE = 0xFFFFFFFF;

// Resolve and warm the require cache. Subsequent `require(samePath)` returns
// the already-loaded `module.exports` object — patches we apply now propagate
// to every later consumer (including those that destructure at top level).
const _astUtilsPath = require.resolve(
  path.join(__dirname, "node_modules/eslint/lib/rules/utils/ast-utils")
);
const astUtils = require(_astUtilsPath);

// Save originals for fallback paths and for benches that compare delta.
const _origGetStaticPropertyName = astUtils.getStaticPropertyName;
const _origGetStaticStringValue  = astUtils.getStaticStringValue;

// Native re-implementation of `getStaticPropertyName`.
//
// Original (eslint/lib/rules/utils/ast-utils.js:304) walks ESTree node types
// via string compares: `node.type === "MemberExpression"`, etc. Our version
// reads the ez tag (a u8) and compares numerically — same observable result,
// fewer property-getter hops.
//
// Falls back to the original implementation for nodes without an ez `_ast`
// (synthetic wrappers like JSXOpeningElement) or with tags we don't yet
// special-case. Correctness is gated by the differential corpus.
function _ezGetStaticPropertyName(node) {
  if (!node) return null;
  const ast = node._ast;
  if (!ast || node._i === undefined) return _origGetStaticPropertyName(node);

  const tags = ast._nodeTags;
  const tag = tags[node._i];

  // Resolve the property/key node index in one tag-bucket lookup.
  let propIdx, computed;
  if (_MEMBER_EXPR_TAGS.has(tag)) {
    propIdx = ast.nodeRhs(node._i);                    // .property is rhs
    computed = _MEMBER_EXPR_COMPUTED_TAGS.has(tag);
  } else if (_PROPERTY_KEY_LHS_TAGS.has(tag)) {
    propIdx = ast.nodeLhs(node._i);                    // .key is lhs
    computed = _PROPERTY_LIKE_COMPUTED_TAGS.has(tag);
  } else {
    // ChainExpression, unknown shapes, synthetic nodes — original handles them.
    return _origGetStaticPropertyName(node);
  }

  if (propIdx === NONE) return null;

  const propTag = tags[propIdx];
  // Most common case (~90%+ of calls): plain identifier in non-computed
  // position. ESTree exposes both `T.identifier` (variable/binding refs)
  // and `T.property_ident` (member-access property names) as `Identifier`;
  // we must accept both here. Read source text via the lex helper.
  if ((propTag === T.identifier || propTag === T.property_ident) && !computed) {
    return ast._identAt(ast._mainTokens[propIdx]);
  }

  // Fall back to the original `getStaticStringValue` for the long tail —
  // string/number/bigint literals, template literals, unary-minus literals,
  // null/true/false. Re-implementing all of those in JS would just be a
  // mechanical port; the speedup vs the original is already captured by
  // the identifier-path above (the dominant case in real codebases).
  // Wrap the prop index in a NodeView so the original receives the
  // ESTree-shaped input it expects.
  const propNode = _nodeView(ast, propIdx);
  return _origGetStaticStringValue(propNode);
}

// Lazy-import nodeView via estree-adapter to avoid a circular require at
// module load. Resolved on first call.
let _nodeView = null;
{
  const { nodeView } = require("./estree-adapter");
  _nodeView = nodeView;
}

// Install. The override survives across `require(...)` calls because CJS
// caches the exports object by resolved path; our mutation is on the
// shared instance. Verified by the differential corpus.
astUtils.getStaticPropertyName = _ezGetStaticPropertyName;

// Diagnostic counters — exposed for bench / sanity checks. Not needed in
// production. EZ_TRACE_OVERRIDES=1 enables a one-shot stderr line on first
// call so smoke tests can confirm the swap took effect.
let _hits = 0;
if (process.env.EZ_TRACE_OVERRIDES === "1") {
  const wrapped = astUtils.getStaticPropertyName;
  astUtils.getStaticPropertyName = function (node) {
    if (++_hits === 1) {
      process.stderr.write("[ez:lib-overrides] getStaticPropertyName intercepted\n");
    }
    return wrapped(node);
  };
}

module.exports = {
  _interceptCount: () => _hits,
  _origGetStaticPropertyName,
};
