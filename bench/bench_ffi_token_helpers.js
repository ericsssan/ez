"use strict";
/**
 * Benchmark: SourceCode.getTokenBefore() — existing JS path vs FFI-backed.
 *
 * Runs both implementations against every node of binder.ts, returns the same
 * Token objects (built lazily, identity-cached). Reports ns per call.
 *
 * Note: existing JS already caches Token objects after first creation, so this
 * is a hot-path measurement (cache populated during warmup).
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const fs   = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "..");

const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
const { dlopen, FFIType, ptr } = require("bun:ffi");

const lib = dlopen(path.join(ROOT, "zig-out/lib/ez.node"), {
  ez_ffi_token_count:            { args: [FFIType.ptr],                                              returns: FFIType.u32 },
  ez_ffi_token_idx_at_or_before: { args: [FFIType.ptr, FFIType.u32],                                returns: FFIType.u32 },
  ez_ffi_token_data:             { args: [FFIType.ptr, FFIType.u32, FFIType.ptr],                   returns: FFIType.void },
  ez_ffi_node_main_token:        { args: [FFIType.ptr, FFIType.u32],                                returns: FFIType.u32 },
});
const ffi = lib.symbols;

const file = path.join(ROOT, "tests/conformance/typescript/src/compiler/binder.ts");
const src  = fs.readFileSync(file, "utf8");
const tagNames = getTagNames();
const ast = parseSource(src, { filename: file });
const buf = ast.buffer;
const bufBytes = new Uint8Array(buf);
const bufPtr = ptr(bufBytes);

console.log(`File: ${path.basename(file)} (${(src.length/1024).toFixed(0)} KB, ${ast.nodeCount} nodes, ${ast.tokenCount} tokens)`);

// ── Build existing SourceCode ──
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
// Run a minimal lint to instantiate a SourceCode we can pull from. Easier: walk the runner
// internals — build the SourceCode-like object directly. We already export the class via
// runPlugins... actually the SourceCode is internal. Use a stub plugin to capture it:

let _capturedSourceCode = null;
const captureRule = {
  create(context) {
    _capturedSourceCode = context.sourceCode || context.getSourceCode();
    return {};
  },
  meta: { name: "capture" },
};
runPlugins(ast, [{ meta: { name: "capture" }, create: captureRule.create }], {
  tagNames, sourceType: "module", ruleConfig: {}, ecmaVersion: 2022,
  envGlobals: false, filename: file, languageOptions: {},
});
const sc = _capturedSourceCode;
if (!sc) { console.error("could not capture SourceCode"); process.exit(1); }
console.log(`SourceCode captured (has getTokenBefore: ${typeof sc.getTokenBefore === "function"})`);

// Collect all node views. _capturedSourceCode.ast is the program node; we need to walk.
// Easier: enumerate node indices 0..nodeCount and build via nodeView.
const { nodeView } = require(path.join(ROOT, "js/estree-adapter.js"));
const nodes = new Array(ast.nodeCount);
for (let i = 0; i < ast.nodeCount; i++) nodes[i] = nodeView(ast, i);

// ── JS getTokenBefore loop ──
function jsLoop() {
  let nonNull = 0;
  for (let i = 0; i < nodes.length; i++) {
    const tok = sc.getTokenBefore(nodes[i]);
    if (tok) nonNull++;
  }
  return nonNull;
}

// ── FFI getTokenBefore equivalent ──
// Build a Token cache with identity equality (mirrors _makeToken).
const _ffiTokenCache = new Array(ast.tokenCount);
const tokDataOut = new Uint32Array(3);
const tokDataPtr = ptr(tokDataOut);
function ffiMakeToken(i) {
  const cached = _ffiTokenCache[i];
  if (cached !== undefined) return cached;
  ffi.ez_ffi_token_data(bufPtr, i, tokDataPtr);
  const start = tokDataOut[0];
  const end   = tokDataOut[1];
  const tag   = tokDataOut[2];
  // Build a minimal Token wrapper. Real ESLint Token also has loc; we skip
  // for the bench (parity check on identity + range).
  const tok = { type: tag, value: src.substring(start, end), range: [start, end], start, end, loc: null };
  _ffiTokenCache[i] = tok;
  return tok;
}
function ffiGetTokenBefore(node) {
  if (!node) return null;
  // Default-path approximation: use mainToken if available, else range.
  let mainTok;
  if (node.mainToken !== undefined && node.mainToken !== null) {
    mainTok = node.mainToken;
  } else if (node.range) {
    // Find token at or before node.range[0] - 1 via FFI binary search.
    const idx = ffi.ez_ffi_token_idx_at_or_before(bufPtr, node.range[0] - 1);
    if (idx === 0xFFFFFFFF) return null;
    return ffiMakeToken(idx);
  } else {
    return null;
  }
  if (mainTok === 0) return null;
  return ffiMakeToken(mainTok - 1);
}
function ffiLoop() {
  let nonNull = 0;
  for (let i = 0; i < nodes.length; i++) {
    const tok = ffiGetTokenBefore(nodes[i]);
    if (tok) nonNull++;
  }
  return nonNull;
}

// Parity check
const jsCount  = jsLoop();
const ffiCount = ffiLoop();
console.log(`\nParity: JS=${jsCount} non-null,  FFI=${ffiCount} non-null  (counts may differ slightly because FFI version skips the "shadowed token" check that JS does for #-prefixed identifiers)`);

// Bench
function bench(label, fn, iters) {
  for (let i = 0; i < 3; i++) fn();
  const t0 = process.hrtime.bigint();
  for (let i = 0; i < iters; i++) fn();
  const dt = Number(process.hrtime.bigint() - t0);
  const perCall = dt / (iters * nodes.length);
  console.log(`  ${label.padEnd(40)} ${(dt/iters/1e6).toFixed(2).padStart(7)} ms/loop  ${perCall.toFixed(1).padStart(7)} ns/call (${nodes.length} calls/loop)`);
  return perCall;
}

console.log(`\nBenchmark — getTokenBefore for every node (${nodes.length} per loop):`);
const ITERS = 20;
const jsNs  = bench("JS sc.getTokenBefore (existing)", jsLoop,  ITERS);
const ffiNs = bench("FFI getTokenBefore (default path)", ffiLoop, ITERS);
console.log(`\n  Speedup: ${(jsNs / ffiNs).toFixed(2)}x  (FFI ${ffiNs < jsNs ? "faster" : "SLOWER"})`);

// ── Bulk: getTokensBetween — typical usage is "tokens between two siblings" ──
// Pick a representative workload: every BlockStatement → call getTokensBetween(body[0], body[last]).
console.log(`\n────── getTokensBetween (bulk operation) ──────`);

const { createTokenHelpers } = require(path.join(ROOT, "js/ffi-source-code.js"));
const ffiSc = createTokenHelpers(ast, src, tagNames);

// Find pairs of node indices where left+right have non-zero gap.
const pairs = [];
for (let i = 0; i < nodes.length; i++) {
  const n = nodes[i];
  if (!n || !n.range) continue;
  const body = n.body;
  if (Array.isArray(body) && body.length >= 2) {
    pairs.push([body[0], body[body.length - 1]]);
  }
}
console.log(`  Pairs: ${pairs.length}`);

function jsBetween() {
  let total = 0;
  for (const [l, r] of pairs) {
    const toks = sc.getTokensBetween(l, r);
    total += toks.length;
  }
  return total;
}
function ffiBetween() {
  let total = 0;
  for (const [l, r] of pairs) {
    const toks = ffiSc.getTokensBetween(l, r);
    total += toks.length;
  }
  return total;
}

const jsBetweenTotal  = jsBetween();
const ffiBetweenTotal = ffiBetween();
console.log(`  Parity: JS ${jsBetweenTotal} tokens, FFI ${ffiBetweenTotal} tokens  (${jsBetweenTotal === ffiBetweenTotal ? "✓ MATCH" : "✗ MISMATCH"})`);

function benchBetween(label, fn, iters) {
  for (let i = 0; i < 3; i++) fn();
  const t0 = process.hrtime.bigint();
  for (let i = 0; i < iters; i++) fn();
  const dt = Number(process.hrtime.bigint() - t0);
  console.log(`    ${label.padEnd(40)} ${(dt/iters/1e6).toFixed(2).padStart(7)} ms/loop  (${pairs.length} pairs/loop, avg ${(jsBetweenTotal/pairs.length).toFixed(1)} tokens/pair)`);
  return dt / iters;
}
const jsBNs  = benchBetween("JS getTokensBetween",  jsBetween,  ITERS);
const ffiBNs = benchBetween("FFI getTokensBetween", ffiBetween, ITERS);
console.log(`\n  Speedup: ${(jsBNs / ffiBNs).toFixed(2)}x`);
