"use strict";
/**
 * FFI-backed ESLint API node-property access vs the existing JS getter path.
 *
 * Measures `Identifier.name` (the heaviest single ESTree-spec property — `_identAt` is
 * 4.9% of total dispatch time on binder.ts) plus the supporting accessors:
 *   - node.type  (ez_ffi_node_tag → tag → tagNames lookup)
 *   - node.range (ez_ffi_node_range → [start, end])
 *   - node.parent (ez_ffi_node_parent → parent node index)
 *
 * Compares apples-to-apples: same input file, same identifier nodes, same access
 * patterns. Reports ns/access for each side.
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const fs   = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "..");

const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
const { dlopen, FFIType, ptr } = require("bun:ffi");

const lib = dlopen(path.join(ROOT, "zig-out/lib/ez.node"), {
  ez_ffi_node_tag:              { args: [FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
  ez_ffi_node_main_token:       { args: [FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
  ez_ffi_node_parent:           { args: [FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
  ez_ffi_node_range:            { args: [FFIType.ptr, FFIType.u32, FFIType.ptr], returns: FFIType.void },
  ez_ffi_node_ident_name_into:  { args: [FFIType.ptr, FFIType.u32, FFIType.ptr, FFIType.u32], returns: FFIType.u32 },
});
const ffi = lib.symbols;

const file = path.join(ROOT, "tests/conformance/typescript/src/compiler/binder.ts");
const src  = fs.readFileSync(file, "utf8");
const tagNames = getTagNames();
const ast = parseSource(src, { filename: file });
const buf = ast.buffer;
const bufBytes = new Uint8Array(buf);
const bufPtr = ptr(bufBytes);

console.log(`File: ${path.basename(file)} (${(src.length/1024).toFixed(0)} KB, ${ast.nodeCount} nodes)`);

// Find every Identifier node index by scanning the tags array directly.
// (Faster than walking via JS AstView for the bench setup.)
const dv = new DataView(buf);
const tagsOff = dv.getUint32(28, true);             // H_TAGS_OFFSET
const tagsArr = new Uint8Array(buf, tagsOff, ast.nodeCount);
const identifierTagIds = new Set();
for (let i = 0; i < tagNames.length; i++) {
  if (tagNames[i] === "Identifier") identifierTagIds.add(i);
}
const identifierIdxs = [];
for (let i = 0; i < ast.nodeCount; i++) {
  if (identifierTagIds.has(tagsArr[i])) identifierIdxs.push(i);
}
console.log(`Identifier nodes: ${identifierIdxs.length}`);

// ── JS path: AstView.name via existing _identAt ──
function jsAccessName() {
  let totalLen = 0;
  for (const i of identifierIdxs) {
    const node = ast.nodeAt ? ast.nodeAt(i) : null;
    if (node && typeof node.name === "string") totalLen += node.name.length;
  }
  return totalLen;
}
const { nodeView } = require(path.join(ROOT, "js/estree-adapter.js"));
function jsAccessNameViaRaw() {
  let totalLen = 0;
  for (const i of identifierIdxs) {
    const node = nodeView(ast, i);
    if (node && typeof node.name === "string") totalLen += node.name.length;
  }
  return totalLen;
}

// ── FFI path: ez_ffi_node_ident_name_into → TextDecoder ──
const nameOut = new Uint8Array(256);
const nameOutPtr = ptr(nameOut);
const decoder = new TextDecoder();
function ffiAccessName() {
  let totalLen = 0;
  for (const i of identifierIdxs) {
    const len = ffi.ez_ffi_node_ident_name_into(bufPtr, i, nameOutPtr, 256);
    const name = decoder.decode(nameOut.subarray(0, len));
    totalLen += name.length;
  }
  return totalLen;
}

// ── Validate parity (both should produce same names) ──
const jsTotal  = jsAccessNameViaRaw();
const ffiTotal = ffiAccessName();
console.log(`\nParity check:`);
console.log(`  JS total name length:  ${jsTotal}`);
console.log(`  FFI total name length: ${ffiTotal}`);
console.log(`  ${jsTotal === ffiTotal ? "✓ MATCH" : "✗ MISMATCH"}`);

// ── Bench ──
function bench(label, fn, iters) {
  // Warmup
  for (let i = 0; i < 5; i++) fn();
  const t0 = process.hrtime.bigint();
  for (let i = 0; i < iters; i++) fn();
  const dt = Number(process.hrtime.bigint() - t0);
  const perRun = dt / iters;
  const perAccess = perRun / identifierIdxs.length;
  console.log(`  ${label.padEnd(45)} ${(perRun/1e6).toFixed(1).padStart(7)} ms/run   ${perAccess.toFixed(1).padStart(7)} ns/access`);
  return perAccess;
}

console.log(`\nName access benchmark (${identifierIdxs.length} identifiers per run):`);
const ITERS = 50;
const jsNs  = bench("JS getter (existing AstView.name)", jsAccessNameViaRaw, ITERS);
const ffiNs = bench("FFI ez_ffi_node_ident_name_into",   ffiAccessName,      ITERS);
console.log(`\n  Speedup: ${(jsNs / ffiNs).toFixed(2)}x  (FFI ${ffiNs < jsNs ? "faster" : "SLOWER"} than JS)`);

// ── Tag access (no string decode, simpler comparison) ──
function jsAccessTag() {
  let s = 0;
  for (const i of identifierIdxs) {
    const node = nodeView(ast, i);
    if (node && typeof node.type === "string") s += node.type.length;
  }
  return s;
}
function ffiAccessTag() {
  let s = 0;
  for (const i of identifierIdxs) {
    const tag = ffi.ez_ffi_node_tag(bufPtr, i);
    const name = tagNames[tag];
    if (name) s += name.length;
  }
  return s;
}
console.log(`\nTag (node.type) access benchmark:`);
const jsTagNs  = bench("JS getter (AstView.type)",   jsAccessTag,  ITERS * 2);
const ffiTagNs = bench("FFI ez_ffi_node_tag + lookup", ffiAccessTag, ITERS * 2);
console.log(`\n  Speedup: ${(jsTagNs / ffiTagNs).toFixed(2)}x`);

// ── Parent access ──
function jsAccessParent() {
  let s = 0;
  for (const i of identifierIdxs) {
    const node = nodeView(ast, i);
    if (node && node.parent) s++;
  }
  return s;
}
function ffiAccessParent() {
  let s = 0;
  for (const i of identifierIdxs) {
    const p = ffi.ez_ffi_node_parent(bufPtr, i);
    if (p !== 0xFFFFFFFF) s++;
  }
  return s;
}
console.log(`\nParent (node.parent presence check) benchmark:`);
const jsPNs  = bench("JS getter (AstView.parent)",  jsAccessParent,  ITERS * 2);
const ffiPNs = bench("FFI ez_ffi_node_parent",      ffiAccessParent, ITERS * 2);
console.log(`\n  Speedup: ${(jsPNs / ffiPNs).toFixed(2)}x`);
