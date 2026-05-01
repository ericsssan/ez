"use strict";
// Throughput comparison: ez (native Zig) vs oxc-parser (NAPI/Node).
//
// ez numbers come from bench-pipeline-st (zig build bench-pipeline-st).
// oxc numbers are measured here via oxc-parser's parseSync.
//
// Run:
//   node bench/bench_oxc_compare.js
//
// Requires oxc-parser in node_modules (or /tmp/node_modules).
// Install: cd /tmp && npm install oxc-parser

const fs = require("fs");
const path = require("path");

let parseSync;
try {
  ({ parseSync } = require("oxc-parser"));
} catch {
  try {
    ({ parseSync } = require("/tmp/node_modules/oxc-parser"));
  } catch {
    console.error("oxc-parser not found. Run: cd /tmp && npm install oxc-parser");
    process.exit(1);
  }
}

const WARMUP = 15;
const ITERATIONS = 150;

const fixtures = [
  { path: "bench/fixtures/jquery.js" },
  { path: "bench/fixtures/lodash.js" },
  { path: "bench/fixtures/three.js" },
  { path: "bench/fixtures/react-dom.development.js" },
  { path: "bench/fixtures/angular-core.mjs" },
  { path: "bench/fixtures/angular-core.d.ts" },
  { path: "bench/fixtures/lib.dom.d.ts" },
  { path: "bench/fixtures/app-render.tsx" },
  { path: "bench/fixtures/angular-classes.ts" },
  { path: "bench/fixtures/checker.ts" },
  { path: "bench/fixtures/typescript.js" },
];

// ez Lex+Parse p50 results from bench-pipeline-st (update after each run).
// Unit: milliseconds.
const ezMs = {
  "jquery.js":                0.800,
  "lodash.js":                0.766,
  "three.js":                 1.299,
  "react-dom.development.js": 2.360,
  "angular-core.mjs":         3.513,
  "angular-core.d.ts":        0.602,
  "lib.dom.d.ts":             2.147,
  "app-render.tsx":           0.509,
  "angular-classes.ts":       2.108,
  "checker.ts":               7.885,
  "typescript.js":           24.516,
};

function bench(fn) {
  for (let i = 0; i < WARMUP; i++) fn();
  const times = [];
  for (let i = 0; i < ITERATIONS; i++) {
    const t0 = performance.now();
    fn();
    times.push(performance.now() - t0);
  }
  times.sort((a, b) => a - b);
  return times[Math.floor(times.length / 2)]; // p50
}

function mbPerSec(bytes, ms) {
  return (bytes / 1024 / 1024) / (ms / 1000);
}

const root = path.join(__dirname, "..");

console.log(`\nez vs oxc-parser throughput (Node ${process.version})`);
console.log(`warmup: ${WARMUP}  iters: ${ITERATIONS}  metric: p50\n`);
console.log(
  `${"fixture".padEnd(30)}  ${"KB".padStart(6)}  ${"ez ms".padStart(7)}  ${"oxc ms".padStart(7)}  ${"ez MB/s".padStart(8)}  ${"oxc MB/s".padStart(8)}  ${"ratio".padStart(6)}`
);
console.log("─".repeat(85));

let totalBytes = 0, totalEzNs = 0, totalOxcNs = 0;

for (const fx of fixtures) {
  const fullPath = path.join(root, fx.path);
  if (!fs.existsSync(fullPath)) {
    console.log(`  ${fx.path}: not found, skipping`);
    continue;
  }

  const src = fs.readFileSync(fullPath, "utf8");
  const bytes = Buffer.byteLength(src, "utf8");
  const name = path.basename(fx.path);

  const oxcP50 = bench(() => parseSync(name, src));
  const ez = ezMs[name];
  const ezMBs = ez != null ? mbPerSec(bytes, ez).toFixed(0) : "n/a";
  const oxcMBs = mbPerSec(bytes, oxcP50).toFixed(0);
  const ratio = ez != null ? (oxcP50 / ez).toFixed(2) : "n/a";
  const tag = ez != null && oxcP50 > ez ? "ez faster" : ez != null ? "oxc faster" : "";

  console.log(
    `${name.padEnd(30)}  ${(bytes / 1024).toFixed(0).padStart(6)}  ` +
    `${(ez ?? "n/a").toString().padStart(7)}  ${oxcP50.toFixed(3).padStart(7)}  ` +
    `${String(ezMBs).padStart(8)}  ${String(oxcMBs).padStart(8)}  ` +
    `${String(ratio).padStart(6)}x  ${tag}`
  );

  if (ez != null) {
    totalBytes += bytes;
    totalEzNs += ez;
    totalOxcNs += oxcP50;
  }
}

console.log("─".repeat(85));
const aggEzMBs = mbPerSec(totalBytes, totalEzNs).toFixed(0);
const aggOxcMBs = mbPerSec(totalBytes, totalOxcNs).toFixed(0);
const aggRatio = (totalOxcNs / totalEzNs).toFixed(2);
console.log(
  `${"AGGREGATE".padEnd(30)}  ${"".padStart(6)}  ` +
  `${"".padStart(7)}  ${"".padStart(7)}  ` +
  `${String(aggEzMBs).padStart(8)}  ${String(aggOxcMBs).padStart(8)}  ${String(aggRatio).padStart(6)}x`
);
console.log(`\nRatio > 1 means oxc is slower (ez wins). < 1 means oxc is faster.`);
console.log(`Note: ez times are from the native Zig bench (no NAPI overhead).`);
console.log(`      oxc times include Node.js NAPI call overhead.\n`);
