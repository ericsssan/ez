"use strict";
/**
 * NAPI throughput: ez vs oxc-parser.
 * Both called from Bun via NAPI.
 *
 * TWO COMPARISONS:
 *
 * (A) Lean — lex+parse only, apples-to-apples:
 *   ez:  parseSourceLean(src, { filename })  — tokenize + parse, no semantic, no AstView
 *   oxc: parseSync(filename, src)             — tokenize + parse + JS object tree
 *   Both return a usable representation of the parsed code.
 *
 * (B) Full pipeline — what real linting uses:
 *   ez:  parseSource(src, { filename })
 *         — lex + parse + scope analysis + node positions + AstView (lazy)
 *   oxc: parseSync(filename, src)             — lex + parse + JS object tree (no scope analysis)
 *   Note: ez does significantly MORE work in (B) — semantic/scope analysis is in the same call.
 *
 * Run: bun bench/bench_parser_oxc.js
 */

const fs = require("fs");
const path = require("path");
const { parseSource: ezParse, parseSourceLean: ezParseLean, reset } = require("../js/index");
const { parseSync: oxcParseSync } = require("oxc-parser");

const WARMUP = 20;
const ITERATIONS = 200;
// Total wall time scales linearly with bytes × ITERATIONS.  At 200 iters and
// ~13 MB/s wall throughput per parser, the big TS fixtures take ~15s each
// (×2 parsers ×2 sections = ~60s per section).  Cap iterations on large
// inputs so the whole bench fits in ~60s and per-row progress shows up
// before any harness timeout (or a watching human gives up).
function iterCountForBytes(bytes) {
  if (bytes > 4 * 1024 * 1024) return 30;   // >4 MB (typescript.js, checker.ts)
  if (bytes > 1 * 1024 * 1024) return 80;   // 1-4 MB
  return ITERATIONS;
}

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

/** Returns p50 ms over `iters` runs. */
function bench(fn, iters = ITERATIONS) {
  for (let i = 0; i < WARMUP; i++) fn();
  const times = new Float64Array(iters);
  for (let i = 0; i < iters; i++) {
    const t0 = performance.now();
    fn();
    times[i] = performance.now() - t0;
  }
  times.sort();
  return times[Math.floor(iters / 2)];
}

/** Per-fixture progress on stderr (unbuffered) so output appears during long
 *  runs.  Uses ANSI overwrite only on a TTY — otherwise emits a plain line so
 *  it stays readable when piped (`2>&1 | tail`) or captured. */
const STDERR_TTY = process.stderr.isTTY;
function progressBegin(msg) {
  process.stderr.write(STDERR_TTY ? `  ${msg}…` : `[bench] ${msg}\n`);
}
function progressEnd() {
  if (STDERR_TTY) process.stderr.write("\r\x1b[K");
}

function mbPerSec(bytes, ms) {
  return (bytes / 1048576) / (ms / 1000);
}

const root = path.join(__dirname, "..");

console.log(`\nez vs oxc-parser — Bun ${Bun.version}`);
console.log(`Both NAPI. warmup: ${WARMUP}  iters: ${ITERATIONS}  metric: p50\n`);

// ── (A) Lex+Parse only — apples-to-apples ──────────────────────────
console.log("(A) Lex+Parse only — ez parseLean vs oxc parseSync:");
console.log("    ez: lex+parse, no semantic, no AstView | oxc: lex+parse + JS object tree");
{
  const W = { fix: 32, kb: 7, ms: 8, mbs: 9 };
  const hdr = [
    "fixture".padEnd(W.fix),
    "KB".padStart(W.kb),
    "ez ms".padStart(W.ms),
    "oxc ms".padStart(W.ms),
    "ez MB/s".padStart(W.mbs),
    "oxc MB/s".padStart(W.mbs),
    "ratio".padStart(7),
  ].join("  ");
  console.log(hdr);
  console.log("─".repeat(hdr.length));

  let totalBytes = 0, totalEzMs = 0, totalOxcMs = 0;

  for (const fx of fixtures) {
    const fullPath = path.join(root, fx.path);
    if (!fs.existsSync(fullPath)) continue;
    const src = fs.readFileSync(fullPath, "utf8");
    const bytes = Buffer.byteLength(src, "utf8");
    const name = path.basename(fx.path);

    const iters = iterCountForBytes(bytes);
    progressBegin(`${name} (${(bytes/1024).toFixed(0)}KB, ${iters} iters)`);
    const ezMs  = bench(() => { ezParseLean(src, { filename: name }); reset(); }, iters);
    const oxcMs = bench(() => { oxcParseSync(name, src); }, iters);
    progressEnd();

    const ezMBs  = mbPerSec(bytes, ezMs);
    const oxcMBs = mbPerSec(bytes, oxcMs);
    const ratio  = oxcMs / ezMs;

    totalBytes  += bytes;
    totalEzMs   += ezMs;
    totalOxcMs  += oxcMs;

    const winner = ratio >= 1.05 ? "✓ ez" : ratio <= 0.95 ? "  oxc" : "  ≈";
    console.log([
      name.padEnd(W.fix),
      (bytes / 1024).toFixed(0).padStart(W.kb),
      ezMs.toFixed(3).padStart(W.ms),
      oxcMs.toFixed(3).padStart(W.ms),
      ezMBs.toFixed(0).padStart(W.mbs),
      oxcMBs.toFixed(0).padStart(W.mbs),
      `${ratio.toFixed(2)}x`.padStart(7),
      winner,
    ].join("  "));
  }

  console.log("─".repeat(hdr.length));
  const aggEzMBs  = mbPerSec(totalBytes, totalEzMs);
  const aggOxcMBs = mbPerSec(totalBytes, totalOxcMs);
  const aggRatio  = totalOxcMs / totalEzMs;
  console.log([
    "AGGREGATE".padEnd(W.fix),
    "".padStart(W.kb),
    totalEzMs.toFixed(1).padStart(W.ms),
    totalOxcMs.toFixed(1).padStart(W.ms),
    aggEzMBs.toFixed(0).padStart(W.mbs),
    aggOxcMBs.toFixed(0).padStart(W.mbs),
    `${aggRatio.toFixed(2)}x`.padStart(7),
  ].join("  "));
  console.log(`ratio = oxc_ms / ez_lean_ms  (> 1 → ez faster)\n`);
}

// ── (B) Full pipeline ──────────────────────────────────────────────
console.log("(B) Full pipeline — ez parseSource vs oxc parseSync:");
console.log("    ez: lex+parse+semantic+positions+AstView(lazy) | oxc: lex+parse+JS objects");
console.log("    NOTE: ez does scope analysis here; oxc does NOT — ez provides more data.\n");
{
  const W = { fix: 32, kb: 7, ms: 8, mbs: 9 };
  const hdr = [
    "fixture".padEnd(W.fix),
    "KB".padStart(W.kb),
    "ez ms".padStart(W.ms),
    "oxc ms".padStart(W.ms),
    "ez MB/s".padStart(W.mbs),
    "oxc MB/s".padStart(W.mbs),
    "ratio".padStart(7),
  ].join("  ");
  console.log(hdr);
  console.log("─".repeat(hdr.length));

  let totalBytes = 0, totalEzMs = 0, totalOxcMs = 0;

  for (const fx of fixtures) {
    const fullPath = path.join(root, fx.path);
    if (!fs.existsSync(fullPath)) continue;
    const src = fs.readFileSync(fullPath, "utf8");
    const bytes = Buffer.byteLength(src, "utf8");
    const name = path.basename(fx.path);

    const iters = iterCountForBytes(bytes);
    progressBegin(`${name} (${(bytes/1024).toFixed(0)}KB, ${iters} iters)`);
    const ezMs  = bench(() => { ezParse(src, { filename: name }); reset(); }, iters);
    const oxcMs = bench(() => { oxcParseSync(name, src); }, iters);
    progressEnd();

    const ezMBs  = mbPerSec(bytes, ezMs);
    const oxcMBs = mbPerSec(bytes, oxcMs);
    const ratio  = oxcMs / ezMs;

    totalBytes  += bytes;
    totalEzMs   += ezMs;
    totalOxcMs  += oxcMs;

    const winner = ratio >= 1.05 ? "✓ ez" : ratio <= 0.95 ? "  oxc" : "  ≈";
    console.log([
      name.padEnd(W.fix),
      (bytes / 1024).toFixed(0).padStart(W.kb),
      ezMs.toFixed(3).padStart(W.ms),
      oxcMs.toFixed(3).padStart(W.ms),
      ezMBs.toFixed(0).padStart(W.mbs),
      oxcMBs.toFixed(0).padStart(W.mbs),
      `${ratio.toFixed(2)}x`.padStart(7),
      winner,
    ].join("  "));
  }

  console.log("─".repeat(hdr.length));
  const aggEzMBs  = mbPerSec(totalBytes, totalEzMs);
  const aggOxcMBs = mbPerSec(totalBytes, totalOxcMs);
  const aggRatio  = totalOxcMs / totalEzMs;
  console.log([
    "AGGREGATE".padEnd(W.fix),
    "".padStart(W.kb),
    totalEzMs.toFixed(1).padStart(W.ms),
    totalOxcMs.toFixed(1).padStart(W.ms),
    aggEzMBs.toFixed(0).padStart(W.mbs),
    aggOxcMBs.toFixed(0).padStart(W.mbs),
    `${aggRatio.toFixed(2)}x`.padStart(7),
  ].join("  "));
  console.log(`ratio = oxc_ms / ez_ms  (> 1 → ez faster)\n`);
}
