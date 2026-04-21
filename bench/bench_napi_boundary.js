"use strict";

/**
 * Isolate the NAPI boundary cost from total lint time.
 *
 * Measures:
 *   1. Per-crossing cost (tightest possible: b.tagCount() in a loop)
 *   2. Crossings per lint (inferred from code audit + instrumentation)
 *   3. Total parse+lint wall time
 *   4. NAPI share = (per-crossing × crossings) / total
 *
 * Usage:
 *   bun bench/bench_napi_boundary.js [fixture.js]
 */

const fs = require("fs");
const path = require("path");
const { parseSource, parseAndLintNative, lintSourceNative, reset, getTagNames } =
  require("../js/index");
const { runPlugins } = require("../js/eslint-runner");

// Direct access to the raw binding so we can measure crossing cost
// without any JS wrapper work.
let binding;
try {
  binding = require("../zig-out/lib/ez.node");
} catch {
  try { binding = require("../zig-out/lib/libez.dylib"); }
  catch { binding = require("../zig-out/lib/libez.so"); }
}

const ITERS_CROSSING = 1_000_000;
const ITERS_LINT = 200;
const WARMUP = 20;

function bench(name, fn, iters) {
  for (let i = 0; i < WARMUP; i++) fn();
  const t0 = performance.now();
  for (let i = 0; i < iters; i++) fn();
  const dt = performance.now() - t0;
  return { name, iters, total_ms: dt, per_op_us: (dt * 1000) / iters };
}

// ── 1. Raw crossing cost ────────────────────────────────────────
// tagCount() does no work on the Zig side beyond returning a u32.
// This is the closest proxy to pure NAPI marshalling overhead.
const crossing = bench("bare NAPI crossing (tagCount)", () => binding.tagCount(), ITERS_CROSSING);

// ── 2. Full parse+lint per file ─────────────────────────────────
const fixture = process.argv[2] || path.join(__dirname, "fixtures/jquery.js");
const source = fs.readFileSync(fixture, "utf-8");
const filename = fixture;
const tagNames = getTagNames();

const noopPlugin = {
  meta: { name: "noop" },
  create() { return { Identifier() {}, CallExpression() {} }; },
};

// Parse only (1 crossing: b.parse)
const parseOnly = bench("parseSource only", () => {
  parseSource(source, { filename });
  reset();
}, ITERS_LINT);

// Parse + native lint (1 crossing: b.parseAndLintFile)
// Note: needs a file path; fall back to separate parse+lint if we only have source
const parseLint = bench("parseSource + lintSourceNative", () => {
  parseSource(source, { filename });
  lintSourceNative(source, { filename, rules: {} });
  reset();
}, ITERS_LINT);

// Parse + plugin traversal (1 crossing, then full JS walk)
const parseTraverse = bench("parseSource + noop visitor traversal", () => {
  const ast = parseSource(source, { filename });
  runPlugins(ast, [noopPlugin], { tagNames });
  reset();
}, ITERS_LINT);

// ── 3. Report ──────────────────────────────────────────────────
const crossings_per_parse = 1;
const crossings_per_parselint = 2;

const napi_cost_parse_us = crossing.per_op_us * crossings_per_parse;
const napi_cost_parselint_us = crossing.per_op_us * crossings_per_parselint;

const total_parse_us = parseOnly.per_op_us;
const total_parselint_us = parseLint.per_op_us;
const total_traverse_us = parseTraverse.per_op_us;

function pct(num, denom) { return ((num / denom) * 100).toFixed(4) + "%"; }

console.log("\n═══ NAPI Boundary Profile ═══\n");
console.log(`Fixture: ${path.basename(fixture)} (${(source.length/1024).toFixed(1)} KB, ${source.split('\n').length} lines)`);
console.log(`Runtime: ${typeof Bun !== "undefined" ? "Bun " + Bun.version : "Node " + process.version}\n`);

console.log("── Raw crossing cost ──");
console.log(`  Per bare NAPI crossing: ${crossing.per_op_us.toFixed(3)} µs`);
console.log(`  (measured across ${ITERS_CROSSING.toLocaleString()} calls to binding.tagCount())\n`);

console.log("── Per-file totals ──");
console.log(`  parseSource alone:         ${(total_parse_us/1000).toFixed(3)} ms  (${crossings_per_parse} crossing)`);
console.log(`  parseSource + native lint: ${(total_parselint_us/1000).toFixed(3)} ms  (${crossings_per_parselint} crossings)`);
console.log(`  parseSource + JS traverse: ${(total_traverse_us/1000).toFixed(3)} ms  (${crossings_per_parse} crossing)\n`);

console.log("── NAPI share ──");
console.log(`  parse:             ${napi_cost_parse_us.toFixed(3)} µs of ${total_parse_us.toFixed(1)} µs = ${pct(napi_cost_parse_us, total_parse_us)}`);
console.log(`  parse+nativelint:  ${napi_cost_parselint_us.toFixed(3)} µs of ${total_parselint_us.toFixed(1)} µs = ${pct(napi_cost_parselint_us, total_parselint_us)}`);
console.log(`  parse+JS traverse: ${napi_cost_parse_us.toFixed(3)} µs of ${total_traverse_us.toFixed(1)} µs = ${pct(napi_cost_parse_us, total_traverse_us)}`);

console.log("\n── Verdict ──");
const worst_share = Math.max(
  napi_cost_parse_us / total_parse_us,
  napi_cost_parselint_us / total_parselint_us,
  napi_cost_parse_us / total_traverse_us,
);
if (worst_share > 0.10) {
  console.log(`  NAPI boundary is >10% — JSC embedding HAS a perf story.`);
} else if (worst_share > 0.01) {
  console.log(`  NAPI boundary is 1-10% — marginal perf win from JSC embedding.`);
} else {
  console.log(`  NAPI boundary is <1% of total — JSC embedding is NOT a perf play.`);
  console.log(`  Everything else (parse, traverse, rule exec) dominates by 100x+.`);
}
