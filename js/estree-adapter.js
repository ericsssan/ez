"use strict";

const { T, OPERATOR_BY_TAG } = require("./tags");

// ── Template literal cooked value processor ──────────────────────
// Processes escape sequences in a template literal quasi raw string,
// returning the cooked string or null for illegal escapes.
function _cookTemplate(raw) {
  let result = '';
  let i = 0;
  while (i < raw.length) {
    const ch = raw[i];
    if (ch !== '\\') { result += ch; i++; continue; }
    i++; // consume backslash
    if (i >= raw.length) break;
    const next = raw[i];
    if (next === '\n') { i++; }                          // line continuation LF
    else if (next === '\r') { i++; if (raw[i] === '\n') i++; } // line continuation CRLF
    else if (next === 'n')  { result += '\n'; i++; }
    else if (next === 'r')  { result += '\r'; i++; }
    else if (next === 't')  { result += '\t'; i++; }
    else if (next === 'b')  { result += '\b'; i++; }
    else if (next === 'f')  { result += '\f'; i++; }
    else if (next === 'v')  { result += '\v'; i++; }
    else if (next === '0' && (i + 1 >= raw.length || !/[0-9]/.test(raw[i + 1]))) { result += '\0'; i++; }
    else if (next === 'x')  {
      const hex = raw.slice(i + 1, i + 3);
      if (/^[0-9a-fA-F]{2}$/.test(hex)) { result += String.fromCharCode(parseInt(hex, 16)); i += 3; }
      else return null;
    }
    else if (next === 'u')  {
      if (raw[i + 1] === '{') {
        const end = raw.indexOf('}', i + 2);
        if (end === -1) return null;
        const cp = parseInt(raw.slice(i + 2, end), 16);
        try { result += String.fromCodePoint(cp); } catch { return null; }
        i = end + 1;
      } else {
        const hex = raw.slice(i + 1, i + 5);
        if (/^[0-9a-fA-F]{4}$/.test(hex)) { result += String.fromCharCode(parseInt(hex, 16)); i += 5; }
        else return null;
      }
    }
    else { result += next; i++; } // unrecognized escape — identity
  }
  return result;
}

// ── Statement range extension for trailing semicolons ──────────
// Parser computes node end positions based on child nodes, which excludes trailing semicolons.
// ESLint rules like `semi` need the semicolon to be part of the statement range.
// This workaround extends statement ranges to include the semicolon.

function _isStatementTag(tag) {
  return tag === T.var_decl || tag === T.let_decl || tag === T.const_decl ||
         tag === T.expression_stmt || tag === T.return_stmt || tag === T.throw_stmt ||
         tag === T.break_stmt || tag === T.continue_stmt ||
         tag === T.import_decl || tag === T.export_named ||
         tag === T.export_default_expr || tag === T.export_default_fn || tag === T.export_default_class ||
         tag === T.export_all;
}

function _extendRangeToIncludeSemicolon(ast, endPos) {
  // Look for a semicolon token that starts at or immediately after endPos
  if (!ast._tokStarts) return endPos;

  const tokStarts = ast._tokStarts;
  const tokEnds = ast._tokEnds;
  const tokTags = ast._tokTags;
  const tokenCount = ast.tokenCount;

  // Binary search for first token at or after endPos
  let lo = 0, hi = tokenCount - 1;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (tokStarts[mid] < endPos) lo = mid + 1;
    else hi = mid;
  }

  // Check if this token is a semicolon
  if (lo < tokenCount && tokStarts[lo] <= endPos && tokEnds[lo] > endPos) {
    // Token contains or starts at endPos — check if it's a semicolon
    const tokenTag = tokTags[lo];
    // Semicolon token tag = 78
    if (tokenTag === 78) {
      return tokEnds[lo];
    }
  }

  // Check the next token if current token doesn't fully cover endPos
  if (lo < tokenCount - 1) {
    const nextIdx = lo + 1;
    const nextTag = tokTags[nextIdx];
    // Semicolon token tag = 78
    if (nextTag === 78 && tokStarts[nextIdx] === endPos) {
      return tokEnds[nextIdx];
    }
  }

  return endPos;
}

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
  // v6: comment positions (byte 88, 92, 96, 100)
  COMMENT_COUNT: 88,
  COMMENT_STARTS_OFFSET: 92,
  COMMENT_ENDS_OFFSET: 96,
  COMMENT_KINDS_OFFSET: 100,
  // v7: token end positions (UTF-16)
  TOK_ENDS_OFFSET: 104,
  // v8: pre-computed node positions (UTF-16)
  NODE_START_POS_OFFSET: 108,
  NODE_END_POS_OFFSET: 112,
  // v9: line starts + maxTok from Zig
  LINE_STARTS_OFFSET: 116,
  LINE_STARTS_COUNT: 120,
  MAX_TOK_OFFSET: 124,
  MIN_TOK_OFFSET: 128,
  SORTED_BY_START_OFFSET: 132,
};

// CfgGraphHeader: 25 u32 fields = 100 bytes
const CFG_GRAPH_HEADER_SIZE = 100;

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
  NODE_REACHABLE: 88,   // u8[] per-node reachability: 1=live, 0=dead
  LOOP_EXIT_REACHABLE: 92,  // u8[] per-loop exit reachability: 1=exit alive, 0=exit dead
  _RESERVED_96: 96,        // legacy cfg_events_offset (unused)
  _RESERVED_100: 100,      // legacy cfg_events_count (unused)
  CFG_GRAPH_OFFSET: 104,   // byte offset to CfgGraphHeader (0 = not present)
  SCOPE_REF_STARTS: 108,   // u32[scope_count] — first index in scope_ref_ids per scope
  SCOPE_REF_COUNTS: 112,   // u32[scope_count] — number of refs per scope
  SCOPE_REF_IDS: 116,      // u32[ref_count]   — ref indices sorted by scope
  SCOPE_CHILD_STARTS: 120, // u32[scope_count] — first index in scope_child_ids per scope
  SCOPE_CHILD_COUNTS: 124, // u32[scope_count] — number of child scopes per scope
  SCOPE_CHILD_IDS: 128,    // u32[total_children] — child scope IDs sorted by parent
  TAG_NODE_STARTS: 132,    // u32[tag_count + 1] — prefix-sum (sentinel at end)
  TAG_NODE_IDS: 136,       // u32[node_count]    — node indices sorted by tag
  TAG_COUNT: 140,          // u32 — number of tag slots
  NODE_DEPTHS: 144,        // u32[node_count] — pre-computed node depths
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
// Ez emits TSTypeReference for TS built-in keyword types.
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
    const tokEndsOff = dv.getUint32(H.TOK_ENDS_OFFSET, true);
    this._tokEnds = tokEndsOff > 0 ? new Uint32Array(buffer, tokEndsOff, this.tokenCount) : null;

    // Pre-computed node positions (v8 — computed in Zig)
    const nspOff = dv.getUint32(H.NODE_START_POS_OFFSET, true);
    const nepOff = dv.getUint32(H.NODE_END_POS_OFFSET, true);
    this._nodeStartPosArr = nspOff > 0 ? new Uint32Array(buffer, nspOff, this.nodeCount) : null;
    this._nodeEndPosArr = nepOff > 0 ? new Uint32Array(buffer, nepOff, this.nodeCount) : null;

    // Line starts (v9 — computed in Zig, UTF-16 positions)
    const lsCount = dv.getUint32(H.LINE_STARTS_COUNT, true);
    const lsOff = dv.getUint32(H.LINE_STARTS_OFFSET, true);
    this._lineStartsArr = (lsCount > 0 && lsOff > 0) ? new Uint32Array(buffer, lsOff, lsCount) : null;

    // Max token per subtree (v9 — pre-computed in Zig)
    const mtOff = dv.getUint32(H.MAX_TOK_OFFSET, true);
    this._maxTokFromBuffer = mtOff > 0 ? new Uint32Array(buffer, mtOff, this.nodeCount) : null;
    const minTokOff = dv.getUint32(H.MIN_TOK_OFFSET, true);
    this._minTokFromBuffer = minTokOff > 0 ? new Uint32Array(buffer, minTokOff, this.nodeCount) : null;

    // Sorted node indices for O(log n) getNodeByRangeIndex
    const sbsOff = dv.getUint32(H.SORTED_BY_START_OFFSET, true);
    this._sortedByStart = sbsOff > 0 ? new Uint32Array(buffer, sbsOff, this.nodeCount) : null;

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
    this._preOrder  = preOff  > 0 ? new Uint32Array(buffer, preOff,  this.nodeCount) : null;
    this._postOrder = postOff > 0 ? new Uint32Array(buffer, postOff, this.nodeCount) : null;

    // Interleaved DFS events (v5 — enter/exit in correct DFS order, computed in Zig)
    // Copy immediately: the Zig allocator reuses this memory region during subsequent
    // native calls, so a live TypedArray view would see stale data by the time
    // getDFSEvents() is called inside runPlugins.
    const dfsEvOff = dv.getUint32(H.DFS_EVENTS_OFFSET, true);
    if (dfsEvOff > 0) {
      const view = new Int32Array(buffer, dfsEvOff, this.nodeCount * 2);
      this._dfsEvents = new Int32Array(view);  // copy, not a view
    } else {
      this._dfsEvents = null;
    }

    // Source type (v5 — 1 = module, 0 = script)
    this._sourceType = dv.getUint32(H.SOURCE_TYPE, true);

    // Comment positions (v6 — recorded by Zig lexer)
    this._commentCount = dv.getUint32(H.COMMENT_COUNT, true);
    if (this._commentCount > 0) {
      const csOff = dv.getUint32(H.COMMENT_STARTS_OFFSET, true);
      const ceOff = dv.getUint32(H.COMMENT_ENDS_OFFSET, true);
      const ckOff = dv.getUint32(H.COMMENT_KINDS_OFFSET, true);
      this._commentStarts = new Uint32Array(buffer, csOff, this._commentCount);
      this._commentEnds = new Uint32Array(buffer, ceOff, this._commentCount);
      this._commentKinds = new Uint8Array(buffer, ckOff, this._commentCount);
    } else {
      this._commentStarts = null;
      this._commentEnds = null;
      this._commentKinds = null;
    }

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
        // Pre-decode all symbol names eagerly: 1 TextDecoder call per file (ASCII fast path)
        // or N calls (non-ASCII fallback). Makes _symName() a pure O(1) array lookup.
        // Also pre-populates the lazy source cache as a side-effect.
        const symCount = this._semSymbolCount;
        const nameCache = new Array(symCount);
        const srcStr = _decoder.decode(this._sourceBytes);
        this._sourceText = srcStr; // pre-fill lazy source cache
        if (srcStr.length === this.sourceLen) {
          // All-ASCII source: byte offset == char offset in decoded string → string slicing
          const srcOff = this._sourceOff;
          for (let i = 0; i < symCount; i++) {
            const s = this._symNameStarts[i], l = this._symNameLens[i];
            const cs = s - srcOff;
            nameCache[i] = (l === 0 || cs < 0) ? '' : srcStr.slice(cs, cs + l);
          }
        } else {
          // Non-ASCII source: per-symbol TextDecoder (correctness fallback)
          const bufLen = buffer.byteLength;
          for (let i = 0; i < symCount; i++) {
            const s = this._symNameStarts[i], l = this._symNameLens[i];
            nameCache[i] = (l === 0 || s + l > bufLen) ? '' : _decoder.decode(new Uint8Array(buffer, s, l));
          }
        }
        this._symNameCache = nameCache;
      }

      if (this._semRefCount > 0) {
        this._refSymbolIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SYMBOL_IDS, true), this._semRefCount);
        this._refKinds        = new Uint8Array (buffer, dv.getUint32(semOff + SH.REF_KINDS, true),       this._semRefCount);
        this._refNodeIds      = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_NODE_IDS, true),    this._semRefCount);
        this._refScopeIds     = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SCOPE_IDS, true),   this._semRefCount);
      }

      this._nodeScopeIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.NODE_SCOPE_IDS, true),  this.nodeCount);
      const reachOff = dv.getUint32(semOff + SH.NODE_REACHABLE, true);
      this._nodeReachable   = reachOff > 0 ? new Uint8Array(buffer, reachOff, this.nodeCount) : null;
      const loopExitOff = dv.getUint32(semOff + SH.LOOP_EXIT_REACHABLE, true);
      this._loopExitReachable = loopExitOff > 0 ? new Uint8Array(buffer, loopExitOff, this.nodeCount) : null;
      // Full code path graph
      const cfgGraphOff = dv.getUint32(semOff + SH.CFG_GRAPH_OFFSET, true);
      if (cfgGraphOff > 0 && cfgGraphOff + CFG_GRAPH_HEADER_SIZE <= buffer.byteLength) {
        try { this._cfgGraph = new CfgGraph(buffer, dv, cfgGraphOff); }
        catch { this._cfgGraph = null; }
      } else {
        this._cfgGraph = null;
      }

      // Scope → refs CSR (precomputed in Zig)
      const srOff = dv.getUint32(semOff + SH.SCOPE_REF_STARTS, true);
      if (srOff > 0) {
        this._scopeRefStarts = new Uint32Array(buffer, srOff, this._semScopeCount);
        this._scopeRefCounts = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_REF_COUNTS, true), this._semScopeCount);
        const sriOff = dv.getUint32(semOff + SH.SCOPE_REF_IDS, true);
        this._scopeRefIds = sriOff > 0 ? new Uint32Array(buffer, sriOff, this._semRefCount) : null;
      }

      // Scope → children CSR (precomputed in Zig)
      const scOff = dv.getUint32(semOff + SH.SCOPE_CHILD_STARTS, true);
      if (scOff > 0) {
        this._scopeChildStarts = new Uint32Array(buffer, scOff, this._semScopeCount);
        this._scopeChildCounts = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_CHILD_COUNTS, true), this._semScopeCount);
        const sciOff = dv.getUint32(semOff + SH.SCOPE_CHILD_IDS, true);
        if (sciOff > 0 && this._semScopeCount > 0) {
          const lastScope = this._semScopeCount - 1;
          const totalChildren = this._scopeChildStarts[lastScope] + this._scopeChildCounts[lastScope];
          this._scopeChildIds = new Uint32Array(buffer, sciOff, totalChildren);
        }
      }

      // Tag → nodes CSR (precomputed in Zig)
      const tagCount = dv.getUint32(semOff + SH.TAG_COUNT, true);
      const tnsOff = dv.getUint32(semOff + SH.TAG_NODE_STARTS, true);
      if (tnsOff > 0 && tagCount > 0) {
        this._tagNodeStarts = new Uint32Array(buffer, tnsOff, tagCount + 1); // +1 sentinel
        const tniOff = dv.getUint32(semOff + SH.TAG_NODE_IDS, true);
        if (tniOff > 0) {
          this._tagNodeIds = new Uint32Array(buffer, tniOff, this.nodeCount);
        }
        this._tagCount = tagCount;
      }

      // Pre-computed node depths (u32 per node)
      const ndOff = dv.getUint32(semOff + SH.NODE_DEPTHS, true);
      if (ndOff > 0) this._nodeDepths = new Uint32Array(buffer, ndOff, this.nodeCount);
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

  /**
   * Find all comments whose ranges overlap [start, end).
   * Uses binary search on the sorted _commentStarts array. O(log n + k).
   */
  commentsInRange(start, end) {
    if (!this._commentStarts || this._commentCount === 0) return [];
    const cs = this._commentStarts;
    const ce = this._commentEnds;
    const ck = this._commentKinds;
    const src = this.source;
    // Binary search: first comment that ends after start
    let lo = 0, hi = this._commentCount;
    while (lo < hi) { const m = (lo + hi) >> 1; if (ce[m] <= start) lo = m + 1; else hi = m; }
    const results = [];
    const ls = this._lineStarts();
    for (let i = lo; i < this._commentCount && cs[i] < end; i++) {
      const cStart = cs[i];
      const cEnd = ce[i];
      const kind = ck[i] === 0 ? 'Line' : 'Block';
      // Strip the // or /* */ delimiters for the value.
      // For Line comments, the parser includes the trailing newline in cEnd —
      // ESLint/Espree expects it excluded from range, value, and loc.
      const valStart = cStart + 2; // skip `//` or `/*`
      let adjEnd = cEnd;
      if (kind === 'Line') {
        // Strip trailing \n, \r\n, \r from range
        while (adjEnd > valStart && (src.charCodeAt(adjEnd - 1) === 10 || src.charCodeAt(adjEnd - 1) === 13)) adjEnd--;
      }
      const valEnd = kind === 'Block' ? adjEnd - 2 : adjEnd;
      const startLine = this._findLineIdx(cStart);
      const endLine   = this._findLineIdx(adjEnd > cStart ? adjEnd - 1 : cStart);
      results.push({
        type: kind, value: src.slice(valStart, valEnd),
        start: cStart, end: adjEnd,
        range: [cStart, adjEnd],
        loc: {
          start: { line: startLine + 1, column: cStart - ls[startLine] },
          end:   { line: endLine + 1,   column: adjEnd - ls[endLine]   },
        },
      });
    }
    return results;
  }

  /** Token start offset (UTF-16) for a given token index. */
  tokenStart(index) {
    return this._tokStarts[index];
  }

  /** Token tag (u8) for a given token index. */
  tokenTag(index) {
    return this._tokTags[index];
  }

  /** Node tag array (Uint8Array). Used by eslint-runner for fast traversal. */
  get nodeTags() {
    return this._nodeTags;
  }

  /**
   * Build and cache the line start offsets array (lazy).
   * Entry i is the UTF-16 offset of the start of line i+1 (0-indexed).
   */
  _lineStarts() {
    if (this._ls !== undefined) return this._ls;
    this._ls = this._lineStartsArr;
    return this._ls;
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
   * Used by the `property` getter on MemberExpression nodes, where ez stores
   * the property name as a token index rather than a full AST node.
   */
  _syntheticId(tokIdx) {
    const start = this._tokStarts[tokIdx];
    const src = this.source;
    let end = this._tokEnds ? this._tokEnds[tokIdx] : undefined;
    if (end === undefined) {
      end = tokIdx + 1 < this.tokenCount ? this._tokStarts[tokIdx + 1] : src.length;
      while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    }
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
    let end = this._tokEnds ? this._tokEnds[tokIdx] : undefined;
    if (end === undefined) {
      end = tokIdx + 1 < this.tokenCount ? this._tokStarts[tokIdx + 1] : src.length;
      while (end > start && src.charCodeAt(end - 1) <= 32) end--;
    }
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
      parent: null, // set by callers (source getter, etc.)
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

  /** JsxElementData { opening, children_start, children_end, closing } */
  extraJsxElementData(i) {
    const e = this._extraData;
    return { opening: e[i], children_start: e[i + 1], children_end: e[i + 2], closing: e[i + 3] };
  }

  /** JsxOpeningData { name, attrs_start, attrs_end } */
  extraJsxOpeningData(i) {
    const e = this._extraData;
    return { name: e[i], attrs_start: e[i + 1], attrs_end: e[i + 2] };
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
    // Use token end position if available (accounts for comments between tokens)
    // Otherwise fall back to next token's start or source length
    let end = this._tokEnds?.[tokIdx];
    if (end === undefined) {
      if (tokIdx + 1 < this.tokenCount) {
        end = this._tokStarts[tokIdx + 1];
        while (end > start && (src.charCodeAt(end - 1) <= 32)) end--;
      } else {
        end = src.length;
      }
    }
    return src.slice(start, end);
  }

  // ── Semantic accessors ─────────────────────────────────────────

  /** Get the name of a symbol. All names are pre-decoded at construction; pure array lookup. */
  _symName(symId) {
    const cache = this._symNameCache;
    if (!cache) return '';
    return cache[symId] ?? '';
  }

  /**
   * Returns true if the node at nodeIdx is in a reachable code path.
   * Pre-computed by Zig's semantic analysis; defaults to true if not available.
   */
  nodeReachable(nodeIdx) {
    if (!this._nodeReachable) return true;
    return this._nodeReachable[nodeIdx] !== 0;
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
    return this._nodeEndPosArr[nodeIdx];
  }

  _ensureMaxTokCache() {
    if (!this._maxTokCache) this._maxTokCache = this._maxTokFromBuffer;
  }

  _nodeStartPos(nodeIdx) {
    return this._nodeStartPosArr[nodeIdx];
  }

}

// ── NodeView Pool ────────────────────────────────────────────────
// Pre-allocated pool of NodeView objects with prototype-based lazy getters.
// After warmup, zero allocations during traversal → zero GC pressure.

const _decoder = new TextDecoder();
const _emptyArray = Object.freeze([]);

/**
 * Shared prototype for all NodeView objects.
 * Getters compute values lazily from the AstView typed arrays.
 *
 * Provides both the low-level ez API (lhs, rhs) and ESTree-compatible
 * named field getters (test, consequent, body, operator, etc.) so that
 * real ESLint rules can run against ez's zero-copy AST buffer.
 */
// Sentinel for "parent not yet computed". Using a unique object (not undefined/null)
// lets nodeView pre-set _parent as an own property on every new node so all nodes
// share the same V8 hidden class {_ast, _i, _parent} from creation — preventing
// the IC polymorphism that occurs when _parent is added on first access.
const _PARENT_UNSET = Object.create(null);
// Sentinel for "body not yet computed". Distinct from null (valid body value for
// nodes where body is absent) and from arrays/objects (valid body values).
const _BODY_UNSET = Object.create(null);
// Sentinel for "value not yet computed". Distinct from null (valid for null_literal)
// and from false/0/"" (valid for boolean/number/string literals).
const _VALUE_UNSET = Object.create(null);

const NodeProto = {
  // ── Low-level ez accessors (existing) ──────────────────────

  get type() {
    // Fast path: return cached value from pre-allocated own field.
    // _type is initialized to null in nodeView(); all instances share the same
    // hidden class so V8 can inline this check with a single field offset load.
    if (this._type !== null) return this._type;
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
    this._type = result; // cached in pre-allocated own field (see nodeView)
    return result;
  },
  /** Internal numeric tag (Zig AST node type). Use this for all internal checks. */
  get _tag() {
    return this._ast._nodeTags[this._i];
  },
  /**
   * ESTree-compatible `tag`:
   * - TaggedTemplateExpression: returns the tag expression node
   * - All others: returns the internal numeric tag (backward compat for eslint-runner)
   */
  get tag() {
    const t = this._ast._nodeTags[this._i];
    if (t === T.tagged_template) {
      const idx = this._ast.nodeLhs(this._i);
      // Use nodeViewChain: (obj?.fn)`template` — the tag may be an optional chain.
      return idx === NONE ? null : nodeViewChain(this._ast, idx);
    }
    return t;
  },
  get mainToken() {
    return this._ast._mainTokens[this._i];
  },
  get start() {
    const ast = this._ast;
    // SequenceExpression: ez assigns '(' as main token, but ESTree requires
    // start at the first expression (the paren is not part of the node's range).
    if (ast._nodeTags[this._i] === T.sequence_expr) {
      const lhs = ast.nodeLhs(this._i);
      const rhs = ast.nodeRhs(this._i);
      const extra = ast._extraData;
      for (let i = lhs; i < rhs; i++) {
        const ci = extra[i];
        if (ci !== NONE) return ast._nodeStartPos(ci);
      }
    }
    return ast._nodeStartPos(this._i);
  },
  get end() {
    if (this._ast._nodeTags[this._i] === T.root) return this._ast.sourceUtf16Len;
    return this._ast._nodeEndPos(this._i);
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
  // These map ESTree named fields to the underlying ez flat buffer,
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
    if (this._parent !== _PARENT_UNSET) return this._parent;
    const pd = this._ast._parentData;
    if (!pd) { this._parent = null; return null; }
    // Walk past grouping_expr (ParenthesizedExpression) parents since nodeView
    // unwraps them — without this skip the parent chain would cycle:
    //   child → ParenthesizedExpression parent → nodeView unwraps back to child
    let parentIdx = pd[this._i];
    while (parentIdx !== NONE && this._ast._nodeTags[parentIdx] === T.grouping_expr) {
      parentIdx = pd[parentIdx];
    }
    let result = parentIdx === NONE ? null : nodeView(this._ast, parentIdx);

    // If this node is the outermost of an optional chain (i.e., it's optional itself, not a non-optional
    // chain middle), wrap it in a ChainExpression and return that as the parent.
    // This ensures the parent chain matches ESTree structure where ChainExpression wraps the
    // outermost optional node:
    //   buffer: parentNode -> optionalNode
    //   ESTree: parentNode -> ChainExpression { expression: optionalNode }
    // Example: (Object?.prototype).p = 0
    //   buffer: MemberExpression(.p) -> MemberExpression(.prototype, optional)
    //   ESTree: MemberExpression(.p) -> ChainExpression -> MemberExpression(.prototype, optional)
    const thisTag = this._ast._nodeTags[this._i];
    if (result && _isOptionalTag(thisTag)) {
      // This node is optional. Wrap it in a ChainExpression.
      const chainExpr = _getChainExpr(this._ast, this._i);
      // Store the actual parent so that chainExpr.parent returns the right value
      Object.defineProperty(chainExpr, '_realParent', {
        value: result,
        writable: true,
        enumerable: false,
        configurable: true
      });
      this._parent = chainExpr;
      return chainExpr;
    }

    // Class body members (MethodDefinition, PropertyDefinition) should parent to synthetic ClassBody.
    // Only route these specific tags to avoid breaking scope detection for other node types.
    if (result && (result._tag === T.class_decl || result._tag === T.class_expr)) {
      const t = this._tag;
      if (t === T.method_def || t === T.property_def || t === T.getter_def ||
          t === T.setter_def || t === T.constructor_def || t === T.computed_method_def ||
          t === T.computed_getter_def || t === T.computed_setter_def ||
          t === T.computed_property_def || t === T.static_block) {
        const body = result.body; // Returns the synthetic ClassBody
        if (body && body.body && body.body.includes(this)) {
          result = body;
        }
      }
    }

    // Method/getter/setter bodies: the block's parent in ez is the method_def,
    // but ESTree has FunctionExpression between them. Synthesize it so
    // `isFunction(node.parent)` works for rules like no-empty.
    if (result && this._tag === T.block_stmt) {
      const pt = result._tag;
      if (pt === T.method_def || pt === T.getter_def || pt === T.setter_def ||
          pt === T.constructor_def || pt === T.computed_method_def ||
          pt === T.computed_getter_def || pt === T.computed_setter_def) {
        result = result.value; // .value getter returns the synthetic FunctionExpression
      }
    }
    // ESTree requires ObjectPattern children to be wrapped in Property nodes.
    // Ez stores AssignmentPattern/Identifier directly under ObjectPattern
    // for destructuring defaults ({a=1}) and shorthand-less patterns.
    // Synthesize a Property wrapper so parent-chain checks like
    // `node.parent.parent.type === "ObjectPattern"` work correctly.
    if (result && result._tag === T.object_pattern) {
      const t = this._tag;
      if (t === T.assignment_pattern || t === T.identifier) {
        const key = t === T.assignment_pattern
          ? (this._ast.nodeLhs(this._i) !== NONE ? nodeView(this._ast, this._ast.nodeLhs(this._i)) : this)
          : this;
        result = {
          type: 'Property', key, value: this, kind: 'init', method: false,
          shorthand: true, computed: false,
          start: this.start, end: this.end, range: this.range, loc: this.loc,
          parent: result,
        };
      }
    }
    this._parent = result;
    return result;
  },
  set parent(v) {
    this._parent = v;
  },

  /**
   * node.operator — binary/unary/assignment operator string.
   * Derived entirely from the tag; no buffer access needed.
   */
  get operator() {
    return OPERATOR_BY_TAG[this._tag] || null;
  },

  /**
   * node.name — identifier name string.
   * Also used by FunctionDeclaration/ClassDeclaration via .id.name.
   */
  get name() {
    const t = this._tag;
    if (t === T.identifier) {
      const ast = this._ast;
      const tok = this.mainToken;
      const pos = ast._tokStarts[tok];
      if (ast.source.charCodeAt(pos) === 35) { // '#'
        const nextTokStart = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : pos + 1;
        if (nextTokStart === pos + 1 && tok + 1 < ast.tokenCount) {
          return _resolveUnicodeEscapes(ast._identAt(tok + 1));
        }
        return _resolveUnicodeEscapes(ast.source.slice(pos + 1, nextTokStart).replace(/\s+$/, ''));
      }
      return _resolveUnicodeEscapes(ast._identAt(tok));
    }
    // JSXOpeningElement.name / JSXClosingElement.name / JSXSelfClosing.name
    if (t === T.jsx_opening_element || t === T.jsx_self_closing) {
      const ast = this._ast;
      const d = ast.extraJsxOpeningData(ast.nodeLhs(this._i));
      return d.name !== NONE ? nodeView(ast, d.name) : null;
    }
    if (t === T.jsx_closing_element) {
      const lhs = this._ast.nodeLhs(this._i);
      return lhs !== NONE ? nodeView(this._ast, lhs) : null;
    }
    // JSXAttribute.name
    if (t === T.jsx_attribute) {
      const lhs = this._ast.nodeLhs(this._i);
      return lhs !== NONE ? nodeView(this._ast, lhs) : null;
    }
    return undefined;
  },

  /**
   * node.value — literal value, or FunctionExpression for methods/properties.
   * Returns raw source text for strings (including quotes), parsed number,
   * boolean, or null. ESLint returns the evaluated value; we approximate.
   */
  get value() {
    if (this._value !== _VALUE_UNSET) return this._value;
    let v;
    const t = this._tag;
    const ast = this._ast;
    const src = ast._rawTokenText(this.mainToken);
    if (t === T.string_literal) {
      // Strip surrounding quotes and unescape basic sequences.
      // ESLint's Literal.value is the evaluated string, not the raw source.
      if (src.length >= 2 && (src[0] === '"' || src[0] === "'")) {
        const inner = src.slice(1, -1);
        if (inner.indexOf('\\') === -1) {
          // Fast path: no backslash → no escapes to process
          v = inner;
        } else {
          // Slow path: process escape sequences
          v = inner.replace(/\\(u\{[0-9a-fA-F]+\}|u[0-9a-fA-F]{4}|x[0-9a-fA-F]{2}|[0-7]{1,3}|.)/g, (_, esc) => {
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
      } else {
        v = src;
      }
    } else if (t === T.number_literal) {
      const s = src.replace(/_/g, ''); // strip numeric separators (1_000 → 1000)
      const sl = s.toLowerCase();
      if (sl.startsWith('0b')) v = parseInt(sl.slice(2), 2);       // binary: 0b101
      else if (sl.startsWith('0o')) v = parseInt(sl.slice(2), 8);  // modern octal: 0o71
      else if (sl.startsWith('0x')) v = parseInt(sl.slice(2), 16); // hex: 0xff
      else if (/^0[0-7]+$/.test(s)) v = parseInt(s, 8);            // legacy octal: 071
      else v = parseFloat(s);
    } else if (t === T.boolean_literal) {
      v = src === 'true';
    } else if (t === T.null_literal) {
      v = null;
    } else if (t === T.bigint_literal) {
      v = src.slice(0, -1); // strip 'n'
    } else if (t === T.regex_literal) {
      // ESTree spec: Literal.value for a regex is the RegExp object, not a string.
      // Returning the raw source string as value causes rules like no-useless-escape
      // to take the string-escape path (typeof value === "string") instead of the
      // regex path, producing false positives for valid regex escapes like /\./.
      const r = this.regex;
      if (!r) {
        v = null;
      } else {
        try { v = new RegExp(r.pattern, r.flags); } catch { v = null; }
      }
    } else if (t === T.declarator) {
      // VariableDeclarator .value = init (ESLint uses .init, but some rules use .value)
      v = this.rhsNode();
    } else if (t === T.property || t === T.computed_property || t === T.shorthand_property) {
      // Property (key: value) — rhs is the value expression.
      // For shorthand properties ({ a }), value === key (same Identifier node).
      const rhs = ast.nodeRhs(this._i);
      if (rhs !== NONE) {
        v = nodeView(ast, rhs);
      } else {
        // Shorthand: value is the same as key
        const lhs = ast.nodeLhs(this._i);
        v = lhs === NONE ? null : nodeView(ast, lhs);
      }
    } else if (t === T.property_def || t === T.computed_property_def) {
      // PropertyDefinition (class field) — rhs is the initializer expression, or null if absent.
      const rhs = ast.nodeRhs(this._i);
      v = rhs === NONE ? null : nodeView(ast, rhs);
    } else if (t === T.method_def || t === T.getter_def || t === T.setter_def ||
        t === T.constructor_def || t === T.computed_method_def ||
        t === T.computed_getter_def || t === T.computed_setter_def) {
      // Method/getter/setter — return a synthetic FunctionExpression.
      // Cache the synthetic to ensure identity equality: node.parent.value === node
      // (no-setter-return checks `parent.value === node` — must be the same object).
      if (this._syntheticFn !== undefined) {
        v = this._syntheticFn;
      } else {
        const md = ast.extraMethodData(ast.nodeRhs(this._i));
        const flags = _methodFlags(ast, this.mainToken);
        const params = ast._nodesFromRange(md.params_start, md.params_end);
        const body = md.body === NONE ? null : nodeView(ast, md.body);
        // Use the method node's own range/loc so ESLint's SourceCode token
        // lookups (getFirstToken, getTokenBefore) work on this synthetic node.
        const myRange = this.range;
        const myLoc = this.loc;
        // Wrap TS parameter properties (public/private/protected/readonly params)
        // in TSParameterProperty nodes so rules like no-empty-function can detect them.
        if (params && (t === T.constructor_def || t === T.method_def || t === T.computed_method_def)) {
          for (let pi = 0; pi < params.length; pi++) {
            const p = params[pi];
            if (!p || p.mainToken === undefined) continue;
            // Check if the token before the param's mainToken is an access modifier
            const prevTok = p.mainToken > 0 ? ast._tokTags[p.mainToken - 1] : 0;
            // kw_public, kw_private, kw_protected, kw_readonly — check tag names
            const prevVal = prevTok > 0 ? ast.source.slice(ast._tokStarts[p.mainToken - 1], ast._tokEnds[p.mainToken - 1]) : '';
            if (prevVal === 'public' || prevVal === 'private' || prevVal === 'protected' || prevVal === 'readonly') {
              params[pi] = {
                type: 'TSParameterProperty',
                parameter: p,
                accessibility: prevVal === 'readonly' ? undefined : prevVal,
                readonly: prevVal === 'readonly',
                start: p.start, end: p.end, range: p.range, loc: p.loc,
                parent: null, // set below
              };
            }
          }
        }
        const synth = {
          type: 'FunctionExpression',
          id: null,
          async: flags.async,
          generator: flags.generator,
          params: params || [],
          body,
          mainToken: this.mainToken,
          start: myRange[0],
          end: myRange[1],
          range: myRange,
          loc: myLoc,
          parent: this, // parent = the Property/MethodDefinition node
        };
        // Update param parents to point to the FunctionExpression, not the
        // Property/MethodDefinition. Rules like id-length check `node.parent.type`
        // and expect function parameters to have FunctionExpression as parent.
        if (params) {
          for (let pi = 0; pi < params.length; pi++) {
            if (params[pi]) params[pi]._parent = synth;
          }
        }
        if (body) body._parent = synth;
        this._syntheticFn = synth;
        v = synth;
      }
    } else if (t === T.template_element) {
      // ESTree: value = { raw: string, cooked: string | null }
      // raw = literal source text; cooked = text with escape sequences processed.
      // Use tokStarts[mainToken+1] as the end rather than this.range[1], because
      // _nodeEndPos can extend past the quasi boundary into trailing `;` tokens.
      const mt = this.mainToken;
      const start = ast._tokStarts[mt];
      const end = (mt + 1 < ast.tokenCount) ? ast._tokStarts[mt + 1] : ast.source.length;
      // trimEnd() strips the whitespace gap between the token and the next token,
      // so the closing ` or } is always at the end when the regex anchors run.
      const raw = ast.source.slice(start, end).trimEnd().replace(/^`|`$/g, '').replace(/^\}|\$\{$/g, '');
      v = { raw, cooked: _cookTemplate(raw) };
    } else if (t === T.jsx_text_node) {
      // JSXText: value is the raw text content between tags.
      const mt = this.mainToken;
      const s = ast._tokStarts[mt], e = ast._tokEnds[mt];
      v = ast.source.slice(s, e);
    } else if (t === T.jsx_attribute) {
      // JSXAttribute: value is the rhs (string literal, expression container, or null)
      const rhs = ast.nodeRhs(this._i);
      v = rhs === NONE ? null : nodeView(ast, rhs);
    } else {
      v = null;
    }
    this._value = v;
    return v;
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
    if (this._tag !== T.regex_literal) return undefined;
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
    if (this._tag !== T.bigint_literal) return undefined;
    const src = this._ast._rawTokenText(this.mainToken);
    return src.endsWith('n') ? src.slice(0, -1) : src;
  },

  /**
   * node.test — condition expression.
   * IfStatement, WhileStatement, DoWhileStatement, ForStatement, ConditionalExpression
   */
  get test() {
    const t = this._tag;
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
    const t = this._tag;
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
      // Use nodeViewChain: (a ? obj?.b : c)() — consequent may be optional chain.
      return d.consequent === NONE ? null : nodeViewChain(ast, d.consequent);
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
    const t = this._tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.if_stmt) return null;
    if (t === T.if_else_stmt) {
      const d = ast.extraIfData(rhs);
      return d.alternate === NONE ? null : nodeView(ast, d.alternate);
    }
    if (t === T.conditional) {
      const d = ast.extraConditional(rhs);
      // Use nodeViewChain: (a ? b : obj?.c)() — alternate may be optional chain.
      return d.alternate === NONE ? null : nodeViewChain(ast, d.alternate);
    }
    return null;
  },

  /**
   * node.body — body of statements, loop body, or function body.
   */
  get body() {
    if (this._body !== _BODY_UNSET) return this._body;
    const t = this._tag;
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
      // Find the '{' token that opens the class body
      const mt = ast._mainTokens[this._i];
      const tokTags = ast._tokTags;
      let bodyOpenTok = mt;
      for (let j = mt + 1; j < ast.tokenCount; j++) {
        if (tokTags[j] === 74 /* l_brace */) { bodyOpenTok = j; break; }
      }
      const cbStart = ast._tokStarts[bodyOpenTok];
      const cbEnd = this.end;
      result = {
        type: 'ClassBody',
        body: members,
        start: cbStart,
        end: cbEnd,
        range: [cbStart, cbEnd],
        loc: this.loc, // approximate — line/col computed lazily by SourceCode
        parent: this,
      };
      // Update each member's parent to point to the synthetic ClassBody instead of the ClassDeclaration
      for (const member of members) {
        member._parent = result;
      }
    } else if (t === T.root) {
      result = ast._nodesFromRange(lhs, rhs);
    }
    this._body = result;
    return result;
  },

  /**
   * node.left — left operand or for-in/of binding.
   */
  get left() {
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (t >= T.add && t <= T.nullish_assign) {
      // Logical/nullish: left may be optional chain.
      if (t === T.logical_and || t === T.logical_or || t === T.nullish_coalesce) {
        return lhs === NONE ? null : nodeViewChain(ast, lhs);
      }
      // Arithmetic binary: disallowArithmeticOperators checks left too.
      if (t >= T.add && t <= T.exponentiate) {
        return lhs === NONE ? null : nodeViewChain(ast, lhs);
      }
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
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    if (t >= T.add && t <= T.nullish_assign) {
      // Logical/nullish: right may be optional chain propagating undefined.
      if (t === T.logical_and || t === T.logical_or || t === T.nullish_coalesce) {
        return rhs === NONE ? null : nodeViewChain(ast, rhs);
      }
      // Arithmetic binary (+,-,*,/,%,**): disallowArithmeticOperators checks right.
      if (t >= T.add && t <= T.exponentiate) {
        return rhs === NONE ? null : nodeViewChain(ast, rhs);
      }
      // in / instanceof: checkUnsafeUsage(node.right)
      if (t === T.instanceof_expr || t === T.in_expr) {
        return rhs === NONE ? null : nodeViewChain(ast, rhs);
      }
      // Arithmetic compound assignment (+=,-=,*=,/=,%=,**=): checkUnsafeArithmetic(node.right)
      if (t >= T.add_assign && t <= T.exp_assign) {
        return rhs === NONE ? null : nodeViewChain(ast, rhs);
      }
      // Plain assignment: ([foo] = obj?.bar) — right may be optional chain when left is pattern.
      if (t === T.assign) {
        return rhs === NONE ? null : nodeViewChain(ast, rhs);
      }
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // for-in/of: iterable may be optional chain (undefined iterator → TypeError)
    if (t === T.for_in_stmt || t === T.for_of_stmt || t === T.for_await_of_stmt) {
      const d = ast.extraForInOfData(lhs);
      return d.expr === NONE ? null : nodeViewChain(ast, d.expr);
    }
    // AssignmentPattern: right may be optional chain (destructuring default)
    if (t === T.assignment_pattern) {
      return rhs === NONE ? null : nodeViewChain(ast, rhs);
    }
    return null;
  },

  /**
   * node.argument — operand of unary/spread/rest/return/throw/await/yield.
   */
  get argument() {
    const t = this._tag;
    const lhs = ast => ast.nodeLhs(this._i);
    const a = this._ast;
    // await/unary-arithmetic: argument may be optional chain.
    // (await obj?.foo)() or +(await obj?.foo) — checkUndefinedShortCircuit traverses into argument.
    if (t === T.await_expr || t === T.unary_plus || t === T.unary_minus) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeViewChain(a, idx);
    }
    if (t === T.logical_not || t === T.bitwise_not || t === T.typeof_expr || t === T.void_expr ||
        t === T.delete_expr || t === T.prefix_inc || t === T.prefix_dec ||
        t === T.postfix_inc || t === T.postfix_dec || t === T.ts_non_null_expr) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    // spread/rest: [...a?.b] and {...a?.b} — undefined spread → TypeError
    if (t === T.spread_element || t === T.rest_element) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeViewChain(a, idx);
    }
    if (t === T.yield_expr || t === T.yield_delegate) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    if (t === T.return_stmt || t === T.throw_stmt) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeView(a, idx);
    }
    if (t === T.jsx_spread_attribute) {
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
    const t = this._tag;
    if (t === T.call_expr || t === T.optional_call_expr || t === T.new_expr) {
      const idx = this._ast.nodeLhs(this._i);
      // Use nodeViewChain so optional chain callees are wrapped in ChainExpression.
      // ESLint rules (no-unsafe-optional-chaining, no-prototype-builtins, etc.) use
      // astUtils.skipChainExpression(node.callee) to handle ChainExpression.
      return idx === NONE ? null : nodeViewChain(this._ast, idx);
    }
    return undefined;
  },

  /**
   * node.arguments — array of argument NodeViews.
   * CallExpression, NewExpression
   */
  get arguments() {
    const t = this._tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.call_expr || t === T.optional_call_expr) {
      const sub = ast.extraSubRange(rhs);
      // Use nodeViewChain for arguments that are optional chain nodes,
      // so ChainExpression wrappers are properly created.
      const result = [];
      const e = ast._extraData;
      for (let i = sub.start; i < sub.end; i++) {
        const idx = e[i];
        if (idx !== NONE) result.push(nodeViewChain(ast, idx));
      }
      return result;
    }
    if (t === T.new_expr) {
      if (rhs === NONE) return [];
      const sub = ast.extraSubRange(rhs);
      // Use nodeViewChain for arguments
      const result = [];
      const e = ast._extraData;
      for (let i = sub.start; i < sub.end; i++) {
        const idx = e[i];
        if (idx !== NONE) result.push(nodeViewChain(ast, idx));
      }
      return result;
    }
    return undefined;
  },

  /**
   * node.object — object being accessed.
   * MemberExpression (all variants)
   */
  get object() {
    const t = this._tag;
    if (t === T.member_expr || t === T.computed_member_expr ||
        t === T.optional_member_expr || t === T.optional_computed_member_expr ||
        t === T.with_stmt) {
      const idx = this._ast.nodeLhs(this._i);
      // Use nodeViewChain to expose ChainExpression for optional chain objects.
      return idx === NONE ? null : nodeViewChain(this._ast, idx);
    }
    return undefined;
  },

  /**
   * node.property — property being accessed.
   * Dot access: returns synthetic Identifier node (ESTree-compatible).
   * Computed access: returns NodeView of the expression.
   */
  get property() {
    const t = this._tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.member_expr || t === T.optional_member_expr) {
      // rhs is the token index of the property identifier; wrap as synthetic Identifier.
      // Cache so identity checks (parent.property === node) work in rules like id-blacklist.
      if (this._cachedProperty) return this._cachedProperty;
      const syn = ast._syntheticId(rhs);
      syn.parent = this;
      this._cachedProperty = syn;
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
    // MetaProperty: new.target → property = Identifier("target")
    if (t === T.new_target) return { type: 'Identifier', name: 'target' };
    if (t === T.import_meta) return { type: 'Identifier', name: 'meta' };
    return undefined;
  },

  /**
   * node.computed — true for computed member/property access.
   */
  get computed() {
    const t = this._tag;
    return t === T.computed_member_expr || t === T.optional_computed_member_expr ||
           t === T.computed_property || t === T.computed_method_def ||
           t === T.computed_property_def || t === T.computed_getter_def ||
           t === T.computed_setter_def;
  },

  /**
   * node.override — true for TS override methods/properties.
   * Detected by checking if 'override' keyword precedes the method name.
   */
  get readonly() {
    const t = this._tag;
    if (t !== T.property_def && t !== T.computed_property_def &&
        t !== T.method_def && t !== T.computed_method_def) return undefined;
    const mt = this.mainToken;
    const ast = this._ast;
    for (let i = mt - 1; i >= 0 && i >= mt - 5; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds ? ast._tokEnds[i] : ast._tokStarts[i + 1]);
      if (val === 'readonly') return true;
      if (val !== 'static' && val !== 'public' && val !== 'private' && val !== 'protected' &&
          val !== 'override' && val !== 'abstract' && val !== 'declare') break;
    }
    return false;
  },

  get override() {
    const t = this._tag;
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def) return undefined;
    const mt = this.mainToken;
    const ast = this._ast;
    // Scan backwards for 'override' keyword before the method name
    for (let i = mt - 1; i >= 0 && i >= mt - 4; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === 'override') return true;
      if (val !== 'static' && val !== 'async' && val !== 'get' && val !== 'set' && val !== '*' &&
          val !== 'public' && val !== 'private' && val !== 'protected' && val !== 'readonly' &&
          val !== 'abstract' && val !== 'declare') break;
    }
    return false;
  },

  /**
   * node.accessibility — TS access modifier ('public'|'private'|'protected').
   */
  get accessibility() {
    const t = this._tag;
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def) return undefined;
    const mt = this.mainToken;
    const ast = this._ast;
    for (let i = mt - 1; i >= 0 && i >= mt - 4; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === 'public' || val === 'private' || val === 'protected') return val;
      if (val !== 'static' && val !== 'async' && val !== 'override' && val !== 'readonly' &&
          val !== 'abstract' && val !== 'declare' && val !== '*') break;
    }
    return null;
  },

  /**
   * node.decorators — TS/proposal decorators array.
   * Detected by scanning backward from the method/property for @ tokens.
   */
  get decorators() {
    const t = this._tag;
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def &&
        t !== T.class_decl && t !== T.class_expr) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    // Scan backward for @ tokens
    const decorators = [];
    for (let i = mt - 1; i >= 0; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === '@') {
        decorators.push({ type: 'Decorator', start: ast._tokStarts[i], end: ast._tokEnds[i + 1] || ast._tokEnds[i] });
      } else if (val === ')') {
        // Skip decorator arguments: @dec(args)
        let depth = 1;
        i--;
        while (i >= 0 && depth > 0) {
          const c = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
          if (c === ')') depth++;
          else if (c === '(') depth--;
          i--;
        }
        // i now points before '(' — next iteration checks for @
      } else if (val === 'static' || val === 'async' || val === 'get' || val === 'set' || val === '*' ||
                 val === 'public' || val === 'private' || val === 'protected' || val === 'readonly' ||
                 val === 'abstract' || val === 'declare' || val === 'override') {
        continue; // skip modifiers between decorator and method name
      } else {
        break; // not a decorator or modifier
      }
    }
    return decorators.length > 0 ? decorators : undefined;
  },

  /**
   * node.optional — true for optional chaining.
   */
  get optional() {
    const t = this._tag;
    return t === T.optional_member_expr || t === T.optional_computed_member_expr ||
           t === T.optional_call_expr;
  },

  /**
   * node.prefix — true for prefix update expressions (++x, --x).
   */
  get prefix() {
    const t = this._tag;
    if (t === T.prefix_inc || t === T.prefix_dec) return true;
    if (t === T.postfix_inc || t === T.postfix_dec) return false;
    // All UnaryExpression operators (void, typeof, delete, !, -, +, ~) are prefix
    if (t === T.typeof_expr || t === T.void_expr || t === T.delete_expr ||
        t === T.logical_not || t === T.bitwise_not || t === T.unary_minus || t === T.unary_plus) return true;
    return null;
  },

  /**
   * node.delegate — true for yield* expressions.
   */
  get delegate() {
    return this._tag === T.yield_delegate;
  },

  /**
   * node.tail — true if this TemplateElement is the last in its TemplateLiteral.
   */
  get tail() {
    if (this._tag !== T.template_element) return undefined;
    // Check if next sibling in parent's child list is also a TemplateElement or we're at the end.
    const ast = this._ast;
    const parent = this.parent;
    if (!parent || parent.tag !== T.template_literal) return true;
    const rhs = ast.nodeRhs(parent._i);
    const extra = ast._extraData;
    // Last child in the range is the tail quasi.
    return extra[rhs - 1] === this._i;
  },

  /**
   * node.async — true for async functions and for-await-of.
   */
  get async() {
    const t = this._tag;
    return t === T.async_fn_decl || t === T.async_fn_expr ||
           t === T.async_generator_fn_decl || t === T.async_generator_fn_expr ||
           t === T.async_arrow_fn || t === T.for_await_of_stmt;
  },

  /**
   * node.generator — true for generator functions.
   */
  get generator() {
    const t = this._tag;
    return t === T.generator_fn_decl || t === T.generator_fn_expr ||
           t === T.async_generator_fn_decl || t === T.async_generator_fn_expr;
  },

  /**
   * node.static — true for static class members (MethodDefinition, PropertyDefinition).
   * Returns undefined for non-member nodes.
   */
  get static() {
    const t = this._tag;
    if (t !== T.method_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.constructor_def && t !== T.computed_method_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def &&
        t !== T.property_def && t !== T.computed_property_def) return undefined;
    return _methodFlags(this._ast, this.mainToken).static;
  },

  /**
   * node.id — name identifier of function/class declaration, or VariableDeclarator pattern.
   */
  get id() {
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.params — parameter list of function/arrow.
   * Returns array of NodeViews.
   */
  get params() {
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.declarations — list of VariableDeclarator nodes.
   */
  get declarations() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.var_decl || t === T.let_decl || t === T.const_decl) {
      // lhs=range.start, rhs=range.end (stored directly)
      return ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
    }
    return undefined;
  },

  /**
   * node.kind — "var" / "let" / "const" for VariableDeclaration;
   *             "init" / "get" / "set" for Property/MethodDefinition.
   */
  get kind() {
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.typeAnnotation — TS type annotation on identifiers, params, etc.
   */
  get typeAnnotation() {
    const ast = this._ast;
    const pd = ast._parentData;
    if (!pd) return undefined;
    // Find a TSTypeAnnotation child of this node
    const myIdx = this._i;
    for (let c = myIdx + 1; c < ast.nodeCount; c++) {
      if (pd[c] !== myIdx) continue;
      if (ast._nodeTags[c] === T.ts_type_annotation) return nodeView(ast, c);
      // Only check direct children (not grandchildren)
    }
    return undefined;
  },

  /**
   * node.declare — true for TS `declare` declarations.
   */
  get declare() {
    const t = this._tag;
    if (t !== T.var_decl && t !== T.let_decl && t !== T.const_decl &&
        t !== T.fn_decl && t !== T.async_fn_decl && t !== T.class_decl &&
        t !== T.property_def && t !== T.computed_property_def) return undefined;
    const mt = this.mainToken;
    const ast = this._ast;
    for (let i = mt - 1; i >= 0 && i >= mt - 5; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds ? ast._tokEnds[i] : ast._tokStarts[i + 1]);
      if (val === 'declare') return true;
      if (val !== 'static' && val !== 'readonly' && val !== 'public' && val !== 'private' &&
          val !== 'protected' && val !== 'override' && val !== 'abstract' && val !== 'export') break;
    }
    return false;
  },

  /**
   * node.importKind — 'type' for `import type`, 'value' otherwise.
   */
  get importKind() {
    const t = this._tag;
    if (t !== T.import_decl && t !== T.import_specifier) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    // For ImportDeclaration: check if token after 'import' is 'type'
    if (t === T.import_decl) {
      if (mt + 1 < ast.tokenCount) {
        const next = ast.source.slice(ast._tokStarts[mt + 1], ast._tokEnds[mt + 1]);
        if (next === 'type') return 'type';
      }
      return 'value';
    }
    // For ImportSpecifier: check if token before name is 'type'
    if (mt > 0) {
      const prev = ast.source.slice(ast._tokStarts[mt - 1], ast._tokEnds[mt - 1]);
      if (prev === 'type') return 'type';
    }
    return 'value';
  },

  /**
   * node.exportKind — 'type' for `export type`, 'value' otherwise.
   */
  get exportKind() {
    const t = this._tag;
    if (t !== T.export_named && t !== T.export_all && t !== T.export_specifier) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    if (t === T.export_named || t === T.export_all) {
      if (mt + 1 < ast.tokenCount) {
        const next = ast.source.slice(ast._tokStarts[mt + 1], ast._tokEnds[mt + 1]);
        if (next === 'type') return 'type';
      }
      return 'value';
    }
    return 'value';
  },

  /**
   * node.init — initializer in VariableDeclarator or ForStatement.
   */
  get init() {
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    if (t === T.declarator) {
      // Use nodeViewChain: `const {x} = obj?.foo` — init may be optional chain.
      return rhs === NONE ? null : nodeViewChain(ast, rhs);
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
    if (this._tag !== T.for_stmt) return null;
    const ast = this._ast;
    const d = ast.extraForData(ast.nodeLhs(this._i));
    return d.update === NONE ? null : nodeView(ast, d.update);
  },

  /**
   * node.superClass — parent class in ClassDeclaration/Expression.
   */
  get superClass() {
    const t = this._tag;
    if (t !== T.class_decl && t !== T.class_expr) return null;
    const ast = this._ast;
    const d = ast.extraClassData(ast.nodeLhs(this._i));
    // Use nodeViewChain: `class A extends obj?.foo {}` — superClass may be optional chain.
    return d.super_class === NONE ? null : nodeViewChain(ast, d.super_class);
  },

  /**
   * node.implements — TS implements clause. Returns array of type references
   * or empty array. Detected via token scanning for 'implements' keyword.
   */
  get implements() {
    const t = this._tag;
    if (t !== T.class_decl && t !== T.class_expr) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    // Scan forward from class keyword to opening brace looking for 'implements'
    for (let i = mt + 1; i < ast.tokenCount; i++) {
      const tag = ast._tokTags[i];
      if (tag === 74) break; // '{' — opening brace
      const start = ast._tokStarts[i];
      const end = ast._tokEnds ? ast._tokEnds[i] : ast._tokStarts[i + 1];
      if (ast.source.slice(start, end) === 'implements') {
        // Return non-empty array to indicate implements exists
        // (rules just check .implements?.length > 0)
        return [{ type: 'TSClassImplements' }];
      }
    }
    return [];
  },

  /**
   * node.elements — elements of ArrayExpression or ArrayPattern.
   * Holes are represented as null (matching ESLint's AST).
   */
  get elements() {
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.expressions — SequenceExpression children or TemplateLiteral interpolations.
   */
  get expressions() {
    const t = this._tag;
    if (t === T.sequence_expr) {
      // Use nodeViewChain: (foo, obj?.bar)() — last element may be optional chain.
      const ast = this._ast;
      const lhs = ast.nodeLhs(this._i), rhs = ast.nodeRhs(this._i);
      const result = [];
      for (let i = lhs; i < rhs; i++) {
        const idx = ast._extraData[i];
        if (idx !== NONE) result.push(nodeViewChain(ast, idx));
      }
      return result;
    }
    if (t === T.template_literal) {
      // Children are interleaved: quasi, expr, quasi, expr, quasi
      const ast = this._ast;
      const lhs = ast.nodeLhs(this._i), rhs = ast.nodeRhs(this._i);
      const result = [];
      const extra = ast._extraData;
      for (let i = lhs; i < rhs; i++) {
        const idx = extra[i];
        if (idx !== NONE && ast._nodeTags[idx] !== T.template_element) {
          result.push(nodeView(ast, idx));
        }
      }
      return result;
    }
    return undefined;
  },

  /**
   * node.quasis — TemplateElement nodes in a TemplateLiteral.
   */
  get quasis() {
    if (this._tag !== T.template_literal) return undefined;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i), rhs = ast.nodeRhs(this._i);
    const result = [];
    const extra = ast._extraData;
    for (let i = lhs; i < rhs; i++) {
      const idx = extra[i];
      if (idx !== NONE && ast._nodeTags[idx] === T.template_element) {
        result.push(nodeView(ast, idx));
      }
    }
    return result;
  },

  /**
   * node.quasi — the TemplateLiteral in a TaggedTemplateExpression.
   */
  get quasi() {
    if (this._tag !== T.tagged_template) return undefined;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? null : nodeView(this._ast, rhs);
  },

  /**
   * node.properties — properties of ObjectExpression or ObjectPattern.
   */
  get properties() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.object_literal || t === T.object_pattern) {
      const nodes = ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
      if (t !== T.object_pattern) return nodes;
      // ObjectPattern: wrap bare AssignmentPattern/Identifier/RestElement in
      // synthetic Property nodes — ESTree requires Property wrappers in patterns.
      return nodes.map(n => {
        if (n.type === 'Property') return n;
        if (n.type === 'RestElement' || n.type === 'SpreadElement') return n;
        // Shorthand destructuring default: {a=1} → Property { key: a, value: AssignmentPattern }
        if (n.type === 'AssignmentPattern') {
          const key = n.left || n;
          return { type: 'Property', key, value: n, kind: 'init', method: false,
                   shorthand: true, computed: false, start: n.start, end: n.end, range: n.range, loc: n.loc, parent: this };
        }
        // Shorthand: {a} → Property { key: a, value: a }
        if (n.type === 'Identifier') {
          return { type: 'Property', key: n, value: n, kind: 'init', method: false,
                   shorthand: true, computed: false, start: n.start, end: n.end, range: n.range, loc: n.loc, parent: this };
        }
        return n;
      });
    }
    return undefined;
  },

  /**
   * node.key — key of Property or MethodDefinition.
   */
  get key() {
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (t === T.property || t === T.shorthand_property ||
        t === T.property_def || t === T.method_def ||
        t === T.getter_def || t === T.setter_def || t === T.constructor_def) {
      if (lhs === NONE) return null;
      const child = nodeView(ast, lhs);
      // For shorthand destructuring with default: { x = 1 } → key should be
      // the Identifier, not the AssignmentPattern
      if (t === T.shorthand_property && child.type === 'AssignmentPattern') {
        return child.left;
      }
      return child;
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
    return this._tag === T.shorthand_property;
  },

  /**
   * node.method — true for method shorthand Property.
   */
  get method() {
    return this._tag === T.method_def || this._tag === T.computed_method_def;
  },

  /**
   * node.discriminant — switch expression.
   */
  get discriminant() {
    if (this._tag !== T.switch_stmt) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.cases — array of SwitchCase NodeViews.
   */
  get cases() {
    if (this._tag !== T.switch_stmt) return null;
    const ast = this._ast;
    const sub = ast.extraSubRange(ast.nodeRhs(this._i));
    return ast._nodesFromRange(sub.start, sub.end);
  },

  /**
   * node.label — label identifier.
   * LabeledStatement, BreakStatement (with label), ContinueStatement (with label)
   */
  get label() {
    if (this._label !== undefined) return this._label;
    const t = this._tag;
    const ast = this._ast;
    let tokIdx = null;
    if (t === T.labeled_stmt) {
      tokIdx = this.mainToken;
    } else if (t === T.break_label || t === T.continue_label) {
      const tokAbsIdx = ast.nodeLhs(this._i);
      if (tokAbsIdx === NONE) { this._label = null; return null; }
      tokIdx = tokAbsIdx; // nodeLhs stores absolute token index for break/continue label
    }
    if (tokIdx === null) { this._label = null; return null; }
    // Return an Identifier-like object with name, range, loc, type.
    const name = ast._identAt(tokIdx);
    const start = ast._tokStarts[tokIdx];
    const end = start + name.length;
    const ls = ast._lineStarts();
    let lo = 0, hi = ls.length - 1;
    while (lo < hi) { const m = (lo + hi + 1) >> 1; if (ls[m] <= start) lo = m; else hi = m - 1; }
    let elo = 0, ehi = ls.length - 1;
    while (elo < ehi) { const m = (elo + ehi + 1) >> 1; if (ls[m] <= end) elo = m; else ehi = m - 1; }
    this._label = {
      type: 'Identifier', name, start, end,
      range: [start, end],
      loc: { start: { line: lo + 1, column: start - ls[lo] }, end: { line: elo + 1, column: end - ls[elo] } },
      parent: this,
    };
    return this._label;
  },

  /**
   * node.block — try block.
   */
  get block() {
    if (this._tag !== T.try_stmt) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.handler — the CatchClause node (tag 23, real NodeView).
   * Returns a proper cached NodeView so ESLint identity checks (parent.handler === node) work.
   */
  get handler() {
    if (this._tag !== T.try_stmt) return null;
    const ast = this._ast;
    const d = ast.extraTryData(ast.nodeRhs(this._i));
    return d.catch_node === NONE ? null : nodeView(ast, d.catch_node);
  },

  /**
   * node.finalizer — finally block.
   */
  get finalizer() {
    if (this._tag !== T.try_stmt) return null;
    const ast = this._ast;
    const d = ast.extraTryData(ast.nodeRhs(this._i));
    return d.finally_body === NONE ? null : nodeView(ast, d.finally_body);
  },

  /**
   * node.param — catch clause parameter.
   */
  get param() {
    if (this._tag !== T.catch_clause) return null;
    const idx = this._ast.nodeLhs(this._i);
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /**
   * node.meta — MetaProperty meta identifier (e.g., "new" in new.target).
   */
  get meta() {
    const t = this._tag;
    if (t === T.new_target) return { type: 'Identifier', name: 'new' };
    if (t === T.import_meta) return { type: 'Identifier', name: 'import' };
    return undefined;
  },

  /**
   * node.expression — ExpressionStatement inner expression.
   * Also used for arrow function concise body detection (see getter above).
   */
  get expression() {
    const t = this._tag;
    if (t === T.expression_stmt) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const ast = this._ast;
      const d = ast.extraArrowData(ast.nodeLhs(this._i));
      return d.body !== NONE && ast._nodeTags[d.body] !== T.block_stmt;
    }
    if (t === T.jsx_expression_container) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    return null;
  },

  /**
   * node.directive — for ExpressionStatement nodes that are directives
   * (e.g., "use strict"). Returns the directive string value, or undefined.
   * ESLint's astUtils.isDirective checks typeof node.directive === "string".
   */
  get directive() {
    if (this._tag !== T.expression_stmt) return undefined;
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
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.source — import/export source literal node (Literal with value/raw).
   * Returns a synthetic Literal node so rules can access .range, .loc, etc.
   */
  get source() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.import_decl) {
      if (this._cachedSource) return this._cachedSource;
      const d = ast.extraImportData(ast.nodeLhs(this._i));
      if (d.source === NONE) return null;
      const lit = ast._syntheticLiteral(d.source);
      lit.parent = this;
      this._cachedSource = lit;
      return lit;
    }
    if (t === T.export_all) {
      if (this._cachedSource) return this._cachedSource;
      const tokIdx = ast.nodeLhs(this._i);
      if (tokIdx === NONE) return null;
      const lit = ast._syntheticLiteral(tokIdx);
      lit.parent = this;
      this._cachedSource = lit;
      return lit;
    }
    // ImportExpression (dynamic import): source = the argument expression
    if (t === T.import_expr) {
      const argIdx = ast.nodeLhs(this._i);
      if (argIdx === NONE) return null;
      return nodeView(ast, argIdx);
    }
    return undefined;
  },

  /**
   * node.local — local binding in import/export specifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get local() {
    if (this._cachedLocal) return this._cachedLocal;
    const t = this._tag;
    const ast = this._ast;
    let tokIdx;
    if (t === T.import_specifier) {
      tokIdx = ast.nodeRhs(this._i);
    } else if (t === T.import_default_specifier || t === T.import_namespace_specifier) {
      tokIdx = ast.nodeLhs(this._i);
    } else if (t === T.export_specifier) {
      tokIdx = ast.nodeLhs(this._i);
    } else {
      return undefined;
    }
    const syn = ast._tokTags[tokIdx] === 2 ? ast._syntheticLiteral(tokIdx) : ast._syntheticId(tokIdx);
    syn.parent = this;
    this._cachedLocal = syn;
    return syn;
  },

  /**
   * node.imported — imported name in ImportSpecifier.
   * Returns a synthetic Identifier or Literal (for string module names). Cached.
   */
  get imported() {
    if (this._tag !== T.import_specifier) return null;
    if (this._cachedImported) return this._cachedImported;
    const ast = this._ast;
    const tokIdx = ast.nodeLhs(this._i);
    const syn = ast._tokTags[tokIdx] === 2 ? ast._syntheticLiteral(tokIdx) : ast._syntheticId(tokIdx);
    syn.parent = this;
    this._cachedImported = syn;
    return syn;
  },

  /**
   * node.exported — exported name in ExportSpecifier.
   * Returns a synthetic Identifier or Literal (for string module names). Cached.
   */
  get exported() {
    if (this._tag !== T.export_specifier) return null;
    if (this._cachedExported) return this._cachedExported;
    const ast = this._ast;
    const tokIdx = ast.nodeRhs(this._i);
    const syn = ast._tokTags[tokIdx] === 2 ? ast._syntheticLiteral(tokIdx) : ast._syntheticId(tokIdx);
    syn.parent = this;
    this._cachedExported = syn;
    return syn;
  },

  /**
   * node.declaration — ExportDefaultDeclaration / ExportNamedDeclaration inner declaration.
   */
  get declaration() {
    const t = this._tag;
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
    return undefined;
  },

  /**
   * node.range — [start, end] UTF-16 offsets.
   * end is the position after the last character of the last token in the subtree.
   */
  get range() {
    if (this._range !== null) return this._range;
    if (this._ast._nodeTags[this._i] === T.root) {
      this._range = [0, this._ast.sourceUtf16Len];
    } else {
      let end = this._ast._nodeEndPos(this._i);
      const tag = this._ast._nodeTags[this._i];

      // For statement nodes, check if a semicolon token follows and extend the range to include it.
      // Parser computes end positions based on child nodes, which excludes trailing semicolons.
      // This workaround extends statement ranges to include the semicolon for ESLint rule compatibility.
      if (_isStatementTag(tag)) {
        end = _extendRangeToIncludeSemicolon(this._ast, end);
      }

      this._range = [this.start, end];
    }
    return this._range;
  },

  /**
   * node.loc — { start: { line, column }, end: { line, column } }
   * Line is 1-indexed; column is 0-indexed.
   */
  get loc() {
    if (this._loc !== null) return this._loc;
    const ast = this._ast;
    let end = ast._nodeEndPos(this._i);

    // For statement nodes, extend end position to include trailing semicolons (see `range` getter)
    const tag = ast._nodeTags[this._i];
    if (_isStatementTag(tag)) {
      end = _extendRangeToIncludeSemicolon(ast, end);
    }

    const ls = ast._lineStarts();
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
    this._loc = {
      start: { line: startLine, column: startCol },
      end: { line: elo + 1, column: end - ls[elo] },
    };
    return this._loc;
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
    const tokEnds = ast._tokEnds;
    const count = ast.tokenCount;
    const ls = ast._lineStarts();
    const result = [];
    for (let i = 0; i < count; i++) {
      const tag = tags[i];
      if (tag === 131) continue; // skip EOF
      const start = starts[i];
      let end = tokEnds ? tokEnds[i] : undefined;
      if (end === undefined) {
        end = i + 1 < count ? starts[i + 1] : src.length;
        while (end > start && src.charCodeAt(end - 1) <= 32) end--;
      }
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
   * Uses the runtime-provided sourceType if set (via _runtimeSourceType),
   * otherwise reads from the Zig buffer header's source_type field.
   */
  get sourceType() {
    if (this._ast._nodeTags[this._i] === T.root) {
      if (this._ast._runtimeSourceType !== undefined) return this._ast._runtimeSourceType;
      return this._ast._sourceType === 1 ? 'module' : 'script';
    }
    return undefined;
  },

  /** node.comments — empty array (ez doesn't track comments yet). Writable so rules can set it. */
  get comments() {
    return this._comments || _emptyArray;
  },
  set comments(v) {
    this._comments = v;
  },

  // ── JSX getters ─────────────────────────────────────────────

  /** JSXElement.openingElement (jsx_element → opening child, jsx_self_closing → self) */
  get openingElement() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.jsx_element) {
      const d = ast.extraJsxElementData(ast.nodeLhs(this._i));
      return d.opening !== NONE ? nodeView(ast, d.opening) : null;
    }
    // Self-closing: the element IS its own opening element
    if (t === T.jsx_self_closing) return this;
    return undefined;
  },

  /** JSXElement.closingElement */
  get closingElement() {
    const t = this._tag;
    if (t === T.jsx_element) {
      const ast = this._ast;
      const d = ast.extraJsxElementData(ast.nodeLhs(this._i));
      return d.closing !== NONE ? nodeView(ast, d.closing) : null;
    }
    if (t === T.jsx_self_closing) return null;
    return undefined;
  },

  /** JSXElement.children / JSXFragment.children */
  get children() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.jsx_element) {
      const d = ast.extraJsxElementData(ast.nodeLhs(this._i));
      return ast._nodesFromRange(d.children_start, d.children_end);
    }
    if (t === T.jsx_self_closing) return []; // self-closing has no children
    if (t === T.jsx_fragment) {
      const lhs = ast.nodeLhs(this._i);
      const rhs = ast.nodeRhs(this._i);
      return ast._nodesFromRange(lhs, rhs);
    }
    return undefined;
  },

  /** JSXOpeningElement.attributes / JSXElement(self-closing).attributes */
  get attributes() {
    const t = this._tag;
    if (t !== T.jsx_opening_element && t !== T.jsx_self_closing) return undefined;
    const ast = this._ast;
    const d = ast.extraJsxOpeningData(ast.nodeLhs(this._i));
    return ast._nodesFromRange(d.attrs_start, d.attrs_end);
  },

  /** JSXOpeningElement.selfClosing */
  get selfClosing() {
    if (this._tag === T.jsx_self_closing) return true;
    if (this._tag === T.jsx_opening_element) return false;
    return undefined;
  },

};


/**
 * Return a stable NodeView for the given (ast, index) pair.
 * Uses a per-AstView cache to guarantee reference equality:
 *   nodeView(ast, i) === nodeView(ast, i)  // always true
 * This is required for ESLint rules that use `===` for node identity.
 *
 * Automatically unwraps grouping_expr (ParenthesizedExpression) since
 * ESTree-compliant parsers don't emit separate nodes for parentheses.
 */
// ── ChainExpression synthesis ────────────────────────────────────
// ESTree wraps the outermost node of an optional chain in a ChainExpression.
// e.g. `a?.b` → ChainExpression { expression: MemberExpression(optional=true) }
//      `a?.b.c` → ChainExpression { expression: MemberExpression { object: ME(opt=true), optional=false } }
//      `(a?.b)()` → CallExpression { callee: ChainExpression { expression: ME(opt=true) } }
// ESLint rules (no-unsafe-optional-chaining) rely on ChainExpression to detect
// optional chain results used in mandatory contexts.

/** Tags that are "optional chain nodes" — always start a chain. */
function _isOptionalTag(tag) {
  return tag === T.optional_member_expr || tag === T.optional_computed_member_expr ||
         tag === T.optional_call_expr;
}

/** Tags that can be chain "middles" — non-optional member/call on top of an optional chain. */
function _isChainMiddleTag(tag) {
  return tag === T.member_expr || tag === T.computed_member_expr || tag === T.call_expr;
}

/**
 * Return true if node `idx` is the LHS (object/callee) of a chain-continuation parent.
 * If so, idx is not the outermost of its chain, so we should NOT wrap it in ChainExpression.
 */
function _isChainChild(ast, idx) {
  const pd = ast._parentData;
  if (!pd) return false;
  let parentIdx = pd[idx];
  // Skip grouping_expr parents (they're transparent)
  while (parentIdx !== NONE && ast._nodeTags[parentIdx] === T.grouping_expr) {
    parentIdx = pd[parentIdx];
  }
  if (parentIdx === NONE) return false;
  const pt = ast._nodeTags[parentIdx];
  if (!(_isOptionalTag(pt) || _isChainMiddleTag(pt))) return false;
  // Must be the LHS (object/callee), not the RHS (property/argument)
  return ast.nodeLhs(parentIdx) === idx;
}

/**
 * Return true if node `idx` belongs to an optional chain (i.e., is optional itself,
 * or is a non-optional member/call whose lhs transitively leads to an optional chain node).
 */
function _isChainNode(ast, idx) {
  // Iterative traversal to avoid call stack depth issues on deep chains.
  let cur = idx;
  while (cur !== NONE) {
    const tag = ast._nodeTags[cur];
    if (_isOptionalTag(tag)) return true;
    if (!_isChainMiddleTag(tag)) return false;
    // Walk the lhs, unwrapping grouping_expr
    let lhsIdx = ast.nodeLhs(cur);
    while (lhsIdx !== NONE && ast._nodeTags[lhsIdx] === T.grouping_expr) {
      lhsIdx = ast.nodeLhs(lhsIdx);
    }
    cur = lhsIdx;
  }
  return false;
}

/** Build (and cache) a synthetic ChainExpression wrapper for node `idx`. */
function _getChainExpr(ast, idx) {
  if (!ast._chainCache) ast._chainCache = new Array(ast.nodeCount);
  let c = ast._chainCache[idx];
  if (c) return c;
  const inner = _nodeViewRaw(ast, idx); // get the NodeProto without chain wrapping
  c = Object.create(null);
  c.type = 'ChainExpression';
  c.expression = inner;
  c._i = idx;           // identity: same as inner node
  c._isChainExpr = true;
  c.mainToken = ast._mainTokens[idx]; // needed for getTokenBefore/After
  Object.defineProperty(c, 'start',  { get: () => inner.start,  configurable: true });
  Object.defineProperty(c, 'end',    { get: () => inner.end,    configurable: true });
  Object.defineProperty(c, 'range',  { get: () => inner.range,  configurable: true });
  Object.defineProperty(c, 'loc',    { get: () => inner.loc,    configurable: true });
  Object.defineProperty(c, 'parent', {
    get: () => c._realParent !== undefined ? c._realParent : inner.parent,
    set: (v) => { c._realParent = v; },
    configurable: true
  });
  ast._chainCache[idx] = c;
  return c;
}

/** Raw nodeView — returns the NodeProto directly, no ChainExpression wrapping. */
function _nodeViewRaw(ast, index) {
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
    n._parent = _PARENT_UNSET;
    n._type = null;
    n._loc  = null;
    n._range = null;
    n._body = _BODY_UNSET;
    n._value = _VALUE_UNSET;
    // Make regex/bigint own properties so Object.hasOwn() works (ESLint uses this)
    const tag = ast._nodeTags[index];
    if (tag === T.regex_literal) {
      const _n = n;
      const _regexGetter = Object.getOwnPropertyDescriptor(NodeProto, 'regex').get;
      Object.defineProperty(n, 'regex', {
        get() { return _regexGetter.call(_n); },
        configurable: true, enumerable: true,
      });
    } else if (tag === T.bigint_literal) {
      const _n = n;
      const _bigintGetter = Object.getOwnPropertyDescriptor(NodeProto, 'bigint').get;
      Object.defineProperty(n, 'bigint', {
        get() { return _bigintGetter.call(_n); },
        configurable: true, enumerable: true,
      });
    }
    cache[index] = n;
  }
  return n;
}

function nodeView(ast, index) {
  // Unwrap grouping_expr transparently (ESTree doesn't have ParenthesizedExpression)
  while (index !== NONE && ast._nodeTags[index] === T.grouping_expr) {
    index = ast.nodeLhs(index);
  }
  if (index === NONE) return null;
  return _nodeViewRaw(ast, index);
}

/**
 * nodeViewChain — like nodeView, but wraps the result in a ChainExpression when the
 * node is the outermost of an optional chain. Used by getters (callee, object, tag, etc.)
 * that need to expose ChainExpression to rules like no-unsafe-optional-chaining.
 *
 * In ESTree, a ChainExpression wraps the outermost node of `?.` chains:
 *   `a?.b`     → ChainExpression { expression: MemberExpression(optional=true) }
 *   `a?.b.c`   → ChainExpression { expression: MemberExpression { object: ME(opt), optional=false } }
 *   `(a?.b)()` → CallExpression { callee: ChainExpression { expression: ME(optional=true) } }
 *
 * By calling nodeViewChain in callee/object/tag/argument getters, the chain wrapper is
 * only added when the optional chain is the TOP-LEVEL value in a mandatory context.
 * The node dispatched to visitors via DFS remains unwrapped (they use _nodeViewRaw).
 */
function nodeViewChain(ast, index) {
  // Unwrap grouping_expr
  while (index !== NONE && ast._nodeTags[index] === T.grouping_expr) {
    index = ast.nodeLhs(index);
  }
  if (index === NONE) return null;
  // Wrap in ChainExpression if this is the outermost optional chain node.
  // A node is NOT outermost if its parent (skipping grouping) uses it as object/callee.
  if (_isChainNode(ast, index) && !_isChainChild(ast, index)) {
    return _getChainExpr(ast, index);
  }
  return _nodeViewRaw(ast, index);
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
function _methodFlags(ast, mainToken) {
  let isAsync = false, isGenerator = false, isStatic = false;
  // Check the main token and scan backwards for modifier keywords.
  // Layout: [static] [async] [*] name (...)
  // mainToken may be: *, async, static, get, set, or the method name identifier.
  const mainTag = ast._tokTags[mainToken];
  if (mainTag === TOK_STAR) isGenerator = true;
  if (mainTag === TOK_ASYNC) isAsync = true;
  if (mainTag === TOK_STATIC) isStatic = true;
  // For async generators: mainToken=async, * is the next token
  if (mainTag === TOK_ASYNC && mainToken + 1 < ast.tokenCount && ast._tokTags[mainToken + 1] === TOK_STAR) {
    isGenerator = true;
  }
  let i = mainToken - 1;
  while (i >= 0) {
    const tag = ast._tokTags[i];
    if (tag === TOK_STAR)   { isGenerator = true; i--; continue; }
    if (tag === TOK_ASYNC)  { isAsync = true;     i--; continue; }
    if (tag === TOK_STATIC) { isStatic = true;    i--; continue; }
    if (tag >= 9 && tag <= 71) { i--; continue; }
    break;
  }
  return { async: isAsync, generator: isGenerator, static: isStatic };
}

/**
 * Reset all node cache references.
 * MUST be called between files to prevent source text retention.
 */
function reset() {
  // Caches are per-AstView; no global state to clear.
}

/**
 * Given a raw tag name (from the tagNames array) and the node index, return
 * the effective ESTree type name — remapping TSTypeReference to TS*Keyword
 * when the node is actually a TypeScript built-in keyword type.
 *
 * Used by walkNodes in eslint-runner.js so visitor dispatch uses the same
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

// ── Full Code Path Graph (reads precomputed data from buffer) ────

// CfgGraphHeader field offsets
const CGH = {
  SEGMENT_COUNT: 0,
  CODEPATH_COUNT: 4,
  EVENT_COUNT: 8,
  SEG_REACHABLE: 12,
  SEG_CODEPATH: 16,
  SEG_NEXT_STARTS: 20,
  SEG_NEXT_TARGETS: 24,
  SEG_PREV_STARTS: 28,
  SEG_PREV_TARGETS: 32,
  SEG_ALL_NEXT_STARTS: 36,
  SEG_ALL_NEXT_TARGETS: 40,
  SEG_ALL_PREV_STARTS: 44,
  SEG_ALL_PREV_TARGETS: 48,
  SEG_LOOPED_STARTS: 52,
  SEG_LOOPED_TARGETS: 56,
  CP_ORIGIN: 60,
  CP_UPPER: 64,
  CP_INITIAL_SEG: 68,
  CP_FINAL_STARTS: 72,
  CP_FINAL_TARGETS: 76,
  CP_RETURNED_STARTS: 80,
  CP_RETURNED_TARGETS: 84,
  CP_THROWN_STARTS: 88,
  CP_THROWN_TARGETS: 92,
  EVENTS: 96,
};

const CP_ORIGINS = ['program', 'function', 'class-field-initializer', 'class-static-block'];
const NONE32 = 0xFFFFFFFF;

class CfgGraph {
  constructor(buffer, dv, off) {
    this._buffer = buffer;
    this._segCount = dv.getUint32(off + CGH.SEGMENT_COUNT, true);
    this._cpCount = dv.getUint32(off + CGH.CODEPATH_COUNT, true);
    this._evCount = dv.getUint32(off + CGH.EVENT_COUNT, true);

    if (this._segCount === 0 && this._cpCount === 0) {
      this._segReachable = null;
      return;
    }

    // Per-segment
    this._segReachable = new Uint8Array(buffer, dv.getUint32(off + CGH.SEG_REACHABLE, true), this._segCount);
    this._segCp = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_CODEPATH, true), this._segCount);

    // Adjacency CSR — targets need explicit length from starts[N]
    const sc1 = this._segCount + 1;
    this._nextStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_NEXT_STARTS, true), sc1);
    const ntOff = dv.getUint32(off + CGH.SEG_NEXT_TARGETS, true);
    const ntLen = this._nextStarts[this._segCount];
    this._nextTargets = ntOff > 0 && ntLen > 0 ? new Uint32Array(buffer, ntOff, ntLen) : null;

    this._prevStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_PREV_STARTS, true), sc1);
    const ptOff = dv.getUint32(off + CGH.SEG_PREV_TARGETS, true);
    const ptLen = this._prevStarts[this._segCount];
    this._prevTargets = ptOff > 0 && ptLen > 0 ? new Uint32Array(buffer, ptOff, ptLen) : null;

    this._allNextStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_ALL_NEXT_STARTS, true), sc1);
    const antOff = dv.getUint32(off + CGH.SEG_ALL_NEXT_TARGETS, true);
    const antLen = this._allNextStarts[this._segCount];
    this._allNextTargets = antOff > 0 && antLen > 0 ? new Uint32Array(buffer, antOff, antLen) : null;

    this._allPrevStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_ALL_PREV_STARTS, true), sc1);
    const aptOff = dv.getUint32(off + CGH.SEG_ALL_PREV_TARGETS, true);
    const aptLen = this._allPrevStarts[this._segCount];
    this._allPrevTargets = aptOff > 0 && aptLen > 0 ? new Uint32Array(buffer, aptOff, aptLen) : null;

    this._loopedStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_LOOPED_STARTS, true), sc1);
    const ltOff = dv.getUint32(off + CGH.SEG_LOOPED_TARGETS, true);
    const ltLen = this._loopedStarts[this._segCount];
    this._loopedTargets = ltOff > 0 && ltLen > 0 ? new Uint32Array(buffer, ltOff, ltLen) : null;

    // Per-codepath
    this._cpOrigin = new Uint8Array(buffer, dv.getUint32(off + CGH.CP_ORIGIN, true), this._cpCount);
    this._cpUpper = new Uint32Array(buffer, dv.getUint32(off + CGH.CP_UPPER, true), this._cpCount);
    this._cpInitialSeg = new Uint32Array(buffer, dv.getUint32(off + CGH.CP_INITIAL_SEG, true), this._cpCount);
    const cc1 = this._cpCount + 1;
    this._cpFinalStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.CP_FINAL_STARTS, true), cc1);
    const cfOff = dv.getUint32(off + CGH.CP_FINAL_TARGETS, true);
    const cfLen = this._cpFinalStarts[this._cpCount];
    this._cpFinalTargets = cfOff > 0 && cfLen > 0 ? new Uint32Array(buffer, cfOff, cfLen) : null;
    this._cpReturnedStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.CP_RETURNED_STARTS, true), cc1);
    const crOff = dv.getUint32(off + CGH.CP_RETURNED_TARGETS, true);
    const crLen = this._cpReturnedStarts[this._cpCount];
    this._cpReturnedTargets = crOff > 0 && crLen > 0 ? new Uint32Array(buffer, crOff, crLen) : null;
    this._cpThrownStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.CP_THROWN_STARTS, true), cc1);
    const ctOff = dv.getUint32(off + CGH.CP_THROWN_TARGETS, true);
    const ctLen = this._cpThrownStarts[this._cpCount];
    this._cpThrownTargets = ctOff > 0 && ctLen > 0 ? new Uint32Array(buffer, ctOff, ctLen) : null;

    // Events
    const evOff = dv.getUint32(off + CGH.EVENTS, true);
    this._events = evOff > 0 && this._evCount > 0 ? new Uint32Array(buffer, evOff, this._evCount * 4) : null;

    // Segment/CodePath caches
    this._segCache = new Array(this._segCount).fill(null);
    this._cpCache = new Array(this._cpCount).fill(null);
  }

  get segmentCount() { return this._segCount; }
  get codepathCount() { return this._cpCount; }
  get eventCount() { return this._evCount; }

  segment(idx) {
    if (idx >= this._segCount || idx === NONE32) return null;
    if (!this._segCache[idx]) this._segCache[idx] = new CfgSegment(this, idx);
    return this._segCache[idx];
  }

  codepath(idx) {
    if (idx >= this._cpCount || idx === NONE32) return null;
    if (!this._cpCache[idx]) this._cpCache[idx] = new CfgCodePath(this, idx);
    return this._cpCache[idx];
  }

  /** Read CSR range as array of segment wrappers */
  _csrSegments(starts, targets, idx) {
    if (!targets) return [];
    const start = starts[idx];
    const end = starts[idx + 1];
    const result = [];
    for (let i = start; i < end; i++) {
      const s = this.segment(targets[i]);
      if (s) result.push(s);
    }
    return result;
  }

  /** Read CSR range as array of segment indices */
  _csrIds(starts, targets, idx) {
    if (!targets) return [];
    const start = starts[idx];
    const end = starts[idx + 1];
    const result = [];
    for (let i = start; i < end; i++) result.push(targets[i]);
    return result;
  }
}

class CfgSegment {
  constructor(cfg, idx) {
    this._cfg = cfg;
    this._idx = idx;
    const cpIdx = cfg._segCp[idx];
    this.id = `s${cpIdx + 1}_${idx + 1}`;
    this.reachable = cfg._segReachable[idx] !== 0;
    // Lazy cached adjacency
    this._next = undefined;
    this._prev = undefined;
    this._allNext = undefined;
    this._allPrev = undefined;
    this._looped = undefined;
    this.internal = { used: true, loopedPrevSegments: null, nodes: [] };
  }

  get nextSegments() {
    if (this._next === undefined) this._next = this._cfg._csrSegments(this._cfg._nextStarts, this._cfg._nextTargets, this._idx);
    return this._next;
  }
  get prevSegments() {
    if (this._prev === undefined) this._prev = this._cfg._csrSegments(this._cfg._prevStarts, this._cfg._prevTargets, this._idx);
    return this._prev;
  }
  get allNextSegments() {
    if (this._allNext === undefined) this._allNext = this._cfg._csrSegments(this._cfg._allNextStarts, this._cfg._allNextTargets, this._idx);
    return this._allNext;
  }
  get allPrevSegments() {
    if (this._allPrev === undefined) this._allPrev = this._cfg._csrSegments(this._cfg._allPrevStarts, this._cfg._allPrevTargets, this._idx);
    return this._allPrev;
  }

  isLoopedPrevSegment(segment) {
    if (this._looped === undefined) {
      this._looped = new Set(this._cfg._csrIds(this._cfg._loopedStarts, this._cfg._loopedTargets, this._idx));
    }
    return this._looped.has(segment._idx);
  }
}

class CfgCodePath {
  constructor(cfg, idx) {
    this._cfg = cfg;
    this._idx = idx;
    this.id = `s${idx + 1}`;
    this.origin = CP_ORIGINS[cfg._cpOrigin[idx]] || 'function';
    const upperIdx = cfg._cpUpper[idx];
    this.upper = upperIdx !== NONE32 ? cfg.codepath(upperIdx) : null;
    this.childCodePaths = []; // populated during event replay
    this.internal = {};
    // Lazy cached segment lists
    this._initial = undefined;
    this._final = undefined;
    this._returned = undefined;
    this._thrown = undefined;
  }

  get initialSegment() {
    if (this._initial === undefined) this._initial = this._cfg.segment(this._cfg._cpInitialSeg[this._idx]);
    return this._initial;
  }
  get finalSegments() {
    if (this._final === undefined) this._final = this._cfg._csrSegments(this._cfg._cpFinalStarts, this._cfg._cpFinalTargets, this._idx);
    return this._final;
  }
  get returnedSegments() {
    if (this._returned === undefined) this._returned = this._cfg._csrSegments(this._cfg._cpReturnedStarts, this._cfg._cpReturnedTargets, this._idx);
    return this._returned;
  }
  get thrownSegments() {
    if (this._thrown === undefined) this._thrown = this._cfg._csrSegments(this._cfg._cpThrownStarts, this._cfg._cpThrownTargets, this._idx);
    return this._thrown;
  }

  get currentSegments() {
    // During event replay, this is set dynamically
    return this._currentSegments || [this.initialSegment];
  }
  set currentSegments(segs) { this._currentSegments = segs; }

  get returnedForkContext() { return []; }

  traverseSegments(optionsOrCb, maybeCb) {
    const cb = typeof optionsOrCb === 'function' ? optionsOrCb : maybeCb;
    const opts = typeof optionsOrCb === 'object' ? optionsOrCb : null;
    const startSeg = opts?.first || this.initialSegment;
    const lastSeg = opts?.last || null;

    // DFS traversal matching ESLint's CodePath.traverseSegments exactly.
    // Key: a segment is only processed when ALL its prevSegments have been
    // visited (or are looped back-edges). This ensures merge points wait
    // for both branches.
    const visited = new Set();
    const skipped = new Set();
    const stack = [[startSeg, 0]];
    let segment = null;
    let broken = false;
    const controller = {
      skip() { skipped.add(segment); },
      break() { broken = true; },
    };
    function isVisited(prev) { return visited.has(prev) || segment.isLoopedPrevSegment(prev); }
    function isSkipped(prev) { return skipped.has(prev) || segment.isLoopedPrevSegment(prev); }

    while (stack.length > 0) {
      const record = stack[stack.length - 1];
      segment = record[0];
      const index = record[1];

      if (index === 0) {
        if (visited.has(segment)) { stack.pop(); continue; }
        // Wait until all prevSegments are visited (looped prevs count as visited)
        if (segment !== startSeg && segment.prevSegments.length > 0 &&
            !segment.prevSegments.every(isVisited)) { stack.pop(); continue; }
        visited.add(segment);
        // Auto-skip if all prevSegments were skipped
        const shouldSkip = skipped.size > 0 && segment.prevSegments.length > 0 &&
            segment.prevSegments.every(isSkipped);
        if (!shouldSkip) {
          cb.call(this, segment, controller);
          if (segment === lastSeg) controller.skip();
          if (broken) break;
        } else {
          skipped.add(segment);
        }
      }

      const end = segment.nextSegments.length - 1;
      if (index < end) {
        record[1] += 1;
        stack.push([segment.nextSegments[index], 0]);
      } else if (index === end) {
        record[0] = segment.nextSegments[index];
        record[1] = 0;
      } else {
        stack.pop();
      }
    }
  }
}

module.exports = { AstView, NodeProto, nodeView, reset, setTagNames, NONE, T, effectiveTypeName, CfgGraph, CfgSegment, CfgCodePath };
