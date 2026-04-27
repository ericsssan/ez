"use strict";

const { AstView, setTagNames, reset: resetView } = require("./estree-adapter");

// ── Load native binding ──────────────────────────────────────────

let binding;

function loadBinding() {
  if (binding) return binding;

  try {
    binding = require("../zig-out/lib/ez.node");
  } catch {
    try {
      binding = require("../zig-out/lib/libez.dylib");
    } catch {
      try {
        binding = require("../zig-out/lib/libez.so");
      } catch {
        throw new Error(
          "ez: could not load native binding. Run `make napi` first."
        );
      }
    }
  }
  return binding;
}

// ── Buffer management ────────────────────────────────────────────

const DEFAULT_BUFFER_SIZE = 4 * 1024 * 1024; // 4 MB
const HEADER_SIZE = 136; // 34 fields × 4 bytes
const MAGIC = 0x5A4E4153; // ASCII "SANZ" little-endian — legacy magic, kept for binary stability

let sharedBuffer = null;

// Ensure sharedBuffer can hold a source of `sourceLen` bytes after parse
// (headers + node/token/extra arrays).  The 30x multiplier is a heuristic
// worst-case inflation factor for AST output relative to source bytes.
function ensureBuffer(sourceLen) {
  return ensureBufferBytes(HEADER_SIZE + sourceLen * 30);
}

// Ensure sharedBuffer has at least `totalBytes` capacity.  Used when the
// Zig side reports an exact needed size and we don't want to re-apply the
// 30x heuristic on top of an already-exact number.  Previously both retry
// paths (parseFile, parseAndLintFile) passed a raw byte count to
// ensureBuffer(sourceLen), which tripled the allocation to ~30x the
// reported need — a 4 MB need ballooned sharedBuffer to 120 MB and
// that ArrayBuffer stuck around for the whole process.
function ensureBufferBytes(totalBytes) {
  const minSize = Math.max(totalBytes, DEFAULT_BUFFER_SIZE);
  // Grow-only: never shrink. Shrinking would orphan the old buffer, and any
  // AstView with noPrivateCopy wrapping it would hold an unreachable reference.
  // Staying at the high-water mark costs at most one large allocation; resize
  // events are O(log n) over any bounded corpus so the cost is negligible.
  if (!sharedBuffer || sharedBuffer.byteLength < minSize) {
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
  const semEnd = semOff > 0 ? semOff + 152 : 0; // SemanticHeader = 152 bytes
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
          const orig = nameStartsArr[i];
          // Only shift offsets that point into the source text.
          // Names in the bump region (implicit globals, offset < sourceStart) are already
          // at the correct offset in the private buffer — no shift needed.
          if (orig >= sourceStart) nameStartsArr[i] = (orig + shift) >>> 0;
        }
      }
    }
  }
  const magic = pdv.getUint32(0, true);
  if (magic !== MAGIC) throw new Error("ez: invalid buffer header (magic mismatch)");
  return privateBuf;
}

/**
 * Parse packed binary diagnostics from the lint output buffer.
 * If srcBytes is provided, each diag includes line/col.
 */
// Cache native rule names for index→name mapping
let _nativeRuleNames = null;

function _getNativeRuleNames() {
  if (_nativeRuleNames) return _nativeRuleNames;
  const rules = getNativeRules();
  _nativeRuleNames = new Array(rules.size);
  for (const [name, info] of rules) _nativeRuleNames[info.index] = name;
  return _nativeRuleNames;
}

/**
 * Parse compact binary diagnostics.
 * Format: count(u32) + per-diag: rule_index(u16) + offset(u32) + flags(u8) = 7 bytes base.
 * flags bits 0-1 = severity (1=warn, 2=error), bit 2 = has_fix.
 * If has_fix: fix_start(u32) + fix_end(u32) + fix_text_len(u16) + fix_text(n) follows.
 */
function _parseDiags(bytesWritten, srcBytes) {
  if (bytesWritten < 4) return [];
  const dv = new DataView(_lintOutBuf);
  const count = dv.getUint32(0, true);
  const ruleNames = _getNativeRuleNames();
  const diags = [];
  let pos = 4;
  for (let i = 0; i < count; i++) {
    if (pos + 7 > bytesWritten) break;
    const ruleIndex = dv.getUint16(pos, true);    pos += 2;
    const offset    = dv.getUint32(pos, true);    pos += 4;
    const flags     = dv.getUint8(pos);           pos += 1;
    const severity  = flags & 0x03;
    const hasFix    = (flags & 0x04) !== 0;
    const ruleName  = ruleNames[ruleIndex] || `native-rule-${ruleIndex}`;
    const diag = { offset, severity, ruleName };
    if (srcBytes) {
      diag.line = _bufOffsetToLine(srcBytes, offset);
      diag.col = _bufOffsetToCol(srcBytes, offset);
    }
    if (hasFix) {
      if (pos + 10 > bytesWritten) break;
      const fixStart   = dv.getUint32(pos, true);     pos += 4;
      const fixEnd     = dv.getUint32(pos, true);     pos += 4;
      const fixTextLen = dv.getUint16(pos, true);     pos += 2;
      if (pos + fixTextLen > bytesWritten) break;
      const fixTextBytes = new Uint8Array(_lintOutBuf, pos, fixTextLen); pos += fixTextLen;
      diag.fix = { range: [fixStart, fixEnd], text: new TextDecoder().decode(fixTextBytes) };
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
  // Pass globals as null-separated UTF-8 bytes so Zig pre-declares them in scope 0,
  // making scope.through exact without JS post-processing.
  let bytesUsed;
  const globals = options.globals;
  if (globals && globals.length > 0) {
    const globalsU8 = Buffer.from(globals.join('\0'), 'utf8');
    bytesUsed = b.parse(buf, sourceStart, sourceLen, lang, globalsU8);
  } else {
    bytesUsed = b.parse(buf, sourceStart, sourceLen, lang);
  }
  if (bytesUsed === 0) throw new Error("ez: parse failed (buffer too small or invalid source)");

  getTagNames();
  if (options.noPrivateCopy) return new AstView(buf);
  const privateBuf = _makePrivateBuf(buf, sourceStart, sourceLen);
  // Allow caller to override source_type in the header (offset 84).
  // Needed when parsing script-mode code (sourceType: "script").
  if (options.sourceType === "script") {
    new DataView(privateBuf).setUint32(84, 0, true);
  } else if (options.sourceType === "module") {
    new DataView(privateBuf).setUint32(84, 1, true);
  }
  return new AstView(privateBuf);
}

function parse(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  let buf = sharedBuffer || ensureBufferBytes(DEFAULT_BUFFER_SIZE);
  let bytesUsed = b.parseFile(buf, filePath, lang);
  if (bytesUsed === 0) {
    const needed = new DataView(buf).getUint32(0, true);
    if (needed > 0 && needed + HEADER_SIZE > buf.byteLength) {
      buf = ensureBufferBytes(needed + HEADER_SIZE);
      sharedBuffer = buf;
      bytesUsed = b.parseFile(buf, filePath, lang);
    }
    if (bytesUsed === 0) throw new Error(`ez: parse failed: ${filePath}`);
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

function lintSourceNative(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang
    ? LANG[options.lang] ?? LANG.js
    : options.filename ? detectLang(options.filename) : LANG.js;

  const { buf, sourceStart, sourceLen } = _encodeSource(source);
  _ensureLintOutBuf(sourceLen);

  let configBuf;
  if (options.config instanceof Uint8Array) {
    configBuf = options.config;
  } else if (options.rules) {
    // Build a native config from the rules object so options (hoist, allow, etc.) are honoured.
    configBuf = buildNativeConfig({ rules: options.rules });
  }
  const bytesWritten = b.lint(buf, sourceStart, sourceLen, lang, _lintOutBuf, configBuf);
  const srcBytes = new Uint8Array(buf, sourceStart, sourceLen);
  return _parseDiags(bytesWritten, srcBytes);
}

function parseAndLintNative(filePath, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js : detectLang(filePath);

  if (_lintOutBuf.byteLength < 64 * 1024) _lintOutBuf = new ArrayBuffer(128 * 1024);

  const configBuf = options.config instanceof Uint8Array ? options.config : undefined;
  let buf = sharedBuffer || ensureBufferBytes(DEFAULT_BUFFER_SIZE);
  let bytesUsed = b.parseAndLintFile(buf, filePath, lang, _lintOutBuf, configBuf);
  if (bytesUsed === 0) {
    const needed = new DataView(buf).getUint32(0, true);
    if (needed > 0 && needed + HEADER_SIZE > buf.byteLength) {
      buf = ensureBufferBytes(needed + HEADER_SIZE);
      sharedBuffer = buf;
      bytesUsed = b.parseAndLintFile(buf, filePath, lang, _lintOutBuf, configBuf);
    }
    if (bytesUsed === 0) throw new Error(`ez: parseAndLintNative failed: ${filePath}`);
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

function buildNativeConfig(configObj) {
  return _encoder.encode(JSON.stringify(configObj));
}

// ── Batch IO functions ───────────────────────────────────────────

const _textDec = new TextDecoder();

/**
 * Decode binary file-list buffer returned by discoverFiles().
 * Format: u32 count, (u16 path_len, u8[] path, u32 size) per entry.
 */
function _decodeFileList(buf) {
  const u8 = new Uint8Array(buf);
  const dv = new DataView(buf);
  const count = dv.getUint32(0, true);
  const paths = new Array(count);
  const sizes = new Uint32Array(count);
  let pos = 4;
  for (let i = 0; i < count; i++) {
    const len = dv.getUint16(pos, true); pos += 2;
    paths[i] = _textDec.decode(u8.subarray(pos, pos + len)); pos += len;
    sizes[i] = dv.getUint32(pos, true); pos += 4;
  }
  return { paths, sizes };
}

/**
 * Discover JS/TS source files under root paths (in Zig — no JS readdirSync).
 * Returns { paths: string[], sizes: Uint32Array }.
 */
function discoverFiles(roots) {
  const b = loadBinding();
  const buf = b.discoverFiles(Array.isArray(roots) ? roots : [roots]);
  return _decodeFileList(buf);
}

/**
 * Lean parse: lex + parse only. No semantic, no traversal arrays, no UTF-16
 * conversion, no node positions. Apples-to-apples vs other parser-only NAPI
 * bindings (oxc-parser parseSync, etc.). Returns the raw bytes-used count
 * from the binding; the caller is responsible for treating the buffer as
 * opaque (no AstView wrapping). For raw throughput measurement.
 */
function parseSourceLean(source, options = {}) {
  const b = loadBinding();
  const lang = options.lang ? LANG[options.lang] ?? LANG.js
    : options.filename ? detectLang(options.filename) : LANG.js;
  const { buf, sourceStart, sourceLen } = _encodeSource(source);
  return b.parseLean(buf, sourceStart, sourceLen, lang);
}

module.exports = { parse, parseSource, parseSourceLean, parseAndLintNative, lintSourceNative, discoverFiles, getNativeRules, buildNativeConfig, reset: resetBuffer, getTagNames, detectLang, LANG, HEADER_SIZE, MAGIC };
