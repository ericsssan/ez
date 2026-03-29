"use strict";

/**
 * Bun FFI fast path — calls the core C ABI exports directly via dlopen.
 * 2-6x faster than NAPI per Bun benchmarks.
 *
 * Falls back to NAPI if bun:ffi is unavailable.
 */

const { dlopen, FFIType, ptr, toArrayBuffer } = require("bun:ffi");
const { resolve } = require("path");

// Find the shared library
const libPath = resolve(__dirname, "../zig-out/lib/libsanz.dylib");

const lib = dlopen(libPath, {
  sanz_parse: {
    args: [FFIType.ptr, FFIType.u32, FFIType.u32, FFIType.u32, FFIType.u8],
    returns: FFIType.u32,
  },
  sanz_tag_count: {
    args: [],
    returns: FFIType.u32,
  },
  sanz_tag_name: {
    args: [FFIType.u8],
    returns: FFIType.ptr,
  },
});

function parse(buffer, sourceStart, sourceLen, lang) {
  const bufPtr = ptr(buffer);
  return lib.symbols.sanz_parse(bufPtr, buffer.byteLength, sourceStart, sourceLen, lang);
}

function tagCount() {
  return lib.symbols.sanz_tag_count();
}

const _decoder = new TextDecoder();

function tagName(index) {
  const namePtr = lib.symbols.sanz_tag_name(index);
  // Read null-terminated C string from pointer
  const buf = toArrayBuffer(namePtr, 0, 64);
  const bytes = new Uint8Array(buf);
  let len = 0;
  while (len < bytes.length && bytes[len] !== 0) len++;
  return _decoder.decode(bytes.subarray(0, len));
}

module.exports = { parse, tagCount, tagName };
