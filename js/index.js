"use strict";

const { AstView, setTagNames, reset: resetView } = require("./estree-adapter");

// ── Load native binding ──────────────────────────────────────────

let binding;

function loadBinding() {
  if (binding) return binding;

  if (typeof Bun !== "undefined") {
    try {
      binding = require("./bun-ffi");
      return binding;
    } catch {
      // Fall through to NAPI
    }
  }

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
const HEADER_SIZE = 116; // 29 fields × 4 bytes
const MAGIC = 0x5A4E4153; // "SANZ" little-endian

let sharedBuffer = null;

function ensureBuffer(sourceLen) {
  const needed = HEADER_SIZE + sourceLen * 30;
  const minSize = Math.max(needed, DEFAULT_BUFFER_SIZE);

  if (!sharedBuffer || sharedBuffer.byteLength < minSize) {
    sharedBuffer = new ArrayBuffer(minSize);
  } else if (sharedBuffer.byteLength > minSize * 4) {
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

// ── Shared helpers ──────────────────────────────────────────────

const _encoder = new TextEncoder();
const _decoder = new TextDecoder();
let _cachedTagNames = null;

// Persistent output buffer — grown as needed, never shrunk (high-water-mark).
let _lintOutBuf = new ArrayBuffer(64 * 1024);

/**
 * Encode a source string into the shared parse buffer.
 * Returns { buf, sourceStart, sourceLen }.
 */
function _encodeSource(source) {
  const reservedLen = source.length + 128;
  let buf = ensureBuffer(reservedLen);
  let sourceStart = buf.byteLength - reservedLen;
  const { read, written } = _encoder.encodeInto(source, new Uint8Array(buf, sourceStart, reservedLen));
  if (read === source.length) {
    return { buf, sourceStart, sourceLen: written };
  }
  const encoded = _encoder.encode(source);
  buf = ensureBuffer(encoded.byteLength);
  sourceStart = buf.byteLength - encoded.byteLength;
  new Uint8Array(buf).set(encoded, sourceStart);
  return { buf, sourceStart, sourceLen: encoded.byteLength };
}

/**
 * Copy AST data from shared buffer into a private buffer.
 * Adjusts SOURCE_OFFSET and symbol name pointers.
 * Returns the private ArrayBuffer.
 */
function _makePrivateBuf(buf, sourceStart, sourceLen) {
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
  if (magic !== MAGIC) throw new Error("sanz: invalid buffer header (magic mismatch)");
  return privateBuf;
}

/**
 * Parse packed binary diagnostics from the lint output buffer.
 * If srcBytes is provided, each diag includes line/col.
 */
function _parseDiags(bytesWritten, srcBytes) {
  if (bytesWritten < 4) return [];
  const dv = new DataView(_lintOutBuf);
  const count = dv.getUint32(0, true);
  const diags = [];
  let pos = 4;
  for (let i = 0; i < count; i++) {
    if (pos + 8 > bytesWritten) break;
    const offset   = dv.getUint32(pos, true); pos += 4;
    const severity = dv.getUint8(pos);         pos += 1;
    const ruleLen  = dv.getUint8(pos);          pos += 1;
    const ruleName = _decoder.decode(new Uint8Array(_lintOutBuf, pos, ruleLen)); pos += ruleLen;
    const msgLen   = dv.getUint16(pos, true);   pos += 2;
    const message  = _decoder.decode(new Uint8Array(_lintOutBuf, pos, msgLen));  pos += msgLen;
    const diag = { offset, severity, ruleName, message };
    if (srcBytes) {
      diag.line = _bufOffsetToLine(srcBytes, offset);
      diag.col = _bufOffsetToCol(srcBytes, offset);
    }
    diags.push(diag);
  }
  return diags;
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

function _ensureLintOutBuf(sourceLen) {
  const needed = Math.max(sourceLen * 4 + 4096, 64 * 1024);
  if (_lintOutBuf.byteLength < needed) {
    _lintOutBuf = new ArrayBuffer(needed * 2);
  }
}

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

// ── Public API ───────────────────────────────────────────────────

function parseSource(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename ? detectLang(options.filename) : LANG.js;

  const { buf, sourceStart, sourceLen } = _encodeSource(source);
  const bytesUsed = b.parse(buf, sourceStart, sourceLen, lang);
  if (bytesUsed === 0) throw new Error("sanz: parse failed (buffer too small or invalid source)");

  getTagNames();
  if (options.noPrivateCopy) return new AstView(buf);
  return new AstView(_makePrivateBuf(buf, sourceStart, sourceLen));
}

function parse(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  let buf = sharedBuffer || ensureBuffer(DEFAULT_BUFFER_SIZE);
  let bytesUsed = b.parseFile(buf, filePath, lang);
  if (bytesUsed === 0) {
    const needed = new DataView(buf).getUint32(0, true);
    if (needed > 0 && needed + HEADER_SIZE > buf.byteLength) {
      buf = ensureBuffer(needed);
      sharedBuffer = buf;
      bytesUsed = b.parseFile(buf, filePath, lang);
    }
    if (bytesUsed === 0) throw new Error(`sanz: parse failed: ${filePath}`);
  }
  sharedBuffer = buf;
  getTagNames();

  if (options.noPrivateCopy) return new AstView(buf);

  const dv0 = new DataView(buf);
  const sourceLen = dv0.getUint32(20, true);
  const sourceStart = dv0.getUint32(52, true);
  return new AstView(_makePrivateBuf(buf, sourceStart, sourceLen));
}

function resetBuffer() {
  resetView();
}

function lintSource(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename ? detectLang(options.filename) : LANG.js;

  const { buf, sourceStart, sourceLen } = _encodeSource(source);
  _ensureLintOutBuf(sourceLen);

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const bytesWritten = b.lint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
  return _parseDiags(bytesWritten);
}

function lint(paths, options = {}) {
  const b = loadBinding();
  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const sizes = options.sizes instanceof Uint32Array ? options.sizes : undefined;
  return b.lintFiles(paths, sizes, configBuf);
}

function parseAndLintSource(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename ? detectLang(options.filename) : LANG.js;

  const { buf, sourceStart, sourceLen } = _encodeSource(source);
  _ensureLintOutBuf(sourceLen);

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  const bytesUsed = b.parseAndLint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
  if (bytesUsed === 0) throw new Error("sanz: parseAndLint failed (buffer too small or invalid source)");

  getTagNames();
  const ast = options.noPrivateCopy
    ? new AstView(buf)
    : new AstView(_makePrivateBuf(buf, sourceStart, sourceLen));
  const diags = _parseDiags(bytesUsed);
  return { ast, diags };
}

function parseAndLint(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  if (_lintOutBuf.byteLength < 64 * 1024) _lintOutBuf = new ArrayBuffer(128 * 1024);

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  let buf = sharedBuffer || ensureBuffer(DEFAULT_BUFFER_SIZE);
  let bytesUsed = b.parseAndLintFile(buf, filePath, lang, _lintOutBuf, configBuf);
  if (bytesUsed === 0) {
    const needed = new DataView(buf).getUint32(0, true);
    if (needed > 0 && needed + HEADER_SIZE > buf.byteLength) {
      buf = ensureBuffer(needed);
      sharedBuffer = buf;
      bytesUsed = b.parseAndLintFile(buf, filePath, lang, _lintOutBuf, configBuf);
    }
    if (bytesUsed === 0) throw new Error(`sanz: parseAndLint failed: ${filePath}`);
  }
  sharedBuffer = buf;
  getTagNames();

  const dv0 = new DataView(buf);
  const sourceLen = dv0.getUint32(20, true);
  const sourceStart = dv0.getUint32(52, true);

  const ast = options.noPrivateCopy
    ? new AstView(buf)
    : new AstView(_makePrivateBuf(buf, sourceStart, sourceLen));

  const srcBytes = new Uint8Array(buf, sourceStart, sourceLen);
  const diags = _parseDiags(bytesUsed, srcBytes);
  return { ast, diags };
}

// ── Native rule config ───────────────────────────────────────────

let _nativeRulesMap = null;

function getNativeRules() {
  if (_nativeRulesMap === null) {
    const b = loadBinding();
    const arr = b.getNativeRules();
    _nativeRulesMap = new Map(arr.map(r => [r.name, r]));
  }
  return _nativeRulesMap;
}

function buildNativeConfig(rulesObj) {
  const nativeRules = getNativeRules();
  const buf = new Uint8Array(nativeRules.size);
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

module.exports = { parse, parseSource, parseAndLint, parseAndLintSource, lintSource, lint, getNativeRules, buildNativeConfig, reset: resetBuffer, getTagNames, detectLang, LANG, HEADER_SIZE, MAGIC };
