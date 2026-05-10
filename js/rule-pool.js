"use strict";
//
// Rule-pool: parallel rule execution by partitioning the rule set
// across N worker threads. Each worker re-parses the source itself
// (NAPI is fast and runs concurrently). Results merge on the main
// thread.
//
// When this helps
// ---------------
//   • Single large file with many rules (perf_hunt's case) — yes.
//   • LSP / watch mode — yes (warm pool amortises spawn cost).
//   • Tiny files — no (worker IPC + each-worker reparse exceeds
//     single-thread lint of a small AST). Caller should bypass.
//
// When it hurts
// -------------
//   • Cold one-shot CLI: pool spawn = N workers × ~310 ms (with
//     bytecode cache) loaded in parallel ≈ 310 ms wall-clock + 12 MB
//     × N memory.
//
// Lifecycle
// ---------
// The pool is a process-wide singleton: lazy-spawned on first
// `lintWithPool` call, persists for the rest of the process. Callers
// don't manage it explicitly. `terminatePool()` is exported for tests
// or graceful shutdown.

const path = require("path");

const WORKER_PATH = path.join(__dirname, "rule-pool-worker.js");
const DEFAULT_WORKERS = (() => {
  // Default to 4 — anecdotally past explorations showed this hits the
  // ~2× ceiling on typescript.js. Override via EZ_POOL_WORKERS.
  const env = parseInt(process.env.EZ_POOL_WORKERS ?? "", 10);
  if (Number.isFinite(env) && env > 0) return env;
  return 4;
})();

let _poolPromise = null;
let _pool = null;

function _initPool(nWorkers) {
  const workers = [];
  const pending = new Map(); // reqId → { resolve, reject }
  let nextId = 0;
  let rr = 0;

  for (let i = 0; i < nWorkers; i++) {
    const w = new Worker(WORKER_PATH);
    w.addEventListener("message", ({ data }) => {
      if (data.type !== "result") return;
      const cb = pending.get(data.reqId);
      if (!cb) return;
      pending.delete(data.reqId);
      cb.resolve({ compact: data.compact, crashMsg: data.crashMsg, ms: data.ms });
    });
    w.addEventListener("error", (e) => {
      // Surface to whichever request is in flight on this worker —
      // imperfect attribution but at least it's not silent.
      for (const [id, cb] of pending) {
        cb.reject(new Error(`Worker error: ${String(e?.message ?? e)}`));
        pending.delete(id);
      }
    });
    workers.push(w);
  }

  // Wait until every worker has signalled `ready` (post-init).
  const ready = Promise.all(
    workers.map((w) => new Promise((resolve) => {
      const onReady = ({ data }) => {
        if (data.type === "ready") { w.removeEventListener("message", onReady); resolve(); }
      };
      w.addEventListener("message", onReady);
      w.postMessage({ type: "init" });
    })),
  );

  return ready.then(() => ({
    workers,
    pending,
    nextId() { return nextId++; },
    nextWorker() { return workers[rr++ % workers.length]; },
    register(reqId, resolve, reject) { pending.set(reqId, { resolve, reject }); },
  }));
}

async function getPool({ nWorkers = DEFAULT_WORKERS } = {}) {
  if (_pool) return _pool;
  if (!_poolPromise) {
    _poolPromise = _initPool(nWorkers).then((p) => { _pool = p; return p; });
  }
  return _poolPromise;
}

function _partitionRules(rules, n) {
  const ruleIds = Object.keys(rules);
  const partitions = Array.from({ length: n }, () => ({}));
  // Round-robin partition. Future work: cost-weighted partition using
  // per-rule attribution numbers from the analyzer.
  for (let i = 0; i < ruleIds.length; i++) {
    partitions[i % n][ruleIds[i]] = rules[ruleIds[i]];
  }
  return partitions;
}

/**
 * Parallel lint via the rule-pool. Same input shape as `lintSource`
 * but the rule set is partitioned across workers.
 *
 * Returns a compact summary across all partitions:
 *   {
 *     compact: [{ ruleIds, lines, cols, crash }, ...]   — one per worker that ran
 *     crashes: string[]                                  — partition-level crashes
 *     totalDiags: number
 *   }
 *
 * Diagnostic objects are NOT materialised across the worker boundary
 * (function references, deeply-nested loc objects, lazy fix functions
 * all defeat structured clone). Callers reconstruct only the shape
 * they need (see `runEzAllOnAstParallel` for the bench shape, or run
 * the single-thread `lintSource` if full report objects are required).
 */
async function lintWithPool(source, options = {}) {
  const pool = await getPool();
  const partitions = _partitionRules(options.rules || {}, pool.workers.length);
  const requests = partitions.map((part) => Object.keys(part).length ? part : null);

  const promises = requests.map((rulesPart) => {
    if (rulesPart === null) return Promise.resolve({ compact: null, crashMsg: null, ms: 0 });
    const reqId = pool.nextId();
    return new Promise((resolve, reject) => {
      pool.register(reqId, resolve, reject);
      pool.nextWorker().postMessage({
        type: "lint",
        reqId,
        source,
        filename: options.filename,
        sourceType: options.sourceType,
        ecmaVersion: options.ecmaVersion,
        ruleConfig: rulesPart,
        plugins: options.plugins,
        languageOptions: options.languageOptions,
        envGlobals: options.envGlobals,
        errorBudget: options.errorBudget,
      });
    });
  });

  const results = await Promise.all(promises);
  const compact = [];
  const crashes = [];
  let totalDiags = 0;
  for (const r of results) {
    if (r.crashMsg) crashes.push(r.crashMsg);
    if (r.compact) {
      compact.push(r.compact);
      totalDiags += r.compact.ruleIds.length;
    }
  }
  return { compact, crashes, totalDiags };
}

function terminatePool() {
  if (!_pool) return;
  for (const w of _pool.workers) w.terminate();
  _pool = null;
  _poolPromise = null;
}

module.exports = { lintWithPool, getPool, terminatePool, DEFAULT_WORKERS };
