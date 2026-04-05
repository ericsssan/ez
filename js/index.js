"use strict";

const { AstView, setTagNames, reset: resetView } = require("./estree-adapter");

// ── Load native binding ──────────────────────────────────────────

let binding;

/**
 * Auto-detect runtime and load the native binding:
 * - Bun FFI (fastest, optional)
 * - NAPI (Node.js + Bun fallback)
 */
function loadBinding() {
  if (binding) return binding;

  // Try Bun FFI fast path first
  if (typeof Bun !== "undefined") {
    try {
      binding = require("./bun-ffi");
      return binding;
    } catch {
      // Fall through to NAPI
    }
  }

  // NAPI path (works in Node.js and Bun)
  try {
    binding = require("../zig-out/lib/sanz.node");
  } catch {
    try {
      binding = require("../zig-out/lib/libsanz.dylib");
    } catch {
      try {
        binding = require("../zig-out/lib/libsanz.so");
      } catch {
        throw new Error(
          "sanz: could not load native binding. Run `make napi` first."
        );
      }
    }
  }
  return binding;
}

// ── Buffer management ────────────────────────────────────────────

const DEFAULT_BUFFER_SIZE = 4 * 1024 * 1024; // 4 MB
const HEADER_SIZE = 104; // 26 fields × 4 bytes
const MAGIC = 0x5A4E4153; // "SANZ" little-endian

let sharedBuffer = null;

function ensureBuffer(sourceLen) {
  const needed = HEADER_SIZE + sourceLen * 30; // heuristic: 30x source size (minified files need ~25x)
  const minSize = Math.max(needed, DEFAULT_BUFFER_SIZE);

  if (!sharedBuffer || sharedBuffer.byteLength < minSize) {
    sharedBuffer = new ArrayBuffer(minSize);
  } else if (sharedBuffer.byteLength > minSize * 4) {
    // Shrink if buffer is >4x what's needed (prevents permanent high-water-mark)
    sharedBuffer = new ArrayBuffer(minSize);
  }
  return sharedBuffer;
}

// ── Language enum ────────────────────────────────────────────────

const LANG = { js: 0, ts: 1, jsx: 2, tsx: 3 };

function detectLang(filename) {
  if (filename.endsWith(".tsx")) return LANG.tsx;
  if (filename.endsWith(".ts") || filename.endsWith(".mts") || filename.endsWith(".cts")) return LANG.ts;
  if (filename.endsWith(".jsx")) return LANG.jsx;
  return LANG.js;
}

// ── Public API ───────────────────────────────────────────────────

/**
 * Parse source code into an AST accessible via typed array views.
 *
 * @param {string} source - Source code string
 * @param {object} [options] - { filename?: string, lang?: 'js'|'ts'|'jsx'|'tsx' }
 * @returns {AstView} - Zero-copy AST view over the shared buffer
 */
function parse(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename
      ? detectLang(options.filename)
      : LANG.js;

  // Fast path: encode directly into the buffer tail using encodeInto() (zero allocation).
  // We reserve source.length + 128 bytes — enough for files that are mostly ASCII
  // (each non-ASCII BMP char adds at most 2 extra bytes; 128 bytes covers ~64 such chars).
  // For files with more non-ASCII we fall back to encode().
  let sourceLen, buf, sourceStart;
  const reservedLen = source.length + 128;
  buf = ensureBuffer(reservedLen);
  sourceStart = buf.byteLength - reservedLen;
  const { read, written } = _encoder.encodeInto(source, new Uint8Array(buf, sourceStart, reservedLen));
  if (read === source.length) {
    // Fast path: all chars encoded in-place — no allocation.
    sourceLen = written;
  } else {
    // Source has too many non-ASCII chars for the reserved space.
    // Fall back to encode() which allocates but handles all Unicode correctly.
    const encoded = _encoder.encode(source);
    sourceLen = encoded.byteLength;
    buf = ensureBuffer(sourceLen);
    sourceStart = buf.byteLength - sourceLen;
    new Uint8Array(buf).set(encoded, sourceStart);
  }

  // Call native parse
  const bytesUsed = b.parse(buf, sourceStart, sourceLen, lang);
  if (bytesUsed === 0) {
    throw new Error("sanz: parse failed (buffer too small or invalid source)");
  }

  // Copy the AST output into a private buffer so that subsequent parse() calls
  // (which reuse sharedBuffer) don't corrupt this AstView's typed array views.
  //
  // Layout of privateBuf:
  //   [0 .. totalUsed)         compact AST data (header + nodes + tokens + semantic + ...)
  //   [totalUsed .. srcStart)  zero padding — covers semantic header fields that may extend
  //                            past totalUsed (e.g. NODE_REACHABLE at semOff+88 can equal
  //                            totalUsed; in the original 4MB buffer those bytes are zero,
  //                            but without padding they'd alias source text in privateBuf)
  //   [srcStart .. srcStart+sourceLen)  source bytes
  //
  // After copy we must update:
  //   H.SOURCE_OFFSET (byte 52): old value = sourceStart (~4MB); new value = srcStart
  //   _symNameStarts[i]: old values = sourceStart + byte_offset; new = srcStart + byte_offset
  const dv0 = new DataView(buf);
  const totalUsed = dv0.getUint32(56 /* H.TOTAL_USED */, true);
  const semOff = dv0.getUint32(68 /* H.SEMANTIC_DATA_OFFSET */, true);
  // Semantic header occupies semOff .. semOff+96 (NODE_REACHABLE at +88, +4 bytes, +4 padding).
  // srcStart must be >= semOff+96 so the zero-filled gap keeps all header reads returning 0.
  const semEnd = semOff > 0 ? semOff + 96 : 0;
  const srcStart = Math.max(totalUsed, semEnd);
  const privateSize = srcStart + sourceLen;
  const privateArr = new Uint8Array(privateSize); // zero-initialized
  privateArr.set(new Uint8Array(buf, 0, totalUsed));             // compact data
  privateArr.set(new Uint8Array(buf, sourceStart, sourceLen), srcStart); // source bytes
  const privateBuf = privateArr.buffer;
  const pdv = new DataView(privateBuf);

  // Fix SOURCE_OFFSET
  pdv.setUint32(52 /* H.SOURCE_OFFSET */, srcStart, true);
  if (semOff > 0) {
    const symCount = pdv.getUint32(semOff + 4 /* SH.SYMBOL_COUNT */, true);
    if (symCount > 0) {
      const nameStartsArrOff = pdv.getUint32(semOff + 60 /* SH.SYMBOL_NAME_STARTS */, true);
      if (nameStartsArrOff > 0 && nameStartsArrOff + symCount * 4 <= totalUsed) {
        const nameStartsArr = new Uint32Array(privateBuf, nameStartsArrOff, symCount);
        const shift = totalUsed - sourceStart; // negative: sourceStart >> totalUsed
        for (let i = 0; i < symCount; i++) {
          nameStartsArr[i] = (nameStartsArr[i] + shift) >>> 0;
        }
      }
    }
  }

  // Verify magic
  const magic = pdv.getUint32(0, true);
  if (magic !== MAGIC) {
    throw new Error("sanz: invalid buffer header (magic mismatch)");
  }

  // Ensure tag names are loaded for NodeProto.type
  getTagNames();

  return new AstView(privateBuf);
}

/**
 * Reset all buffer views. Call between files to prevent source text retention.
 */
function resetBuffer() {
  resetView();
}

const _encoder = new TextEncoder();
let _cachedTagNames = null;

/**
 * Get the tag name table (ESTree-compatible type names).
 * Cached after first call. Also initializes estree-adapter.js TAG_NAMES.
 */
function getTagNames() {
  if (_cachedTagNames) return _cachedTagNames;
  const b = loadBinding();
  const count = b.tagCount();
  _cachedTagNames = new Array(count);
  for (let i = 0; i < count; i++) {
    _cachedTagNames[i] = b.tagName(i);
  }
  setTagNames(_cachedTagNames);
  return _cachedTagNames;
}

// ── Lint ─────────────────────────────────────────────────────────

const _decoder = new TextDecoder();

// Persistent output buffer — grown as needed, never shrunk (high-water-mark).
let _lintOutBuf = new ArrayBuffer(64 * 1024);

/**
 * Lint source code in-process using the native Zig lint rules.
 * No subprocess, no disk I/O — source is passed as a string.
 *
 * @param {string} source
 * @param {object} [options] - { filename?: string, lang?: 'js'|'ts'|'jsx'|'tsx' }
 * @returns {Array<{offset: number, severity: number, ruleName: string, message: string}>}
 *   severity: 0 = error, 1 = warning
 */
function lint(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename
      ? detectLang(options.filename)
      : LANG.js;

  // Encode source into the shared parse buffer (same path as parse()).
  let sourceLen, buf, sourceStart;
  const reservedLen = source.length + 128;
  buf = ensureBuffer(reservedLen);
  sourceStart = buf.byteLength - reservedLen;
  const { read, written } = _encoder.encodeInto(source, new Uint8Array(buf, sourceStart, reservedLen));
  if (read === source.length) {
    sourceLen = written;
  } else {
    const encoded = _encoder.encode(source);
    sourceLen = encoded.byteLength;
    buf = ensureBuffer(sourceLen);
    sourceStart = buf.byteLength - sourceLen;
    new Uint8Array(buf).set(encoded, sourceStart);
  }

  // Ensure output buffer is large enough (heuristic: source * 4 + 4KB minimum).
  const needed = Math.max(sourceLen * 4 + 4096, 64 * 1024);
  if (_lintOutBuf.byteLength < needed) {
    _lintOutBuf = new ArrayBuffer(needed * 2);
  }

  const bytesWritten = b.lint(buf, sourceStart, sourceLen, lang, _lintOutBuf);
  if (bytesWritten < 4) return [];

  // Parse packed binary output.
  const dv = new DataView(_lintOutBuf);
  const count = dv.getUint32(0, true);
  const diags = [];
  let pos = 4;
  for (let i = 0; i < count && pos < bytesWritten; i++) {
    const offset   = dv.getUint32(pos, true); pos += 4;
    const severity = dv.getUint8(pos);         pos += 1;
    const ruleLen  = dv.getUint8(pos);          pos += 1;
    const ruleName = _decoder.decode(new Uint8Array(_lintOutBuf, pos, ruleLen)); pos += ruleLen;
    const msgLen   = dv.getUint16(pos, true);   pos += 2;
    const message  = _decoder.decode(new Uint8Array(_lintOutBuf, pos, msgLen));  pos += msgLen;
    diags.push({ offset, severity, ruleName, message });
  }
  return diags;
}

/**
 * Parse + lint in a single pipeline pass — avoids double lex/parse/semantic.
 *
 * Equivalent to calling parse() and lint() separately, but the native side
 * reuses the live AST and SemanticResult for both, cutting pipeline cost
 * from 2× to 1×.
 *
 * @param {string} source
 * @param {object} [options] - { filename?: string, lang?: 'js'|'ts'|'jsx'|'tsx' }
 * @returns {{ ast: AstView, diags: Array<{offset, severity, ruleName, message}> }}
 */
function parseAndLint(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename
      ? detectLang(options.filename)
      : LANG.js;

  // Encode source into shared buffer (same as parse()).
  let sourceLen, buf, sourceStart;
  const reservedLen = source.length + 128;
  buf = ensureBuffer(reservedLen);
  sourceStart = buf.byteLength - reservedLen;
  const { read, written } = _encoder.encodeInto(source, new Uint8Array(buf, sourceStart, reservedLen));
  if (read === source.length) {
    sourceLen = written;
  } else {
    const encoded = _encoder.encode(source);
    sourceLen = encoded.byteLength;
    buf = ensureBuffer(sourceLen);
    sourceStart = buf.byteLength - sourceLen;
    new Uint8Array(buf).set(encoded, sourceStart);
  }

  // Ensure lint output buffer.
  const needed = Math.max(sourceLen * 4 + 4096, 64 * 1024);
  if (_lintOutBuf.byteLength < needed) {
    _lintOutBuf = new ArrayBuffer(needed * 2);
  }

  // Single native call — returns AST bytesUsed; diags written to _lintOutBuf.
  const bytesUsed = b.parseAndLint(buf, sourceStart, sourceLen, lang, _lintOutBuf);
  if (bytesUsed === 0) {
    throw new Error("sanz: parseAndLint failed (buffer too small or invalid source)");
  }

  // Build AstView from the buffer (same copy logic as parse()).
  const dv0 = new DataView(buf);
  const totalUsed = dv0.getUint32(56 /* H.TOTAL_USED */, true);
  const semOff = dv0.getUint32(68 /* H.SEMANTIC_DATA_OFFSET */, true);
  const semEnd = semOff > 0 ? semOff + 96 : 0;
  const srcStart = Math.max(totalUsed, semEnd);
  const privateSize = srcStart + sourceLen;
  const privateArr = new Uint8Array(privateSize);
  privateArr.set(new Uint8Array(buf, 0, totalUsed));
  privateArr.set(new Uint8Array(buf, sourceStart, sourceLen), srcStart);
  const privateBuf = privateArr.buffer;
  const pdv = new DataView(privateBuf);
  pdv.setUint32(52 /* H.SOURCE_OFFSET */, srcStart, true);
  if (semOff > 0) {
    const symCount = pdv.getUint32(semOff + 4, true);
    if (symCount > 0) {
      const nameStartsArrOff = pdv.getUint32(semOff + 60, true);
      if (nameStartsArrOff > 0 && nameStartsArrOff + symCount * 4 <= totalUsed) {
        const nameStartsArr = new Uint32Array(privateBuf, nameStartsArrOff, symCount);
        const shift = totalUsed - sourceStart;
        for (let i = 0; i < symCount; i++) nameStartsArr[i] = (nameStartsArr[i] + shift) >>> 0;
      }
    }
  }

  getTagNames();
  const ast = new AstView(privateBuf);

  // Parse diagnostics from _lintOutBuf.
  const dv = new DataView(_lintOutBuf);
  const count = dv.getUint32(0, true);
  const diags = [];
  let pos = 4;
  for (let i = 0; i < count; i++) {
    if (pos + 8 > _lintOutBuf.byteLength) break;
    const offset   = dv.getUint32(pos, true); pos += 4;
    const severity = dv.getUint8(pos);         pos += 1;
    const ruleLen  = dv.getUint8(pos);          pos += 1;
    const ruleName = _decoder.decode(new Uint8Array(_lintOutBuf, pos, ruleLen)); pos += ruleLen;
    const msgLen   = dv.getUint16(pos, true);   pos += 2;
    const message  = _decoder.decode(new Uint8Array(_lintOutBuf, pos, msgLen));  pos += msgLen;
    diags.push({ offset, severity, ruleName, message });
  }

  return { ast, diags };
}

/**
 * Lint source code using an already-parsed AstView (output of parse()).
 *
 * Avoids re-encoding the source string — reads source bytes directly from
 * the AstView's underlying buffer. Use this in the hybrid routing scenario:
 *
 *   const ast  = sanz.parse(source, { filename });   // parse once (for JS rules)
 *   const diags = sanz.lintBuffer(ast, { filename }); // lint from same buffer (native rules)
 *
 * @param {AstView} astView - Result of a previous parse() call
 * @param {object} [options] - { lang?: 'js'|'ts'|'jsx'|'tsx', filename?: string }
 * @returns {Array<{offset: number, severity: number, ruleName: string, message: string}>}
 */
function lintBuffer(astView, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename
      ? detectLang(options.filename)
      : LANG.js;

  const buf = astView.buffer;

  // Ensure output buffer is large enough (use source_len from header as proxy).
  const dv = new DataView(buf);
  const sourceLen = dv.getUint32(20 /* H.SOURCE_LEN */, true);
  const needed = Math.max(sourceLen * 4 + 4096, 64 * 1024);
  if (_lintOutBuf.byteLength < needed) {
    _lintOutBuf = new ArrayBuffer(needed * 2);
  }

  const bytesWritten = b.lintBuffer(buf, lang, _lintOutBuf);
  if (bytesWritten < 4) return [];

  const dvOut = new DataView(_lintOutBuf);
  const count = dvOut.getUint32(0, true);
  const diags = [];
  let pos = 4;
  for (let i = 0; i < count && pos < bytesWritten; i++) {
    const offset   = dvOut.getUint32(pos, true); pos += 4;
    const severity = dvOut.getUint8(pos);         pos += 1;
    const ruleLen  = dvOut.getUint8(pos);          pos += 1;
    const ruleName = _decoder.decode(new Uint8Array(_lintOutBuf, pos, ruleLen)); pos += ruleLen;
    const msgLen   = dvOut.getUint16(pos, true);   pos += 2;
    const message  = _decoder.decode(new Uint8Array(_lintOutBuf, pos, msgLen));  pos += msgLen;
    diags.push({ offset, severity, ruleName, message });
  }
  return diags;
}

module.exports = { parse, lint, lintBuffer, parseAndLint, reset: resetBuffer, getTagNames, detectLang, LANG, HEADER_SIZE, MAGIC };
