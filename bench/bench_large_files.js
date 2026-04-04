"use strict";
/**
 * Large-file benchmark — parse + lint on real-world large files.
 *
 * Stresses things the corpus benchmarks miss:
 *   - Deep AST trees (checker.ts: ~170k nodes)
 *   - Scope analysis on large symbol tables
 *   - Rule dispatch at high node counts
 *
 * Usage: node bench/bench_large_files.js
 */

const fs   = require("fs");
const path = require("path");

const ROOT   = path.join(__dirname, "..");
const JS_DIR = path.join(ROOT, "js");

const { parse, getTagNames }  = require(path.join(JS_DIR, "index"));
const { runPlugins }          = require(path.join(JS_DIR, "eslint-runner"));
const { loadPlugin }          = require(path.join(JS_DIR, "load-plugin"));

const tagNames   = getTagNames();
const pluginsAll = loadPlugin("eslint", new Set());

// ── Files ────────────────────────────────────────────────────────

const LARGE_FILES = [
  {
    rel:   "tests/conformance/babel/Makefile.js",
    lang:  "js",
    label: "Makefile.js (babel, ~200KB JS)",
  },
  {
    rel:   "tests/conformance/babel/packages/babel-generator/test/fixtures/edgecase/large-file-concise/output.js",
    lang:  "js",
    label: "large-file-concise/output.js (babel, ~3.4MB JS)",
  },
  {
    rel:   "tests/conformance/typescript/src/compiler/checker.ts",
    lang:  "ts",
    label: "checker.ts (TypeScript compiler, ~3MB TS)",
  },
];

// ── Helpers ──────────────────────────────────────────────────────

function hrt() { return Number(process.hrtime.bigint()); }

function fmtMs(ns) { return (ns / 1e6).toFixed(1) + " ms"; }
function fmtMBs(bytes, ns) {
  return ((bytes / 1024 / 1024) / (ns / 1e9)).toFixed(1) + " MB/s";
}

function median(arr) {
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}

const PARSE_REPS  = 5;
const LINT_REPS   = 3;

// ── Per-rule timing ──────────────────────────────────────────────

function timeAllRules(ast, filename) {
  const results = [];
  for (const plugin of pluginsAll) {
    const t0 = hrt();
    try { runPlugins(ast, [plugin], { filename, tagNames }); } catch {}
    const ns = hrt() - t0;
    results.push({ name: plugin.meta?.name ?? "?", ns });
  }
  results.sort((a, b) => b.ns - a.ns);
  return results;
}

// ── Main ─────────────────────────────────────────────────────────

console.log(`Large-file benchmark  (${pluginsAll.length} ESLint rules)\n`);

for (const { rel, lang, label } of LARGE_FILES) {
  const filePath = path.join(ROOT, rel);
  if (!fs.existsSync(filePath)) {
    console.log(`SKIP ${label}\n  (file not found: ${rel})\n`);
    continue;
  }

  const src       = fs.readFileSync(filePath, "utf8");
  const byteLen   = Buffer.byteLength(src, "utf8");
  console.log(`── ${label}`);
  console.log(`   ${(byteLen / 1024).toFixed(0)} KB  ·  ${src.split("\n").length.toLocaleString()} lines`);

  // ── Parse benchmark ─────────────────────────────────────────
  let ast;
  const parseTimes = [];
  for (let i = 0; i < PARSE_REPS; i++) {
    const t0 = hrt();
    try { ast = parse(src, { filename: rel, lang }); }
    catch (e) { console.log(`   PARSE ERROR: ${e.message}`); break; }
    parseTimes.push(hrt() - t0);
  }
  if (!ast) { console.log(); continue; }

  const parseNs = median(parseTimes);
  console.log(`   Parse  ${fmtMs(parseNs).padStart(8)}  ·  ${fmtMBs(byteLen, parseNs).padStart(10)}  ·  ${ast.nodeCount.toLocaleString()} nodes`);

  // ── All-rules lint benchmark ─────────────────────────────────
  const lintTimes = [];
  for (let i = 0; i < LINT_REPS; i++) {
    const t0 = hrt();
    try { runPlugins(ast, pluginsAll, { filename: rel, tagNames }); } catch {}
    lintTimes.push(hrt() - t0);
  }
  const lintNs = median(lintTimes);
  const nsPerNode = ast.nodeCount > 0 ? (lintNs / ast.nodeCount).toFixed(1) : "?";
  console.log(`   Lint   ${fmtMs(lintNs).padStart(8)}  ·  ${nsPerNode.padStart(8)} ns/node  ·  ${pluginsAll.length} rules`);

  // ── Top slowest rules ────────────────────────────────────────
  const perRule = timeAllRules(ast, rel);
  console.log(`   Top 10 slowest rules:`);
  for (const { name, ns } of perRule.slice(0, 10)) {
    console.log(`     ${fmtMs(ns).padStart(8)}  ${name}`);
  }

  // ── Slowest 1% threshold ─────────────────────────────────────
  const threshold = lintNs / pluginsAll.length * 10; // 10× average = outlier
  const outliers = perRule.filter(r => r.ns > threshold);
  if (outliers.length > 0) {
    console.log(`   Outliers (>10× avg): ${outliers.map(r => r.name).join(", ")}`);
  }

  console.log();
}

console.log("Done.");
