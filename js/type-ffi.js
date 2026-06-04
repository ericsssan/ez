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
  // In a `bun build --compile` binary, prefer the embedded lib (a /$bunfs path
  // dlopen can open). Uncompiled, this require throws → fall back to on-disk.
  let dylib = null;
  try { const p = require("./native-embed.mjs").default; if (p) dylib = p; } catch {}
  if (!dylib) {
    const candidates = [
      path.join(__dirname, "../zig-out/lib/ez.node"),
      path.join(__dirname, "../zig-out/lib/libez.dylib"),
      path.join(__dirname, "../zig-out/lib/libez.so"),
    ];
    for (const c of candidates) if (fs.existsSync(c)) { dylib = c; break; }
  }
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
      ez_type_sig_rest_index:  { args: [H, U, U], returns: U },
      ez_type_sig_predicate_param:  { args: [H, U, U], returns: U },
      ez_type_sig_predicate_target: { args: [H, U, U], returns: U },
      ez_type_call_param_type: { args: [H, U, U], returns: U },
      ez_type_assignable:      { args: [H, U, U], returns: FFIType.u8 },
      ez_type_resolve_type_node: { args: [H, U], returns: U },
      ez_type_resolve_type_node_param: { args: [H, U], returns: U },
      ez_type_of_node_param: { args: [H, U], returns: U },
      ez_type_constraint: { args: [H, U], returns: U },
      ez_type_base_count: { args: [H, U], returns: U },
      ez_type_base_at: { args: [H, U, U], returns: U },
      ez_type_lit_string: { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_lit_number: { args: [H, U], returns: FFIType.f64 },
      ez_type_lit_bool:   { args: [H, U], returns: FFIType.u8 },
      // Object properties (by-name lookup; name passed as utf8 ptr+len).
      ez_type_prop_count:         { args: [H, U], returns: U },
      ez_type_prop_type_by_name:  { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_prop_flags_by_name: { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_prop_name_at:       { args: [H, U, U, FFIType.ptr, U], returns: U },
      ez_type_prop_type_at:       { args: [H, U, U], returns: U },
      ez_type_is_natively_bound:  { args: [H, U], returns: U },
      // Type arguments + name (type refs like Promise<T>).
      ez_type_type_arg_count: { args: [H, U], returns: U },
      ez_type_type_arg:       { args: [H, U, U], returns: U },
      ez_type_name_eq:        { args: [H, U, FFIType.ptr, U], returns: FFIType.u8 },
      ez_type_ref_name:       { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_alias_name:     { args: [H, U, FFIType.ptr, U], returns: U },
      ez_type_resolve_declared: { args: [H, FFIType.ptr, U], returns: U },
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
    // Index of the rest param (...args), or null if none.
    sigRestIndex(typeId, sigIdx) {
      const r = b.sym.ez_type_sig_rest_index(h, typeId >>> 0, sigIdx >>> 0);
      return r === 0xffff ? null : r;
    },
    // Type-predicate signature: narrowed parameter index (or null) + target type.
    sigPredicateParam(typeId, sigIdx) {
      const r = b.sym.ez_type_sig_predicate_param(h, typeId >>> 0, sigIdx >>> 0);
      return r === 0xffff ? null : r;
    },
    sigPredicateTarget(typeId, sigIdx) {
      const r = b.sym.ez_type_sig_predicate_target(h, typeId >>> 0, sigIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Instantiated type of a generic call's param (null if not a generic call).
    callParamType(callNodeIdx, paramIdx) {
      const r = b.sym.ez_type_call_param_type(h, callNodeIdx >>> 0, paramIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Three-valued assignability: 0=no, 1=yes, 2=unknown.
    assignable(source, target) { return b.sym.ez_type_assignable(h, source >>> 0, target >>> 0); },
    // Resolve a TS type-annotation node to its type (null on bad node).
    resolveTypeNode(nodeIdx) {
      const r = b.sym.ez_type_resolve_type_node(h, nodeIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Like resolveTypeNode, but a bare in-scope type parameter → a `.type_param`
    // type (carrying its constraint), for asserted types (`x as T`).
    resolveTypeNodeParam(nodeIdx) {
      const r = b.sym.ez_type_resolve_type_node_param(h, nodeIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // `.type_param` for an identifier value with a bare-param annotation (`a: T`),
    // or null. Used so the facade sees `a as T` as an identity assertion.
    typeOfNodeParam(nodeIdx) {
      const r = b.sym.ez_type_of_node_param(h, nodeIdx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Constraint TypeId of a `.type_param` (null if unconstrained / not a param).
    constraint(typeId) {
      const r = b.sym.ez_type_constraint(h, typeId >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Direct base types of an interface object_t (its `extends` clause).
    baseCount(typeId) { return b.sym.ez_type_base_count(h, typeId >>> 0); },
    baseAt(typeId, i) {
      const r = b.sym.ez_type_base_at(h, typeId >>> 0, i >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // Literal type values (for ts.LiteralType `.value` / boolean intrinsicName).
    litString(typeId) {
      const buf = Buffer.allocUnsafe(256);
      const n = b.sym.ez_type_lit_string(h, typeId >>> 0, b.ptr(buf), buf.length);
      return buf.toString("utf8", 0, n);
    },
    litNumber(typeId) { return b.sym.ez_type_lit_number(h, typeId >>> 0); },
    litBool(typeId) { return b.sym.ez_type_lit_bool(h, typeId >>> 0); }, // 1/0/0xFF
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
    // Enumerate properties by index — name + type (for getProperties()).
    propNameAt(typeId, idx) {
      const buf = Buffer.allocUnsafe(128);
      const n = b.sym.ez_type_prop_name_at(h, typeId >>> 0, idx >>> 0, b.ptr(buf), buf.length);
      return n > 0 ? buf.toString("utf8", 0, n) : "";
    },
    propTypeAt(typeId, idx) {
      const r = b.sym.ez_type_prop_type_at(h, typeId >>> 0, idx >>> 0);
      return r === NO_TYPE ? null : r;
    },
    // True when typeId is a natively-bound builtin global (Math/JSON/console)
    // whose methods are safe to extract unbound (unbound-method exemption).
    isNativelyBoundType(typeId) {
      return b.sym.ez_type_is_natively_bound(h, typeId >>> 0) === 1;
    },
    // Type arguments (type refs like Promise<T>, arrays, tuples).
    typeArgCount(typeId) { return b.sym.ez_type_type_arg_count(h, typeId >>> 0); },
    typeArg(typeId, i) {
      const r = b.sym.ez_type_type_arg(h, typeId >>> 0, i >>> 0);
      return r === NO_TYPE ? null : r;
    },
    nameEq(typeId, name) {
      const buf = Buffer.from(name, "utf8");
      return b.sym.ez_type_name_eq(h, typeId >>> 0, b.ptr(buf), buf.length) === 1;
    },
    // The type's name (e.g. "Set", "Promise"), or "" if unnamed. Used to key
    // per-generic ts.TypeReference.target identity in the facade.
    refName(typeId) {
      const buf = Buffer.allocUnsafe(64);
      const n = b.sym.ez_type_ref_name(h, typeId >>> 0, b.ptr(buf), buf.length);
      return n > 0 ? buf.toString("utf8", 0, n) : "";
    },
    // The type-alias name this type was resolved from (`type Foo = …` → "Foo"),
    // or "" — facade ts.Type.aliasSymbol.
    aliasName(typeId) {
      const buf = Buffer.allocUnsafe(64);
      const n = b.sym.ez_type_alias_name(h, typeId >>> 0, b.ptr(buf), buf.length);
      return n > 0 ? buf.toString("utf8", 0, n) : "";
    },
    // Resolve a declared type name → its TypeId (user interface/class/alias), or
    // null for lib/undeclared names. Lets the facade walk a base type_ref's bases.
    resolveDeclared(name) {
      const nb = Buffer.from(name, "utf8");
      const r = b.sym.ez_type_resolve_declared(h, b.ptr(nb), nb.length);
      return r === NO_TYPE ? null : r;
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
