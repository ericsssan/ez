"use strict";
/**
 * bench-hybrid.js — benchmark hybrid routing vs pure-JS runner path
 *
 * Measures per-file wall time for:
 *   A) parse(source)  +  runPlugins(ast, allPlugins)    [all rules via JS]
 *   B) parseAndLint(source, {config})  +  runPlugins(ast, jsOnlyPlugins)  [split routing]
 *   C) parseAndLint(source)   [all native rules, no JS runner]
 *   D) parse(source) only     [baseline — no lint]
 *
 * Usage:
 *   node js/bench-hybrid.js [--files N] [--warmup N] [--iters N]
 */

const fs   = require("fs");
const path = require("path");

const ez = require("./index");
const { runPlugins } = require("./eslint-runner");
const { loadPlugin }  = require("./load-plugin");

// ── CLI ──────────────────────────────────────────────────────────
const argv = process.argv.slice(2);
let MAX_FILES = 999999; // no cap
let WARMUP    = 200;
let ITERS     = 1;

for (let i = 0; i < argv.length; i++) {
  if (argv[i] === "--files")  MAX_FILES = parseInt(argv[++i], 10);
  if (argv[i] === "--warmup") WARMUP    = parseInt(argv[++i], 10);
  if (argv[i] === "--iters")  ITERS     = parseInt(argv[++i], 10);
}

// ── Corpus ───────────────────────────────────────────────────────
function collectFiles(dir, exts, minB, maxB, limit) {
  const results = [];
  function walk(p) {
    if (results.length >= limit) return;
    let entries;
    try { entries = fs.readdirSync(p, { withFileTypes: true }); } catch { return; }
    for (const e of entries) {
      if (results.length >= limit) break;
      if (e.name.startsWith(".")) continue;
      const full = path.join(p, e.name);
      if (e.isDirectory()) { walk(full); continue; }
      if (!exts.has(path.extname(e.name))) continue;
      if (e.name.endsWith(".d.ts") || e.name.endsWith(".d.mts") || e.name.endsWith(".d.cts")) continue;
      try {
        const size = fs.statSync(full).size;
        if (size >= minB && size <= maxB) results.push(full);
      } catch {}
    }
  }
  walk(dir);
  return results;
}

const files = collectFiles(
  path.join(__dirname, "..", "tests", "conformance"),
  new Set([".js", ".ts", ".jsx", ".tsx"]),
  1024, 200 * 1024, MAX_FILES,
);

if (files.length === 0) {
  console.error("No files found — run from the Ez repo root.");
  process.exit(1);
}

// Read all files up front; skip files with import X = require() TS syntax (parser crash)
// Matches TS import-equals forms: import X = require(...) / import X = Namespace / import type X = ...
const TS_IMPORT_ASSIGN = /\bimport\s+(?:type\s+)?\w+\s*=/;
const rawSources = files.map(f => {
  try {
    const src = fs.readFileSync(f, "utf8");
    if (TS_IMPORT_ASSIGN.test(src)) return null;
    return { file: f, src };
  } catch { return null; }
}).filter(Boolean);

// Pre-validate via subprocess batches: finds both JS exceptions AND native crashes.
// Using parseAndLint because some AST patterns crash only during lint, not parse.
const { execFileSync } = require("child_process");
process.stderr.write(`Pre-validating ${rawSources.length} files (subprocess batches)...`);
const BATCH = 100;
const crashSet = new Set();
for (let i = 0; i < rawSources.length; i += BATCH) {
  const batch = rawSources.slice(i, i + BATCH).map(x => x.file);
  try {
    execFileSync(process.execPath, ["-e", `
const ez = require('./js/index.js');
const fs = require('fs');
const files = ${JSON.stringify(batch)};
for (const f of files) { try { ez.parseAndLintSource(fs.readFileSync(f,'utf8'),{filename:f}); } catch {} }
`], { timeout: 20000, cwd: process.cwd() });
  } catch (e) {
    if (e.status === 138 || e.status === 139 || e.signal) {
      // crash in this batch — bisect to find exact file
      for (const f of batch) {
        try {
          execFileSync(process.execPath, ["-e", `
const ez = require('./js/index.js');
const fs = require('fs');
ez.parseAndLintSource(fs.readFileSync(${JSON.stringify(f)},'utf8'),{filename:${JSON.stringify(f)}});
`], { timeout: 5000, cwd: process.cwd() });
        } catch (e2) {
          if (e2.status === 138 || e2.status === 139 || e2.signal) crashSet.add(f);
        }
      }
    }
  }
}
const sources = rawSources.filter(({ file, src }) => {
  if (crashSet.has(file)) return false;
  try { ez.parseSource(src, { filename: file }); return true; }
  catch { return false; }
});
console.error(` ${sources.length} ok, ${rawSources.length - sources.length} skipped (${crashSet.size} native crashes)`);

console.log(`Corpus: ${sources.length} files`);

// ── Rule setup ───────────────────────────────────────────────────
// Load eslint plugin for JS runner
let allPlugins = [];
try {
  allPlugins = loadPlugin("eslint", new Set());
} catch {
  try {
    // fall back to just using a subset of rules directly
    allPlugins = [];
  } catch {}
}

const tagNames      = ez.getTagNames();
const nativeRules   = ez.getNativeRules();
const nativeNames   = new Set(nativeRules.keys());

// Partition plugin rules: native-covered vs JS-only
const jsOnlyPlugins = allPlugins.filter(p => {
  const name = p.meta?.name ?? p.id ?? "";
  // strip "eslint/" prefix if present
  const bare = name.replace(/^eslint\//, "");
  return !nativeNames.has(bare) && !nativeNames.has(name);
});
const nativeCoveredRules = allPlugins.filter(p => {
  const name = p.meta?.name ?? p.id ?? "";
  const bare = name.replace(/^eslint\//, "");
  return nativeNames.has(bare) || nativeNames.has(name);
});

// Build native config from the native-covered ESLint rules
const nativeRuleConfig = {};
for (const p of nativeCoveredRules) {
  const name = (p.meta?.name ?? p.id ?? "").replace(/^eslint\//, "");
  if (nativeNames.has(name)) nativeRuleConfig[name] = "warn";
}
const nativeConfig = ez.buildNativeConfig(nativeRuleConfig);

console.log(`ESLint plugin rules: ${allPlugins.length} total`);
console.log(`  → native-covered:  ${nativeCoveredRules.length} (will run via Zig in hybrid path)`);
console.log(`  → JS-only:         ${jsOnlyPlugins.length}  (always via JS runner)`);
console.log(`Native config rules enabled: ${Object.keys(nativeRuleConfig).length}`);
console.log();

// ── Benchmark helpers ────────────────────────────────────────────
function hrMs() {
  const [s, ns] = process.hrtime();
  return s * 1e3 + ns / 1e6;
}

function runOnce(label, fn) {
  const t0 = hrMs();
  let count = 0;
  for (const { file, src } of sources) {
    try { fn(src, file); } catch { continue; }
    count++;
  }
  const elapsed = hrMs() - t0;
  return { label, count, elapsed, msPerFile: elapsed / count };
}

function bench(label, fn) {
  // warmup
  for (let w = 0; w < WARMUP; w++) {
    const idx = w % sources.length;
    try { fn(sources[idx].src, sources[idx].file); } catch {}
  }

  const totalMs = [];
  for (let i = 0; i < ITERS; i++) {
    const r = runOnce(label, fn);
    totalMs.push(r.elapsed);
  }
  totalMs.sort((a, b) => a - b);
  const bestTotal  = totalMs[0];
  const medTotal   = totalMs[Math.floor(totalMs.length / 2)];
  const msPerFile  = medTotal / sources.length;
  return { label, median: msPerFile, min: bestTotal / sources.length, totalMs: medTotal, bestTotal };
}

// ── Paths ────────────────────────────────────────────────────────

// D: parse only (baseline)
const pathD = bench("D  parseSource() only", (src, file) => {
  ez.parseSource(src, { filename: file });
});

// A: parseSource + runPlugins (all rules via JS)
const pathA = allPlugins.length > 0
  ? bench("A  parseSource + runPlugins (all JS)", (src, file) => {
      const ast = ez.parseSource(src, { filename: file });
      runPlugins(ast, allPlugins, { filename: file, tagNames });
    })
  : null;

// C: parseAndLintSource (all native, no JS runner)
const pathC = bench("C  parseAndLintSource (all native)", (src, file) => {
  ez.parseAndLintSource(src, { filename: file });
});

// B: hybrid — parseAndLintSource(nativeConfig) + runPlugins(jsOnly)
const pathB = bench("B  hybrid: parseAndLintSource(cfg) + runPlugins(jsOnly)", (src, file) => {
  const { ast } = ez.parseAndLintSource(src, { filename: file, config: nativeConfig });
  if (jsOnlyPlugins.length > 0) {
    runPlugins(ast, jsOnlyPlugins, { filename: file, tagNames });
  }
});

// ── Results ──────────────────────────────────────────────────────
const all = [pathD, pathA, pathC, pathB].filter(Boolean);
all.sort((a, b) => a.median - b.median);

const fastest = all[0].median;

const fileCount = sources.length;
console.log(`Results (${fileCount} files, median of ${ITERS} runs — lower is better):`);
console.log("─".repeat(78));
console.log(`${"Path".padEnd(48)} ${"ms/file".padStart(8)}  ${"total".padStart(8)}  ratio`);
console.log("─".repeat(78));
for (const r of all) {
  const ratio = (r.median / fastest).toFixed(2);
  const totalSec = (r.totalMs / 1000).toFixed(2);
  console.log(
    `${r.label.padEnd(48)} ${r.median.toFixed(3).padStart(8)}  ${(totalSec + "s").padStart(8)}  ${ratio}×`
  );
}
console.log("─".repeat(78));

if (pathA && pathB) {
  const speedup = pathA.median / pathB.median;
  const change  = ((pathB.median - pathA.median) / pathA.median * 100).toFixed(1);
  const sign    = speedup >= 1 ? "faster" : "slower";
  console.log(`\nHybrid vs all-JS: ${Math.abs(speedup).toFixed(2)}× ${sign} (${Math.abs(parseFloat(change))}% ${speedup >= 1 ? "reduction" : "overhead"})`);
}

if (pathA && pathC) {
  const speedup = pathA.median / pathC.median;
  console.log(`Native-only vs all-JS: ${speedup.toFixed(2)}× faster`);
}
