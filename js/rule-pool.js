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

  // Wait until every worker has signalled `ready` (post-init). Errors
  // during init reject the init promise — otherwise a silent worker
  // crash on bundle load would leave callers awaiting a `ready` that
  // never arrives.
  const initPromises = [];
  for (let i = 0; i < nWorkers; i++) {
    const w = new Worker(WORKER_PATH);
    initPromises.push(new Promise((resolve, reject) => {
      let initialised = false;
      w.addEventListener("message", ({ data }) => {
        if (data.type === "ready" && !initialised) {
          initialised = true;
          resolve();
          return;
        }
        if (data.type !== "result") return;
        const cb = pending.get(data.reqId);
        if (!cb) return;
        pending.delete(data.reqId);
        cb.resolve({ compact: data.compact, crashMsg: data.crashMsg, ms: data.ms });
      });
      w.addEventListener("error", (e) => {
        const msg = `Worker error: ${String(e?.message ?? e)}`;
        if (!initialised) { reject(new Error(`init failed — ${msg}`)); return; }
        // Errored after init: surface to in-flight requests on this
        // worker (best-effort attribution).
        for (const [id, cb] of pending) {
          cb.reject(new Error(msg));
          pending.delete(id);
        }
      });
      // Belt + suspenders: timeout the init so a wedged worker doesn't
      // hang lintWithPool callers forever. 30s is generous (cold bundle
      // import is ~310 ms with the JSC bytecode cache, ~440 ms without).
      const t = setTimeout(() => {
        if (!initialised) {
          initialised = true; // prevent double-reject from a late "ready"
          reject(new Error(`Worker init timeout (${WORKER_PATH})`));
        }
      }, 30_000);
      // Don't anchor the event loop on the timeout itself.
      if (typeof t.unref === "function") t.unref();
      w.postMessage({ type: "init" });
    }));
    workers.push(w);
  }

  return Promise.all(initPromises).then(() => ({
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
      // Watchdog: if a worker never replies (uncaught throw, abnormal
      // exit) within REQ_TIMEOUT_MS, reject so the caller surfaces
      // failure rather than hanging the process. 60 s is generous —
      // typescript.js takes ~2.5 s parallel; anything past 10 s means
      // the worker is wedged.
      const timer = setTimeout(() => {
        const cb = pool.pending.get(reqId);
        if (!cb) return;
        pool.pending.delete(reqId);
        cb.reject(new Error(`rule-pool: worker request ${reqId} timed out after 60 s`));
      }, 60_000);
      if (typeof timer.unref === "function") timer.unref();
      pool.register(reqId,
        (val) => { clearTimeout(timer); resolve(val); },
        (err) => { clearTimeout(timer); reject(err); },
      );
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
