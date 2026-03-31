"use strict";

const { nodeView, NONE } = require("./node-view");

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
 * 1. Collect mainToken of every node in the subtree → gives all "content" tokens
 * 2. Find maxTok = highest token index in subset
 * 3. Scan forward from maxTok+1, including closing/separator punctuation until
 *    we hit a keyword, identifier, or opener — these start the next sibling
 *
 * Uses parent pointer data for correct subtree membership.
 */
function collectSubtreeTokens(ast, nodeIdx, result) {
  if (nodeIdx === NONE || nodeIdx >= ast.nodeCount) return;
  const pd = ast._parentData;
  const n = ast.nodeCount;
  const mt = ast._mainTokens;
  const tc = ast.tokenCount;
  const tags = ast._tokTags;

  let startTok = mt[nodeIdx];
  let maxTok = startTok;

  if (pd) {
    for (let i = 0; i < n; i++) {
      if (i === nodeIdx || _isDescendant(pd, i, nodeIdx)) {
        const tok = mt[i];
        if (tok > maxTok) maxTok = tok;
      }
    }
  }

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
  }

  /**
   * Build a token object with loc for token index i.
   * The _tokenIndex property allows getTokenBefore/After to work on token objects.
   */
  _makeToken(i) {
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
    return {
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
    // Fast path for synthetic nodes
    if (node._i === undefined || node._i === null) {
      if (node.mainToken !== undefined) {
        const tok = this._makeToken(node.mainToken);
        const { fn, skip } = this._normalizeFilter(filterOrOpts);
        return (!fn || fn(tok)) && skip === 0 ? tok : null;
      }
      return null;
    }
    const tokens = this.getTokens(node);
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    let skipped = 0;
    for (let i = 0; i < tokens.length; i++) {
      if (!fn || fn(tokens[i])) {
        if (skipped >= skip) return tokens[i];
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
    const tokens = this.getTokens(node);
    const { fn, skip } = this._normalizeFilter(filterOrOpts);
    let skipped = 0;
    for (let i = tokens.length - 1; i >= 0; i--) {
      if (!fn || fn(tokens[i])) {
        if (skipped >= skip) return tokens[i];
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
   * Stub for getScope — returns an empty scope with no variables.
   * Sufficient for rules that use it only for name-collision checks in fixers.
   */
  getScope() {
    const upper = { variables: [], references: [], through: [], set: new Map(),
                    isStrict: false, type: 'global', upper: null, block: null };
    return {
      variables: [],
      childScopes: [],
      references: [],
      through: [],
      set: new Map(),
      implicit: { variables: [] },
      block: null,
      upper,
      isStrict: false,
      type: 'module',
    };
  }

  /**
   * Stub for isGlobalReference — returns false (no real scope analysis).
   */
  isGlobalReference() {
    return false;
  }

  /**
   * Stub for getDeclaredVariables — returns fake variable objects for function params.
   * Without real scope analysis, returns stub variables with empty reference arrays.
   * defs[0].type = "Parameter" lets no-func-assign/no-param-reassign discriminate
   * without crashing (they check defs[0].type before accessing references).
   */
  getDeclaredVariables(node) {
    if (!node) return [];
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
}

// ── Context ─────────────────────────────────────────────────────

/**
 * ESLint-compatible rule context passed to plugin visitor functions.
 */
class RuleContext {
  constructor(ast, filename, sourceText, options = {}) {
    this._ast = ast;
    this._filename = filename;
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
    this._reports.push({
      ruleId: this._currentRule,
      message: resolvedMsg,
      node: node ? { type: node.type, start: node.start } : undefined,
      loc: loc || (node ? { start: node.start } : undefined),
    });
  }

  getSourceCode() {
    return this.sourceCode;
  }

  getFilename() {
    return this._filename;
  }
}

// ── Visitor Walk ─────────────────────────────────────────────────

/**
 * Build a reverse mapping from ESTree type name → list of visitor functions.
 * This enables efficient single-pass traversal.
 */
function buildVisitorMap(plugins, context) {
  const map = new Map();

  for (const plugin of plugins) {
    const ruleId = plugin.meta?.name || "unknown";
    const ruleMeta = plugin.meta || null;
    const ruleOptions = plugin.meta?.defaultOptions ?? [];
    // Apply meta.defaultOptions so rules can safely destructure context.options
    context.options = ruleOptions;
    let visitors;
    try {
      visitors = plugin.create(context);
    } finally {
      context.options = [];
    }
    for (const [visitorKey, handler] of Object.entries(visitors)) {
      const isExit = visitorKey.endsWith(':exit');
      const typeName = isExit ? visitorKey.slice(0, -5) : visitorKey;
      const mapKey = isExit ? typeName + ':exit' : typeName;
      if (!map.has(mapKey)) {
        map.set(mapKey, []);
      }
      map.get(mapKey).push({ handler, ruleId, ruleMeta, ruleOptions });
    }
  }

  return map;
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
function walkNodes(ast, visitorMap, context, tagNames) {
  const nodeTags = ast.nodeTags;
  const { preOrder, postOrder } = buildDFSOrders(ast);

  function invokeHandlers(mapKey, nodeIdx) {
    const handlers = visitorMap.get(mapKey);
    if (!handlers) return;
    const node = nodeView(ast, nodeIdx);
    for (let h = 0; h < handlers.length; h++) {
      context._currentRule = handlers[h].ruleId;
      context._currentRuleMeta = handlers[h].ruleMeta;
      context.options = handlers[h].ruleOptions;
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

  // Enter pass: DFS pre-order (parents before children)
  for (let i = 0; i < preOrder.length; i++) {
    const idx = preOrder[i];
    const typeName = tagNames[nodeTags[idx]];
    if (!typeName) continue;
    // Stub: call onCodePathStart at function/program boundaries
    if (CODE_PATH_TYPES.has(typeName)) invokeCodePathHandlers('onCodePathStart', idx);
    invokeHandlers(typeName, idx);
  }

  // Exit pass: DFS post-order (children before parents)
  for (let i = 0; i < postOrder.length; i++) {
    const idx = postOrder[i];
    const typeName = tagNames[nodeTags[idx]];
    if (!typeName) continue;
    invokeHandlers(typeName + ':exit', idx);
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
  const { filename = "<input>", tagNames } = options;

  if (!tagNames) {
    throw new Error("runPlugins requires options.tagNames (call getTagNames() first)");
  }

  const context = new RuleContext(ast, filename, ast.source);
  const visitorMap = buildVisitorMap(plugins, context);

  walkNodes(ast, visitorMap, context, tagNames);

  return context._reports;
}

module.exports = { runPlugins, RuleContext };
