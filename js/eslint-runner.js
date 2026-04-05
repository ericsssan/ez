"use strict";

const { nodeView, NONE, effectiveTypeName, T } = require("./estree-adapter");
let _tsServices = null;
function tsServices() {
  if (!_tsServices) {
    try { _tsServices = require("./ts-services"); } catch { _tsServices = null; }
  }
  return _tsServices;
}
let _esquery = null;
function esquery() {
  if (!_esquery) {
    try { _esquery = require("./node_modules/esquery"); } catch { _esquery = null; }
  }
  return _esquery;
}
const _selectorParseCache = new Map();

// ── defaultOptions deep merge ───────────────────────────────────
// Mirrors ESLint's getRuleOptions / deepMergeArrays so that rules with
// meta.defaultOptions get the correct merged options when user options
// are a partial override (e.g. [] means "use all defaults").
function _deepMergeObjects(first, second) {
  if (second === undefined) return first;
  if (typeof first !== "object" || first === null || Array.isArray(first) ||
      typeof second !== "object" || second === null || Array.isArray(second))
    return second;
  const result = { ...first, ...second };
  for (const key of Object.keys(second)) {
    if (Object.prototype.propertyIsEnumerable.call(first, key))
      result[key] = _deepMergeObjects(first[key], second[key]);
  }
  return result;
}
function _deepMergeArrays(first, second) {
  if (!first || !second) return second || first || [];
  return [
    ...first.map((v, i) => _deepMergeObjects(v, i < second.length ? second[i] : undefined)),
    ...second.slice(first.length),
  ];
}
// Compute the effective rule options: merge defaultOptions with user-supplied options.
function _mergeRuleOptions(defaultOptions, configured) {
  if (configured === undefined) return defaultOptions ?? [];
  return _deepMergeArrays(defaultOptions ?? [], configured);
}

// ── ecmaVersion normalization ────────────────────────────────────
// Matches ESLint's normalizeEcmaVersionForLanguageOptions:
// short form (3,5,6..13) → year form (3,5,2015..2022).
function _normalizeEcmaVersion(v) {
  if (!v) return 2022;
  if (v === 3 || v === 5) return v;
  return v >= 2015 ? v : v + 2009;
}

// Minimum ecmaVersion (year) for globals that were added after ES5.
// Globals not in this map were available since ES3/5 (pre-ES2015).
const _GLOBAL_MIN_VERSION = {
  // ES2015 (ES6)
  Symbol: 2015, Promise: 2015, Proxy: 2015, Reflect: 2015, Map: 2015, Set: 2015,
  WeakMap: 2015, WeakSet: 2015, ArrayBuffer: 2015, DataView: 2015,
  Int8Array: 2015, Uint8Array: 2015, Uint8ClampedArray: 2015,
  Int16Array: 2015, Uint16Array: 2015, Int32Array: 2015, Uint32Array: 2015,
  Float32Array: 2015, Float64Array: 2015,
  // ES2017
  Atomics: 2017, SharedArrayBuffer: 2017,
  // ES2020
  BigInt: 2020, BigInt64Array: 2020, BigUint64Array: 2020, globalThis: 2020,
  // ES2021
  WeakRef: 2021, FinalizationRegistry: 2021, AggregateError: 2021,
};

// ── ES2022 built-in globals ─────────────────────────────────────
// Added to the global scope so no-undef doesn't flag these as undeclared.
// Matches ESLint's default globals (es2022 environment).
const _BUILTIN_GLOBALS = [
  // Values
  'NaN', 'Infinity', 'undefined', 'globalThis',
  // Functions
  'eval', 'isFinite', 'isNaN', 'parseFloat', 'parseInt',
  'decodeURI', 'decodeURIComponent', 'encodeURI', 'encodeURIComponent',
  // Constructors / namespaces
  'Object', 'Function', 'Boolean', 'Symbol', 'Number', 'BigInt', 'Math', 'Date',
  'String', 'RegExp', 'Array', 'Int8Array', 'Uint8Array', 'Uint8ClampedArray',
  'Int16Array', 'Uint16Array', 'Int32Array', 'Uint32Array',
  'Float32Array', 'Float64Array', 'BigInt64Array', 'BigUint64Array',
  'Map', 'Set', 'WeakMap', 'WeakSet', 'WeakRef', 'FinalizationRegistry',
  'ArrayBuffer', 'SharedArrayBuffer', 'DataView', 'Atomics',
  'JSON', 'Promise', 'Proxy', 'Reflect',
  'Error', 'AggregateError', 'EvalError', 'RangeError', 'ReferenceError',
  'SyntaxError', 'TypeError', 'URIError',
  'console', 'setTimeout', 'clearTimeout', 'setInterval', 'clearInterval',
  'queueMicrotask', 'structuredClone', 'atob', 'btoa',
  'URL', 'URLSearchParams', 'TextEncoder', 'TextDecoder',
  'AbortController', 'AbortSignal', 'Event', 'EventTarget',
  'FormData', 'Headers', 'Request', 'Response', 'fetch',
  'crypto', 'performance', 'navigator',
];

// ── Interned String Table ────────────────────────────────────────
// Pre-intern all ESTree type name strings so identity comparisons (===)
// on node.type are O(1) pointer checks, not string byte comparisons.
// V8 already interns short strings in most cases, but explicitly caching
// guarantees it and enables fast Map/Set lookups with interned keys.

const _internedStrings = new Map();

function _intern(str) {
  if (!str) return str;
  let interned = _internedStrings.get(str);
  if (interned === undefined) {
    interned = str;
    _internedStrings.set(str, str);
  }
  return interned;
}

// ── Helpers ──────────────────────────────────────────────────────

// Returns true if a function AST node has a 'use strict' directive as its first body statement.
// Used to detect strict mode when Zig's SF_HAS_USE_STRICT flag isn't set (module-mode wrapper bug).
function _fnHasUseStrict(fnNode) {
  const body = fnNode.body;
  if (!body || body.type !== 'BlockStatement') return false;
  const stmts = body.body;
  if (!stmts || stmts.length === 0) return false;
  const first = stmts[0];
  return first.type === 'ExpressionStatement' &&
    first.expression?.type === 'Literal' &&
    first.expression?.value === 'use strict';
}

// Tags that act as destructuring pass-through nodes (not the declaring node).
const _DESTRUCTURE_TAGS = new Set([
  T.property, T.shorthand_property, T.computed_property,
  T.object_pattern, T.array_pattern,
  T.assignment_pattern, T.rest_element, T.spread_element,
]);
// Tags that create function scope (including methods/getters/setters).
const _FN_TAGS = new Set([
  T.fn_decl, T.async_fn_decl, T.generator_fn_decl, T.async_generator_fn_decl,
  T.fn_expr, T.async_fn_expr, T.generator_fn_expr, T.async_generator_fn_expr,
  T.arrow_fn, T.async_arrow_fn,
  T.method_def, T.getter_def, T.setter_def, T.constructor_def,
  T.computed_method_def, T.computed_getter_def, T.computed_setter_def,
]);
const _CLASS_TAG_SET = new Set([T.class_decl, T.class_expr]);

/**
 * Walk up from declNode to find the correct ESLint def.node for a given def type.
 */
function _findDefNode(declNode, defType) {
  if (!declNode) return null;
  let cur = declNode.parent;
  switch (defType) {
    case 'Variable':
      while (cur) {
        if (cur._tag === T.declarator) return cur;
        if (!_DESTRUCTURE_TAGS.has(cur._tag)) break;
        cur = cur.parent;
      }
      break;
    case 'FunctionName':
      while (cur) { if (_FN_TAGS.has(cur._tag)) return cur; cur = cur.parent; }
      break;
    case 'ClassName':
      while (cur) { if (_CLASS_TAG_SET.has(cur._tag)) return cur; cur = cur.parent; }
      break;
    case 'ImportBinding':
      while (cur) { if (cur._tag === T.import_decl) return cur; cur = cur.parent; }
      break;
    case 'Parameter':
      while (cur) { if (_FN_TAGS.has(cur._tag)) return cur; cur = cur.parent; }
      break;
    case 'CatchClause':
      while (cur) { if (cur._tag === T.catch_clause) return cur; cur = cur.parent; }
      break;
  }
  return declNode;
}

/**
 * Binary-search lineStarts array to find the 1-based line number for pos.
 */
function _findLine(ls, pos) {
  let lo = 0, hi = ls.length - 1;
  while (lo < hi) {
    const mid = (lo + hi + 1) >> 1;
    if (ls[mid] <= pos) lo = mid;
    else hi = mid - 1;
  }
  return lo + 1; // 1-indexed
}

/**
 * Map sanz token tag to ESLint token type string.
 * Token tag enum (from token.zig):
 *   0-1  = number/bigint literals  → Numeric
 *   2    = string literal           → String
 *   3-6  = template literals        → Template
 *   7    = regex literal            → RegularExpression
 *   8    = identifier               → Identifier
 *   9-71 = keywords (JS + TS)       → Keyword
 *   72+  = punctuation + operators  → Punctuator
 *   131  = eof                      → (not emitted)
 */
function _tokType(tag) {
  if (tag <= 1) return 'Numeric';
  if (tag === 2) return 'String';
  if (tag <= 6) return 'Template';
  if (tag === 7) return 'RegularExpression';
  if (tag === 8) return 'Identifier';
  if (tag <= 71) return 'Keyword';
  return 'Punctuator';
}

// ── Scope flag bit positions (must match src/parser/scope.zig ScopeFlags) ─────
// packed struct(u16) { strict_mode, is_var_scope, has_use_strict, is_async, ... }
const SF_STRICT_MODE    = 1; // bit 0 — strict by any cause (module mode, use strict, class body)
const SF_HAS_USE_STRICT = 4; // bit 2 — has explicit 'use strict' directive in this scope

// ── Source Code ──────────────────────────────────────────────────

/**
 * Check if node i is a descendant of ancestorIdx using parent pointers.
 */
function _isDescendant(pd, i, ancestorIdx) {
  let cur = pd[i];
  while (cur !== NONE) {
    if (cur === ancestorIdx) return true;
    cur = pd[cur];
  }
  return false;
}

// Punctuator tags that are openers (start blocks/groups) — scan stops at these
// when encountered AFTER the initial opener position.
// Tags: l_brace=74, l_bracket=76, l_paren=72
// We allow these to continue scanning (they'll be balanced by closers).

// Closing/separator punctuator tags we DO continue scanning past:
// r_brace=75, r_bracket=77, r_paren=73, semicolon=78, comma=84
const SCAN_CONTINUE_TAGS = new Set([73, 75, 77, 78, 84]);

/**
 * Collect all token indices within a node's subtree, including structural
 * tokens (closing brackets, semicolons) that have no corresponding AST node.
 *
 * Algorithm:
 * 1. Look up precomputed maxTok for this node (O(1) via _maxTokCache)
 * 2. Scan forward from maxTok+1, including closing/separator punctuation
 * 3. Collect all tokens [startTok..endTok]
 *
 * Requires _maxTokCache to be populated (done lazily via _nodeEndPos).
 */
/** Build minTok cache: minimum main_token index in each node's subtree. */
function _computeMinTok(ast) {
  const n = ast.nodeCount;
  const pd = ast._parentData;
  const mt = ast._mainTokens;
  const minTok = new Int32Array(n);
  for (let i = 0; i < n; i++) minTok[i] = mt[i];
  if (pd) {
    for (let i = 1; i < n; i++) {
      const p = pd[i];
      if (p !== NONE && minTok[i] < minTok[p]) minTok[p] = minTok[i];
    }
  }
  ast._minTokCache = minTok;
}

function collectSubtreeTokens(ast, nodeIdx, result) {
  if (nodeIdx === NONE || nodeIdx >= ast.nodeCount) return;

  // Ensure caches are populated
  if (!ast._maxTokCache) ast._nodeEndPos(nodeIdx);
  if (!ast._minTokCache) _computeMinTok(ast);

  const tc = ast.tokenCount;
  const tags = ast._tokTags;

  const startTok = ast._minTokCache[nodeIdx];
  const maxTok = ast._maxTokCache[nodeIdx];

  // Scan forward past maxTok to include closing/separator tokens
  let endTok = maxTok;
  for (let t = maxTok + 1; t < tc; t++) {
    const tag = tags[t];
    if (tag === 131) break; // EOF
    if (SCAN_CONTINUE_TAGS.has(tag)) {
      endTok = t;
    } else {
      break;
    }
  }

  // Collect all token indices [startTok..endTok] into result
  for (let t = startTok; t <= endTok; t++) {
    if (!result.includes(t)) result.push(t);
  }
}

/**
 * ESLint-compatible SourceCode object.
 * Provides getText(), getTokens(), getFirstToken(), getLastToken().
 */
class SourceCode {
  constructor(ast, sourceText, sourceType, ecmaVersion) {
    this._ast = ast;
    this.text = sourceText;
    this._sourceType = sourceType || 'module';
    this._ecmaVersion = _normalizeEcmaVersion(ecmaVersion);
    // Expose runtime sourceType on the AST so node.sourceType returns correctly.
    // Zig always parses in module mode, so the buffer always says 'module'.
    ast._runtimeSourceType = this._sourceType;
    this._linesCache = null;
    this._tokensCache = null;
    this._scopeCache = new Map();
    this._thinScopeCache = new Map();
    this._thinVarCache = new Map();
    this._tokenSkipList = null; // lazily built token position index
  }

  reset(ast, sourceText, sourceType, ecmaVersion) {
    this._ast = ast;
    this.text = sourceText;
    this._sourceType = sourceType || 'module';
    this._ecmaVersion = _normalizeEcmaVersion(ecmaVersion);
    ast._runtimeSourceType = this._sourceType;
    this._linesCache = null;
    this._tokensCache = null;
    this._scopeCache.clear();
    this._thinScopeCache.clear();
    this._thinVarCache.clear();
    this._tokenSkipList = null;
    this._tokenObjCache = null;
    this._nodesByType = null;
    this.parserServices = null;
    // Scope indices are file-specific — must be cleared so _ensureScopeIndex rebuilds
    // for the new AST instead of returning stale data from the previous file.
    this._scopeSymIndex = null;
    this._scopeRefIndex = null;
    this._scopeChildIndex = null;
    this._symRefIndex = null;
    this._declSymIndex = null;
  }

  /**
   * Token skip-list: build a sparse index over token start positions.
   * Enables O(log n) binary search for getTokenBefore/After by position
   * instead of linear scanning from the anchor token.
   *
   * Returns a sorted Uint32Array of token start positions (same indices as _tokStarts).
   * Since _tokStarts is already sorted (tokens appear in source order),
   * we just cache a reference for the binary search helper.
   */
  _ensureTokenSkipList() {
    if (this._tokenSkipList) return this._tokenSkipList;
    // _tokStarts is already sorted by position — just cache it
    this._tokenSkipList = this._ast._tokStarts;
    return this._tokenSkipList;
  }

  /**
   * Binary search: find the token index whose start position is <= pos.
   * Returns the index in _tokStarts. O(log n).
   */
  _tokenIndexAtOrBefore(pos) {
    const starts = this._ensureTokenSkipList();
    const tc = this._ast.tokenCount;
    let lo = 0, hi = tc - 1;
    while (lo < hi) {
      const mid = (lo + hi + 1) >> 1;
      if (starts[mid] <= pos) lo = mid;
      else hi = mid - 1;
    }
    return lo;
  }

  /**
   * Build a token object with loc for token index i.
   * Cached to ensure identity equality: _makeToken(i) === _makeToken(i).
   * This is required for rules that compare token objects by reference.
   */
  _makeToken(i) {
    if (!this._tokenObjCache) this._tokenObjCache = new Array(this._ast.tokenCount);
    const cached = this._tokenObjCache[i];
    if (cached !== undefined) return cached;
    const ast = this._ast;
    const src = this.text;
    const start = ast._tokStarts[i];
    let end = i + 1 < ast.tokenCount ? ast._tokStarts[i + 1] : src.length;
    // Clamp end to the first comment that starts after this token, so that
    // trimming backwards does not walk through comment text into the token.
    const cs = ast._commentStarts;
    const cc = ast._commentCount || 0;
    if (cc > 0) {
      let lo = 0, hi = cc;
      while (lo < hi) { const m = (lo + hi) >> 1; if (cs[m] <= start) lo = m + 1; else hi = m; }
      if (lo < cc && cs[lo] < end) end = cs[lo];
    }
    while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    const value = src.slice(start, end);
    const ls = ast._lineStarts();
    const startLine = _findLine(ls, start);
    const startCol = start - ls[startLine - 1];
    const endLine = _findLine(ls, end);
    const endCol = end - ls[endLine - 1];
    const tok = {
      type: _tokType(ast._tokTags[i]),
      value,
      range: [start, end],
      loc: {
        start: { line: startLine, column: startCol },
        end: { line: endLine, column: endCol },
      },
      // Allow getTokenBefore/After to use this as a position anchor
      mainToken: i,
    };
    this._tokenObjCache[i] = tok;
    return tok;
  }

  /**
   * Get source text for a node.
   * Start is accurate; end is approximated via the next token.
   */
  getText(node) {
    if (!node) return this.text;
    const start = node.start;
    // Approximate end: find the next token that starts after node's main token
    const ast = this._ast;
    const mainTok = node.mainToken;
    let end = this.text.length;
    if (mainTok + 1 < ast.tokenCount) {
      end = ast._tokStarts[mainTok + 1];
    }
    // Remove trailing whitespace
    while (end > start && this.text.charCodeAt(end - 1) <= 32) end--;
    return this.text.slice(start, end);
  }

  /**
   * Get tokens within a node's subtree.
   * Returns array of token objects with type, value, range, loc.
   * Handles both NodeView objects (with _i) and synthetic token-anchored objects (mainToken only).
   */
  getTokens(node, filterOrOpts) {
    if (!node) return [];
    const ast = this._ast;
    // Synthetic node (e.g. property identifier): only one token
    if (node._i === undefined || node._i === null) {
      if (node.mainToken !== undefined) return [this._makeToken(node.mainToken)];
      return [];
    }
    // Use strict range: only tokens within [startTok, maxTok] — no forward-scan extension.
    // collectSubtreeTokens extends past maxTok to include trailing ); etc., which breaks
    // token-comparison rules like no-self-compare.
    if (!ast._maxTokCache) ast._nodeEndPos(node._i);
    if (!ast._minTokCache) _computeMinTok(ast);
    const startTok = ast._minTokCache[node._i];
    const maxTok   = ast._maxTokCache[node._i];
    const fn = filterOrOpts && typeof filterOrOpts.filter === 'function' ? filterOrOpts.filter : null;
    const toks = [];
    for (let t = startTok; t <= maxTok; t++) {
      const tok = this._makeToken(t);
      if (!fn || fn(tok)) toks.push(tok);
    }
    return toks;
  }

  getFirstToken(node, filterOrOpts) {
    if (!node) return null;
    if (node._i === undefined || node._i === null) {
      // Synthetic node — use range to scan tokens if available, else mainToken
      if (node.range) {
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        const ast = this._ast;
        const starts = ast._tokStarts;
        const tc = ast.tokenCount;
        // Binary search for first token at or after range[0]
        let lo = 0, hi = tc - 1;
        while (lo < hi) { const m = (lo + hi) >> 1; if (starts[m] < node.range[0]) lo = m + 1; else hi = m; }
        let skipped = 0;
        for (let t = lo; t < tc && starts[t] < node.range[1]; t++) {
          if (ast._tokTags[t] === 131) continue; // skip EOF
          const tok = this._makeToken(t);
          if (!fn || fn(tok)) { if (skipped >= skip) return tok; skipped++; }
        }
        return null;
      }
      if (node.mainToken !== undefined) {
        const tok = this._makeToken(node.mainToken);
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        return (!fn || fn(tok)) && skip === 0 ? tok : null;
      }
      return null;
    }
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    const ast = this._ast;
    if (!ast._minTokCache) _computeMinTok(ast);
    const startTok = ast._minTokCache[node._i];
    // Fast path: no filter, no skip — just return the first token
    if (!fn && skip === 0) return this._makeToken(startTok);
    // Slow path: filter/skip required — iterate forward from startTok
    if (!ast._maxTokCache) ast._nodeEndPos(node._i);
    const maxTok = ast._maxTokCache[node._i];
    const tags = ast._tokTags;
    const tc = ast.tokenCount;
    let endTok = maxTok;
    for (let t = maxTok + 1; t < tc; t++) {
      const tag = tags[t];
      if (tag === 131) break;
      if (SCAN_CONTINUE_TAGS.has(tag)) endTok = t;
      else break;
    }
    let skipped = 0;
    for (let t = startTok; t <= endTok; t++) {
      const tok = this._makeToken(t);
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  getLastToken(node, filterOrOpts) {
    if (!node) return null;
    if (node._i === undefined || node._i === null) {
      if (node.mainToken !== undefined) {
        const tok = this._makeToken(node.mainToken);
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        return (!fn || fn(tok)) && skip === 0 ? tok : null;
      }
      return null;
    }
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    const ast = this._ast;
    // Use the true end position (accounts for trailing } and matched brackets)
    // rather than the simple SCAN_CONTINUE_TAGS scan, which stops at l_brace (tag=74).
    const nodeEnd = ast._nodeEndPos(node._i);
    const starts = ast._tokStarts;
    const tc = ast.tokenCount;
    // Binary search: last token whose start position is strictly before nodeEnd
    let endTok = 0;
    let lo = 0, hi = tc - 1;
    while (lo <= hi) {
      const mid = (lo + hi) >> 1;
      if (starts[mid] < nodeEnd) { endTok = mid; lo = mid + 1; }
      else hi = mid - 1;
    }
    // Skip EOF
    while (endTok > 0 && ast._tokTags[endTok] === 131) endTok--;
    // Fast path: no filter, no skip
    if (!fn && skip === 0) return this._makeToken(endTok);
    // Slow path: iterate backwards
    const startTok = ast._mainTokens[node._i];
    let skipped = 0;
    for (let t = endTok; t >= startTok; t--) {
      const tok = this._makeToken(t);
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  /**
   * Normalize a filter argument that may be a function, number, or options object.
   * ESLint SourceCode token methods accept:
   *   getTokenAfter(node)
   *   getTokenAfter(node, filterFn)
   *   getTokenAfter(node, N)              — legacy: skip N tokens
   *   getTokenAfter(node, { filter?, count?, includeComments? })
   * Returns { fn, skip } where fn may be null (= no filter),
   * and skip = N tokens to skip from start/end.
   */
  _normalizeFilter(filterOrOpts) {
    if (!filterOrOpts && filterOrOpts !== 0) return { fn: null, skip: 0 };
    if (typeof filterOrOpts === 'function') return { fn: filterOrOpts, skip: 0 };
    if (typeof filterOrOpts === 'number') return { fn: null, skip: filterOrOpts };
    // Options object: ESLint uses {filter?, skip?, count?, includeComments?}
    return {
      fn: (typeof filterOrOpts.filter === 'function') ? filterOrOpts.filter : null,
      skip: filterOrOpts.skip || filterOrOpts.count || 0,
    };
  }

  getTokenBefore(node, filterOrOpts) {
    if (!node) return null;
    const ast = this._ast;
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) return null;
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    // Range-based fallback: when node.range[0] differs from mainToken start
    // (e.g. SequenceExpression whose mainToken is '('), binary-search for the
    // last token strictly before node.range[0].
    let anchorTok = mainTok - 1;
    if (node.range) {
      const nodeStart = node.range[0];
      if (ast._tokStarts[mainTok] !== nodeStart) {
        anchorTok = this._tokenIndexAtOrBefore(nodeStart - 1);
      }
    }
    if (anchorTok < 0) return null;
    if (!fn && skip === 0) return this._makeToken(anchorTok);
    let skipped = 0;
    for (let i = anchorTok; i >= 0; i--) {
      const tok = this._makeToken(i);
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  getTokenAfter(node, filterOrOpts) {
    if (!node) return null;
    const ast = this._ast;
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) return null;
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    // Default: one past the main token.
    let anchorTok = mainTok + 1;

    if (node._i !== undefined && node._i !== null) {
      // For real AST nodes: check if the subtree has tokens beyond mainToken
      // (i.e., it's a multi-token node like UnaryExpression `!a`). If so, use
      // range[1] to find the first token strictly after the entire node.
      // We detect multi-token via maxTok: if maxTok > mainTok, the subtree
      // extends past mainToken and mainToken+1 lands inside the node.
      if (!ast._maxTokCache) ast._nodeEndPos(node._i);
      const maxTok = ast._maxTokCache[node._i];
      if (maxTok !== undefined && maxTok > mainTok && node.range) {
        const nodeEnd = node.range[1];
        const starts = ast._tokStarts;
        let lo = 0, hi = ast.tokenCount - 1;
        anchorTok = ast.tokenCount;
        while (lo <= hi) {
          const mid = (lo + hi) >> 1;
          if (starts[mid] >= nodeEnd) { anchorTok = mid; hi = mid - 1; }
          else lo = mid + 1;
        }
      }
    } else if (node.range) {
      // Synthetic node or fallback: use range[1] if mainToken start != node start
      const nodeStart = node.range[0];
      if (ast._tokStarts[mainTok] !== nodeStart) {
        const nodeEnd = node.range[1];
        const starts = ast._tokStarts;
        let lo = 0, hi = ast.tokenCount - 1;
        anchorTok = ast.tokenCount;
        while (lo <= hi) {
          const mid = (lo + hi) >> 1;
          if (starts[mid] >= nodeEnd) { anchorTok = mid; hi = mid - 1; }
          else lo = mid + 1;
        }
      }
    }
    if (anchorTok >= ast.tokenCount) return null;
    if (!fn && skip === 0) return this._makeToken(anchorTok);
    let skipped = 0;
    for (let i = anchorTok; i < ast.tokenCount; i++) {
      const tok = this._makeToken(i);
      if (!fn || fn(tok)) {
        if (skipped >= skip) return tok;
        skipped++;
      }
    }
    return null;
  }

  /**
   * Find token at or near a source position using binary search.
   * O(log n) — useful for position-based queries.
   */
  getTokenAtPosition(pos) {
    const idx = this._tokenIndexAtOrBefore(pos);
    return this._makeToken(idx);
  }

  /**
   * Get the first token between two nodes that matches an optional filter.
   * Used by rules like eqeqeq to find the operator token.
   */
  getFirstTokenBetween(nodeA, nodeB, filterOrOpts) {
    if (!nodeA || !nodeB) return null;
    const ast = this._ast;
    const startTok = nodeA.mainToken + 1;
    const endTok = nodeB.mainToken;
    const { fn } = this._normalizeFilter(filterOrOpts);
    for (let i = startTok; i < endTok; i++) {
      const tok = this._makeToken(i);
      if (!fn || fn(tok)) return tok;
    }
    return null;
  }

  /**
   * Get all tokens between two nodes (inclusive optional).
   */
  getTokensBetween(nodeA, nodeB, filterOrOpts) {
    if (!nodeA || !nodeB) return [];
    const ast = this._ast;
    const startTok = nodeA.mainToken + 1;
    const endTok = nodeB.mainToken;
    const { fn } = this._normalizeFilter(filterOrOpts);
    const result = [];
    for (let i = startTok; i < endTok; i++) {
      const tok = this._makeToken(i);
      if (!fn || fn(tok)) result.push(tok);
    }
    return result;
  }

  /** All tokens in the file (cached). Excludes EOF (tag 131). */
  _getAllTokens() {
    if (this._tokensCache) return this._tokensCache;
    const result = [];
    const tags = this._ast._tokTags;
    for (let i = 0; i < this._ast.tokenCount; i++) {
      if (tags[i] !== 131) result.push(this._makeToken(i));
    }
    this._tokensCache = result;
    return result;
  }

  /**
   * tokensAndComments — all tokens (no real comments, stub includes only tokens).
   * Used by rules like no-multi-spaces, space-in-parens.
   */
  get tokensAndComments() {
    return this._getAllTokens();
  }

  /** Stub for getNodeByRangeIndex. */
  getNodeByRangeIndex() {
    return null;
  }

  /**
   * Get the scope containing a node. Uses real semantic data when available.
   */
  getScope(node) {
    const ast = this._ast;
    if (!ast._nodeScopeIds || !node) return this._stubScope();
    const nodeIdx = (node._i !== undefined && node._i !== null) ? node._i : -1;
    // Program node (root, index 0): always return the global scope (scope 0).
    // ESLint's eslint-scope maps getScope(Program) → global, not module.
    // The Zig side maps root to module (scope 1) because both share node 0.
    if (nodeIdx === 0) return this._buildScope(0);
    const scopeId = nodeIdx >= 0 ? ast._scopeForNode(nodeIdx) : 0;
    return this._buildScope(scopeId);
  }

  /**
   * Build the scope-to-symbols and scope-to-refs indices once, so _buildScope
   * doesn't scan all symbols/refs for every scope (O(scopes × data) → O(data)).
   */
  _ensureScopeIndex() {
    if (this._scopeSymIndex) return;
    const ast = this._ast;
    const scopeCount = ast._semScopeCount || 0;

    // scope → [symId, symId, ...] index
    const symIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) symIndex[i] = [];
    if (ast._symScopeIds) {
      for (let i = 0; i < ast._semSymbolCount; i++) {
        const s = ast._symScopeIds[i];
        if (s < scopeCount) symIndex[s].push(i);
      }
    }
    this._scopeSymIndex = symIndex;

    // scope → [refIdx, refIdx, ...] index
    const refIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) refIndex[i] = [];
    if (ast._refScopeIds) {
      for (let i = 0; i < ast._semRefCount; i++) {
        const s = ast._refScopeIds[i];
        if (s < scopeCount) refIndex[s].push(i);
      }
    }
    this._scopeRefIndex = refIndex;

    // scope → [childScopeId, ...] index
    const childIndex = new Array(scopeCount);
    for (let i = 0; i < scopeCount; i++) childIndex[i] = [];
    if (ast._scopeParents) {
      const NONE32 = 0xFFFFFFFF;
      for (let i = 0; i < scopeCount; i++) {
        const p = ast._scopeParents[i];
        if (p !== NONE32 && p < scopeCount) childIndex[p].push(i);
      }
    }
    this._scopeChildIndex = childIndex;

    // symbol → [refIdx, ...] index (avoids O(symbols × refs) scan in _buildVariable)
    const symRefIndex = new Array(ast._semSymbolCount || 0);
    for (let i = 0; i < symRefIndex.length; i++) symRefIndex[i] = [];
    if (ast._refSymbolIds) {
      const NONE32 = 0xFFFFFFFF;
      for (let i = 0; i < (ast._semRefCount || 0); i++) {
        const s = ast._refSymbolIds[i];
        if (s !== NONE32 && s < symRefIndex.length) symRefIndex[s].push(i);
      }
    }
    this._symRefIndex = symRefIndex;

    // declNode ancestor → [symId, ...] index for O(1) getDeclaredVariables lookups.
    // For each symbol, index it under its decl node AND all ancestor nodes up to the
    // nearest scope boundary (covers VariableDeclaration → Declarator → Identifier pattern).
    const declSymIndex = new Map();
    if (ast._symDeclNodes && ast._parentData) {
      const pd2 = ast._parentData;
      const tags2 = ast._nodeTags;
      const NONE32b = 0xFFFFFFFF;
      for (let i = 0; i < (ast._semSymbolCount || 0); i++) {
        const declNodeIdx = ast._symDeclNodes[i];
        if (declNodeIdx === NONE32b || declNodeIdx >= ast.nodeCount) continue;
        // Register at decl node itself and walk up to scope boundary
        let cur = declNodeIdx;
        while (cur !== NONE && cur !== NONE32b && cur < ast.nodeCount) {
          let arr = declSymIndex.get(cur);
          if (!arr) { arr = []; declSymIndex.set(cur, arr); }
          arr.push(i);
          const curTag = tags2[cur];
          if ((curTag >= 30 && curTag <= 34) || (curTag >= 63 && curTag <= 69) || _FN_TAGS.has(curTag)) break;
          cur = pd2[cur];
        }
      }
    }
    this._declSymIndex = declSymIndex;
  }

  /**
   * Build an ESLint-compatible scope object from the semantic data for a given scopeId.
   * Results are cached per SourceCode instance to avoid O(n²) rebuilds and
   * to break the parent↔child circular reference during construction.
   */
  _buildScope(scopeId) {
    const cached = this._scopeCache.get(scopeId);
    if (cached) return cached;

    const ast = this._ast;
    if (!ast._scopeKinds || scopeId === NONE || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }
    const NONE32 = 0xFFFFFFFF;
    const KIND_NAMES = ['global','module','function','block','class','catch','switch','static_block','with'];
    const kind = ast._scopeKinds[scopeId];
    const flags16 = ast._scopeFlags[scopeId];
    const parentId = ast._scopeParents[scopeId];

    // Ensure scope→symbol/ref/child indices are built (once per SourceCode).
    this._ensureScopeIndex();

    // Build variables: only symbols belonging to THIS scope (via precomputed index).
    const varMap = new Map();
    const symIds = this._scopeSymIndex[scopeId];
    if (symIds) {
      for (let j = 0; j < symIds.length; j++) {
        const v = this._buildVariable(symIds[j]);
        if (varMap.has(v.name)) {
          const existing = varMap.get(v.name);
          existing.identifiers.push(...v.identifiers);
          existing.defs.push(...v.defs);
          existing.references.push(...v.references);
        } else {
          varMap.set(v.name, v);
        }
      }
    }
    const variables = Array.from(varMap.values());

    // Build references: only refs from THIS scope (via precomputed index).
    const references = [];
    const through = [];
    const refIds = this._scopeRefIndex[scopeId];
    if (refIds) {
      for (let j = 0; j < refIds.length; j++) {
        const ref = this._buildReference(refIds[j]);
        references.push(ref);
        if (!ref.resolved) through.push(ref);
      }
    }

    const upper = parentId === NONE32 ? null : this._buildScope(parentId);
    const set = new Map(varMap);

    // block = the AST node that created this scope (for require-atomic-updates)
    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE;
    const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;

    const isVarScope = kind === 0 || kind === 1 || kind === 2; // global, module, function

    // In script mode, isStrict comes from an explicit 'use strict' directive in this
    // scope or inherited from an ancestor — NOT from module-mode wrapping.
    // Class bodies (kind 4) and static blocks (kind 7) are always strict per spec.
    const isAlwaysStrict = kind === 4 || kind === 7;
    // Detect 'use strict' directive by checking the function body's first statement,
    // since Zig's analyze() always uses module mode so SF_HAS_USE_STRICT is never set.
    const hasUseStrict = kind === 2 && block !== null && _fnHasUseStrict(block);
    // Function expressions in a class extends clause are always strict per spec
    // (class heritage is evaluated in strict mode). Zig's scope parent for these
    // functions points to the module scope rather than the class scope, so we
    // need to detect this case explicitly.
    const inClassExtends = kind === 2 && block !== null &&
      block.parent !== null &&
      (block.parent.type === 'ClassDeclaration' || block.parent.type === 'ClassExpression') &&
      block.parent.superClass !== null && block.parent.superClass._i === block._i;
    const isStrict = isAlwaysStrict || inClassExtends || hasUseStrict || (
      this._sourceType === 'script'
        ? (flags16 & SF_HAS_USE_STRICT) !== 0 || !!(upper && upper.isStrict)
        : (flags16 & SF_STRICT_MODE) !== 0
    );

    const childScopes = [];
    const scope = {
      type: KIND_NAMES[kind] || 'block',
      isStrict,
      variables,
      set,
      references,
      through,
      childScopes,
      implicit: { variables: [] },
      block,
      upper,
      lookup(name) { return set.get(name) || null; },
    };
    scope.variableScope = isVarScope ? scope : (upper ? upper.variableScope || upper : scope);

    // Add ES2022 built-in globals to the global scope so rules like no-undef
    // don't flag NaN, undefined, Infinity, etc. as undeclared.
    if (kind === 0) { // global scope
      const ecmaVersion = this._ecmaVersion;
      for (const name of _BUILTIN_GLOBALS) {
        // Exclude globals that weren't available at the specified ecmaVersion.
        const minVer = _GLOBAL_MIN_VERSION[name];
        if (minVer !== undefined && ecmaVersion < minVer) continue;
        if (!set.has(name)) {
          const globalVar = { name, defs: [], references: [], identifiers: [],
            scope, eslintUsed: false, writeable: false,
            isRead: () => false, isWritten: () => false };
          set.set(name, globalVar);
          variables.push(globalVar);
        }
      }
    }

    // Add implicit 'arguments' to function scopes (non-arrow functions).
    // ESLint's eslint-scope provides 'arguments' as a built-in variable
    // in every function scope (except arrow functions).
    if (kind === 2 && !set.has('arguments')) { // kind 2 = function
      const argsVar = { name: 'arguments', defs: [], references: [], identifiers: [],
        scope, eslintUsed: false, writeable: false,
        isRead: () => false, isWritten: () => false };
      set.set('arguments', argsVar);
      variables.push(argsVar);
    }

    // Cache before building children to break the parent←→child cycle.
    this._scopeCache.set(scopeId, scope);

    // Populate childScopes via precomputed index (not full scan).
    const childIds = this._scopeChildIndex[scopeId];
    if (childIds) {
      for (let j = 0; j < childIds.length; j++) {
        childScopes.push(this._buildScope(childIds[j]));
      }
    }

    // Bubble unresolved references from child scopes into this scope's through
    // list, matching ESLint's eslint-scope behavior. A reference that is
    // unresolved in a child scope and also not resolved in this scope should
    // appear in through (so no-undef sees it on the global scope).
    // If the reference resolves to a variable in this scope (e.g., a built-in
    // global), link the reference to that variable.
    for (const child of childScopes) {
      for (const ref of child.through) {
        // Skip PrivateIdentifier references — they are class-scoped,
        // not normal variable references. no-undef should not see them.
        if (ref.identifier?.type === 'PrivateIdentifier') continue;
        const name = ref.identifier?.name;
        const variable = name ? set.get(name) : undefined;
        if (variable) {
          // Resolved by this scope — link reference to variable
          variable.references.push(ref);
          ref.resolved = variable;
        } else {
          through.push(ref);
        }
      }
    }

    return scope;
  }

  /**
   * Eagerly build all scopes upfront. This turns O(scopes × symbols) lazy
   * construction into a single O(symbols + refs + scopes) pass.
   * Called by the rule query optimizer when scope-aware rules are detected.
   */
  _precomputeScopes() {
    const ast = this._ast;
    if (!ast._scopeKinds) return;
    // Build all scopes bottom-up (children before parents are already handled
    // by the recursive _buildScope + cache). Just trigger the root scope.
    this._buildScope(0);
  }

  /** Build an ESLint Variable object for a symbol. */
  _buildVariable(symId) {
    const ast = this._ast;
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];
    const NONE32 = 0xFFFFFFFF;

    // SymbolFlags bits (matches symbol.zig):
    // 0=is_var, 1=is_let, 2=is_const, 3=is_function, 4=is_class,
    // 5=is_parameter, 6=is_catch_param, 7=is_import, 8=is_export,
    // 9=is_hoisted, 10=is_written, 11=is_read, 12=is_type_of, 13=is_implicit_global
    const is_param  = (flags16 & 0x20) !== 0;
    const is_const  = (flags16 & 0x04) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;

    // Build references for this symbol via precomputed index (O(refs_for_sym) not O(all_refs)).
    const references = [];
    this._ensureScopeIndex();
    const symRefs = this._symRefIndex ? this._symRefIndex[symId] : null;
    if (symRefs) {
      for (let j = 0; j < symRefs.length; j++) {
        references.push(this._buildReference(symRefs[j]));
      }
    }

    const declNodeIdx = ast._symDeclNodes[symId];
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;

    // Determine def type
    const is_catch = (flags16 & 0x40) !== 0;
    let defType = 'Variable';
    if (is_param) defType = 'Parameter';
    else if (is_catch) defType = 'CatchClause';
    else if ((flags16 & 0x08) !== 0) defType = 'FunctionName';
    else if ((flags16 & 0x10) !== 0) defType = 'ClassName';
    else if (is_import) defType = 'ImportBinding';

    // Map declNode (Identifier) to the ESLint-expected def.node and def.parent:
    //   Variable:    def.name=Identifier, def.node=VariableDeclarator, def.parent=VariableDeclaration
    //   CatchClause: def.name=Identifier, def.node=Identifier, def.parent=TryStatement
    //   Parameter:   def.name=Identifier, def.node=Identifier, def.parent=FunctionDeclaration
    //   FunctionName:def.name=Identifier, def.node=FunctionDeclaration, def.parent=container
    //   ClassName:   def.name=Identifier, def.node=ClassDeclaration, def.parent=container
    //   ImportBinding: def.name=Identifier, def.node=ImportSpecifier, def.parent=ImportDeclaration
    let defNode = declNode ? _findDefNode(declNode, defType) : null;
    const defs = declNode ? [{ type: defType, name: declNode, node: defNode, parent: defNode ? defNode.parent || null : null }] : [];

    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    // Use a thin scope (no variables) to avoid infinite recursion.
    // variable.scope is used primarily for variableScope chain traversal.
    // Cached via _thinScopeCache so same scopeId always returns the same object,
    // required for prefer-const's `writer.from === variable.scope` identity check.
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();

    // Synthesize an init-write reference for let/const variables that have an initializer.
    // The Zig semantic analyzer only tracks explicit write references (assignments),
    // but ESLint's prefer-const also needs the initializer tracked as a write reference.
    // For destructured patterns (let {a, b} = obj), the identifier's immediate parent is
    // a property/shorthand_property/object_pattern/array_pattern, not the VariableDeclarator.
    // Walk up through destructuring nodes to find the enclosing VariableDeclarator.
    const is_let = (flags16 & 0x02) !== 0;
    if ((is_let || is_const) && declNodeIdx !== undefined && declNodeIdx !== NONE && ast._parentData) {
      let curIdx = ast._parentData[declNodeIdx];
      let initAdded = false;
      while (!initAdded && curIdx !== undefined && curIdx !== NONE && curIdx < ast.nodeCount) {
        const curTag = ast._nodeTags[curIdx];
        if (curTag === T.declarator) {
          const initNodeIdx = ast.nodeRhs(curIdx);
          if (initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) {
            const thin = this._buildThinVariable(symId);
            // Append (push) the init-write so that Zig-tracked refs (in source order)
            // come first. This ensures reads that precede the declaration in source order
            // appear before the init-write, allowing the prefer-const rule's
            // ignoreReadBeforeAssign option to see the read-before-write ordering.
            references.push({
              identifier: declNode,
              from: scope, // same object as variable.scope — required for prefer-const
              resolved: thin,
              writeExpr: nodeView(ast, initNodeIdx),
              init: true,
              isWrite: () => true,
              isRead: () => false,
              isWriteOnly: () => true,
              isReadOnly: () => false,
              isReadWrite: () => false,
            });
          }
          initAdded = true; // found declarator; stop regardless of whether init exists
        } else if (curTag === T.property || curTag === T.shorthand_property ||
                   curTag === T.computed_property || curTag === T.object_pattern ||
                   curTag === T.array_pattern || curTag === T.assignment_pattern ||
                   curTag === T.rest_element) {
          curIdx = ast._parentData[curIdx];
        } else {
          break;
        }
      }
    }

    return {
      name,
      defs,
      references,
      scope,
      identifiers: declNode ? [declNode] : [],
      eslintUsed: false,
      writeable: !is_const && !is_import,
      isRead: () => is_read,
      isWritten: () => is_written || is_let, // let vars are potentially writable
    };
  }

  /** Build an ESLint Reference object for a reference entry. */
  _buildReference(refIdx) {
    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    const symId = ast._refSymbolIds[refIdx];
    const kind  = ast._refKinds[refIdx];  // 0=read, 1=write, 2=read_write, 3=type_of
    const nodeIdx = ast._refNodeIds[refIdx];
    const refNode = (nodeIdx !== NONE32 && nodeIdx < ast.nodeCount)
      ? nodeView(ast, nodeIdx) : null;

    // Use thin variable for resolved to avoid recursive buildVariable→buildReference cycles.
    const resolved = symId !== NONE32 ? this._buildThinVariable(symId) : null;

    const refScopeId = ast._refScopeIds ? ast._refScopeIds[refIdx] : NONE;
    const from = (refScopeId !== undefined && refScopeId !== NONE32)
      ? this._buildThinScope(refScopeId) : this._stubScope();

    return {
      identifier: refNode,
      from,
      resolved,
      writeExpr: null,
      init: false,
      isWrite: () => kind === 1 || kind === 2,
      isRead:  () => kind === 0 || kind === 2 || kind === 3,
      isWriteOnly: () => kind === 1,
      isReadOnly:  () => kind === 0 || kind === 3,
      isReadWrite: () => kind === 2,
    };
  }

  /**
   * Build a thin Variable (no references) for use as reference.resolved.
   * Avoids cycles: _buildVariable → _buildReference → _buildVariable.
   */
  _buildThinVariable(symId) {
    const thinCached = this._thinVarCache.get(symId);
    if (thinCached !== undefined) return thinCached;
    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    if (!ast._symFlags || symId === NONE || symId === NONE32 || symId >= ast._semSymbolCount) { this._thinVarCache.set(symId, null); return null; }
    const name = ast._symName(symId);
    const flags16 = ast._symFlags[symId];
    const is_const  = (flags16 & 0x04) !== 0;
    const is_param  = (flags16 & 0x20) !== 0;
    const is_import = (flags16 & 0x80) !== 0;
    const is_read   = (flags16 & 0x800) !== 0;
    const is_written= (flags16 & 0x400) !== 0;
    const symScopeId = ast._symScopeIds ? ast._symScopeIds[symId] : NONE;
    const scope = (symScopeId !== undefined && symScopeId !== NONE32)
      ? this._buildThinScope(symScopeId) : this._stubScope();
    const is_catch = (flags16 & 0x40) !== 0;
    let defType = 'Variable';
    if (is_param) defType = 'Parameter';
    else if (is_catch) defType = 'CatchClause';
    else if ((flags16 & 0x08) !== 0) defType = 'FunctionName';
    else if ((flags16 & 0x10) !== 0) defType = 'ClassName';
    else if (is_import) defType = 'ImportBinding';
    const declNodeIdx = ast._symDeclNodes ? ast._symDeclNodes[symId] : NONE32;
    const declNode = (declNodeIdx !== NONE32 && declNodeIdx < ast.nodeCount)
      ? nodeView(ast, declNodeIdx) : null;
    let defNode = declNode ? _findDefNode(declNode, defType) : null;
    const thinVar = {
      name,
      defs: declNode ? [{ type: defType, name: declNode, node: defNode, parent: defNode ? defNode.parent || null : null }] : [],
      references: [], // thin — no refs to avoid cycle
      scope,
      identifiers: declNode ? [declNode] : [],
      eslintUsed: false,
      writeable: !is_const && !is_import,
      isRead: () => is_read,
      isWritten: () => is_written,
    };
    this._thinVarCache.set(symId, thinVar);
    return thinVar;
  }

  /**
   * Build a thin scope (no variables/references) for use as variable.scope.
   * Avoids infinite recursion: _buildScope → _buildVariable → _buildScope.
   * Thin scopes only provide chain structure: type, isStrict, upper, variableScope.
   * Results are cached so same scopeId → same object (required for === comparisons
   * in prefer-const: writer.from === variable.scope).
   */
  _buildThinScope(scopeId) {
    const cached = this._thinScopeCache.get(scopeId);
    if (cached) return cached;

    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    if (!ast._scopeKinds || scopeId === NONE || scopeId === NONE32 || scopeId >= ast._semScopeCount) {
      return this._stubScope();
    }
    const KIND_NAMES = ['global','module','function','block','class','catch','switch','static_block','with'];
    const kind = ast._scopeKinds[scopeId];
    const flags16 = ast._scopeFlags[scopeId];
    const parentId = ast._scopeParents[scopeId];
    const upper = (parentId !== NONE32) ? this._buildThinScope(parentId) : null;
    const isAlwaysStrict = kind === 4 || kind === 7;
    const isStrict = isAlwaysStrict || (
      this._sourceType === 'script'
        ? (flags16 & SF_HAS_USE_STRICT) !== 0 || !!(upper && upper.isStrict)
        : (flags16 & SF_STRICT_MODE) !== 0
    );
    const scopeNodeIdx = ast._scopeNodeIds ? ast._scopeNodeIds[scopeId] : NONE32;
    const block = (scopeNodeIdx !== undefined && scopeNodeIdx !== NONE32 && scopeNodeIdx < ast.nodeCount)
      ? nodeView(ast, scopeNodeIdx) : null;
    const isVarScope = kind === 0 || kind === 1 || kind === 2;
    const s = {
      type: KIND_NAMES[kind] || 'block', isStrict, variables: [], references: [],
      set: new Map(), through: [], childScopes: [], implicit: { variables: [] },
      block, upper, lookup: () => null,
    };
    s.variableScope = isVarScope ? s : (upper ? upper.variableScope || upper : s);
    this._thinScopeCache.set(scopeId, s);
    return s;
  }

  /** Fallback stub scope (no semantic data). */
  _stubScope() {
    const upper = { variables: [], references: [], through: [], set: new Map(),
                    isStrict: false, type: 'global', upper: null, block: null,
                    lookup: () => null };
    upper.variableScope = upper;
    const s = {
      variables: [], childScopes: [], references: [], through: [],
      set: new Map(), implicit: { variables: [] }, block: null,
      upper, isStrict: false, type: 'module', lookup: () => null,
    };
    s.variableScope = s;
    return s;
  }

  /**
   * Stub for isGlobalReference — returns false (no real scope analysis).
   */
  isGlobalReference() {
    return false;
  }

  /**
   * getDeclaredVariables — returns real symbol data for function/variable nodes.
   * Falls back to parameter stubs if no semantic data available.
   */
  getDeclaredVariables(node) {
    if (!node) return [];
    const ast = this._ast;

    // Use real semantic data if available — O(1) via precomputed _declSymIndex.
    if (ast._symDeclNodes && node._i !== undefined && node._i !== null) {
      this._ensureScopeIndex();
      const symIds = this._declSymIndex ? this._declSymIndex.get(node._i) : null;
      if (symIds && symIds.length > 0) {
        // Merge variables with the same name (e.g. duplicate params `function f(a,b,a)`).
        // ESLint scope analysis merges them into one variable with multiple defs.
        const varMap = new Map();
        for (const i of symIds) {
          const v = this._buildVariable(i);
          if (varMap.has(v.name)) {
            const ex = varMap.get(v.name);
            ex.identifiers.push(...v.identifiers);
            ex.defs.push(...v.defs);
            ex.references.push(...v.references);
          } else {
            varMap.set(v.name, v);
          }
        }
        return Array.from(varMap.values());
      }
      return [];
    }

    // Fallback: return param stubs with defs so rules don't crash
    const params = node.params;
    if (!params || !params.length) return [];
    return params.map(p => {
      const name = (p && p.name) || (p && p.id && p.id.name) || '';
      return { name, references: [], defs: [{ type: 'Parameter', node: p }], scope: null };
    });
  }

  /**
   * getCommentsInside — comments within the node's range.
   * Uses Zig-recorded comment positions with O(log n) binary search.
   */
  getCommentsInside(node) {
    if (!node || !node.range) return [];
    return this._ast.commentsInRange(node.range[0], node.range[1]);
  }

  /** getCommentsBefore — comments in the gap before a node. */
  getCommentsBefore(node) {
    if (!node || !node.range) return [];
    const start = node.range[0];
    const ast = this._ast;
    const starts = ast._tokStarts;
    let lo = 0, hi = ast.tokenCount - 1;
    while (lo < hi) { const m = (lo + hi + 1) >> 1; if (starts[m] < start) lo = m; else hi = m - 1; }
    const prevEnd = lo > 0 ? starts[lo] : 0;
    return ast.commentsInRange(prevEnd, start);
  }

  /** Stub for getCommentsAfter — returns empty array. */
  getCommentsAfter() {
    return [];
  }

  /**
   * commentsExistBetween — true if any comment exists between two nodes/tokens.
   */
  commentsExistBetween(a, b) {
    if (!a || !b) return false;
    const start = a.range ? a.range[1] : (a.end || 0);
    const end = b.range ? b.range[0] : (b.start || 0);
    return this._ast.commentsInRange(start, end).length > 0;
  }

  /**
   * getAllComments — all comment nodes in the file.
   * Used by rules like no-irregular-whitespace to filter out violations in comments.
   */
  getAllComments() {
    return this._ast.commentsInRange(0, this.text.length);
  }

  /**
   * getFirstTokens(node, N) — first N tokens of node.
   */
  getFirstTokens(node, countOrOpts) {
    const count = (typeof countOrOpts === 'number') ? countOrOpts :
                  (countOrOpts && countOrOpts.count) ? countOrOpts.count : 1;
    return this.getTokens(node).slice(0, count);
  }

  /**
   * getLastTokens(node, N) — last N tokens of node.
   */
  getLastTokens(node, countOrOpts) {
    const count = (typeof countOrOpts === 'number') ? countOrOpts :
                  (countOrOpts && countOrOpts.count) ? countOrOpts.count : 1;
    const toks = this.getTokens(node);
    return toks.slice(Math.max(0, toks.length - count));
  }

  /**
   * Get array of source lines (cached).
   */
  getLines() {
    return this.lines;
  }

  /** lines property — array of source lines */
  get lines() {
    if (!this._linesCache) this._linesCache = this.text.split(/\r\n|\r|\n|\u2028|\u2029/);
    return this._linesCache;
  }

  /**
   * ast property — Program node with .tokens and .comments arrays.
   * Used by rules like max-len, indent that access sourceCode.ast.tokens/comments.
   */
  get ast() {
    if (this._astObj) return this._astObj;
    const root = nodeView(this._ast, 0);
    const sc = this;
    // Attach a `tokens` lazy property directly on this instance
    const obj = Object.create(Object.getPrototypeOf(root));
    obj._ast = root._ast;
    obj._i = root._i;
    obj.comments = []; // no comments in sanz yet
    Object.defineProperty(obj, 'tokens', {
      get() { return sc._getAllTokens(); },
      configurable: true, enumerable: true,
    });
    this._astObj = obj;
    return obj;
  }

  /**
   * Stub for getIndexFromLoc — convert {line, column} to index.
   */
  getIndexFromLoc(loc) {
    const ls = this._ast._lineStarts();
    return ls[loc.line - 1] + loc.column;
  }

  /**
   * Check whether there is whitespace between two tokens/nodes.
   * Returns true if the end of tokenA and start of tokenB differ.
   */
  isSpaceBetween(nodeA, nodeB) {
    if (!nodeA || !nodeB) return false;
    const ast = this._ast;
    const endTok = (nodeA.mainToken !== undefined) ? nodeA.mainToken : -1;
    const startTok = (nodeB.mainToken !== undefined) ? nodeB.mainToken : -1;
    if (endTok < 0 || startTok < 0 || endTok >= startTok) return false;
    // Check if there's any whitespace between end of endTok and start of startTok
    const endPos = this._makeToken(endTok).range[1];
    const startPos = ast._tokStarts[startTok];
    return startPos > endPos;
  }

  /**
   * Stub for isNotWhitespace — checks if token value has non-whitespace.
   */
  isNotWhitespace(token) {
    return token && token.value.trim().length > 0;
  }

  /**
   * Stub for getLocFromIndex — convert index to {line, column}.
   */
  getLocFromIndex(idx) {
    const ls = this._ast._lineStarts();
    const line = _findLine(ls, idx);
    return { line, column: idx - ls[line - 1] };
  }

  /**
   * Returns ancestors of node from root to parent (not including node itself).
   * Compatible with ESLint v8+ sourceCode.getAncestors(node).
   */
  getAncestors(node) {
    const pd = this._ast._parentData;
    if (!pd || !node || node._i === undefined) return [];
    const ancestors = [];
    let parentIdx = pd[node._i];
    while (parentIdx !== NONE && parentIdx !== undefined && parentIdx < this._ast.nodeCount) {
      ancestors.unshift(nodeView(this._ast, parentIdx));
      parentIdx = pd[parentIdx];
    }
    return ancestors;
  }

  /** Alias: same as getTokenBefore (we don't separate comments from tokens). */
  getTokenOrCommentBefore(node, filterOrOpts) {
    return this.getTokenBefore(node, filterOrOpts);
  }

  /** Alias: same as getTokenAfter (we don't separate comments from tokens). */
  getTokenOrCommentAfter(node, filterOrOpts) {
    return this.getTokenAfter(node, filterOrOpts);
  }
}

// ── Fixer ────────────────────────────────────────────────────────

/**
 * ESLint-compatible fixer object passed to rule fix() functions.
 * Each method returns a { range: [start, end], text: string } fix descriptor.
 */
class RuleFixer {
  constructor(source) {
    this._source = source;
  }

  _rangeOf(nodeOrToken) {
    if (nodeOrToken.range) return nodeOrToken.range;
    const s = nodeOrToken.start ?? 0;
    const e = nodeOrToken.end ?? s;
    return [s, e];
  }

  /** Remove a node or token from the source. */
  remove(nodeOrToken) {
    return { range: this._rangeOf(nodeOrToken), text: '' };
  }

  /** Replace the source text of a node or token. */
  replaceText(nodeOrToken, text) {
    return { range: this._rangeOf(nodeOrToken), text };
  }

  /** Replace source text in a range [start, end]. */
  replaceTextRange(range, text) {
    return { range, text };
  }

  /** Insert text before a node or token. */
  insertTextBefore(nodeOrToken, text) {
    const [start] = this._rangeOf(nodeOrToken);
    return { range: [start, start], text };
  }

  /** Insert text after a node or token. */
  insertTextAfter(nodeOrToken, text) {
    const [, end] = this._rangeOf(nodeOrToken);
    return { range: [end, end], text };
  }

  /** Insert text before a range. */
  insertTextBeforeRange(range, text) {
    return { range: [range[0], range[0]], text };
  }

  /** Insert text after a range. */
  insertTextAfterRange(range, text) {
    return { range: [range[1], range[1]], text };
  }
}

// ── Context ─────────────────────────────────────────────────────

/**
 * Core report logic — called from pre-bound per-rule report functions so that
 * ruleId/ruleMeta are captured at rule-load time, not mutated per handler call.
 */
function _execReport(descriptor, ruleId, ruleMeta, ctx) {
  const { node, message, messageId, loc, data } = descriptor;
  let resolvedMsg = message;
  if (!resolvedMsg && messageId && ruleMeta?.messages) {
    let tpl = ruleMeta.messages[messageId] || messageId;
    resolvedMsg = data
      ? tpl.replace(/\{\{(\w+)\}\}/g, (_, k) => data[k] ?? `{{${k}}}`)
      : tpl;
  }
  resolvedMsg = resolvedMsg || messageId || 'Lint violation';
  let resolvedLoc = loc;
  if (!resolvedLoc && node) {
    const sc = ctx.sourceCode;
    // node may be a NodeView (.start/.end) or a token object (.range[0]/.range[1]).
    const startIdx = node.start != null ? node.start : (node.range ? node.range[0] : 0);
    const endIdx   = node.end   != null ? node.end   : (node.range ? node.range[1] : startIdx);
    resolvedLoc = {
      start: sc.getLocFromIndex(startIdx),
      end:   sc.getLocFromIndex(endIdx),
    };
  } else if (resolvedLoc && typeof resolvedLoc.start === 'number') {
    const sc = ctx.sourceCode;
    resolvedLoc = {
      start: sc.getLocFromIndex(resolvedLoc.start),
      end: resolvedLoc.end != null
        ? sc.getLocFromIndex(resolvedLoc.end)
        : sc.getLocFromIndex(resolvedLoc.start),
    };
  }
  let fix = null;
  if (typeof descriptor.fix === 'function') {
    try {
      const fixer = new RuleFixer(ctx._ast.source);
      const fixResult = descriptor.fix(fixer);
      if (fixResult) {
        fix = (typeof fixResult[Symbol.iterator] === 'function' && typeof fixResult.range === 'undefined')
          ? [...fixResult]
          : [fixResult];
        fix = fix.filter(Boolean);
      }
    } catch { /* ignore fix errors */ }
  }
  ctx._reports.push({
    ruleId,
    message: resolvedMsg,
    node: node ? { type: node.type, start: node.start != null ? node.start : (node.range ? node.range[0] : undefined) } : undefined,
    loc: resolvedLoc,
    fix: fix && fix.length > 0 ? fix : undefined,
  });
  const newCount = (ctx._ruleErrors[ruleId] || 0) + 1;
  ctx._ruleErrors[ruleId] = newCount;
  if (newCount >= ctx._errorBudget && ctx._skipSet) {
    ctx._skipSet.mark(ruleId);
  }
}

/**
 * Create a pre-bound report function for a specific rule.
 * Captures ruleId/ruleMeta via closure — no need to mutate context._currentRule
 * or context._currentRuleMeta before each handler invocation.
 */
function _makeBoundReport(ruleId, ruleMeta, masterCtx) {
  return function report(descriptor) {
    _execReport(descriptor, ruleId, ruleMeta, masterCtx);
  };
}

/**
 * Create a reusable safe handler wrapper for a specific rule.
 * The wrapper owns a mutable `_state.inner` reference that is updated per file,
 * eliminating per-file closure allocation while keeping try/catch out of the
 * hot dispatch loop.
 *
 * The wrapper also bakes in the skipSet check so _invokeFused needs no per-handler
 * guard — just iterates and calls.
 */
function _makeSafeHandler(ruleId, context) {
  const state = { inner: null };
  function safeHandler(node) {
    if (context._skipSet !== null && context._skipSet.has(ruleId)) return;
    try { state.inner(node); }
    catch (err) { context._reports.push({ ruleId, message: `Plugin error: ${err.message}` }); }
  }
  safeHandler._state = state;
  return safeHandler;
}

/**
 * ESLint-compatible rule context passed to plugin visitor functions.
 */
class RuleContext {
  constructor(ast, filename, sourceText, options = {}) {
    this._ast = ast;
    this._filename = filename;
    this.filename = filename; // ESLint v8+ flat config uses context.filename directly
    this._source = sourceText;
    this._reports = [];
    this.options = options.ruleOptions || [];
    this.parserOptions = { ecmaVersion: 2022, ecmaFeatures: { jsx: true } };
    this.languageOptions = {
      ecmaVersion: 2022,
      sourceType: 'module',
      parserOptions: { ecmaFeatures: { jsx: true } },
      // Identify as @typescript-eslint/parser so type-aware rules don't throw
      parser: { meta: { name: '@typescript-eslint/parser' } },
    };
    this.settings = {};
    // Satisfy ESLint v8 parserPath check used by getParserServices
    this.parserPath = '@typescript-eslint/parser';
    const sc = new SourceCode(ast, sourceText, options.sourceType, options.ecmaVersion);
    this.sourceCode = sc;
    // Attach TypeScript parserServices for .ts/.tsx files
    if (options.parserServices) {
      sc.parserServices = options.parserServices;
    }
    // Short-circuit / error budget: per-rule violation count
    this._ruleErrors = Object.create(null);
    this._errorBudget = options.errorBudget || DEFAULT_ERROR_BUDGET;
    if (options.sourceType) this.languageOptions.sourceType = options.sourceType;
    if (options.ecmaVersion) this.languageOptions.ecmaVersion = _normalizeEcmaVersion(options.ecmaVersion);
  }

  reset(ast, filename, sourceText, options = {}) {
    this._ast = ast;
    this._filename = filename;
    this.filename = filename;
    this._source = sourceText;
    this._reports = [];
    this._ruleErrors = Object.create(null);
    this._errorBudget = options.errorBudget || DEFAULT_ERROR_BUDGET;
    this._skipSet = null;
    this._currentNodeIdx = 0;
    this._currentRule = null;
    this._currentRuleMeta = null;
    this.sourceCode.reset(ast, sourceText, options.sourceType, options.ecmaVersion);
    if (options.parserServices) this.sourceCode.parserServices = options.parserServices;
    if (options.sourceType) this.languageOptions.sourceType = options.sourceType;
    if (options.ecmaVersion) this.languageOptions.ecmaVersion = _normalizeEcmaVersion(options.ecmaVersion);
  }

  /**
   * Report a lint violation.
   * @param {object} descriptor - { node, message, loc? }
   */
  report(descriptor) {
    _execReport(descriptor, this._currentRule, this._currentRuleMeta, this);
  }

  getSourceCode() {
    return this.sourceCode;
  }

  getFilename() {
    return this._filename;
  }

  /**
   * Returns ancestor nodes of the current node (root → parent, not including current node).
   * Compatible with ESLint v7 context.getAncestors().
   */
  getAncestors() {
    return this.sourceCode.getAncestors(nodeView(this._ast, this._currentNodeIdx));
  }

  /**
   * Mark a variable as used in the current scope (stub — used by some rules).
   */
  markVariableAsUsed(name) {
    // No-op stub; real implementation would mark the variable in scope analysis.
    return false;
  }

  getPhysicalFilename() {
    return this._filename;
  }

  getCwd() {
    return process.cwd();
  }
}

// ── Visitor Walk ─────────────────────────────────────────────────

/**
 * Returns true if a visitor key is a CSS-style AST selector rather than
 * a plain ESTree node type name (optionally with :exit).
 * Selectors contain [, >, ~, +, spaces, parens, or a : that is not just :exit.
 * Comma-separated lists of plain type names are NOT selectors — they expand to multiple map entries.
 */
function _isSelector(key) {
  const base = key.endsWith(':exit') ? key.slice(0, -5) : key;
  // Comma-only union of plain type names like "MethodDefinition, PropertyDefinition"
  // These should be expanded, not sent to esquery.
  if (base.includes(',')) {
    const parts = base.split(',').map(p => p.trim());
    if (parts.every(p => /^[A-Z][A-Za-z]*$/.test(p))) return false; // simple type union
  }
  return /[\s\[>~+.(]/.test(base) || base.includes(':');
}

/**
 * Expand a comma-separated union of type names into individual keys.
 * e.g. "MethodDefinition, PropertyDefinition" → ["MethodDefinition", "PropertyDefinition"]
 * For non-unions, returns [key].
 */
function _expandUnion(key) {
  const isExit = key.endsWith(':exit');
  const base = isExit ? key.slice(0, -5) : key;
  if (!base.includes(',')) return [key];
  return base.split(',').map(p => isExit ? p.trim() + ':exit' : p.trim());
}

/**
 * Build a reverse mapping from ESTree type name → list of visitor functions.
 * This enables efficient single-pass traversal.
 * Also returns a selectorHandlers array for CSS-style AST selectors.
 */
// Cached visitorMap structure: reuse Map + arrays across files.
// Only handler function references change (closures are re-created by create()).
// The Map keys, ruleIds, ruleMeta, and ruleOptions are stable for the same plugins.
let _cachedVMPlugins = null;
let _cachedVM = null; // { map, selectorHandlers, handlerSlots }

function buildVisitorMap(plugins, context, ruleConfig = {}) {
  if (_cachedVMPlugins === plugins && _cachedVM) {
    // Fast path: recipe-based update — no Object.entries, no _isSelector, no _expandUnion,
    // no map-array clear/refill. Direct property access by pre-computed visitorKey.
    // Map arrays and selectorHandlers are stable (same slot objects); only _state.inner changes.
    const { map, selectorHandlers, handlerSlots, selectorSlots, perRuleCtxs, perPluginRecipe } = _cachedVM;
    let slotIdx = 0, selIdx = 0;
    let mismatch = false;
    for (let pi = 0; pi < plugins.length && !mismatch; pi++) {
      const recipe = perPluginRecipe[pi];
      if (!recipe || recipe.length === 0) continue;
      let visitors;
      try { visitors = plugins[pi].create(perRuleCtxs[pi]); }
      catch { mismatch = true; break; }
      if (!visitors || typeof visitors !== 'object') { mismatch = true; break; }
      for (let r = 0; r < recipe.length && !mismatch; r++) {
        const step = recipe[r];
        const handler = visitors[step.visitorKey];
        if (typeof handler !== 'function') { mismatch = true; break; }
        if (step.sel) {
          selectorSlots[selIdx++].handler = handler;
        } else {
          // numSlots >= 1 for union keys (e.g. "Foo, Bar:exit" → 2 slots with same handler)
          for (let k = 0; k < step.numSlots; k++) {
            handlerSlots[slotIdx++].handler._state.inner = handler;
          }
        }
      }
    }
    if (mismatch) {
      _cachedVMPlugins = null;
      _cachedVM = null;
      return buildVisitorMap(plugins, context, ruleConfig);
    }
    return { map, selectorHandlers };
  }

  // Cold path: first file — build from scratch and cache structure.
  const map = new Map();
  const selectorHandlers = [];
  const handlerSlots = []; // all handler descriptor objects (reused across files)
  const selectorSlots = [];
  const pluginOptions = [];
  const perRuleCtxs = []; // cached per-rule contexts (item 4)
  const perPluginRecipe = []; // fast-path recipe: per-plugin ordered list of {visitorKey, sel, numSlots}

  for (const plugin of plugins) {
    const ruleId = plugin.meta?.name || "unknown";
    const ruleMeta = plugin.meta || null;
    const shortName = ruleId.includes('/') ? ruleId.split('/').pop() : ruleId;
    const configured = ruleConfig[ruleId] ?? ruleConfig[shortName];
    const ruleOptions = _mergeRuleOptions(plugin.meta?.defaultOptions, configured);
    pluginOptions.push(ruleOptions);
    // Per-rule context — created once, reused across all files (items 4+5).
    // report() and options are stable per rule; prototype chain reads per-file
    // state (sourceCode, _currentNodeIdx, etc.) from the reused master context.
    const perRuleCtx = Object.create(context);
    perRuleCtx.options = ruleOptions;
    perRuleCtx.id = ruleId;
    perRuleCtx.report = _makeBoundReport(ruleId, ruleMeta, context);
    perRuleCtxs.push(perRuleCtx);
    const recipe = [];
    let visitors;
    try { visitors = plugin.create(perRuleCtx); } catch { perPluginRecipe.push(recipe); continue; }
    if (!visitors || typeof visitors !== 'object') { perPluginRecipe.push(recipe); continue; }
    for (const [visitorKey, handler] of Object.entries(visitors)) {
      if (typeof handler !== 'function') continue;
      if (_isSelector(visitorKey)) {
        const isExit = visitorKey.endsWith(':exit');
        const selector = isExit ? visitorKey.slice(0, -5) : visitorKey;
        let parsedSelector = _selectorParseCache.get(selector);
        if (parsedSelector === undefined) {
          try { parsedSelector = esquery() ? esquery().parse(selector) : null; } catch { parsedSelector = null; }
          _selectorParseCache.set(selector, parsedSelector);
        }
        if (!parsedSelector) continue;
        const slot = { selector, parsedSelector, isExit, handler, ruleId, ruleMeta, ruleOptions };
        selectorSlots.push(slot);
        selectorHandlers.push(slot);
        recipe.push({ visitorKey, sel: true, numSlots: 1 });
        continue;
      }
      const expandedKeys = _expandUnion(visitorKey);
      recipe.push({ visitorKey, sel: false, numSlots: expandedKeys.length });
      for (const mapKey of expandedKeys) {
        if (!map.has(mapKey)) map.set(mapKey, []);
        // Safe handler wrapper (items 1+2): try/catch + skipSet check baked in,
        // inner reference updated per file with no new closure allocation.
        const safe = _makeSafeHandler(ruleId, context);
        safe._state.inner = handler;
        const slot = { handler: safe, _state: safe._state, ruleId, ruleMeta, ruleOptions };
        handlerSlots.push(slot);
        map.get(mapKey).push(slot);
      }
    }
    perPluginRecipe.push(recipe);
  }

  _cachedVMPlugins = plugins;
  _cachedVM = { map, selectorHandlers, handlerSlots, selectorSlots, pluginOptions, perRuleCtxs, perPluginRecipe };
  return { map, selectorHandlers };
}

/**
 * Build DFS pre-order and post-order traversal sequences from parent pointers.
 * Parents have higher node indices than children in the sanz AST, except for
 * Program (index 0) which is the root. Using parent data gives correct DFS order.
 */
function buildDFSOrders(ast) {
  const nodeCount = ast.nodeCount;
  const pd = ast._parentData;

  if (!pd) {
    // Fallback: reverse for enter (most parents before children), forward for exit
    const preOrder = new Int32Array(nodeCount);
    const postOrder = new Int32Array(nodeCount);
    for (let i = 0; i < nodeCount; i++) {
      preOrder[i] = nodeCount - 1 - i;
      postOrder[i] = i;
    }
    return { preOrder, postOrder };
  }

  // Build a flat CSR (compressed sparse row) children representation using typed
  // arrays to avoid allocating one JS Array per node (28K allocs for acorn.js).
  const childCount  = new Int32Array(nodeCount);
  for (let i = 0; i < nodeCount; i++) {
    const p = pd[i];
    if (p !== NONE) childCount[p]++;
  }
  const childOffset = new Int32Array(nodeCount + 1);
  let totalChildren = 0;
  for (let i = 0; i < nodeCount; i++) {
    childOffset[i] = totalChildren;
    totalChildren += childCount[i];
  }
  childOffset[nodeCount] = totalChildren;
  const children = new Int32Array(totalChildren);
  const fillCursor = new Int32Array(nodeCount);
  for (let i = 0; i < nodeCount; i++) {
    const p = pd[i];
    if (p !== NONE) {
      children[childOffset[p] + fillCursor[p]++] = i;
    }
  }

  // Iterative DFS using typed-array stacks — zero GC pressure.
  const preOrder  = new Int32Array(nodeCount);
  const postOrder = new Int32Array(nodeCount);
  const stackNode = new Int32Array(nodeCount * 2);
  const stackPost = new Uint8Array(nodeCount * 2);
  let top = 0, preIdx = 0, postIdx = 0;
  stackNode[0] = 0;
  stackPost[0] = 0;

  while (top >= 0) {
    const node = stackNode[top];
    const isPost = stackPost[top];
    top--;

    if (isPost) {
      postOrder[postIdx++] = node;
    } else {
      preOrder[preIdx++] = node;
      // Schedule post-visit (push self as post)
      top++;
      stackNode[top] = node;
      stackPost[top] = 1;
      // Schedule children in reverse order so first child processes first
      const off = childOffset[node];
      const cnt = childCount[node];
      for (let i = cnt - 1; i >= 0; i--) {
        top++;
        stackNode[top] = children[off + i];
        stackPost[top] = 0;
      }
    }
  }

  return { preOrder, postOrder };
}

// Node types that trigger onCodePathStart/onCodePathEnd.
const CODE_PATH_TYPES = new Set([
  'Program',
  'FunctionDeclaration',
  'FunctionExpression',
  'ArrowFunctionExpression',
]);

const CLASS_TYPES = new Set(['ClassDeclaration', 'ClassExpression']);

// ── Lightweight Code Path Tracker ────────────────────────────────
// Tracks reachability through control flow for rules like no-unreachable,
// getter-return, consistent-return, no-fallthrough. Not a full CFG — just
// tracks whether code is reachable at each point in the DFS.

let _cpIdCounter = 0;
let _segIdCounter = 0;

function _makeSegment(reachable = true) {
  return {
    id: 's' + (_segIdCounter++),
    reachable,
    nextSegments: [],
    prevSegments: [],
    allNextSegments: [],
    allPrevSegments: [],
    internal: {},
  };
}

class CodePathTracker {
  constructor() {
    this._stack = []; // stack of { codePath, segment, returned }
    this._currentSegment = null;
    this._codePath = null;
    this._branchStack = []; // { savedReachable, anyBranchReachable }
  }

  enterFunction(node) {
    const seg = _makeSegment(true);
    const codePath = {
      id: 'cp' + (_cpIdCounter++),
      origin: node.type === 'Program' ? 'program' : 'function',
      upper: this._codePath,
      childCodePaths: [],
      currentSegments: [seg],
      initialSegment: seg,
      finalSegments: [],
      thrownSegments: [],
      returnedForkContext: [],
      internal: {},
    };
    if (this._codePath) this._codePath.childCodePaths.push(codePath);
    this._stack.push({ codePath: this._codePath, segment: this._currentSegment, returned: false });
    this._codePath = codePath;
    this._currentSegment = seg;
    return { codePath, segment: seg };
  }

  exitFunction() {
    const codePath = this._codePath;
    if (this._currentSegment) codePath.finalSegments.push(this._currentSegment);
    const prev = this._stack.pop();
    this._codePath = prev ? prev.codePath : null;
    this._currentSegment = prev ? prev.segment : null;
    return codePath;
  }

  // Called after return/throw/break/continue — subsequent code is unreachable
  markUnreachable() {
    if (this._currentSegment) this._currentSegment.reachable = false;
    const unreachSeg = _makeSegment(false);
    this._currentSegment = unreachSeg;
    if (this._codePath) this._codePath.currentSegments = [unreachSeg];
  }

  // Enter a branching statement (if/try/switch/loop). Saves current reachability.
  enterBranch() {
    this._branchStack.push({ savedReachable: this.reachable, anyBranchReachable: false });
  }

  // Enter alternate path (else/catch/case). Records previous branch result, restores.
  nextBranch() {
    const top = this._branchStack[this._branchStack.length - 1];
    if (!top) return _makeSegment(true);
    if (this.reachable) top.anyBranchReachable = true;
    const seg = _makeSegment(top.savedReachable);
    this._currentSegment = seg;
    if (this._codePath) this._codePath.currentSegments = [seg];
    return seg;
  }

  // Exit branching statement. Merge: reachable if any branch was, or if implicit path exists.
  // hasAllBranches=true (if-else, try-catch): all paths go through branch → reachable = anyBranchReachable
  // hasAllBranches=false (switch-no-default, if-no-else, loops): implicit bypass path exists →
  //   reachable = anyBranchReachable || savedReachable (bypass inherits entry reachability)
  exitBranch(hasAllBranches = false) {
    const top = this._branchStack.pop();
    if (!top) return _makeSegment(true);
    if (this.reachable) top.anyBranchReachable = true;
    const reachable = hasAllBranches ? top.anyBranchReachable : (top.anyBranchReachable || top.savedReachable);
    const seg = _makeSegment(reachable);
    this._currentSegment = seg;
    if (this._codePath) this._codePath.currentSegments = [seg];
    return seg;
  }

  // Called when entering a new block that restores reachability (else, catch, finally, case)
  forkReachable() {
    const seg = _makeSegment(true);
    this._currentSegment = seg;
    if (this._codePath) this._codePath.currentSegments = [seg];
    return seg;
  }

  get segment() { return this._currentSegment; }
  get codePath() { return this._codePath; }
  get reachable() { return this._currentSegment ? this._currentSegment.reachable : true; }
}

// ── Rule Query Optimizer: handler analysis & fusion ─────────────

/** Default max violations per rule before short-circuiting. */
const DEFAULT_ERROR_BUDGET = 200;

/**
 * Consolidated handler analysis cache.
 * Keyed by handler.toString() — computed once per unique handler source,
 * reused across all files in the same process. This eliminates the #1
 * profiling hotspot: repeated .toString() + regex on every handler per file.
 */
const _handlerAnalysisCache = new Map();

function _analyzeHandler(handler) {
  let src;
  try { src = handler.toString(); } catch {
    return { cost: 2, parentGuard: null, isTrivial: false, ruleAccess: 'independent' };
  }
  let cached = _handlerAnalysisCache.get(src);
  if (cached) return cached;

  // Cost estimation
  let cost;
  if (src.includes('getScope') || src.includes('getDeclaredVariables') ||
      src.includes('getAncestors') || src.includes('.scope')) cost = 3;
  else if (src.includes('getToken') || src.includes('.parent.') ||
      src.includes('getText') || src.includes('sourceCode')) cost = 2;
  else cost = 1;

  // Parent guard extraction
  const m = src.match(
    /if\s*\(\s*node\.parent\??\.type\s*!==?\s*["']([A-Z][A-Za-z]+)["']\s*\)\s*return\b/
  );
  const parentGuard = m ? { parentType: m[1] } : null;

  // Trivial handler detection
  let isTrivial = false;
  if (src.length <= 300 && src.includes('report') &&
      !src.includes('for ') && !src.includes('for(') && !src.includes('while') &&
      !src.includes('getScope') && !src.includes('getDeclaredVariables') &&
      !src.includes('getToken') && !src.includes('getText')) {
    isTrivial = true;
  }

  // Rule access classification
  let ruleAccess;
  if (src.includes('markVariableAsUsed') || src.includes('.eslintUsed')) ruleAccess = 'writer';
  else if (src.includes('getScope') || src.includes('getDeclaredVariables') ||
      src.includes('.references') || src.includes('.variables')) ruleAccess = 'reader';
  else ruleAccess = 'independent';

  cached = { cost, parentGuard, isTrivial, ruleAccess };
  _handlerAnalysisCache.set(src, cached);
  return cached;
}

// Thin wrappers for backward compatibility / tests
function _estimateHandlerCost(handler) { return _analyzeHandler(handler).cost; }
function _extractParentGuard(handler) { return _analyzeHandler(handler).parentGuard; }
function _isTrivialHandler(handler) { return _analyzeHandler(handler).isTrivial; }

/**
 * Dead handler elimination: check if a handler's visitor type can actually
 * appear as a child of certain parent types based on JS/TS grammar constraints.
 * Returns false if the handler's parent guard specifies an impossible combination.
 *
 * Grammar constraints (subset — covers most common cases):
 */
const _VALID_PARENTS = {
  // BreakStatement can only appear inside loops or switch
  BreakStatement: new Set(['ForStatement', 'ForInStatement', 'ForOfStatement', 'WhileStatement',
    'DoWhileStatement', 'SwitchCase', 'BlockStatement', 'LabeledStatement']),
  // ContinueStatement can only appear inside loops
  ContinueStatement: new Set(['ForStatement', 'ForInStatement', 'ForOfStatement', 'WhileStatement',
    'DoWhileStatement', 'BlockStatement', 'LabeledStatement']),
  // CatchClause can only be child of TryStatement
  CatchClause: new Set(['TryStatement']),
  // SwitchCase can only be child of SwitchStatement
  SwitchCase: new Set(['SwitchStatement']),
  // ClassBody (synthetic) can only be child of ClassDeclaration/ClassExpression
  ClassBody: new Set(['ClassDeclaration', 'ClassExpression']),
  // MethodDefinition can only be in class body (mapped to ClassDeclaration/ClassExpression)
  MethodDefinition: new Set(['ClassDeclaration', 'ClassExpression']),
  // PropertyDefinition same as MethodDefinition
  PropertyDefinition: new Set(['ClassDeclaration', 'ClassExpression']),
};

function _isDeadHandler(typeName, parentGuard) {
  if (!parentGuard) return false;
  const validParents = _VALID_PARENTS[typeName];
  if (!validParents) return false; // no constraint known — keep handler
  return !validParents.has(parentGuard.parentType);
}

/**
 * Fuse multiple handlers for the same tag into an optimized execution plan.
 * Applies cost-based ordering, predicate pushdown, handler inlining,
 * and dead handler elimination.
 *
 * Returns a "fused handler descriptor" object with:
 *   .items: sorted array of { handler, ruleId, ruleMeta, ruleOptions, cost, parentGuard }
 *   .length: number of items (for compatibility check in hot loop)
 *   ._fused: true (marker so _invokeFused knows this is fused)
 */
function _fuseHandlers(handlers, typeName) {
  const items = [];
  for (let i = 0; i < handlers.length; i++) {
    const h = handlers[i];
    // Analyze the actual visitor function (inner), not the safeHandler wrapper
    const inner = h._state ? h._state.inner : h.handler;
    const analysis = _analyzeHandler(inner);
    if (_isDeadHandler(typeName, analysis.parentGuard)) continue;
    items.push({
      _state: h._state || null, // direct mutable state ref; inner called via _state.inner
      handler: h.handler,       // kept for compatibility (selectors, remapPlan fallback)
      ruleId: h.ruleId,
      ruleMeta: h.ruleMeta,
      ruleOptions: h.ruleOptions,
      cost: analysis.isTrivial ? 0 : analysis.cost,
      parentGuard: analysis.parentGuard,
    });
  }
  items.sort((a, b) => a.cost - b.cost);
  const desc = { items, length: items.length, _fused: true, _compiled: null };
  // Compiled dispatch is attached lazily after coalescing (see _buildPlan)
  return desc;
}

/**
 * Hot path: invoke handler without try/catch.
 * V8 can fully optimize this since there's no exception handling.
 */
function _callHandler(handler, node) {
  handler(node);
}

/**
 * SQL compiled-query technique: generate a direct-call dispatch function.
 *
 * Instead of a loop `for (h=0; h<N; h++) states[h].inner(node)`, generate:
 *   function(node) { s[0].inner(node); s[1].inner(node); ... s[N-1].inner(node); }
 *
 * Benefits:
 * - No loop overhead (bounds check, counter, array element load per iter)
 * - Each `s[i]` is a fixed constant index — V8 forms a stable IC per position
 * - V8 can potentially elide the per-iteration load of the loop variable
 *
 * The generated function captures `stateRefs` (the array of _state objects).
 * `stateRefs[i].inner` is read at call time, so per-file visitor updates propagate.
 *
 * Only compiled for descriptors with no parent guards and no coalesced guards
 * (i.e., the simple majority-case dispatch).
 *
 * Max 512 handlers to keep generated code size reasonable.
 */
const _COMPILED_DISPATCH_MAX = 512;

function _buildCompiledDispatch(items) {
  if (items.length === 0 || items.length > _COMPILED_DISPATCH_MAX) return null;
  // Only compile when all items have no parent guards (pure dispatch, no predicates)
  for (let i = 0; i < items.length; i++) {
    if (items[i].parentGuard) return null;
  }
  const stateRefs = items.map(item => item._state);
  const lines = items.map((_, i) => `s[${i}].inner(nd);`).join('');
  // new Function captures stateRefs as 's', returns an (node) → void function
  const fn = new Function('s', `return function(nd){${lines}};`)(stateRefs);
  return fn;
}

/**
 * Cold path: handle errors from handler invocation.
 * Separated from the hot path so V8 doesn't deoptimize the caller.
 */
function _handleError(err, ruleId, context) {
  context._reports.push({ ruleId, message: `Plugin error: ${err.message}` });
}

/**
 * Invoke a fused handler descriptor against a node.
 * Applies predicate pushdown only — skipSet check and try/catch are baked
 * into each safeHandler wrapper, keeping this loop free of both (items 1+2).
 */
// Helper: call item._state.inner or fall back to item.handler (for items without _state).
// Called only on error recovery paths — not the hot path.
function _invokeFusedItem(item, node, context) {
  if (item._state) {
    item._state.inner(node);
  } else {
    item.handler(node);
  }
}

/**
 * Invoke a fused handler descriptor against a node.
 *
 * SQL optimizer technique: batch try/catch (one per dispatch group, not per handler).
 * Like a vectorized SQL operator, we catch errors at the batch boundary:
 *   - Common case (anySkipped=false): ONE try/catch for all N handlers.
 *     V8 can optimize the try block as if it doesn't exist when nothing throws.
 *   - Error case: quarantine the bad handler, continue remaining with per-handler protection.
 *   - Skip case (anySkipped=true): per-handler skip check, individual try/catch.
 *
 * Predicate hoisting: context._skipSet null check done ONCE outside the loop,
 * not N times inside.
 */
function _invokeFused(desc, node, nodeIdx, context) {
  context._currentNodeIdx = nodeIdx;
  const skip = context._skipSet;
  // anySkipped: true only when at least one rule has exhausted its error budget.
  // null._set is never reached because skip===null short-circuits first.
  const anySkipped = skip !== null && skip._set.size > 0;

  if (!desc._fused) {
    // Non-fused array of slots — all slots have _state set; call _state.inner directly.
    const arr = desc;
    const n = arr.length;
    if (!anySkipped) {
      let h = 0;
      try {
        for (; h < n; h++) arr[h]._state.inner(node);
      } catch (err) {
        context._reports.push({ ruleId: arr[h].ruleId, message: `Plugin error: ${err.message}` });
        for (let k = h + 1; k < n; k++) {
          try { arr[k]._state.inner(node); }
          catch (e) { context._reports.push({ ruleId: arr[k].ruleId, message: `Plugin error: ${e.message}` }); }
        }
      }
    } else if (!skip.allSkipped) {
      for (let h = 0; h < n; h++) {
        if (skip.has(arr[h].ruleId)) continue;
        try { arr[h]._state.inner(node); }
        catch (err) { context._reports.push({ ruleId: arr[h].ruleId, message: `Plugin error: ${err.message}` }); }
      }
    }
    return;
  }

  const items = desc.items;
  const parentType = node.parent ? node.parent.type : null;
  let lastGuardKey = undefined;
  let lastGuardResult = false;

  if (!anySkipped) {
    // Fast path: one try/catch for all handlers (SQL operator-level error handling)
    let h = 0;
    try {
      for (; h < items.length; h++) {
        const item = items[h];
        if (item.parentGuard) {
          const guardKey = item._coalescedGuard !== undefined ? item._coalescedGuard : item.parentGuard.parentType;
          if (guardKey !== lastGuardKey) { lastGuardKey = guardKey; lastGuardResult = parentType === guardKey; }
          if (!lastGuardResult) continue;
        }
        item._state.inner(node);
      }
    } catch (err) {
      context._reports.push({ ruleId: items[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < items.length; k++) {
        try { items[k]._state.inner(node); }
        catch (e) { context._reports.push({ ruleId: items[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  } else if (!skip.allSkipped) {
    // Slow path: some rules exceeded budget
    for (let h = 0; h < items.length; h++) {
      const item = items[h];
      if (skip.has(item.ruleId)) continue;
      if (item.parentGuard) {
        const guardKey = item._coalescedGuard !== undefined ? item._coalescedGuard : item.parentGuard.parentType;
        if (guardKey !== lastGuardKey) { lastGuardKey = guardKey; lastGuardResult = parentType === guardKey; }
        if (!lastGuardResult) continue;
      }
      try { item._state.inner(node); }
      catch (err) { context._reports.push({ ruleId: item.ruleId, message: `Plugin error: ${err.message}` }); }
    }
  }
}

// ── Rule Query Optimizer: columnar batch scan ───────────────────
//
// For rules that register exactly one enter handler for one node type
// (no exit, no selectors, no codepath/classBody/methodFn), we can bypass
// DFS entirely and iterate directly over the materialized view index.
// This is the "columnar scan" — like a DB scanning a single column.

/**
 * Identify rules that can use columnar batch scan.
 * Returns a Map<typeName, handler[]> of handlers that should be run
 * via batch scan, and removes those entries from the tag handler arrays.
 *
 * A rule is batch-scannable only if it registers EXACTLY one enter handler
 * for one node type — no exit handlers, no special handlers (codepath,
 * classBody, selectors), and no entries in the visitorMap for other keys.
 */
function _extractBatchScannable(visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers, tagFlags) {
  const batchable = new Map(); // typeName → handler[]

  // Build a set of all ruleIds that have ANY non-tag-enter entry in the visitorMap.
  // This catches rules that also register onCodePathStart, Program:exit, etc.
  const rulesWithNonTagEntries = new Set();
  for (const [key, handlers] of visitorMap) {
    // Skip keys that are plain enter types (those are in tagEnterHandlers already)
    if (/^[A-Z]/.test(key) && !key.includes(':')) continue;
    // This is a non-tag entry (exit, codepath, Program:exit, selector, etc.)
    const items = Array.isArray(handlers) ? handlers : (handlers.items || []);
    for (const h of items) {
      rulesWithNonTagEntries.add(h.ruleId);
    }
  }

  for (let t = 0; t < tagCount; t++) {
    const enter = tagEnterHandlers[t];
    if (!enter) continue;
    // Can't batch if there are exit handlers or special flags
    if (tagExitHandlers[t] || tagFlags[t]) continue;
    const tn = tagNames[t];
    if (!tn) continue;

    // Check each handler: batchable if this rule ONLY registered this one type
    const handlers = enter._fused ? enter.items : enter;
    const batchableHandlers = [];
    const keepHandlers = [];

    for (let h = 0; h < handlers.length; h++) {
      const hd = handlers[h];
      const ruleId = hd.ruleId;

      // Rule has non-tag entries (onCodePathStart, Program:exit, etc.) — not batchable
      if (rulesWithNonTagEntries.has(ruleId)) {
        keepHandlers.push(hd);
        continue;
      }

      // Check if this rule has handlers for other tag types too
      let multiType = false;
      for (let t2 = 0; t2 < tagCount; t2++) {
        if (t2 === t) continue;
        const other = tagEnterHandlers[t2];
        if (!other) continue;
        const otherItems = other._fused ? other.items : other;
        for (let j = 0; j < otherItems.length; j++) {
          if (otherItems[j].ruleId === ruleId) { multiType = true; break; }
        }
        if (multiType) break;
      }
      if (multiType) {
        keepHandlers.push(hd);
      } else {
        batchableHandlers.push(hd);
      }
    }

    if (batchableHandlers.length > 0) {
      batchable.set(tn, batchableHandlers);
      // Update the tag handler array: keep only non-batchable handlers
      if (keepHandlers.length === 0) {
        tagEnterHandlers[t] = null;
      } else if (keepHandlers.length === 1) {
        tagEnterHandlers[t] = keepHandlers;
      } else {
        tagEnterHandlers[t] = _fuseHandlers(keepHandlers, tn);
      }
    }
  }

  return batchable;
}

// ── Rule Query Optimizer: profile-guided replan ─────────────────
//
// Measure actual handler execution time on first N nodes, then reorder
// handlers by real cost for subsequent nodes. Stored globally so it
// persists across files in the same process (worker).

const _profileData = new Map(); // ruleId → { totalNs: number, calls: number }
const PROFILE_WARMUP_NODES = 50; // nodes to profile before replanning

/**
 * Record a handler's execution time into the profile data.
 */
function _profileRecord(ruleId, elapsedNs) {
  let entry = _profileData.get(ruleId);
  if (!entry) { entry = { totalNs: 0, calls: 0 }; _profileData.set(ruleId, entry); }
  entry.totalNs += elapsedNs;
  entry.calls++;
}

/**
 * Get the profiled average cost for a rule, or -1 if not enough data.
 */
function _profiledCost(ruleId) {
  const entry = _profileData.get(ruleId);
  if (!entry || entry.calls < 3) return -1;
  return entry.totalNs / entry.calls;
}

/**
 * Re-sort fused handler items by actual profiled cost (descending reliability).
 * Called after warmup to reorder based on real measurements.
 */
function _replanFused(desc) {
  if (!desc || !desc._fused) return;
  desc.items.sort((a, b) => {
    const ca = _profiledCost(a.ruleId);
    const cb = _profiledCost(b.ruleId);
    // If both have profile data, sort by actual cost
    if (ca >= 0 && cb >= 0) return ca - cb;
    // Otherwise fall back to static estimate
    return a.cost - b.cost;
  });
}

// ── Rule Query Optimizer: rule dependency DAG ───────────────────
//
// Model inter-rule data dependencies. Rules that write to shared state
// (e.g., mark variables as used) must run before rules that read it.
// We detect this by analyzing handler source for common patterns.

// Thin wrapper for backward compatibility / tests
function _classifyRuleAccess(handler) { return _analyzeHandler(handler).ruleAccess; }

/**
 * Sort handlers within a fused group respecting the dependency DAG:
 * writers → independents → readers (within each tier, by cost).
 */
function _sortByDependency(items) {
  const ORDER = { writer: 0, independent: 1, reader: 2 };
  items.sort((a, b) => {
    const aInner = a._state ? a._state.inner : a.handler;
    const bInner = b._state ? b._state.inner : b.handler;
    const orderDiff = ORDER[_analyzeHandler(aInner).ruleAccess] - ORDER[_analyzeHandler(bInner).ruleAccess];
    if (orderDiff !== 0) return orderDiff;
    return a.cost - b.cost;
  });
}

// ── Rule Query Optimizer: visitor coalescing ────────────────────
//
// When multiple handlers for the same tag share the same parent-type guard,
// coalesce them into a single group with one shared guard check.
// This eliminates redundant node.parent.type lookups in the hot loop.

function _coalesceByParentGuard(items) {
  if (items.length <= 1) return items;
  // Group items by parentGuard.parentType (null = no guard)
  const groups = new Map(); // parentType|null → item[]
  for (const item of items) {
    const key = item.parentGuard ? item.parentGuard.parentType : null;
    let group = groups.get(key);
    if (!group) { group = []; groups.set(key, group); }
    group.push(item);
  }
  // If no coalescing opportunity (all different guards), return as-is
  if (groups.size === items.length) return items;
  // Rebuild items: coalesced groups with shared guard
  const result = [];
  for (const [parentType, group] of groups) {
    if (group.length === 1) {
      result.push(group[0]);
    } else {
      // Mark group items with a shared guard so _invokeFused can batch them
      for (const item of group) {
        item._coalescedGuard = parentType; // shared guard key
        result.push(item);
      }
    }
  }
  return result;
}

// ── Rule Query Optimizer: rule skip bitmap ──────────────────────
//
// Instead of checking context._ruleErrors[ruleId] >= budget per handler,
// maintain a Set of exhausted ruleIds. Set.has() is O(1) and avoids
// the property lookup + comparison on every handler invocation.

class RuleSkipSet {
  constructor() {
    this._set = new Set();
    this._allSkipped = false;
    this._totalRules = 0;
  }
  init(totalRules) {
    this._totalRules = totalRules;
  }
  mark(ruleId) {
    this._set.add(ruleId);
    if (this._set.size >= this._totalRules) this._allSkipped = true;
  }
  has(ruleId) {
    return this._set.has(ruleId);
  }
  get allSkipped() {
    return this._allSkipped;
  }
}

// ── Rule Query Optimizer: AST fingerprinting ────────────────────
//
// Hash subtree structure for deduplication. If two subtrees have identical
// tag sequences, run rules once and clone results for the duplicate.
// Only applied to top-level function/class declarations (most common dups).

function _fingerprintSubtree(nodeTags, pd, nodeCount, rootIdx) {
  // Simple fingerprint: collect tag sequence for direct children
  let hash = nodeTags[rootIdx];
  for (let i = 0; i < nodeCount; i++) {
    if (pd[i] === rootIdx) {
      hash = (hash * 31 + nodeTags[i]) | 0;
    }
  }
  return hash;
}

// ── Rule Query Optimizer: early exit for file-level rules ───────
//
// Rules that only register Program or Program:exit handlers don't need
// DFS traversal at all. Extract them and run them directly.

function _extractFileLevelRules(visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers) {
  const fileLevelEnter = []; // handlers for Program (enter)
  const fileLevelExit = [];  // handlers for Program:exit

  // Find the Program tag number
  let programTag = -1;
  for (let t = 0; t < tagCount; t++) {
    if (tagNames[t] === 'Program') { programTag = t; break; }
  }
  if (programTag < 0) return { fileLevelEnter, fileLevelExit, extractedRules: new Set() };

  // Build a Set of ruleIds that appear in ANY non-Program handler in O(rules) one pass.
  // Then isFileLevelOnly is just a Set.has() — O(1) instead of O(tagCount) per rule.
  const enterHandlers = tagEnterHandlers[programTag];
  const exitHandlers = tagExitHandlers[programTag];
  const extractedRules = new Set();

  const _nonProgramRules = new Set();
  for (let t = 0; t < tagCount; t++) {
    if (t === programTag) continue;
    const e = tagEnterHandlers[t];
    if (e) { const items = e._fused ? e.items : e; for (let j = 0; j < items.length; j++) _nonProgramRules.add(items[j].ruleId); }
    const x = tagExitHandlers[t];
    if (x) { const items = x._fused ? x.items : x; for (let j = 0; j < items.length; j++) _nonProgramRules.add(items[j].ruleId); }
  }
  for (const [key, handlers] of visitorMap) {
    if (key === 'Program' || key === 'Program:exit') continue;
    const items = Array.isArray(handlers) ? handlers : (handlers.items || []);
    for (const h of items) _nonProgramRules.add(h.ruleId);
  }

  // Extract file-level enter handlers
  if (enterHandlers) {
    const items = enterHandlers._fused ? enterHandlers.items : enterHandlers;
    const keep = [];
    for (let h = 0; h < items.length; h++) {
      if (!_nonProgramRules.has(items[h].ruleId)) {
        fileLevelEnter.push(items[h]);
        extractedRules.add(items[h].ruleId);
      } else {
        keep.push(items[h]);
      }
    }
    if (keep.length === 0) tagEnterHandlers[programTag] = null;
    else if (keep.length !== items.length) {
      tagEnterHandlers[programTag] = keep.length === 1 ? keep : _fuseHandlers(keep, 'Program');
    }
  }

  // Extract file-level exit handlers
  if (exitHandlers) {
    const items = exitHandlers._fused ? exitHandlers.items : exitHandlers;
    const keep = [];
    for (let h = 0; h < items.length; h++) {
      if (extractedRules.has(items[h].ruleId)) {
        fileLevelExit.push(items[h]);
      } else {
        keep.push(items[h]);
      }
    }
    if (keep.length === 0) tagExitHandlers[programTag] = null;
    else if (keep.length !== items.length) {
      tagExitHandlers[programTag] = keep.length === 1 ? keep : _fuseHandlers(keep, 'Program:exit');
    }
  }

  return { fileLevelEnter, fileLevelExit, extractedRules };
}

// ── Execution Plan Cache ─────────────────────────────────────────
// The structural plan (tag handler arrays, flags, fusion order, file-level
// extraction, batch scan eligibility) is deterministic for a given visitorMap
// structure. Cache it so the second+ file skips all handler analysis.
// Key: serialized ruleId set (since handler references change per file but
// ruleIds and visitor keys are stable for the same plugin set).

let _cachedPlanPlugins = null;
let _cachedPlan = null;

/**
 * Compile a fast-path selector matcher from a parsed esquery selector.
 * Returns { fn: (node, ancestors) => boolean, complete: boolean }
 * - complete=true: fn fully replaces esq.matches (safe to skip esq.matches)
 * - complete=false: fn is a quick pre-filter only (esq.matches still needed to confirm)
 * Returns null if the selector can't be fast-compiled.
 */
function _compileSelectorFastMatcher(parsedSelector) {
  if (!parsedSelector) return null;
  const t = parsedSelector.type;

  if (t === 'compound') {
    // compound: identifier + zero or more attribute selectors
    const attrChecks = [];
    for (const s of parsedSelector.selectors) {
      if (s.type === 'identifier') continue; // type already guaranteed by per-tag dispatch
      if (s.type !== 'attribute') return null; // pseudo-class, field, etc. — can't compile
      const check = _compileAttrCheck(s);
      if (!check) return null;
      attrChecks.push(check);
    }
    if (attrChecks.length === 0) {
      return { fn: (_n, _a) => true, complete: true };
    }
    if (attrChecks.length === 1) {
      const c = attrChecks[0];
      return { fn: (n, _a) => c(n), complete: true };
    }
    return { fn: (n, _a) => { for (const c of attrChecks) if (!c(n)) return false; return true; }, complete: true };
  }

  if (t === 'child') {
    const { left, right } = parsedSelector;

    // Two-level nested child: A > B > C  (left itself is a child combinator)
    if (left.type === 'child') {
      const ll = left.left, lr = left.right;
      const llType = ll.type === 'identifier' ? ll.value :
                     (ll.type === 'compound' ? (ll.selectors.find(s => s.type === 'identifier') || {}).value : null);
      if (!llType) return null;
      const lrType = lr.type === 'identifier' ? lr.value :
                     (lr.type === 'compound' ? (lr.selectors.find(s => s.type === 'identifier') || {}).value : null);
      if (!lrType) return null;

      // Compile attribute checks on the middle node (lr)
      let lrAttrChecks = null;
      const llComplete = ll.type === 'identifier'; // no attributes on grandparent
      let lrComplete = lr.type === 'identifier';   // will be true if all lr attrs compiled
      if (lr.type === 'compound') {
        const attrs = lr.selectors.filter(s => s.type === 'attribute');
        if (attrs.length > 0) {
          const compiled = attrs.map(a => _compileAttrCheck(a));
          if (compiled.some(c => !c)) return null; // failed to compile an attr → fall back
          lrAttrChecks = compiled;
          lrComplete = true;
        } else {
          lrComplete = true; // compound with only identifier (no attrs) → complete
        }
      }

      // Compile checks for the right side (the node itself: type + field)
      let nodeType = null, nodeField = null, rightComplete = false;
      if (right.type === 'identifier') {
        nodeType = right.value !== '*' ? right.value : null;
        rightComplete = true;
      } else if (right.type === 'field') {
        nodeField = right.name;
        rightComplete = true;
      } else if (right.type === 'compound') {
        const rIdent = right.selectors.find(s => s.type === 'identifier');
        const rField = right.selectors.find(s => s.type === 'field');
        const rAttrs = right.selectors.filter(s => s.type === 'attribute');
        if (rAttrs.length > 0) return null; // don't handle right-side attributes in 2-level (rare)
        if (rIdent && rIdent.value !== '*') nodeType = rIdent.value;
        if (rField) nodeField = rField.name;
        rightComplete = true;
      } else {
        return null;
      }

      const complete = llComplete && lrComplete && rightComplete;
      const lrChecks = lrAttrChecks; // closure capture
      return {
        fn: (n, a) => {
          if (!a || a.length < 2) return false;
          const par = a[0], gpar = a[1];
          if (gpar.type !== llType) return false;
          if (par.type !== lrType) return false;
          if (lrChecks) { for (let i = 0; i < lrChecks.length; i++) if (!lrChecks[i](par)) return false; }
          if (nodeType && n.type !== nodeType) return false;
          if (nodeField && par[nodeField] !== n) return false;
          return true;
        },
        complete
      };
    }

    const leftType = left.type === 'identifier' ? left.value :
                     (left.type === 'compound' ? (left.selectors.find(s => s.type === 'identifier') || {}).value : null);
    if (!leftType) return null;

    // Compile left (parent) attribute checks for compound left selectors (e.g. A[x!=y] > B)
    let leftAttrChecks = null;
    let leftComplete = left.type === 'identifier'; // simple identifier: complete
    if (left.type === 'compound') {
      const attrs = left.selectors.filter(s => s.type === 'attribute');
      if (attrs.length > 0) {
        const compiled = attrs.map(a => _compileAttrCheck(a));
        if (compiled.some(c => !c)) return null; // can't compile an attr → fall back
        leftAttrChecks = compiled;
        leftComplete = true;
      } else {
        leftComplete = true; // compound with identifier only, no attrs
      }
    }

    // Helper: check parent type + optional parent attribute conditions
    const lAttrChecks = leftAttrChecks; // closure capture for inner fns
    const checkParent = !lAttrChecks
      ? (a) => a && a.length > 0 && a[0].type === leftType
      : (a) => {
          if (!a || a.length === 0 || a[0].type !== leftType) return false;
          for (let i = 0; i < lAttrChecks.length; i++) if (!lAttrChecks[i](a[0])) return false;
          return true;
        };

    // A > B (right identifier)
    if (right.type === 'identifier') {
      return { fn: (_n, a) => checkParent(a), complete: leftComplete, requiredParentType: leftType };
    }
    // A > .field (right is a field selector)
    if (right.type === 'field') {
      const fieldName = right.name;
      return { fn: (n, a) => checkParent(a) && a[0][fieldName] === n, complete: leftComplete, requiredParentType: leftType };
    }
    // A > compound (wildcard/identifier + optional field + optional attributes on node)
    if (right.type === 'compound') {
      const rightIdent = right.selectors.find(s => s.type === 'identifier');
      const rightField = right.selectors.find(s => s.type === 'field');
      const rightAttrSelectors = right.selectors.filter(s => s.type === 'attribute');
      let rightAttrChecks = null;
      if (rightAttrSelectors.length > 0) {
        const compiled = rightAttrSelectors.map(a => _compileAttrCheck(a));
        if (compiled.some(c => !c)) return null;
        rightAttrChecks = compiled;
      }
      const fieldName = rightField ? rightField.name : null;
      const childType = rightIdent && rightIdent.value !== '*' ? rightIdent.value : null;
      const rChecks = rightAttrChecks;
      return {
        fn: (n, a) => {
          if (!checkParent(a)) return false;
          if (childType && n.type !== childType) return false;
          if (fieldName && a[0][fieldName] !== n) return false;
          if (rChecks) { for (let i = 0; i < rChecks.length; i++) if (!rChecks[i](n)) return false; }
          return true;
        },
        complete: leftComplete, // right checks fully compiled
        requiredParentType: leftType
      };
    }
    return null;
  }

  if (t === 'matches') {
    // Union selector: compile a fast matcher.
    // complete=true if every branch's fast matcher is complete (no esq.matches needed).
    const checks = [];
    let allComplete = true;
    for (const sel of parsedSelector.selectors) {
      if (sel.type === 'identifier') {
        if (sel.value === '*') return { fn: (_n, _a) => true, complete: false }; // wildcard — matches all
        const tv = sel.value;
        checks.push((n, _a) => n.type === tv);
        // identifier type-only check is complete
      } else if (sel.type === 'compound') {
        const branchMatcher = _compileSelectorFastMatcher(sel);
        if (branchMatcher) {
          checks.push(branchMatcher.fn);
          if (!branchMatcher.complete) allComplete = false;
        } else {
          // Fall back to type-only check (incomplete)
          const ident = sel.selectors.find(s => s.type === 'identifier');
          if (ident && ident.value !== '*') { const tv = ident.value; checks.push((n, _a) => n.type === tv); }
          else return { fn: (_n, _a) => true, complete: false };
          allComplete = false;
        }
      }
      else if (sel.type === 'child') {
        // Recursively compile a fast pre-filter for this branch
        const branchMatcher = _compileSelectorFastMatcher(sel);
        if (!branchMatcher) return null; // can't filter this branch → can't filter union
        checks.push(branchMatcher.fn);
        if (!branchMatcher.complete) allComplete = false;
      } else if (sel.type === 'class') {
        const resolved = _PSEUDO_CLASS_TYPES[sel.name];
        if (!resolved) return null; // unknown pseudo-class
        const typeSet = new Set(resolved);
        checks.push((n, _a) => typeSet.has(n.type));
        // pseudo-class type resolution is complete (exact type match)
      } else if (sel.type === 'not' || sel.type === 'has') {
        return null;
      } else {
        return null; // unknown branch type
      }
    }
    if (checks.length === 0) return null;
    if (checks.length === 1) { const c = checks[0]; return { fn: c, complete: allComplete }; }
    return { fn: (n, a) => { for (const c of checks) if (c(n, a)) return true; return false; }, complete: allComplete };
  }

  if (t === 'identifier') {
    // Type-only selector: always matches (type guaranteed by per-tag dispatch, or wildcard)
    return { fn: (_n, _a) => true, complete: true };
  }

  if (t === 'class') {
    const name = parsedSelector.name;
    if (name === 'function') {
      // :function matches FunctionDeclaration, FunctionExpression, ArrowFunctionExpression exactly
      return { fn: (n, _a) => n.type === 'FunctionDeclaration' || n.type === 'FunctionExpression' || n.type === 'ArrowFunctionExpression', complete: true };
    }
    if (name === 'expression') {
      // :expression per esquery: types ending in 'Expression', types ending in 'Literal',
      // Identifier (if parent is not MetaProperty), MetaProperty
      return {
        fn: (n, a) => {
          const tp = n.type;
          if (tp.endsWith('Expression') || tp.endsWith('Literal') || tp === 'MetaProperty') return true;
          if (tp === 'Identifier') return !a || a.length === 0 || a[0].type !== 'MetaProperty';
          return false;
        },
        complete: true
      };
    }
    return null;
  }

  return null;
}

function _compileAttrCheck(attr) {
  // Build a function (node) => boolean for a single attribute selector.
  const nameParts = attr.name.split('.');
  const op = attr.operator || null;
  const rawVal = attr.value != null ? attr.value.value : undefined;

  function accessPath(node) {
    let cur = node;
    for (const p of nameParts) {
      if (cur == null) return undefined;
      cur = cur[p];
    }
    return cur;
  }

  // Existence check: [attr] means attr != null
  if (!op) return (n) => accessPath(n) != null;
  // Literal comparisons: esquery coerces both sides to string ("true" === "".concat(true)).
  // Using == would fail for e.g. true == "true" (JS: 1 == NaN → false).
  if (op === '=')  { const sv = ''.concat(rawVal); return (n) => ''.concat(accessPath(n)) === sv; }
  if (op === '!=') { const sv = ''.concat(rawVal); return (n) => ''.concat(accessPath(n)) !== sv; }
  if (op === '<')  return (n) => accessPath(n) <  rawVal;
  if (op === '>')  return (n) => accessPath(n) >  rawVal;
  if (op === '<=') return (n) => accessPath(n) <= rawVal;
  if (op === '>=') return (n) => accessPath(n) >= rawVal;
  return null; // regexp, type checks, etc. — can't compile
}
// Live plan cache: when plugins are stable and safeHandlers are reused (buildVisitorMap
// hot path updates _state.inner in place), the fused items already reference the current
// handlers via _state. Skip _remapPlan entirely — SQL "prepared statement" reuse.
let _cachedLivePlanPlugins = null;
let _cachedLivePlan = null;
let _cachedSelectorPlanPlugins = null;
let _cachedSelectorPlan = null;

/**
 * Build (and cache) per-tag selector dispatch tables.
 * Avoids scanning all selectors per node — only checks selectors whose root type matches.
 * Cached by plugins identity; slot.handler refs in selectorsByTag* update automatically
 * each file (same slot objects reused by buildVisitorMap fast path).
 */
function _getOrBuildSelectorPlan(plugins, selectorHandlers, tagNames, tagCount) {
  if (_cachedSelectorPlanPlugins === plugins && _cachedSelectorPlan !== undefined) {
    return _cachedSelectorPlan;
  }
  const selectorTagArr = new Uint8Array(tagCount);
  const selectorsByTagEnter = new Array(tagCount).fill(null);
  const selectorsByTagExit  = new Array(tagCount).fill(null);
  // Universal handlers: selectors with unresolvable root type (e.g. `* > X`, `A > *.field`).
  // These must run for every node — kept separate from per-tag dispatch.
  const universalEnter = [];
  const universalExit  = [];
  for (const sh of selectorHandlers) {
    const rootType = _getSelectorRootTypes(sh.selector);
    // Compile fast matcher once per selector (cached on slot, stable across files)
    if (sh._fastMatcher === undefined) {
      sh._fastMatcher = _compileSelectorFastMatcher(sh.parsedSelector);
    }
    if (rootType === null) {
      // Unresolvable root type (e.g. universal selector *): must check every node.
      // For child-combinator selectors with a known parent type (e.g. "ForStatement > .test"),
      // store the parent tag index so invokeSelectorHandlers can pre-filter by parent tag,
      // avoiding getAncestorsFor for the ~99% of nodes that are not children of that parent type.
      if (sh._fastMatcher && sh._fastMatcher.requiredParentType && sh._fastMatcher.requiredParentTagIdx === undefined) {
        const pti = tagNames.indexOf(sh._fastMatcher.requiredParentType);
        sh._fastMatcher.requiredParentTagIdx = pti >= 0 ? pti : -1;
      }
      (sh.isExit ? universalExit : universalEnter).push(sh);
      continue;
    }
    const types = Array.isArray(rootType) ? rootType : [rootType];
    for (const rt of types) {
      // sanz uses variant tags: populate ALL tag indices for this type name.
      const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(rt) : null;
      const indices = allTags ? allTags : (tagNames.indexOf(rt) >= 0 ? [tagNames.indexOf(rt)] : []);
      for (let ki = 0; ki < indices.length; ki++) {
        const i = indices[ki];
        selectorTagArr[i] = 1;
        const byTag = sh.isExit ? selectorsByTagExit : selectorsByTagEnter;
        if (!byTag[i]) byTag[i] = [];
        byTag[i].push(sh);
      }
    }
  }
  _cachedSelectorPlanPlugins = plugins;
  _cachedSelectorPlan = { selectorTagArr, selectorsByTagEnter, selectorsByTagExit, universalEnter, universalExit };
  return _cachedSelectorPlan;
}

function _getOrBuildPlan(plugins, visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip, selectorHandlers) {
  // Cache keyed on plugins array identity — same array = same rule set.
  // In lint.js, the same plugins array is reused for every file.
  if (_cachedLivePlanPlugins === plugins && _cachedLivePlan) {
    // Fast path: safeHandlers are stable, _state.inner already updated by buildVisitorMap
    // hot path. No remapping needed — plan is current as-is.
    return _cachedLivePlan;
  }
  if (_cachedPlanPlugins === plugins && _cachedPlan) {
    const plan = _remapPlan(_cachedPlan, visitorMap, tagNames, tagCount);
    _cachedLivePlan = plan;
    _cachedLivePlanPlugins = plugins;
    return plan;
  }

  const plan = _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip, selectorHandlers);
  _cachedPlanPlugins = plugins;
  _cachedPlan = plan;
  _cachedLivePlan = plan;
  _cachedLivePlanPlugins = plugins;
  return plan;
}

const _BRANCH_STMT_TYPES = new Set(['IfStatement', 'TryStatement', 'SwitchStatement',
  'WhileStatement', 'DoWhileStatement', 'ForStatement', 'ForInStatement', 'ForOfStatement']);
const _CATCH_CASE_TYPES = new Set(['CatchClause', 'SwitchCase']);
const _TERMINATOR_TYPES = new Set(['ReturnStatement', 'ThrowStatement', 'BreakStatement', 'ContinueStatement']);

// Tag index sets and exit keys cached by tagNames identity — computed once per session,
// not per file. Saves ~2μs/file of Set construction and string allocation overhead.
let _tagSetCacheRef = null;
let _cachedBranchTagSet = null, _cachedCatchTagSet = null, _cachedTerminatorTagSet = null;
let _cachedIfStmtTagSet = null; // Set of ALL tag indices whose name is 'IfStatement'
let _cachedIfStmtTag = -1; // first IfStatement tag (used for elseStartNodes only)
let _cachedTryStmtTagSet = null; // Set of ALL tag indices whose name is 'TryStatement'
let _cachedDoWhileStmtTagSet = null; // Set of ALL tag indices whose name is 'DoWhileStatement'
let _cachedExitKeys = null; // indexed by tag int → 'TypeName:exit' pre-interned string
let _cachedTypeNameToTag = null; // Map<typeName, tagIndex> — last occurrence, for O(1) reverse lookup
let _cachedTypeNameToAllTags = null; // Map<typeName, Int32Array> — ALL variant tag indices

function _ensureTagCaches(tagNames) {
  if (_tagSetCacheRef === tagNames) return;
  _tagSetCacheRef = tagNames;
  // Build tag sets by iterating ALL tags (not indexOf which only finds first occurrence).
  // This handles sanz variants like if_stmt (tag 4) and if_else_stmt (tag 5) that share
  // the same ESTree type name 'IfStatement'.
  _cachedBranchTagSet    = new Set();
  _cachedCatchTagSet     = new Set();
  _cachedTerminatorTagSet = new Set();
  _cachedIfStmtTagSet    = new Set();
  _cachedTryStmtTagSet   = new Set();
  _cachedDoWhileStmtTagSet = new Set();
  for (let _t = 0; _t < tagNames.length; _t++) {
    const _tn = tagNames[_t];
    if (!_tn) continue;
    if (_BRANCH_STMT_TYPES.has(_tn)) _cachedBranchTagSet.add(_t);
    if (_CATCH_CASE_TYPES.has(_tn))  _cachedCatchTagSet.add(_t);
    if (_TERMINATOR_TYPES.has(_tn))  _cachedTerminatorTagSet.add(_t);
    if (_tn === 'IfStatement')       _cachedIfStmtTagSet.add(_t);
    if (_tn === 'TryStatement')      _cachedTryStmtTagSet.add(_t);
    if (_tn === 'DoWhileStatement')  _cachedDoWhileStmtTagSet.add(_t);
  }
  _cachedIfStmtTag = tagNames.indexOf('IfStatement');
  _cachedExitKeys = tagNames.map(t => t ? t + ':exit' : null);
  const m = new Map();
  const allTags = new Map(); // typeName → Array<int>
  for (let i = 0; i < tagNames.length; i++) {
    const tn = tagNames[i];
    if (!tn) continue;
    m.set(tn, i);
    let arr = allTags.get(tn);
    if (!arr) { arr = []; allTags.set(tn, arr); }
    arr.push(i);
  }
  // Convert to Int32Arrays for fast iteration
  const allTagsFinal = new Map();
  for (const [tn, arr] of allTags) allTagsFinal.set(tn, new Int32Array(arr));
  _cachedTypeNameToTag = m;
  _cachedTypeNameToAllTags = allTagsFinal;
}

/**
 * Build or retrieve tag-indexed handler arrays for a visitorMap.
 * Cached on the map object itself — rebuilt only when visitorMap changes
 * (first file per rule-set; reused for all subsequent files via recipe fast path).
 * Replaces O(1) Map.get(string) per node with O(1) array[int] per node.
 */
function _getTagHandlerArrays(visitorMap, tagCount) {
  if (visitorMap._tagHandlers) return visitorMap._tagHandlers;
  const enter = new Array(tagCount).fill(null);
  const exit  = new Array(tagCount).fill(null);
  // sanz uses variant tags: multiple tag indices per ESTree type name (e.g. BinaryExpression
  // has one tag per operator, Literal has one per literal kind). We must populate ALL variant
  // tags with the same handler array so that any variant fires the right visitors.
  for (const [key, handlers] of visitorMap) {
    if (key.endsWith(':exit')) {
      const typeName = key.slice(0, -5);
      const tags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(typeName) : null;
      if (tags) { for (let i = 0; i < tags.length; i++) exit[tags[i]] = handlers; }
    } else {
      const tags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(key) : null;
      if (tags) { for (let i = 0; i < tags.length; i++) enter[tags[i]] = handlers; }
    }
  }
  visitorMap._tagHandlers = enter;
  visitorMap._tagExitHandlers = exit;
  return enter;
}

// Esquery pseudo-class → concrete node type lists (from esquery source).
// These allow per-tag dispatch and fast matchers for :function and :expression.
const _PSEUDO_CLASS_TYPES = {
  'function': ['FunctionDeclaration', 'FunctionExpression', 'ArrowFunctionExpression'],
};

/**
 * Extract the node type(s) that a CSS selector key can match.
 * Returns a Set of type name strings. Returns null if ambiguous/unparseable.
 *
 * Examples:
 *   'BinaryExpression[operator="in"]'  → Set{'BinaryExpression'}
 *   'ExpressionStatement > NewExpression' → Set{'NewExpression'}
 *   'Literal[regex]'                   → Set{'Literal'}
 *   'MethodDefinition[kind="constructor"]:exit' → Set{'MethodDefinition'}
 */
function _getSelectorRootTypes(key) {
  // Strip :exit suffix
  const k = key.endsWith(':exit') ? key.slice(0, -5) : key;
  // Handle comma-separated union selectors: resolve each part individually
  if (k.includes(',')) {
    const types = [];
    for (const part of k.split(',')) {
      const t = _getSelectorRootTypes(part.trim());
      if (t === null) return null; // if any part is unresolvable, fall back to full scan
      if (Array.isArray(t)) { for (const tp of t) types.push(tp); }
      else types.push(t);
    }
    return types; // flat array of root types for union
  }
  // Get the last part after child combinator (>)
  const last = k.split('>').pop().trim();
  // Remove attribute selectors [...] (may span multiple), field access .field, pseudo-classes :class
  const typePart = last.replace(/\[[^\]]*\]/g, '').split('.')[0].replace(/:.*$/, '').trim();
  // Must start with uppercase letter to be a node type name
  if (/^[A-Z][A-Za-z]*$/.test(typePart)) return typePart;
  // Handle bare pseudo-class selectors like :function, :expression
  const pseudoMatch = last.match(/^:([a-z-]+)/);
  if (pseudoMatch) {
    const resolved = _PSEUDO_CLASS_TYPES[pseudoMatch[1]];
    if (resolved) return resolved; // array of concrete types
  }
  return null;
}

function _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip, selectorHandlers) {
  const FLAG_CODEPATH_ENTER = 1, FLAG_CLASS_BODY = 2, FLAG_METHOD_FN = 4, FLAG_CODEPATH_EXIT = 8;
  const FLAG_BRANCH_ENTER = 16, FLAG_CATCH_CASE = 32, FLAG_TERMINATOR = 64, FLAG_BRANCH_EXIT = 128;
  const FLAG_SELECTOR = 256;
  const tagEnterHandlers = new Array(tagCount);
  const tagExitHandlers  = new Array(tagCount);
  const tagFlags = new Uint16Array(tagCount);

  // Compute selector-relevant tags: only these need invokeSelectorHandlers called.
  // Universal selectors (null rootType, e.g. `A > *.field`) match any node type.
  const selectorRelevantTags = new Uint8Array(tagCount);
  let hasUniversalSelectors = false;
  if (selectorHandlers && selectorHandlers.length > 0) {
    for (const sh of selectorHandlers) {
      const rootType = _getSelectorRootTypes(sh.selector);
      if (rootType === null) { hasUniversalSelectors = true; continue; }
      const rtArr = Array.isArray(rootType) ? rootType : [rootType];
      for (const rt of rtArr) {
        const allTags = _cachedTypeNameToAllTags ? _cachedTypeNameToAllTags.get(rt) : null;
        if (allTags) { for (let ki = 0; ki < allTags.length; ki++) selectorRelevantTags[allTags[ki]] = 1; }
        else { const i = tagNames.indexOf(rt); if (i >= 0) selectorRelevantTags[i] = 1; }
      }
      // unknown tag name (e.g. TSModuleDeclaration not in sanz's tagNames): selector won't fire, skip
    }
  }

  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t];
    if (!tn) continue;
    tagEnterHandlers[t] = visitorMap.get(tn) || null;
    tagExitHandlers[t]  = visitorMap.get(tn + ':exit') || null;
    if (hasCodePath && CODE_PATH_TYPES.has(tn)) tagFlags[t] |= FLAG_CODEPATH_ENTER | FLAG_CODEPATH_EXIT;
    if (hasClassBody && CLASS_TYPES.has(tn))    tagFlags[t] |= FLAG_CLASS_BODY;
    if (hasMethodFn && tn === 'MethodDefinition') tagFlags[t] |= FLAG_METHOD_FN;
    if (hasCodePath) {
      if (_BRANCH_STMT_TYPES.has(tn)) tagFlags[t] |= FLAG_BRANCH_ENTER | FLAG_BRANCH_EXIT;
      if (_CATCH_CASE_TYPES.has(tn))  tagFlags[t] |= FLAG_CATCH_CASE;
      if (_TERMINATOR_TYPES.has(tn))  tagFlags[t] |= FLAG_TERMINATOR;
    }
    // Universal selectors require invokeSelectorHandlers on every node.
    if (selectorRelevantTags[t] || hasUniversalSelectors) {
      tagFlags[t] |= FLAG_SELECTOR;
    }
  }

  // Relevant tag set
  const relevantTag = new Uint8Array(tagCount);
  let relevantTagCount = 0;
  for (let t = 0; t < tagCount; t++) {
    if (tagEnterHandlers[t] || tagExitHandlers[t] || tagFlags[t]) {
      relevantTag[t] = 1;
      relevantTagCount++;
    }
  }

  // Rule fusion + compiled dispatch
  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t] || '';
    const enter = tagEnterHandlers[t];
    if (enter && enter.length > 1) {
      const fused = _fuseHandlers(enter, tn);
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
      fused._compiled = _buildCompiledDispatch(fused.items);
      tagEnterHandlers[t] = fused;
    }
    const exit = tagExitHandlers[t];
    if (exit && exit.length > 1) {
      const fused = _fuseHandlers(exit, tn + ':exit');
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
      fused._compiled = _buildCompiledDispatch(fused.items);
      tagExitHandlers[t] = fused;
    }
  }

  // File-level rule extraction
  const { fileLevelEnter, fileLevelExit } = _extractFileLevelRules(
    visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers
  );

  // Columnar batch scan
  const batchScannable = canSkip ? _extractBatchScannable(
    visitorMap, tagNames, tagCount, tagEnterHandlers, tagExitHandlers, tagFlags
  ) : new Map();

  // Record the structural template: for each slot, store the ruleId ordering
  // so _remapPlan can reconstruct with fresh handler references.
  const _template = _buildTemplate(tagEnterHandlers, tagExitHandlers, tagCount, fileLevelEnter, fileLevelExit, batchScannable);

  return { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
           fileLevelEnter, fileLevelExit, batchScannable, _template };
}

function _buildTemplate(tagEnterHandlers, tagExitHandlers, tagCount, fileLevelEnter, fileLevelExit, batchScannable) {
  // For each tag slot, record the ruleId+visitorKey ordering.
  // This lets _remapPlan reconstruct the plan with new handler refs.
  function slotTemplate(desc) {
    if (!desc) return null;
    if (desc._fused) {
      return { _fused: true, items: desc.items.map(it => ({
        ruleId: it.ruleId, cost: it.cost, parentGuard: it.parentGuard, _coalescedGuard: it._coalescedGuard
      }))};
    }
    return desc.map(it => ({ ruleId: it.ruleId }));
  }
  const enterTemplates = new Array(tagCount);
  const exitTemplates = new Array(tagCount);
  for (let t = 0; t < tagCount; t++) {
    enterTemplates[t] = slotTemplate(tagEnterHandlers[t]);
    exitTemplates[t] = slotTemplate(tagExitHandlers[t]);
  }
  return {
    enterTemplates, exitTemplates,
    fileLevelEnterIds: fileLevelEnter.map(h => h.ruleId),
    fileLevelExitIds: fileLevelExit.map(h => h.ruleId),
    batchScannableIds: new Map([...batchScannable].map(([tn, hs]) => [tn, hs.map(h => h.ruleId)])),
  };
}

function _remapPlan(cachedPlan, visitorMap, tagNames, tagCount) {
  const { _template, tagFlags, relevantTag, relevantTagCount } = cachedPlan;
  // Build ruleId+key → handler lookup from fresh visitorMap
  const handlerByKey = new Map();
  const handlerByRule = new Map();
  for (const [key, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : [handlers];
    for (const h of items) {
      if (h.ruleId) {
        handlerByKey.set(h.ruleId + '|' + key, h);
        if (!handlerByRule.has(h.ruleId)) handlerByRule.set(h.ruleId, h);
      }
    }
  }

  function remapSlot(template, tagName) {
    if (!template) return null;
    if (template._fused) {
      const items = [];
      for (let i = 0; i < template.items.length; i++) {
        const t = template.items[i];
        const fresh = handlerByKey.get(t.ruleId + '|' + tagName) || handlerByRule.get(t.ruleId);
        if (fresh) items.push({ _state: fresh._state || null, handler: fresh.handler, ruleId: t.ruleId, ruleMeta: fresh.ruleMeta, ruleOptions: fresh.ruleOptions, cost: t.cost, parentGuard: t.parentGuard, _coalescedGuard: t._coalescedGuard });
      }
      return items.length > 0 ? { items, length: items.length, _fused: true } : null;
    }
    const arr = [];
    for (let i = 0; i < template.length; i++) {
      const fresh = handlerByKey.get(template[i].ruleId + '|' + tagName) || handlerByRule.get(template[i].ruleId);
      if (fresh) arr.push(fresh);
    }
    return arr.length > 0 ? arr : null;
  }

  const tagEnterHandlers = new Array(tagCount);
  const tagExitHandlers = new Array(tagCount);
  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t] || '';
    tagEnterHandlers[t] = remapSlot(_template.enterTemplates[t], tn);
    tagExitHandlers[t] = remapSlot(_template.exitTemplates[t], tn + ':exit');
  }

  const fileLevelEnter = _remapList(_template.fileLevelEnterIds, 'Program', handlerByKey, handlerByRule);
  const fileLevelExit = _remapList(_template.fileLevelExitIds, 'Program:exit', handlerByKey, handlerByRule);
  const batchScannable = new Map();
  for (const [tn, ruleIds] of _template.batchScannableIds) {
    const hs = _remapList(ruleIds, tn, handlerByKey, handlerByRule);
    if (hs.length > 0) batchScannable.set(tn, hs);
  }

  return { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
           fileLevelEnter, fileLevelExit, batchScannable, _template };
}

function _remapList(ruleIds, key, handlerByKey, handlerByRule) {
  const result = [];
  for (let i = 0; i < ruleIds.length; i++) {
    const fresh = handlerByKey.get(ruleIds[i] + '|' + key) || handlerByRule.get(ruleIds[i]);
    if (fresh) result.push(fresh);
  }
  return result;
}

/**
 * Walk all AST nodes in DFS order: enter (pre-order) then exit (post-order).
 * Proper DFS ensures parents are visited before children on enter, and
 * children before parents on exit — matching real ESLint traversal semantics.
 * Errors are caught per-handler so one failing plugin doesn't abort others.
 */
function walkNodes(ast, visitorMapResult, context, tagNames, plugins) {
  const { map: visitorMap, selectorHandlers } = visitorMapResult;

  // Fast exit: no rules registered any visitors — nothing to dispatch.
  if (visitorMap.size === 0 && selectorHandlers.length === 0) {
    context._skipSet = null;
    context.sourceCode._nodesByType = null;
    context.sourceCode.getNodesByType = function() { return []; };
    return;
  }

  // Ensure tag index Sets and exit key strings are built (cached across files).
  _ensureTagCaches(tagNames);

  const nodeTags = ast.nodeTags;
  // Use Zig-precomputed DFS orders if available (v4 buffer), else compute in JS.
  const { preOrder, postOrder } = (ast._preOrder && ast._postOrder)
    ? { preOrder: ast._preOrder, postOrder: ast._postOrder }
    : buildDFSOrders(ast);

  // For selector matching, we need ancestors. Build the ancestors array lazily per node.
  const hasSelectors = selectorHandlers.length > 0;
  const esq = hasSelectors ? esquery() : null;
  const pd = ast._parentData;

  // Reusable ancestors buffer — reset per node, never reallocated.
  // Safe: esquery only reads the array; both _runSelectorList calls per node are synchronous.
  const _ancestorsBuf = [];

  function getAncestorsFor(nodeIdx) {
    _ancestorsBuf.length = 0;
    if (!pd) return _ancestorsBuf;
    // esquery expects ancestors[0] = immediate parent (closest first), not root-first.
    let p = pd[nodeIdx];
    while (p !== NONE && p !== undefined && p < ast.nodeCount) {
      _ancestorsBuf.push(nodeView(ast, p));
      p = pd[p];
    }
    return _ancestorsBuf;
  }

  function invokeHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    context._currentNodeIdx = nodeIdx;
    for (let h = 0; h < handlers.length; h++) handlers[h].handler(node);
  }

  function invokeSelectorHandlers(nodeIdx, isExit) {
    if (!esq || selectorHandlers.length === 0) return;
    const tag = nodeTags[nodeIdx];
    const byTag = isExit ? selectorsByTagExit : selectorsByTagEnter;
    const universal = isExit ? _universalExit : _universalEnter;
    const handlers = byTag ? byTag[tag] : (universal ? null : selectorHandlers);
    const hasHandlers = (handlers && handlers.length > 0) || (universal && universal.length > 0);
    if (!hasHandlers) return;
    const node = nodeView(ast, nodeIdx);
    let ancestors = null; // lazy — only compute if a selector needs them
    context._currentNodeIdx = nodeIdx;
    function _runSelectorList(list) {
      for (let h = 0; h < list.length; h++) {
        const sh = list[h];
        try {
          const fm = sh._fastMatcher;
          if (fm) {
            // Parent tag pre-check: for child-combinator selectors with a known parent type
            // (e.g. "ForStatement > .test"), skip getAncestorsFor when parent tag doesn't match.
            // This avoids O(n) ancestor allocation for the vast majority of nodes.
            if (fm.requiredParentTagIdx !== undefined && fm.requiredParentTagIdx >= 0) {
              const pIdx = pd ? pd[nodeIdx] : NONE;
              if (pIdx === NONE || pIdx >= nodeTags.length || nodeTags[pIdx] !== fm.requiredParentTagIdx) continue;
            }
            // Fast path: use pre-compiled matcher
            let matched;
            if (!fm.complete || fm.fn.length >= 2) {
              // Needs ancestors (child combinator)
              if (ancestors === null) ancestors = getAncestorsFor(nodeIdx);
              matched = fm.fn(node, ancestors);
            } else {
              matched = fm.fn(node, null);
            }
            if (!matched) continue;
            if (fm.complete) { sh.handler(node); continue; }
            // complete=false: fast matcher is a pre-filter only, still need esq.matches
          }
          // Fallback: full esq.matches
          if (ancestors === null) ancestors = getAncestorsFor(nodeIdx);
          if (esq.matches(node, sh.parsedSelector, ancestors)) {
            sh.handler(node);
          }
        } catch (err) {
          context._reports.push({
            ruleId: sh.ruleId,
            message: `Plugin error: ${err.message}`,
          });
        }
      }
    }
    if (handlers && handlers.length > 0) _runSelectorList(handlers);
    if (universal && universal.length > 0) _runSelectorList(universal);
  }

  function invokeCodePathHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    const cp = cpTracker.codePath;
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(cp, node);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(cp, node); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  // Synthetic ClassBody node (passed to ClassBody/ClassBody:exit handlers).
  // We reuse a single object and update the class node reference each time.
  // _i and _ast are set so getFirstToken/getLastToken work correctly.
  const syntheticClassBody = { type: 'ClassBody', body: null, parent: null, mainToken: 0, _ast: ast, _i: 0 };

  function invokeClassBodyHandlers(classNodeIdx, isExit) {
    const classBodyKey = isExit ? 'ClassBody:exit' : 'ClassBody';
    if (!visitorMap.has(classBodyKey)) return;
    // Build the synthetic ClassBody node pointing to this class
    const classNode = nodeView(ast, classNodeIdx);
    syntheticClassBody.body = classNode.body?.body || [];
    syntheticClassBody.parent = classNode;
    syntheticClassBody.mainToken = classNode.mainToken;
    syntheticClassBody._i = classNodeIdx;
    // Copy loc/range/start/end from class node so layout rules work
    syntheticClassBody.start = classNode.start;
    syntheticClassBody.end = classNode.end;
    syntheticClassBody.range = classNode.range;
    syntheticClassBody.loc = classNode.loc;
    const handlers = visitorMap.get(classBodyKey);
    context._currentNodeIdx = classNodeIdx;
    for (let h = 0; h < handlers.length; h++) {
      try {
        handlers[h].handler(syntheticClassBody);
      } catch (err) {
        context._reports.push({
          ruleId: handlers[h].ruleId,
          message: `Plugin error: ${err.message}`,
        });
      }
    }
  }

  // ── FunctionExpression synthesis for class methods ───────────────
  // sanz has no FunctionExpression node in the AST for class methods.
  // Synthesize FunctionExpression enter/exit and onCodePathStart/End events
  // so rules like no-constructor-return and getter-return work correctly.

  const cpTracker = new CodePathTracker();

  function invokeCodePathHandlersWithNode(mapKey, node) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const cp = cpTracker.codePath;
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(cp, node);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(cp, node); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  // Reused second arg for segment events — rules that use onCodePathSegmentStart(seg, node)
  // receive this as `node`; all observed rules ignore it so we avoid allocating {} per call.
  const _segEventNode = {};
  // Pre-cache segment event handler arrays — eliminates visitorMap.get() on every branch point.
  const _segStartH    = visitorMap.get('onCodePathSegmentStart') || null;
  const _segEndH      = visitorMap.get('onCodePathSegmentEnd') || null;
  const _unreachStartH = visitorMap.get('onUnreachableCodePathSegmentStart') || null;
  const _unreachEndH  = visitorMap.get('onUnreachableCodePathSegmentEnd') || null;

  function _dispatchSeg(handlers, seg) {
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(seg, _segEventNode);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(seg, _segEventNode); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  function invokeSegmentEvent(eventName, segment) {
    let handlers;
    if (eventName === 'onCodePathSegmentStart')             handlers = _segStartH;
    else if (eventName === 'onCodePathSegmentEnd')          handlers = _segEndH;
    else if (eventName === 'onUnreachableCodePathSegmentStart') handlers = _unreachStartH;
    else if (eventName === 'onUnreachableCodePathSegmentEnd')   handlers = _unreachEndH;
    else handlers = visitorMap.get(eventName);
    if (!handlers) return;
    _dispatchSeg(handlers, segment);
  }
  // Specialized helpers for the two common reachability-conditional patterns.
  // Eliminates string switch + function call vs plain handler lookup + dispatch.
  function _segEndEvent(seg) {
    const h = seg.reachable ? _segEndH : _unreachEndH;
    if (h) _dispatchSeg(h, seg);
  }
  function _segStartOrUnreachEvent(seg) {
    const h = seg.reachable ? _segStartH : _unreachStartH;
    if (h) _dispatchSeg(h, seg);
  }

  function invokeHandlersWithNode(mapKey, node, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    context._currentNodeIdx = nodeIdx;
    const hn = handlers.length;
    let h = 0;
    try {
      for (; h < hn; h++) handlers[h]._state.inner(node);
    } catch (err) {
      context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      for (let k = h + 1; k < hn; k++) {
        try { handlers[k]._state.inner(node); }
        catch (e) { context._reports.push({ ruleId: handlers[k].ruleId, message: `Plugin error: ${e.message}` }); }
      }
    }
  }

  function invokeMethodFnHandlers(methodNodeIdx, isExit) {
    const fnKey = isExit ? 'FunctionExpression:exit' : 'FunctionExpression';
    const hasFn = visitorMap.has(fnKey);
    const hasCodePath = visitorMap.has(isExit ? 'onCodePathEnd' : 'onCodePathStart');
    if (!hasFn && !hasCodePath) return;

    const methodNode = nodeView(ast, methodNodeIdx);
    // Use node.value which already computes async/generator/params/body from the buffer
    const fnExpr = methodNode.value;
    if (!fnExpr || fnExpr.type !== 'FunctionExpression') return;
    // Augment with parent pointer and position info for rules that inspect node.parent
    fnExpr.parent = methodNode;
    fnExpr.end = methodNode.end;
    fnExpr.range = methodNode.range;
    fnExpr.loc = methodNode.loc;
    fnExpr._ast = ast;
    fnExpr._i = methodNodeIdx;

    if (!isExit) {
      const outerSeg = cpTracker.segment;
      if (outerSeg) _segEndEvent(outerSeg);
      const { segment } = cpTracker.enterFunction(fnExpr);
      invokeCodePathHandlersWithNode('onCodePathStart', fnExpr);
      if (_segStartH) _dispatchSeg(_segStartH, segment);
      if (hasFn) invokeHandlersWithNode(fnKey, fnExpr, methodNodeIdx);
    } else {
      if (hasFn) invokeHandlersWithNode(fnKey, fnExpr, methodNodeIdx);
      const oldSeg = cpTracker.segment;
      if (oldSeg) _segEndEvent(oldSeg);
      invokeCodePathHandlersWithNode('onCodePathEnd', fnExpr);
      cpTracker.exitFunction();
      const outerSeg = cpTracker.segment;
      if (outerSeg) _segStartOrUnreachEvent(outerSeg);
    }
  }

  const hasCodePath  = visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd');
  const hasClassBody = visitorMap.has('ClassBody') || visitorMap.has('ClassBody:exit');
  const hasMethodFn  = visitorMap.has('FunctionExpression') || visitorMap.has('FunctionExpression:exit') ||
                       visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd');
  // canSkip: true allows the DFS to skip nodes with no handlers or flags.
  // With selector type-filtering (FLAG_SELECTOR in tagFlags), we can skip even with selectors.
  // Set to true always; FLAG_SELECTOR handles selector-relevant tags.
  const canSkip = true;
  const tagCount = tagNames.length;
  const FLAG_CODEPATH_ENTER = 1;
  const FLAG_CLASS_BODY     = 2;
  const FLAG_METHOD_FN      = 4;
  const FLAG_CODEPATH_EXIT  = 8;
  const FLAG_BRANCH_ENTER   = 16;
  const FLAG_CATCH_CASE     = 32;
  const FLAG_TERMINATOR     = 64;
  const FLAG_BRANCH_EXIT    = 128;
  const FLAG_SELECTOR       = 256;
  // Use pre-cached tag index Sets (built once per session in _ensureTagCaches, not per file).
  const ifStmtTag = _cachedIfStmtTag;
  const _ifStmtTagSet = _cachedIfStmtTagSet;
  const _tryStmtTagSet = _cachedTryStmtTagSet;
  const _doWhileStmtTagSet = _cachedDoWhileStmtTagSet;
  const _branchEnterTagSet = _cachedBranchTagSet;
  const _catchCaseTagSet = _cachedCatchTagSet;
  const _terminatorTagSet = _cachedTerminatorTagSet;
  const _exitKeys = _cachedExitKeys; // 'TypeName:exit' pre-interned strings indexed by tag int
  // Per-tag selector dispatch (cached by plugin set, not per-file):
  // selectorsByTagEnter/Exit[tagIdx] = selectors whose root type == tagNames[tagIdx].
  // Avoids looping all selectors per node; slot.handler refs update automatically per file.
  const _selPlan = hasSelectors ? _getOrBuildSelectorPlan(plugins, selectorHandlers, tagNames, tagCount) : null;
  const _selectorTagArr     = _selPlan ? _selPlan.selectorTagArr     : null;
  const selectorsByTagEnter = _selPlan ? _selPlan.selectorsByTagEnter : null;
  const selectorsByTagExit  = _selPlan ? _selPlan.selectorsByTagExit  : null;
  const _universalEnter     = _selPlan && _selPlan.universalEnter.length > 0 ? _selPlan.universalEnter : null;
  const _universalExit      = _selPlan && _selPlan.universalExit.length  > 0 ? _selPlan.universalExit  : null;
  // When universal selectors exist, they must fire on every node for that event type.
  const _hasUniversalEnter = _universalEnter !== null;
  const _hasUniversalExit  = _universalExit  !== null;

  // ── Small file fast path ──────────────────────────────────────
  // For files with < 100 nodes, skip the full optimizer (plan remap,
  // subtree pruning, materialized views, batch scan, etc.) and use
  // a simple DFS with direct visitorMap lookups. The optimizer overhead
  // (0.5ms) exceeds the DFS cost on these tiny files.
  // ── Interleaved DFS traversal ──────────────────────────────────
  // Build a single event sequence that interleaves enter (pre-order)
  // and exit (post-order) events in correct DFS order. This ensures
  // rules that maintain state across enter/exit (e.g., block-scoped-var's
  // scope stack) see events in the right order.
  // Event format: positive index = enter, ~index (bitwise NOT) = exit.
  function buildInterleavedDFS() {
    const n = ast.nodeCount;
    const events = new Int32Array(n * 2);
    let ei = 0, pi = 0, qi = 0;
    while (pi < n || qi < n) {
      // If we still have pre-order entries and the next pre comes before
      // (or at same position as) the next post, emit enter.
      // Strategy: pre[pi] < post[qi] means enter first.
      // We use the pre/post indices directly — in a correct DFS,
      // a node's enter always comes before its exit.
      if (pi < n && (qi >= n || preOrder[pi] !== postOrder[qi])) {
        events[ei++] = preOrder[pi++];
      } else if (qi < n) {
        events[ei++] = ~postOrder[qi++];
        // After emitting an exit, check if the next pre is also ready
      }
      // Advance post while the next post matches what we've already entered
      while (qi < n && pi < n && postOrder[qi] === preOrder[pi - 1]) {
        // This shouldn't happen in normal DFS — break to avoid infinite loop
        break;
      }
    }
    return { events, count: ei };
  }

  // Use Zig-precomputed DFS events if available (v5 buffer), else compute in JS.
  function getDFSEvents() {
    if (ast._dfsEvents) {
      // Find the actual count (events may be zero-padded if fewer were emitted)
      let count = ast._dfsEvents.length;
      while (count > 0 && ast._dfsEvents[count - 1] === 0 && count > 1) count--;
      // But 0 could be a valid enter(0) event. Use the full 2n length.
      return { events: ast._dfsEvents, count: ast.nodeCount * 2 };
    }
    return buildDFSEvents();
  }

  // JS fallback: reconstruct correct DFS from pre-order + parent data.
  function buildDFSEvents() {
    const n = preOrder.length;
    const events = new Int32Array(n * 2);
    let ei = 0;
    // Use a stack to track when to emit exits
    const stack = [];
    for (let i = 0; i < n; i++) {
      const idx = preOrder[i];
      // Pop exits: any node on the stack that is NOT an ancestor of idx
      while (stack.length > 0) {
        const top = stack[stack.length - 1];
        // Check if top is ancestor of idx using parent data
        let isAncestor = false;
        if (pd) {
          let p = pd[idx];
          while (p !== NONE && p !== undefined && p < ast.nodeCount) {
            if (p === top) { isAncestor = true; break; }
            p = pd[p];
          }
        }
        if (isAncestor) break;
        stack.pop();
        events[ei++] = ~top; // exit
      }
      events[ei++] = idx; // enter
      stack.push(idx);
    }
    // Flush remaining exits
    while (stack.length > 0) {
      events[ei++] = ~stack.pop();
    }
    return { events, count: ei };
  }

  // Pre-compute else-branch starters — marks nodes that are the `alternate` child of an
  // IfStatement. Eliminates per-node parent check in the DFS hot path (both paths).
  const elseStartNodes = hasCodePath && pd ? (() => {
    const arr = new Uint8Array(ast.nodeCount);
    for (let i = 0; i < ast.nodeCount; i++) {
      if (_ifStmtTagSet && _ifStmtTagSet.has(nodeTags[i])) {
        const ifN = nodeView(ast, i);
        if (ifN.alternate) arr[ifN.alternate._i] = 1;
      }
    }
    return arr;
  })() : null;

  // ── Catch stack: transparent parent pre-warming for findParentCatch ──
  // preserve-caught-error calls node.parent in a loop up to the nearest CatchClause.
  // During DFS we maintain a stack of CatchClause/function-boundary indices so that
  // when we visit a ThrowStatement we can pre-warm those parent pointers in one pass.
  // Cost: near-zero for files with no ThrowStatement nodes; O(depth) only for throws.
  const _throwStmtTag   = _cachedTypeNameToTag !== null ? (_cachedTypeNameToTag.get('ThrowStatement')   ?? -1) : -1;
  const _catchClauseTag = _cachedTypeNameToTag !== null ? (_cachedTypeNameToTag.get('CatchClause')       ?? -1) : -1;
  // Uint8Array for O(1) tag membership checks in the hot path.
  const _catchBarrierTagArr = new Uint8Array(tagCount);
  for (const _bn of ['FunctionDeclaration','FunctionExpression','ArrowFunctionExpression','StaticBlock']) {
    const _bt = _cachedTypeNameToTag !== null ? _cachedTypeNameToTag.get(_bn) : undefined;
    if (_bt !== undefined) _catchBarrierTagArr[_bt] = 1;
  }
  // Only activate the catch stack when a rule actually listens to ThrowStatement.
  const catchStack = (_throwStmtTag >= 0 && visitorMap.has('ThrowStatement') && pd) ? [] : null;
  // For the large-file DFS skip guard: which tags must not be pruned for catch-stack bookkeeping.
  // (CatchClause and barrier types must be visited to keep the stack consistent.)
  const _catchStackTrackArr = catchStack !== null ? (() => {
    const a = new Uint8Array(tagCount);
    if (_catchClauseTag >= 0) a[_catchClauseTag] = 1;
    for (let _t = 0; _t < tagCount; _t++) if (_catchBarrierTagArr[_t]) a[_t] = 1;
    return a;
  })() : null;

  if (ast.nodeCount < 100) {
    context._skipSet = null;
    // Lazy nodesByType for rules that need it
    context.sourceCode._nodesByType = null;
    context.sourceCode.getNodesByType = function(typeName) {
      if (!this._nodesByType) {
        this._nodesByType = new Map();
        for (let i = 0; i < ast.nodeCount; i++) {
          const tn2 = tagNames[nodeTags[i]];
          if (tn2) {
            let a = this._nodesByType.get(tn2);
            if (!a) { a = []; this._nodesByType.set(tn2, a); }
            a.push(i);
          }
        }
      }
      const indices = this._nodesByType.get(typeName);
      if (!indices) return [];
      return indices.map(idx2 => nodeView(this._ast, idx2));
    };
    // Check if any rule listens for PrivateIdentifier — if so, we need to
    // dispatch Identifier nodes that are actually PrivateIdentifiers to that handler too.
    const hasPrivateId = visitorMap.has('PrivateIdentifier');
    const hasPrivateIdExit = visitorMap.has('PrivateIdentifier:exit');
    const identTag = tagNames.indexOf('Identifier');

    // For MemberExpression with private property, we also need to synthesize
    // PrivateIdentifier visits since the property isn't a real AST node.
    const hasMemberPrivate = hasPrivateId && (visitorMap.has('MemberExpression') || visitorMap.has('PrivateIdentifier'));
    const memberExprTag = tagNames.indexOf('MemberExpression');

    // Use interleaved DFS to ensure enter/exit events fire in correct order.
    const { events, count: evCount } = getDFSEvents();
    // Pre-index handler arrays by tag int — replaces Map.get(string) per node with array[int].
    // Cached on visitorMap object (stable across files via recipe fast path).
    const _tagHandlers     = _getTagHandlerArrays(visitorMap, tagCount);
    const _tagExitHandlers = visitorMap._tagExitHandlers;
    for (let i = 0; i < evCount; i++) {
      const ev = events[i];
      if (ev >= 0) {
        // Enter event
        const idx = ev;
        const tag = nodeTags[idx];
        let tn = tagNames[tag];
        if (!tn) continue;
        const isMethodNode = tn === 'MethodDefinition'; // save before remap
        // Remap MethodDefinition → Property inside object literals (ESTree convention)
        if (isMethodNode && pd) {
          const pi2 = pd[idx];
          if (pi2 !== NONE && pi2 < ast.nodeCount) {
            const pt = nodeTags[pi2];
            if (tagNames[pt] === 'ObjectExpression' || tagNames[pt] === 'ObjectPattern') tn = 'Property';
          }
        }
        // Catch stack: bookkeep CatchClause/function-boundary for ThrowStatement pre-warming
        if (catchStack !== null) {
          if (tag === _catchClauseTag) {
            catchStack.push(idx);
          } else if (_catchBarrierTagArr[tag]) {
            catchStack.push(-1); // function boundary — no enclosing catch in this scope
          } else if (tag === _throwStmtTag) {
            // Pre-warm parent pointers up to nearest CatchClause so rule's node.parent calls hit cache.
            const top = catchStack.length > 0 ? catchStack[catchStack.length - 1] : -1;
            if (top >= 0) {
              let _p = pd[idx];
              while (_p !== NONE && _p !== undefined && _p < ast.nodeCount) {
                nodeView(ast, _p).parent; // populate .parent cache (idempotent)
                if (_p === top) break;
                if (_catchBarrierTagArr[nodeTags[_p]]) break;
                _p = pd[_p];
              }
            }
          }
        }
        if (hasCodePath && CODE_PATH_TYPES.has(tn)) {
          // End outer segment before starting a new code path
          const outerSeg = cpTracker.segment;
          if (outerSeg) _segEndEvent(outerSeg);
          const { segment } = cpTracker.enterFunction(nodeView(ast, idx));
          invokeCodePathHandlers('onCodePathStart', idx);
          if (_segStartH) _dispatchSeg(_segStartH, segment);
        }
        // Branch points (integer tag checks — no string comparisons)
        if (hasCodePath) {
          if (_branchEnterTagSet.has(tag)) {
            cpTracker.enterBranch();
          }
          if (_catchCaseTagSet.has(tag)) {
            const oldSeg = cpTracker.segment;
            if (oldSeg) _segEndEvent(oldSeg);
            const seg = cpTracker.nextBranch();
            if (seg) _segStartOrUnreachEvent(seg);
          }
          // Detect else branch (pre-computed map)
          if (elseStartNodes && elseStartNodes[idx]) {
            const oldSeg = cpTracker.segment;
            if (oldSeg) _segEndEvent(oldSeg);
            const seg = cpTracker.nextBranch();
            if (seg) _segStartOrUnreachEvent(seg);
          }
        }
        const enter = isMethodNode ? visitorMap.get(tn) : _tagHandlers[tag];
        if (enter) {
          const node = nodeView(ast, idx);
          context._currentNodeIdx = idx;
          let _eh = 0;
          try {
            for (; _eh < enter.length; _eh++) enter[_eh]._state.inner(node);
          } catch (err) {
            context._reports.push({ ruleId: enter[_eh].ruleId, message: `Plugin error: ${err.message}` });
            for (let _ek = _eh + 1; _ek < enter.length; _ek++) {
              try { _invokeFusedItem(enter[_ek], node, context); }
              catch (e) { context._reports.push({ ruleId: enter[_ek].ruleId, message: `Plugin error: ${e.message}` }); }
            }
          }
        }
        // PrivateIdentifier dispatch: Identifier nodes with # prefix
        if (hasPrivateId && tag === identTag) {
          const pos = ast._tokStarts[ast._mainTokens[idx]];
          if (pos < ast.source.length && ast.source.charCodeAt(pos) === 35) {
            const privEnter = visitorMap.get('PrivateIdentifier');
            if (privEnter) {
              const node = nodeView(ast, idx);
              for (let h = 0; h < privEnter.length; h++) {
                const hd = privEnter[h];
                context._currentNodeIdx = idx;
                hd.handler(node);
              }
            }
          }
        }
        // Synthesize PrivateIdentifier visit for MemberExpression with private property
        if (hasMemberPrivate && (tag === memberExprTag || tn === 'MemberExpression')) {
          const rhs = ast.nodeRhs(idx);
          if (rhs !== NONE) {
            const propStart = ast._tokStarts[rhs];
            if (propStart < ast.source.length && ast.source.charCodeAt(propStart) === 35) {
              const synth = ast._syntheticId(rhs);
              const privEnter = visitorMap.get('PrivateIdentifier');
              if (privEnter && synth.type === 'PrivateIdentifier') {
                synth.parent = nodeView(ast, idx);
                for (let h = 0; h < privEnter.length; h++) {
                  privEnter[h].handler(synth);
                }
              }
            }
          }
        }
        if (hasClassBody && CLASS_TYPES.has(tn)) invokeClassBodyHandlers(idx, false);
        if (hasMethodFn && isMethodNode) invokeMethodFnHandlers(idx, false);
        if ((_selectorTagArr && _selectorTagArr[tag]) || _hasUniversalEnter) invokeSelectorHandlers(idx, false);
      } else {
        // Exit event (bitwise NOT to get node index)
        const idx = ~ev;
        const tag = nodeTags[idx];
        let tn = tagNames[tag];
        if (!tn) continue;
        const isMethodNode = tn === 'MethodDefinition'; // save before remap
        // Remap MethodDefinition → Property inside object literals
        if (isMethodNode && pd) {
          const pi2 = pd[idx];
          if (pi2 !== NONE && pi2 < ast.nodeCount) {
            const pt = nodeTags[pi2];
            if (tagNames[pt] === 'ObjectExpression' || tagNames[pt] === 'ObjectPattern') tn = 'Property';
          }
        }
        // Catch stack: pop on CatchClause/function-boundary exit
        if (catchStack !== null && (tag === _catchClauseTag || _catchBarrierTagArr[tag])) {
          catchStack.pop();
        }
        // Code-path: terminators mark subsequent code unreachable (integer tag checks)
        if (hasCodePath) {
          if (_terminatorTagSet.has(tag)) {
            const oldSeg = cpTracker.segment;
            if (oldSeg) if (_segEndH) _dispatchSeg(_segEndH, oldSeg);
            cpTracker.markUnreachable();
            const unreachSeg = cpTracker.segment;
            if (_unreachStartH) _dispatchSeg(_unreachStartH, unreachSeg);
          }
        }
        if (hasClassBody && CLASS_TYPES.has(tn)) invokeClassBodyHandlers(idx, true);
        // Use pre-indexed array (no Map lookup, no string allocation); fall back on remap (MethodDefinition→Property)
        const exit = isMethodNode ? visitorMap.get(tn + ':exit') : _tagExitHandlers[tag];
        if (exit) {
          const node = nodeView(ast, idx);
          context._currentNodeIdx = idx;
          let _xh = 0;
          try {
            for (; _xh < exit.length; _xh++) exit[_xh]._state.inner(node);
          } catch (err) {
            context._reports.push({ ruleId: exit[_xh].ruleId, message: `Plugin error: ${err.message}` });
            for (let _xk = _xh + 1; _xk < exit.length; _xk++) {
              try { _invokeFusedItem(exit[_xk], node, context); }
              catch (e) { context._reports.push({ ruleId: exit[_xk].ruleId, message: `Plugin error: ${e.message}` }); }
            }
          }
        }
        // PrivateIdentifier:exit dispatch
        if (hasPrivateIdExit && tag === identTag) {
          const pos = ast._tokStarts[ast._mainTokens[idx]];
          if (pos < ast.source.length && ast.source.charCodeAt(pos) === 35) {
            const privExit = visitorMap.get('PrivateIdentifier:exit');
            if (privExit) {
              const node = nodeView(ast, idx);
              context._currentNodeIdx = idx;
              for (let h = 0; h < privExit.length; h++) {
                privExit[h].handler(node);
              }
            }
          }
        }
        if (hasMethodFn && isMethodNode) invokeMethodFnHandlers(idx, true);
        // Exit branching statements — merge reachability
        if (hasCodePath && _branchEnterTagSet.has(tag)) {
          const oldSeg = cpTracker.segment;
          if (oldSeg) _segEndEvent(oldSeg);
          const hasAllBranches = (_ifStmtTagSet && _ifStmtTagSet.has(tag) && nodeView(ast, idx).alternate != null) ||
            (_tryStmtTagSet && _tryStmtTagSet.has(tag) && nodeView(ast, idx).handler != null) ||
            (_doWhileStmtTagSet && _doWhileStmtTagSet.has(tag));
          const seg = cpTracker.exitBranch(hasAllBranches);
          _segStartOrUnreachEvent(seg);
        }
        if (hasCodePath && CODE_PATH_TYPES.has(tn)) {
          const oldSeg = cpTracker.segment;
          if (oldSeg) _segEndEvent(oldSeg);
          // Fire onCodePathEnd BEFORE exitFunction — rule needs to see the function's codePath
          invokeCodePathHandlers('onCodePathEnd', idx);
          cpTracker.exitFunction();
          // Restore outer segment
          const outerSeg = cpTracker.segment;
          if (outerSeg) _segStartOrUnreachEvent(outerSeg);
        }
        if ((_selectorTagArr && _selectorTagArr[tag]) || _hasUniversalExit) invokeSelectorHandlers(idx, true);
      }
    }
    return;
  }

  // ── Full optimizer path (files with >= 100 nodes) ──────────────
  const plan = _getOrBuildPlan(plugins, visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip, selectorHandlers);
  const { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
          fileLevelEnter, fileLevelExit, batchScannable } = plan;

  const subtreeRelevant = new Uint8Array(ast.nodeCount);
  const usePruning = canSkip && relevantTagCount < tagCount * 0.5 && pd;
  if (usePruning) {
    for (let i = 0; i < postOrder.length; i++) {
      const idx = postOrder[i];
      if (relevantTag[nodeTags[idx]]) {
        subtreeRelevant[idx] = 1;
        const p = pd[idx]; if (p !== NONE) subtreeRelevant[p] = 1;
      } else if (subtreeRelevant[idx]) {
        const p = pd[idx]; if (p !== NONE) subtreeRelevant[p] = 1;
      }
    }
  }


  const skipSet = new RuleSkipSet();
  skipSet.init(visitorMap.size);
  context._skipSet = skipSet;

  const nodesByType = new Map();
  for (let i = 0; i < ast.nodeCount; i++) {
    const tag = nodeTags[i];
    const tn = tagNames[tag];
    if (tn) {
      let arr = nodesByType.get(tn);
      if (!arr) { arr = []; nodesByType.set(tn, arr); }
      arr.push(i);
    }
  }
  context.sourceCode._nodesByType = nodesByType;
  context.sourceCode.getNodesByType = function(typeName) {
    const indices = this._nodesByType.get(typeName);
    if (!indices) return [];
    return indices.map(idx => nodeView(this._ast, idx));
  };

  // Execute batch-scannable rules before the DFS walk.
  // SQL columnar scan: one pass over all nodes of each type, calling N rule handlers.
  // Batch try/catch: ONE try/catch for all N handlers per node, not per handler.
  for (const [typeName, handlers] of batchScannable) {
    const indices = nodesByType.get(typeName);
    if (!indices) continue;
    const hn = handlers.length;
    for (let i = 0; i < indices.length; i++) {
      const node = nodeView(ast, indices[i]);
      context._currentNodeIdx = indices[i];
      let bh = 0;
      try {
        for (; bh < hn; bh++) handlers[bh]._state.inner(node);
      } catch (err) {
        context._reports.push({ ruleId: handlers[bh].ruleId, message: `Plugin error: ${err.message}` });
        for (let bk = bh + 1; bk < hn; bk++) {
          try { handlers[bk]._state.inner(node); }
          catch (e) { context._reports.push({ ruleId: handlers[bk].ruleId, message: `Plugin error: ${e.message}` }); }
        }
      }
    }
  }

  // ── Execute file-level enter rules (before DFS) ────────────────
  if (fileLevelEnter.length > 0) {
    const rootNode = nodeView(ast, 0);
    context._currentNodeIdx = 0;
    for (const hd of fileLevelEnter) hd.handler(rootNode);
  }

  // Pre-compute MethodDefinition → Property remap for object literal methods.
  // sanz uses the same tags (getter_def, setter_def, method_def) for both class
  // methods (→ MethodDefinition) and object literal methods (→ Property).
  // The adapter's .type getter does the remap, but the runner dispatches by raw
  // tag → we need to intercept and use Property handlers for object-context nodes.
  const _methodDefTagBits = new Uint8Array(tagNames.length);
  const _objContainerTagBits = new Uint8Array(tagNames.length);
  let _propertyTagNum = -1;
  for (let _t = 0; _t < tagNames.length; _t++) {
    const _tn = tagNames[_t];
    if (_tn === 'MethodDefinition') _methodDefTagBits[_t] = 1;
    if (_tn === 'ObjectExpression' || _tn === 'ObjectPattern') _objContainerTagBits[_t] = 1;
    if (_tn === 'Property') _propertyTagNum = _t;
  }
  const _hasMdRemap = _propertyTagNum >= 0 && _methodDefTagBits.some(v => v);

  /** Resolve actual enter/exit handlers accounting for MethodDef-in-object-literal remap. */
  function _resolveHandlers(handlersArr, tag, idx) {
    if (_hasMdRemap && _methodDefTagBits[tag] && pd) {
      const parentIdx = pd[idx];
      if (parentIdx !== undefined && parentIdx !== NONE && _objContainerTagBits[nodeTags[parentIdx]]) {
        return _propertyTagNum >= 0 ? handlersArr[_propertyTagNum] : null;
      }
    }
    return handlersArr[tag];
  }

  // Interleaved DFS: enter and exit events in correct DFS order.
  const hasPrivateIdOpt = visitorMap.has('PrivateIdentifier');
  const hasPrivateIdExitOpt = visitorMap.has('PrivateIdentifier:exit');
  const identTagOpt = tagNames.indexOf('Identifier');
  const memberExprTagOpt = tagNames.indexOf('MemberExpression');

  const { events: dfsEvents, count: dfsCount } = getDFSEvents();
  for (let i = 0; i < dfsCount; i++) {
    if (skipSet.allSkipped) break;
    const ev = dfsEvents[i];
    if (ev >= 0) {
      // Enter event
      const idx = ev;
      if (usePruning && !subtreeRelevant[idx]) continue;
      const tag = nodeTags[idx];
      const handlers = _resolveHandlers(tagEnterHandlers, tag, idx);
      const flags = tagFlags[tag];
      if (canSkip && !handlers && !flags && !(hasPrivateIdOpt && tag === identTagOpt) && !(_catchStackTrackArr && _catchStackTrackArr[tag])) continue;
      // Catch stack: bookkeep CatchClause/function-boundary for ThrowStatement pre-warming
      if (catchStack !== null) {
        if (tag === _catchClauseTag) {
          catchStack.push(idx);
        } else if (_catchBarrierTagArr[tag]) {
          catchStack.push(-1); // function boundary — no enclosing catch in this scope
        } else if (tag === _throwStmtTag) {
          const top = catchStack.length > 0 ? catchStack[catchStack.length - 1] : -1;
          if (top >= 0) {
            let _p = pd[idx];
            while (_p !== NONE && _p !== undefined && _p < ast.nodeCount) {
              nodeView(ast, _p).parent; // populate .parent cache (idempotent)
              if (_p === top) break;
              if (_catchBarrierTagArr[nodeTags[_p]]) break;
              _p = pd[_p];
            }
          }
        }
      }
      if (flags & FLAG_CODEPATH_ENTER) {
        const outerSeg = cpTracker.segment;
        if (outerSeg) _segEndEvent(outerSeg);
        const { segment } = cpTracker.enterFunction(nodeView(ast, idx));
        invokeCodePathHandlers('onCodePathStart', idx);
        if (_segStartH) _dispatchSeg(_segStartH, segment);
      }
      // Branch enter (flag-based: no string lookups in hot path)
      if (flags & FLAG_BRANCH_ENTER) cpTracker.enterBranch();
      if (flags & FLAG_CATCH_CASE) {
        const oldSeg2 = cpTracker.segment;
        if (oldSeg2) _segEndEvent(oldSeg2);
        const seg2 = cpTracker.nextBranch();
        if (seg2) _segStartOrUnreachEvent(seg2);
      }
      if (elseStartNodes && elseStartNodes[idx]) {
        const oldSeg2 = cpTracker.segment;
        if (oldSeg2) _segEndEvent(oldSeg2);
        const seg2 = cpTracker.nextBranch();
        if (seg2) _segStartOrUnreachEvent(seg2);
      }
      if (handlers) {
        _invokeFused(handlers, nodeView(ast, idx), idx, context);
      }
      // PrivateIdentifier dispatch for Identifier nodes with # prefix
      if (hasPrivateIdOpt && tag === identTagOpt) {
        const pos = ast._tokStarts[ast._mainTokens[idx]];
        if (pos < ast.source.length && ast.source.charCodeAt(pos) === 35) {
          const privEnter = visitorMap.get('PrivateIdentifier');
          if (privEnter) {
            const node = nodeView(ast, idx);
            context._currentNodeIdx = idx;
            for (let h = 0; h < privEnter.length; h++) privEnter[h].handler(node);
          }
        }
      }
      // Synthesize PrivateIdentifier for MemberExpression with private property
      if (hasPrivateIdOpt && (tag === memberExprTagOpt || tagNames[tag] === 'MemberExpression')) {
        const rhs = ast.nodeRhs(idx);
        if (rhs !== NONE) {
          const propStart = ast._tokStarts[rhs];
          if (propStart < ast.source.length && ast.source.charCodeAt(propStart) === 35) {
            const synth = ast._syntheticId(rhs);
            if (synth.type === 'PrivateIdentifier') {
              synth.parent = nodeView(ast, idx);
              const privEnter = visitorMap.get('PrivateIdentifier');
              if (privEnter) {
                for (let h = 0; h < privEnter.length; h++) {
                  try { privEnter[h].handler(synth); } catch (err) {
                    context._reports.push({ ruleId: privEnter[h].ruleId, message: `Plugin error: ${err.message}` });
                  }
                }
              }
            }
          }
        }
      }
      if (flags & FLAG_CLASS_BODY) invokeClassBodyHandlers(idx, false);
      if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, false);
      if (flags & FLAG_SELECTOR) invokeSelectorHandlers(idx, false);
    } else {
      // Exit event
      const idx = ~ev;
      if (usePruning && !subtreeRelevant[idx]) continue;
      const tag = nodeTags[idx];
      const handlers = _resolveHandlers(tagExitHandlers, tag, idx);
      const flags = tagFlags[tag];
      if (canSkip && !handlers && !flags && !(_catchStackTrackArr && _catchStackTrackArr[tag])) continue;
      // Catch stack: pop CatchClause/function-boundary on exit
      if (catchStack !== null && (tag === _catchClauseTag || _catchBarrierTagArr[tag])) {
        catchStack.pop();
      }
      if (flags & FLAG_CLASS_BODY) invokeClassBodyHandlers(idx, true);
      if (handlers) {
        _invokeFused(handlers, nodeView(ast, idx), idx, context);
      }
      if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, true);
      // Terminators and branch exit (flag-based: no string lookups in hot path)
      if (flags & FLAG_TERMINATOR) {
        const oldSeg = cpTracker.segment;
        if (oldSeg) if (_segEndH) _dispatchSeg(_segEndH, oldSeg);
        cpTracker.markUnreachable();
        if (_unreachStartH) _dispatchSeg(_unreachStartH, cpTracker.segment);
      }
      if (flags & FLAG_BRANCH_EXIT) {
        const oldSeg = cpTracker.segment;
        if (oldSeg) _segEndEvent(oldSeg);
        const hasAllBranches = (_ifStmtTagSet && _ifStmtTagSet.has(tag) && nodeView(ast, idx).alternate != null) ||
          (_tryStmtTagSet && _tryStmtTagSet.has(tag) && nodeView(ast, idx).handler != null) ||
          (_doWhileStmtTagSet && _doWhileStmtTagSet.has(tag));
        const seg2 = cpTracker.exitBranch(hasAllBranches);
        _segStartOrUnreachEvent(seg2);
      }
      if (flags & FLAG_CODEPATH_EXIT) {
        const oldSeg = cpTracker.segment;
        if (oldSeg) _segEndEvent(oldSeg);
        invokeCodePathHandlers('onCodePathEnd', idx);
        cpTracker.exitFunction();
        const outerSeg = cpTracker.segment;
        if (outerSeg) _segStartOrUnreachEvent(outerSeg);
      }
      if (flags & FLAG_SELECTOR) invokeSelectorHandlers(idx, true);
    }
  }

  // ── Execute file-level exit rules (after DFS) ─────────────────
  if (fileLevelExit.length > 0) {
    const rootNode = nodeView(ast, 0);
    context._currentNodeIdx = 0;
    for (const hd of fileLevelExit) hd.handler(rootNode);
  }
}

// ── Public API ───────────────────────────────────────────────────

/**
 * Run ESLint-compatible plugins against a parsed AST.
 *
 * @param {AstView} ast - Parsed AST from sanz.parse()
 * @param {Array} plugins - Array of { meta?: { name }, create(context) => visitors }
 * @param {object} [options] - { filename?: string, tagNames?: string[] }
 * @returns {Array} - Array of { ruleId, message, node?, loc? }
 *
 * Plugin format (ESLint-compatible):
 *   {
 *     meta: { name: "no-debugger" },
 *     create(context) {
 *       return {
 *         DebuggerStatement(node) {
 *           context.report({ node, message: "Unexpected debugger" });
 *         }
 *       };
 *     }
 *   }
 */
// Cache interned tag names across calls (tag names don't change between files).
let _cachedInternedTagNames = null;
let _cachedTagNamesInput = null;

// Item 4+5: Reuse RuleContext across files to keep perRuleCtxs prototype chain stable.
let _cachedContext = null;

// Item 3: Node cache pool — avoids new Array(nodeCount) per file.
let _nodeCachePool = null;
let _nodeCachePoolSize = 0;

function runPlugins(ast, plugins, options = {}) {
  const { filename = "<input>", tagNames, ruleConfig = {}, typeAware = false, errorBudget, sourceType, ecmaVersion } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  let parserServices = null;
  if (typeAware && filename !== "<input>" && /\.[mc]?tsx?$/.test(filename)) {
    const svc = tsServices();
    if (svc) {
      try { parserServices = svc.buildParserServices(filename); } catch {}
    }
  }

  // Cache interned tag names (same array across all files)
  if (_cachedTagNamesInput !== tagNames) {
    _cachedInternedTagNames = tagNames.map(t => t ? _intern(t) : t);
    _cachedTagNamesInput = tagNames;
  }

  // Item 3: Pre-assign node cache pool to avoid new Array(nodeCount) in nodeView().
  const nc = ast.nodeCount;
  if (_nodeCachePool === null || _nodeCachePoolSize < nc) {
    _nodeCachePool = new Array(nc);
    _nodeCachePoolSize = nc;
  } else {
    // Clear only the slots this AST will use (rest are never read).
    _nodeCachePool.fill(undefined, 0, nc);
  }
  ast._nodeCache = _nodeCachePool;

  // Items 4+5: Reuse master RuleContext; stable prototype for cached perRuleCtxs.
  let context;
  if (_cachedContext) {
    _cachedContext.reset(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion });
    context = _cachedContext;
  } else {
    context = new RuleContext(ast, filename, ast.source, { parserServices, errorBudget, sourceType, ecmaVersion });
    _cachedContext = context;
  }

  const visitorMapResult = buildVisitorMap(plugins, context, ruleConfig);

  const hasScopeRules = visitorMapResult.map.has('Program:exit');
  if (ast._scopeKinds && hasScopeRules) {
    context.sourceCode._precomputeScopes();
  }

  walkNodes(ast, visitorMapResult, context, _cachedInternedTagNames, plugins);

  return context._reports;
}

module.exports = {
  runPlugins, RuleContext,
  // Exported for testing
  _estimateHandlerCost, _extractParentGuard, _fuseHandlers,
  _isTrivialHandler, _isDeadHandler, _classifyRuleAccess,
  _profileData, DEFAULT_ERROR_BUDGET,
  _intern, _coalesceByParentGuard, _fingerprintSubtree,
  RuleSkipSet, _extractFileLevelRules,
};
