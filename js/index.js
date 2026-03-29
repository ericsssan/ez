"use strict";

const { AstView, setTagNames, reset: resetView } = require("./node-view");

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
const HEADER_SIZE = 64;
const MAGIC = 0x5A4E4153; // "SANZ" little-endian

let sharedBuffer = null;

function ensureBuffer(sourceLen) {
  const needed = HEADER_SIZE + sourceLen * 20; // heuristic: 20x source size
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

  // Encode source as UTF-8 into the buffer tail
  const encoded = _encoder.encode(source);
  const sourceLen = encoded.byteLength;

  const buf = ensureBuffer(sourceLen);
  const sourceStart = buf.byteLength - sourceLen;

  // Write source at the tail of the buffer
  new Uint8Array(buf).set(encoded, sourceStart);

  // Call native parse
  const bytesUsed = b.parse(buf, sourceStart, sourceLen, lang);
  if (bytesUsed === 0) {
    throw new Error("sanz: parse failed (buffer too small or invalid source)");
  }

  // Verify magic
  const dv = new DataView(buf);
  const magic = dv.getUint32(0, true);
  if (magic !== MAGIC) {
    throw new Error("sanz: invalid buffer header (magic mismatch)");
  }

  // Ensure tag names are loaded for NodeProto.type
  getTagNames();

  return new AstView(buf);
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
 * Cached after first call. Also initializes node-view.js TAG_NAMES.
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

module.exports = { parse, reset: resetBuffer, getTagNames, detectLang, LANG, HEADER_SIZE, MAGIC };
