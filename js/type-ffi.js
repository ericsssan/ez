"use strict";

// bun:ffi binding for the persistent type-query handle (src/cli/type_ffi.zig).
//
// Backs the lazy type-aware bridge: open a handle for a source file, query node
// types on demand, close it. The ts.Type facade (ts-services.js) sits on top of
// these primitives. Degrades to null when bun:ffi or the native lib is absent —
// callers fall back to the type-less light parserServices.

const path = require("path");
const fs = require("fs");

const LANG = { js: 0, ts: 1, jsx: 2, tsx: 3, dts: 4 };
const NO_TYPE = 0xffffffff;

let _binding; // undefined = not tried, null = unavailable, object = ready

function binding() {
  if (_binding !== undefined) return _binding;
  let dlopen, FFIType, ptr;
  try {
    ({ dlopen, FFIType, ptr } = require("bun:ffi"));
  } catch {
    _binding = null;
    return null;
  }
  const candidates = [
    path.join(__dirname, "../zig-out/lib/ez.node"),
    path.join(__dirname, "../zig-out/lib/libez.dylib"),
    path.join(__dirname, "../zig-out/lib/libez.so"),
  ];
  let dylib = null;
  for (const c of candidates) if (fs.existsSync(c)) { dylib = c; break; }
  if (!dylib) { _binding = null; return null; }

  const U = FFIType.u32, H = FFIType.u64_fast;
  let lib;
  try {
    lib = dlopen(dylib, {
      ez_type_open:        { args: [FFIType.ptr, U, FFIType.u8, FFIType.u8], returns: H },
      ez_type_close:       { args: [H], returns: FFIType.void },
      ez_type_node_count:  { args: [H], returns: U },
      ez_type_of_node:     { args: [H, U], returns: U },
      ez_type_kind:        { args: [H, U], returns: FFIType.u8 },
      ez_type_flags:       { args: [H, U], returns: U },
      ez_type_array_elem:  { args: [H, U], returns: U },
      ez_type_member_count:{ args: [H, U], returns: U },
      ez_type_member_at:   { args: [H, U, U], returns: U },
      // Call signatures (params + return type).
      ez_type_sig_count:       { args: [H, U], returns: U },
      ez_type_sig_return:      { args: [H, U, U], returns: U },
      ez_type_sig_param_count: { args: [H, U, U], returns: U },
      ez_type_sig_param:       { args: [H, U, U, U], returns: U },
      ez_type_sig_flags:       { args: [H, U, U], returns: U },
      // Object properties (by-name lookup; name passed as utf8 ptr+len).
      ez_type_prop_count:         { args: [H, U], returns: U },
      ez_type_prop_type_by_name:  { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_prop_flags_by_name: { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_tag_last:    { args: [U], returns: FFIType.void },
      ez_type_open_reuse:  { args: [U], returns: H },
    });
  } catch {
    _binding = null;
    return null;
  }
  _binding = { sym: lib.symbols, ptr };
  return _binding;
}

function isAvailable() {
  return binding() !== null;
}

function _handleObj(b, h) {
  return {
    handle: h,
    nodeCount() { return b.sym.ez_type_node_count(h); },
    typeOfNode(nodeIdx) {
      const tid = b.sym.ez_type_of_node(h, nodeIdx >>> 0);
      return tid === NO_TYPE ? null : tid;
    },
    kind(typeId) { return b.sym.ez_type_kind(h, typeId >>> 0); },
    flags(typeId) { return b.sym.ez_type_flags(h, typeId >>> 0); },
    arrayElem(typeId) {
      const e = b.sym.ez_type_array_elem(h, typeId >>> 0);
      return e === NO_TYPE ? null : e;
    },
    members(typeId) {
      const n = b.sym.ez_type_member_count(h, typeId >>> 0);
      const out = new Array(n);
      for (let i = 0; i < n; i++) out[i] = b.sym.ez_type_member_at(h, typeId >>> 0, i);
      return out;
    },
    // Call signatures.
    sigCount(typeId) { return b.sym.ez_type_sig_count(h, typeId >>> 0); },
    sigReturn(typeId, sigIdx) {
      const r = b.sym.ez_type_sig_return(h, typeId >>> 0, sigIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    sigParamCount(typeId, sigIdx) { return b.sym.ez_type_sig_param_count(h, typeId >>> 0, sigIdx >>> 0); },
    sigParam(typeId, sigIdx, paramIdx) {
      const r = b.sym.ez_type_sig_param(h, typeId >>> 0, sigIdx >>> 0, paramIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    sigFlags(typeId, sigIdx) { return b.sym.ez_type_sig_flags(h, typeId >>> 0, sigIdx >>> 0); },
    // Object properties (by name).
    propCount(typeId) { return b.sym.ez_type_prop_count(h, typeId >>> 0); },
    propType(typeId, name) {
      const buf = Buffer.from(name, "utf8");
      const r = b.sym.ez_type_prop_type_by_name(h, typeId >>> 0, b.ptr(buf), buf.length);
      return r === NO_TYPE ? null : r;
    },
    // Flag bits (1=optional,2=readonly,4=method,8=fn-property) or -1 if absent.
    propFlags(typeId, name) {
      const buf = Buffer.from(name, "utf8");
      const r = b.sym.ez_type_prop_flags_by_name(h, typeId >>> 0, b.ptr(buf), buf.length);
      return r === NO_TYPE ? -1 : r;
    },
    close() { b.sym.ez_type_close(h); },
  };
}

/// Open a type-query handle for `source` (fresh parse). Returns a handle object
/// with query methods, or null if the native bridge is unavailable. Caller MUST
/// .close().
function open(source, lang = "ts", isModule = true) {
  const b = binding();
  if (!b) return null;
  const langCode = typeof lang === "number" ? lang : (LANG[lang] ?? LANG.ts);
  const bytes = Buffer.from(source, "utf8");
  const h = b.sym.ez_type_open(b.ptr(bytes), bytes.length, langCode, isModule ? 1 : 0);
  if (!h || h === 0) return null;
  return _handleObj(b, h);
}

/// Stamp the generation of the parse JS just completed (so the matching
/// `openReuse(gen)` reuses exactly that parse).
function tagLast(gen) {
  const b = binding();
  if (b) b.sym.ez_type_tag_last(gen >>> 0);
}

/// Open a handle that REUSES the runner's just-tagged parse — no second parse.
/// Returns a handle object, or null if the tagged parse isn't available (the
/// caller should fall back to `open`). The handle is valid only until the next
/// parse on this thread; close it before then.
function openReuse(gen) {
  const b = binding();
  if (!b) return null;
  const h = b.sym.ez_type_open_reuse(gen >>> 0);
  if (!h || h === 0) return null;
  return _handleObj(b, h);
}

module.exports = { open, openReuse, tagLast, isAvailable, LANG, NO_TYPE };
