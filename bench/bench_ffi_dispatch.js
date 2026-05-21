"use strict";
/**
 * End-to-end smoke test + benchmark for the Zig FFI selector dispatcher.
 *
 * Picks a handful of selectors that the dispatcher SHOULD be able to handle
 * (Identifier, :statement, :matches(A,B,C), :not(A,B), wildcard), runs the
 * dispatch, and reports:
 *   - matches per second
 *   - time vs running the same selectors through esquery in JS
 *   - sanity check: same nodes matched on both sides
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const fs   = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "..");

const { parseSource, getTagNames, _internal } = require(path.join(ROOT, "js/index.js"));
const { ptr } = require("bun:ffi");
const ffiDispatch = require(path.join(ROOT, "js/ffi-dispatch.js"));

if (!ffiDispatch.isAvailable()) {
  console.error("FFI not available (bun:ffi missing or .dylib not found)");
  process.exit(1);
}

// Read & parse binder.ts (the slow file from prior profiling).
const file = path.join(ROOT, "tests/conformance/typescript/src/compiler/binder.ts");
const src  = fs.readFileSync(file, "utf8");
const tagNames = getTagNames();

// Build name→tag-IDs map (a type name can map to multiple variant tags in ez).
const tagNameToIds = new Map();
for (let i = 0; i < tagNames.length; i++) {
  const n = tagNames[i];
  if (!n) continue;
  let arr = tagNameToIds.get(n);
  if (!arr) { arr = []; tagNameToIds.set(n, arr); }
  arr.push(i);
}

const ast    = parseSource(src, { filename: file });
const buffer = ast.buffer;
const bufPtr = ptr(new Uint8Array(buffer));
const bufLen = buffer.byteLength;

console.log(`File: ${path.basename(file)} (${(src.length / 1024).toFixed(0)} KB, ${ast.nodeCount} nodes, ${tagNames.length} tags)`);

// Pick the test selectors — same shape as the actual hot rules from the production profile.
const esquery = require(path.join(ROOT, "js/node_modules/esquery"));
const testSelectors = [
  "Identifier",
  "CallExpression",
  "*",
  ":statement",
  ":expression",
  ":not(Program)",
  ":matches(Property, MethodDefinition)",
  ":matches(VariableDeclarator, PropertyDefinition, AccessorProperty)",
  ":not(FunctionDeclaration, FunctionExpression, ArrowFunctionExpression)",
];

const compiled = [];
for (const s of testSelectors) {
  const parsed = esquery.parse(s);
  const spec = ffiDispatch.compileSelectorSpec(parsed, tagNameToIds, tagNames);
  compiled.push({ selector: s, parsed, spec });
}

console.log(`\nSpec compilation:`);
for (const c of compiled) {
  if (!c.spec) console.log(`  ${c.selector.padEnd(70)}  → UNSUPPORTED`);
  else {
    const kindName = ["unsupp", "tag_eq", "tag_in", "tag_not_in", "wildcard"][c.spec.kind] || "?";
    const tagInfo  = c.spec.tagSet ? `[${c.spec.tagSet.length} tags]` : (c.spec.kind === 1 ? `tag=${c.spec.a}` : "");
    console.log(`  ${c.selector.padEnd(70)}  → ${kindName.padEnd(11)} ${tagInfo}`);
  }
}

// Build the plan buffer (only for compilable specs).
const compilableSpecs = compiled.map(c => c.spec); // includes nulls → KIND_UNSUPPORTED in plan
const planBuf = ffiDispatch.buildPlanBuffer(compilableSpecs);
const planPtr = ptr(planBuf);
const planLen = planBuf.byteLength;
console.log(`\nPlan: ${compilableSpecs.length} specs (${compilableSpecs.filter(s => s).length} compilable), ${planBuf.byteLength} bytes`);

// ── Run FFI dispatch ──
function runFfi() {
  return ffiDispatch.dispatch(bufPtr, bufLen, planPtr, planLen);
}

// Warmup
for (let i = 0; i < 5; i++) runFfi();

// Measure
const N = 100;
const t0 = process.hrtime.bigint();
let lastEvents;
for (let i = 0; i < N; i++) lastEvents = runFfi();
const ffiNs = Number(process.hrtime.bigint() - t0);
const ffiMsPerCall = (ffiNs / N) / 1e6;
const ffiCount = lastEvents.length / 2;
console.log(`\nFFI dispatch:`);
console.log(`  ${ffiMsPerCall.toFixed(2).padStart(8)} ms/call  (${N} calls in ${(ffiNs/1e6).toFixed(0)}ms)`);
console.log(`  ${ffiCount.toLocaleString().padStart(8)} match events per call`);
console.log(`  ${(ffiCount * 1000 / ffiMsPerCall / 1e6).toFixed(1)} M matches/s`);

// ── Compare against running esquery in JS for the same selectors ──
const esq = esquery;
function runEsq() {
  let count = 0;
  // Walk every node, every selector. This mirrors how _runSelectorList works
  // when there's no fast matcher.
  for (let n = 0; n < ast.nodeCount; n++) {
    const nodeView = ast.nodeAt ? ast.nodeAt(n) : null;
    if (!nodeView) continue;
    for (const c of compiled) {
      if (esq.matches(nodeView, c.parsed)) count++;
    }
  }
  return count;
}

// Warmup
for (let i = 0; i < 2; i++) runEsq();
const e0 = process.hrtime.bigint();
let esqCount;
const Nesq = 5;
for (let i = 0; i < Nesq; i++) esqCount = runEsq();
const esqNs = Number(process.hrtime.bigint() - e0);
const esqMsPerCall = (esqNs / Nesq) / 1e6;
console.log(`\nesquery (JS, same selectors):`);
console.log(`  ${esqMsPerCall.toFixed(2).padStart(8)} ms/call  (${Nesq} calls in ${(esqNs/1e6).toFixed(0)}ms)`);
console.log(`  ${esqCount.toLocaleString().padStart(8)} matches per call`);

console.log(`\nSpeedup: ${(esqMsPerCall / ffiMsPerCall).toFixed(1)}x`);

// Per-event counts by selector (to validate FFI matches expected counts)
const perSelectorCounts = new Array(compiled.length).fill(0);
for (let i = 0; i < lastEvents.length; i += 2) perSelectorCounts[lastEvents[i]]++;
console.log(`\nMatch counts per selector (FFI):`);
for (let i = 0; i < compiled.length; i++) {
  console.log(`  ${perSelectorCounts[i].toString().padStart(7)}  ${compiled[i].selector}`);
}
