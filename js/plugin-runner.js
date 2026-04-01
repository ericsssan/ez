"use strict";

const { nodeView, NONE, effectiveTypeName } = require("./node-view");
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
function collectSubtreeTokens(ast, nodeIdx, result) {
  if (nodeIdx === NONE || nodeIdx >= ast.nodeCount) return;

  // Ensure maxTok cache is populated (triggers _computeAllEndPos if not yet done)
  if (!ast._maxTokCache) ast._nodeEndPos(nodeIdx);

  const mt = ast._mainTokens;
  const tc = ast.tokenCount;
  const tags = ast._tokTags;

  const startTok = mt[nodeIdx];
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
  constructor(ast, sourceText) {
    this._ast = ast;
    this.text = sourceText;
    this._linesCache = null;
    this._tokensCache = null;
    this._scopeCache = new Map();
    this._thinScopeCache = new Map();
    this._tokenSkipList = null; // lazily built token position index
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
    const tokenIndices = [];
    collectSubtreeTokens(ast, node._i, tokenIndices);
    tokenIndices.sort((a, b) => ast._tokStarts[a] - ast._tokStarts[b]);
    const toks = tokenIndices.map(i => this._makeToken(i));
    // Apply filter if provided
    if (filterOrOpts && typeof filterOrOpts.filter === 'function') {
      return toks.filter(filterOrOpts.filter);
    }
    return toks;
  }

  getFirstToken(node, filterOrOpts) {
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
    const startTok = ast._mainTokens[node._i];
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
    // Ensure maxTok cache exists
    if (!ast._maxTokCache) ast._nodeEndPos(node._i);
    const maxTok = ast._maxTokCache[node._i];
    const tags = ast._tokTags;
    const tc = ast.tokenCount;
    // Compute endTok (maxTok + trailing structural tokens)
    let endTok = maxTok;
    for (let t = maxTok + 1; t < tc; t++) {
      const tag = tags[t];
      if (tag === 131) break;
      if (SCAN_CONTINUE_TAGS.has(tag)) endTok = t;
      else break;
    }
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
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) return null;
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    // Fast path: no filter, no skip — O(1)
    if (!fn && skip === 0 && mainTok > 0) return this._makeToken(mainTok - 1);
    let skipped = 0;
    for (let i = mainTok - 1; i >= 0; i--) {
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
    // Fast path: no filter, no skip — O(1)
    if (!fn && skip === 0 && mainTok + 1 < ast.tokenCount) return this._makeToken(mainTok + 1);
    let skipped = 0;
    for (let i = mainTok + 1; i < ast.tokenCount; i++) {
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
    const isStrict = (flags16 & 1) !== 0;
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

    // Cache before building children to break the parent←→child cycle.
    this._scopeCache.set(scopeId, scope);

    // Populate childScopes via precomputed index (not full scan).
    const childIds = this._scopeChildIndex[scopeId];
    if (childIds) {
      for (let j = 0; j < childIds.length; j++) {
        childScopes.push(this._buildScope(childIds[j]));
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
    let defNode = declNode;
    if (defType === 'Variable' || defType === 'ClassName' || defType === 'FunctionName' || defType === 'ImportBinding') {
      // For these types, def.node = parent of Identifier (Declarator/Declaration/Specifier)
      defNode = declNode && declNode.parent ? declNode.parent : declNode;
    }
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
    const is_let = (flags16 & 0x02) !== 0;
    if ((is_let || is_const) && declNodeIdx !== undefined && declNodeIdx !== NONE && declNodeIdx !== 0xFFFFFFFF && ast._parentData) {
      const declaratorIdx = ast._parentData[declNodeIdx]; // Identifier → Declarator
      if (declaratorIdx !== undefined && declaratorIdx !== NONE && declaratorIdx !== 0xFFFFFFFF && declaratorIdx < ast.nodeCount) {
        const initNodeIdx = ast.nodeRhs(declaratorIdx);
        if (initNodeIdx !== 0xFFFFFFFF && initNodeIdx !== NONE && initNodeIdx < ast.nodeCount) {
          // Has initializer — prepend synthetic init write reference.
          const thin = this._buildThinVariable(symId);
          references.unshift({
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
    const ast = this._ast;
    const NONE32 = 0xFFFFFFFF;
    if (!ast._symFlags || symId === NONE || symId === NONE32 || symId >= ast._semSymbolCount) return null;
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
    // Compute def.node and def.parent same as in _buildVariable
    let defNode = declNode;
    if (defType === 'Variable' || defType === 'ClassName' || defType === 'FunctionName' || defType === 'ImportBinding') {
      defNode = declNode && declNode.parent ? declNode.parent : declNode;
    }
    return {
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
    const isStrict = (flags16 & 1) !== 0;
    const parentId = ast._scopeParents[scopeId];
    const upper = (parentId !== NONE32) ? this._buildThinScope(parentId) : null;
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

    // Use real semantic data if available
    if (ast._symDeclNodes && node._i !== undefined && node._i !== null) {
      const NONE32 = 0xFFFFFFFF;
      const nodeIdx = node._i;
      const result = [];
      // Find symbols whose decl_node is nodeIdx or a direct structural descendant.
      // ESLint rules (e.g., prefer-const) call getDeclaredVariables(varDeclNode)
      // while sanz stores the Identifier as decl_node, 2 hops deeper in the tree.
      // IMPORTANT: Stop at function/class scope boundaries so that parameters of
      // nested arrow functions don't get returned for the outer VariableDeclarator.
      const pd = ast._parentData;
      const tags = ast._nodeTags;
      for (let i = 0; i < ast._semSymbolCount; i++) {
        const declNodeIdx = ast._symDeclNodes[i];
        if (declNodeIdx === NONE32 || declNodeIdx >= ast.nodeCount) continue;
        if (declNodeIdx === nodeIdx) {
          result.push(this._buildVariable(i));
          continue;
        }
        // Walk ancestors of declNodeIdx looking for nodeIdx, stopping at scope boundaries.
        // Scope-creating node tags: fn_decl(30-33), class_decl(34), fn_expr(63-66),
        // class_expr(67), arrow_fn(68), async_arrow_fn(69).
        if (pd) {
          let cur = pd[declNodeIdx];
          while (cur !== NONE && cur !== NONE32 && cur < ast.nodeCount) {
            if (cur === nodeIdx) { result.push(this._buildVariable(i)); break; }
            // Stop if we cross a function or class boundary
            const curTag = tags[cur];
            if ((curTag >= 30 && curTag <= 34) || (curTag >= 63 && curTag <= 69)) break;
            cur = pd[cur];
          }
        }
      }
      if (result.length > 0) return result;
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
   * Stub for getCommentsInside — returns empty array.
   * Rules that rely on this for correctness (e.g. no-empty) will treat blocks
   * as having no comments. Sufficient to prevent crashes.
   */
  getCommentsInside() {
    return [];
  }

  /** Stub for getCommentsBefore — returns empty array. */
  getCommentsBefore() {
    return [];
  }

  /** Stub for getCommentsAfter — returns empty array. */
  getCommentsAfter() {
    return [];
  }

  /**
   * Stub for commentsExistBetween — returns false.
   */
  commentsExistBetween() {
    return false;
  }

  /**
   * Stub for getAllComments — returns empty array.
   */
  getAllComments() {
    return [];
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
    if (!this._linesCache) this._linesCache = this.text.split('\n');
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
    const sc = new SourceCode(ast, sourceText);
    this.sourceCode = sc;
    // Attach TypeScript parserServices for .ts/.tsx files
    if (options.parserServices) {
      sc.parserServices = options.parserServices;
    }
    // Short-circuit / error budget: per-rule violation count
    this._ruleErrors = Object.create(null);
    this._errorBudget = options.errorBudget || DEFAULT_ERROR_BUDGET;
  }

  /**
   * Report a lint violation.
   * @param {object} descriptor - { node, message, loc? }
   */
  report(descriptor) {
    const { node, message, messageId, loc, data } = descriptor;
    let resolvedMsg = message;
    if (!resolvedMsg && messageId && this._currentRuleMeta?.messages) {
      let tpl = this._currentRuleMeta.messages[messageId] || messageId;
      if (data) {
        resolvedMsg = tpl.replace(/\{\{(\w+)\}\}/g, (_, k) => data[k] ?? `{{${k}}}`);
      } else {
        resolvedMsg = tpl;
      }
    }
    resolvedMsg = resolvedMsg || messageId || 'Lint violation';
    // Compute loc as {start:{line,column}, end:{line,column}} from node or numeric offset.
    let resolvedLoc = loc;
    if (!resolvedLoc && node) {
      const sc = this.sourceCode;
      resolvedLoc = {
        start: sc.getLocFromIndex(node.start),
        end: sc.getLocFromIndex(node.end != null ? node.end : node.start),
      };
    } else if (resolvedLoc && typeof resolvedLoc.start === 'number') {
      const sc = this.sourceCode;
      resolvedLoc = {
        start: sc.getLocFromIndex(resolvedLoc.start),
        end: resolvedLoc.end != null ? sc.getLocFromIndex(resolvedLoc.end) : sc.getLocFromIndex(resolvedLoc.start),
      };
    }
    // Collect fix if provided
    let fix = null;
    if (typeof descriptor.fix === 'function') {
      try {
        const fixer = new RuleFixer(this._ast.source);
        const fixResult = descriptor.fix(fixer);
        if (fixResult) {
          // fix() may return a single fix object or an iterable of fix objects
          if (typeof fixResult[Symbol.iterator] === 'function' && typeof fixResult.range === 'undefined') {
            fix = [...fixResult];
          } else {
            fix = [fixResult];
          }
          fix = fix.filter(Boolean);
        }
      } catch { /* ignore fix errors */ }
    }
    const ruleId = this._currentRule;
    this._reports.push({
      ruleId,
      message: resolvedMsg,
      node: node ? { type: node.type, start: node.start } : undefined,
      loc: resolvedLoc,
      fix: fix && fix.length > 0 ? fix : undefined,
    });
    // Short-circuit: track per-rule error count + update skip bitmap
    const newCount = (this._ruleErrors[ruleId] || 0) + 1;
    this._ruleErrors[ruleId] = newCount;
    if (newCount >= this._errorBudget && this._skipSet) {
      this._skipSet.mark(ruleId);
    }
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
function buildVisitorMap(plugins, context, ruleConfig = {}) {
  const map = new Map();
  // Array of { selector, isExit, handler, ruleId, ruleMeta, ruleOptions }
  const selectorHandlers = [];

  for (const plugin of plugins) {
    const ruleId = plugin.meta?.name || "unknown";
    const ruleMeta = plugin.meta || null;
    // Rule config keys can be the full name (e.g. "eslint/eqeqeq") or short name ("eqeqeq").
    const shortName = ruleId.includes('/') ? ruleId.split('/').pop() : ruleId;
    const configured = ruleConfig[ruleId] ?? ruleConfig[shortName];
    const ruleOptions = configured !== undefined ? configured : (plugin.meta?.defaultOptions ?? []);
    // Apply options so rules can safely destructure context.options in create()
    context.options = ruleOptions;
    let visitors;
    try {
      visitors = plugin.create(context);
    } catch (err) {
      // Rule failed to initialize — skip it
      context.options = [];
      continue;
    } finally {
      context.options = [];
    }
    if (!visitors || typeof visitors !== 'object') continue;
    for (const [visitorKey, handler] of Object.entries(visitors)) {
      if (typeof handler !== 'function') continue;
      if (_isSelector(visitorKey)) {
        // CSS-style AST selector — pre-parse to avoid repeated parsing on every node
        const isExit = visitorKey.endsWith(':exit');
        const selector = isExit ? visitorKey.slice(0, -5) : visitorKey;
        let parsedSelector = _selectorParseCache.get(selector);
        if (parsedSelector === undefined) {
          try { parsedSelector = esquery() ? esquery().parse(selector) : null; } catch { parsedSelector = null; }
          _selectorParseCache.set(selector, parsedSelector);
        }
        if (!parsedSelector) continue;
        selectorHandlers.push({ selector, parsedSelector, isExit, handler, ruleId, ruleMeta, ruleOptions });
        continue;
      }
      // Expand comma-separated type unions ("A, B" → ["A", "B"])
      for (const mapKey of _expandUnion(visitorKey)) {
        if (!map.has(mapKey)) map.set(mapKey, []);
        map.get(mapKey).push({ handler, ruleId, ruleMeta, ruleOptions });
      }
    }
  }

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
// ESLint calls these at every function boundary and at Program.
const CODE_PATH_TYPES = new Set([
  'Program',
  'FunctionDeclaration',
  'FunctionExpression',
  'ArrowFunctionExpression',
]);

// A minimal fake code path object. Rules that need real code path analysis
// (consistent-return, etc.) will still fail, but rules that only use the
// onCodePathStart node argument (no-constructor-return) will work correctly.
const FAKE_CODE_PATH = Object.freeze({
  id: 'cp0',
  currentSegments: [],
  thrownSegments: [],
  state: 'normal',
  upper: null,
});

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
    const analysis = _analyzeHandler(h.handler);
    if (_isDeadHandler(typeName, analysis.parentGuard)) continue;
    items.push({
      handler: h.handler,
      ruleId: h.ruleId,
      ruleMeta: h.ruleMeta,
      ruleOptions: h.ruleOptions,
      cost: analysis.isTrivial ? 0 : analysis.cost,
      parentGuard: analysis.parentGuard,
    });
  }
  items.sort((a, b) => a.cost - b.cost);
  return { items, length: items.length, _fused: true };
}

/**
 * Hot path: invoke handler without try/catch.
 * V8 can fully optimize this since there's no exception handling.
 */
function _callHandler(handler, node) {
  handler(node);
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
 * Applies predicate pushdown, short-circuit (error budget), and hot/cold splitting.
 */
function _invokeFused(desc, node, nodeIdx, context) {
  const skipSet = context._skipSet;
  if (!desc._fused) {
    // Not fused (single handler) — use original array format
    for (let h = 0; h < desc.length; h++) {
      const d = desc[h];
      // Skip bitmap: fast O(1) check if rule is exhausted
      if (skipSet && skipSet.has(d.ruleId)) continue;
      if (context._ruleErrors[d.ruleId] >= context._errorBudget) {
        if (skipSet) skipSet.mark(d.ruleId);
        continue;
      }
      context._currentRule = d.ruleId;
      context._currentRuleMeta = d.ruleMeta;
      context.options = d.ruleOptions;
      context._currentNodeIdx = nodeIdx;
      try { _callHandler(d.handler, node); }
      catch (err) { _handleError(err, d.ruleId, context); }
    }
    return;
  }
  const items = desc.items;
  const parentType = node.parent ? node.parent.type : null;
  // Visitor coalescing: track last checked guard to skip redundant lookups
  let lastGuardKey = undefined;
  let lastGuardResult = false;
  for (let h = 0; h < items.length; h++) {
    const item = items[h];
    // Skip bitmap: fast O(1) check
    if (skipSet && skipSet.has(item.ruleId)) continue;
    if (context._ruleErrors[item.ruleId] >= context._errorBudget) {
      if (skipSet) skipSet.mark(item.ruleId);
      continue;
    }
    // Predicate pushdown with coalesced guard check
    if (item.parentGuard) {
      const guardKey = item._coalescedGuard !== undefined ? item._coalescedGuard : item.parentGuard.parentType;
      if (guardKey === lastGuardKey) {
        if (!lastGuardResult) continue; // same guard, already failed
      } else {
        lastGuardKey = guardKey;
        lastGuardResult = parentType === guardKey;
        if (!lastGuardResult) continue;
      }
    }
    context._currentRule = item.ruleId;
    context._currentRuleMeta = item.ruleMeta;
    context.options = item.ruleOptions;
    context._currentNodeIdx = nodeIdx;
    try { _callHandler(item.handler, node); }
    catch (err) { _handleError(err, item.ruleId, context); }
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
    const orderDiff = ORDER[_analyzeHandler(a.handler).ruleAccess] - ORDER[_analyzeHandler(b.handler).ruleAccess];
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

  // Check each Program handler: file-level if this rule ONLY registers Program/Program:exit
  const enterHandlers = tagEnterHandlers[programTag];
  const exitHandlers = tagExitHandlers[programTag];
  const extractedRules = new Set();

  function isFileLevelOnly(ruleId) {
    // Check if this rule appears in any non-Program handler
    for (let t = 0; t < tagCount; t++) {
      if (t === programTag) continue;
      const e = tagEnterHandlers[t];
      if (e) {
        const items = e._fused ? e.items : e;
        for (let j = 0; j < items.length; j++) {
          if (items[j].ruleId === ruleId) return false;
        }
      }
      const x = tagExitHandlers[t];
      if (x) {
        const items = x._fused ? x.items : x;
        for (let j = 0; j < items.length; j++) {
          if (items[j].ruleId === ruleId) return false;
        }
      }
    }
    // Also check visitorMap for non-tag entries
    for (const [key, handlers] of visitorMap) {
      if (key === 'Program' || key === 'Program:exit') continue;
      const items = Array.isArray(handlers) ? handlers : (handlers.items || []);
      for (const h of items) {
        if (h.ruleId === ruleId) return false;
      }
    }
    return true;
  }

  // Extract file-level enter handlers
  if (enterHandlers) {
    const items = enterHandlers._fused ? enterHandlers.items : enterHandlers;
    const keep = [];
    for (let h = 0; h < items.length; h++) {
      if (isFileLevelOnly(items[h].ruleId)) {
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

let _cachedPlanKey = null;
let _cachedPlan = null;

function _getOrBuildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip) {
  // Build a cache key from the visitorMap keys + ruleIds (deterministic for same plugins)
  const keyParts = [];
  for (const [k, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : (handlers.items || [handlers]);
    const ruleIds = items.map(h => h.ruleId || '?').join(',');
    keyParts.push(k + ':' + ruleIds);
  }
  const planKey = keyParts.join('|');

  if (_cachedPlanKey === planKey && _cachedPlan) {
    // Remap handler references from the new visitorMap into the cached plan
    return _remapPlan(_cachedPlan, visitorMap, tagNames, tagCount);
  }

  // Build from scratch
  const plan = _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip);

  // Cache the structural template for reuse
  _cachedPlanKey = planKey;
  _cachedPlan = plan;
  return plan;
}

function _buildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip) {
  const FLAG_CODEPATH_ENTER = 1, FLAG_CLASS_BODY = 2, FLAG_METHOD_FN = 4, FLAG_CODEPATH_EXIT = 8;
  const tagEnterHandlers = new Array(tagCount);
  const tagExitHandlers  = new Array(tagCount);
  const tagFlags = new Uint8Array(tagCount);

  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t];
    if (!tn) continue;
    tagEnterHandlers[t] = visitorMap.get(tn) || null;
    tagExitHandlers[t]  = visitorMap.get(tn + ':exit') || null;
    if (hasCodePath && CODE_PATH_TYPES.has(tn)) tagFlags[t] |= FLAG_CODEPATH_ENTER | FLAG_CODEPATH_EXIT;
    if (hasClassBody && CLASS_TYPES.has(tn))    tagFlags[t] |= FLAG_CLASS_BODY;
    if (hasMethodFn && tn === 'MethodDefinition') tagFlags[t] |= FLAG_METHOD_FN;
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

  // Rule fusion
  for (let t = 0; t < tagCount; t++) {
    const tn = tagNames[t] || '';
    const enter = tagEnterHandlers[t];
    if (enter && enter.length > 1) {
      const fused = _fuseHandlers(enter, tn);
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
      tagEnterHandlers[t] = fused;
    }
    const exit = tagExitHandlers[t];
    if (exit && exit.length > 1) {
      const fused = _fuseHandlers(exit, tn + ':exit');
      _sortByDependency(fused.items);
      fused.items = _coalesceByParentGuard(fused.items);
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
  // Build ruleId → fresh handler lookup from the new visitorMap
  const handlerByKey = new Map(); // "ruleId|visitorKey" → handler entry
  for (const [key, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : [handlers];
    for (const h of items) {
      if (h.ruleId) handlerByKey.set(h.ruleId + '|' + key, h);
    }
  }
  // Also index by ruleId alone for simpler lookups
  const handlerByRule = new Map(); // ruleId → last seen handler entry (for meta/options)
  for (const [key, handlers] of visitorMap) {
    const items = Array.isArray(handlers) ? handlers : [handlers];
    for (const h of items) {
      if (h.ruleId && !handlerByRule.has(h.ruleId)) handlerByRule.set(h.ruleId, h);
    }
  }

  function remapSlot(template, tagName) {
    if (!template) return null;
    if (template._fused) {
      const items = [];
      for (const t of template.items) {
        const fresh = handlerByKey.get(t.ruleId + '|' + tagName) || handlerByRule.get(t.ruleId);
        if (!fresh) continue;
        items.push({
          handler: fresh.handler, ruleId: t.ruleId,
          ruleMeta: fresh.ruleMeta, ruleOptions: fresh.ruleOptions,
          cost: t.cost, parentGuard: t.parentGuard, _coalescedGuard: t._coalescedGuard,
        });
      }
      return { items, length: items.length, _fused: true };
    }
    // Array format
    const arr = [];
    for (const t of template) {
      const fresh = handlerByKey.get(t.ruleId + '|' + tagName) || handlerByRule.get(t.ruleId);
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

  // Remap file-level handlers
  const fileLevelEnter = [];
  for (const ruleId of _template.fileLevelEnterIds) {
    const fresh = handlerByKey.get(ruleId + '|Program') || handlerByRule.get(ruleId);
    if (fresh) fileLevelEnter.push(fresh);
  }
  const fileLevelExit = [];
  for (const ruleId of _template.fileLevelExitIds) {
    const fresh = handlerByKey.get(ruleId + '|Program:exit') || handlerByRule.get(ruleId);
    if (fresh) fileLevelExit.push(fresh);
  }

  // Remap batch scannable
  const batchScannable = new Map();
  for (const [tn, ruleIds] of _template.batchScannableIds) {
    const hs = [];
    for (const ruleId of ruleIds) {
      const fresh = handlerByKey.get(ruleId + '|' + tn) || handlerByRule.get(ruleId);
      if (fresh) hs.push(fresh);
    }
    if (hs.length > 0) batchScannable.set(tn, hs);
  }

  return { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
           fileLevelEnter, fileLevelExit, batchScannable, _template };
}

/**
 * Walk all AST nodes in DFS order: enter (pre-order) then exit (post-order).
 * Proper DFS ensures parents are visited before children on enter, and
 * children before parents on exit — matching real ESLint traversal semantics.
 * Errors are caught per-handler so one failing plugin doesn't abort others.
 */
function walkNodes(ast, visitorMapResult, context, tagNames) {
  const { map: visitorMap, selectorHandlers } = visitorMapResult;
  const nodeTags = ast.nodeTags;
  // Use Zig-precomputed DFS orders if available (v4 buffer), else compute in JS.
  const { preOrder, postOrder } = (ast._preOrder && ast._postOrder)
    ? { preOrder: ast._preOrder, postOrder: ast._postOrder }
    : buildDFSOrders(ast);

  // For selector matching, we need ancestors. Build the ancestors array lazily per node.
  const hasSelectors = selectorHandlers.length > 0;
  const esq = hasSelectors ? esquery() : null;
  const pd = ast._parentData;

  function getAncestorsFor(nodeIdx) {
    if (!pd) return [];
    // esquery expects ancestors[0] = immediate parent (closest first), not root-first.
    const ancestors = [];
    let p = pd[nodeIdx];
    while (p !== NONE && p !== undefined && p < ast.nodeCount) {
      ancestors.push(nodeView(ast, p));
      p = pd[p];
    }
    return ancestors;
  }

  function invokeHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
      context._currentNodeIdx = nodeIdx;
      try {
        handlers[h].handler(node);
      } catch (err) {
        context._reports.push({
          ruleId: handlers[h].ruleId,
          message: `Plugin error: ${err.message}`,
        });
      }
    }
  }

  function invokeSelectorHandlers(nodeIdx, isExit) {
    if (!esq || selectorHandlers.length === 0) return;
    const node = nodeView(ast, nodeIdx);
    let ancestors = null; // lazy
    for (let h = 0; h < selectorHandlers.length; h++) {
      const sh = selectorHandlers[h];
      if (sh.isExit !== isExit) continue;
      try {
        if (ancestors === null) ancestors = getAncestorsFor(nodeIdx);
        if (esq.matches(node, sh.parsedSelector, ancestors)) {
          context._currentRule = sh.ruleId;
          context._currentRuleMeta = sh.ruleMeta;
          context.options = sh.ruleOptions;
          context._currentNodeIdx = nodeIdx;
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

  function invokeCodePathHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
      try {
        // onCodePathStart receives (codePath, node); onCodePathEnd receives (codePath)
        handlers[h].handler(FAKE_CODE_PATH, node);
      } catch (err) {
        context._reports.push({
          ruleId: handlers[h].ruleId,
          message: `Plugin error: ${err.message}`,
        });
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
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
      context._currentNodeIdx = classNodeIdx;
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

  const CLASS_TYPES = new Set(['ClassDeclaration', 'ClassExpression']);

  // ── FunctionExpression synthesis for class methods ───────────────
  // sanz has no FunctionExpression node in the AST for class methods.
  // Synthesize FunctionExpression enter/exit and onCodePathStart/End events
  // so rules like no-constructor-return and getter-return work correctly.

  function invokeCodePathHandlersWithNode(mapKey, node) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
      try {
        handlers[h].handler(FAKE_CODE_PATH, node);
      } catch (err) {
        context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
      }
    }
  }

  function invokeHandlersWithNode(mapKey, node, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
      context._currentNodeIdx = nodeIdx;
      try {
        handlers[h].handler(node);
      } catch (err) {
        context._reports.push({ ruleId: handlers[h].ruleId, message: `Plugin error: ${err.message}` });
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
      invokeCodePathHandlersWithNode('onCodePathStart', fnExpr);
      if (hasFn) invokeHandlersWithNode(fnKey, fnExpr, methodNodeIdx);
    } else {
      if (hasFn) invokeHandlersWithNode(fnKey, fnExpr, methodNodeIdx);
      invokeCodePathHandlersWithNode('onCodePathEnd', fnExpr);
    }
  }

  // Hoist feature flags — avoid per-node Set/Map lookups when no handlers registered.
  const hasCodePath  = visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd');
  const hasClassBody = visitorMap.has('ClassBody') || visitorMap.has('ClassBody:exit');
  const hasMethodFn  = visitorMap.has('FunctionExpression') || visitorMap.has('FunctionExpression:exit') ||
                       visitorMap.has('onCodePathStart') || visitorMap.has('onCodePathEnd');
  const canSkip = !hasSelectors;

  const tagCount = tagNames.length;
  const FLAG_CODEPATH_ENTER = 1;
  const FLAG_CLASS_BODY     = 2;
  const FLAG_METHOD_FN      = 4;
  const FLAG_CODEPATH_EXIT  = 8;

  // ── Execution plan: build once, reuse across files ─────────────
  // The plan template (tag arrays, flags, fusion order, file-level/batch
  // extraction) is deterministic for a given plugin set + tagNames.
  // Cache it keyed by the plugins array identity so the second file
  // skips all .toString()/regex analysis, O(rules×tags) scans, etc.
  // Only per-file state (skipSet, nodesByType, subtreeRelevant) is rebuilt.
  const plan = _getOrBuildPlan(visitorMap, tagNames, tagCount, hasCodePath, hasClassBody, hasMethodFn, canSkip);
  const { tagEnterHandlers, tagExitHandlers, tagFlags, relevantTag, relevantTagCount,
          fileLevelEnter, fileLevelExit, batchScannable } = plan;

  // ── Per-file state ─────────────────────────────────────────────

  // Subtree pruning (per-file: depends on AST structure)
  const subtreeRelevant = new Uint8Array(ast.nodeCount);
  const usePruning = canSkip && relevantTagCount < tagCount * 0.5 && pd;
  if (usePruning) {
    for (let i = 0; i < postOrder.length; i++) {
      const idx = postOrder[i];
      if (relevantTag[nodeTags[idx]]) {
        subtreeRelevant[idx] = 1;
        const p = pd[idx];
        if (p !== NONE) subtreeRelevant[p] = 1;
      } else if (subtreeRelevant[idx]) {
        const p = pd[idx];
        if (p !== NONE) subtreeRelevant[p] = 1;
      }
    }
  }

  // Initialize rule skip bitmap
  const skipSet = new RuleSkipSet();
  skipSet.init(visitorMap.size);
  context._skipSet = skipSet;

  // Materialized views (per-file: depends on AST content)
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

  // Execute batch-scannable rules before the DFS walk
  for (const [typeName, handlers] of batchScannable) {
    const indices = nodesByType.get(typeName);
    if (!indices) continue;
    for (let i = 0; i < indices.length; i++) {
      const idx = indices[i];
      const node = nodeView(ast, idx);
      for (let h = 0; h < handlers.length; h++) {
        const hd = handlers[h];
        if (context._ruleErrors[hd.ruleId] >= context._errorBudget) continue;
        context._currentRule = hd.ruleId;
        context._currentRuleMeta = hd.ruleMeta;
        context.options = hd.ruleOptions;
        context._currentNodeIdx = idx;
        try { _callHandler(hd.handler, node); }
        catch (err) { _handleError(err, hd.ruleId, context); }
      }
    }
  }

  // ── Execute file-level enter rules (before DFS) ────────────────
  if (fileLevelEnter.length > 0) {
    const rootNode = nodeView(ast, 0);
    for (const hd of fileLevelEnter) {
      context._currentRule = hd.ruleId;
      context._currentRuleMeta = hd.ruleMeta;
      context.options = hd.ruleOptions;
      context._currentNodeIdx = 0;
      try { _callHandler(hd.handler, rootNode); }
      catch (err) { _handleError(err, hd.ruleId, context); }
    }
  }

  // Enter pass: DFS pre-order (parents before children)
  for (let i = 0; i < preOrder.length; i++) {
    const idx = preOrder[i];
    if (skipSet.allSkipped) break;
    if (usePruning && !subtreeRelevant[idx]) continue;
    const tag = nodeTags[idx];
    const handlers = tagEnterHandlers[tag];
    const flags = tagFlags[tag];
    if (canSkip && !handlers && !flags) continue;
    if (flags & FLAG_CODEPATH_ENTER) invokeCodePathHandlers('onCodePathStart', idx);
    if (handlers) {
      _invokeFused(handlers, nodeView(ast, idx), idx, context);
    }
    if (flags & FLAG_CLASS_BODY) invokeClassBodyHandlers(idx, false);
    if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, false);
    if (hasSelectors) invokeSelectorHandlers(idx, false);
  }

  // Exit pass: DFS post-order (children before parents)
  for (let i = 0; i < postOrder.length; i++) {
    const idx = postOrder[i];
    if (skipSet.allSkipped) break;
    if (usePruning && !subtreeRelevant[idx]) continue;
    const tag = nodeTags[idx];
    const handlers = tagExitHandlers[tag];
    const flags = tagFlags[tag];
    if (canSkip && !handlers && !flags) continue;
    if (flags & FLAG_CLASS_BODY) invokeClassBodyHandlers(idx, true);
    if (handlers) {
      const node = nodeView(ast, idx);
      _invokeFused(handlers, node, idx, context);
    }
    if (flags & FLAG_METHOD_FN) invokeMethodFnHandlers(idx, true);
    if (flags & FLAG_CODEPATH_EXIT) invokeCodePathHandlers('onCodePathEnd', idx);
    if (hasSelectors) invokeSelectorHandlers(idx, true);
  }

  // ── Execute file-level exit rules (after DFS) ─────────────────
  if (fileLevelExit.length > 0) {
    const rootNode = nodeView(ast, 0);
    for (const hd of fileLevelExit) {
      context._currentRule = hd.ruleId;
      context._currentRuleMeta = hd.ruleMeta;
      context.options = hd.ruleOptions;
      context._currentNodeIdx = 0;
      try { _callHandler(hd.handler, rootNode); }
      catch (err) { _handleError(err, hd.ruleId, context); }
    }
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
function runPlugins(ast, plugins, options = {}) {
  const { filename = "<input>", tagNames, ruleConfig = {}, typeAware = false, errorBudget } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  // Build TypeScript parserServices only when type-aware rules are loaded.
  // Calling buildParserServices invokes the full TypeScript compiler (~50ms/file);
  // skip it for pure-syntax rules (eslint core, etc.).
  let parserServices = null;
  if (typeAware && filename !== "<input>" && /\.[mc]?tsx?$/.test(filename)) {
    const svc = tsServices();
    if (svc) {
      try {
        parserServices = svc.buildParserServices(filename);
      } catch { /* ts unavailable or file not parseable — run syntax-only rules */ }
    }
  }

  // Intern tag names for O(1) identity comparisons
  const internedTagNames = tagNames.map(t => t ? _intern(t) : t);

  const context = new RuleContext(ast, filename, ast.source, { parserServices, errorBudget });
  const visitorMapResult = buildVisitorMap(plugins, context, ruleConfig);

  // ── Rule Query Optimizer: two-phase scope execution ───────────
  // Phase 1: Precompute scopes if any scope-aware rule is loaded.
  // Phase 2: Separate scope-writing rules (markVariableAsUsed) from
  // scope-reading rules. Writers run in the main DFS; readers in Program:exit.
  // This is handled by the dependency DAG sort within fused groups.
  const hasScopeRules = visitorMapResult.map.has('Program:exit');
  if (ast._scopeKinds && hasScopeRules) {
    context.sourceCode._precomputeScopes();
  }

  // ── Rule Query Optimizer: build optimization stats ──────────────
  const optimizerStats = {
    totalRules: plugins.length,
    registeredTypes: visitorMapResult.map.size,
    selectorCount: visitorMapResult.selectorHandlers.length,
    scopePrecomputed: !!(ast._scopeKinds && hasScopeRules),
  };
  context._optimizerStats = optimizerStats;

  walkNodes(ast, visitorMapResult, context, internedTagNames);

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
