"use strict";
/**
 * bench_worker_threads.js
 *
 * Measures whether Node.js Worker threads improve throughput for JS-only ESLint
 * rules vs the sequential single-threaded path.
 *
 * Native Zig rules bypass this entirely (they use Zig OS threads in lintFiles),
 * so we must use JS-only rules to exercise the worker path.
 *
 * Usage:
 *   node bench/bench_worker_threads.js [--threads 1,2,4,8,12] [--files N] [--rule <name>]
 *
 * Defaults: threads=[1,2,4,8,12], files=all in conformance dirs, rule=no-magic-numbers
 */

"use strict";
const { execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const os = require("os");

const ROOT = path.join(__dirname, "..");

// ── arg parsing ──────────────────────────────────────────────────
let threadCounts = [1, 2, 4, 8, 12];
let maxFiles = Infinity;
let ruleName = "no-magic-numbers"; // guaranteed JS-only
let warmupRuns = 1;

for (let i = 2; i < process.argv.length; i++) {
  const arg = process.argv[i];
  if (arg.startsWith("--threads=")) {
    threadCounts = arg.slice("--threads=".length).split(",").map(Number);
  } else if (arg === "--threads") {
    threadCounts = process.argv[++i].split(",").map(Number);
  } else if (arg.startsWith("--files=")) {
    maxFiles = parseInt(arg.slice("--files=".length), 10);
  } else if (arg === "--files") {
    maxFiles = parseInt(process.argv[++i], 10);
  } else if (arg.startsWith("--rule=")) {
    ruleName = arg.slice("--rule=".length);
  } else if (arg === "--rule") {
    ruleName = process.argv[++i];
  }
}

// ── file discovery ───────────────────────────────────────────────
const JS_EXTS = new Set([".js", ".mjs", ".cjs", ".jsx", ".ts", ".mts", ".cts", ".tsx"]);

function discoverFiles(dir, max) {
  const results = [];
  function walk(p) {
    if (results.length >= max) return;
    let entries;
    try { entries = fs.readdirSync(p, { withFileTypes: true }); } catch { return; }
    for (const e of entries) {
      if (results.length >= max) return;
      const full = path.join(p, e.name);
      if (e.isDirectory()) {
        if (e.name === "node_modules" || e.name.startsWith(".")) continue;
        walk(full);
      } else if (e.isFile() && JS_EXTS.has(path.extname(e.name))
                 && !e.name.endsWith(".d.ts") && !e.name.endsWith(".d.mts")) {
        results.push(full);
      }
    }
  }
  walk(dir);
  return results;
}

// Collect from conformance dirs (small files — most representative of real-world load)
const searchDirs = [
  path.join(ROOT, "tests/conformance/test262/test/language"),
  path.join(ROOT, "tests/conformance/babel/packages/babel-parser/test/fixtures"),
  path.join(ROOT, "tests/conformance/typescript/tests/cases/conformance"),
];

console.log("Discovering files...");
const allFiles = [];
for (const dir of searchDirs) {
  if (!fs.existsSync(dir)) continue;
  const found = discoverFiles(dir, maxFiles - allFiles.length);
  allFiles.push(...found);
  if (allFiles.length >= maxFiles) break;
}

if (allFiles.length === 0) {
  console.error("No files found. Run `make submodules` to populate conformance dirs.");
  process.exit(1);
}

const fileCount = allFiles.length;
const totalBytes = allFiles.reduce((s, f) => {
  try { return s + fs.statSync(f).size; } catch { return s; }
}, 0);

console.log(`Files: ${fileCount.toLocaleString()} | Total: ${(totalBytes / 1024 / 1024).toFixed(1)} MB`);
console.log(`Rule:  ${ruleName} (JS-only — forces worker path)`);
console.log(`CPUs:  ${os.cpus().length}`);
console.log();

// Write file list to a temp file so lint.js can consume it via xargs-style
// Actually we call lint.js directly via execFileSync with the file list.
// To avoid ARG_MAX limits with 100k files, write paths to a temp response file
// and pass them via stdin or a file list.
// Lint.js accepts directories — collect unique parent dirs. But that re-discovers.
// Better: write a wrapper that calls the internal API directly.

// ── Direct API benchmark (bypasses CLI overhead) ─────────────────

// We invoke lint.js logic directly via require to avoid process spawn overhead.
// This gives cleaner numbers.

// Write file list to temp file
const tmpList = path.join(os.tmpdir(), "sanz_bench_files.txt");
fs.writeFileSync(tmpList, allFiles.join("\n"));

// Build a minimal lint.js-equivalent harness using the worker thread machinery
const LINT_WORKER = path.join(ROOT, "js/lint-worker.js");
const { Worker } = require("worker_threads");

const { getNativeRules, buildNativeConfig } = require(path.join(ROOT, "js/index"));
const { loadPlugin } = require(path.join(ROOT, "js/load-plugin"));

// Load eslint plugin
let plugins;
try {
  plugins = loadPlugin("eslint", new Set([ruleName]));
} catch (e) {
  console.error(`Cannot load eslint plugin: ${e.message}`);
  console.error("Run: cd js && npm install eslint");
  process.exit(1);
}

if (plugins.length === 0) {
  console.error(`Rule '${ruleName}' not found in eslint plugin`);
  process.exit(1);
}

// Verify it's JS-only
const nativeRules = getNativeRules();
if (nativeRules.has(ruleName)) {
  console.error(`WARNING: '${ruleName}' is a NATIVE rule — workers won't be used. Results won't show worker benefit.`);
}

const ruleConfig = {};
const pluginNames = ["eslint"];
const ruleFilters = [ruleName];
const typeAware = false;
const applyFix = false;

function splitChunks(arr, n) {
  const size = Math.ceil(arr.length / n);
  const chunks = [];
  for (let i = 0; i < arr.length; i += size) chunks.push(arr.slice(i, i + size));
  return chunks;
}

function runWithThreads(files, threads) {
  return new Promise((resolve, reject) => {
    if (threads === 1) {
      // Sequential: one-shot worker (or inline)
      const w = new Worker(LINT_WORKER, {
        workerData: { files, pluginNames, ruleFilters, ruleConfig, applyFix, typeAware },
      });
      w.once("message", (results) => {
        if (results && results.fatalError) return reject(new Error(results.fatalError));
        resolve(results);
      });
      w.once("error", reject);
      return;
    }

    // Multi-threaded pool mode with wave warmup (mirrors lint.js _runFileParallel)
    const chunks = splitChunks(files, threads);
    const allResults = new Array(chunks.length);
    const workers = [];
    let done = 0;
    let rejected = false;
    const warmupFile = files[0];
    const WAVE_SIZE = 3;
    let spawned = 0;
    let warmedUp = 0;

    function onReject(err) { if (!rejected) { rejected = true; reject(err); } }

    function spawnWave() {
      const end = Math.min(spawned + WAVE_SIZE, chunks.length);
      while (spawned < end) spawnOne(spawned++);
    }

    function spawnOne(idx) {
      const w = new Worker(LINT_WORKER, {
        workerData: { pluginNames, ruleFilters, ruleConfig, applyFix, typeAware },
      });
      workers[idx] = w;
      w.on("message", (msg) => {
        if (msg.fatalError) { onReject(new Error(msg.fatalError)); return; }
        if (msg.ready) { w.postMessage({ files: [warmupFile], batchId: -1 }); return; }
        if (msg.batchId === -1) {
          if (++warmedUp % WAVE_SIZE === 0 || warmedUp === chunks.length) {
            if (spawned < chunks.length) spawnWave();
          }
          if (warmedUp === chunks.length) {
            for (let i = 0; i < workers.length; i++) workers[i].postMessage({ files: chunks[i], batchId: i });
          }
          return;
        }
        if (msg.results !== undefined && msg.batchId >= 0) {
          allResults[msg.batchId] = msg.results;
          w.postMessage({ exit: true });
          if (++done === chunks.length) resolve(allResults.flat());
        }
      });
      w.on("error", onReject);
      w.on("exit", (code) => { if (code !== 0 && !rejected && done < chunks.length) onReject(new Error(`Worker ${idx} exited ${code}`)); });
    }
    spawnWave();
  });
}

// ── run benchmark ────────────────────────────────────────────────

async function bench(threads) {
  // Warmup run (not timed)
  const warmupFiles = allFiles.slice(0, Math.min(500, allFiles.length));
  await runWithThreads(warmupFiles, Math.min(threads, warmupFiles.length));

  const t0 = performance.now();
  const results = await runWithThreads(allFiles, threads);
  const elapsed = (performance.now() - t0) / 1000;

  const violations = results.reduce((s, r) => s + (r.violations?.length ?? 0), 0);
  const errors = results.filter(r => r.readError || r.parseError).length;
  const filesPerSec = (fileCount / elapsed).toFixed(0);
  const mbPerSec = (totalBytes / 1024 / 1024 / elapsed).toFixed(1);

  return { threads, elapsed, filesPerSec, mbPerSec, violations, errors };
}

async function main() {
  const results = [];

  // Filter thread counts to not exceed file count or CPU count
  const cpus = os.cpus().length;
  const validThreads = threadCounts.filter(t => t >= 1 && t <= Math.max(fileCount, cpus));

  console.log(`${"threads".padEnd(8)} ${"time(s)".padEnd(10)} ${"files/s".padEnd(10)} ${"MB/s".padEnd(8)} ${"violations".padEnd(12)} notes`);
  console.log("─".repeat(70));

  let baseline = null;

  for (const t of validThreads) {
    process.stdout.write(`${String(t).padEnd(8)} `);
    try {
      const r = await bench(t);
      results.push(r);
      if (!baseline) baseline = r;
      const speedup = baseline ? (baseline.elapsed / r.elapsed).toFixed(2) + "x" : "1.00x";
      console.log(
        `${r.elapsed.toFixed(2).padEnd(10)} ${r.filesPerSec.padEnd(10)} ${r.mbPerSec.padEnd(8)} ${String(r.violations).padEnd(12)} ${t === 1 ? "(baseline)" : speedup}`
      );
    } catch (e) {
      console.log(`ERROR: ${e.message}`);
    }
  }

  console.log();
  if (results.length >= 2) {
    const best = results.reduce((a, b) => b.elapsed < a.elapsed ? b : a);
    const seq = results[0];
    console.log(`Best:     ${best.threads} threads — ${(seq.elapsed / best.elapsed).toFixed(2)}x speedup over sequential`);
    console.log(`Peak:     ${best.filesPerSec} files/s at ${best.mbPerSec} MB/s`);
    if (best.threads === 1) {
      console.log("Verdict:  Worker threads do NOT improve throughput (overhead dominates).");
    } else {
      const pct = (((seq.elapsed - best.elapsed) / seq.elapsed) * 100).toFixed(0);
      console.log(`Verdict:  Worker threads save ~${pct}% wall time at ${best.threads} threads.`);
    }
  }

  fs.unlinkSync(tmpList);
}

main().catch(e => { console.error(e); process.exit(1); });
