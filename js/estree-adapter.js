"use strict";

const { T, OPERATOR_BY_TAG } = require("./tags");

// ── Token tag constants ───────────────────────────────────────────
const TOK_KW_TYPE = 58;   // kw_type token tag

// ── Packed modifier bit constants ────────────────────────────────
// Match ast.zig ModifierBit
const MOD_ACC_MASK  = 0x3;
const MOD_ACC_PUBLIC    = 0x1;
const MOD_ACC_PRIVATE   = 0x2;
const MOD_ACC_PROTECTED = 0x3;
const MOD_READONLY  = 1 << 2;
const MOD_OVERRIDE  = 1 << 3;
const MOD_DECLARE   = 1 << 4;
const MOD_ABSTRACT  = 1 << 5;
const MOD_STATIC    = 1 << 6;
const MOD_ASYNC     = 1 << 7;
const MOD_GENERATOR = 1 << 8;
const MOD_ACCESSOR  = 1 << 9;

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
         tag === T.import_decl || tag === T.export_named || tag === T.export_named_from ||
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
  // v11: merged token+comment order (byte 136)
  TOK_CMT_MERGE_OFFSET: 136,
  // v12: resolved parent indices (parent post grouping_expr / ts_parenthesized_type
  // skip). Eliminates a parent-chain while-loop in `get parent`'s slow path.
  RESOLVED_PARENT_OFFSET: 140,
  // v13: u8 type override per node — pre-baked result of the JS-side
  // `_computeNodeType` switch. 0 = use TAG_NAMES[tag]; 1..19 = override
  // slot in `_OVERRIDE_TYPES`. See parent_builder.zig TypeOverride enum.
  TYPE_OVERRIDES_OFFSET: 144,
  // v14: u8 parent-synthesis kind per node — pre-baked dispatch for the
  // post-resolve cascade in `get parent`. 0 = no synthesis (use resolved
  // parent NodeView directly); 1..6 select a synthetic-wrapper or redirect
  // path. See parent_builder.zig ParentKind enum.
  PARENT_KIND_OFFSET: 148,
  // v15: per-node identifier name UTF-16 ranges. u32[node_count] each.
  // For identifier/property_ident: [start,end) in source (private '#' stripped).
  // For all other nodes: 0,0. JS reads via source.slice(start, end).
  NODE_NAME_STARTS_OFFSET: 152,
  NODE_NAME_ENDS_OFFSET: 156,
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
  REF_WRITE_EXPR_IDS: 84,  // u32[] — write expression node (NONE if not a write ref)
  NODE_SCOPE_IDS: 88,
  NODE_REACHABLE: 92,   // u8[] per-node reachability: 1=live, 0=dead
  LOOP_EXIT_REACHABLE: 96,  // u8[] per-loop exit reachability: 1=exit alive, 0=exit dead
  _RESERVED_100: 100,      // legacy cfg_events_offset (unused)
  _RESERVED_104: 104,      // legacy cfg_events_count (unused)
  CFG_GRAPH_OFFSET: 108,   // byte offset to CfgGraphHeader (0 = not present)
  SCOPE_REF_STARTS: 112,   // u32[scope_count] — first index in scope_ref_ids per scope
  SCOPE_REF_COUNTS: 116,   // u32[scope_count] — number of refs per scope
  SCOPE_REF_IDS: 120,      // u32[ref_count]   — ref indices sorted by scope
  SCOPE_CHILD_STARTS: 124, // u32[scope_count] — first index in scope_child_ids per scope
  SCOPE_CHILD_COUNTS: 128, // u32[scope_count] — number of child scopes per scope
  SCOPE_CHILD_IDS: 132,    // u32[total_children] — child scope IDs sorted by parent
  TAG_NODE_STARTS: 136,    // u32[tag_count + 1] — prefix-sum (sentinel at end)
  TAG_NODE_IDS: 140,       // u32[node_count]    — node indices sorted by tag
  TAG_COUNT: 144,          // u32 — number of tag slots
  NODE_DEPTHS: 148,        // u32[node_count] — pre-computed node depths
  SYMBOL_KINDS: 152,       // u8[symbol_count] — BindingKind per symbol
  SCOPE_THROUGH_REF_STARTS: 156, // u32[scope_count]
  SCOPE_THROUGH_REF_COUNTS: 160, // u32[scope_count]
  SCOPE_THROUGH_REF_IDS: 164,    // u32[total_through_refs]
  SYM_REF_INDIRECT: 168,         // u32[ref_count] — ref_by_sym indirect index
  SCOPE_SYM_IDS: 172,            // u32[sym_count] — sym IDs sorted by scope (CSR)
  // Phase B: per-node decl-sym CSR. Replaces JS-side `_ensureDeclSymIndex`.
  DECL_SYM_NODE_STARTS: 176,     // u32[node_count + 1] — prefix-sum CSR offsets
  DECL_SYM_NODE_IDS: 180,        // u32[total_entries]  — symbol IDs
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
    // Data is interleaved [lhs: u32, rhs: u32] per node, accessed via DataView
    // (Uint32Array view was slightly slower in V8/Bun for this hot path).
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

    // Merged token+comment order (v11) — u32[tokenCount + commentCount].
    // Entry < tokenCount → token index; entry >= tokenCount → comment index.
    // Must be read after _commentCount is set below, so we defer initialization.
    this._tokCmtMergeOff = dv.getUint32(H.TOK_CMT_MERGE_OFFSET, true);
    this._tokCmtMerge = null; // lazily created — _commentCount not yet read

    // Source text (UTF-8 in buffer, decoded lazily)
    this._sourceBytes = new Uint8Array(buffer, sourceOff, this.sourceLen);
    this._sourceOff = sourceOff; // byte offset of source in buffer (for symbol name lookup)
    this._sourceText = null;

    // Parent indices (v2 — zero array if not present in buffer)
    const parentOff = dv.getUint32(H.PARENT_INDICES_OFFSET, true);
    this._parentData = parentOff > 0
      ? new Uint32Array(buffer, parentOff, this.nodeCount)
      : null;
    // Resolved parent indices (v12 — `_parentData` with grouping_expr /
    // ts_parenthesized_type ancestors skipped). Eliminates the while-loop in
    // `get parent`'s slow path. Falls back to runtime walking if absent.
    const resolvedParentOff = dv.getUint32(H.RESOLVED_PARENT_OFFSET, true);
    this._resolvedParentData = resolvedParentOff > 0
      ? new Uint32Array(buffer, resolvedParentOff, this.nodeCount)
      : null;
    // v13: per-node type override slot. 0 = use TAG_NAMES[tag]; 1..19 select
    // an entry from `_OVERRIDE_TYPES`. Eliminates the per-node switch +
    // token-text matching that `_computeNodeType` used to run on every node.
    const typeOverridesOff = dv.getUint32(H.TYPE_OVERRIDES_OFFSET, true);
    this._typeOverrides = typeOverridesOff > 0
      ? new Uint8Array(buffer, typeOverridesOff, this.nodeCount)
      : null;
    // v14: per-node parent-synthesis kind. 0 = no synthesis (return resolved
    // parent NodeView directly); 1..6 select a synthetic-wrapper or redirect
    // path. Replaces the post-resolve tag-pattern cascade in `get parent`.
    const parentKindOff = dv.getUint32(H.PARENT_KIND_OFFSET, true);
    this._parentKinds = parentKindOff > 0
      ? new Uint8Array(buffer, parentKindOff, this.nodeCount)
      : null;
    // v15: per-node identifier name UTF-16 ranges (start, end into source).
    const nnsOff = dv.getUint32(H.NODE_NAME_STARTS_OFFSET, true);
    const nneOff = dv.getUint32(H.NODE_NAME_ENDS_OFFSET, true);
    this._nodeNameStarts = nnsOff > 0 ? new Uint32Array(buffer, nnsOff, this.nodeCount) : null;
    this._nodeNameEnds   = nneOff > 0 ? new Uint32Array(buffer, nneOff, this.nodeCount) : null;

    // DFS traversal orders (v4 — pre-order and post-order, computed in Zig)
    const preOff  = dv.getUint32(H.PRE_ORDER_OFFSET,  true);
    const postOff = dv.getUint32(H.POST_ORDER_OFFSET, true);
    this._preOrder  = preOff  > 0 ? new Uint32Array(buffer, preOff,  this.nodeCount) : null;
    this._postOrder = postOff > 0 ? new Uint32Array(buffer, postOff, this.nodeCount) : null;

    // Inverse of _preOrder: _preOrderRank[nodeIdx] = DFS pre-order visiting position.
    // Used by getNodeByRangeIndex to pick the deepest (last-entered) node among
    // same-range candidates. Higher rank = visited later in DFS = deeper in tree.
    // Computed lazily on first getNodeByRangeIndex call (O(n) fill).
    this._preOrderRank = null;

    // Interleaved DFS events (v5 — enter/exit in correct DFS order, computed in Zig).
    // Kept as a view into the shared parse buffer.  The view is valid until the
    // next parse/parseSource/parseAndLintNative call overwrites the buffer —
    // callers must consume the AST before parsing the next file.
    const dfsEvOff = dv.getUint32(H.DFS_EVENTS_OFFSET, true);
    this._dfsEvents = dfsEvOff > 0
      ? new Int32Array(buffer, dfsEvOff, this.nodeCount * 2)
      : null;

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

    // Deferred view creation for merged token+comment order (needs commentCount).
    if (this._tokCmtMergeOff > 0) {
      const total = this.tokenCount + this._commentCount;
      this._tokCmtMerge = new Uint32Array(buffer, this._tokCmtMergeOff, total);
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
        const _symKindsOff    = dv.getUint32(semOff + SH.SYMBOL_KINDS, true);
        this._symKinds        = _symKindsOff ? new Uint8Array(buffer, _symKindsOff, this._semSymbolCount) : null;
        this._symScopeIds     = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_SCOPE_IDS, true),  this._semSymbolCount);
        this._symDeclNodes    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_DECL_NODES, true), this._semSymbolCount);
        this._symRefStarts    = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_REF_STARTS, true), this._semSymbolCount);
        this._symRefEnds      = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_REF_ENDS, true),   this._semSymbolCount);
        const _symRefIndirectOff = dv.getUint32(semOff + SH.SYM_REF_INDIRECT, true);
        this._symRefBySym     = (_symRefIndirectOff > 0 && this._semRefCount > 0) ? new Uint32Array(buffer, _symRefIndirectOff, this._semRefCount) : null;
        const _scopeSymIdsOff = dv.getUint32(semOff + SH.SCOPE_SYM_IDS, true);
        this._scopeSymIds     = (_scopeSymIdsOff > 0 && this._semSymbolCount > 0) ? new Uint32Array(buffer, _scopeSymIdsOff, this._semSymbolCount) : null;
        // Phase B: per-node decl-sym CSR. `_declSymNodeStarts[i]` is the start
        // index into `_declSymNodeIds`; count = starts[i+1] - starts[i].
        const _declSymStartsOff = dv.getUint32(semOff + SH.DECL_SYM_NODE_STARTS, true);
        const _declSymIdsOff    = dv.getUint32(semOff + SH.DECL_SYM_NODE_IDS, true);
        this._declSymNodeStarts = _declSymStartsOff > 0
          ? new Uint32Array(buffer, _declSymStartsOff, this.nodeCount + 1)
          : null;
        // Total entry count is the last element of the prefix-sum array.
        const _declSymTotal = this._declSymNodeStarts ? this._declSymNodeStarts[this.nodeCount] : 0;
        this._declSymNodeIds = (_declSymIdsOff > 0 && _declSymTotal > 0)
          ? new Uint32Array(buffer, _declSymIdsOff, _declSymTotal)
          : null;
        this._symNameStarts   = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_NAME_STARTS, true),this._semSymbolCount);
        this._symNameLens     = new Uint32Array(buffer, dv.getUint32(semOff + SH.SYMBOL_NAME_LENS, true),  this._semSymbolCount);
        // Symbol name cache built lazily on first _symName() call.
        this._symNameCache = null;
      }

      if (this._semRefCount > 0) {
        this._refSymbolIds    = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SYMBOL_IDS, true),     this._semRefCount);
        this._refKinds        = new Uint8Array (buffer, dv.getUint32(semOff + SH.REF_KINDS, true),           this._semRefCount);
        this._refNodeIds      = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_NODE_IDS, true),        this._semRefCount);
        this._refScopeIds     = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_SCOPE_IDS, true),       this._semRefCount);
        this._refWriteExprIds = new Uint32Array(buffer, dv.getUint32(semOff + SH.REF_WRITE_EXPR_IDS, true), this._semRefCount);
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

      // Scope → through-refs CSR (precomputed in Zig — refs passing through scope
      // without resolving locally; target is a strict ancestor or ref is unresolved).
      const stOff = dv.getUint32(semOff + SH.SCOPE_THROUGH_REF_STARTS, true);
      if (stOff > 0) {
        this._scopeThroughRefStarts = new Uint32Array(buffer, stOff, this._semScopeCount);
        this._scopeThroughRefCounts = new Uint32Array(buffer, dv.getUint32(semOff + SH.SCOPE_THROUGH_REF_COUNTS, true), this._semScopeCount);
        const stiOff = dv.getUint32(semOff + SH.SCOPE_THROUGH_REF_IDS, true);
        if (stiOff > 0 && this._semScopeCount > 0) {
          const lastScope = this._semScopeCount - 1;
          const totalThrough = this._scopeThroughRefStarts[lastScope] + this._scopeThroughRefCounts[lastScope];
          this._scopeThroughRefIds = totalThrough > 0 ? new Uint32Array(buffer, stiOff, totalThrough) : null;
        }
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

    // Per-parse NodeView pool. Eagerly allocated so `_nodeViewRaw`
    // skips the `cache === null` lazy-init branch on every call — the
    // function is hit by every `node.parent` / array-getter access in
    // every rule, so removing one branch per call is real. Sentinel
    // for "not computed yet" stays `undefined` (matches downstream
    // invalidation patterns like `nc[0] = undefined`).
    this._nodeCache = new Array(this.nodeCount);

    // Pre-computed AST-shape bits, one byte per node. Lets hot
    // helpers short-circuit a multi-step chain with a single buffer
    // read instead of walking NodeView wrappers + property getters.
    //
    // Empirical lesson from wiring attempts: shape bits only pay
    // when they replace a chain of >=2 checks. Single-property
    // checks like `node?.type === 'X'` are already at V8's IC floor
    // and adding `_shapeBits[i] & MASK` is parallel overhead, not a
    // replacement. So the only bit kept is the one that fits this
    // criterion in practice; isMemberExpression / isCallExpression /
    // isUndefined wirings were tested and either neutral or slower,
    // so they're not consumed here.
    //
    // Bit layout:
    //   0x01 — IS_METHOD_CALL_SHAPE: tag is one of the call_expr
    //          variants AND its lhs (callee) tag is one of the
    //          member_expr variants. Used by unicorn isMethodCall.
    {
      const nc = this.nodeCount;
      const bits = new Uint8Array(nc);
      const tags = this._nodeTags;
      const dv2 = this._dv;
      const dataOff = this._dataOff;
      const tCallExpr = T.call_expr;
      const tOptCallExpr = T.optional_call_expr;
      const tMember = T.member_expr;
      const tCompMember = T.computed_member_expr;
      const tOptMember = T.optional_member_expr;
      const tOptCompMember = T.optional_computed_member_expr;
      for (let i = 0; i < nc; i++) {
        const t = tags[i];
        if (t === tCallExpr || t === tOptCallExpr) {
          const calleeIdx = dv2.getUint32(dataOff + i * 8, true);
          if (calleeIdx < nc) {
            const ct = tags[calleeIdx];
            if (ct === tMember || ct === tCompMember || ct === tOptMember || ct === tOptCompMember) {
              bits[i] = 0x01;
            }
          }
        }
      }
      this._shapeBits = bits;
    }

    // Build node→symId index from ref arrays. Most identifier/property_ident
    // nodes are symbol references; for those, _computeIdentifierName can return
    // symNameCache[symId] directly — a pre-allocated string, zero source.slice().
    // Non-reference identifiers (e.g. member-expression property names) fall
    // through to the v15 source.slice() path.
    this._nodeSymId = null;
    if (this._semRefCount > 0 && this._refNodeIds && this._refSymbolIds) {
      const nc = this.nodeCount;
      const nodeSymId = new Uint32Array(nc).fill(NONE);
      const refNodeIds = this._refNodeIds;
      const refSymIds  = this._refSymbolIds;
      const refCount   = this._semRefCount;
      for (let r = 0; r < refCount; r++) {
        const ni = refNodeIds[r];
        // Take the first ref for each node; name is the same for all refs on the same node.
        if (nodeSymId[ni] === NONE) nodeSymId[ni] = refSymIds[r];
      }
      this._nodeSymId = nodeSymId;
      // Eagerly warm the sym name cache so _computeIdentifierName hits it immediately
      // at _NodeView_LR construction time rather than triggering a lazy build mid-traversal.
      this._buildSymNameCache();
    }
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

  /** FnData { name, params, params_end, body, return_type, type_params, type_params_end } */
  extraFnData(i) {
    const e = this._extraData;
    return { name: e[i], params: e[i + 1], params_end: e[i + 2], body: e[i + 3], return_type: e[i + 4], type_params: e[i + 5], type_params_end: e[i + 6] };
  }

  /** ClassData { name, super_class, body, impls_start, impls_end, type_params, type_params_end } */
  extraClassData(i) {
    const e = this._extraData;
    return { name: e[i], super_class: e[i + 1], body: e[i + 2], impls_start: e[i + 3], impls_end: e[i + 4], type_params: e[i + 5], type_params_end: e[i + 6] };
  }

  /** ArrowData { params_start, params_end, body, return_type } */
  extraArrowData(i) {
    const e = this._extraData;
    return { params_start: e[i], params_end: e[i + 1], body: e[i + 2], return_type: e[i + 3] };
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

  /** MethodData { params_start, params_end, body, return_type, modifiers } */
  extraMethodData(i) {
    const e = this._extraData;
    return { params_start: e[i], params_end: e[i + 1], body: e[i + 2], return_type: e[i + 3], modifiers: e[i + 4] };
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

  /** InterfaceData { name, type_params, type_params_end, extends_start, extends_end, body_start, body_end } */
  extraInterfaceData(i) {
    const e = this._extraData;
    return { name: e[i], type_params: e[i + 1], type_params_end: e[i + 2], extends_start: e[i + 3], extends_end: e[i + 4], body_start: e[i + 5], body_end: e[i + 6] };
  }

  /** TypeAliasData { name, type_params, type_params_end, type_node } */
  extraTypeAliasData(i) {
    const e = this._extraData;
    return { name: e[i], type_params: e[i + 1], type_params_end: e[i + 2], type_node: e[i + 3] };
  }

  /** PropertyData { value, type_annotation, optional } */
  extraPropertyData(i) {
    const e = this._extraData;
    return { value: e[i], type_annotation: e[i + 1], optional: e[i + 2] };
  }

  /** EnumData { name, members_start, members_end } */
  extraEnumData(i) {
    const e = this._extraData;
    return { name: e[i], members_start: e[i + 1], members_end: e[i + 2] };
  }

  /** InterfaceSigData { key, params_start, params_end, return_type, kind, type_params, type_params_end } */
  extraInterfaceSigData(i) {
    const e = this._extraData;
    return { key: e[i], params_start: e[i + 1], params_end: e[i + 2], return_type: e[i + 3], kind: e[i + 4], type_params: e[i + 5], type_params_end: e[i + 6] };
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

  /** Get the name of a symbol. Cache is built lazily on first call. */
  _symName(symId) {
    let cache = this._symNameCache;
    if (cache === null) cache = this._buildSymNameCache();
    return cache[symId] ?? '';
  }

  _buildSymNameCache() {
    const symCount = this._semSymbolCount;
    const nameCache = new Array(symCount);
    const srcStr = this.source; // lazy decode; also pre-fills _sourceText
    if (srcStr.length === this.sourceLen) {
      // All-ASCII: byte offset == char offset → string slicing.
      // Names in the bump region (implicit globals, offset < sourceStart) fall back to decode.
      const srcOff = this._sourceOff;
      for (let i = 0; i < symCount; i++) {
        const s = this._symNameStarts[i], l = this._symNameLens[i];
        if (l === 0) { nameCache[i] = ''; continue; }
        const cs = s - srcOff;
        nameCache[i] = cs >= 0 ? srcStr.slice(cs, cs + l) : _decoder.decode(new Uint8Array(this.buffer, s, l));
      }
    } else {
      // Non-ASCII: per-symbol TextDecoder
      const bufLen = this.buffer.byteLength;
      for (let i = 0; i < symCount; i++) {
        const s = this._symNameStarts[i], l = this._symNameLens[i];
        nameCache[i] = (l === 0 || s + l > bufLen) ? '' : _decoder.decode(new Uint8Array(this.buffer, s, l));
      }
    }
    this._symNameCache = nameCache;
    return nameCache;
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
// Former _INIT_UNSET / _BODY_UNSET / _VALUE_UNSET sentinels removed —
// the corresponding caches now live in the external `_synthCache` WeakMap
// where `'key' in bundle` distinguishes "computed = undefined / null"
// from "not computed yet" without a magic-object dance.

// External cache for SYNTHETIC nodes (constructed objects that don't exist in
// the buffer — e.g., a method's synthetic FunctionExpression value, the
// synthetic TSTypeParameterDeclaration / TSTypeParameterInstantiation
// wrappers). Synthetic identity must be stable across reads
// (`node.value === node.value`), and these caches used to live as own
// properties on the NodeView (`this._syntheticFn`, `this._typeParameters`,
// etc.). That mixed two failure modes: cache poisoning via mutation
// (e.g. invokeMethodFnHandlers mutating fn.range) and IC pollution from
// fields that aren't part of the buffer-backed shape. Moving them out:
//   • bugs from mutation of cached synth fields don't poison other NodeViews
//   • NodeView's own-property surface stays buffer-only
//   • per-tag constructor families can shed the synth-cache fields entirely
const _synthCache = new WeakMap();
function _getSynth(node) {
  let s = _synthCache.get(node);
  if (!s) { s = Object.create(null); _synthCache.set(node, s); }
  return s;
}

// ── TypeScript synthetic node helpers ─────────────────────────

/** Read packed modifiers from MethodData. Returns 0 if node has no modifiers. */
function _nodeMods(ast, nodeIdx) {
  const t = ast._nodeTags[nodeIdx];
  if (t === T.method_def || t === T.getter_def || t === T.setter_def ||
      t === T.constructor_def || t === T.computed_method_def ||
      t === T.computed_getter_def || t === T.computed_setter_def) {
    return ast.extraMethodData(ast.nodeRhs(nodeIdx)).modifiers;
  }
  return 0;
}

/** Determine ESTree member type for a ts_type_annotation used as interface member. */
function _tsInterfaceMemberType(ast, idx) {
  const mt = ast._mainTokens[idx];
  const c = ast.source.charCodeAt(ast._tokStarts[mt]);
  // TSIndexSignature: main_token is '[' — check BEFORE lhs (lhs is now the param identifier)
  if (c === 91) return 'TSIndexSignature';
  const lhs = ast.nodeLhs(idx);
  if (lhs === NONE) {
    if (c === 110) return 'TSConstructSignatureDeclaration'; // 'n' for new
    return 'TSCallSignatureDeclaration';
  }
  // Has a name — check token after name for '(' or '<' (method) vs ':' (property)
  const nameMt = ast._mainTokens[lhs];
  let next = nameMt + 1;
  if (next < ast.tokenCount && ast.source.charCodeAt(ast._tokStarts[next]) === 63) next++; // skip '?'
  if (next < ast.tokenCount) {
    const nc = ast.source.charCodeAt(ast._tokStarts[next]);
    if (nc === 40 || nc === 60) return 'TSMethodSignature'; // '(' or '<'
  }
  return 'TSPropertySignature';
}

/** Create a synthetic AST node (plain object, not a NodeView). */
function _syntheticNode(type, start, end, props, ast) {
  const ls = ast._lineStarts();
  const sli = ast._findLineIdx(start);
  const eli = ast._findLineIdx(end > 0 ? end - 1 : 0);
  return Object.assign({
    type,
    start,
    end,
    range: [start, end],
    loc: {
      start: { line: sli + 1, column: start - ls[sli] },
      end:   { line: eli + 1, column: end   - ls[eli] },
    },
    parent: null,
  }, props);
}

/** Create a synthetic Identifier node from a token index. */
function _tokenIdentifier(ast, tokIdx) {
  const name = ast._identAt(tokIdx);
  const start = ast._tokStarts[tokIdx];
  const end = ast._tokEnds ? ast._tokEnds[tokIdx] : start + name.length;
  return _syntheticNode('Identifier', start, end, { name, typeAnnotation: undefined }, ast);
}

/**
 * Convert a member_expr chain (used for qualified type names like `React.FC`) to
 * a TSQualifiedName node with .left/.right properties, as ESTree rules expect.
 * Called recursively for nested qualifications.
 */
function _memberToQualifiedName(ast, idx) {
  const lhs = ast.nodeLhs(idx);
  const rhs = ast.nodeRhs(idx); // property_ident
  const lhsTag = ast._nodeTags[lhs];
  const leftNode = lhsTag === T.member_expr
    ? _memberToQualifiedName(ast, lhs)
    : nodeView(ast, lhs); // Identifier
  const rightNode = nodeView(ast, rhs); // property_ident → Identifier
  const start = leftNode.start;
  const end = rightNode.end;
  return _syntheticNode('TSQualifiedName', start, end, { left: leftNode, right: rightNode }, ast);
}

// ESTree-shape type override slots. Index 0 is reserved as "no override"
// (use TAG_NAMES[tag]); indices 1..19 mirror `parent_builder.TypeOverride`
// in Zig and must stay in sync with that enum.
const _OVERRIDE_TYPES = [
  null,                          // 0 — no override (sentinel)
  'PrivateIdentifier',           // 1
  'Property',                    // 2 — method_def inside object_literal/object_pattern
  'TSImportEqualsDeclaration',   // 3
  'TSModuleBlock',               // 4
  'TSLiteralType',               // 5
  'TSAnyKeyword',                // 6
  'TSBigIntKeyword',             // 7
  'TSBooleanKeyword',            // 8
  'TSIntrinsicKeyword',          // 9
  'TSNeverKeyword',              // 10
  'TSNullKeyword',               // 11
  'TSNumberKeyword',             // 12
  'TSObjectKeyword',             // 13
  'TSStringKeyword',             // 14
  'TSSymbolKeyword',             // 15
  'TSThisType',                  // 16
  'TSUndefinedKeyword',          // 17
  'TSUnknownKeyword',            // 18
  'TSVoidKeyword',               // 19
  'TSQualifiedName',             // 20 — member_expr in type position
  'NewExpression',               // 21 — call_expr(ts_instantiation_expr(new_expr)) = new Foo<T>()
  'AccessorProperty',           // 22 — property_def with accessor keyword (ES2024 auto-accessors)
  'TSAbstractPropertyDefinition', // 23 — abstract class property
  'TSAbstractAccessorProperty', // 24 — abstract accessor class property
];

// Compute the ESTree-shape `type` string for a node at construction time.
// Fast path: read the pre-baked `_typeOverrides[index]` slot — Zig already
// resolved the disambiguation cases (PrivateIdentifier, Property,
// TSImportEqualsDeclaration, TSModuleBlock, TS keyword/literal types) at
// parse time. Slot 0 means "no override; use TAG_NAMES[tag]".
// Fallback: when the buffer doesn't carry the v13 array (legacy), recompute
// from the raw tag.
function _computeNodeType(ast, index, tag) {
  const overrides = ast._typeOverrides;
  if (overrides) {
    const slot = overrides[index];
    if (slot !== 0) return _OVERRIDE_TYPES[slot];
  }
  // Abstract class members become TSAbstractPropertyDefinition /
  // TSAbstractMethodDefinition in the ESTree shape (typescript-eslint
  // splits abstract from concrete via the node TYPE, not a flag). The
  // parent_builder doesn't pre-bake this because the abstract bit is
  // already on the modifier byte — check it here.
  if (tag === T.property_def || tag === T.computed_property_def ||
      tag === T.method_def || tag === T.computed_method_def) {
    const mods = _nodeMods(ast, index);
    if (mods & MOD_ABSTRACT) {
      if (tag === T.property_def || tag === T.computed_property_def) return 'TSAbstractPropertyDefinition';
      return 'TSAbstractMethodDefinition';
    }
    // ES2024 auto-accessor fields use `accessor` keyword → AccessorProperty node type.
    if ((tag === T.property_def || tag === T.computed_property_def) && (mods & MOD_ACCESSOR)) {
      return 'AccessorProperty';
    }
  }
  return TAG_NAMES ? TAG_NAMES[tag] : String(tag);
}

const NodeProto = {
  // ── Low-level ez accessors (existing) ──────────────────────

  // `type` is set as an own data property at construction time
  // (see `_nodeViewRaw` → `_computeNodeType`). No getter — a direct
  // property read at every call site. Eliminates ~14% of profile time
  // that used to be spent in the cached-fast-path getter check.
  // _tag (numeric Zig AST node type) is now an own data property on every
  // node instance, set at `_nodeViewRaw` construction time. Direct property
  // read instead of typed-array dispatch via `ast._nodeTags[idx]`.
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
    // Program (root) always starts at 0, even if the first token is not at 0.
    if (ast._nodeTags[this._i] === T.root) return 0;
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
    // `declare var/let/const` and `declare function`: the VariableDeclaration/
    // FunctionDeclaration node's range starts at `var`/`function`, but ESTree
    // (TypeScript-ESLint) includes the `declare` keyword in the node range.
    // Detect by checking if the token preceding the node's main_token is `declare`.
    const t = ast._nodeTags[this._i];
    if (t === T.var_decl || t === T.let_decl || t === T.const_decl || t === T.fn_decl || t === T.ts_declare_function) {
      const mt = ast._mainTokens[this._i];
      if (mt > 0 && ast._tokStarts && ast._tokEnds) {
        const prev = mt - 1;
        const ps = ast._tokStarts[prev], pe = ast._tokEnds[prev];
        if (pe <= ast.source.length && ast.source.slice(ps, pe) === 'declare') {
          return ps;
        }
      }
    }
    // TSIndexSignature with `readonly`: main_token is `[` but range should
    // include the preceding `readonly` keyword (typescript-eslint behavior).
    if (t === T.ts_index_signature) {
      const mt = ast._mainTokens[this._i];
      if (mt > 0 && ast._tokStarts && ast._tokEnds) {
        const prev = mt - 1;
        const ps = ast._tokStarts[prev], pe = ast._tokEnds[prev];
        if (pe <= ast.source.length && ast.source.slice(ps, pe) === 'readonly') {
          return ps;
        }
      }
    }
    return ast._nodeStartPos(this._i);
  },
  get end() {
    const ast = this._ast;
    if (ast._nodeTags[this._i] === T.root) return ast.sourceUtf16Len;
    // jsx_identifier with compound name (e.g. aria-haspopup): lhs = last token index.
    // _nodeEndPos only covers the first token; use tok_ends[lhs] for the true end.
    if (ast._nodeTags[this._i] === T.jsx_identifier) {
      const lhs = ast.nodeLhs(this._i);
      if (lhs !== NONE && ast._tokEnds) return ast._tokEnds[lhs];
    }
    // SequenceExpression: when paren-wrapped, _nodeEndPos includes the closing ')'.
    // ESTree requires end at the last expression (parens are not part of the range).
    if (ast._nodeTags[this._i] === T.sequence_expr) {
      const lhs = ast.nodeLhs(this._i), rhs = ast.nodeRhs(this._i);
      const extra = ast._extraData;
      for (let i = rhs - 1; i >= lhs; i--) {
        const ci = extra[i];
        if (ci !== NONE) return ast._nodeEndPos(ci);
      }
    }
    return ast._nodeEndPos(this._i);
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
    const ast = this._ast;
    const parentIdx = ast._resolvedParentData[this._i];
    if (parentIdx === NONE) { this._parent = null; return null; }

    // Lazy fixup: nodes that are children of SYNTHETIC wrappers need their
    // _parent set to the synthetic node rather than the real parent.
    // (a) Type param inside TSTypeReference / TSInstantiationExpression:
    //     accessing `typeArguments` sets _parent = TSTypeParameterInstantiation.
    // (b) Return-type node inside TSFunctionType / TSConstructorType:
    //     accessing `returnType` sets _parent = TSTypeAnnotation.
    const parentTag = ast._nodeTags[parentIdx];
    if (parentTag === T.ts_type_reference || parentTag === T.ts_instantiation_expr) {
      _nodeViewRaw(ast, parentIdx).typeArguments; // side-effect: sets _parent on all type params
      if (this._parent !== _PARENT_UNSET) return this._parent;
    } else if (parentTag === T.ts_function_type || parentTag === T.ts_constructor_type) {
      _nodeViewRaw(ast, parentIdx).returnType; // side-effect: sets _parent on the return type node
      if (this._parent !== _PARENT_UNSET) return this._parent;
    }

    // Pre-baked synthesis kind from Zig (see parent_builder.ParentKind).
    // Common case: kind === 0 → return resolved-parent NodeView directly.
    const kind = ast._parentKinds[this._i];
    if (kind === 0) {
      const r = nodeView(this._ast, parentIdx);
      this._parent = r;
      return r;
    }

    let result = nodeView(this._ast, parentIdx);
    switch (kind) {
      case 1: {
        // ChainExpression wrap — this node is the outermost optional. Wrap
        // the resolved parent in a synthetic ChainExpression and stash the
        // real parent on it for ChainExpression's own parent lookup.
        const chainExpr = _getChainExpr(this._ast, this._i);
        Object.defineProperty(chainExpr, '_realParent', {
          value: result, writable: true, enumerable: false, configurable: true,
        });
        this._parent = chainExpr;
        return chainExpr;
      }
      case 2: {
        // Method/getter/setter non-key child — ESTree wants the synthetic
        // FunctionExpression (parent.value) as the parent.
        result = result.value;
        this._parent = result;
        return result;
      }
      case 3: {
        // ObjectPattern child (assignment_pattern/identifier) — synthesize a
        // Property wrapper so parent-chain checks find ObjectPattern correctly.
        const t = this._tag;
        const key = t === T.assignment_pattern
          ? (this._ast.nodeLhs(this._i) !== NONE
              ? nodeView(this._ast, this._ast.nodeLhs(this._i))
              : this)
          : this;
        const wrapper = {
          type: 'Property', key, value: this, kind: 'init', method: false,
          shorthand: true, computed: false,
          start: this.start, end: this.end, range: this.range, loc: this.loc,
          parent: result,
        };
        this._parent = wrapper;
        return wrapper;
      }
      case 4: {
        // JSXOpeningElement wrap — jsx_attribute/jsx_spread_attribute under
        // jsx_self_closing. ESTree expects JSXOpeningElement(selfClosing=true).
        const selfClosingNode = result;
        const ast2 = this._ast;
        const d = ast2.extraJsxOpeningData(ast2.nodeLhs(selfClosingNode._i));
        const openingEl = {
          type: 'JSXOpeningElement',
          selfClosing: true,
          get name() { return d.name !== NONE ? nodeView(ast2, d.name) : null; },
          get attributes() { return ast2._nodesFromRange(d.attrs_start, d.attrs_end); },
          range: selfClosingNode.range,
          loc: selfClosingNode.loc,
          get start() { return selfClosingNode.start; },
          get end() { return selfClosingNode.end; },
          parent: selfClosingNode,
        };
        this._parent = openingEl;
        return openingEl;
      }
      case 5: {
        // TSEnumMember → synthetic TSEnumBody. Trigger the body getter so
        // _syntheticEnumBody is populated on this node before returning.
        if (this._syntheticEnumBody === undefined) void result.body;
        const body = this._syntheticEnumBody;
        if (body !== undefined) {
          this._parent = body;
          return body;
        }
        this._parent = result;
        return result;
      }
      case 6: {
        // TS interface member → synthetic TSInterfaceBody (cached on the
        // parent NodeView via its `body` getter).
        const ifaceBody = result.body;
        if (ifaceBody) {
          this._parent = ifaceBody;
          return ifaceBody;
        }
        this._parent = result;
        return result;
      }
      case 7: {
        // ts_type_parameter → synthetic TSTypeParameterDeclaration (cached on
        // the resolved parent's `typeParameters` getter, which also installs
        // `_parent` on each param. After it runs, `this._parent` is the wrapper.)
        const decl = result.typeParameters;
        if (decl && this._parent !== _PARENT_UNSET) return this._parent;
        if (decl) {
          this._parent = decl;
          return decl;
        }
        this._parent = result;
        return result;
      }
      default: {
        this._parent = result;
        return result;
      }
    }
  },
  set parent(v) {
    this._parent = v;
  },

  /**
   * node.operator — binary/unary/assignment operator string.
   * Mostly derived from the tag; ts_keyof_type reads token text (handles keyof/readonly).
   */
  get operator() {
    const t = this._tag;
    if (t === T.ts_keyof_type) {
      // Both `keyof T` and `readonly T` use ts_keyof_type; operator is the keyword text.
      const ast = this._ast;
      const tok = ast._mainTokens[this._i];
      const start = ast._tokStarts[tok];
      const end = ast._tokEnds ? ast._tokEnds[tok]
        : (tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : ast.source.length);
      return ast.source.slice(start, end).trim();
    }
    return OPERATOR_BY_TAG[t] || null;
  },

  /**
   * node.name — identifier name string.
   * Also used by FunctionDeclaration/ClassDeclaration via .id.name.
   */
  get name() {
    const t = this._tag;
    if (t === T.identifier || t === T.property_ident) {
      // Lazy-cache identifier name on the instance — `_buildScopeRefsAndThrough`
      // and rule code (`ref.identifier.name`) read this for nearly every
      // reference, often more than once per identifier across multiple rules.
      // Each computation calls `_identAt` (string slice + Unicode escape
      // resolve), which adds up at hundreds of thousands of accesses per file.
      let cached = this._cachedName;
      if (cached !== undefined) return cached;
      const ast = this._ast;
      const tok = this.mainToken;
      const pos = ast._tokStarts[tok];
      if (ast.source.charCodeAt(pos) === 35) { // '#'
        const nextTokStart = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : pos + 1;
        if (nextTokStart === pos + 1 && tok + 1 < ast.tokenCount) {
          cached = _resolveUnicodeEscapes(ast._identAt(tok + 1));
        } else {
          cached = _resolveUnicodeEscapes(ast.source.slice(pos + 1, nextTokStart).replace(/\s+$/, ''));
        }
      } else {
        cached = _resolveUnicodeEscapes(ast._identAt(tok));
      }
      this._cachedName = cached;
      return cached;
    }
    // JSXIdentifier.name — the identifier text
    if (t === T.jsx_identifier) {
      const lhs = this._ast.nodeLhs(this._i);
      if (lhs !== NONE && this._ast._tokEnds) {
        // Compound hyphenated name (e.g. "aria-fake"): lhs is last token index.
        const ast = this._ast;
        const start = ast._tokStarts[ast._mainTokens[this._i]];
        const end = ast._tokEnds[lhs];
        return ast.source.slice(start, end);
      }
      return this._ast._identAt(this._ast._mainTokens[this._i]);
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
    // JSXNamespacedName.name (local part, rhs)
    if (t === T.jsx_namespaced_name) {
      const idx = this._ast.nodeRhs(this._i);
      return idx !== NONE ? nodeView(this._ast, idx) : null;
    }
    // TSTypeParameter.name — synthetic Identifier from main_token
    if (t === T.ts_type_parameter) {
      const ast = this._ast;
      const tok = ast._mainTokens[this._i];
      const ps = ast._tokStarts[tok];
      const pe = ast._tokEnds ? ast._tokEnds[tok] : ps + ast._identAt(tok).length;
      const nameStr = _resolveUnicodeEscapes(ast._identAt(tok));
      const id = _syntheticNode('Identifier', ps, pe, { name: nameStr, parent: this }, ast);
      return id;
    }
    return undefined;
  },

  /**
   * node.value — literal value, or FunctionExpression for methods/properties.
   * Returns raw source text for strings (including quotes), parsed number,
   * boolean, or null. ESLint returns the evaluated value; we approximate.
   */
  get value() {
    const _synthBundle = _getSynth(this);
    if ('value' in _synthBundle) return _synthBundle.value;
    let v;
    let t = this._tag;
    const ast = this._ast;
    const src = ast._rawTokenText(this.mainToken);
    // property_literal is a Literal whose main_token is a string_literal token.
    // Reuse the string-literal decoding path.
    if (t === T.property_literal) t = T.string_literal;
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
      try { v = BigInt(src.slice(0, -1)); } catch { v = null; } // actual BigInt, typeof === 'bigint'
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
      // PropertyDefinition (class field) — rhs is PropertyData extra index.
      const rhs = ast.nodeRhs(this._i);
      const pd = rhs === NONE ? null : ast.extraPropertyData(rhs);
      const valIdx = pd ? pd.value : NONE;
      v = valIdx === NONE ? null : nodeView(ast, valIdx);
    } else if (t === T.method_def || t === T.getter_def || t === T.setter_def ||
        t === T.constructor_def || t === T.computed_method_def ||
        t === T.computed_getter_def || t === T.computed_setter_def) {
      // Method/getter/setter — return a synthetic FunctionExpression.
      // Cache externally (per-NodeView WeakMap) so rules can rely on
      // identity (`node.parent.value === node`) without polluting the
      // NodeView's own-property surface — that prevented IC monomorphism
      // and was the source of the invokeMethodFnHandlers range-mutation
      // bug class.
      const _synthBundle = _getSynth(this);
      if (_synthBundle.fn !== undefined) {
        v = _synthBundle.fn;
      } else {
        const md = ast.extraMethodData(ast.nodeRhs(this._i));
        const mods = md.modifiers;
        const isAsync = !!(mods & MOD_ASYNC);
        const isGenerator = !!(mods & MOD_GENERATOR);
        const params = ast._nodesFromRange(md.params_start, md.params_end);
        const returnType = md.return_type === NONE ? undefined : nodeView(ast, md.return_type);
        // FunctionExpression range starts at the `(` of params (NOT at the
        // method's start, which includes the key). ESLint rules like
        // object-shorthand's makeFunctionLongform use sourceCode.getTokensBetween(
        // key, value) to locate the `]` of computed keys; if value starts at the
        // method's start they get an empty range and crash.
        const methodRange = this.range;
        const src = ast.source;
        let fnStart = methodRange[0];
        const keyIdx = ast.nodeLhs(this._i);
        const keyEnd = keyIdx !== NONE ? ast._nodeEndPos(keyIdx) : methodRange[0];
        let probe = keyEnd;
        while (probe < src.length && src.charCodeAt(probe) !== 0x28 /* ( */) probe++;
        if (probe < src.length) fnStart = probe;
        const myRange = [fnStart, methodRange[1]];
        const ls = ast._lineStarts();
        const _lineAt = (p) => { let lo = 0, hi = ls.length - 1; while (lo < hi) { const m = (lo + hi + 1) >> 1; if (ls[m] <= p) lo = m; else hi = m - 1; } return lo + 1; };
        const sl = _lineAt(myRange[0]);
        const el = _lineAt(myRange[1]);
        const myLoc = {
          start: { line: sl, column: myRange[0] - ls[sl - 1] },
          end:   { line: el, column: myRange[1] - ls[el - 1] },
        };
        // For TS overload/abstract methods: body is NONE.
        // Use type 'TSEmptyBodyFunctionExpression' (not 'FunctionExpression') so that
        // @typescript-eslint/no-useless-constructor skips it (its check is type === 'FunctionExpression').
        // Use body: null (matching @typescript-eslint/parser behavior) so that
        // hasOverloadSignatures's `member.value.body == null` check works correctly.
        const isBodyless = md.body === NONE;
        const body = isBodyless ? null : nodeView(ast, md.body);
        // Synthetic TSParameterProperty wrapping is no longer needed — the parser
        // now emits real ts_parameter_property AST nodes for modifier params.
        const synth = {
          type: isBodyless ? 'TSEmptyBodyFunctionExpression' : 'FunctionExpression',
          id: null,
          async: isAsync,
          generator: isGenerator,
          params: params || [],
          body,
          returnType,
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
        _synthBundle.fn = synth;
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
    } else if (t === T.jsx_text_node || t === T.jsx_gap_node) {
      // JSXText: value is the raw text content between tags.
      // jsx_gap_node: range fully overridden by napi.zig (lhs/rhs = byte offsets).
      // jsx_text_node: range always overridden by napi.zig (lhs = next_tok, rhs = leading gap start).
      // Use this.range in all cases.
      const r = this.range;
      v = ast.source.slice(r[0], r[1]);
    } else if (t === T.jsx_attribute) {
      // JSXAttribute: value is the rhs (string literal, expression container, or null)
      const rhs = ast.nodeRhs(this._i);
      v = rhs === NONE ? null : nodeView(ast, rhs);
    } else {
      v = null;
    }
    _synthBundle.value = v;
    return v;
  },

  /**
   * node.raw — raw literal source text (for Literal nodes).
   */
  get raw() {
    // JSXText nodes: raw text always from position range (set by napi.zig).
    if (this._tag === T.jsx_gap_node || this._tag === T.jsx_text_node) {
      const r = this.range;
      return this._ast.source.slice(r[0], r[1]);
    }
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
    // Use nodeViewChain: the test is a boolean context, so optional chains
    // at the top level must be wrapped in ChainExpression (e.g., `if (a?.b)`)
    if (t === T.if_stmt || t === T.if_else_stmt || t === T.while_stmt) {
      return lhs === NONE ? null : nodeViewChain(ast, lhs);
    }
    if (t === T.do_while_stmt) {
      return rhs === NONE ? null : nodeViewChain(ast, rhs);
    }
    if (t === T.for_stmt) {
      const d = ast.extraForData(lhs);
      return d.condition === NONE ? null : nodeViewChain(ast, d.condition);
    }
    if (t === T.conditional) {
      return lhs === NONE ? null : nodeViewChain(ast, lhs);
    }
    if (t === T.switch_case) {
      return lhs === NONE ? null : nodeViewChain(ast, lhs);
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
    const _synthBundle = _getSynth(this);
    if ('body' in _synthBundle) return _synthBundle.body;
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
        t === T.generator_fn_expr || t === T.async_generator_fn_expr ||
        t === T.ts_declare_function) {
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
      // class_body is a real node now — return it directly
      const d = ast.extraClassData(lhs);
      result = d.body === NONE ? null : nodeView(ast, d.body);
    } else if (t === T.class_body) {
      // class_body.body = array of member nodes
      result = ast._nodesFromRange(lhs, rhs);
    } else if (t === T.root) {
      result = ast._nodesFromRange(lhs, rhs);
    } else if (t === T.ts_interface_decl) {
      // TSInterfaceDeclaration.body → synthetic TSInterfaceBody { type, body: members[] }
      const d = ast.extraInterfaceData(lhs);
      const memberIdxs = ast._extraData.subarray(d.body_start, d.body_end);
      const members = [];
      for (let mi = 0; mi < memberIdxs.length; mi++) {
        const n = nodeView(ast, memberIdxs[mi]);
        // Type is derived from the node tag (ts_method_signature, ts_property_signature, etc.)
        // No need to set n._type — the tag-based type getter handles it.
        members.push(n);
      }
      const bodyStart = members.length > 0 ? members[0].start : this.end;
      const bodyEnd   = members.length > 0 ? members[members.length - 1].end : this.end;
      result = _syntheticNode('TSInterfaceBody', bodyStart, bodyEnd, { body: members, parent: this }, ast);
    } else if (t === T.ts_enum_decl) {
      // TSEnumDeclaration.body → synthetic TSEnumBody { type, members: TSEnumMember[] }
      const d = ast.extraEnumData(lhs);
      const memberIdxs = ast._extraData.subarray(d.members_start, d.members_end);
      const members = [];
      for (let mi = 0; mi < memberIdxs.length; mi++) members.push(nodeView(ast, memberIdxs[mi]));
      const bodyStart = members.length > 0 ? members[0].start : this.end;
      const bodyEnd   = members.length > 0 ? members[members.length - 1].end : this.end;
      result = _syntheticNode('TSEnumBody', bodyStart, bodyEnd, { members, parent: this }, ast);
      // Back-ref: TSEnumMember.parent must return TSEnumBody, not TSEnumDeclaration.
      // Set _syntheticEnumBody on each member so the parent getter can intercept it.
      for (const m of members) m._syntheticEnumBody = result;
    } else if (t === T.ts_module_decl || t === T.ts_namespace_decl) {
      result = rhs === NONE ? null : nodeView(ast, rhs);
    }
    _synthBundle.body = result;
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
    // Node types without 'left' property (VariableDeclarator, etc.) return undefined
    // so that `node.left !== void 0` correctly distinguishes them from AssignmentExpression.
    return undefined;
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
    // All unary operators wrap optional-chain arguments in ChainExpression.
    // ESLint rules (no-import-assign, no-extra-boolean-cast, no-unsafe-optional-chaining)
    // traverse into argument and rely on the ChainExpression wrapper.
    if (t === T.await_expr || t === T.unary_plus || t === T.unary_minus ||
        t === T.logical_not || t === T.bitwise_not || t === T.typeof_expr || t === T.void_expr ||
        t === T.delete_expr || t === T.prefix_inc || t === T.prefix_dec ||
        t === T.postfix_inc || t === T.postfix_dec) {
      const idx = lhs(a);
      return idx === NONE ? null : nodeViewChain(a, idx);
    }
    if (t === T.ts_non_null_expr) {
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
      let idx = this._ast.nodeLhs(this._i);
      if (idx === NONE) return null;
      // TS: `Promise<void>(...)` and `new Foo<T>(...)` — when the callee is a
      // TSInstantiationExpression, @typescript-eslint exposes the underlying
      // expression on CallExpression.callee and lifts typeArguments to the
      // call/new directly. Unwrap here for ESLint-rule compatibility.
      if (this._ast._nodeTags[idx] === T.ts_instantiation_expr) {
        const inner = this._ast.nodeLhs(idx);
        if (inner !== NONE) {
          // `new Foo<T>()` pattern: call_expr(ts_instantiation_expr(new_expr(callee,NONE))).
          // The new_expr has no args (NONE rhs) — args belong to the outer call_expr.
          // Unwrap both wrappers to expose Foo (the identifier) as callee.
          if (this._ast._nodeTags[inner] === T.new_expr && this._ast.nodeRhs(inner) === NONE) {
            const newCallee = this._ast.nodeLhs(inner);
            if (newCallee !== NONE) idx = newCallee;
          } else {
            idx = inner;
          }
        }
      }
      // Use nodeViewChain so optional chain callees are wrapped in ChainExpression.
      // ESLint rules (no-unsafe-optional-chaining, no-prototype-builtins, etc.) use
      // astUtils.skipChainExpression(node.callee) to handle ChainExpression.
      return nodeViewChain(this._ast, idx);
    }
    return undefined;
  },

  /**
   * node.arguments — array of argument NodeViews.
   * CallExpression, NewExpression
   */
  get arguments() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.args !== undefined) return _synthBundle.args;
    const t = this._tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    let result;
    if (t === T.call_expr || t === T.optional_call_expr) {
      const sub = ast.extraSubRange(rhs);
      result = [];
      const e = ast._extraData;
      for (let i = sub.start; i < sub.end; i++) {
        const idx = e[i];
        if (idx !== NONE) result.push(nodeViewChain(ast, idx));
      }
    } else if (t === T.new_expr) {
      if (rhs === NONE) { _synthBundle.args = []; return []; }
      const sub = ast.extraSubRange(rhs);
      result = [];
      const e = ast._extraData;
      for (let i = sub.start; i < sub.end; i++) {
        const idx = e[i];
        if (idx !== NONE) result.push(nodeViewChain(ast, idx));
      }
    }
    _synthBundle.args = result;
    return result;
  },

  /**
   * node.object — object being accessed.
   * MemberExpression (all variants) and JSXMemberExpression.
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
    // JSXMemberExpression.object
    if (t === T.jsx_member_expr) {
      const idx = this._ast.nodeLhs(this._i);
      return idx !== NONE ? nodeView(this._ast, idx) : null;
    }
    return undefined;
  },

  /**
   * node.property — property being accessed.
   * Dot access: rhs is a real property_ident (or identifier for #private) node.
   * Computed access: returns NodeView of the expression.
   */
  get property() {
    const t = this._tag;
    const ast = this._ast;
    const rhs = ast.nodeRhs(this._i);
    if (t === T.member_expr || t === T.optional_member_expr) {
      // rhs is a node index to a property_ident (or identifier for private).
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.computed_member_expr || t === T.optional_computed_member_expr) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // Property node: key
    if (t === T.property) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.computed_property) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // MetaProperty: new.target → property = real property_ident("target")
    if (t === T.new_target || t === T.import_meta) {
      const propIdx = ast.nodeRhs(this._i);
      return propIdx === NONE ? null : nodeView(ast, propIdx);
    }
    // JSXMemberExpression.property
    if (t === T.jsx_member_expr) {
      const idx = ast.nodeRhs(this._i);
      return idx !== NONE ? nodeView(ast, idx) : null;
    }
    return undefined;
  },

  /**
   * node.computed — true for computed member/property access.
   * JSXMemberExpression.computed is always false.
   */
  get computed() {
    const t = this._tag;
    if (t === T.jsx_member_expr) return false;
    if (t === T.computed_member_expr || t === T.optional_computed_member_expr ||
        t === T.computed_property || t === T.computed_method_def ||
        t === T.computed_property_def || t === T.computed_getter_def ||
        t === T.computed_setter_def) return true;
    // TS interface members: detect computed-key signatures (`['f'](): void`,
    // `[Symbol.iterator]: T`) by checking whether the byte before the key is `[`.
    if (t === T.ts_method_signature || t === T.ts_property_signature) {
      const ast = this._ast;
      const key = this.key;
      if (!key) return false;
      const keyStart = key.start ?? key.range?.[0];
      if (keyStart == null || keyStart <= 0) return false;
      return ast.source.charCodeAt(keyStart - 1) === 0x5B /* [ */;
    }
    return false;
  },

  /**
   * node.override — true for TS override methods/properties.
   * Detected by checking if 'override' keyword precedes the method name.
   */
  get readonly() {
    const t = this._tag;
    const ast = this._ast;
    // TSParameterProperty: scan forward from main_token
    if (t === T.ts_parameter_property) {
      const mt = ast._mainTokens[this._i];
      for (let i = mt; i < mt + 4; i++) {
        const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
        if (val === 'readonly') return true;
        if (val !== 'public' && val !== 'private' && val !== 'protected' && val !== 'override') break;
      }
      return false;
    }
    // TSPropertySignature: the parser sets main_token to `readonly` when present,
    // otherwise to the property name. Check if the main token text is `readonly`.
    if (t === T.ts_property_signature) {
      const mt = ast._mainTokens[this._i];
      const val = ast.source.slice(ast._tokStarts[mt], ast._tokEnds[mt]);
      return val === 'readonly';
    }
    // TSIndexSignature: main_token is `[`. Check if the preceding token is `readonly`.
    if (t === T.ts_index_signature) {
      const mt = ast._mainTokens[this._i];
      if (mt > 0) {
        const prev = mt - 1;
        const val = ast.source.slice(ast._tokStarts[prev], ast._tokEnds[prev]);
        if (val === 'readonly') return true;
      }
      return false;
    }
    if (t !== T.property_def && t !== T.computed_property_def &&
        t !== T.method_def && t !== T.computed_method_def) return undefined;
    const mt = this.mainToken;
    for (let i = mt - 1; i >= 0 && i >= mt - 6; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds ? ast._tokEnds[i] : ast._tokStarts[i + 1]);
      if (val === 'readonly') return true;
      if (val !== 'static' && val !== 'public' && val !== 'private' && val !== 'protected' &&
          val !== 'override' && val !== 'abstract' && val !== 'declare' && val !== 'accessor') break;
    }
    return false;
  },

  get override() {
    const t = this._tag;
    const ast = this._ast;
    // TSParameterProperty: scan forward from main_token
    if (t === T.ts_parameter_property) {
      const mt = ast._mainTokens[this._i];
      for (let i = mt; i < mt + 4; i++) {
        const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
        if (val === 'override') return true;
        if (val !== 'public' && val !== 'private' && val !== 'protected' && val !== 'readonly') break;
      }
      return false;
    }
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def) return undefined;
    const mt = this.mainToken;
    // Scan backwards for 'override' keyword before the method name
    for (let i = mt - 1; i >= 0 && i >= mt - 6; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === 'override') return true;
      if (val !== 'static' && val !== 'async' && val !== 'get' && val !== 'set' && val !== '*' &&
          val !== 'public' && val !== 'private' && val !== 'protected' && val !== 'readonly' &&
          val !== 'abstract' && val !== 'declare' && val !== 'accessor') break;
    }
    return false;
  },

  /**
   * node.accessibility — TS access modifier ('public'|'private'|'protected').
   */
  get accessibility() {
    const t = this._tag;
    const ast = this._ast;
    // TSParameterProperty: scan forward from main_token (first modifier)
    if (t === T.ts_parameter_property) {
      const mt = this._ast._mainTokens[this._i];
      for (let i = mt; i < mt + 4; i++) {
        const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
        if (val === 'public' || val === 'private' || val === 'protected') return val;
        if (val !== 'readonly' && val !== 'override') break;
      }
      return undefined;
    }
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def) return undefined;
    const mt = this.mainToken;
    for (let i = mt - 1; i >= 0 && i >= mt - 5; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === 'public' || val === 'private' || val === 'protected') return val;
      if (val !== 'static' && val !== 'async' && val !== 'override' && val !== 'readonly' &&
          val !== 'abstract' && val !== 'declare' && val !== 'accessor' &&
          val !== '*' && val !== 'get' && val !== 'set') break;
    }
    return undefined;
  },

  /**
   * node.decorators — TS/proposal decorators array.
   * Detected by scanning backward from the method/property for @ tokens.
   */
  get decorators() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.dec !== undefined) return _synthBundle.dec;
    const t = this._tag;
    // TS param/pattern nodes can have decorators (TSParameterProperty), return [] when none
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def &&
        t !== T.class_decl && t !== T.class_expr && t !== T.ts_parameter_property) {
      _synthBundle.dec = [];
      return [];
    }
    const ast = this._ast;
    const mt = this.mainToken;
    // Scan backward for @ tokens
    const decorators = [];
    for (let i = mt - 1; i >= 0; i--) {
      const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
      if (val === '@') {
        // @ followed by decorator name — use end of the expression (next meaningful token)
        const decEnd = (i + 1 < ast.tokenCount) ? ast._tokEnds[i + 1] : ast._tokEnds[i];
        const decStart = ast._tokStarts[i];
        const _ls = this._ast._lineStarts();
        const _sL = this._ast._findLineIdx(decStart);
        const _eL = this._ast._findLineIdx(decEnd > decStart ? decEnd - 1 : decStart);
        decorators.push({ type: 'Decorator', start: decStart, end: decEnd, range: [decStart, decEnd],
          loc: { start: { line: _sL + 1, column: decStart - _ls[_sL] }, end: { line: _eL + 1, column: decEnd - _ls[_eL] } } });
      } else if (val === ')') {
        // Skip decorator arguments: @dec(args) — walk back to matching '('
        let depth = 1;
        i--;
        while (i >= 0 && depth > 0) {
          const c = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
          if (c === ')') depth++;
          else if (c === '(') depth--;
          i--;
        }
        // i now points before '(' — check if this is a decorator name
        if (i >= 0) {
          const nameVal = ast.source.slice(ast._tokStarts[i], ast._tokEnds[i]);
          // Decorator name or member expression: skip so loop continues to find '@'
          if (nameVal !== '@') continue;
          // It's '@' directly before '(' — parameterless decorator with parens? Re-process.
          i++; // undo so the loop will see '@' next iteration
        }
      } else if (val === 'static' || val === 'async' || val === 'get' || val === 'set' || val === '*' ||
                 val === 'public' || val === 'private' || val === 'protected' || val === 'readonly' ||
                 val === 'abstract' || val === 'declare' || val === 'override' ||
                 val === 'export' || val === 'default') {
        continue; // skip modifiers and export keywords between decorator and class name
      } else if (val === '.') {
        // Member expression in decorator: @ns.Dec — skip dot and continue
        continue;
      } else {
        // Could be a decorator name/identifier — peek backward past dots and identifiers to find '@'
        let isDecoratorPart = false;
        let j = i - 1;
        while (j >= 0) {
          const prev = ast.source.slice(ast._tokStarts[j], ast._tokEnds[j]);
          if (prev === '.') { j--; continue; }  // skip dots in member expressions
          if (prev === '@') { isDecoratorPart = true; break; }
          // Another identifier in the chain (e.g. 'ns' in @ns.Dec)
          if (/^[_$a-zA-Z]/.test(prev)) { j--; continue; }
          break;
        }
        if (isDecoratorPart) continue; // part of a decorator expression, keep scanning
        break; // not a decorator or modifier
      }
    }
    const result = decorators.length > 0 ? decorators : [];
    _synthBundle.dec = result;
    return result;
  },

  /**
   * node.optional — true for optional chaining.
   */
  get optional() {
    const t = this._tag;
    // For interface method param identifiers, lhs=0 (root sentinel) means optional.
    if (t === T.identifier) {
      const lhs = this._ast.nodeLhs(this._i);
      return lhs === 0 ? true : undefined;
    }
    // PropertyDefinition with TS optional marker `?` (e.g. `class C { a?: number = 5 }`)
    if (t === T.property_def || t === T.computed_property_def) {
      const rhs = this._ast.nodeRhs(this._i);
      if (rhs !== NONE) {
        const pd = this._ast.extraPropertyData(rhs);
        return pd.optional === 1 ? true : false;
      }
      return false;
    }
    // TS interface/type-literal members: `f?(…)` (TSMethodSignature) and
    // `a?: T` (TSPropertySignature). The parser doesn't pre-bake an optional
    // flag for these — scan source forward from the key end and check whether
    // the next non-whitespace token is `?`.
    if (t === T.ts_method_signature || t === T.ts_property_signature) {
      const ast = this._ast;
      const src = ast.source;
      const key = this.key;
      if (!key || typeof key.end !== 'number') return false;
      let i = key.end;
      const n = src.length;
      while (i < n) {
        const c = src.charCodeAt(i);
        if (c === 32 || c === 9 || c === 10 || c === 13) { i++; continue; }
        return c === 63 /* ? */;
      }
      return false;
    }
    return t === T.optional_member_expr || t === T.optional_computed_member_expr ||
           t === T.optional_call_expr;
  },

  /** ImportExpression.options — second argument to dynamic import(), or null. */
  get options() {
    if (this._tag !== T.import_expr) return undefined;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? null : nodeView(this._ast, rhs);
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
   * node.await — true for for-await-of statements.
   * ESLint's ForOfStatement.await property distinguishes `for await (...)`.
   */
  get await() {
    return this._tag === T.for_await_of_stmt ? true : undefined;
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
        t === T.generator_fn_expr || t === T.async_generator_fn_expr ||
        t === T.ts_declare_function) {
      const d = ast.extraFnData(lhs);
      return d.name === NONE ? null : nodeView(ast, d.name);
    }
    if (t === T.class_decl || t === T.class_expr) {
      const d = ast.extraClassData(lhs);
      return d.name === NONE ? null : nodeView(ast, d.name);
    }
    // TSInterfaceDeclaration / TSTypeAliasDeclaration: real Identifier node
    // stored in rhs (created by the parser specifically so it has a stable
    // AST identity for the scope declare event — defs[0].node.parent
    // === declaration).
    if (t === T.ts_interface_decl || t === T.ts_type_alias_decl) {
      const rhsId = ast.nodeRhs(this._i);
      if (rhsId !== NONE) return nodeView(ast, rhsId);
      // Fallback: legacy token-based identifier (no parent chain).
      const name_tok = ast._extraData[lhs];
      return _tokenIdentifier(ast, name_tok);
    }
    // TSEnumDeclaration: still token-based for now.
    if (t === T.ts_enum_decl) {
      const name_tok = ast._extraData[lhs];
      return _tokenIdentifier(ast, name_tok);
    }
    // TSModuleDeclaration / TSNamespaceDeclaration: id is lhs (Identifier node).
    if (t === T.ts_module_decl || t === T.ts_namespace_decl) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // TSEnumMember: id is lhs (Identifier or StringLiteral).
    if (t === T.ts_enum_member) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // TSImportEqualsDeclaration: id is the bound identifier (`foo` in `import foo = ...`).
    // Stored as import_decl with lhs=NONE, rhs=module_ref. The name is the token
    // immediately after `import` (or after `import type` for type imports).
    if (t === T.import_decl && lhs === NONE && ast.nodeRhs(this._i) !== NONE) {
      const mt = ast._mainTokens[this._i]; // 'import' token
      let nameTok = mt + 1;
      // Skip optional 'type' keyword
      const nameText = ast._rawTokenText(nameTok);
      if (nameText === 'type') nameTok++;
      return _tokenIdentifier(ast, nameTok);
    }
    return undefined;
  },

  /**
   * node.typeName — qualified name of TSTypeReference (Identifier or TSQualifiedName).
   * For qualified types like `React.FC`, the parser emits a member_expr chain.
   * ESTree rules expect a TSQualifiedName with .left/.right instead of MemberExpression.
   */
  get typeName() {
    if (this._tag !== T.ts_type_reference) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    if (lhs !== NONE) {
      const lhsTag = this._ast._nodeTags[lhs];
      // Literal types: lhs is a real literal or unary_minus node — TSLiteralType has no typeName
      if (lhsTag === T.number_literal || lhsTag === T.bigint_literal ||
          lhsTag === T.string_literal || lhsTag === T.boolean_literal ||
          lhsTag === T.unary_minus) return undefined;
      // member_expr in type position = qualified name: convert to TSQualifiedName
      // e.g. `React.FC` → TSQualifiedName { left: Identifier("React"), right: Identifier("FC") }
      if (lhsTag === T.member_expr) return _memberToQualifiedName(this._ast, lhs);
      return nodeView(this._ast, lhs);
    }
    // No separate name node (e.g., `as const` / `as readonly`): synthesize Identifier
    // from the source text so rules can access node.typeName.type and node.typeName.name.
    const start = this.start;
    const end = this.end;
    const name = this._ast.source.slice(start, end);
    return _syntheticNode('Identifier', start, end, { name }, this._ast);
  },

  /**
   * node.exprName — the identifier/qualified name of a TSTypeQuery (`typeof X`).
   * ESTree rules access returnType.exprName.name when returnType is TSTypeQuery.
   * lhs is the ts_type_reference node wrapping the operand; its typeName is the name.
   */
  get exprName() {
    if (this._tag !== 172 /* ts_typeof_type */) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    if (lhs === NONE) return undefined;
    // lhs is a ts_type_reference; return its typeName (Identifier or TSQualifiedName)
    const lhsTag = this._ast._nodeTags[lhs];
    if (lhsTag !== T.ts_type_reference) return nodeView(this._ast, lhs);
    const nameIdx = this._ast.nodeLhs(lhs);
    if (nameIdx === NONE) return undefined;
    const nameTag = this._ast._nodeTags[nameIdx];
    if (nameTag === T.member_expr) return _memberToQualifiedName(this._ast, nameIdx);
    return nodeView(this._ast, nameIdx);
  },

  /**
   * node.literal — for TSLiteralType nodes (TSTypeReference with a literal main token).
   * Returns a synthetic Literal node with the JS value.
   */
  get literal() {
    if (this._tag !== T.ts_type_reference || this._ast.nodeRhs(this._i) !== NONE) return undefined;
    // New: real literal child node stored in lhs (number/bigint/unary_minus for negative)
    const lhsForLit = this._ast.nodeLhs(this._i);
    if (lhsForLit !== NONE) {
      const lhsTag = this._ast._nodeTags[lhsForLit];
      if (lhsTag === T.number_literal || lhsTag === T.bigint_literal ||
          lhsTag === T.string_literal || lhsTag === T.boolean_literal ||
          lhsTag === T.unary_minus) {
        return nodeView(this._ast, lhsForLit);
      }
    }
    const ast = this._ast;
    const tok = ast._mainTokens[this._i];
    const start = ast._tokStarts[tok];
    const end = ast._tokEnds ? ast._tokEnds[tok]
      : (tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : ast.source.length);
    const text = ast.source.slice(start, end);
    const c = text.charCodeAt(0);
    let value;
    if (c === 39 || c === 34) {        // single/double quoted string
      value = text.slice(1, -1);
    } else if (c === 96) {             // template literal (strip backticks, ignore interpolation)
      value = text.slice(1, -1);
    } else if (c >= 48 && c <= 57) {   // number or bigint
      value = text.endsWith('n') ? BigInt(text.slice(0, -1)) : Number(text);
    } else if (text === 'true') {
      value = true;
    } else if (text === 'false') {
      value = false;
    } else if (c === 45) {             // negative number/bigint literal type (`-1`, `-1n`)
      // The '-' is the main token; the number is the NEXT token. typescript-eslint
      // models the `.literal` as a UnaryExpression(operator '-', argument: the
      // positive Literal). Ranges/value mirror the runner's TSLiteralType→Literal
      // synthesis so native rules (no-magic-numbers) are byte-identical.
      const numTok = tok + 1;
      if (numTok >= ast.tokenCount) return undefined;
      const numStart = ast._tokStarts[numTok];
      const numEnd = ast._tokEnds ? ast._tokEnds[numTok]
        : (numTok + 1 < ast.tokenCount ? ast._tokStarts[numTok + 1] : ast.source.length);
      const numText = ast.source.slice(numStart, numEnd);
      const numVal = numText.endsWith('n') ? BigInt(numText.slice(0, -1)) : Number(numText);
      if (typeof numVal !== 'bigint' && isNaN(numVal)) return undefined;
      const arg = _syntheticNode('Literal', numStart, numEnd, { value: numVal, raw: numText }, ast);
      const unary = _syntheticNode('UnaryExpression', start, numEnd, { operator: '-', prefix: true, argument: arg }, ast);
      arg.parent = unary;
      unary.parent = nodeView(this._ast, this._i); // the TSLiteralType node
      return unary;
    } else {
      return undefined; // not a literal type
    }
    return _syntheticNode('Literal', start, end, { value, raw: text }, ast);
  },

  /**
   * node.typeArguments — TSTypeParameterInstantiation for TSTypeReference.
   * Returns synthetic node { type: 'TSTypeParameterInstantiation', params: [...] }
   * or null if no type arguments.
   */
  /**
   * node.elementType — element type for TSArrayType.
   */
  get elementType() {
    if (this._tag !== T.ts_array_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    return lhs === NONE ? undefined : nodeView(this._ast, lhs);
  },

  /**
   * node.elementTypes — elements of TSTupleType (ts_tuple_type).
   * lhs/rhs encode the SubRange start/end into extra_data.
   */
  get elementTypes() {
    if (this._tag !== T.ts_tuple_type) return undefined;
    const ast = this._ast;
    const start = ast.nodeLhs(this._i);
    const end   = ast.nodeRhs(this._i);
    return ast._nodesFromRange(start, end);
  },

  get typeArguments() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.ta !== undefined) return _synthBundle.ta;
    const tag = this._tag;
    // CallExpression / NewExpression with a TSInstantiationExpression callee:
    // hoist typeArguments from the wrapper to match @typescript-eslint shape.
    if (tag === T.call_expr || tag === T.optional_call_expr || tag === T.new_expr) {
      const lhs = this._ast.nodeLhs(this._i);
      if (lhs !== NONE && this._ast._nodeTags[lhs] === T.ts_instantiation_expr) {
        const wrapperRhs = this._ast.nodeRhs(lhs);
        if (wrapperRhs === NONE) { _synthBundle.ta = null; return null; }
        const sub = this._ast.extraSubRange(wrapperRhs);
        const params = this._ast._nodesFromRange(sub.start, sub.end);
        const src = this._ast.source;
        let tStart = this.start, tEnd = this.end;
        if (params.length > 0) {
          tStart = params[0].start;
          while (tStart > 0 && src.charCodeAt(tStart - 1) !== 0x3C) tStart--;
          if (tStart > 0) tStart--;
          tEnd = params[params.length - 1].end;
          while (tEnd < src.length && src.charCodeAt(tEnd) !== 0x3E) tEnd++;
          if (tEnd < src.length) tEnd++;
        }
        const synth = _syntheticNode('TSTypeParameterInstantiation', tStart, tEnd, { params, parent: this }, this._ast);
        for (const p of params) p._parent = synth;
        _synthBundle.ta = synth;
        return synth;
      }
      _synthBundle.ta = null;
      return null;
    }
    if (tag !== T.ts_type_reference && tag !== T.ts_instantiation_expr) { _synthBundle.ta = undefined; return undefined; }
    const rhs = this._ast.nodeRhs(this._i);
    if (rhs === NONE) { _synthBundle.ta = null; return null; }
    const sub = this._ast.extraSubRange(rhs);
    const params = this._ast._nodesFromRange(sub.start, sub.end);
    // Range = the `<...>` slice, not the whole TSTypeReference. Walk back from
    // the first param's start to find `<` and forward from the last param's end
    // to find `>` so sourceCode.getText(typeArguments) returns just `<args>`.
    const src = this._ast.source;
    let tStart = this.start;
    let tEnd = this.end;
    if (params.length > 0) {
      tStart = params[0].start;
      while (tStart > 0 && src.charCodeAt(tStart - 1) !== 0x3C /* < */) tStart--;
      if (tStart > 0) tStart--; // include the `<`
      tEnd = params[params.length - 1].end;
      while (tEnd < src.length && src.charCodeAt(tEnd) !== 0x3E /* > */) tEnd++;
      if (tEnd < src.length) tEnd++; // include the `>`
    }
    // For TSInstantiationExpression used as a call callee (f<T>(args)), the
    // TSTypeParameterInstantiation's ESTree parent should be the CallExpression,
    // matching what @typescript-eslint/parser produces.
    let synthParent = this;
    if (tag === T.ts_instantiation_expr && this._ast._parentData) {
      const callerIdx = this._ast._parentData[this._i];
      if (callerIdx !== undefined && callerIdx !== NONE) {
        const callerTag = this._ast._nodeTags[callerIdx];
        if (callerTag === T.call_expr || callerTag === T.optional_call_expr || callerTag === T.new_expr) {
          synthParent = nodeView(this._ast, callerIdx);
        }
      }
    }
    const synth = _syntheticNode('TSTypeParameterInstantiation', tStart, tEnd, { params, parent: synthParent }, this._ast);
    // Set each param's parent to the TSTypeParameterInstantiation
    for (const p of params) p._parent = synth;
    _synthBundle.ta = synth;
    return synth;
  },

  /**
   * node.types — constituent types of TSUnionType or TSIntersectionType.
   * Returns array of type NodeViews.
   */
  get types() {
    const t = this._tag;
    if (t !== T.ts_union_type && t !== T.ts_intersection_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    const rhs = this._ast.nodeRhs(this._i);
    return this._ast._nodesFromRange(lhs, rhs);
  },

  /** TSConditionalType.checkType / extendsType / trueType / falseType — the
   * 4 child types of `T extends U ? X : Y`. Stored as a packed extra-data
   * range [check, extends, true, false] (see typescript.zig). */
  get checkType() {
    if (this._tag !== T.ts_conditional_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    const idx = this._ast._extraData[lhs];
    return idx === NONE ? null : nodeView(this._ast, idx);
  },
  get extendsType() {
    if (this._tag !== T.ts_conditional_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    const idx = this._ast._extraData[lhs + 1];
    return idx === NONE ? null : nodeView(this._ast, idx);
  },
  get trueType() {
    if (this._tag !== T.ts_conditional_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    const idx = this._ast._extraData[lhs + 2];
    return idx === NONE ? null : nodeView(this._ast, idx);
  },
  get falseType() {
    if (this._tag !== T.ts_conditional_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    const idx = this._ast._extraData[lhs + 3];
    return idx === NONE ? null : nodeView(this._ast, idx);
  },

  /** TSIndexedAccessType.objectType / indexType — `T[K]`. lhs=objectType, rhs=indexType. */
  get objectType() {
    if (this._tag !== T.ts_indexed_access_type) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    return lhs === NONE ? null : nodeView(this._ast, lhs);
  },
  get indexType() {
    if (this._tag !== T.ts_indexed_access_type) return undefined;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? null : nodeView(this._ast, rhs);
  },

  /**
   * node.typeParameters — TSTypeParameterDeclaration for generic declarations.
   * Used by: TSTypeAliasDeclaration, TSInterfaceDeclaration, function declarations, class declarations.
   * Returns null when there are no type parameters.
   */
  get typeParameters() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.tp !== undefined) return _synthBundle.tp;
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    let tp_start, tp_end;
    if (t === T.ts_type_alias_decl) {
      const d = ast.extraTypeAliasData(lhs);
      tp_start = d.type_params; tp_end = d.type_params_end;
    } else if (t === T.ts_interface_decl) {
      const d = ast.extraInterfaceData(lhs);
      tp_start = d.type_params; tp_end = d.type_params_end;
    } else if (t === T.fn_decl || t === T.async_fn_decl ||
               t === T.fn_expr || t === T.async_fn_expr ||
               t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
               t === T.generator_fn_expr || t === T.async_generator_fn_expr ||
               t === T.ts_function_type || t === T.ts_constructor_type ||
               t === T.ts_declare_function) {
      if (lhs === NONE) return null;
      const d = ast.extraFnData(lhs);
      tp_start = d.type_params; tp_end = d.type_params_end;
    } else if (t === T.class_decl || t === T.class_expr) {
      if (lhs === NONE) return null;
      const d = ast.extraClassData(lhs);
      tp_start = d.type_params; tp_end = d.type_params_end;
    } else if (t === T.ts_method_signature || t === T.ts_call_signature ||
               t === T.ts_construct_signature) {
      if (lhs === NONE) return null;
      const d = ast.extraInterfaceSigData(lhs);
      tp_start = d.type_params; tp_end = d.type_params_end;
    } else {
      return null;
    }
    if (tp_start === undefined || tp_start >= tp_end) { _synthBundle.tp = null; return null; }
    const params = [];
    let rangeStart = Infinity, rangeEnd = 0;
    for (let i = tp_start; i < tp_end; i++) {
      const paramIdx = ast._extraData[i];
      const pv = nodeView(ast, paramIdx);
      if (pv.start < rangeStart) rangeStart = pv.start;
      if (pv.end > rangeEnd) rangeEnd = pv.end;
      params.push(pv);
    }
    // Include the angle brackets in the declaration's range — ESTree's
    // TSTypeParameterDeclaration spans `<…>`, not just the inner params.
    // Rules like @typescript-eslint/method-signature-style emit
    // `sourceCode.getText(typeParameters)` into their autofix; without the
    // brackets the fix produces `f: T(a: T) => T` instead of `f: <T>(…)`.
    if (rangeStart !== Infinity) {
      const src = ast.source;
      const isWs = c => c === 32 || c === 9 || c === 10 || c === 13;
      // Walk back over whitespace and block comments to find `<`.
      let s = rangeStart - 1;
      while (s >= 0) {
        const c = src.charCodeAt(s);
        if (isWs(c)) { s--; continue; }
        // Block-comment end `*/` — skip over the comment.
        if (c === 47 /* / */ && s > 0 && src.charCodeAt(s - 1) === 42 /* * */) {
          s -= 2;
          while (s > 0 && !(src.charCodeAt(s) === 42 && src.charCodeAt(s - 1) === 47)) s--;
          s -= 2; // skip past `/*`
          continue;
        }
        break;
      }
      if (s >= 0 && src.charCodeAt(s) === 60 /* < */) rangeStart = s;
      const srcLen = src.length;
      // Walk forward past whitespace/block-comments to find `>`.
      let e = rangeEnd;
      while (e < srcLen) {
        const c = src.charCodeAt(e);
        if (isWs(c)) { e++; continue; }
        if (c === 47 && e + 1 < srcLen && src.charCodeAt(e + 1) === 42) {
          e += 2;
          while (e + 1 < srcLen && !(src.charCodeAt(e) === 42 && src.charCodeAt(e + 1) === 47)) e++;
          e += 2; // skip past `*/`
          continue;
        }
        break;
      }
      if (e < srcLen && src.charCodeAt(e) === 62 /* > */) rangeEnd = e + 1;
    }
    const result = _syntheticNode('TSTypeParameterDeclaration',
      rangeStart === Infinity ? this.start : rangeStart,
      rangeEnd === 0 ? this.end : rangeEnd,
      { params, parent: this }, ast);
    for (const p of params) p._parent = result;
    _synthBundle.tp = result;
    return result;
  },

  /**
   * node.constraint — TSTypeParameter constraint clause (`extends T`).
   */
  get constraint() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.ts_type_parameter) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? undefined : nodeView(ast, lhs);
    }
    // TSMappedType.constraint — second slot in the extra-data range (`[K in T]` → T).
    if (t === T.ts_mapped_type) {
      const start = ast.nodeLhs(this._i);
      const cid = ast._extraData[start + 1];
      return (cid === NONE || cid === undefined) ? undefined : nodeView(ast, cid);
    }
    return undefined;
  },

  /**
   * node.default — TSTypeParameter default value (`= T`).
   */
  get default() {
    if (this._tag !== T.ts_type_parameter) return undefined;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? undefined : nodeView(this._ast, rhs);
  },

  /**
   * node.extends — heritage clauses of TSInterfaceDeclaration.
   * Returns array of TSExpressionWithTypeArguments NodeViews.
   */
  get extends() {
    const t = this._tag;
    if (t !== T.ts_interface_decl) return undefined;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const d = ast.extraInterfaceData(lhs);
    return ast._nodesFromRange(d.extends_start, d.extends_end);
  },

  /**
   * node.members — members of TSTypeLiteral (object type body).
   * Returns array of interface-member NodeViews.
   */
  get members() {
    const t = this._tag;
    if (t !== T.ts_type_literal) return undefined;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    const rhs = ast.nodeRhs(this._i);
    const memberIdxs = ast._extraData.subarray(lhs, rhs);
    const members = [];
    for (let mi = 0; mi < memberIdxs.length; mi++) {
      // Type is derived from the node tag — no need to set n._type.
      members.push(nodeView(ast, memberIdxs[mi]));
    }
    return members;
  },

  /**
   * node.params — parameter list of function/arrow.
   * Returns array of NodeViews.
   */
  get params() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.params !== undefined) return _synthBundle.params;
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    let result;
    if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr ||
        t === T.ts_declare_function) {
      const d = ast.extraFnData(lhs);
      result = ast._nodesFromRange(d.params, d.params_end);
    } else if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const d = ast.extraArrowData(lhs);
      result = ast._nodesFromRange(d.params_start, d.params_end);
    } else if (t === T.ts_function_type || t === T.ts_constructor_type) {
      if (lhs === NONE) { _synthBundle.params = []; return []; }
      const d = ast.extraFnData(lhs);
      result = ast._nodesFromRange(d.params, d.params_end);
    } else if (t === T.ts_call_signature || t === T.ts_construct_signature || t === T.ts_method_signature) {
      if (lhs === NONE) { _synthBundle.params = []; return []; }
      const d = ast.extraInterfaceSigData(lhs);
      result = ast._nodesFromRange(d.params_start, d.params_end);
    }
    _synthBundle.params = result;
    return result;
  },

  /**
   * node.parameters — TSIndexSignature / TSCallSignature / TSConstructSignature / TSMethodSignature parameter list.
   * TSIndexSignature: lhs holds the identifier.
   * TSCallSignature/TSConstructSignature/TSMethodSignature: lhs = InterfaceSigData extra index.
   */
  get parameters() {
    const t = this._tag;
    if (t === T.ts_index_signature) {
      const lhs = this._ast.nodeLhs(this._i);
      return lhs === NONE ? [] : [nodeView(this._ast, lhs)];
    }
    if (t === T.ts_call_signature || t === T.ts_construct_signature || t === T.ts_method_signature) {
      const lhs = this._ast.nodeLhs(this._i);
      if (lhs === NONE) return [];
      const d = this._ast.extraInterfaceSigData(lhs);
      return this._ast._nodesFromRange(d.params_start, d.params_end);
    }
    // Legacy fallback for old ts_type_annotation-encoded interface members
    if (t !== T.ts_type_annotation) return undefined;
    const ast = this._ast;
    const mt = ast._mainTokens[this._i];
    const c = ast.source.charCodeAt(ast._tokStarts[mt]);
    if (c === 91) { // '[' → TSIndexSignature
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? [] : [nodeView(ast, lhs)];
    }
    // '(' → TSCallSignatureDeclaration, 'n' → TSConstructSignatureDeclaration
    if (c === 40 || c === 110) return [];
    return undefined;
  },

  /**
   * node.parameter — TSParameterProperty inner binding.
   */
  get parameter() {
    if (this._tag !== T.ts_parameter_property) return undefined;
    const lhs = this._ast.nodeLhs(this._i);
    return lhs === NONE ? null : nodeView(this._ast, lhs);
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
    if (t === T.const_decl) {
      // 'await using' / 'using' declarations share const_decl tag; detect by main token.
      // tag 45 = kw_await → 'await using', tag 8 = identifier "using" → 'using'.
      const mainTok = this._ast._mainTokens[this._i];
      const tokTag = this._ast._tokTags[mainTok];
      if (tokTag === 45) return 'await using';
      if (tokTag === 8) return 'using';
      return 'const';
    }
    if (t === T.ts_namespace_decl) return 'namespace';
    if (t === T.ts_module_decl) return 'module';
    if (t === T.ts_method_signature) {
      const lhs = this._ast.nodeLhs(this._i);
      if (lhs !== NONE) {
        const d = this._ast.extraInterfaceSigData(lhs);
        if (d.kind === 1) return 'get';
        if (d.kind === 2) return 'set';
      }
      return 'method';
    }
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
        if (!(_nodeMods(ast, this._i) & MOD_STATIC)) {
          const rawText = ast._rawTokenText(mainTok);
          // identifier token (tag 8) with text "constructor"
          // or string literal 'constructor'/"constructor" — both name the constructor
          if (rawText === 'constructor' ||
              rawText === "'constructor'" || rawText === '"constructor"') {
            return 'constructor';
          }
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
    const t = this._tag;
    const ast = this._ast;
    // Fast path: Identifier nodes store type annotation in rhs (function/interface params).
    if (t === T.identifier) {
      const rhs = ast.nodeRhs(this._i);
      return rhs === NONE ? undefined : nodeView(ast, rhs);
    }
    if (t === T.ts_type_annotation) {
      // Distinguish TSTypeAnnotation wrapper (main_token = ':', charCode 58) from interface
      // member nodes (TSPropertySignature/TSMethodSignature, main_token = member name).
      // Wrapper: return inner type (lhs). Interface member: return type annotation (rhs).
      const mt = ast._mainTokens[this._i];
      if (ast.source.charCodeAt(ast._tokStarts[mt]) === 58) { // ':'
        const idx = ast.nodeLhs(this._i);
        return idx === NONE ? undefined : nodeView(ast, idx);
      }
      const idx = ast.nodeRhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // New interface member tags: ts_property_signature rhs is type annotation
    if (t === T.ts_property_signature || t === T.ts_index_signature) {
      const idx = ast.nodeRhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // PropertyDefinition: rhs = PropertyData extra index; type_annotation is stored there.
    if (t === T.property_def || t === T.computed_property_def) {
      const rhs = ast.nodeRhs(this._i);
      if (rhs === NONE) return undefined;
      const pd = ast.extraPropertyData(rhs);
      return pd.type_annotation === NONE ? undefined : nodeView(ast, pd.type_annotation);
    }
    // TSTypeAliasDeclaration: typeAnnotation = the aliased type
    if (t === T.ts_type_alias_decl) {
      const d = ast.extraTypeAliasData(ast.nodeLhs(this._i));
      return d.type_node === NONE ? undefined : nodeView(ast, d.type_node);
    }
    // TSAsExpression / TSSatisfiesExpression: typeAnnotation = rhs (the cast type)
    if (t === T.ts_as_expr || t === T.ts_satisfies_expr) {
      const idx = ast.nodeRhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // TSTypeAssertion (<Type>expr): typeAnnotation = lhs (the type)
    if (t === T.ts_type_assertion) {
      const idx = ast.nodeLhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // TSTypeOperator (ts_keyof_type: keyof T / readonly T): typeAnnotation = lhs (inner type)
    if (t === T.ts_keyof_type) {
      const idx = ast.nodeLhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // TSMappedType.typeAnnotation — fourth slot in extra-data range (value type after `:`).
    if (t === T.ts_mapped_type) {
      const start = ast.nodeLhs(this._i);
      const vid = ast._extraData[start + 3];
      return (vid === NONE || vid === undefined) ? undefined : nodeView(ast, vid);
    }
    // RestElement: rhs = type annotation (e.g. `...[a]: string[]`)
    if (t === T.rest_element) {
      const idx = ast.nodeRhs(this._i);
      return idx === NONE ? undefined : nodeView(ast, idx);
    }
    // ArrayPattern / ObjectPattern in a VariableDeclarator: the type annotation is parsed
    // after the pattern elements but the declarator node stores lhs=binding, rhs=init.
    // The ts_type_annotation node sits between pattern end and init in the node array.
    if (t === T.array_pattern || t === T.object_pattern) {
      const parent = ast._parentData ? ast._parentData[this._i] : NONE;
      if (parent !== NONE && ast._nodeTags[parent] === T.declarator) {
        const init = ast.nodeRhs(parent);
        const startScan = this._i + 1;
        const endScan = init !== NONE ? init : ast.nodeCount;
        for (let c = startScan; c < endScan; c++) {
          if (ast._nodeTags[c] === T.ts_type_annotation) return nodeView(ast, c);
        }
      }
    }
    // General case: find a TSTypeAnnotation child
    const pd = ast._parentData;
    if (!pd) return undefined;
    const myIdx = this._i;
    for (let c = myIdx + 1; c < ast.nodeCount; c++) {
      if (pd[c] !== myIdx) continue;
      if (ast._nodeTags[c] === T.ts_type_annotation) return nodeView(ast, c);
    }
    return undefined;
  },

  /**
   * node.returnType — TS return type annotation on functions/arrows/methods.
   * Returns the TSTypeAnnotation NodeView or undefined.
   */
  get returnType() {
    const t = this._tag;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr ||
        t === T.ts_declare_function) {
      const d = ast.extraFnData(lhs);
      return d.return_type === NONE ? undefined : nodeView(ast, d.return_type);
    }
    if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const d = ast.extraArrowData(lhs);
      return d.return_type === NONE ? undefined : nodeView(ast, d.return_type);
    }
    if (t === T.method_def || t === T.computed_method_def ||
        t === T.getter_def || t === T.setter_def ||
        t === T.computed_getter_def || t === T.computed_setter_def ||
        t === T.constructor_def) {
      const d = ast.extraMethodData(ast.nodeRhs(this._i));
      return d.return_type === NONE ? undefined : nodeView(ast, d.return_type);
    }
    // TS interface member signatures: return_type from InterfaceSigData
    if (t === T.ts_method_signature || t === T.ts_call_signature || t === T.ts_construct_signature) {
      const lhs2 = ast.nodeLhs(this._i);
      if (lhs2 === NONE) return undefined;
      const d2 = ast.extraInterfaceSigData(lhs2);
      return d2.return_type === NONE ? undefined : nodeView(ast, d2.return_type);
    }
    // TSFunctionType / TSConstructorType: body field stores raw return type; wrap in synthetic TSTypeAnnotation.
    if (t === T.ts_function_type || t === T.ts_constructor_type) {
      if (lhs === NONE) return undefined;
      const _synthBundle = _getSynth(this);
      if (_synthBundle.rt !== undefined) return _synthBundle.rt;
      const d = ast.extraFnData(lhs);
      if (d.body === NONE) { _synthBundle.rt = null; return undefined; }
      const innerNode = nodeView(ast, d.body);
      if (!innerNode) { _synthBundle.rt = null; return undefined; }
      const synth = _syntheticNode('TSTypeAnnotation', innerNode.start, innerNode.end,
        { typeAnnotation: innerNode, parent: this }, ast);
      innerNode._parent = synth;  // fix parent chain: return-type node → TSTypeAnnotation
      _synthBundle.rt = synth;
      return synth;
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
        t !== T.ts_enum_decl &&
        t !== T.property_def && t !== T.computed_property_def &&
        t !== T.ts_namespace_decl && t !== T.ts_module_decl) return undefined;
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
   * node.abstract — true for TS abstract class members / abstract classes.
   */
  get abstract() {
    const t = this._tag;
    if (t !== T.method_def && t !== T.computed_method_def && t !== T.property_def &&
        t !== T.computed_property_def && t !== T.getter_def && t !== T.setter_def &&
        t !== T.computed_getter_def && t !== T.computed_setter_def && t !== T.constructor_def &&
        t !== T.class_decl && t !== T.class_expr) return undefined;
    // For class_decl/class_expr: check if 'abstract' precedes 'class' keyword via token scan
    if (t === T.class_decl || t === T.class_expr) {
      const ast = this._ast;
      const mt = this.mainToken;
      if (mt > 0 && ast._tokEnds && ast.source.slice(ast._tokStarts[mt - 1], ast._tokEnds[mt - 1]) === 'abstract') return true;
      return false;
    }
    // For property_def/computed_property_def: no extra data, use token scan
    if (t === T.property_def || t === T.computed_property_def) {
      const ast = this._ast;
      const mt = this.mainToken;
      for (let i = mt - 1; i >= 0 && i >= mt - 5; i--) {
        const val = ast.source.slice(ast._tokStarts[i], ast._tokEnds ? ast._tokEnds[i] : ast._tokStarts[i + 1]);
        if (val === 'abstract') return true;
        if (val !== 'static' && val !== 'public' && val !== 'private' && val !== 'protected' &&
            val !== 'override' && val !== 'readonly' && val !== 'declare') break;
      }
      return false;
    }
    // For methods: read from MethodData.modifiers
    return !!(_nodeMods(this._ast, this._i) & MOD_ABSTRACT);
  },

  /**
   * node.importKind — 'type' for `import type`, 'value' otherwise.
   */
  get importKind() {
    const t = this._tag;
    if (t !== T.import_decl && t !== T.import_specifier) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    if (t === T.import_decl) {
      // import type { ... } — 'type' token is immediately after 'import'
      if (mt + 1 < ast.tokenCount && ast._tokTags[mt + 1] === TOK_KW_TYPE) return 'type';
      return 'value';
    }
    // ImportSpecifier { type Foo } — 'type' token immediately before the name
    if (mt > 0 && ast._tokTags[mt - 1] === TOK_KW_TYPE) return 'type';
    return 'value';
  },

  /**
   * node.exportKind — 'type' for `export type`, 'value' otherwise.
   */
  get exportKind() {
    const t = this._tag;
    if (t !== T.export_named && t !== T.export_named_from && t !== T.export_all && t !== T.export_specifier) return undefined;
    const ast = this._ast;
    const mt = this.mainToken;
    if (t === T.export_named || t === T.export_named_from || t === T.export_all) {
      if (mt + 1 < ast.tokenCount && ast._tokTags[mt + 1] === TOK_KW_TYPE) return 'type';
      return 'value';
    }
    // ExportSpecifier: inline `type` modifier — `export { type foo }`
    if (mt > 0 && ast._tokTags[mt - 1] === TOK_KW_TYPE) return 'type';
    return 'value';
  },

  /**
   * node.init — initializer in VariableDeclarator or ForStatement.
   * Lazy-cached on the instance via `_init` so repeated reads (the rule
   * `def.node.init` read fires per variable + the prefer-const synth-write-
   * ref check fires too) don't re-materialize the init node every call.
   */
  get init() {
    const _synthBundle = _getSynth(this);
    if ('init' in _synthBundle) return _synthBundle.init;
    const t = this._tag;
    const ast = this._ast;
    let result = null;
    if (t === T.declarator) {
      const rhs = ast.nodeRhs(this._i);
      result = rhs === NONE ? null : nodeViewChain(ast, rhs);
    } else if (t === T.for_stmt) {
      const d = ast.extraForData(ast.nodeLhs(this._i));
      result = d.init === NONE ? null : nodeView(ast, d.init);
    }
    _synthBundle.init = result;
    return result;
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
    if (d.super_class !== NONE) return nodeViewChain(ast, d.super_class);
    // TS mode: Zig parser stores super_class=NONE and creates TSTypeReference instead.
    // Fall back: scan tokens for 'extends' keyword, then find the node whose mainToken is the identifier.
    const mt = this.mainToken; // class keyword token
    const tokTags = ast._tokTags;
    const mainTokens = ast._mainTokens;
    const nc = ast.nodeCount;
    // Find 'extends' token (tag 19) scanning forward from class keyword
    let extendsTok = -1;
    for (let ti = mt + 1; ti < ast.tokenCount; ti++) {
      const tag = tokTags[ti];
      if (tag === 19) { extendsTok = ti; break; } // kw_extends
      if (tag === 74) break; // '{' — class body started without extends
    }
    if (extendsTok < 0) return null;
    // Find node whose mainToken is the identifier right after 'extends'
    const heritageTok = extendsTok + 1;
    for (let ni = 0; ni < nc; ni++) {
      if (mainTokens[ni] === heritageTok) {
        const nTag = ast._nodeTags[ni];
        // TSTypeReference wraps the heritage name — return its typeName (lhs)
        if (nTag === T.ts_type_reference) {
          const inner = ast.nodeLhs(ni);
          return inner === NONE ? null : nodeView(ast, inner);
        }
        return nodeView(ast, ni);
      }
    }
    return null;
  },

  /**
   * node.implements — TS implements clause.
   * Returns array of TSClassImplements objects with .expression = Identifier.
   * Data comes from ClassData.impls_start/impls_end in the Zig buffer.
   * Each extra_data entry is the main_token index of the type reference (precomputed by Zig).
   */
  get implements() {
    const t = this._tag;
    if (t !== T.class_decl && t !== T.class_expr) return undefined;
    const ast = this._ast;
    const d = ast.extraClassData(ast.nodeLhs(this._i));
    if (d.impls_start === d.impls_end) return [];
    const result = [];
    const ed = ast._extraData;
    for (let i = d.impls_start; i < d.impls_end; i++) {
      const tok = ed[i]; // main_token index precomputed by Zig
      result.push({ type: 'TSClassImplements', expression: _tokenIdentifier(ast, tok) });
    }
    return result;
  },

  /**
   * node.elements — elements of ArrayExpression or ArrayPattern.
   * Holes are represented as null (matching ESLint's AST).
   *
   * Cached: rules like unicorn/no-array-for-each visit every Identifier
   * and call `parent.elements.includes(node)` from `isNotReference`,
   * which would otherwise rebuild the array per visit. Cache key is
   * the external synth bundle (`'elements' in bundle`) so non-array
   * tags also short-circuit on subsequent reads.
   */
  get elements() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.elements !== undefined) return _synthBundle.elements;
    const t = this._tag;
    const ast = this._ast;
    let result = undefined;
    if (t === T.array_literal || t === T.array_pattern) {
      const lhs = ast.nodeLhs(this._i);
      const rhs = ast.nodeRhs(this._i);
      const slice = ast._extraData.subarray(lhs, rhs);
      result = [];
      for (let j = 0; j < slice.length; j++) {
        const nodeIdx = slice[j];
        result.push(nodeIdx === NONE ? null : nodeView(ast, nodeIdx));
      }
      // Zig pushes a sentinel NONE after a trailing SpreadElement when there's a trailing comma
      // (e.g. `[...a,]`), to help validatePattern detect the comma. Strip it from the ESTree view:
      // a trailing comma is not an elision and should not add a null element.
      if (result.length >= 2 && result[result.length - 1] === null) {
        const prev = result[result.length - 2];
        if (prev !== null && prev.type === 'SpreadElement') {
          result.pop();
        }
      }
    }
    _synthBundle.elements = result;
    return result;
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
   *
   * Cached: hot via `parent.parent.properties.includes(parent)` in
   * unicorn/ast/is-reference-identifier's Property case (one of several
   * patterns that drive `_nodesFromRange` to ~17% self-time on
   * typescript.js).
   */
  get properties() {
    const _synthBundle = _getSynth(this);
    if (_synthBundle.props !== undefined) return _synthBundle.props;
    const t = this._tag;
    const ast = this._ast;
    let result = undefined;
    if (t === T.object_literal || t === T.object_pattern) {
      const nodes = ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
      if (t !== T.object_pattern) {
        result = nodes;
      } else {
      // ObjectPattern: wrap bare AssignmentPattern/Identifier/RestElement in
      // synthetic Property nodes — ESTree requires Property wrappers in patterns.
      result = nodes.map(n => {
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
    }
    _synthBundle.props = result;
    return result;
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
    // TS interface members: key is stored differently per tag.
    // TSMethodSignature: lhs = InterfaceSigData extra index; key is d.key.
    // TSPropertySignature: lhs = key node directly.
    // TSCallSignature/TSConstructSignature: no meaningful key; return dummy Identifier.
    if (t === T.ts_method_signature) {
      if (lhs === NONE) return { type: 'Identifier', name: '', start: this.start, end: this.start };
      const d = ast.extraInterfaceSigData(lhs);
      if (d.key === NONE) return { type: 'Identifier', name: '', start: this.start, end: this.start };
      return nodeView(ast, d.key);
    }
    if (t === T.ts_property_signature) {
      if (lhs === NONE) return { type: 'Identifier', name: '', start: this.start, end: this.start };
      return nodeView(ast, lhs);
    }
    if (t === T.ts_call_signature || t === T.ts_construct_signature || t === T.ts_index_signature) {
      return { type: 'Identifier', name: '', start: this.start, end: this.start };
    }
    if (t === T.ts_type_annotation || t === T.ts_enum_member) {
      if (lhs === NONE) return { type: 'Identifier', name: '', start: this.start, end: this.start };
      return nodeView(ast, lhs);
    }
    // StaticBlock / TSParameterProperty / etc.: nodes whose ESTree shape has
    // no `key`, but our prototype-based view exposes the `key` getter on every
    // node. Some rules do `'key' in node && node.key.type === ...` — the `in`
    // check passes (getter is on the prototype) and then the `.type` access
    // crashes on null. Return a benign dummy Identifier so the type check
    // fails cleanly instead of throwing.
    if (t === T.static_block) return { type: 'Identifier', name: '', start: this.start, end: this.start };
    if (t === T.ts_parameter_property) return { type: 'Identifier', name: '', start: this.start, end: this.start };
    // TSMappedType.key — first slot in the extra-data range (key identifier).
    if (t === T.ts_mapped_type) {
      const start = ast.nodeLhs(this._i);
      const kid = ast._extraData[start];
      return (kid === NONE || kid === undefined) ? null : nodeView(ast, kid);
    }
    return null;
  },

  /**
   * node.initializer — TSEnumMember initializer expression.
   */
  get initializer() {
    if (this._tag !== T.ts_enum_member) return undefined;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? null : nodeView(this._ast, rhs);
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
    const t = this._tag;
    const ast = this._ast;
    // labeled_stmt: rhs = label identifier node
    if (t === T.labeled_stmt) {
      const rhs = ast.nodeRhs(this._i);
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // break_label / continue_label: lhs = label identifier node
    if (t === T.break_label || t === T.continue_label) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return null;
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
   * Real property_ident node stored in lhs.
   */
  get meta() {
    const t = this._tag;
    if (t === T.new_target || t === T.import_meta) {
      const metaIdx = this._ast.nodeLhs(this._i);
      return metaIdx === NONE ? null : nodeView(this._ast, metaIdx);
    }
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
      return idx === NONE ? null : nodeViewChain(this._ast, idx);
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
    // TSAsExpression / TSSatisfiesExpression: expression = lhs (the wrapped expression)
    if (t === T.ts_as_expr || t === T.ts_satisfies_expr) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    // TSTypeAssertion (<Type>expr): expression = rhs
    if (t === T.ts_type_assertion) {
      const idx = this._ast.nodeRhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    // TSTypeReference used as TSExpressionWithTypeArguments (in extends/implements clause):
    // expression = typeName (the Identifier or TSQualifiedName).
    // Rules like @typescript-eslint/prefer-function-type access .expression on extends nodes.
    if (t === T.ts_type_reference) {
      const lhs = this._ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(this._ast, lhs);
    }
    // TSNonNullExpression: expression = lhs (already handled by argument getter, also expose here)
    if (t === T.ts_non_null_expr) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    // TSInstantiationExpression: expression = lhs (the value being instantiated)
    if (t === T.ts_instantiation_expr) {
      const idx = this._ast.nodeLhs(this._i);
      return idx === NONE ? null : nodeView(this._ast, idx);
    }
    return null;
  },

  /**
   * node.directive — for ExpressionStatement nodes that are directives
   * (e.g., "use strict"). Returns the directive string value, or undefined.
   * ESLint's astUtils.isDirective checks typeof node.directive === "string".
   *
   * Per the ECMAScript spec, directive prologues only appear at the start of:
   *   - ScriptBody (Program)
   *   - FunctionBody (BlockStatement whose parent is a function)
   *   - ModuleBody (Program with sourceType=module)
   * Class static blocks do NOT have directive prologues.
   *
   * A node is a directive only if all preceding siblings in the parent body
   * are also string-literal expression statements (the leading directive sequence).
   */
  get directive() {
    if (this._tag !== T.expression_stmt) return undefined;
    const ast = this._ast;
    // Directive prologues are an ES5+ concept. Espree does not set the directive
    // property when ecmaVersion < 5 (i.e. ecmaVersion 3). Match that behavior.
    if (ast._ecmaVersion !== undefined && ast._ecmaVersion < 5) return undefined;
    const exprIdx = ast.nodeLhs(this._i);
    if (exprIdx === NONE) return undefined;
    if (ast._nodeTags[exprIdx] !== T.string_literal) return undefined;

    // Check parent context — only Program or function BlockStatement are valid.
    const pd = ast._parentData;
    if (!pd) return undefined;
    const parentIdx = pd[this._i];
    if (parentIdx === NONE || parentIdx === 0xFFFFFFFF) return undefined;
    const parentTag = ast._nodeTags[parentIdx];

    let bodyStart, bodyEnd;
    if (parentTag === T.root) {
      bodyStart = ast.nodeLhs(parentIdx);
      bodyEnd   = ast.nodeRhs(parentIdx);
    } else if (parentTag === T.block_stmt) {
      // Block must be the direct body of a function or TS namespace/module.
      const gpIdx = pd[parentIdx];
      if (gpIdx === NONE || gpIdx === 0xFFFFFFFF) return undefined;
      const gpTag = ast._nodeTags[gpIdx];
      if (gpTag === T.ts_namespace_decl || gpTag === T.ts_module_decl) {
        // TS namespace/module body — 'use strict' etc. count as directives
        bodyStart = ast.nodeLhs(parentIdx);
        bodyEnd   = ast.nodeRhs(parentIdx);
      } else if (gpTag !== T.fn_decl && gpTag !== T.async_fn_decl &&
          gpTag !== T.generator_fn_decl && gpTag !== T.async_generator_fn_decl &&
          gpTag !== T.fn_expr && gpTag !== T.async_fn_expr &&
          gpTag !== T.generator_fn_expr && gpTag !== T.async_generator_fn_expr &&
          gpTag !== T.arrow_fn && gpTag !== T.async_arrow_fn) {
        return undefined;
      } else {
        bodyStart = ast.nodeLhs(parentIdx);
        bodyEnd   = ast.nodeRhs(parentIdx);
      }
    } else {
      return undefined;
    }

    // Walk extra-data range: all preceding siblings must be string_literal expression_stmts.
    const e = ast._extraData;
    for (let ei = bodyStart; ei < bodyEnd; ei++) {
      const sibIdx = e[ei];
      if (sibIdx === NONE || sibIdx === 0xFFFFFFFF) continue;
      if (sibIdx === this._i) break; // reached self — all before were directives
      if (ast._nodeTags[sibIdx] !== T.expression_stmt) return undefined;
      const sibExpr = ast.nodeLhs(sibIdx);
      if (sibExpr === NONE || ast._nodeTags[sibExpr] !== T.string_literal) return undefined;
    }

    // This node is in the leading string-literal sequence → it's a directive.
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
      const lhs = ast.nodeLhs(this._i);
      if (lhs === NONE) return []; // TSImportEqualsDeclaration — no specifiers
      const d = ast.extraImportData(lhs);
      return ast._nodesFromRange(d.specifiers_start, d.specifiers_end);
    }
    if (t === T.export_named) {
      const rhs = ast.nodeRhs(this._i);
      if (rhs === NONE) return []; // declaration export has no specifiers
      return ast._nodesFromRange(ast.nodeLhs(this._i), rhs);
    }
    if (t === T.export_named_from) {
      // lhs = extra index to ImportData { specifiers_start, specifiers_end, source }
      const d = ast.extraImportData(ast.nodeLhs(this._i));
      return ast._nodesFromRange(d.specifiers_start, d.specifiers_end);
    }
    return undefined;
  },

  /**
   * node.source — import/export source literal node.
   * Now a real string_literal node in the AST buffer; no synthesis needed.
   */
  get source() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.import_decl) {
      const lhs = ast.nodeLhs(this._i);
      if (lhs === NONE) return null;
      const d = ast.extraImportData(lhs);
      return d.source === NONE ? null : nodeView(ast, d.source);
    }
    if (t === T.export_named_from) {
      const d = ast.extraImportData(ast.nodeLhs(this._i));
      return d.source === NONE ? null : nodeView(ast, d.source);
    }
    if (t === T.export_all) {
      const srcIdx = ast.nodeLhs(this._i);
      return srcIdx === NONE ? null : nodeView(ast, srcIdx);
    }
    // ImportExpression (dynamic import): source = the argument expression
    if (t === T.import_expr) {
      const argIdx = ast.nodeLhs(this._i);
      return argIdx === NONE ? null : nodeView(ast, argIdx);
    }
    return undefined;
  },

  /**
   * node.moduleReference — TSImportEqualsDeclaration module reference.
   * For `import X = require('...')`: rhs is the require() call; extract string literal.
   */
  get moduleReference() {
    const t = this._tag;
    if (t !== T.import_decl) return undefined;
    const ast = this._ast;
    const lhs = ast.nodeLhs(this._i);
    if (lhs !== NONE) return undefined; // regular ImportDeclaration
    const rhs = ast.nodeRhs(this._i);
    if (rhs === NONE) return undefined;
    const callNode = nodeView(ast, rhs);
    // Get expression: first argument of require('...') call, or the rhs itself for qualified names
    const args = callNode.arguments;
    const expr = (args && args.length > 0) ? args[0] : callNode;
    return _syntheticNode('TSExternalModuleReference', callNode.start, callNode.end, { expression: expr }, ast);
  },

  /**
   * node.local — local binding in import/export specifier.
   * Returns the real identifier node created by the parser.
   */
  get local() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.import_specifier) {
      const rhs = ast.nodeRhs(this._i);
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.import_default_specifier || t === T.import_namespace_specifier) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    if (t === T.export_specifier) {
      const lhs = ast.nodeLhs(this._i);
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    return undefined;
  },

  /**
   * node.imported — imported name in ImportSpecifier.
   * Real identifier/literal node from the parser.
   */
  get imported() {
    if (this._tag !== T.import_specifier) return null;
    const lhs = this._ast.nodeLhs(this._i);
    return lhs === NONE ? null : nodeView(this._ast, lhs);
  },

  /**
   * node.exported — exported name in ExportSpecifier or ExportAllDeclaration.
   * Real identifier/literal node from the parser.
   */
  get exported() {
    const t = this._tag;
    if (t === T.export_all) {
      const rhs = this._ast.nodeRhs(this._i);
      return rhs === NONE ? null : nodeView(this._ast, rhs);
    }
    if (t !== T.export_specifier) return null;
    const rhs = this._ast.nodeRhs(this._i);
    return rhs === NONE ? null : nodeView(this._ast, rhs);
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
    if (t === T.export_named_from) {
      return null; // re-export has specifiers + source, no declaration
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

      // jsx_identifier with compound name: lhs = last token index; use its end.
      if (tag === T.jsx_identifier) {
        const lhs = this._ast.nodeLhs(this._i);
        if (lhs !== NONE && this._ast._tokEnds) end = this._ast._tokEnds[lhs];
      }

      // SequenceExpression: when paren-wrapped, _nodeEndPos includes the closing ')'.
      // Walk backwards through elements to find the last expression's true end position.
      if (tag === T.sequence_expr) {
        const lhs = this._ast.nodeLhs(this._i), rhs = this._ast.nodeRhs(this._i);
        const extra = this._ast._extraData;
        for (let i = rhs - 1; i >= lhs; i--) {
          const ci = extra[i];
          if (ci !== NONE) { end = this._ast._nodeEndPos(ci); break; }
        }
      }

      // For statement nodes, check if a semicolon token follows and extend the range to include it.
      // Parser computes end positions based on child nodes, which excludes trailing semicolons.
      // This workaround extends statement ranges to include the semicolon for ESLint rule compatibility.
      // Exception: var/let/const as the init of a for-statement must NOT include the for's `;` separator.
      if (_isStatementTag(tag)) {
        let isForInitDecl = false;
        if (tag === T.var_decl || tag === T.let_decl || tag === T.const_decl) {
          const pd = this._ast._parentData;
          if (pd) {
            const pi = pd[this._i];
            if (pi !== undefined && pi !== 0xffffffff && this._ast._nodeTags[pi] === T.for_stmt) {
              // Confirm this node is the INIT of the for-statement (not the body).
              // The init is stored in extra data; body is in rhs. We check by looking at the
              // ForStatement's init property: if parent.init === this node, skip extension.
              const parentView = nodeView(this._ast, pi);
              isForInitDecl = parentView && parentView.init === this;
            }
          }
        }
        if (!isForInitDecl) {
          end = _extendRangeToIncludeSemicolon(this._ast, end);
        }
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

  /** node.comments — all file comments on Program; empty array elsewhere. Writable so rules can set it. */
  get comments() {
    if (this._comments !== undefined) return this._comments;
    // Program (root) nodes expose the full comment list; other nodes get nothing.
    if (this._tag === T.root) {
      const ast = this._ast;
      const all = ast.commentsInRange ? ast.commentsInRange(0, ast.sourceLen) : _emptyArray;
      this._comments = all;
      return all;
    }
    return _emptyArray;
  },
  set comments(v) {
    this._comments = v;
  },

  // ── JSX getters ─────────────────────────────────────────────

  /** JSXElement.openingElement (jsx_element → opening child, jsx_self_closing → synth) */
  get openingElement() {
    const t = this._tag;
    const ast = this._ast;
    if (t === T.jsx_element) {
      const d = ast.extraJsxElementData(ast.nodeLhs(this._i));
      return d.opening !== NONE ? nodeView(ast, d.opening) : null;
    }
    // Self-closing: synthesize a JSXOpeningElement(selfClosing=true) view that aliases
    // this node's range. ESTree rules expect node.openingElement.type === 'JSXOpeningElement',
    // and rules like jsx-tag-spacing read node.range/loc on it for fix positioning.
    if (t === T.jsx_self_closing) {
      let cached = this._syntheticOpeningElement;
      if (cached !== undefined) return cached;
      const selfNode = this;
      const d = ast.extraJsxOpeningData(ast.nodeLhs(this._i));
      // The synth carries selfNode's _i and _ast so SourceCode helpers (getTokens,
      // getLastTokens, getFirstToken, etc.) that key off _i still find tokens via the
      // jsx_self_closing node's token range. Without _i, getTokens returns [].
      cached = {
        type: 'JSXOpeningElement',
        selfClosing: true,
        _i: selfNode._i,
        _ast: ast,
        _tag: T.jsx_self_closing,
        get name() { return d.name !== NONE ? nodeView(ast, d.name) : null; },
        get attributes() { return ast._nodesFromRange(d.attrs_start, d.attrs_end); },
        get typeArguments() { return undefined; },
        get typeParameters() { return undefined; },
        get range() { return selfNode.range; },
        get loc() { return selfNode.loc; },
        get start() { return selfNode.start; },
        get end() { return selfNode.end; },
        parent: selfNode,
      };
      this._syntheticOpeningElement = cached;
      return cached;
    }
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

  /** JSXOpeningElement.attributes / JSXElement(self-closing).attributes /
   *  ImportDeclaration.attributes (TS5+ import attributes — ez doesn't parse
   *  them yet, but ESLint/typescript-eslint expect this property to exist
   *  as an array for rules like @typescript-eslint/consistent-type-imports). */
  get attributes() {
    const t = this._tag;
    if (t === T.import_decl || t === T.export_named_from || t === T.export_all) return [];
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

  /** JSXNamespacedName.namespace */
  get namespace() {
    if (this._tag !== T.jsx_namespaced_name) return undefined;
    const idx = this._ast.nodeLhs(this._i);
    return idx !== NONE ? nodeView(this._ast, idx) : null;
  },

  /** JSXFragment.openingFragment — synthetic JSXOpeningFragment node */
  get openingFragment() {
    if (this._tag !== T.jsx_fragment) return undefined;
    const ast = this._ast;
    const start = this.start; // already includes `<` after our js_buffer fix
    // main_token is the `>` token of `<>`.  Use its end position so the opening
    // fragment range is correct even when `<` and `>` are on different lines
    // (e.g. `< /* comment */ >`).
    const mainTok = ast._mainTokens[this._i];
    const end = ast._tokEnds ? ast._tokEnds[mainTok] : ast._tokStarts[mainTok] + 1;
    const ls = ast._lineStarts();
    const sli = ast._findLineIdx(start);
    const eli = ast._findLineIdx(end > 0 ? end - 1 : 0);
    return { type: 'JSXOpeningFragment', start, end, range: [start, end],
             loc: { start: { line: sli + 1, column: start - ls[sli] },
                    end:   { line: eli + 1, column: end   - ls[eli] } },
             attributes: [], selfClosing: false };
  },

  /** JSXFragment.closingFragment — synthetic JSXClosingFragment node */
  get closingFragment() {
    if (this._tag !== T.jsx_fragment) return undefined;
    const ast = this._ast;
    const end = this.end;   // end of `>`
    // Scan backward through the token list to find the `<` (tag=98) that starts `</`.
    // This is correct even when `</` and `>` are on different lines with comments between.
    const starts = ast._tokStarts;
    const tags = ast._tokTags;
    const tc = ast.tokenCount;
    // Binary search: last token whose start is strictly before nodeEnd
    let endTokIdx = 0;
    let lo = 0, hi = tc - 1;
    while (lo <= hi) { const mid = (lo + hi) >> 1; if (starts[mid] < end) { endTokIdx = mid; lo = mid + 1; } else hi = mid - 1; }
    // Scan backward (past `>` and `/`) to find `<` (less_than = token tag 98)
    let ltIdx = endTokIdx - 1;
    while (ltIdx >= 0 && tags[ltIdx] !== 98) ltIdx--;
    const start = ltIdx >= 0 ? starts[ltIdx] : end - 3;
    const ls = ast._lineStarts();
    const sli = ast._findLineIdx(start);
    const eli = ast._findLineIdx(end > 0 ? end - 1 : 0);
    return { type: 'JSXClosingFragment', start, end, range: [start, end],
             loc: { start: { line: sli + 1, column: start - ls[sli] },
                    end:   { line: eli + 1, column: end   - ls[eli] } } };
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
 * Cache "does this AST contain ANY optional-chain node?" (one tag-CSR check
 * per AST). When false — overwhelmingly common in pre-transpiled bundles
 * like typescript.js — `_isChainNode` returns false in O(1).
 */
function _astHasOptionalChain(ast) {
  if (ast._hasOptionalChain !== undefined) return ast._hasOptionalChain;
  const starts = ast._tagNodeStarts;
  let has = false;
  if (starts) {
    const tags = [T.optional_call_expr, T.optional_member_expr, T.optional_computed_member_expr];
    for (const t of tags) {
      if (t == null || t < 0 || t >= starts.length - 1) continue;
      if (starts[t + 1] - starts[t] > 0) { has = true; break; }
    }
  }
  ast._hasOptionalChain = has;
  return has;
}

/**
 * Return true if node `idx` belongs to an optional chain (i.e., is optional itself,
 * or is a non-optional member/call whose lhs transitively leads to an optional chain node).
 *
 * Hot path: when the AST has no optional-chain nodes at all, return false
 * without inspecting `idx`. Pre-bundled JS (typescript.js, lodash, etc.)
 * almost never contains `?.` and dominates real workloads.
 */
function _isChainNode(ast, idx) {
  if (!_astHasOptionalChain(ast)) return false;
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

// ── Per-type prototypes ──────────────────────────────────────────
// ESLint plugins use `'prop' in node` to distinguish node types. With a shared
// prototype, every getter is visible on every node, breaking that contract.
// Fix: for specific node types where plugins check with `in` and the property
// doesn't belong, create a variant prototype with that getter removed.
// Conservative approach: only remove properties we KNOW cause bugs, not all.

// Map: tag → array of property names to delete from NodeProto for that type.
// Only list properties where plugins use `'prop' in node` and the prop doesn't
// belong to that node type per the ESTree spec.
const _TAG_DELETE_PROPS = {
  // jsdocUtils checks `'left' in param` and `'name' in param` to route code paths.
  // With prototype getters these are always true, taking wrong branches and
  // bypassing the correct handlers for each node type.
  [T.rest_element]:    ['left', 'right', 'name'],
  // ObjectPattern/ArrayPattern: `'left' in param` and `'name' in param` must be
  // false so jsdocUtils takes the correct ObjectPattern/ArrayPattern branch.
  // ESTree spec: neither node type has .left or .name properties.
  [T.object_pattern]:  ['left', 'right', 'name'],
  [T.array_pattern]:   ['left', 'right', 'name'],
  // Identifier: ESTree spec has no .left/.right. The compiled jsdocUtils.cjs checks
  // `'left' in param && 'typeAnnotation' in param.left` without a null guard, so
  // `'left' in identifier` returning true leads to `'typeAnnotation' in undefined` crash.
  [T.identifier]:            ['left', 'right'],
  [T.property_ident]:        ['left', 'right'],
  // Property/shorthand_property/computed_property: ESTree spec has no .left/.right/.name.
  // jsdocUtils v2's compiled dist checks `'left' in prop && 'typeAnnotation' in prop.left`
  // and `'name' in prop` without null guards on Property nodes from ObjectPattern.properties.
  [T.property]:              ['left', 'right', 'name'],
  [T.shorthand_property]:    ['left', 'right', 'name'],
  [T.computed_property]:     ['left', 'right', 'name'],
  // AssignmentPattern: ESTree spec has no .name. jsdocUtils checks `'name' in param` before
  // `'left' in param && 'name' in param.left`, so if AP has name it returns undefined instead
  // of the correct param.left.name (the actual param identifier name like 'code' in 'code=1').
  [T.assignment_pattern]:    ['name'],
  // TSParameterProperty: jsdocUtils checks `'left' in param` (crashes: left getter returns
  // undefined, then `'typeAnnotation' in undefined` throws), and `'name' in param` / `typeAnnotation`
  // which would take wrong branches before reaching the `param.type === 'TSParameterProperty'`
  // handler at line 461. Delete all three so jsdocUtils falls through to the correct branch.
  [T.ts_parameter_property]: ['left', 'name', 'typeAnnotation'],
};

const _typeProtos = new Array(256);

function _getTypeProto(tag) {
  let proto = _typeProtos[tag];
  if (proto) return proto;
  const deletes = _TAG_DELETE_PROPS[tag];
  if (!deletes) {
    // No overrides needed — use NodeProto directly
    _typeProtos[tag] = NodeProto;
    return NodeProto;
  }
  // Clone NodeProto and delete the specified getters
  proto = Object.create(Object.prototype, Object.getOwnPropertyDescriptors(NodeProto));
  for (const prop of deletes) {
    delete proto[prop];
  }
  _typeProtos[tag] = proto;
  return proto;
}

// Constructor function with all node fields initialized — JSC allocates a
// single statically-known structure per `new _NodeView(...)`, no proto hop.
// (A `class` would also work but its `.prototype` is non-writable so we can't
// point it at NodeProto.) Used for the common case where
// `_getTypeProto(tag) === NodeProto`; tags with `_TAG_DELETE_PROPS` overrides
// take the object-literal slow path.
// Tags whose `range` differs from `[_nodeStartPos, _nodeEndPos]` and
// therefore can't be eager-filled in the ctor. The lazy `get range`
// getter handles these: root (uses 0..sourceUtf16Len), jsx_identifier
// (compound names use tokEnds[lhs]), sequence_expr (paren-wrapped end
// adjustment), and statement tags (need trailing-semicolon extension
// + the var/let/const-in-for-init parent check). The default ctor's
// _range slot is left null for these so the getter fires.
function _isSimpleRangeTag(tag) {
  return tag !== T.root && tag !== T.jsx_identifier && tag !== T.sequence_expr &&
         !_isStatementTag(tag);
}

function _NodeView(ast, idx, tag, type) {
  this._ast = ast;
  this._i = idx;
  this._tag = tag;
  this._parent = _PARENT_UNSET;
  this.type = type;
  this._loc = null;
  // Eager-fill _range cache for simple-tag nodes — most rules read
  // `node.range` (for diagnostic spans), so paying ~2 typed-array
  // reads at construction beats the getter dispatch + lazy compute on
  // first access. Special tags (statements, root, jsx_identifier,
  // sequence_expr) keep the null sentinel; the getter handles them.
  this._range = _isSimpleRangeTag(tag)
    ? [ast._nodeStartPosArr[idx], ast._nodeEndPosArr[idx]]
    : null;
  // _body, _value, _init moved to external `_synthCache` (WeakMap-keyed)
  this._cachedName = undefined;
  // _params, _typeParameters, _arguments, _decorators, _elements, _properties
  // moved to external `_synthCache` (WeakMap-keyed). Synthetic-node identity
  // is preserved without polluting the NodeView's own-property surface; rule
  // ICs stay monomorphic across the buffer-backed shape.
}
_NodeView.prototype = NodeProto;

// Per-override-set constructors. Each carries its own statically-set
// prototype (NodeProto clone with the override's properties deleted), so
// `new _NodeView_X` allocates with a fixed shape and no setPrototypeDirect
// call. Bodies are intentionally identical to `_NodeView`'s — JSC's
// allocation profile is per-constructor.
function _NodeView_LRN(ast, idx, tag, type) {  // ['left','right','name']
  // None of the LRN tags (rest_element, object_pattern, array_pattern,
  // property, shorthand_property, computed_property) need range
  // adjustment — eager-fill unconditionally.
  this._ast = ast; this._i = idx; this._tag = tag; this._parent = _PARENT_UNSET;
  this.type = type; this._loc = null;
  this._range = [ast._nodeStartPosArr[idx], ast._nodeEndPosArr[idx]];
  // _body, _value, _init moved to external `_synthCache` (WeakMap-keyed)
  this._cachedName = undefined;
  // synth caches externalized — see _NodeView comment.
}
// Identifier name extraction — called at construction time to pre-fill
// `_cachedName` on identifier-tagged NodeViews, so the `get name` getter
// hits the cache on first access immediately.
//
// Fast path (v15 buffer): read pre-computed UTF-16 [start,end) from Zig,
// slice source directly, inline the unicode-escape check. Eliminates both
// _identAt (char-by-char scan) and the _resolveUnicodeEscapes function call
// for the 99.9%+ of identifiers without escapes.
//
// Fallback (no v15 data): legacy _identAt scan + _resolveUnicodeEscapes.
function _computeIdentifierName(ast, idx) {
  // Fast path 1: sym cache hit — returns an already-allocated string, zero source.slice().
  // Covers the majority of identifier/property_ident nodes that are symbol references.
  const nodeSymId = ast._nodeSymId;
  if (nodeSymId !== null) {
    const symId = nodeSymId[idx];
    if (symId !== NONE) return ast._symNameCache[symId];
  }
  // Fast path 2: v15 buffer ranges — one source.slice() with inlined escape check.
  // Covers non-reference identifiers (property names in member expressions, etc.).
  const nameStarts = ast._nodeNameStarts;
  if (nameStarts !== null) {
    const start = nameStarts[idx];
    const end = ast._nodeNameEnds[idx];
    const name = ast.source.slice(start, end);
    if (name.indexOf('\\') === -1) return name;
    return _resolveUnicodeEscapes(name);
  }
  // Legacy fallback: no v15 buffer (old binary).
  const tok = ast._mainTokens[idx];
  const pos = ast._tokStarts[tok];
  if (ast.source.charCodeAt(pos) === 35) { // '#' — private identifier
    const nextTokStart = tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : pos + 1;
    if (nextTokStart === pos + 1 && tok + 1 < ast.tokenCount) {
      return _resolveUnicodeEscapes(ast._identAt(tok + 1));
    }
    return _resolveUnicodeEscapes(ast.source.slice(pos + 1, nextTokStart).replace(/\s+$/, ''));
  }
  return _resolveUnicodeEscapes(ast._identAt(tok));
}

function _NodeView_LR(ast, idx, tag, type) {   // ['left','right']  (T.identifier, T.property_ident)
  this._ast = ast; this._i = idx; this._tag = tag; this._parent = _PARENT_UNSET;
  this.type = type; this._loc = null;
  this._range = [ast._nodeStartPosArr[idx], ast._nodeEndPosArr[idx]];
  // Pre-fill _cachedName so the `get name` getter hits the cache immediately
  // on first access (no _identAt scan, no unicode-escape resolve at read time).
  // Using _cachedName (not `name`) keeps slot-8 identical to _NodeView's layout,
  // so both constructors produce objects at the same property offset — JSC/V8
  // can use offset-based ICs without structure checks at mixed-tag call sites.
  this._cachedName = _computeIdentifierName(ast, idx);
  // synth caches externalized — see _NodeView comment.
}
function _NodeView_N(ast, idx, tag, type) {    // ['name']  (T.assignment_pattern)
  this._ast = ast; this._i = idx; this._tag = tag; this._parent = _PARENT_UNSET;
  this.type = type; this._loc = null;
  this._range = [ast._nodeStartPosArr[idx], ast._nodeEndPosArr[idx]];
  // _body, _value, _init moved to external `_synthCache` (WeakMap-keyed)
  this._cachedName = undefined;
  // synth caches externalized — see _NodeView comment.
}
function _NodeView_LNT(ast, idx, tag, type) {  // ['left','name','typeAnnotation']  (T.ts_parameter_property)
  this._ast = ast; this._i = idx; this._tag = tag; this._parent = _PARENT_UNSET;
  this.type = type; this._loc = null;
  this._range = [ast._nodeStartPosArr[idx], ast._nodeEndPosArr[idx]];
  // _body, _value, _init moved to external `_synthCache` (WeakMap-keyed)
  this._cachedName = undefined;
  // synth caches externalized — see _NodeView comment.
}
_NodeView_LRN.prototype = _getTypeProto(T.rest_element);
_NodeView_LR.prototype  = _getTypeProto(T.identifier);
_NodeView_N.prototype   = _getTypeProto(T.assignment_pattern);
_NodeView_LNT.prototype = _getTypeProto(T.ts_parameter_property);

// Tag → constructor table. Default cell = `_NodeView` (NodeProto). Special
// tags route to their override-set ctor. Lookup is a single array read.
const _NODE_CTOR = new Array(256);
for (let i = 0; i < 256; i++) _NODE_CTOR[i] = _NodeView;
for (const t of [T.rest_element, T.object_pattern, T.array_pattern,
                 T.property, T.shorthand_property, T.computed_property]) _NODE_CTOR[t] = _NodeView_LRN;
for (const t of [T.identifier, T.property_ident]) _NODE_CTOR[t] = _NodeView_LR;
_NODE_CTOR[T.assignment_pattern] = _NodeView_N;
_NODE_CTOR[T.ts_parameter_property] = _NodeView_LNT;

/** Raw nodeView — returns per-type proto node, no ChainExpression wrapping. */
function _nodeViewRaw(ast, index) {
  // Pool is eagerly allocated in AstView ctor as `new Array(nodeCount)`.
  // Single branch per call: cached hit → return. Miss → construct,
  // install, return. The `cache === null` lazy-init branch from the
  // pre-eager-init version is gone.
  const cache = ast._nodeCache;
  const cached = cache[index];
  if (cached !== undefined) return cached;
  const tag = ast._nodeTags[index];
  // Single dispatch through tag→ctor table. Each ctor has a fixed
  // prototype; no setPrototypeDirect on any path.
  const Ctor = _NODE_CTOR[tag];
  const n = new Ctor(ast, index, tag, _computeNodeType(ast, index, tag));
  // Eager-fill regex/bigint as own DATA properties so `Object.hasOwn(n,
  // 'regex')` returns true (ESLint rules check) AND `n.regex` reads
  // through a fast IC load instead of dispatching the prototype getter
  // every access.
  if (tag === T.regex_literal) {
    const src = ast._rawTokenText(ast._mainTokens[index]);
    const lastSlash = src.lastIndexOf('/');
    Object.defineProperty(n, 'regex', {
      value: lastSlash > 0
        ? { pattern: src.slice(1, lastSlash), flags: src.slice(lastSlash + 1) }
        : undefined,
      writable: true, enumerable: true, configurable: true,
    });
  } else if (tag === T.bigint_literal) {
    const src = ast._rawTokenText(ast._mainTokens[index]);
    Object.defineProperty(n, 'bigint', {
      value: src.endsWith('n') ? src.slice(0, -1) : src,
      writable: true, enumerable: true, configurable: true,
    });
  }
  cache[index] = n;
  return n;
}

function nodeView(ast, index) {
  // Unwrap grouping_expr and ts_parenthesized_type transparently.
  // ESTree/typescript-eslint don't have ParenthesizedExpression/TSParenthesizedType —
  // parentheses are transparent and the inner node is returned directly.
  while (index !== NONE && (ast._nodeTags[index] === T.grouping_expr ||
                             ast._nodeTags[index] === T.ts_parenthesized_type)) {
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
    // Skip TS contextual modifier identifiers (override/readonly/declare/
    // abstract/accessor/public/private/protected) — they're tokenized as
    // plain identifiers but precede `static`/`async`/the name in class members.
    if (tag === 8 /* identifier */) {
      const text = ast._rawTokenText(i);
      if (text === 'accessor' || text === 'override' || text === 'readonly' ||
          text === 'declare' || text === 'abstract' || text === 'public' ||
          text === 'private' || text === 'protected') { i--; continue; }
    }
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
// Compute the ESTree-shape `type` string for a node directly from the
// buffer — no NodeView allocation. Mirrors `_computeNodeType`'s logic
// (consult `_typeOverrides` for pre-baked disambiguations, fall back to
// `TAG_NAMES[tag]`). Used by rule-rewriter helpers
// (`parentTypeEq` etc.) that need only the parent's `.type` and don't
// want to materialize the parent NodeView just to read one string.
function nodeTypeAt(ast, idx) {
  const overrides = ast._typeOverrides;
  if (overrides) {
    const slot = overrides[idx];
    if (slot !== 0) return _OVERRIDE_TYPES[slot];
  }
  return TAG_NAMES ? TAG_NAMES[ast._nodeTags[idx]] : null;
}

function effectiveTypeName(ast, idx, rawTagName) {
  if (rawTagName === 'TSTypeReference' && ast.nodeRhs(idx) === NONE) {
    const tok = ast._mainTokens[idx];
    const start = ast._tokStarts[tok];
    const end = ast._tokEnds ? ast._tokEnds[tok]
      : (tok + 1 < ast.tokenCount ? ast._tokStarts[tok + 1] : ast.source.length);
    const text = ast.source.slice(start, end);
    const kw = _TS_KW_TYPES[text.trim()];
    if (kw) return kw;
    // Literal type: string/template literal, number/bigint, boolean, negative
    const c = text.charCodeAt(0);
    if (c === 39 || c === 34 || c === 96 || // ' " `
        (c >= 48 && c <= 57) ||              // digit
        text === 'true' || text === 'false' || text === '-') {
      return 'TSLiteralType';
    }
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
  SEG_COLLAPSED_PREV_STARTS: 60,
  SEG_COLLAPSED_PREV_TARGETS: 64,
  CP_ORIGIN: 68,
  CP_UPPER: 72,
  CP_INITIAL_SEG: 76,
  CP_FINAL_STARTS: 80,
  CP_FINAL_TARGETS: 84,
  CP_RETURNED_STARTS: 88,
  CP_RETURNED_TARGETS: 92,
  CP_THROWN_STARTS: 96,
  CP_THROWN_TARGETS: 100,
  EVENTS: 104,
  // Pre-baked per-phase CSR for CFG events. Replaces the per-runPlugins
  // event-Map build that scanned `events`. See writeCfgGraph in js_buffer.zig.
  CFG_PHASE_NODE_COUNT: 108,
  CFG_PHASE_ENTER_STARTS: 112,
  CFG_PHASE_ENTER_DATA: 116,
  CFG_PHASE_EXIT_STARTS: 120,
  CFG_PHASE_EXIT_DATA: 124,
  CFG_PHASE_POST_STARTS: 128,
  CFG_PHASE_POST_DATA: 132,
  CFG_PHASE_AFTER_ENTER_STARTS: 136,
  CFG_PHASE_AFTER_ENTER_DATA: 140,
  CFG_NODE_BITS: 144,
  CFG_SUBTREE_BITS: 148,
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
    // next/allNext are reconstructed lazily in JS by inverting prev + loopedPrev.
    this._nextStarts = null;
    this._nextTargets = null;
    this._allNextStarts = null;
    this._allNextTargets = null;

    this._prevStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_PREV_STARTS, true), sc1);
    const ptOff = dv.getUint32(off + CGH.SEG_PREV_TARGETS, true);
    const ptLen = this._prevStarts[this._segCount];
    this._prevTargets = ptOff > 0 && ptLen > 0 ? new Uint32Array(buffer, ptOff, ptLen) : null;

    this._allPrevStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_ALL_PREV_STARTS, true), sc1);
    const aptOff = dv.getUint32(off + CGH.SEG_ALL_PREV_TARGETS, true);
    const aptLen = this._allPrevStarts[this._segCount];
    this._allPrevTargets = aptOff > 0 && aptLen > 0 ? new Uint32Array(buffer, aptOff, aptLen) : null;

    this._loopedStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_LOOPED_STARTS, true), sc1);
    const ltOff = dv.getUint32(off + CGH.SEG_LOOPED_TARGETS, true);
    const ltLen = this._loopedStarts[this._segCount];
    this._loopedTargets = ltOff > 0 && ltLen > 0 ? new Uint32Array(buffer, ltOff, ltLen) : null;

    this._collapsedPrevStarts = new Uint32Array(buffer, dv.getUint32(off + CGH.SEG_COLLAPSED_PREV_STARTS, true), sc1);
    const cptOff = dv.getUint32(off + CGH.SEG_COLLAPSED_PREV_TARGETS, true);
    const cptLen = this._collapsedPrevStarts[this._segCount];
    this._collapsedPrevTargets = cptOff > 0 && cptLen > 0 ? new Uint32Array(buffer, cptOff, cptLen) : null;

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

    // Pre-baked per-phase CSR (replaces the runtime event-Map build).
    // `phase_node_count` is the same node count the buffer was built against;
    // also doubles as a "is the CSR present" flag (0 if not built).
    const cfgNc = dv.getUint32(off + CGH.CFG_PHASE_NODE_COUNT, true);
    if (cfgNc > 0) {
      const sc1n = cfgNc + 1;
      // 4 phases: enter (0), exit (1), post (2), after_enter (3).
      const _readStarts = (cgh) => new Uint32Array(buffer, dv.getUint32(off + cgh, true), sc1n);
      const _readData = (startsArr, cghData) => {
        const total = startsArr[cfgNc];
        const dOff = dv.getUint32(off + cghData, true);
        return total > 0 && dOff > 0 ? new Uint32Array(buffer, dOff, total * 3) : null;
      };
      this._cfgEnterStarts      = _readStarts(CGH.CFG_PHASE_ENTER_STARTS);
      this._cfgEnterData        = _readData(this._cfgEnterStarts, CGH.CFG_PHASE_ENTER_DATA);
      this._cfgExitStarts       = _readStarts(CGH.CFG_PHASE_EXIT_STARTS);
      this._cfgExitData         = _readData(this._cfgExitStarts, CGH.CFG_PHASE_EXIT_DATA);
      this._cfgPostStarts       = _readStarts(CGH.CFG_PHASE_POST_STARTS);
      this._cfgPostData         = _readData(this._cfgPostStarts, CGH.CFG_PHASE_POST_DATA);
      this._cfgAfterEnterStarts = _readStarts(CGH.CFG_PHASE_AFTER_ENTER_STARTS);
      this._cfgAfterEnterData   = _readData(this._cfgAfterEnterStarts, CGH.CFG_PHASE_AFTER_ENTER_DATA);
      const nbOff = dv.getUint32(off + CGH.CFG_NODE_BITS, true);
      this._cfgNodeBits = nbOff > 0 ? new Uint8Array(buffer, nbOff, cfgNc) : null;
      const sbOff = dv.getUint32(off + CGH.CFG_SUBTREE_BITS, true);
      this._cfgSubtreeBits = sbOff > 0 ? new Uint8Array(buffer, sbOff, cfgNc) : null;
      this._cfgPhaseNodeCount = cfgNc;
    } else {
      this._cfgEnterStarts = null; this._cfgEnterData = null;
      this._cfgExitStarts = null; this._cfgExitData = null;
      this._cfgPostStarts = null; this._cfgPostData = null;
      this._cfgAfterEnterStarts = null; this._cfgAfterEnterData = null;
      this._cfgNodeBits = null;
      this._cfgSubtreeBits = null;
      this._cfgPhaseNodeCount = 0;
    }

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

  /** Build next/allNext adjacency by inverting prev + loopedPrev (called once on first access). */
  _ensureNextAdjacency() {
    if (this._nextStarts !== null) return;
    const N = this._segCount;
    const degNext = new Uint32Array(N);
    const degAllNext = new Uint32Array(N);
    const prevT = this._prevTargets, allPrevT = this._allPrevTargets;
    const loopedT = this._loopedTargets;
    // From prev edges — nextSegments only includes reachable successors; skip unreachable i
    const reach = this._segReachable;
    if (prevT) {
      for (let i = 0; i < N; i++) {
        if (!reach[i]) continue;
        const ps = this._prevStarts[i], pe = this._prevStarts[i + 1];
        for (let k = ps; k < pe; k++) degNext[prevT[k]]++;
      }
    }
    if (allPrevT) {
      for (let i = 0; i < N; i++) {
        const aps = this._allPrevStarts[i], ape = this._allPrevStarts[i + 1];
        for (let k = aps; k < ape; k++) degAllNext[allPrevT[k]]++;
      }
    }
    // From looped back-edges: loopedTargets[loopedStarts[i]..loopedStarts[i+1]] = loop-end segs for header i
    if (loopedT) {
      for (let i = 0; i < N; i++) {
        const ls = this._loopedStarts[i], le = this._loopedStarts[i + 1];
        for (let k = ls; k < le; k++) {
          const p = loopedT[k];
          degAllNext[p]++;
          if (reach[p] && reach[i]) degNext[p]++;
        }
      }
    }
    // Build CSR starts
    const nextStarts = new Uint32Array(N + 1);
    const allNextStarts = new Uint32Array(N + 1);
    for (let i = 0; i < N; i++) {
      nextStarts[i + 1] = nextStarts[i] + degNext[i];
      allNextStarts[i + 1] = allNextStarts[i] + degAllNext[i];
    }
    const nextTargets = new Uint32Array(nextStarts[N]);
    const allNextTargets = new Uint32Array(allNextStarts[N]);
    // Fill from prev edges
    const posNext = new Uint32Array(N);
    const posAllNext = new Uint32Array(N);
    if (prevT) {
      for (let i = 0; i < N; i++) {
        if (!reach[i]) continue;
        const ps = this._prevStarts[i], pe = this._prevStarts[i + 1];
        for (let k = ps; k < pe; k++) {
          const p = prevT[k];
          nextTargets[nextStarts[p] + posNext[p]++] = i;
        }
      }
    }
    if (allPrevT) {
      for (let i = 0; i < N; i++) {
        const aps = this._allPrevStarts[i], ape = this._allPrevStarts[i + 1];
        for (let k = aps; k < ape; k++) {
          const p = allPrevT[k];
          allNextTargets[allNextStarts[p] + posAllNext[p]++] = i;
        }
      }
    }
    // Fill from looped back-edges
    if (loopedT) {
      for (let i = 0; i < N; i++) {
        const ls = this._loopedStarts[i], le = this._loopedStarts[i + 1];
        for (let k = ls; k < le; k++) {
          const p = loopedT[k];
          allNextTargets[allNextStarts[p] + posAllNext[p]++] = i;
          if (reach[p] && reach[i]) nextTargets[nextStarts[p] + posNext[p]++] = i;
        }
      }
    }
    this._nextStarts = nextStarts;
    this._nextTargets = nextTargets.length > 0 ? nextTargets : null;
    this._allNextStarts = allNextStarts;
    this._allNextTargets = allNextTargets.length > 0 ? allNextTargets : null;
  }
}

class CfgSegment {
  constructor(cfg, idx) {
    this._cfg = cfg;
    this._idx = idx;
    this.reachable = cfg._segReachable[idx] !== 0;
    // Lazy cached adjacency
    this._next = undefined;
    this._prev = undefined;
    this._allNext = undefined;
    this._allPrev = undefined;
    this._looped = undefined;
    // Lazy id/internal — backing fields initialized null so the hidden class is stable
    this._id = null;
    this._internal = null;
  }
  get id() {
    if (this._id === null) this._id = `s${this._cfg._segCp[this._idx] + 1}_${this._idx + 1}`;
    return this._id;
  }
  set id(v) { this._id = v; }
  get internal() {
    if (this._internal === null) this._internal = { used: true, loopedPrevSegments: null, nodes: [] };
    return this._internal;
  }
  set internal(v) { this._internal = v; }

  get nextSegments() {
    if (this._next === undefined) {
      this._cfg._ensureNextAdjacency();
      this._next = this._cfg._csrSegments(this._cfg._nextStarts, this._cfg._nextTargets, this._idx);
    }
    return this._next;
  }
  get prevSegments() {
    if (this._prev === undefined) this._prev = this._cfg._csrSegments(this._cfg._prevStarts, this._cfg._prevTargets, this._idx);
    return this._prev;
  }
  get allNextSegments() {
    if (this._allNext === undefined) {
      this._cfg._ensureNextAdjacency();
      this._allNext = this._cfg._csrSegments(this._cfg._allNextStarts, this._cfg._allNextTargets, this._idx);
    }
    return this._allNext;
  }
  get allPrevSegments() {
    if (this._allPrev === undefined) {
      if (!this.reachable && this._cfg._collapsedPrevTargets) {
        // Use precomputed reachable-ancestor list — eliminates O(depth) JS recursion
        // in rules like no-useless-return that traverse unreachable predecessor chains.
        this._allPrev = this._cfg._csrSegments(this._cfg._collapsedPrevStarts, this._cfg._collapsedPrevTargets, this._idx);
      } else {
        this._allPrev = this._cfg._csrSegments(this._cfg._allPrevStarts, this._cfg._allPrevTargets, this._idx);
      }
    }
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

/**
 * Return the synthetic ChainExpression wrapper for node `idx` if it is the outermost
 * optional chain node, otherwise return null. Used by the runner to synthesize
 * ChainExpression enter/exit events for rules like no-restricted-syntax.
 */
function getChainExprIfOutermost(ast, idx) {
  if (_isChainNode(ast, idx) && !_isChainChild(ast, idx)) {
    return _getChainExpr(ast, idx);
  }
  return null;
}

module.exports = { AstView, NodeProto, nodeView, _nodeViewRaw, reset, setTagNames, NONE, T, effectiveTypeName, nodeTypeAt, CfgGraph, CfgSegment, CfgCodePath, getChainExprIfOutermost };
