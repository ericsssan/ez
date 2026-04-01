"use strict";

const { nodeView, NONE } = require("./node-view");
let _esquery = null;
function esquery() {
  if (!_esquery) {
    try { _esquery = require("./node_modules/esquery"); } catch { _esquery = null; }
  }
  return _esquery;
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
    const ast = this._ast;
    const mainTok = node.mainToken;
    if (mainTok === undefined || mainTok === null) return null;
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
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

    // Build variables: all symbols whose scope_id matches this scope.
    // Merge symbols with the same name (var redeclarations get 2 symbols in sanz
    // but ESLint expects 1 variable with 2 identifiers, for no-redeclare support).
    const varMap = new Map();
    if (ast._symScopeIds) {
      for (let i = 0; i < ast._semSymbolCount; i++) {
        if (ast._symScopeIds[i] !== scopeId) continue;
        const v = this._buildVariable(i);
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

    // Build references: all references from this scope
    const references = [];
    const through = []; // unresolved references (bubble up to global scope)
    if (ast._refScopeIds) {
      for (let i = 0; i < ast._semRefCount; i++) {
        if (ast._refScopeIds[i] === scopeId) {
          const ref = this._buildReference(i);
          references.push(ref);
          if (!ref.resolved) through.push(ref);
        }
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

    // Populate childScopes (needed by no-shadow, no-unused-vars, etc.).
    for (let c = 0; c < ast._semScopeCount; c++) {
      if (ast._scopeParents[c] === scopeId) childScopes.push(this._buildScope(c));
    }

    return scope;
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

    // Build references for this symbol by scanning the reference table.
    // (RefRange in symbol table is not always populated by the analyzer.)
    const references = [];
    if (ast._refSymbolIds) {
      for (let i = 0; i < ast._semRefCount; i++) {
        if (ast._refSymbolIds[i] === symId) references.push(this._buildReference(i));
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
    };
    this.settings = {};
    const sc = new SourceCode(ast, sourceText);
    this.sourceCode = sc;
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
    this._reports.push({
      ruleId: this._currentRule,
      message: resolvedMsg,
      node: node ? { type: node.type, start: node.start } : undefined,
      loc: resolvedLoc,
    });
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
        let parsedSelector;
        try { parsedSelector = esquery() ? esquery().parse(selector) : null; } catch { parsedSelector = null; }
        if (!parsedSelector) continue; // skip unparseable selectors
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

  // Build children lists. Children are added in index order which equals source order.
  const childrenOf = new Array(nodeCount);
  for (let i = 0; i < nodeCount; i++) childrenOf[i] = [];
  for (let i = 0; i < nodeCount; i++) {
    const p = pd[i];
    if (p !== NONE) childrenOf[p].push(i);
  }

  // Iterative DFS from root (index 0) collecting pre-order and post-order.
  const preOrder = [];
  const postOrder = [];
  // Stack entries: positive = enter node, negative-1-encoded = exit node
  // Use a simple two-value approach to avoid object allocation.
  const stack = [0]; // start: enter node 0
  const stackIsPost = [false];
  let top = 0;

  while (top >= 0) {
    const node = stack[top];
    const isPost = stackIsPost[top];
    top--;

    if (isPost) {
      postOrder.push(node);
    } else {
      preOrder.push(node);
      // Schedule post-visit
      top++;
      stack[top] = node;
      stackIsPost[top] = true;
      // Schedule children in reverse order (so first child is processed first)
      const ch = childrenOf[node];
      for (let i = ch.length - 1; i >= 0; i--) {
        top++;
        if (top >= stack.length) {
          stack.push(ch[i]);
          stackIsPost.push(false);
        } else {
          stack[top] = ch[i];
          stackIsPost[top] = false;
        }
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

/**
 * Walk all AST nodes in DFS order: enter (pre-order) then exit (post-order).
 * Proper DFS ensures parents are visited before children on enter, and
 * children before parents on exit — matching real ESLint traversal semantics.
 * Errors are caught per-handler so one failing plugin doesn't abort others.
 */
function walkNodes(ast, visitorMapResult, context, tagNames) {
  const { map: visitorMap, selectorHandlers } = visitorMapResult;
  const nodeTags = ast.nodeTags;
  const { preOrder, postOrder } = buildDFSOrders(ast);

  // For selector matching, we need ancestors. Build the ancestors array lazily per node.
  const esq = selectorHandlers.length > 0 ? esquery() : null;
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

  // Enter pass: DFS pre-order (parents before children)
  for (let i = 0; i < preOrder.length; i++) {
    const idx = preOrder[i];
    const typeName = tagNames[nodeTags[idx]];
    if (!typeName) continue;
    // Stub: call onCodePathStart at function/program boundaries
    if (CODE_PATH_TYPES.has(typeName)) invokeCodePathHandlers('onCodePathStart', idx);
    invokeHandlers(typeName, idx);
    // Synthesize ClassBody enter after ClassDeclaration/ClassExpression enter
    if (CLASS_TYPES.has(typeName)) invokeClassBodyHandlers(idx, false);
    invokeSelectorHandlers(idx, false);
  }

  // Exit pass: DFS post-order (children before parents)
  for (let i = 0; i < postOrder.length; i++) {
    const idx = postOrder[i];
    const typeName = tagNames[nodeTags[idx]];
    if (!typeName) continue;
    // Synthesize ClassBody exit before ClassDeclaration/ClassExpression exit
    if (CLASS_TYPES.has(typeName)) invokeClassBodyHandlers(idx, true);
    invokeHandlers(typeName + ':exit', idx);
    invokeSelectorHandlers(idx, true);
    // Stub: call onCodePathEnd at function/program boundaries
    if (CODE_PATH_TYPES.has(typeName)) invokeCodePathHandlers('onCodePathEnd', idx);
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
  const { filename = "<input>", tagNames, ruleConfig = {} } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  const context = new RuleContext(ast, filename, ast.source);
  const visitorMapResult = buildVisitorMap(plugins, context, ruleConfig);

  walkNodes(ast, visitorMapResult, context, tagNames);

  return context._reports;
}

module.exports = { runPlugins, RuleContext };
