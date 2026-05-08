"use strict";
//
// === ez build-time substitute for @es-joy/jsdoccomment/dist/index.cjs.cjs ===
//
// `findJSDocComment(node, sourceCode, settings, opts)` is called by every
// rule in `eslint-plugin-jsdoc` once per AST node it inspects. Across 30+
// jsdoc rules each scanning every FunctionDeclaration / ClassDeclaration
// / ExportNamedDeclaration / etc., the same `(sourceCode, node)` tuple
// is queried dozens of times per file. Each call walks tokens backward
// via `sourceCode.getTokenBefore(...)` (a binary search + token
// materialization in our `eslint-runner.js`).
//
// This substitute wraps `findJSDocComment` (and `getJSDocComment` which
// invokes it) with a per-(sourceCode, node, settings, opts) memo. First
// rule pays full cost; rules 2..N for the same node hit the cache.
//
// The substitute's compiled `__filename` is the UPSTREAM path (the
// runtime loader rebases via `Module._compile` so relative requires
// resolve from the upstream dir). We read the upstream bytes via
// `fs.readFileSync(__filename)` and compile a private Module so we can
// access the original exports without re-entering our own cache.

const fs = require("fs");
const path = require("path");
const Module = require("module");

const _upstreamCode = fs.readFileSync(__filename, "utf8");
const _privateModule = new Module(__filename, module);
_privateModule.filename = __filename;
_privateModule.paths = Module._nodeModulePaths(path.dirname(__filename));
_privateModule._compile(_upstreamCode, __filename);
const _upstream = _privateModule.exports;

// Per-sourceCode → per-node → list of (settings/opts key → result) entries.
// WeakMap on sourceCode so caches GC with the lint run; inner Map on node
// so we can store multiple entries when a single (sourceCode, node) is
// queried with different settings/opts (rare in practice).
const _findCache = new WeakMap();

function _memoizedFindJSDocComment(astNode, sourceCode, settings, opts) {
  if (!sourceCode || !astNode) {
    return _upstream.findJSDocComment(astNode, sourceCode, settings, opts);
  }
  let byNode = _findCache.get(sourceCode);
  if (!byNode) {
    byNode = new WeakMap();
    _findCache.set(sourceCode, byNode);
  }
  const s = settings || {};
  const o = opts || {};
  const minL = s.minLines ?? 0;
  const maxL = s.maxLines ?? 1;
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
  const result = _upstream.findJSDocComment(astNode, sourceCode, settings, opts);
  entries.push([minL, maxL, nonJ, result]);
  return result;
}

// `getJSDocComment` is the higher-level entry that delegates to
// `findJSDocComment` (after `getReducedASTNode`). Many rules call this
// instead of `findJSDocComment` directly. Memoize here too — the
// reduction is deterministic per (sourceCode, node, settings) so the
// same triple gets the same comment.
const _getCache = new WeakMap();

function _memoizedGetJSDocComment(sourceCode, node, settings, opts) {
  if (!sourceCode || !node) {
    return _upstream.getJSDocComment(sourceCode, node, settings, opts);
  }
  let byNode = _getCache.get(sourceCode);
  if (!byNode) {
    byNode = new WeakMap();
    _getCache.set(sourceCode, byNode);
  }
  const s = settings || {};
  const o = opts || {};
  const minL = s.minLines ?? 0;
  const maxL = s.maxLines ?? 1;
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
  const result = _upstream.getJSDocComment(sourceCode, node, settings, opts);
  entries.push([minL, maxL, ckOv, result]);
  return result;
}

// Re-export everything from upstream, override the two memoized entries.
module.exports = Object.assign({}, _upstream, {
  findJSDocComment: _memoizedFindJSDocComment,
  getJSDocComment: _memoizedGetJSDocComment,
});
