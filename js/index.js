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
        const shift = srcStart - sourceStart; // negative: sourceStart >> srcStart
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
 * Parse a file by path — Zig reads it directly (no TextEncoder overhead).
 *
 * @param {string} filePath - Absolute or relative path to the file
 * @param {object} [options] - { lang?: 'js'|'ts'|'jsx'|'tsx' }
 * @returns {AstView}
 */
function parseFile(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  const { buf, sourceLen, sourceStart } = _loadFile(filePath);

  const bytesUsed = b.parse(buf, sourceStart, sourceLen, lang);
  if (bytesUsed === 0) {
    throw new Error(`sanz: parse failed: ${filePath}`);
  }

  // Same private-buffer copy logic as parse().
  const dv0 = new DataView(buf);
  const totalUsed = dv0.getUint32(56, true);
  const semOff = dv0.getUint32(68, true);
  const semEnd = semOff > 0 ? semOff + 96 : 0;
  const srcStart = Math.max(totalUsed, semEnd);
  const privateSize = srcStart + sourceLen;
  const privateArr = new Uint8Array(privateSize);
  privateArr.set(new Uint8Array(buf, 0, totalUsed));
  privateArr.set(new Uint8Array(buf, sourceStart, sourceLen), srcStart);
  const privateBuf = privateArr.buffer;
  const pdv = new DataView(privateBuf);
  pdv.setUint32(52, srcStart, true);
  if (semOff > 0) {
    const symCount = pdv.getUint32(semOff + 4, true);
    if (symCount > 0) {
      const nameStartsArrOff = pdv.getUint32(semOff + 60, true);
      if (nameStartsArrOff > 0 && nameStartsArrOff + symCount * 4 <= totalUsed) {
        const nameStartsArr = new Uint32Array(privateBuf, nameStartsArrOff, symCount);
        const shift = srcStart - sourceStart;
        for (let i = 0; i < symCount; i++) {
          nameStartsArr[i] = (nameStartsArr[i] + shift) >>> 0;
        }
      }
    }
  }
  const magic = pdv.getUint32(0, true);
  if (magic !== MAGIC) throw new Error(`sanz: invalid buffer header: ${filePath}`);
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

// ── File I/O helpers ─────────────────────────────────────────────

/**
 * Read a file directly into the tail of the shared parse buffer via Zig libc.
 * Returns sourceLen. If sourceLen > buf.byteLength, buffer was too small —
 * caller must resize and retry.
 */
function _readFileToBuf(path, buf) {
  const b = loadBinding();
  return b.readFileToBuf(path, buf);
}

/** Count 1-based line number for a UTF-8 byte offset. */
function _bufOffsetToLine(bytes, offset) {
  let line = 1;
  const end = Math.min(offset, bytes.length);
  for (let i = 0; i < end; i++) {
    if (bytes[i] === 10) line++;
  }
  return line;
}

/** Count 0-based column for a UTF-8 byte offset. */
function _bufOffsetToCol(bytes, offset) {
  const end = Math.min(offset, bytes.length);
  for (let i = end; i > 0; i--) {
    if (bytes[i - 1] === 10) return end - i;
  }
  return end;
}

/**
 * Load a file into the shared buffer, resizing if needed.
 * Returns { buf, sourceLen, sourceStart }.
 * Throws on read failure or empty result.
 */
function _loadFile(path) {
  let buf = sharedBuffer || ensureBuffer(DEFAULT_BUFFER_SIZE);
  let sourceLen = _readFileToBuf(path, buf);
  if (sourceLen === 0) throw new Error(`sanz: cannot read file: ${path}`);
  if (sourceLen > buf.byteLength) {
    buf = ensureBuffer(sourceLen);
    sourceLen = _readFileToBuf(path, buf);
    if (sourceLen === 0 || sourceLen > buf.byteLength) throw new Error(`sanz: read failed after resize: ${path}`);
  }
  return { buf, sourceLen, sourceStart: buf.byteLength - sourceLen };
}

// ── Lint ─────────────────────────────────────────────────────────

const _decoder = new TextDecoder();

// Persistent output buffer — grown as needed, never shrunk (high-water-mark).
let _lintOutBuf = new ArrayBuffer(64 * 1024);

/**
 * Lint source code or multiple files using the native Zig lint rules.
 *
 * Single-file form:
 *   lint(source: string, options?) → Array<{offset, severity, ruleName, message}>
 *
 * Batch form (parallel via Zig OS threads):
 *   lint(filePaths: string[], options?) → Array<{file: string, diags: Array<{offset, severity, ruleName, message}>}>
 *   Zig workers read files and parse+lint in parallel (no JS-side I/O).
 *
 * @param {string|string[]} source  Source string or array of file paths
 * @param {object} [options]        { filename?, lang?, config?: Uint8Array }
 */
function lint(source, options = {}) {
  if (Array.isArray(source)) {
    const b = loadBinding();
    const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
    const sizes = options.sizes instanceof Uint32Array ? options.sizes : undefined;
    return b.lintFiles(source, sizes, configBuf);
  }
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

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const bytesWritten = b.lint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
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
  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const bytesUsed = b.parseAndLint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
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
 * Parse + lint a file by path — Zig reads it directly.
 * Diags include {line, col} computed from source bytes (no re-read needed).
 *
 * @param {string} filePath
 * @param {object} [options] - { lang?, config?: Uint8Array }
 * @returns {{ ast: AstView, diags: Array<{offset, line, col, severity, ruleName, message}> }}
 */
function parseAndLintFile(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  const { buf, sourceLen, sourceStart } = _loadFile(filePath);

  const needed = Math.max(sourceLen * 4 + 4096, 64 * 1024);
  if (_lintOutBuf.byteLength < needed) _lintOutBuf = new ArrayBuffer(needed * 2);

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const bytesUsed = b.parseAndLint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
  if (bytesUsed === 0) {
    throw new Error(`sanz: parseAndLint failed: ${filePath}`);
  }

  // Build private AstView (same copy logic as parseAndLint()).
  const dv0 = new DataView(buf);
  const totalUsed = dv0.getUint32(56, true);
  const semOff = dv0.getUint32(68, true);
  const semEnd = semOff > 0 ? semOff + 96 : 0;
  const srcStart = Math.max(totalUsed, semEnd);
  const privateSize = srcStart + sourceLen;
  const privateArr = new Uint8Array(privateSize);
  privateArr.set(new Uint8Array(buf, 0, totalUsed));
  privateArr.set(new Uint8Array(buf, sourceStart, sourceLen), srcStart);
  const privateBuf = privateArr.buffer;
  const pdv = new DataView(privateBuf);
  pdv.setUint32(52, srcStart, true);
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

  // Parse diags — compute line/col from source bytes still in buf (valid until next _loadFile).
  const srcBytes = new Uint8Array(buf, sourceStart, sourceLen);
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
    diags.push({
      offset,
      line: _bufOffsetToLine(srcBytes, offset),
      col:  _bufOffsetToCol(srcBytes, offset),
      severity,
      ruleName,
      message,
    });
  }

  return { ast, diags };
}

// ── Native rule config ───────────────────────────────────────────

let _nativeRulesMap = null;

/**
 * Get metadata for all natively-implemented lint rules.
 * Returns a Map<name, {name, index, category, defaultSeverity}>.
 * Cached after first call.
 */
function getNativeRules() {
  if (_nativeRulesMap === null) {
    const b = loadBinding();
    const arr = b.getNativeRules();
    _nativeRulesMap = new Map(arr.map(r => [r.name, r]));
  }
  return _nativeRulesMap;
}

/**
 * Build a severity config buffer for the native linter from an ESLint rules object.
 *
 * Only rules with a native Zig implementation are included; all others are ignored.
 * Rules not present in rulesObj default to OFF (not the rule's own default severity).
 * This lets callers route only their explicitly-configured native rules to Zig, and
 * send the rest to the JS runner.
 *
 * @param {Object} rulesObj - ESLint-style rules: { "no-debugger": "error", "no-var": 1 }
 * @returns {Uint8Array} Severity table — pass as options.config to lint/parseAndLint/lintBuffer
 */
function buildNativeConfig(rulesObj) {
  const nativeRules = getNativeRules();
  const buf = new Uint8Array(nativeRules.size); // all off by default
  for (const [ruleName, severity] of Object.entries(rulesObj)) {
    const info = nativeRules.get(ruleName);
    if (!info) continue;
    const sev = typeof severity === 'number'
      ? Math.min(2, Math.max(0, severity))
      : severity === 'error' || severity === '2' ? 2
      : (severity === 'warn' || severity === 'warning' || severity === '1') ? 1
      : 0;
    buf[info.index] = sev;
  }
  return buf;
}

module.exports = { parse, parseFile, lint, parseAndLint, parseAndLintFile, getNativeRules, buildNativeConfig, reset: resetBuffer, getTagNames, detectLang, LANG, HEADER_SIZE, MAGIC };
