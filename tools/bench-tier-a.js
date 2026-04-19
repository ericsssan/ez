#!/usr/bin/env bun
// Measure Tier A short-circuit impact on plugin.create() calls and wall time.
//
// Strategy:
//   1. Patch every loaded rule's create() to count invocations.
//   2. Lint N synthetic files against a representative rule set, sequentially.
//   3. Repeat K times. Take min wall time (stable under noise).
//   4. Run with and without EZ_DISABLE_TIER_A to compare.
//
// Reports per-rule and aggregate create() call counts plus throughput delta.

"use strict";

const path = require("node:path");
const fs = require("node:fs");

const FILE_COUNT = parseInt(process.env.BENCH_FILES || "100", 10);
const ITERATIONS = parseInt(process.env.BENCH_ITER || "3", 10);

// Synthesize a realistic-sized source file (~60 lines each).
function makeSource(seed) {
  const pieces = [
    `"use strict";
function foo${seed}(a, b) {
  if (a === null || b === null) { return; }
  const arr = [1, 2, 3, ${seed}];
  for (let i = 0; i < arr.length; i++) { console.log(arr[i]); }
  return a + b;
}`,
    `const x${seed} = 1;
var y${seed} = 2;
function bar${seed}() {
  debugger;
  if (x${seed} == null) return;
  return x${seed} + y${seed};
}`,
    `class Widget${seed} {
  constructor(name) { this.name = name; this.id = ${seed}; }
  render() { console.log(this.name, this.id); }
  update(value) {
    if (value === null) return;
    this.value = value;
    return value * 2;
  }
}`,
    `const obj${seed} = {
  a: 1,
  b: 2,
  nested: { x: 10, y: 20 },
  method(n) { return n + ${seed}; }
};`,
    `try {
  throw new Error("err ${seed}");
} catch (e) {
  console.error(e);
  if (e.code === "BAD") throw e;
} finally {
  console.log("done ${seed}");
}`,
    `async function run${seed}() {
  const results = await Promise.all([
    fetch("/a").then(r => r.json()),
    fetch("/b").then(r => r.json()),
  ]);
  return results.reduce((a, b) => ({ ...a, ...b }), {});
}`,
  ];
  return pieces.join("\n\n");
}
const SYNTHETIC_SOURCES = Array.from({ length: 8 }, (_, i) => makeSource(i));

// Representative rule set of JS-handled rules (not covered by native Zig impls).
// Mix of Tier A (shared-handlers), Tier B (shared-handlers-proxied), and Tier D
// to exercise realistic config. Rules chosen to have native=false, so the JS
// dispatcher actually runs create() and the short-circuit is meaningful.
const RULES = {
  // Tier A (shared-handlers) — eligible for short-circuit
  "no-buffer-constructor": "error",
  "strict": "error",
  "func-name-matching": "error",
  "eol-last": "error",
  "no-restricted-syntax": ["error", "WithStatement"],
  "init-declarations": "error",
  "one-var-declaration-per-line": "error",
  "constructor-super": "error",
  "unicode-bom": "error",
  "max-nested-callbacks": "error",
  "no-sync": "error",
  // Tier B (shared-handlers-proxied) — eligible with redirecting Proxy
  "sort-vars": "error",
  "arrow-parens": "error",
  "one-var": "error",
  "wrap-iife": "error",
  "semi-spacing": "error",
  "space-infix-ops": "error",
  "semi-style": "error",
  "newline-before-return": "error",
  "space-unary-ops": "error",
  "no-unassigned-vars": "error",
  "curly": "error",
  // Tier D (fresh-per-file) — always runs create()
  "no-loop-func": "error",
  "no-fallthrough": "error",
  "no-magic-numbers": ["error", { "ignore": [0, 1] }],
};

async function runBench() {
  // Patch plugin.create() via load-plugin once modules loaded.
  // Simpler approach: intercept at ruleTester level via linter-runner cache instrumentation.
  const api = require(path.resolve(__dirname, "../js/api.js"));
  const runner = require(path.resolve(__dirname, "../js/eslint-runner.js"));

  // Install a global counter that the runner can increment.
  const createCounts = new Map();
  globalThis.__EZ_BENCH_CREATE_COUNTER__ = (ruleId) => {
    createCounts.set(ruleId, (createCounts.get(ruleId) || 0) + 1);
  };

  // createLinter pre-resolves the config once and returns a reusable lintText fn.
  // This is the idiomatic path that hits both the resolved-config and the runner's
  // buildVisitorMap caches — required to exercise the Tier A hot-path short-circuit.
  const lintText = await api.createLinter({ rules: RULES });

  const files = [];
  for (let i = 0; i < FILE_COUNT; i++) {
    files.push({
      filename: `bench-${i}.js`,
      source: SYNTHETIC_SOURCES[i % SYNTHETIC_SOURCES.length],
    });
  }

  // Warmup — skip first iteration's JIT noise and trigger cold path.
  for (const f of files.slice(0, 5)) {
    await lintText(f.source, f.filename);
  }
  createCounts.clear();

  const times = [];
  for (let iter = 0; iter < ITERATIONS; iter++) {
    createCounts.clear();
    const start = performance.now();
    for (const f of files) {
      await lintText(f.source, f.filename);
    }
    times.push(performance.now() - start);
  }

  const minTime = Math.min(...times);
  const avgTime = times.reduce((a, b) => a + b, 0) / times.length;

  let totalCreates = 0;
  for (const n of createCounts.values()) totalCreates += n;

  const tierADisabled = process.env.EZ_DISABLE_TIER_A === "1";
  process.stdout.write(JSON.stringify({
    mode: tierADisabled ? "tier-a-off" : "tier-a-on",
    files: FILE_COUNT,
    iterations: ITERATIONS,
    rulesConfigured: Object.keys(RULES).length,
    wallTimeMs: { min: Math.round(minTime), avg: Math.round(avgTime) },
    throughputFilesPerSec: Math.round(FILE_COUNT / (minTime / 1000)),
    createCallsLastIteration: totalCreates,
    createCallsPerFile: (totalCreates / FILE_COUNT).toFixed(2),
    perRuleCreates: Object.fromEntries(
      [...createCounts.entries()].sort((a, b) => b[1] - a[1])
    ),
  }, null, 2));
  process.stdout.write("\n");
}

runBench().catch(err => {
  process.stderr.write(String(err) + "\n");
  process.exit(1);
});
