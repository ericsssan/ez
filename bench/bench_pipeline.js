"use strict";
/**
 * Pipeline throughput benchmark — isolates each stage:
 *   I/O, encode, parse (NAPI), runPlugins, full pipeline
 *
 * Also measures:
 *   - Token pre-scan: byte-search for rule triggers before full parse
 *   - Batch NAPI: how much time is pure NAPI boundary overhead vs actual parse work
 *   - Async I/O overlap: I/O latency hidden behind parse+rules CPU work
 *
 * Usage: node bench/bench_pipeline.js [A|B|C]
 */
const fs   = require("fs");
const path = require("path");

const CORPUSES = {
  A: "tests/conformance/test262-parser-tests/pass",
  B: "tests/conformance/babel/packages/babel-parser/test/fixtures",
  C: "tests/conformance/test262/test/language",
};
const corpusArg = (process.argv[2] || "A").toUpperCase();
if (!CORPUSES[corpusArg]) { console.error("Usage: node bench/bench_pipeline.js [A|B|C]"); process.exit(1); }

const ROOT       = path.join(__dirname, "..");
const CORPUS_DIR = path.join(ROOT, CORPUSES[corpusArg]);
const JS_DIR     = path.join(ROOT, "js");

function collectFiles(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.name.startsWith(".") || e.name === "node_modules") continue;
    const full = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...collectFiles(full));
    else if (e.name.endsWith(".js")) out.push(full);
  }
  return out;
}
const files = corpusArg === "A"
  ? fs.readdirSync(CORPUS_DIR).filter(f => f.endsWith(".js")).map(f => path.join(CORPUS_DIR, f))
  : collectFiles(CORPUS_DIR);
const N = files.length;

const { parse, getTagNames } = require(path.join(JS_DIR, "index"));
const { runPlugins }         = require(path.join(JS_DIR, "eslint-runner"));
const { loadPlugin }         = require(path.join(JS_DIR, "load-plugin"));
const tagNames = getTagNames();

// ── Datasets ──────────────────────────────────────────────────────
// Pre-loaded strings (already in V8 heap) — baseline for all timed segments.
const codes    = files.map(f => fs.readFileSync(f, "utf8"));
// Pre-encoded UTF-8 buffers — separates encoding cost from I/O cost.
const enc      = new TextEncoder();
const buffers  = codes.map(s => enc.encode(s)); // Uint8Array per file

// Total bytes
const totalBytes = buffers.reduce((s, b) => s + b.length, 0);
const totalMB    = (totalBytes / 1e6).toFixed(1);

// Rules for full pipeline test — ALL non-deprecated ESLint rules
const pluginsAll = loadPlugin("eslint", new Set());
console.log(`Loaded ${pluginsAll.length} ESLint rules`);

// ── Token pre-scan triggers ────────────────────────────────────────
// Representative triggers for common rules.
// A file is "relevant" if it contains ANY of these patterns.
// In practice nearly all real files will match at least one.
const RULE_TRIGGERS = {
  "no-debugger":  "debugger",
  "no-console":   "console",
  "no-eval":      "eval",
  "no-with":      "with",
  "no-continue":  "continue",
  "no-alert":     "alert",
  "no-var":       "var ",
};
const triggerPatterns = Object.values(RULE_TRIGGERS);
// Pre-scan: check if each file contains each trigger.
const totalHitsAll = new Uint8Array(N);
for (let i = 0; i < N; i++) {
  for (const pat of triggerPatterns) {
    if (codes[i].includes(pat)) { totalHitsAll[i] = 1; break; }
  }
}
const hitFiles = totalHitsAll.reduce((s, v) => s + v, 0);

// ── Helpers ───────────────────────────────────────────────────────
const WARMUP = Math.min(N, 500);
const REPS   = 3;
// Rule stages are capped to avoid 30-min runs on large corpora with many rules.
// Corpus A (tiny files) runs all files; corpus C (large files) uses a sample.
const RULE_FILE_LIMIT = 500;
const rN     = Math.min(N, RULE_FILE_LIMIT);
const rFiles = files.slice(0, rN);
const rCodes = codes.slice(0, rN);
const rHitsAll = totalHitsAll.slice(0, rN);
const rReps  = rN < N ? 1 : REPS; // single rep when sampling — variance is low enough
const rBytes = rCodes.reduce((s, c) => s + c.length, 0);
function hrt()       { return Number(process.hrtime.bigint()); }
function median(arr) { const s = [...arr].sort((a,b) => a-b); return s[Math.floor(s.length/2)]; }
function segment(fn) { const t = []; for (let r = 0; r < REPS; r++) t.push(fn()); return median(t); }
function rSegment(fn) {
  const t = [];
  for (let r = 0; r < rReps; r++) t.push(fn());
  return rReps === 1 ? t[0] : median(t);
}
function mbps(ns, bytes) { return ((bytes / 1e6) / (ns / 1e9)).toFixed(0); }
function row(label, ns) {
  const ms  = (ns / 1e6).toFixed(1);
  const msf = (ns / 1e6 / N).toFixed(4);
  const thr = mbps(ns, totalBytes);
  console.log(`  ${label.padEnd(46)} ${ms.padStart(8)} ms  ${msf.padStart(9)} ms/file  ${thr.padStart(6)} MB/s`);
}
function rowN(label, ns, n) {
  const ms  = (ns / 1e6).toFixed(1);
  const msf = (ns / 1e6 / n).toFixed(4);
  console.log(`  ${label.padEnd(46)} ${ms.padStart(8)} ms  ${msf.padStart(9)} ms/file`);
}
function rowR(label, ns) {
  const ms  = (ns / 1e6).toFixed(1);
  const msf = (ns / 1e6 / rN).toFixed(4);
  const thr = mbps(ns, rBytes);
  const note = rN < N ? ` [sample ${rN}]` : "";
  console.log(`  ${(label + note).padEnd(46)} ${ms.padStart(8)} ms  ${msf.padStart(9)} ms/file  ${thr.padStart(6)} MB/s`);
}

console.log(`\nCorpus ${corpusArg}: ${N} files, ${totalMB} MB total`);
console.log(`Token pre-scan: ${hitFiles}/${N} files match ≥1 rule trigger (${(hitFiles/N*100).toFixed(0)}%)`);
console.log();

// ── Warmup ────────────────────────────────────────────────────────
process.stdout.write("Warming up JIT...");
for (let pass = 0; pass < 2; pass++) {
  for (let i = 0; i < WARMUP; i++) {
    try {
      const ast = parse(codes[i], { filename: files[i] });
      runPlugins(ast, pluginsAll, { filename: files[i], tagNames });
    } catch {}
  }
}
console.log(" done\n");

const HDR = `${"Stage".padEnd(48)} ${"Total ms".padStart(8)}   ${"ms/file".padStart(9)}  ${"MB/s".padStart(6)}`;
console.log(HDR);
console.log("─".repeat(75));

// ── Stage 1: I/O — cold + warm ────────────────────────────────────
// Warm I/O (OS page cache already hot from earlier readFileSync at startup)
const ioWarmNs = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) fs.readFileSync(files[i]);
  return hrt() - t0;
});
row("1a. readFileSync (OS cache warm, Buffer)", ioWarmNs);

const ioWarmUtf8Ns = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) fs.readFileSync(files[i], "utf8");
  return hrt() - t0;
});
row("1b. readFileSync utf8 string (OS cache warm)", ioWarmUtf8Ns);

// ── Stage 2: String encode overhead ──────────────────────────────
const encodeNs = segment(() => {
  const t0 = hrt();
  const enc2 = new TextEncoder();
  for (let i = 0; i < N; i++) enc2.encode(codes[i]);
  return hrt() - t0;
});
row("2.  TextEncoder.encode (string→UTF-8 bytes)", encodeNs);

// ── Stage 3: Parse only (codes pre-loaded) ────────────────────────
const parseNs = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) { try { parse(codes[i], { filename: files[i] }); } catch {} }
  return hrt() - t0;
});
row("3.  parse() only (NAPI, source pre-loaded)", parseNs);

// ── Stage 4: Parse NAPI overhead isolation ────────────────────────
// Parse the SAME file N times — eliminates source variability, isolates NAPI overhead.
const parseNapiNs = segment(() => {
  const t0 = hrt();
  const src0 = codes[0], fn0 = files[0];
  for (let i = 0; i < N; i++) { try { parse(src0, { filename: fn0 }); } catch {} }
  return hrt() - t0;
});
row("4.  parse() same file ×N (NAPI overhead only)", parseNapiNs);

// ── Stage 5: Full pipeline (I/O warm + parse + all rules) ────────
const fullNs = rSegment(() => {
  const t0 = hrt();
  for (let i = 0; i < rN; i++) {
    try {
      const src = fs.readFileSync(rFiles[i], "utf8");
      const ast = parse(src, { filename: rFiles[i] });
      runPlugins(ast, pluginsAll, { filename: rFiles[i], tagNames });
    } catch {}
  }
  return hrt() - t0;
});
rowR("5.  I/O(warm) + parse + runPlugins(all rules)", fullNs);

// ── Stage 6: Token pre-scan time ─────────────────────────────────
const scanNs = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    for (const pat of Object.values(RULE_TRIGGERS)) codes[i].includes(pat);
  }
  return hrt() - t0;
});
row(`6.  Token pre-scan (${triggerPatterns.length} trigger patterns)`, scanNs);

// ── Stage 7: Full pipeline + token gating (skip if no triggers) ──
let gatedFiles = 0;
const gatedNs = rSegment(() => {
  const t0 = hrt();
  gatedFiles = 0;
  for (let i = 0; i < rN; i++) {
    if (!rHitsAll[i]) continue; // skip files with no relevant tokens
    gatedFiles++;
    try {
      const ast = parse(rCodes[i], { filename: rFiles[i] });
      runPlugins(ast, pluginsAll, { filename: rFiles[i], tagNames });
    } catch {}
  }
  return hrt() - t0;
});
const skipPct = ((1 - gatedFiles/rN)*100).toFixed(0);
const gateNote = rN < N ? ` [sample ${rN}]` : "";
rowN(`7.  parse + runPlugins, token-gated${gateNote}`, gatedNs, gatedFiles || 1);
console.log(`     → skipped ${rN-gatedFiles}/${rN} files (${skipPct}%)`);

// ── Stage 8: Async I/O overlap simulation ─────────────────────────
// Simulate: start reading file[i+1] while processing file[i].
// Uses Node's fs.promises but with synchronous parse+lint (single thread).
// This measures how much of the I/O latency can be hidden behind CPU work.
const asyncNs = rSegment(() => {
  return new Promise(resolve => {
    let i = 0;
    const t0 = hrt();
    function next() {
      if (i >= rN) { resolve(Number(BigInt(hrt()) - BigInt(t0))); return; }
      const idx = i++;
      try {
        const src = fs.readFileSync(rFiles[idx], "utf8");
        const ast = parse(src, { filename: rFiles[idx] });
        runPlugins(ast, pluginsAll, { filename: rFiles[idx], tagNames });
      } catch {}
      setImmediate(next); // yield event loop to allow async I/O progress
    }
    next();
  });
});
// Note: setImmediate adds overhead; the real benefit comes from concurrent reads.

// ── Breakdown summary ─────────────────────────────────────────────
console.log("─".repeat(75));
const sampleNote = rN < N ? ` (sample ${rN} files)` : "";
console.log(`\nBreakdown (median times)${sampleNote}:`);
// I/O and parse baseline scaled to rN for fair comparison
const parseMs  = (parseNs / N) * rN / 1e6; // scale parse to rN files
const ioMs     = (ioWarmUtf8Ns / N) * rN / 1e6; // scale I/O to rN files
const rulesPlusParseNs = rSegment(() => {
  const t0 = hrt();
  for (let i = 0; i < rN; i++) {
    try {
      const ast = parse(rCodes[i], { filename: rFiles[i] });
      runPlugins(ast, pluginsAll, { filename: rFiles[i], tagNames });
    } catch {}
  }
  return hrt() - t0;
});
const rulesMs = rulesPlusParseNs / 1e6 - parseMs;
console.log(`  I/O (warm):     ${ioMs.toFixed(1)} ms  (${(ioMs/(ioMs+parseMs+rulesMs)*100).toFixed(0)}%)`);
console.log(`  parse (NAPI):   ${parseMs.toFixed(1)} ms  (${(parseMs/(ioMs+parseMs+rulesMs)*100).toFixed(0)}%)`);
console.log(`  rules (all):    ${rulesMs.toFixed(1)} ms  (${(rulesMs/(ioMs+parseMs+rulesMs)*100).toFixed(0)}%)`);
console.log(`  total:          ${(ioMs+parseMs+rulesMs).toFixed(1)} ms`);

console.log("\nOptimization potential:");
const scanMs = scanNs / 1e6;
// skipFrac: fraction of files skipped by token gating (based on full corpus)
const skipFrac = 1 - hitFiles / N;
// Per-file parse+rule cost (from sample, scaled to full corpus)
const parseRulePerFile = (parseMs + rulesMs) / rN; // ms/file
const savedWorkMs = parseRulePerFile * skipFrac * N;
console.log(`  Token pre-scan cost:           ${scanMs.toFixed(1)} ms for all ${N} files`);
console.log(`  Files skipped by token gating: ${N-hitFiles}/${N} (${(skipFrac*100).toFixed(0)}%)`);
console.log(`  Parse+rules saved (gated):     ~${savedWorkMs.toFixed(0)} ms  (${parseRulePerFile.toFixed(3)} ms/file × ${N-hitFiles} skipped files)`);
console.log(`  Net pre-scan benefit:          ~${(savedWorkMs - scanMs).toFixed(0)} ms`);
// NAPI: use per-file numbers (full-corpus parse/NAPI are full-corpus values)
const napiUsPerFile = parseNapiNs / N / 1000;
const parseUsPerFile = parseNs / N / 1000;
const napiOverheadPct = ((parseNapiNs / parseNs) * 100).toFixed(0);
console.log(`  NAPI overhead per file:        ${napiUsPerFile.toFixed(1)} µs NAPI vs ${parseUsPerFile.toFixed(1)} µs parse  (~${napiOverheadPct}% overhead)`);
console.log("\nConclusions for batching:");
console.log(`  Batch N files → 1 NAPI call would save: ~${(parseNapiNs/1e6 * (1 - 1/N)).toFixed(1)} ms`);
console.log(`  (${napiUsPerFile.toFixed(1)} µs NAPI overhead × ${N} files)`);
console.log("\nDone.");
