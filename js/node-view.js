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

    // Parent indices (v2 — zero array if not present in buffer)
    const parentOff = dv.getUint32(H.PARENT_INDICES_OFFSET, true);
    this._parentData = parentOff > 0
      ? new Uint32Array(buffer, parentOff, this.nodeCount)
      : null;

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
    const name = src.slice(start, end);
    const li = this._findLineIdx(start);
    const eli = this._findLineIdx(end);
    const ls = this._lineStarts();
    return {
      type: 'Identifier',
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

  /** TryData { catch_param, catch_body, finally_body } */
  extraTryData(i) {
    const e = this._extraData;
    return { catch_param: e[i], catch_body: e[i + 1], finally_body: e[i + 2] };
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
      // identifier chars: A-Z a-z 0-9 _ $ or unicode
      if (!((c >= 65 && c <= 90) || (c >= 97 && c <= 122) ||
            (c >= 48 && c <= 57) || c === 95 || c === 36 || c > 127)) break;
      pos++;
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

  /**
   * Build end-position array for all nodes in a single O(n) pass.
   * In sanz, children have higher node indices than parents (root=0 is lowest).
   * Iterating high→low propagates each child's max-token up to its parent in one pass.
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
      // Propagate max token up the tree with repeated passes until convergence.
      // Node index ordering is not strictly parent-before-child in sanz, so a
      // single pass is insufficient; typically converges in O(depth) passes.
      let changed = true;
      while (changed) {
        changed = false;
        for (let i = 1; i < n; i++) {
          const p = pd[i];
          if (p !== NONE && maxTok[i] > maxTok[p]) {
            maxTok[p] = maxTok[i];
            changed = true;
          }
        }
      }
    }

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
    if (!pd) return null;
    const parentIdx = pd[this._i];
    if (parentIdx === NONE) return null;
    return nodeView(this._ast, parentIdx);
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
      return this._ast._identAt(this.mainToken);
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
    if (t === T.string_literal) return src; // raw with quotes; TODO: unescape
    if (t === T.number_literal) return parseFloat(src);
    if (t === T.boolean_literal) return src === 'true';
    if (t === T.null_literal) return null;
    if (t === T.bigint_literal) return src.slice(0, -1); // strip 'n'
    if (t === T.regex_literal) return src;
    // VariableDeclarator .value = init (ESLint uses .init, but some rules use .value)
    if (t === T.declarator) return this.rhsNode();
    // Property (key: value) — rhs is the value expression
    if (t === T.property || t === T.computed_property) {
      const rhs = ast.nodeRhs(this._i);
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // Method/getter/setter — return a synthetic FunctionExpression
    if (t === T.method_def || t === T.getter_def || t === T.setter_def ||
        t === T.constructor_def || t === T.computed_method_def ||
        t === T.computed_getter_def || t === T.computed_setter_def) {
      const md = ast.extraMethodData(ast.nodeRhs(this._i));
      const flags = _methodFlags(ast, this.mainToken);
      const params = ast._nodesFromRange(md.params_start, md.params_end);
      const body = md.body === NONE ? null : nodeView(ast, md.body);
      return {
        type: 'FunctionExpression',
        id: null,
        async: flags.async,
        generator: flags.generator,
        params: params || [],
        body,
        mainToken: this.mainToken,
        start: ast._tokStarts[this.mainToken],
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
    // BlockStatement — lhs=range.start, rhs=range.end (stored directly)
    if (t === T.block_stmt) {
      return ast._nodesFromRange(lhs, rhs);
    }
    // if/while: body is rhs
    if (t === T.if_stmt || t === T.while_stmt) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // do-while: body is lhs
    if (t === T.do_while_stmt) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // for/for-in/for-of: body in extra
    if (t === T.for_stmt) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    if (t === T.for_in_stmt || t === T.for_of_stmt || t === T.for_await_of_stmt) {
      const d = ast.extraForInOfData(lhs);
      return d.body === NONE ? null : nodeView(ast, d.body);
    }
    // labeled statement
    if (t === T.labeled_stmt) {
      return lhs === NONE ? null : nodeView(ast, lhs);
    }
    // with statement
    if (t === T.with_stmt) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // function/arrow bodies via FnData/ArrowData
    if (t === T.fn_decl || t === T.async_fn_decl ||
        t === T.generator_fn_decl || t === T.async_generator_fn_decl ||
        t === T.fn_expr || t === T.async_fn_expr ||
        t === T.generator_fn_expr || t === T.async_generator_fn_expr) {
      const d = ast.extraFnData(lhs);
      return d.body === NONE ? null : nodeView(ast, d.body);
    }
    if (t === T.arrow_fn || t === T.async_arrow_fn) {
      const d = ast.extraArrowData(lhs);
      return d.body === NONE ? null : nodeView(ast, d.body);
    }
    // catch_clause
    if (t === T.catch_clause) {
      return rhs === NONE ? null : nodeView(ast, rhs);
    }
    // static block — lhs=range.start, rhs=range.end (stored directly)
    if (t === T.static_block) {
      return ast._nodesFromRange(lhs, rhs);
    }
    // Program body — lhs=range.start, rhs=range.end (stored directly)
    if (t === T.root) {
      return ast._nodesFromRange(lhs, rhs);
    }
    return null;
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
      return ast._syntheticId(rhs);
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
    if (t === T.method_def || t === T.computed_method_def) return 'method';
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
   * Note: holes are omitted (ESLint includes null for holes).
   */
  get elements() {
    const t = this.tag;
    const ast = this._ast;
    if (t === T.array_literal || t === T.array_pattern) {
      // lhs=range.start, rhs=range.end (stored directly)
      return ast._nodesFromRange(ast.nodeLhs(this._i), ast.nodeRhs(this._i));
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
   * node.handler — catch clause (synthetic CatchClause with param and body).
   */
  get handler() {
    if (this.tag !== T.try_stmt) return null;
    const ast = this._ast;
    const d = ast.extraTryData(ast.nodeRhs(this._i));
    if (d.catch_body === NONE) return null;
    const body = nodeView(ast, d.catch_body);
    const param = d.catch_param === NONE ? null : nodeView(ast, d.catch_param);
    // Return a synthetic CatchClause so rules can access .body and .param
    return {
      type: 'CatchClause',
      param,
      body,
      start: param ? param.start : body.start,
      mainToken: body.mainToken,
    };
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
      return d.source === NONE ? null : ast._syntheticId(d.source);
    }
    if (t === T.export_all) {
      const tokIdx = ast.nodeLhs(this._i);
      return tokIdx === NONE ? null : ast._syntheticId(tokIdx);
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
    if (t === T.import_specifier) {
      return ast._syntheticId(ast.nodeRhs(this._i)); // rhs = local name token
    }
    if (t === T.import_default_specifier || t === T.import_namespace_specifier) {
      return ast._syntheticId(ast.nodeLhs(this._i));
    }
    if (t === T.export_specifier) {
      return ast._syntheticId(ast.nodeLhs(this._i));
    }
    return null;
  },

  /**
   * node.imported — imported name in ImportSpecifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get imported() {
    if (this.tag !== T.import_specifier) return null;
    return this._ast._syntheticId(this._ast.nodeLhs(this._i));
  },

  /**
   * node.exported — exported name in ExportSpecifier.
   * Returns a synthetic Identifier node (with range/loc).
   */
  get exported() {
    if (this.tag !== T.export_specifier) return null;
    return this._ast._syntheticId(this._ast.nodeRhs(this._i));
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
    return [this.start, this._ast._nodeEndPos(this._i)];
  },

  /**
   * node.loc — { start: { line, column }, end: { line, column } }
   * Line is 1-indexed; column is 0-indexed.
   */
  get loc() {
    const ast = this._ast;
    const start = this.start;
    const end = ast._nodeEndPos(this._i);
    const ls = ast._lineStarts();
    let lo = 0, hi = ls.length - 1;
    while (lo < hi) {
      const mid = (lo + hi + 1) >> 1;
      if (ls[mid] <= start) lo = mid;
      else hi = mid - 1;
    }
    const startLine = lo + 1;
    const startCol = start - ls[lo];
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

const TOK_ASYNC = 44;    // kw_async
const TOK_STAR  = 89;    // asterisk (generator marker)

/**
 * Scan backwards from the method name token to detect async/generator flags.
 * Method tokens before the name: `static`, `async`, `*`, `get`, `set`
 * Returns { async: bool, generator: bool }.
 */
function _methodFlags(ast, mainToken) {
  let isAsync = false;
  let isGenerator = false;
  let i = mainToken - 1;
  while (i >= 0) {
    const tag = ast._tokTags[i];
    if (tag === TOK_STAR) { isGenerator = true; i--; continue; }
    if (tag === TOK_ASYNC) { isAsync = true; i--; continue; }
    // static / get / set / other keyword modifiers — skip
    if (tag >= 9 && tag <= 71) { i--; continue; }
    break;
  }
  return { async: isAsync, generator: isGenerator };
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

module.exports = { AstView, NodeProto, nodeView, reset, setTagNames, NONE, T };
