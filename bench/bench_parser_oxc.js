"use strict";

/**
 * Head-to-head: Ez parser vs oxc-parser.
 * Both called via NAPI from Bun, both return the full AST.
 * Report per-file wall time, MB/s, and MLines/s.
 *
 * Run: bun bench/bench_parser_oxc.js
 */

const fs = require("fs");
const path = require("path");
const { parseSource: ezParse, reset } = require("../js/index");
const { parseSync: oxcParseSync } = require("oxc-parser");

const WARMUP = 10;
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

console.log(`Parser head-to-head — Bun ${Bun.version}`);
console.log(`${WARMUP} warmup + ${ITERATIONS} iters per fixture\n`);

const pad = s => String(s).padStart(10);
console.log(
  `${'fixture'.padEnd(18)} ${'size'.padStart(8)} ${'lines'.padStart(7)}  ` +
  `${'ez (ms)'.padStart(9)}  ${'oxc (ms)'.padStart(10)}  ${'ez MB/s'.padStart(9)}  ${'oxc MB/s'.padStart(9)}  ratio`);
console.log('─'.repeat(100));

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

  console.log(
    `${name.padEnd(18)} ${pad((bytes/1024).toFixed(0)+' KB').padStart(8)} ` +
    `${pad(lines).padStart(7)}  ` +
    `${pad(ezMs.toFixed(2))}  ${pad(oxcMs.toFixed(2))}  ` +
    `${pad(ezMBps.toFixed(1))}  ${pad(oxcMBps.toFixed(1))}  ${ratio.toFixed(2)}x`);
}

console.log();
console.log('ez = Ez.parseSource (NAPI, private-copy path)');
console.log('oxc = oxc-parser.parseSync (NAPI, in-process)');
