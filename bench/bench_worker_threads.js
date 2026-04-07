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
 * Uses the same streaming pool pattern as lint.js _runFileParallel: workers get
 * MINI_BATCH files at a time, results are counted immediately (not accumulated),
 * memory is bounded to workerCount × MINI_BATCH × avg_result_size.
 *
 * Usage:
 *   node bench/bench_worker_threads.js [--threads 1,2,4,8,12] [--files N] [--rule <name>]
 */

const path = require("path");
const fs = require("fs");
const os = require("os");
const { Worker } = require("worker_threads");

const ROOT = path.join(__dirname, "..");
const LINT_WORKER = path.join(ROOT, "js/lint-worker.js");

// ── arg parsing ──────────────────────────────────────────────────
let threadCounts = [1, 2, 4, 8, 12];
let maxFiles = Infinity;
let ruleName = "no-magic-numbers"; // guaranteed JS-only

for (let i = 2; i < process.argv.length; i++) {
  const arg = process.argv[i];
  if (arg.startsWith("--threads=")) threadCounts = arg.slice(10).split(",").map(Number);
  else if (arg === "--threads") threadCounts = process.argv[++i].split(",").map(Number);
  else if (arg.startsWith("--files=")) maxFiles = parseInt(arg.slice(8), 10);
  else if (arg === "--files") maxFiles = parseInt(process.argv[++i], 10);
  else if (arg.startsWith("--rule=")) ruleName = arg.slice(7);
  else if (arg === "--rule") ruleName = process.argv[++i];
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

const searchDirs = [
  path.join(ROOT, "tests/conformance/test262/test/language"),
  path.join(ROOT, "tests/conformance/babel/packages/babel-parser/test/fixtures"),
  path.join(ROOT, "tests/conformance/typescript/tests/cases/conformance"),
];

console.log("Discovering files...");
const allFiles = [];
for (const dir of searchDirs) {
  if (!fs.existsSync(dir)) continue;
  allFiles.push(...discoverFiles(dir, maxFiles - allFiles.length));
  if (allFiles.length >= maxFiles) break;
}

if (allFiles.length === 0) {
  console.error("No files found. Run `make submodules` to populate conformance dirs.");
  process.exit(1);
}

const totalBytes = allFiles.reduce((s, f) => {
  try { return s + fs.statSync(f).size; } catch { return s; }
}, 0);

console.log(`Files: ${allFiles.length.toLocaleString()} | Total: ${(totalBytes / 1024 / 1024).toFixed(1)} MB`);
console.log(`Rule:  ${ruleName} (JS-only — forces worker path)`);
console.log(`CPUs:  ${os.cpus().length}`);
console.log();

// ── load plugin ──────────────────────────────────────────────────
const { getNativeRules } = require(path.join(ROOT, "js/index"));
const { loadPlugin } = require(path.join(ROOT, "js/load-plugin"));

let plugins;
try {
  plugins = loadPlugin("eslint", new Set([ruleName]));
} catch (e) {
  console.error(`Cannot load eslint plugin: ${e.message}\nRun: cd js && npm install eslint`);
  process.exit(1);
}
if (plugins.length === 0) { console.error(`Rule '${ruleName}' not found`); process.exit(1); }

const nativeRules = getNativeRules();
if (nativeRules.has(ruleName)) {
  console.error(`WARNING: '${ruleName}' is a NATIVE rule — workers won't be used.`);
}

const pluginNames = ["eslint"];
const ruleFilters = [ruleName];
const ruleConfig = {};

// ── streaming pool (mirrors lint.js _runFileParallel) ────────────
// Workers get MINI_BATCH files at a time; results are counted immediately
// without accumulation. Memory = workerCount × MINI_BATCH × avg_result_size.

const MINI_BATCH = 50;

function runStream(files, threads) {
  const workerCount = Math.min(threads, files.length);
  let violations = 0;
  let errors = 0;

  return new Promise((resolve, reject) => {
    let cursor = 0;
    let doneWorkers = 0;
    let rejected = false;
    const warmupFile = files[0];
    const workers = new Array(workerCount);
    let spawned = 0;
    let warmedUp = 0;
    const WAVE_SIZE = 3;

    function onReject(err) { if (!rejected) { rejected = true; reject(err); } }

    function dispatchNext(worker) {
      if (rejected) return;
      if (cursor >= files.length) {
        worker.postMessage({ exit: true });
        if (++doneWorkers === workerCount) resolve({ violations, errors });
        return;
      }
      const end = Math.min(cursor + MINI_BATCH, files.length);
      worker.postMessage({ files: files.slice(cursor, end), batchId: cursor });
      cursor = end;
    }

    function spawnWave() {
      const end = Math.min(spawned + WAVE_SIZE, workerCount);
      while (spawned < end) spawnOne(spawned++);
    }

    function spawnOne(idx) {
      const worker = new Worker(LINT_WORKER, {
        workerData: { pluginNames, ruleFilters, ruleConfig, applyFix: false, typeAware: false },
      });
      workers[idx] = worker;
      worker.on("message", (msg) => {
        if (msg.fatalError) { onReject(new Error(msg.fatalError)); return; }
        if (msg.ready) { worker.postMessage({ files: [warmupFile], batchId: -1 }); return; }
        if (msg.batchId === -1) {
          if (++warmedUp % WAVE_SIZE === 0 || warmedUp === workerCount) {
            if (spawned < workerCount) spawnWave();
          }
          if (warmedUp === workerCount) {
            for (let i = 0; i < workerCount; i++) dispatchNext(workers[i]);
          }
          return;
        }
        if (msg.results !== undefined && msg.batchId >= 0) {
          // Count immediately — never store
          for (const r of msg.results) {
            if (r.violations) violations += r.violations.length;
            else if (r.readError || r.parseError) errors++;
          }
          dispatchNext(worker);
        }
      });
      worker.on("error", onReject);
      worker.on("exit", (code) => {
        if (code !== 0 && !rejected && doneWorkers < workerCount)
          onReject(new Error(`Worker ${idx} exited ${code}`));
      });
    }
    spawnWave();
  });
}

// ── benchmark ────────────────────────────────────────────────────
async function bench(threads) {
  // Warmup: small slice to force JIT compilation before timing
  const warmupFiles = allFiles.slice(0, Math.min(200, allFiles.length));
  await runStream(warmupFiles, Math.min(threads, warmupFiles.length));

  const t0 = performance.now();
  const { violations, errors } = await runStream(allFiles, threads);
  const elapsed = (performance.now() - t0) / 1000;

  return {
    threads,
    elapsed,
    filesPerSec: Math.round(allFiles.length / elapsed),
    mbPerSec: (totalBytes / 1024 / 1024 / elapsed).toFixed(1),
    violations,
    errors,
  };
}

async function main() {
  const cpus = os.cpus().length;
  const validThreads = threadCounts.filter(t => t >= 1 && t <= Math.max(allFiles.length, cpus));

  console.log(`${"threads".padEnd(8)} ${"time(s)".padEnd(10)} ${"files/s".padEnd(10)} ${"MB/s".padEnd(8)} violations`);
  console.log("─".repeat(55));

  const results = [];
  for (const t of validThreads) {
    process.stdout.write(`${String(t).padEnd(8)} `);
    try {
      const r = await bench(t);
      results.push(r);
      const baseline = results[0];
      const speedup = t === 1 ? "(baseline)" : `${(baseline.elapsed / r.elapsed).toFixed(2)}x`;
      console.log(`${r.elapsed.toFixed(2).padEnd(10)} ${String(r.filesPerSec).padEnd(10)} ${r.mbPerSec.padEnd(8)} ${r.violations}  ${speedup}`);
    } catch (e) {
      console.log(`ERROR: ${e.message}`);
    }
  }

  console.log();
  if (results.length >= 2) {
    const best = results.reduce((a, b) => b.elapsed < a.elapsed ? b : a);
    const seq = results[0];
    if (best.threads === 1) {
      console.log("Verdict: Worker threads do NOT improve throughput (overhead dominates).");
    } else {
      const pct = (((seq.elapsed - best.elapsed) / seq.elapsed) * 100).toFixed(0);
      console.log(`Best:    ${best.threads} threads — ${(seq.elapsed / best.elapsed).toFixed(2)}x speedup, saves ~${pct}% wall time`);
      console.log(`Peak:    ${best.filesPerSec.toLocaleString()} files/s at ${best.mbPerSec} MB/s`);
    }
  }
}

main().catch(e => { console.error(e); process.exit(1); });
