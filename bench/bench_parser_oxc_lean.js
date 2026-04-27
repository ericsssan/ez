"use strict";

/**
 * Apples-to-apples single-thread parse-only NAPI throughput.
 * Compares Ez parseSourceLean (lex + parse only, no sem/traversal/UTF-16)
 * against oxc-parser parseSync.
 *
 * Run: bun bench/bench_parser_oxc_lean.js
 */

const fs = require("fs");
const path = require("path");
const { parseSourceLean: ezParse, reset } = require("../js/index");
const { parseSync: oxcParseSync } = require("oxc-parser");

const WARMUP = 20;
const ITERATIONS = 100;

const fixtures = [
  "bench/fixtures/jquery.js",
  "bench/fixtures/lodash.js",
  "bench/fixtures/three.js",
  "bench/fixtures/typescript.js",
];

function bench(name, fn, iters) {
  for (let i = 0; i < WARMUP; i++) fn();
  const t0 = performance.now();
  for (let i = 0; i < iters; i++) fn();
  const dt = performance.now() - t0;
  return dt / iters;
}

console.log(`Parse-only head-to-head — Bun ${Bun.version}`);
console.log(`${WARMUP} warmup + ${ITERATIONS} iters per fixture`);
console.log(`ez parseSourceLean: lex + parse only (no sem, no post-processing)`);
console.log(`oxc parseSync:      lex + parse only\n`);

const pad = s => String(s).padStart(10);
console.log(
  `${'fixture'.padEnd(18)} ${'size'.padStart(8)} ${'lines'.padStart(7)}  ` +
  `${'ez (ms)'.padStart(9)}  ${'oxc (ms)'.padStart(10)}  ${'ez MB/s'.padStart(9)}  ${'oxc MB/s'.padStart(9)}  ratio`);
console.log('─'.repeat(100));

let totalEzMs = 0, totalOxcMs = 0, totalBytes = 0;

for (const fx of fixtures) {
  const p = path.join(__dirname, '..', fx);
  const src = fs.readFileSync(p, 'utf-8');
  const bytes = Buffer.byteLength(src, 'utf-8');
  const lines = src.split('\n').length;
  const name = path.basename(fx);

  const ezMs = bench('ez', () => {
    ezParse(src, { filename: name });
    reset();
  }, ITERATIONS);

  const oxcMs = bench('oxc', () => {
    oxcParseSync(name, src);
  }, ITERATIONS);

  const ezMBps = (bytes / 1024 / 1024) / (ezMs / 1000);
  const oxcMBps = (bytes / 1024 / 1024) / (oxcMs / 1000);
  const ratio = ezMs / oxcMs;

  totalEzMs += ezMs; totalOxcMs += oxcMs; totalBytes += bytes;

  console.log(
    `${name.padEnd(18)} ${pad((bytes/1024).toFixed(0)+' KB').padStart(8)} ` +
    `${pad(lines).padStart(7)}  ` +
    `${pad(ezMs.toFixed(2))}  ${pad(oxcMs.toFixed(2))}  ` +
    `${pad(ezMBps.toFixed(1))}  ${pad(oxcMBps.toFixed(1))}  ${ratio.toFixed(2)}x`);
}

console.log('─'.repeat(100));
const totEzMBps = (totalBytes / 1024 / 1024) / (totalEzMs / 1000);
const totOxcMBps = (totalBytes / 1024 / 1024) / (totalOxcMs / 1000);
console.log(
  `${'TOTAL'.padEnd(18)} ${pad((totalBytes/1024).toFixed(0)+' KB').padStart(8)} ` +
  `${''.padStart(7)}  ` +
  `${pad(totalEzMs.toFixed(2))}  ${pad(totalOxcMs.toFixed(2))}  ` +
  `${pad(totEzMBps.toFixed(1))}  ${pad(totOxcMBps.toFixed(1))}  ${(totalEzMs/totalOxcMs).toFixed(2)}x`);
