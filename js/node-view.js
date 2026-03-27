"use strict";

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
};

const FLAG_HAS_BOM = 1;

// ── Tag name table ──────────────────────────────────────────────

let TAG_NAMES = null;

/// NodeIndex.none sentinel (matches Zig's std.math.maxInt(u32))
const NONE = 0xFFFFFFFF;

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
    this._sourceText = null;

    // Reset pool index for this parse
    _poolIdx = 0;
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
 */
const NodeProto = {
  get type() {
    return TAG_NAMES ? TAG_NAMES[this._ast._nodeTags[this._i]] : String(this._ast._nodeTags[this._i]);
  },
  get tag() {
    return this._ast._nodeTags[this._i];
  },
  get mainToken() {
    return this._ast._mainTokens[this._i];
  },
  get start() {
    return this._ast._tokStarts[this._ast._mainTokens[this._i]];
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
   * Returns fresh objects (not pooled) to avoid aliasing when
   * the caller holds references to multiple children simultaneously.
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
};

// Pre-allocate the pool
const _pool = Array.from({ length: POOL_SIZE }, () => Object.create(NodeProto));

function nodeView(ast, index) {
  const n = _pool[_poolIdx++ & (POOL_SIZE - 1)];
  n._ast = ast;
  n._i = index;
  return n;
}

/**
 * Reset all pool objects and cached state.
 * MUST be called between files to prevent source text retention
 * via V8's SlicedString optimization.
 */
function reset() {
  for (let i = 0; i < POOL_SIZE; i++) {
    _pool[i]._ast = null;
    _pool[i]._i = 0;
  }
  _poolIdx = 0;
}

module.exports = { AstView, NodeProto, nodeView, reset, setTagNames, NONE };
