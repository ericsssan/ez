#!/usr/bin/env bun
// ezlint — single-process Bun CLI.
//
// One Bun process is the entry point.  Loads the Zig parser via NAPI
// (ez.node), runs native rules at parse time, runs JS-only ESLint rules
// in-process (single file) or fanned out to Bun.Worker threads (multi-file).
//
// Architecture:
//   1 file:    inline lint — no worker spawn cost
//   N files:   M Bun.Worker threads (default = min(N, navigator.hardwareConcurrency))
//              each warm with rule modules; pull files from a shared queue
//
// No subprocesses, no IPC frames, no AST publish to /tmp.
//
// Usage:    bun run src/bun/lint.js [flags] <file> [<file>...]
// Compile:  bun build --compile --packages=bundle ./src/bun/lint.js \
//             --outfile dist/ezlint

"use strict";

const tStart = performance.now();

// Static relative require (NOT path.resolve(__dirname, ...)) so `bun build
// --compile` can follow the dependency graph and inline everything into the
// standalone binary.  Dynamic requires would leave api.js + its transitive
// closure (rules.bundle.js, eslint-visitor-keys, etc.) outside the bundle.
const { createFileLinter } = require("../../js/api.js");
// Static, pre-required rule descriptors — replaces api.js's loadCoreRules
// for the standalone binary so `bun build --compile` can follow the
// dependency graph.  See src/bun/recommended-rules.js for the rationale.
const { DESCRIPTORS: CORE_PLUGINS } = require("./recommended-rules.js");

// ESLint v9 :recommended rule set — single source of truth on the JS side.
const ESLINT_RECOMMENDED = [
  "constructor-super", "for-direction", "getter-return", "no-async-promise-executor",
  "no-case-declarations", "no-class-assign", "no-compare-neg-zero", "no-cond-assign",
  "no-const-assign", "no-constant-binary-expression", "no-constant-condition",
  "no-control-regex", "no-debugger", "no-delete-var", "no-dupe-args",
  "no-dupe-class-members", "no-dupe-else-if", "no-dupe-keys", "no-duplicate-case",
  "no-empty", "no-empty-character-class", "no-empty-pattern", "no-empty-static-block",
  "no-ex-assign", "no-extra-boolean-cast", "no-fallthrough", "no-func-assign",
  "no-global-assign", "no-import-assign", "no-invalid-regexp", "no-irregular-whitespace",
  "no-loss-of-precision", "no-misleading-character-class", "no-new-native-nonconstructor",
  "no-nonoctal-decimal-escape", "no-obj-calls", "no-octal", "no-prototype-builtins",
  "no-redeclare", "no-regex-spaces", "no-self-assign", "no-setter-return",
  "no-shadow-restricted-names", "no-sparse-arrays", "no-this-before-super",
  "no-unassigned-vars", "no-undef", "no-unexpected-multiline", "no-unreachable",
  "no-unsafe-finally", "no-unsafe-negation", "no-unsafe-optional-chaining",
  "no-unused-labels", "no-unused-private-class-members", "no-unused-vars",
  "no-useless-assignment", "no-useless-backreference", "no-useless-catch",
  "no-useless-escape", "no-with", "preserve-caught-error", "require-yield",
  "use-isnan", "valid-typeof",
];

// ── CLI parse ───────────────────────────────────────────────────

function parseArgs(argv) {
  const args = { files: [], recommended: false, quiet: false, timing: false, workers: null };
  for (const a of argv) {
    if (a === "--recommended") args.recommended = true;
    else if (a === "--quiet" || a === "-q") args.quiet = true;
    else if (a === "--timing") args.timing = true;
    else if (a.startsWith("--workers=")) {
      const n = parseInt(a.slice("--workers=".length), 10);
      if (!Number.isFinite(n) || n < 0) { process.stderr.write(`ezlint: invalid --workers value\n`); process.exit(2); }
      args.workers = n;
    } else if (a === "--help" || a === "-h") {
      printHelp();
      process.exit(0);
    } else if (a.startsWith("--")) {
      process.stderr.write(`ezlint: unknown flag '${a}'\n`);
      process.exit(2);
    } else {
      args.files.push(a);
    }
  }
  return args;
}

function printHelp() {
  process.stdout.write(
    "usage: ezlint [flags] <file> [<file>...]\n\n" +
    "flags:\n" +
    "  --recommended    use eslint:recommended preset (64 rules)\n" +
    "  --workers=N      worker count for multi-file (default min(files, hardware), 0 = inline single-thread)\n" +
    "  --quiet, -q      suppress per-diagnostic output, print summary only\n" +
    "  --timing         emit startup/lint ms breakdown on stderr\n" +
    "  --help, -h       show this help\n",
  );
}

// ── Diag formatter (compact text) ───────────────────────────────

function formatDiag(file, d) {
  const sev = d.severity === 2 ? "error" : "warning";
  const rule = d.ruleId ? ` (${d.ruleId})` : "";
  return `${file}:${d.line}:${d.column}: ${sev}: ${d.message}${rule}`;
}

// ── Worker pool ─────────────────────────────────────────────────
//
// Spawn M Bun.Workers, init each with the same rules config (kicks off
// per-worker module load + JIT warm-up in parallel with file enumeration
// and the first parse).  Distribute files via a queue: a worker that
// finishes one file is immediately handed the next from the head of the
// queue ("work-stealing" without the heap overhead — we just hand work
// to whoever asks).
//
// Workers stay warm across files; the ~485ms per-worker rule-load cost
// is paid once and amortised across the entire file set.

class WorkerPool {
  constructor(nWorkers, rulesConfig) {
    this.workers = [];
    // Bun.Worker accepts a path or URL; the URL form survives bun build
    // --compile bundling because the bundler statically resolves it.
    const workerUrl = new URL("./lint-worker.js", import.meta.url);
    for (let i = 0; i < nWorkers; i++) {
      const w = new Worker(workerUrl);
      const slot = { id: i, worker: w, ready: false, busy: false };
      w.onmessage = (e) => this._onMessage(slot, e);
      w.postMessage({ type: "init", rules: rulesConfig });
      this.workers.push(slot);
    }
    this._queue = [];
    this._results = []; // { seq, file, diagnostics, error? }
    this._next = 0;     // monotonic seq for stable ordering
    this._inflight = 0;
    this._resolve = null;
  }

  _dispatch() {
    for (const slot of this.workers) {
      if (slot.busy || !slot.ready) continue;
      if (this._queue.length === 0) break;
      const file = this._queue.shift();
      const seq = this._next++;
      slot.busy = true;
      this._inflight++;
      slot.worker.postMessage({ type: "lint", file, seq });
    }
  }

  _onMessage(slot, event) {
    const msg = event.data;
    if (msg.type === "ready") {
      slot.ready = true;
      this._dispatch();
    } else if (msg.type === "result") {
      slot.busy = false;
      this._inflight--;
      this._results.push(msg);
      this._dispatch();
      if (this._inflight === 0 && this._queue.length === 0 && this._resolve) {
        this._resolve();
      }
    }
  }

  async run(files) {
    this._queue = [...files];
    if (this._queue.length === 0) return [];
    // Wait for at least one worker to be ready before returning the awaited
    // promise — _dispatch is a no-op until then; this is harmless because
    // the "ready" message handler retries dispatch.
    return new Promise((resolve) => {
      this._resolve = resolve;
      this._dispatch();
    }).then(() => this._results);
  }

  shutdown() {
    for (const slot of this.workers) {
      slot.worker.postMessage({ type: "shutdown" });
      slot.worker.terminate();
    }
  }
}

// ── Main ────────────────────────────────────────────────────────

(async () => {
  const args = parseArgs(process.argv.slice(2));
  if (args.files.length === 0) {
    printHelp();
    process.exit(2);
  }

  if (!args.recommended) {
    process.stderr.write("ezlint: --recommended is currently required (config-file discovery TODO)\n");
    process.exit(2);
  }
  const rules = Object.fromEntries(ESLINT_RECOMMENDED.map(r => [r, "error"]));

  let totalDiags = 0;
  let totalErrors = 0;

  // Single-file fast path: skip the worker pool entirely.  The pool's spawn
  // + warm-up cost (~50ms × N + ~485ms first-init) exceeds the single-file
  // lint time for everything except the largest files, and dodges the
  // postMessage round-trip.
  // --workers=0 forces inline regardless of file count (useful for profiling).
  const wantInline = args.workers === 0 || args.files.length === 1;

  if (wantInline) {
    const lintFile = await createFileLinter({ rules, corePlugins: CORE_PLUGINS });
    const tReady = performance.now();
    for (const file of args.files) {
      let diags;
      try {
        diags = lintFile(file);
      } catch (e) {
        process.stderr.write(`ezlint: ${file}: ${e.message}\n`);
        totalErrors++;
        continue;
      }
      totalDiags += diags.length;
      for (const d of diags) if (d.severity === 2) totalErrors++;
      if (!args.quiet) {
        for (const d of diags) process.stdout.write(formatDiag(file, d) + "\n");
      }
    }
    const tDone = performance.now();
    if (args.timing) {
      process.stderr.write(
        `\nezlint: ${args.files.length} file(s), ${totalDiags} diags ` +
        `[inline] (startup ${(tReady - tStart).toFixed(0)}ms, lint ${(tDone - tReady).toFixed(0)}ms, ` +
        `total ${(tDone - tStart).toFixed(0)}ms)\n`,
      );
    } else if (args.quiet) {
      process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across ${args.files.length} file(s)\n`);
    }
    process.exit(totalErrors > 0 ? 1 : 0);
  }

  // Multi-file path.  Bun exposes navigator.hardwareConcurrency; clamp to
  // the file count so we don't spawn workers that have nothing to do.
  const hwc = (typeof navigator !== "undefined" && navigator.hardwareConcurrency) || 4;
  const nWorkers = Math.max(1, Math.min(args.workers ?? hwc, args.files.length));

  const pool = new WorkerPool(nWorkers, rules);
  const tDispatch = performance.now();
  const results = await pool.run(args.files);
  const tDone = performance.now();
  pool.shutdown();

  // Sort results by the original file order so output is deterministic
  // regardless of the order in which workers finish.
  const fileOrder = new Map(args.files.map((f, i) => [f, i]));
  results.sort((a, b) => (fileOrder.get(a.file) ?? 0) - (fileOrder.get(b.file) ?? 0));

  for (const r of results) {
    if (r.error) {
      process.stderr.write(`ezlint: ${r.file}: ${r.error}\n`);
      totalErrors++;
      continue;
    }
    totalDiags += r.diagnostics.length;
    for (const d of r.diagnostics) if (d.severity === 2) totalErrors++;
    if (!args.quiet) {
      for (const d of r.diagnostics) process.stdout.write(formatDiag(r.file, d) + "\n");
    }
  }

  if (args.timing) {
    process.stderr.write(
      `\nezlint: ${args.files.length} file(s), ${totalDiags} diags ` +
      `[pool n=${nWorkers}] (dispatch ${(tDispatch - tStart).toFixed(0)}ms, lint ${(tDone - tDispatch).toFixed(0)}ms, ` +
      `total ${(tDone - tStart).toFixed(0)}ms)\n`,
    );
  } else if (args.quiet) {
    process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across ${args.files.length} file(s)\n`);
  }

  process.exit(totalErrors > 0 ? 1 : 0);
})().catch(e => {
  process.stderr.write(`ezlint: ${e.stack || e.message}\n`);
  process.exit(1);
});
