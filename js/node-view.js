"use strict";

const { T, OPERATOR_BY_TAG } = require("./tags");

// ── Header offsets (matches BufferHeader extern struct) ──────────

const H = {
  MAGIC: 0,
  VERSION: 4,
  NODE_COUNT: 8,
  TOKEN_COUNT: 12,
  EXTRA_COUNT: 16,
  SOURCE_LEN: 20,
  SOURCE_UTF16_LEN: 24,
  TAGS_OFFSET: 28,
  MAIN_TOKENS_OFFSET: 32,
  DATA_OFFSET: 36,
  EXTRA_DATA_OFFSET: 40,
  TOK_TAGS_OFFSET: 44,
  TOK_STARTS_OFFSET: 48,
  SOURCE_OFFSET: 52,
  TOTAL_USED: 56,
  FLAGS: 60,
  // v2: parent indices (byte 64)
  PARENT_INDICES_OFFSET: 64,
  // v3: semantic data offset (byte 68)
  SEMANTIC_DATA_OFFSET: 68,
  // v4: DFS traversal order arrays (byte 72, 76)
  PRE_ORDER_OFFSET: 72,
  POST_ORDER_OFFSET: 76,
  // v5: interleaved DFS events (byte 80), source type (byte 84)
  DFS_EVENTS_OFFSET: 80,
  SOURCE_TYPE: 84,
};

// SemanticHeader field offsets (byte offsets from semOff)
const SH = {
  SCOPE_COUNT: 0,
  SYMBOL_COUNT: 4,
  REF_COUNT: 8,
  // _pad: 12
  SCOPE_KINDS: 16,
  SCOPE_FLAGS: 20,
  SCOPE_PARENTS: 24,
  SCOPE_NODE_IDS: 28,
  SCOPE_BINDINGS_START: 32,
  SCOPE_BINDINGS_COUNT: 36,
  SYMBOL_FLAGS: 40,
  SYMBOL_SCOPE_IDS: 44,
  SYMBOL_DECL_NODES: 48,
  SYMBOL_REF_STARTS: 52,
  SYMBOL_REF_ENDS: 56,
  SYMBOL_NAME_STARTS: 60,
  SYMBOL_NAME_LENS: 64,
  REF_SYMBOL_IDS: 68,
  REF_KINDS: 72,
  REF_NODE_IDS: 76,
  REF_SCOPE_IDS: 80,
  NODE_SCOPE_IDS: 84,
};

const FLAG_HAS_BOM = 1;

// ── Helpers ─────────────────────────────────────────────────────

/** Resolve Unicode escape sequences (\uXXXX and \u{XXXX}) in identifier names. */
function _resolveUnicodeEscapes(name) {
  if (!name || name.indexOf('\\') === -1) return name;
  return name.replace(/\\u\{([0-9a-fA-F]+)\}|\\u([0-9a-fA-F]{4})/g, (_, braced, four) => {
    return String.fromCodePoint(parseInt(braced || four, 16));
  });
}

// ── Tag name table ──────────────────────────────────────────────

let TAG_NAMES = null;

/// NodeIndex.none sentinel (matches Zig's std.math.maxInt(u32))
const NONE = 0xFFFFFFFF;

// ── TypeScript keyword type remapping ───────────────────────────
// Sanz emits TSTypeReference for TS built-in keyword types.
// ESLint/typescript-eslint rules expect TSAnyKeyword etc.
// When TSTypeReference has no type arguments (rhs === NONE) and its
// main token text is a TypeScript keyword type, remap to the ESTree name.
const _TS_KW_TYPES = {
  any:        'TSAnyKeyword',
  bigint:     'TSBigIntKeyword',
  boolean:    'TSBooleanKeyword',
  intrinsic:  'TSIntrinsicKeyword',
  never:      'TSNeverKeyword',
  null:       'TSNullKeyword',
  number:     'TSNumberKeyword',
  object:     'TSObjectKeyword',
  string:     'TSStringKeyword',
  symbol:     'TSSymbolKeyword',
  this:       'TSThisType',
  undefined:  'TSUndefinedKeyword',
  unknown:    'TSUnknownKeyword',
  void:       'TSVoidKeyword',
};

/**
 * Set the tag name table directly (e.g., from cached data).
 */
function setTagNames(names) {
  TAG_NAMES = names;
}

// ── AstView ─────────────────────────────────────────────────────

/**
 * Zero-copy view over the parsed AST in the shared buffer.
 * Creates typed array views over the SoA arrays.
 */
class AstView {
  constructor(buffer) {
    const dv = new DataView(buffer);

    this.buffer = buffer;
    this.nodeCount = dv.getUint32(H.NODE_COUNT, true);
    this.tokenCount = dv.getUint32(H.TOKEN_COUNT, true);
    this.extraCount = dv.getUint32(H.EXTRA_COUNT, true);
    this.sourceLen = dv.getUint32(H.SOURCE_LEN, true);
    this.sourceUtf16Len = dv.getUint32(H.SOURCE_UTF16_LEN, true);
    this.hasBOM = (dv.getUint32(H.FLAGS, true) & FLAG_HAS_BOM) !== 0;

    const tagsOff = dv.getUint32(H.TAGS_OFFSET, true);
    const mainToksOff = dv.getUint32(H.MAIN_TOKENS_OFFSET, true);
    const dataOff = dv.getUint32(H.DATA_OFFSET, true);
    const extraOff = dv.getUint32(H.EXTRA_DATA_OFFSET, true);
    const tokTagsOff = dv.getUint32(H.TOK_TAGS_OFFSET, true);
    const tokStartsOff = dv.getUint32(H.TOK_STARTS_OFFSET, true);
    const sourceOff = dv.getUint32(H.SOURCE_OFFSET, true);

    // Node SoA arrays
    this._nodeTags = new Uint8Array(buffer, tagsOff, this.nodeCount);
    this._mainTokens = new Uint32Array(buffer, mainToksOff, this.nodeCount);
    // Data is interleaved [lhs: u32, rhs: u32] per node
    this._dv = dv;
    this._dataOff = dataOff;

    // Extra data
    this._extraData = new Uint32Array(buffer, extraOff, this.extraCount);

    // Token SoA arrays
    this._tokTags = new Uint8Array(buffer, tokTagsOff, this.tokenCount);
    this._tokStarts = new Uint32Array(buffer, tokStartsOff, this.tokenCount);

    // Source text (UTF-8 in buffer, decoded lazily)
    this._sourceBytes = new Uint8Array(buffer, sourceOff, this.sourceLen);
    this._sourceOff = sourceOff; // byte offset of source in buffer (for symbol name lookup)
    this._sourceText = null;

    // Parent indices (v2 — zero array if not present in buffer)
    const parentOff = dv.getUint32(H.PARENT_INDICES_OFFSET, true);
    this._parentData = parentOff > 0
      ? new Uint32Array(buffer, parentOff, this.nodeCount)
      : null;

    // DFS traversal orders (v4 — pre-order and post-order, computed in Zig)
    const preOff  = dv.getUint32(H.PRE_ORDER_OFFSET,  true);
    const postOff = dv.getUint32(H.POST_ORDER_OFFSET, true);
    this._preOrder  = preOff  > 0 ? new Int32Array(buffer, preOff,  this.nodeCount) : null;
    this._postOrder = postOff > 0 ? new Int32Array(buffer, postOff, this.nodeCount) : null;

    // Interleaved DFS events (v5 — enter/exit in correct DFS order, computed in Zig)
    const dfsEvOff = dv.getUint32(H.DFS_EVENTS_OFFSET, true);
    this._dfsEvents = dfsEvOff > 0 ? new Int32Array(buffer, dfsEvOff, this.nodeCount * 2) : null;

    // Source type (v5 — 1 = module, 0 = script)
    this._sourceType = dv.getUint32(H.SOURCE_TYPE, true);

    // Semantic data (v3 — scope/symbol/reference tables)
    const semOff = dv.getUint32(H.SEMANTIC_DATA_OFFSET, true);
    if (semOff > 0) {
      this._semScopeCount   = dv.getUint32(semOff + SH.SCOPE_COUNT, true);
      this._semSymbolCount  = dv.getUint32(semOff + SH.SYMBOL_COUNT, true);
      this._semRefCount     = dv.getUint32(semOff + SH.REF_COUNT, true);

      this._scopeKinds      = new Uint8Array (buffer, dv.getUint32(semOff + SH.SCOPE_KINDS, true),           this._semScopeCount);
      this._scopeFlags      = new Uint16Array(buffer, dv.getUint32(semOff + SH.SCOPE_FLAGS, true),           this._semScopeCount);
      this._scopeParents    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_PARENTS, true),         this._semScopeCount);
      this._scopeNodeIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_NODE_IDS, true),        this._semScopeCount);
      this._scopeBindStart  = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_BINDINGS_START, true),  this._semScopeCount);
      this._scopeBindCount  = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_BINDINGS_COUNT, true),  this._semScopeCount);

      if (this._semSymbolCount > 0) {
        this._symFlags        = new Uint16Array(buffer, dv.getUint32(semOff + SH.SYMBOL_FLAGS, true),      this._semSymbolCount);
        this._symScopeIds     = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_SCOPE_IDS, true),  this._semSymbolCount);
        this._symDeclNodes    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_DECL_NODES, true), this._semSymbolCount);
        this._symRefStarts    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_REF_STARTS, true), this._semSymbolCount);
        this._symRefEnds      = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_REF_ENDS, true),   this._semSymbolCount);
        this._symNameStarts   = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_NAME_STARTS, true),this._semSymbolCount);
        this._symNameLens     = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_NAME_LENS, true),  this._semSymbolCount);
      }

      if (this._semRefCount > 0) {
        this._refSymbolIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SYMBOL_IDS, true), this._semRefCount);
        this._refKinds        = new Uint8Array (buffer, dv.getUint32(semOff + SH.REF_KINDS, true),       this._semRefCount);
        this._refNodeIds      = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_NODE_IDS, true),    this._semRefCount);
        this._refScopeIds     = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SCOPE_IDS, true),   this._semRefCount);
      }

      this._nodeScopeIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.NODE_SCOPE_IDS, true),  this.nodeCount);
    } else {
      this._semScopeCount = 0;
      this._semSymbolCount = 0;
      this._semRefCount = 0;
    }

    // Per-parse node cache — ensures reference equality: nodeView(ast, i) === nodeView(ast, i)
    this._nodeCache = null;
  }

  /** Decoded source text (lazy). */
  get source() {
    if (this._sourceText === null) {
      this._sourceText = _decoder.decode(this._sourceBytes);
    }
    return this._sourceText;
  }

  /** Get the root NodeView (node index 0). */
  root() {
    return nodeView(this, 0);
  }

  /** Get a NodeView by index. */
  node(index) {
    return nodeView(this, index);
  }

  /** Get the lhs of a node (as u32). */
  nodeLhs(index) {
    return this._dv.getUint32(this._dataOff + index * 8, true);
  }

  /** Get the rhs of a node (as u32). */
  nodeRhs(index) {
    return this._dv.getUint32(this._dataOff + index * 8 + 4, true);
  }

  /** Get extra_data[index]. */
  extra(index) {
    return this._extraData[index];
  }

  /** Get a range of extra_data as a Uint32Array view. */
  extraSlice(start, end) {
    return this._extraData.subarray(start, end);
  }

  /** Token start offset (UTF-16) for a given token index. */
  tokenStart(index) {
    return this._tokStarts[index];
  }

  /** Token tag (u8) for a given token index. */
  tokenTag(index) {
    return this._tokTags[index];
  }

  /** Node tag array (Uint8Array). Used by plugin-runner for fast traversal. */
  get nodeTags() {
    return this._nodeTags;
  }

  /**
   * Build and cache the line start offsets array (lazy).
   * Entry i is the UTF-16 offset of the start of line i+1 (0-indexed).
   */
  _lineStarts() {
    if (this._ls !== undefined) return this._ls;
    const src = this.source;
    const ls = [0];
    for (let i = 0; i < src.length; i++) {
      if (src.charCodeAt(i) === 10) ls.push(i + 1);
    }
    this._ls = ls;
    return ls;
  }

  /**
   * Binary search the lineStarts array. Returns 0-based line index.
   */
  _findLineIdx(pos) {
    const ls = this._lineStarts();
    let lo = 0, hi = ls.length - 1;
    while (lo < hi) {
      const mid = (lo + hi + 1) >> 1;
      if (ls[mid] <= pos) lo = mid;
      else hi = mid - 1;
    }
    return lo;
  }

  /**
   * Create a synthetic Identifier-like object for a token index.
   * Used by the `property` getter on MemberExpression nodes, where sanz stores
   * the property name as a token index rather than a full AST node.
   */
  _syntheticId(tokIdx) {
    const start = this._tokStarts[tokIdx];
    const src = this.source;
    let end = tokIdx + 1 < this.tokenCount ? this._tokStarts[tokIdx + 1] : src.length;
    while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    let name = src.slice(start, end);
    // Private identifiers: # may be a separate token from the name.
    let type = 'Identifier';
    if (name.charCodeAt(0) === 35) { // '#'
      type = 'PrivateIdentifier';
      if (name.length === 1 && tokIdx + 1 < this.tokenCount) {
        const nameStart = this._tokStarts[tokIdx + 1];
        let nameEnd = tokIdx + 2 < this.tokenCount ? this._tokStarts[tokIdx + 2] : src.length;
        while (nameEnd > nameStart && src.charCodeAt(nameEnd - 1) <= 32) nameEnd--;
        name = src.slice(nameStart, nameEnd);
      } else {
        name = name.slice(1);
      }
    }
    name = _resolveUnicodeEscapes(name);
    const li = this._findLineIdx(start);
    const eli = this._findLineIdx(end);
    const ls = this._lineStarts();
    return {
      type,
      name,
      start,
      end,
      range: [start, end],
      loc: {
        start: { line: li + 1, column: start - ls[li] },
        end: { line: eli + 1, column: end - ls[eli] },
      },
      mainToken: tokIdx,
    };
  }

  /**
   * Build a synthetic Literal node from a token index (for string/number literals).
   * Used by ImportDeclaration.source, ExportDeclaration.source, etc.
   */
  _syntheticLiteral(tokIdx) {
    const start = this._tokStarts[tokIdx];
    const src = this.source;
    let end = tokIdx + 1 < this.tokenCount ? this._tokStarts[tokIdx + 1] : src.length;
    while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    const raw = src.slice(start, end);
    // Decode the value: strip quotes for strings
    let value = raw;
    if ((raw.startsWith('"') || raw.startsWith("'") || raw.startsWith('`')) && raw.length >= 2) {
      value = raw.slice(1, -1).replace(/\\(.)/g, (_, c) => c === 'n' ? '\n' : c === 't' ? '\t' : c === 'r' ? '\r' : c);
    } else if (!isNaN(Number(raw))) {
      value = Number(raw);
    }
    const li = this._findLineIdx(start);
    const eli = this._findLineIdx(end);
    const ls = this._lineStarts();
    return {
      type: 'Literal',
      value,
      raw,
      start,
      end,
      range: [start, end],
      loc: {
        start: { line: li + 1, column: start - ls[li] },
        end: { line: eli + 1, column: end - ls[eli] },
      },
      mainToken: tokIdx,
    };
  }

  // ── ExtraData struct accessors ─────────────────────────────────
  // Each matches the Zig ExtraData struct layout (sequential u32 fields).

  /** SubRange { start, end } */
  extraSubRange(i) {
    const e = this._extraData;
    return { start: e[i], end: e[i + 1] };
  }

  /** IfData { consequent, alternate } */
  extraIfData(i) {
    const e = this._extraData;
    return { consequent: e[i], alternate: e[i + 1] };
  }

  /** ForData { init, condition, update } */
  extraForData(i) {
    const e = this._extraData;
    return { init: e[i], condition: e[i + 1], update: e[i + 2] };
  }

  /** ForInOfData { binding, expr, body } */
  extraForInOfData(i) {
    const e = this._extraData;
    return { binding: e[i], expr: e[i + 1], body: e[i + 2] };
  }

  /** TryData { catch_node, finally_body } */
  extraTryData(i) {
    const e = this._extraData;
    return { catch_node: e[i], finally_body: e[i + 1] };
  }

  /** FnData { name, params, params_end, body } */
  extraFnData(i) {
    const e = this._extraData;
    return { name: e[i], params: e[i + 1], params_end: e[i + 2], body: e[i + 3] };
  }

  /** ClassData { name, super_class, body_start, body_end } */
  extraClassData(i) {
    const e = this._extraData;
    return { name: e[i], super_class: e[i + 1], body_start: e[i + 2], body_end: e[i + 3] };
  }

  /** ArrowData { params_start, params_end, body } */
  extraArrowData(i) {
    const e = this._extraData;
    return { params_start: e[i], params_end: e[i + 1], body: e[i + 2] };
  }

  /** Conditional { consequent, alternate } */
  extraConditional(i) {
    const e = this._extraData;
    return { consequent: e[i], alternate: e[i + 1] };
  }

  /** ImportData { specifiers_start, specifiers_end, source } */
  extraImportData(i) {
    const e = this._extraData;
    return { specifiers_start: e[i], specifiers_end: e[i + 1], source: e[i + 2] };
  }

  /** MethodData { params_start, params_end, body } */
  extraMethodData(i) {
    const e = this._extraData;
    return { params_start: e[i], params_end: e[i + 1], body: e[i + 2] };
  }

  // ── Token text helpers ─────────────────────────────────────────

  /**
   * Get identifier text starting at a token's UTF-16 position.
   * Scans forward until a non-identifier character is found.
   */
  _identAt(tokIdx) {
    const src = this.source;
    let pos = this._tokStarts[tokIdx];
    const start = pos;
    while (pos < src.length) {
      const c = src.charCodeAt(pos);
      // identifier chars: A-Z a-z 0-9 _ $ or unicode (>127)
      if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122) ||
          (c >= 48 && c <= 57) || c === 95 || c === 36 || c > 127) {
        pos++;
      } else if (c === 92) { // backslash — Unicode escape \uXXXX or \u{XXXX}
        pos++; // skip '\'
        if (pos < src.length && src.charCodeAt(pos) === 117) { // 'u'
          pos++;
          if (pos < src.length && src.charCodeAt(pos) === 123) { // '{'
            pos++;
            while (pos < src.length && src.charCodeAt(pos) !== 125) pos++;
            if (pos < src.length) pos++; // skip '}'
          } else {
            // \uXXXX — 4 hex digits
            for (let j = 0; j < 4 && pos < src.length; j++) pos++;
          }
        }
      } else {
        break;
      }
    }
    return src.slice(start, pos);
  }

  /**
   * Get raw source text for a token by scanning to the next token's start.
   * Used for string/number/regex literals. Strips trailing whitespace.
   */
  _rawTokenText(tokIdx) {
    const src = this.source;
    const start = this._tokStarts[tokIdx];
    let end;
    if (tokIdx + 1 < this.tokenCount) {
      end = this._tokStarts[tokIdx + 1];
      while (end > start && (src.charCodeAt(end - 1) <= 32)) end--;
    } else {
      end = src.length;
    }
    return src.slice(start, end);
  }

  // ── Semantic accessors ─────────────────────────────────────────

  /** Get the name of a symbol from raw buffer bytes (byte offsets, not UTF-16). */
  _symName(symId) {
    if (!this._symNameStarts) return '';
    const start = this._symNameStarts[symId];
    const len = this._symNameLens[symId];
    // Read directly from the underlying buffer using byte offsets.
    // Symbol name starts/lens are byte positions, not UTF-16 character indices.
    // Guard: skip if offset is out of range (defensive against rare Zig-side
    // overflow bugs on very large files with thousands of symbols).
    if (start + len > this.buffer.byteLength || len === 0) return '';
    const bytes = new Uint8Array(this.buffer, start, len);
    // Fast path: ASCII-only (most identifier names)
    let ascii = true;
    for (let i = 0; i < bytes.length; i++) {
      if (bytes[i] > 127) { ascii = false; break; }
    }
    if (ascii) {
      let s = '';
      for (let i = 0; i < bytes.length; i++) s += String.fromCharCode(bytes[i]);
      return s;
    }
    // Slow path: UTF-8 decode
    return new TextDecoder().decode(bytes);
  }

  /**
   * Get the innermost scope containing a node.
   * Walks up the parent chain from the node's own scope entry until found.
   * Returns the scopeId (u32), or NONE if no semantic data.
   */
  _scopeForNode(nodeIdx) {
    if (!this._nodeScopeIds) return NONE;
    // Walk up the parent chain until we find a node that has a scope entry
    let cur = nodeIdx;
    while (cur !== NONE && cur < this.nodeCount) {
      const scopeId = this._nodeScopeIds[cur];
      if (scopeId !== NONE) return scopeId;
      const pd = this._parentData;
      if (!pd) break;
      cur = pd[cur];
    }
    return 0; // global scope
  }

  /**
   * Build an array of NodeViews from an extra_data SubRange.
   */
  _nodesFromRange(start, end) {
    const result = [];
    const e = this._extraData;
    for (let i = start; i < end; i++) {
      const idx = e[i];
      if (idx !== NONE) result.push(nodeView(this, idx));
    }
    return result;
  }

  /**
   * Compute the end position (exclusive, UTF-16) of a node's last token.
   * Finds the max main_token across the node and all its descendants,
   * then returns the trimmed end of that token (= start of next token, whitespace stripped).
   * Result is cached per AstView instance.
   */
  _nodeEndPos(nodeIdx) {
    if (!this._endPosCache) this._endPosCache = this._computeAllEndPos();
    return this._endPosCache[nodeIdx];
  }

  /** Get the start position of a node (minimum token start in its subtree). */
  _nodeStartPos(nodeIdx) {
    if (!this._startPosCache) {
      const n = this.nodeCount;
      const pd = this._parentData;
      const mt = this._mainTokens;
      // minTok[i] = lowest main_token index in node i's subtree
      const minTok = new Int32Array(n);
      for (let i = 0; i < n; i++) minTok[i] = mt[i];
      if (pd) {
        for (let i = 1; i < n; i++) {
          const p = pd[i];
          if (p !== NONE && minTok[i] < minTok[p]) minTok[p] = minTok[i];
        }
      }
      const startPos = new Int32Array(n);
      for (let i = 0; i < n; i++) startPos[i] = this._tokStarts[minTok[i]];
      this._startPosCache = startPos;
    }
    return this._startPosCache[nodeIdx];
  }

  /**
   * Build end-position and max-token-index arrays for all nodes.
   * Uses iterative multi-pass propagation through parent pointers.
   *
   * Stores maxTok array as _maxTokCache for use by collectSubtreeTokens,
   * avoiding the O(n) per-call scan.
   */
  _computeAllEndPos() {
    const n = this.nodeCount;
    const pd = this._parentData;
    const mt = this._mainTokens;
    const tc = this.tokenCount;
    const src = this.source;

    // maxTok[i] = highest main_token index in node i's subtree
    const maxTok = new Int32Array(n);
    for (let i = 0; i < n; i++) maxTok[i] = mt[i];

    if (pd) {
      // Single-pass propagation: process nodes in reverse order (high → low index).
      // In sanz's AST, children always have lower indices than parents (except root=0),
      // so reverse order guarantees children are finalized before their parents.
      // This replaces the O(n × depth) fixpoint loop with a single O(n) pass.
      for (let i = 1; i < n; i++) {
        const p = pd[i];
        if (p !== NONE && maxTok[i] > maxTok[p]) {
          maxTok[p] = maxTok[i];
        }
      }
      // Root (0) is processed separately: propagate up from all direct children.
      // The above loop handles this since children of root have pd[i] = 0.
    }

    // Cache maxTok for use by collectSubtreeTokens (O(1) lookup instead of O(n) scan)
    this._maxTokCache = maxTok;

    // Convert token indices to end byte positions (trimmed)
    const endPos = new Int32Array(n);
    for (let i = 0; i < n; i++) {
      const tokIdx = maxTok[i];
      const tStart = this._tokStarts[tokIdx];
      let tEnd = tokIdx + 1 < tc ? this._tokStarts[tokIdx + 1] : src.length;
      while (tEnd > tStart && src.charCodeAt(tEnd - 1) <= 32) tEnd--;
      endPos[i] = tEnd;
    }

    return endPos;
  }
}

// ── NodeView Pool ────────────────────────────────────────────────
// Pre-allocated pool of NodeView objects with prototype-based lazy getters.
// After warmup, zero allocations during traversal → zero GC pressure.

const _decoder = new TextDecoder();
const POOL_SIZE = 256;
let _poolIdx = 0;

/**
 * Shared prototype for all NodeView objects.
 * Getters compute values lazily from the AstView typed arrays.
 *
 * Provides both the low-level sanz API (lhs, rhs) and ESTree-compatible
 * named field getters (test, consequent, body, operator, etc.) so that
 * real ESLint rules can run against sanz's zero-copy AST buffer.
 */
const NodeProto = {
  // ── Low-level sanz accessors (existing) ──────────────────────

  get type() {
    // Property memoization: cache the computed type on the instance.
    // After first access, subsequent reads are O(1) direct property lookups.
    // Object.defineProperty on the instance shadows the prototype getter.
    const tagName = TAG_NAMES ? TAG_NAMES[this._ast._nodeTags[this._i]] : String(this._ast._nodeTags[this._i]);
    let result = tagName;
    // Remap Identifier → PrivateIdentifier when the token starts with #.
    if (tagName === 'Identifier') {
      const pos = this._ast._tokStarts[this._ast._mainTokens[this._i]];
      if (pos < this._ast.source.length && this._ast.source.charCodeAt(pos) === 35) {
        result = 'PrivateIdentifier';
      }
    }
    // Remap MethodDefinition → Property when inside an object literal/pattern.
    // ESTree uses Property for object methods, MethodDefinition for class methods.
    if (tagName === 'MethodDefinition') {
      const parentIdx = this._ast._parentData ? this._ast._parentData[this._i] : NONE;
      if (parentIdx !== NONE) {
        const parentTag = this._ast._nodeTags[parentIdx];
        if (parentTag === T.object_literal || parentTag === T.object_pattern) {
          result = 'Property';
        }
      }
    }
    // Remap TSTypeReference to TS*Keyword when it's a built-in keyword type
    // (no type arguments, and main token text matches a TS keyword type).
    if (tagName === 'TSTypeReference' && this._ast.nodeRhs(this._i) === NONE) {
      const ast = this._ast;
      const tok = ast._mainTokens[this._i];
      const start = ast._tokStarts[tok];
      const end = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : ast.source.length;
      const text = ast.source.slice(start, end).trim();
      const kw = _TS_KW_TYPES[text];
      if (kw) result = kw;
    }
    // Memoize: shadow the prototype getter with a direct value property
    Object.defineProperty(this, 'type', { value: result, configurable: true });
    return result;
  },
  get tag() {
    return this._ast._nodeTags[this._i];
  },
  get mainToken() {
    return this._ast._mainTokens[this._i];
  },
  get start() {
    return this._ast._nodeStartPos(this._i);
  },
  get lhs() {
    return this._ast.nodeLhs(this._i);
  },
  get rhs() {
    return this._ast.nodeRhs(this._i);
  },
  /** Get a child NodeView from lhs (if it's a node index). */
  lhsNode() {
    const idx = this.lhs;
    return idx === NONE ? null : nodeView(this._ast, idx);
  },
  /** Get a child NodeView from rhs (if it's a node index). */
  rhsNode() {
    const idx = this.rhs;
    return idx === NONE ? null : nodeView(this._ast, idx);
  },
  /**
   * Get children from an extra_data SubRange.
   */
  children(startExtra, endExtra) {
    const ast = this._ast;
    const result = [];
    for (let i = startExtra; i < endExtra; i++) {
      const child = Object.create(NodeProto);
      child._ast = ast;
      child._i = ast._extraData[i];
      result.push(child);
    }
    return result;
  },

  // ── ESTree-compatible field getters ──────────────────────────
  //
  // These map ESTree named fields to the underlying sanz flat buffer,
  // enabling real ESLint rules to run without modification.
  //
  // Field access pattern (from ast.zig comments):
  //   lhs / rhs = direct NodeIndex or ExtraIndex
  //   extraData(TypedStruct, lhs/rhs) = read typed struct from extra_data
  //   extraSlice(SubRange) = read list of NodeIndex from extra_data

  /**
   * node.parent — returns the parent NodeView using the parent index array.
   * Root node (index 0) returns null.
   */
  get parent() {
    const pd = this._ast._parentData;
    if (!pd) {
      Object.defineProperty(this, 'parent', { value: null, configurable: true, writable: true });
      return null;
    }
    // Walk past grouping_expr (ParenthesizedExpression) parents since nodeView
    // unwraps them — without this skip the parent chain would cycle:
    //   child → ParenthesizedExpression parent → nodeView unwraps back to child
    let parentIdx = pd[this._i];
    while (parentIdx !== NONE && this._ast._nodeTags[parentIdx] === T.grouping_expr) {
      parentIdx = pd[parentIdx];
    }
    const result = parentIdx === NONE ? null : nodeView(this._ast, parentIdx);
    // Memoize: shadow the prototype getter with a writable value property
    // (writable: true allows ESLint's traversal to set node.parent)
    Object.defineProperty(this, 'parent', { value: result, configurable: true, writable: true });
    return result;
  },
  set parent(v) {
    // ESLint's traversal sets node.parent on every node. Shadow the prototype
    // getter with a writable own property so subsequent reads/writes are direct.
    Object.defineProperty(this, 'parent', { value: v, configurable: true, writable: true });
  },

  /**
   * node.operator — binary/unary/assignment operator string.
   * Derived entirely from the tag; no buffer access needed.
   */
  get operator() {
    return OPERATOR_BY_TAG[this.tag] || null;
  },

  /**
   * node.name — identifier name string.
   * Also used by FunctionDeclaration/ClassDeclaration via .id.name.
   */
  get name() {
    if (this.tag === T.identifier) {
      const ast = this._ast;
      const tok = this.mainToken;
      const pos = ast._tokStarts[tok];
      // Private identifier: # may be a separate token from the name
      if (ast.source.charCodeAt(pos) === 35) { // '#'
        const nextTokStart = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : pos + 1;
        if (nextTokStart === pos + 1 && tok + 1 < ast.tokenCount) {
          return _resolveUnicodeEscapes(ast._identAt(tok + 1));
        }
        return _resolveUnicodeEscapes(ast.source.slice(pos + 1, nextTokStart).replace(/\s+$/, ''));
      }
      return _resolveUnicodeEscapes(ast._identAt(tok));
    }
    return null;
  },

  /**
   * node.value — literal value, or FunctionExpression for methods/properties.
   * Returns raw source text for strings (including quotes), parsed number,
   * boolean, or null. ESLint returns the evaluated value; we approximate.
   */
  get value() {
    const t = this.tag;
    const ast = this._ast;
    const src = ast._rawTokenText(this.mainToken);
    if (t === T.string_literal) {
      // Strip surrounding quotes and unescape basic sequences.
      // ESLint's Literal.value is the evaluated string, not the raw source.
      if (src.length >= 2 && (src[0] === '"' || src[0] === "'")) {
        const inner = src.slice(1, -1);
        // Fast path: no backslash → no escapes to process
        if (inner.indexOf('\\') === -1) return inner;
        // Slow path: process escape sequences
        return inner.replace(/\\(u\{[0-9a-fA-F]+\}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{2}|[0-7]{1,3}|.)/g, (_, esc) => {
          switch (esc[0]) {
            case 'n': return '\n';
            case 'r': return '\r';
            case 't': return '\t';
            case 'b': return '\b';
            case 'f': return '\f';
            case 'v': return '\v';
            case '0': return esc.length === 1 ? '\0' : String.fromCharCode(parseInt(esc, 8));
            case 'x': return String.fromCharCode(parseInt(esc.slice(1), 16));
            case 'u':
              if (esc[1] === '{') return String.fromCodePoint(parseInt(esc.slice(2, -1), 16));
              return String.fromCharCode(parseInt(esc.slice(1), 16));
            default:
              if (esc[0] >= '1' && esc[0] <= '7') return String.fromCharCode(parseInt(esc, 8));
              return esc; // \', \", \\, etc.
          }
        });
      }
      return src;
    }
    if (t === T.number_literal) return parseFloat(src);
    if (t === T.boolean_literal) return src === 'true';
    if (t === T.null_literal) return null;
    if (t === T.bigint_literal) return src.slice(0, -1); // strip 'n'
    if (t === T.regex_literal) return src;
    // VariableDeclarator .value = init (ESLint uses .init, but some rules use .value)
    if (t === T.declarator) return this.rhsNode();
    // Property (key: value) — rhs is the value expression.
    // For shorthand properties ({ a }), value === key (same Identifier node).
    if (t === T.property || t === T.computed_property || t === T.shorthand_property) {
      const rhs = ast.nodeRhs(this._i);
      if (rhs !== NONE) return nodeView(ast, rhs);
      // Shorthand: value is the same as key
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // Method/getter/setter — return a synthetic FunctionExpression
    if (t === T.method_def || t === T.getter_def || t === T.setter_def ||
        t === T.constructor_def || t === T.computed_method_def ||
        t === T.computed_getter_def || t === T.computed_setter_def) {
      const md = ast.extraMethodData(ast.nodeRhs(this._i));
      const flags = _methodFlags(ast, this.mainToken);
      const params = ast._nodesFromRange(md.params_start, md.params_end);
      const body = md.body === NONE ? null : nodeView(ast, md.body);
      const startPos = ast._tokStarts[this.mainToken];
      // Use the containing Property/MethodDefinition node's loc for the synthetic FunctionExpression
      const loc = this.loc;
      return {
        type: 'FunctionExpression',
        id: null,
        async: flags.async,
        generator: flags.generator,
        params: params || [],
        body,
        mainToken: this.mainToken,
        start: startPos,
        loc,
        range: loc ? [startPos, loc.end ? (body?.range?.[1] || startPos) : startPos] : undefined,
        parent: this, // parent = the Property/MethodDefinition node
      };
    }
    return null;
  },

  /**
   * node.raw — raw literal source text (for Literal nodes).
   */
  get raw() {
    return this._ast._rawTokenText(this.mainToken);
  },

  /**
   * node.regex — for regex Literal nodes: { pattern, flags }.
   * ESLint rules like require-unicode-regexp use Literal[regex] selectors.
   */
  get regex() {
    if (this.tag !== T.regex_literal) return undefined;
    const src = this._ast._rawTokenText(this.mainToken);
    // Regex format: /pattern/flags
    const lastSlash = src.lastIndexOf('/');
    if (lastSlash <= 0) return undefined;
    return {
      pattern: src.slice(1, lastSlash),
      flags: src.slice(lastSlash + 1),
    };
  },

  /**
   * node.bigint — for BigInt Literal nodes: the numeric string (without 'n').
   * ESLint's no-magic-numbers uses Literal[bigint] selectors.
   */
  get bigint() {
    if (this.tag !== T.bigint_literal) return undefined;
    const src = this._ast._rawTokenText(this.mainToken);
    return src.endsWith('n') ? src.slice(0, -1) : src;
  },

  /**
   * node.test — condition expression.
   * IfStatement, WhileStatement, DoWhileStatement, ForStatement, ConditionalExpression
   */
  get test() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    if (t === T.if_stmt || t === T.if_else_stmt || t === T.while_stmt) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.do_while_stmt) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.for_stmt) {
      const d = ast.extraForData(lhs);
      return d.condition === NONE ? null : nodeView(ast, d.condition);
    }
    if (t === T.conditional) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.switch_case) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return null;
  },

  /**
   * node.consequent — then-branch or case body.
   * IfStatement, ConditionalExpression, SwitchCase (array of stmts)
   */
  get consequent() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    if (t === T.if_stmt) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.if_else_stmt) {
      const d = ast.extraIfData(rhs);
      return d.consequent === NONE ? null : nodeView(ast, d.consequent);
    }
    if (t === T.conditional) {
      const d = ast.extraConditional(rhs);
      return d.consequent === NONE ? null : nodeView(ast, d.consequent);
    }
    if (t === T.switch_case || t === T.switch_default) {
      const sub = ast.extraSubRange(rhs);
      return ast._nodesFromRange(sub.start, sub.end);
    }
    return null;
  },

  /**
   * node.alternate — else-branch.
   * IfStatement, ConditionalExpression
   */
  get alternate() {
    const t = this.tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.if_stmt) return null;
    if (t === T.if_else_stmt) {
      const d = ast.extraIfData(rhs);
      return d.alternate === NONE ? null : nodeView(ast, d.alternate);
    }
    if (t === T.conditional) {
      const d = ast.extraConditional(rhs);
      return d.alternate === NONE ? null : nodeView(ast, d.alternate);
    }
    return null;
  },

  /**
   * node.body — body of statements, loop body, or function body.
   */
  get body() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    let result = null;
    if (t === T.block_stmt) {
      result = ast._nodesFromRange(lhs, rhs);
    } else if (t === T.if_stmt || t === T.while_stmt) {
      result = rhs === NONE ? null : nodeView(ast, rhs);
    } else if (t === T.do_while_stmt) {
      result = lhs === NONE ? null : nodeView(ast, lhs);
    } else if (t === T.for_stmt) {
      result = rhs === NONE ? null : nodeView(ast, rhs);
    } else if (t === T.for_in_stmt || t === T.for_of_stmt || t === T.for_await_of_stmt) {
      const d = ast.extraForInOfData(lhs);
      result = d.body === NONE ? null : nodeView(ast, d.body);
    } else if (t === T.labeled_stmt) {
      result = lhs === NONE ? null : nodeView(ast, lhs);
    } else if (t === T.with_stmt) {
      result = rhs === NONE ? null : nodeView(ast, rhs);
    } else if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr) {
      const d = ast.extraFnData(lhs);
      result = d.body === NONE ? null : nodeView(ast, d.body);
    } else if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const d = ast.extraArrowData(lhs);
      result = d.body === NONE ? null : nodeView(ast, d.body);
    } else if (t === T.catch_clause) {
      result = rhs === NONE ? null : nodeView(ast, rhs);
    } else if (t === T.static_block) {
      result = ast._nodesFromRange(lhs, rhs);
    } else if (t === T.class_decl || t === T.class_expr) {
      const d = ast.extraClassData(lhs);
      const members = ast._nodesFromRange(d.body_start, d.body_end);
      result = {
        type: 'ClassBody',
        body: members,
        start: members.length > 0 ? members[0].start : this.start,
        mainToken: this.mainToken,
      };
    } else if (t === T.root) {
      result = ast._nodesFromRange(lhs, rhs);
    }
    return result;
  },

  /**
   * node.left — left operand or for-in/of binding.
   */
  get left() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    // Binary/logical/assignment expressions
    if (t >= T.add && t <= T.nullish_assign) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // for-in/of: binding (left side)
    if (t === T.for_in_stmt || t === T.for_of_stmt || t === T.for_await_of_stmt) {
      const d = ast.extraForInOfData(lhs);
      return d.binding === NONE ? null : nodeView(ast, d.binding);
    }
    // AssignmentPattern
    if (t === T.assignment_pattern) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // VariableDeclarator has no 'left' property in ESLint's AST. Return undefined
    // so that `node.left !== void 0` correctly distinguishes it from AssignmentExpression.
    if (t === T.declarator) return undefined;
    return null;
  },

  /**
   * node.right — right operand or for-in/of iterable.
   */
  get right() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    // Binary/logical/assignment expressions
    if (t >= T.add && t <= T.nullish_assign) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // for-in/of: iterable (right side)
    if (t === T.for_in_stmt || t === T.for_of_stmt || t === T.for_await_of_stmt) {
      const d = ast.extraForInOfData(lhs);
      return d.expr === NONE ? null : nodeView(ast, d.expr);
    }
    // AssignmentPattern
    if (t === T.assignment_pattern) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    return null;
  },

  /**
   * node.argument — operand of unary/spread/rest/return/throw/await/yield.
   */
  get argument() {
    const t = this.tag;
    const lhs = ast => ast.nodeLhs(this._i);
    const a = this._ast;
    if (t === T.unary_plus || t === T.unary_minus || t === T.logical_not ||
        t === T.bitwise_not || t === T.typeof_expr || t === T.void_expr ||
        t === T.delete_expr || t === T.prefix_inc || t === T.prefix_dec ||
        t === T.postfix_inc || t === T.postfix_dec || t === T.await_expr ||
        t === T.spread_element || t === T.rest_element ||
        t === T.ts_non_null_expr) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    if (t === T.yield_expr || t === T.yield_delegate) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    if (t === T.return_stmt || t === T.throw_stmt) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    return null;
  },

  /**
   * node.callee — function being called.
   * CallExpression, NewExpression
   */
  get callee() {
    const t = this.tag;
    if (t === T.call_expr || t === T.optional_call_expr || t === T.new_expr) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    return null;
  },

  /**
   * node.arguments — array of argument NodeViews.
   * CallExpression, NewExpression
   */
  get arguments() {
    const t = this.tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.call_expr || t === T.optional_call_expr) {
      const sub = ast.extraSubRange(rhs);
      return ast._nodesFromRange(sub.start, sub.end);
    }
    if (t === T.new_expr) {
      if (rhs === NONE) return [];
      const sub = ast.extraSubRange(rhs);
      return ast._nodesFromRange(sub.start, sub.end);
    }
    return null;
  },

  /**
   * node.object — object being accessed.
   * MemberExpression (all variants)
   */
  get object() {
    const t = this.tag;
    if (t === T.member_expr || t === T.computed_member_expr ||
        t === T.optional_member_expr || t === T.optional_computed_member_expr ||
        t === T.with_stmt) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    return null;
  },

  /**
   * node.property — property being accessed.
   * Dot access: returns synthetic Identifier node (ESTree-compatible).
   * Computed access: returns NodeView of the expression.
   */
  get property() {
    const t = this.tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.member_expr || t === T.optional_member_expr) {
      // rhs is the token index of the property identifier; wrap as synthetic Identifier
      const syn = ast._syntheticId(rhs);
      syn.parent = this;
      return syn;
    }
    if (t === T.computed_member_expr || t === T.optional_computed_member_expr) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // Property node: key
    if (t === T.property || t === T.shorthand_property) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.computed_property) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return null;
  },

  /**
   * node.computed — true for computed member/property access.
   */
  get computed() {
    const t = this.tag;
    return t === T.computed_member_expr || t === T.optional_computed_member_expr ||
           t === T.computed_property || t === T.computed_method_def ||
           t === T.computed_property_def || t === T.computed_getter_def ||
           t === T.computed_setter_def;
  },

  /**
   * node.optional — true for optional chaining.
   */
  get optional() {
    const t = this.tag;
    return t === T.optional_member_expr || t === T.optional_computed_member_expr ||
           t === T.optional_call_expr;
  },

  /**
   * node.prefix — true for prefix update expressions (++x, --x).
   */
  get prefix() {
    const t = this.tag;
    if (t === T.prefix_inc || t === T.prefix_dec) return true;
    if (t === T.postfix_inc || t === T.postfix_dec) return false;
    return null;
  },

  /**
   * node.delegate — true for yield* expressions.
   */
  get delegate() {
    return this.tag === T.yield_delegate;
  },

  /**
   * node.async — true for async functions and for-await-of.
   */
  get async() {
    const t = this.tag;
    return t === T.async_fn_decl || t === T.async_fn_expr ||
           t === T.async_generator_fn_decl || t === T.async_generator_fn_expr ||
           t === T.async_arrow_fn || t === T.for_await_of_stmt;
  },

  /**
   * node.generator — true for generator functions.
   */
  get generator() {
    const t = this.tag;
    return t === T.generator_fn_decl || t === T.generator_fn_expr ||
           t === T.async_generator_fn_decl || t === T.async_generator_fn_expr;
  },

  /**
   * node.static — true for static class members (MethodDefinition, PropertyDefinition).
   * Returns undefined for non-member nodes.
   */
  get static() {
    const t = this.tag;
    if (t !== T.method_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.constructor_def && t !== T.computed_method_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def) return undefined;
    return _methodFlags(this._ast, this.mainToken).static;
  },

  /**
   * node.id — name identifier of function/class declaration, or VariableDeclarator pattern.
   */
  get id() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    // VariableDeclarator: id is the left-hand side (pattern or identifier)
    if (t === T.declarator) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr) {
      const d = ast.extraFnData(lhs);
      return d.name === NONE ? null : nodeView(ast, d.name);
    }
    if (t === T.class_decl || t === T.class_expr) {
      const d = ast.extraClassData(lhs);
      return d.name === NONE ? null : nodeView(ast, d.name);
    }
    return null;
  },

  /**
   * node.params — parameter list of function/arrow.
   * Returns array of NodeViews.
   */
  get params() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr) {
      const d = ast.extraFnData(lhs);
      return ast._nodesFromRange(d.params, d.params_end);
    }
    if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const d = ast.extraArrowData(lhs);
      return ast._nodesFromRange(d.params_start, d.params_end);
    }
    return null;
  },

  /**
   * node.declarations — list of VariableDeclarator nodes.
   */
  get declarations() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.var_decl || t === T.let_decl || t === T.const_decl) {
      // lhs=range.start, rhs=range.end (stored directly)
      return ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
    }
    return null;
  },

  /**
   * node.kind — "var" / "let" / "const" for VariableDeclaration;
   *             "init" / "get" / "set" for Property/MethodDefinition.
   */
  get kind() {
    const t = this.tag;
    if (t === T.var_decl) return 'var';
    if (t === T.let_decl) return 'let';
    if (t === T.const_decl) return 'const';
    if (t === T.getter_def || t === T.computed_getter_def) return 'get';
    if (t === T.setter_def || t === T.computed_setter_def) return 'set';
    if (t === T.constructor_def) return 'constructor';
    if (t === T.method_def || t === T.computed_method_def) {
      // Object literal methods have kind "init" (ESTree Property.kind),
      // class methods have kind "method" (ESTree MethodDefinition.kind).
      const parentIdx = this._ast._parentData ? this._ast._parentData[this._i] : NONE;
      if (parentIdx !== NONE) {
        const parentTag = this._ast._nodeTags[parentIdx];
        if (parentTag === T.object_literal || parentTag === T.object_pattern) {
          return 'init';
        }
      }
      // constructor_def tag should distinguish constructors, but in practice
      // constructors appear as method_def. Fall back: check key token text.
      if (t === T.method_def) {
        const ast = this._ast;
        const mainTok = this.mainToken;
        // identifier token (tag 8) with text "constructor", not static
        if (ast._tokTags[mainTok] === 8 &&
            ast._rawTokenText(mainTok) === 'constructor' &&
            !_methodFlags(ast, mainTok).static) {
          return 'constructor';
        }
      }
      return 'method';
    }
    if (t === T.property || t === T.shorthand_property || t === T.computed_property) return 'init';
    return null;
  },

  /**
   * node.init — initializer in VariableDeclarator or ForStatement.
   */
  get init() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    if (t === T.declarator) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.for_stmt) {
      const d = ast.extraForData(lhs);
      return d.init === NONE ? null : nodeView(ast, d.init);
    }
    return null;
  },

  /**
   * node.update — update expression in ForStatement.
   */
  get update() {
    if (this.tag !== T.for_stmt) return null;
    const ast = this._ast;
    const d = ast.extraForData(ast.nodeLhs(this._i));
    return d.update === NONE ? null : nodeView(ast, d.update);
  },

  /**
   * node.superClass — parent class in ClassDeclaration/Expression.
   */
  get superClass() {
    const t = this.tag;
    if (t !== T.class_decl && t !== T.class_expr) return null;
    const ast = this._ast;
    const d = ast.extraClassData(ast.nodeLhs(this._i));
    return d.super_class === NONE ? null : nodeView(ast, d.super_class);
  },

  /**
   * node.elements — elements of ArrayExpression or ArrayPattern.
   * Holes are represented as null (matching ESLint's AST).
   */
  get elements() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.array_literal || t === T.array_pattern) {
      const lhs = ast.nodeLhs(this._i);
      const rhs = ast.nodeRhs(this._i);
      const slice = ast._extraData.subarray(lhs, rhs);
      const result = [];
      for (let j = 0; j < slice.length; j++) {
        const nodeIdx = slice[j];
        result.push(nodeIdx === NONE ? null : nodeView(ast, nodeIdx));
      }
      return result;
    }
    return null;
  },

  /**
   * node.properties — properties of ObjectExpression or ObjectPattern.
   */
  get properties() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.object_literal || t === T.object_pattern) {
      // lhs=range.start, rhs=range.end (stored directly)
      return ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
    }
    return null;
  },

  /**
   * node.key — key of Property or MethodDefinition.
   */
  get key() {
    const t = this.tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (t === T.property || t === T.shorthand_property ||
        t === T.property_def || t === T.method_def ||
        t === T.getter_def || t === T.setter_def || t === T.constructor_def) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.computed_property || t === T.computed_method_def ||
        t === T.computed_property_def || t === T.computed_getter_def ||
        t === T.computed_setter_def) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return null;
  },

  /**
   * node.shorthand — true for shorthand Property.
   */
  get shorthand() {
    return this.tag === T.shorthand_property;
  },

  /**
   * node.method — true for method shorthand Property.
   */
  get method() {
    return this.tag === T.method_def || this.tag === T.computed_method_def;
  },

  /**
   * node.discriminant — switch expression.
   */
  get discriminant() {
    if (this.tag !== T.switch_stmt) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.cases — array of SwitchCase NodeViews.
   */
  get cases() {
    if (this.tag !== T.switch_stmt) return null;
    const ast = this._ast;
    const sub = ast.extraSubRange(ast.nodeRhs(this._i));
    return ast._nodesFromRange(sub.start, sub.end);
  },

  /**
   * node.label — label identifier.
   * LabeledStatement, BreakStatement (with label), ContinueStatement (with label)
   */
  get label() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.labeled_stmt) {
      return ast._identAt(this.mainToken);
    }
    if (t === T.break_label || t === T.continue_label) {
      // lhs stores label token offset relative to main_token
      const tokOffset = ast.nodeLhs(this._i);
      return tokOffset === NONE ? null : ast._identAt(this.mainToken + tokOffset);
    }
    return null;
  },

  /**
   * node.block — try block.
   */
  get block() {
    if (this.tag !== T.try_stmt) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.handler — the CatchClause node (tag 23, real NodeView).
   * Returns a proper cached NodeView so ESLint identity checks (parent.handler === node) work.
   */
  get handler() {
    if (this.tag !== T.try_stmt) return null;
    const ast = this._ast;
    const d = ast.extraTryData(ast.nodeRhs(this._i));
    return d.catch_node === NONE ? null : nodeView(ast, d.catch_node);
  },

  /**
   * node.finalizer — finally block.
   */
  get finalizer() {
    if (this.tag !== T.try_stmt) return null;
    const ast = this._ast;
    const d = ast.extraTryData(ast.nodeRhs(this._i));
    return d.finally_body === NONE ? null : nodeView(ast, d.finally_body);
  },

  /**
   * node.param — catch clause parameter.
   */
  get param() {
    if (this.tag !== T.catch_clause) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.expression — ExpressionStatement inner expression.
   * Also used for arrow function concise body detection (see getter above).
   */
  get expression() {
    const t = this.tag;
    if (t === T.expression_stmt) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    if (t === T.arrow_fn || t === T.async_arrow_fn) {
      // concise body = body is not a block
      const ast = this._ast;
      const d = ast.extraArrowData(ast.nodeLhs(this._i));
      return d.body !== NONE && ast._nodeTags[d.body] !== T.block_stmt;
    }
    return null;
  },

  /**
   * node.directive — for ExpressionStatement nodes that are directives
   * (e.g., "use strict"). Returns the directive string value, or undefined.
   * ESLint's astUtils.isDirective checks typeof node.directive === "string".
   */
  get directive() {
    if (this.tag !== T.expression_stmt) return undefined;
    const ast = this._ast;
    const exprIdx = ast.nodeLhs(this._i);
    if (exprIdx === NONE) return undefined;
    if (ast._nodeTags[exprIdx] !== T.string_literal) return undefined;
    // Return the string value (without quotes)
    const raw = ast._rawTokenText(ast._mainTokens[exprIdx]);
    if (raw.length >= 2 && (raw[0] === '"' || raw[0] === "'")) {
      return raw.slice(1, -1);
    }
    return undefined;
  },

  /**
   * node.specifiers — ImportDeclaration / ExportNamedDeclaration specifiers.
   */
  get specifiers() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.import_decl) {
      const d = ast.extraImportData(ast.nodeLhs(this._i));
      return ast._nodesFromRange(d.specifiers_start, d.specifiers_end);
    }
    if (t === T.export_named) {
      const rhs = ast.nodeRhs(this._i);
      if (rhs === NONE) return []; // declaration export has no specifiers
      return ast._nodesFromRange(ast.nodeLhs(this._i), rhs);
    }
    return null;
  },

  /**
   * node.source — import/export source literal node (Literal with value/raw).
   * Returns a synthetic Literal node so rules can access .range, .loc, etc.
   */
  get source() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.import_decl) {
      const d = ast.extraImportData(ast.nodeLhs(this._i));
      return d.source === NONE ? null : ast._syntheticLiteral(d.source);
    }
    if (t === T.export_all) {
      const tokIdx = ast.nodeLhs(this._i);
      return tokIdx === NONE ? null : ast._syntheticLiteral(tokIdx);
    }
    return null;
  },

  /**
   * node.local — local binding in import/export specifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get local() {
    const t = this.tag;
    const ast = this._ast;
    let syn;
    if (t === T.import_specifier) {
      syn = ast._syntheticId(ast.nodeRhs(this._i)); // rhs = local name token
      syn.parent = this;
      return syn;
    }
    if (t === T.import_default_specifier || t === T.import_namespace_specifier) {
      syn = ast._syntheticId(ast.nodeLhs(this._i));
      syn.parent = this;
      return syn;
    }
    if (t === T.export_specifier) {
      syn = ast._syntheticId(ast.nodeLhs(this._i));
      syn.parent = this;
      return syn;
    }
    return null;
  },

  /**
   * node.imported — imported name in ImportSpecifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get imported() {
    if (this.tag !== T.import_specifier) return null;
    const syn = this._ast._syntheticId(this._ast.nodeLhs(this._i));
    syn.parent = this;
    return syn;
  },

  /**
   * node.exported — exported name in ExportSpecifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get exported() {
    if (this.tag !== T.export_specifier) return null;
    const syn = this._ast._syntheticId(this._ast.nodeRhs(this._i));
    syn.parent = this;
    return syn;
  },

  /**
   * node.declaration — ExportDefaultDeclaration / ExportNamedDeclaration inner declaration.
   */
  get declaration() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.export_default_expr || t === T.export_default_fn || t === T.export_default_class) {
      const idx = ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(ast, idx);
    }
    if (t === T.export_named) {
      const rhs = ast.nodeRhs(this._i);
      if (rhs !== NONE) return null; // specifiers export has no declaration
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return null;
  },

  /**
   * node.range — [start, end] UTF-16 offsets.
   * end is the position after the last character of the last token in the subtree.
   */
  get range() {
    // Program node always spans the entire source: [0, sourceLength]
    if (this._ast._nodeTags[this._i] === T.root) {
      return [0, this._ast.sourceUtf16Len];
    }
    return [this.start, this._ast._nodeEndPos(this._i)];
  },

  /**
   * node.loc — { start: { line, column }, end: { line, column } }
   * Line is 1-indexed; column is 0-indexed.
   */
  get loc() {
    const ast = this._ast;
    const end = ast._nodeEndPos(this._i);
    const ls = ast._lineStarts();
    // Program node always starts at line 1, column 0
    let startLine, startCol;
    if (ast._nodeTags[this._i] === T.root) {
      startLine = 1;
      startCol = 0;
    } else {
      const start = this.start;
      let lo = 0, hi = ls.length - 1;
      while (lo < hi) {
        const mid = (lo + hi + 1) >> 1;
        if (ls[mid] <= start) lo = mid;
        else hi = mid - 1;
      }
      startLine = lo + 1;
      startCol = start - ls[lo];
    }
    let elo = 0, ehi = ls.length - 1;
    while (elo < ehi) {
      const mid = (elo + ehi + 1) >> 1;
      if (ls[mid] <= end) elo = mid;
      else ehi = mid - 1;
    }
    return {
      start: { line: startLine, column: startCol },
      end: { line: elo + 1, column: end - ls[elo] },
    };
  },

  /**
   * node.tokens — all tokens in the file as ESLint token objects.
   * Only meaningful on Program nodes, but accessible from any node.
   * Cached on the AstView to avoid repeated builds.
   */
  get tokens() {
    const ast = this._ast;
    if (ast._tokensCache) return ast._tokensCache;
    const src = ast.source;
    const tags = ast._tokTags;
    const starts = ast._tokStarts;
    const count = ast.tokenCount;
    const ls = ast._lineStarts();
    const result = [];
    for (let i = 0; i < count; i++) {
      const tag = tags[i];
      if (tag === 131) continue; // skip EOF
      const start = starts[i];
      let end = i + 1 < count ? starts[i + 1] : src.length;
      while (end > start && src.charCodeAt(end - 1) <= 32) end--;
      const value = src.slice(start, end);
      // Map tag to ESLint token type
      let type;
      if (tag <= 1) type = 'Numeric';
      else if (tag === 2) type = 'String';
      else if (tag <= 6) type = 'Template';
      else if (tag === 7) type = 'RegularExpression';
      else if (tag === 8) type = 'Identifier';
      else if (tag <= 71) type = 'Keyword';
      else type = 'Punctuator';
      // Compute loc
      let lo = 0, hi = ls.length - 1;
      while (lo < hi) { const m = (lo + hi + 1) >> 1; if (ls[m] <= start) lo = m; else hi = m - 1; }
      const startLine = lo + 1, startCol = start - ls[lo];
      let elo = 0, ehi = ls.length - 1;
      while (elo < ehi) { const m = (elo + ehi + 1) >> 1; if (ls[m] <= end) elo = m; else ehi = m - 1; }
      result.push({
        type, value, range: [start, end],
        loc: { start: { line: startLine, column: startCol }, end: { line: elo + 1, column: end - ls[elo] } },
        mainToken: i,
      });
    }
    ast._tokensCache = result;
    return result;
  },

  /**
   * node.sourceType — "module" or "script" on Program nodes.
   * Read from the Zig buffer header's source_type field.
   */
  get sourceType() {
    if (this._ast._nodeTags[this._i] === T.root) {
      return this._ast._sourceType === 1 ? 'module' : 'script';
    }
    return undefined;
  },

  /** node.comments — empty array (sanz doesn't track comments yet). Writable so rules can set it. */
  get comments() {
    return this._comments || [];
  },
  set comments(v) {
    this._comments = v;
  },
};

// Pre-allocate the pool (kept for backward compat with callers that import it)
const _pool = Array.from({ length: POOL_SIZE }, () => Object.create(NodeProto));

/**
 * Return a stable NodeView for the given (ast, index) pair.
 * Uses a per-AstView cache to guarantee reference equality:
 *   nodeView(ast, i) === nodeView(ast, i)  // always true
 * This is required for ESLint rules that use `===` for node identity.
 *
 * Automatically unwraps grouping_expr (ParenthesizedExpression) since
 * ESTree-compliant parsers don't emit separate nodes for parentheses.
 */
function nodeView(ast, index) {
  // Unwrap grouping_expr transparently (ESTree doesn't have ParenthesizedExpression)
  while (index !== NONE && ast._nodeTags[index] === T.grouping_expr) {
    index = ast.nodeLhs(index);
  }
  if (index === NONE) return null;
  let cache = ast._nodeCache;
  if (cache === null) {
    cache = new Array(ast.nodeCount);
    ast._nodeCache = cache;
  }
  let n = cache[index];
  if (n === undefined) {
    n = Object.create(NodeProto);
    n._ast = ast;
    n._i = index;
    cache[index] = n;
  }
  return n;
}

// ── Method flag helpers ──────────────────────────────────────────

const TOK_ASYNC   = 44;   // kw_async
const TOK_STATIC  = 46;   // kw_static
const TOK_STAR    = 89;   // asterisk (generator marker)

/**
 * Scan backwards from the method name token to detect async/static/generator flags.
 * Method tokens before the name: `static`, `async`, `*`, `get`, `set`
 * Returns { async: bool, generator: bool, static: bool }.
 */
// Reusable result object — avoids allocating {async, generator, static} per call.
const _methodFlagsResult = { async: false, generator: false, static: false };

function _methodFlags(ast, mainToken) {
  _methodFlagsResult.async = false;
  _methodFlagsResult.generator = false;
  _methodFlagsResult.static = false;
  // Check the main token and scan backwards for modifier keywords.
  // Layout: [static] [async] [*] name (...)
  // mainToken may be: *, async, static, get, set, or the method name identifier.
  const mainTag = ast._tokTags[mainToken];
  if (mainTag === TOK_STAR) _methodFlagsResult.generator = true;
  if (mainTag === TOK_ASYNC) _methodFlagsResult.async = true;
  if (mainTag === TOK_STATIC) _methodFlagsResult.static = true;
  // For async generators: mainToken=async, * is the next token
  if (mainTag === TOK_ASYNC && mainToken + 1 < ast.tokenCount && ast._tokTags[mainToken + 1] === TOK_STAR) {
    _methodFlagsResult.generator = true;
  }
  let i = mainToken - 1;
  while (i >= 0) {
    const tag = ast._tokTags[i];
    if (tag === TOK_STAR)   { _methodFlagsResult.generator = true; i--; continue; }
    if (tag === TOK_ASYNC)  { _methodFlagsResult.async = true;     i--; continue; }
    if (tag === TOK_STATIC) { _methodFlagsResult.static = true;    i--; continue; }
    if (tag >= 9 && tag <= 71) { i--; continue; }
    break;
  }
  return _methodFlagsResult;
}

/**
 * Reset all node cache references.
 * MUST be called between files to prevent source text retention.
 */
function reset() {
  // Caches are per-AstView; nulling _pool entries for legacy callers
  for (let i = 0; i < POOL_SIZE; i++) {
    _pool[i]._ast = null;
    _pool[i]._i = 0;
  }
  _poolIdx = 0;
}

/**
 * Given a raw tag name (from the tagNames array) and the node index, return
 * the effective ESTree type name — remapping TSTypeReference to TS*Keyword
 * when the node is actually a TypeScript built-in keyword type.
 *
 * Used by walkNodes in plugin-runner.js so visitor dispatch uses the same
 * type names as NodeProto.type.
 */
function effectiveTypeName(ast, idx, rawTagName) {
  if (rawTagName === 'TSTypeReference' && ast.nodeRhs(idx) === NONE) {
    const tok = ast._mainTokens[idx];
    const start = ast._tokStarts[tok];
    const end = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : ast.source.length;
    const text = ast.source.slice(start, end).trim();
    return _TS_KW_TYPES[text] || rawTagName;
  }
  return rawTagName;
}

module.exports = { AstView, NodeProto, nodeView, reset, setTagNames, NONE, T, effectiveTypeName };
