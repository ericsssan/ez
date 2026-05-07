"use strict";
/**
 * FFI-backed SourceCode token helpers.
 *
 * Implements the ESLint SourceCode token API surface against the Zig FFI primitives:
 *   - getFirstToken(node)
 *   - getLastToken(node)
 *   - getTokenBefore(node)
 *   - getTokenAfter(node)
 *   - getTokensBetween(left, right)
 *   - getTokens(node)
 *   - getTokenByRangeStart(pos)
 *
 * Hot-path versions only — they handle the no-options / no-filter cases that ~95%+ of
 * rule callbacks hit. Calls with options (filter fn, includeComments, skip count) fall
 * back to the existing JS SourceCode implementation. JS-side Token wrappers are cached
 * by token index so identity equality holds across calls (mirrors `_makeToken`).
 *
 * Designed to be drop-in compatible with the ESLint SourceCode contract — no rule code
 * changes needed; just swap which SourceCode is handed to the rule's context.
 */

const path = require("path");
const fs   = require("fs");

let _binding = null;
function _tryLoad() {
  if (_binding !== null) return _binding;
  let dlopen, FFIType, ptr;
  try { ({ dlopen, FFIType, ptr } = require("bun:ffi")); }
  catch { _binding = false; return false; }

  const candidates = [
    path.join(__dirname, "../zig-out/lib/ez.node"),
    path.join(__dirname, "../zig-out/lib/libez.dylib"),
    path.join(__dirname, "../zig-out/lib/libez.so"),
  ];
  let dylib = null;
  for (const c of candidates) if (fs.existsSync(c)) { dylib = c; break; }
  if (!dylib) { _binding = false; return false; }

  let lib;
  try {
    lib = dlopen(dylib, {
      ez_ffi_token_count:            { args: [FFIType.ptr],                                                returns: FFIType.u32 },
      ez_ffi_token_idx_at_or_before: { args: [FFIType.ptr, FFIType.u32],                                   returns: FFIType.u32 },
      ez_ffi_token_idx_at_or_after:  { args: [FFIType.ptr, FFIType.u32],                                   returns: FFIType.u32 },
      ez_ffi_token_data:             { args: [FFIType.ptr, FFIType.u32, FFIType.ptr],                      returns: FFIType.void },
      ez_ffi_token_data_range:       { args: [FFIType.ptr, FFIType.u32, FFIType.u32, FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
    });
  } catch { _binding = false; return false; }
  _binding = { ptr, sym: lib.symbols };
  return _binding;
}

function isAvailable() { return !!_tryLoad(); }

const NONE_IDX = 0xFFFFFFFF;

/**
 * Wraps an AST buffer with FFI-backed token helpers.
 *
 * @param {object} astView    The existing AstView (used for buffer ref + tokenCount)
 * @param {string} sourceText The source text (used to materialize Token.value)
 * @param {string[]} tokenTagNames  Token tag → string name lookup table
 * @returns {object} An object exposing the SourceCode token API methods.
 */
function createTokenHelpers(astView, sourceText, tokenTagNames) {
  const b = _tryLoad();
  if (!b) throw new Error("ffi-source-code: bun:ffi unavailable");
  const { ptr, sym } = b;

  const bufBytes = new Uint8Array(astView.buffer);
  const bufPtr   = ptr(bufBytes);
  const tokenCount = astView.tokenCount;

  // Token wrapper cache for identity equality. _tokenObjCache[i] = JS wrapper or null
  // (null = shadowed token, e.g. identifier portion of #private).
  const tokenObjCache = new Array(tokenCount);

  // Reusable scratch buffer for ez_ffi_token_data writes.
  const scratch3 = new Uint32Array(3);
  const scratch3Ptr = ptr(scratch3);

  // Reusable scratch buffer for bulk token data — sized for typical between-call lengths.
  let bulkBuf  = new Uint32Array(3 * 1024);  // 1024 tokens × (start, end, tag)
  let bulkPtr  = ptr(bulkBuf);

  function _ensureBulk(needTokens) {
    if (bulkBuf.length < needTokens * 3) {
      bulkBuf = new Uint32Array(Math.max(needTokens * 3, bulkBuf.length * 2));
      bulkPtr = ptr(bulkBuf);
    }
  }

  /** Build (or fetch from cache) the Token wrapper for a given token index. */
  function makeToken(i) {
    if (i === NONE_IDX || i >= tokenCount) return null;
    const cached = tokenObjCache[i];
    if (cached !== undefined) return cached;
    sym.ez_ffi_token_data(bufPtr, i, scratch3Ptr);
    const start = scratch3[0];
    const end   = scratch3[1];
    const tag   = scratch3[2];
    const tok = {
      type: tokenTagNames[tag] || `tag-${tag}`,
      value: sourceText.substring(start, end),
      range: [start, end],
      start, end,
      loc: null, // computed lazily on access if needed
    };
    tokenObjCache[i] = tok;
    return tok;
  }

  /** Fast-path getTokenBefore: default options only (no filter, no skip, no comments). */
  function getTokenBefore(node) {
    if (!node) return null;
    const mainTok = node.mainToken;
    if (mainTok !== undefined && mainTok !== null) {
      if (mainTok === 0) return null;
      return makeToken(mainTok - 1);
    }
    if (!node.range) return null;
    const idx = sym.ez_ffi_token_idx_at_or_before(bufPtr, node.range[0] - 1);
    if (idx === NONE_IDX) return null;
    return makeToken(idx);
  }

  /** Fast-path getTokenAfter: default options only. */
  function getTokenAfter(node) {
    if (!node) return null;
    if (node.range) {
      const idx = sym.ez_ffi_token_idx_at_or_after(bufPtr, node.range[1]);
      if (idx === NONE_IDX) return null;
      return makeToken(idx);
    }
    return null;
  }

  /** First token of a node — lookup mainToken (its main_token IS the first one). */
  function getFirstToken(node) {
    if (!node) return null;
    const mainTok = node.mainToken;
    if (mainTok !== undefined && mainTok !== null) return makeToken(mainTok);
    if (!node.range) return null;
    const idx = sym.ez_ffi_token_idx_at_or_after(bufPtr, node.range[0]);
    if (idx === NONE_IDX) return null;
    return makeToken(idx);
  }

  /** Last token of a node — find token at-or-before node.range[1]-1. */
  function getLastToken(node) {
    if (!node || !node.range) return null;
    const idx = sym.ez_ffi_token_idx_at_or_before(bufPtr, node.range[1] - 1);
    if (idx === NONE_IDX) return null;
    return makeToken(idx);
  }

  /**
   * Tokens strictly between `left` and `right`. The bulk variant of the FFI primitive
   * fills a typed array with all token data in one call; we then build wrappers as we
   * push them into the result. Wrapper construction is unavoidable for ESLint compat
   * but only happens for tokens actually returned (not for ones the rule ignores).
   */
  function getTokensBetween(left, right) {
    if (!left || !right || !left.range || !right.range) return [];
    const startIdx = sym.ez_ffi_token_idx_at_or_after(bufPtr, left.range[1]);
    if (startIdx === NONE_IDX) return [];
    const endIdx   = sym.ez_ffi_token_idx_at_or_before(bufPtr, right.range[0] - 1);
    if (endIdx === NONE_IDX || endIdx < startIdx) return [];
    const count = endIdx - startIdx + 1;
    _ensureBulk(count);
    sym.ez_ffi_token_data_range(bufPtr, startIdx, endIdx + 1, bulkPtr, bulkBuf.length / 3);
    // The bulk data is in bulkBuf[0..count*3]. Wrappers cache uses absolute token index.
    const out = new Array(count);
    for (let k = 0; k < count; k++) out[k] = makeToken(startIdx + k);
    return out;
  }

  /** All tokens of a node. */
  function getTokens(node) {
    if (!node || !node.range) return [];
    const startIdx = sym.ez_ffi_token_idx_at_or_after(bufPtr, node.range[0]);
    const endIdx   = sym.ez_ffi_token_idx_at_or_before(bufPtr, node.range[1] - 1);
    if (startIdx === NONE_IDX || endIdx === NONE_IDX || endIdx < startIdx) return [];
    const count = endIdx - startIdx + 1;
    const out = new Array(count);
    for (let k = 0; k < count; k++) out[k] = makeToken(startIdx + k);
    return out;
  }

  /** Token whose start position equals `pos`, or null. ESLint API. */
  function getTokenByRangeStart(pos) {
    const idx = sym.ez_ffi_token_idx_at_or_before(bufPtr, pos);
    if (idx === NONE_IDX) return null;
    sym.ez_ffi_token_data(bufPtr, idx, scratch3Ptr);
    if (scratch3[0] !== pos) return null;
    return makeToken(idx);
  }

  return {
    getTokenBefore, getTokenAfter,
    getFirstToken, getLastToken,
    getTokensBetween, getTokens,
    getTokenByRangeStart,
    // Exposed for tests / power users.
    _internal: { makeToken, _bufPtr: bufPtr },
  };
}

module.exports = { createTokenHelpers, isAvailable, _internal: { tryLoad: _tryLoad } };
