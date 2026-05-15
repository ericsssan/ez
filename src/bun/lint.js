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
const { createFileLinter, createSyncLinter, applyFixes } = require("../../js/api.js");
const fs = require("node:fs");

// ESLint applies up to 10 fix passes by default; we follow that convention.
// Each pass re-lints the previous pass's output and applies any newly-
// resolvable fixes (some rules' fixes expose new violations that another
// rule can fix on the next pass; some single rules emit independent fixes
// at conflicting ranges that resolve over multiple passes).
const MAX_FIX_PASSES = 10;
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
  const args = { files: [], recommended: false, quiet: false, timing: false, workers: null, fix: false, fixDryRun: false, configPath: null, noConfigLookup: false };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--recommended") args.recommended = true;
    else if (a === "--quiet" || a === "-q") args.quiet = true;
    else if (a === "--timing") args.timing = true;
    else if (a === "--fix") args.fix = true;
    else if (a === "--fix-dry-run") args.fixDryRun = true;
    else if (a === "--no-config-lookup") args.noConfigLookup = true;
    else if (a === "--config" || a === "-c") {
      const v = argv[++i];
      if (!v) { process.stderr.write(`ezlint: --config requires a path\n`); process.exit(2); }
      args.configPath = v;
    } else if (a.startsWith("--config=")) {
      args.configPath = a.slice("--config=".length);
    } else if (a.startsWith("--workers=")) {
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
  if (args.fix && args.fixDryRun) {
    process.stderr.write("ezlint: --fix and --fix-dry-run are mutually exclusive\n");
    process.exit(2);
  }
  if (args.recommended && args.configPath) {
    process.stderr.write("ezlint: --recommended and --config are mutually exclusive\n");
    process.exit(2);
  }
  return args;
}

function printHelp() {
  process.stdout.write(
    "usage: ezlint [flags] <file> [<file>...]\n\n" +
    "config (one of these required):\n" +
    "  --recommended         use bundled eslint:recommended preset (64 rules)\n" +
    "  --config <path>, -c   load explicit eslint flat-config file\n" +
    "  (auto-discover)       walk up from cwd looking for eslint.config.{js,mjs,cjs}\n" +
    "  --no-config-lookup    don't auto-discover; combine with --recommended for defaults\n\n" +
    "flags:\n" +
    "  --fix                 apply autofix to fixable diagnostics; write changes to disk\n" +
    "  --fix-dry-run         print what --fix would change without writing\n" +
    "  --workers=N           worker count for multi-file (default min(files, hardware), 0 = inline)\n" +
    "  --quiet, -q           suppress per-diagnostic output, print summary only\n" +
    "  --timing              emit startup/lint ms breakdown on stderr\n" +
    "  --help, -h            show this help\n",
  );
}

// ── Flat-config discovery ───────────────────────────────────────
//
// Walk up from cwd looking for eslint.config.{js,mjs,cjs} (matching
// ESLint's auto-discovery semantics).  Returns the absolute path to the
// nearest config file, or null if none found.  Stops at the filesystem
// root or when a directory containing a `package.json` is found and
// still has no config (so we don't accidentally cross monorepo
// boundaries upward — same heuristic as ESLint v9).
function findFlatConfig(startDir) {
  const path = require("node:path");
  const { existsSync } = fs;
  const NAMES = ["eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"];
  let dir = path.resolve(startDir);
  while (true) {
    for (const n of NAMES) {
      const p = path.join(dir, n);
      if (existsSync(p)) return p;
    }
    // Stop at a package boundary OR filesystem root.
    if (existsSync(path.join(dir, "package.json"))) return null;
    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

// Load a flat config file.  Both ESM (.js/.mjs) and CJS (.cjs) supported.
// Returns the array-shaped config (or single-object wrapped in an array).
async function loadConfigFile(absPath) {
  if (absPath.endsWith(".cjs")) {
    const mod = require(absPath);
    return Array.isArray(mod) ? mod : [mod];
  }
  // .js / .mjs — use dynamic import so ESM exports work.
  const mod = await import("file://" + absPath);
  const def = mod.default || mod;
  return Array.isArray(def) ? def : [def];
}

// Extract the merged `rules` object from a flat-config array.  Later
// entries override earlier ones.  Plugins are not loaded at this stage;
// rule names are kept verbatim and resolved against CORE_PLUGINS later.
function extractRulesFromConfig(configArray) {
  const merged = {};
  for (const entry of configArray) {
    if (!entry || typeof entry !== "object") continue;
    if (entry.rules && typeof entry.rules === "object") {
      Object.assign(merged, entry.rules);
    }
  }
  return merged;
}

// ── Diag formatter (compact text) ───────────────────────────────

function formatDiag(file, d) {
  const sev = d.severity === 2 ? "error" : "warning";
  const rule = d.ruleId ? ` (${d.ruleId})` : "";
  return `${file}:${d.line}:${d.column}: ${sev}: ${d.message}${rule}`;
}

// ── Autofix application ─────────────────────────────────────────
//
// Given a source string and its diagnostics, extract `fix` payloads and
// apply them.  Returns { fixedSource, applied, skipped } where:
//   * fixedSource — string with non-overlapping fixes applied, or null
//     when nothing changed.
//   * applied     — diagnostics whose fix was applied this pass.
//   * skipped     — diagnostics with a fix that overlapped an earlier
//     one (resolved on a later pass by applyFixIterative).
function applyFixesToSource(source, diags) {
  const withFix = diags.filter(d => d.fix);
  if (withFix.length === 0) return { fixedSource: null, applied: [], skipped: [] };
  const fixes = withFix.flatMap(d => Array.isArray(d.fix) ? d.fix : [d.fix]);
  const fixed = applyFixes(source, fixes);
  if (fixed === source) return { fixedSource: null, applied: [], skipped: [] };
  // Replay the same start-sorted skip-on-overlap pass so we can attribute
  // applied vs skipped per diagnostic.  Used for the dry-run summary and
  // to detect convergence in the iterative fix loop.
  const sorted = withFix.slice().sort((a, b) => {
    const fa = Array.isArray(a.fix) ? a.fix[0] : a.fix;
    const fb = Array.isArray(b.fix) ? b.fix[0] : b.fix;
    return fa.range[0] - fb.range[0];
  });
  const applied = [], skipped = [];
  let cursor = 0;
  for (const d of sorted) {
    const f = Array.isArray(d.fix) ? d.fix[0] : d.fix;
    if (f.range[0] < cursor) skipped.push(d);
    else { applied.push(d); cursor = f.range[1]; }
  }
  return { fixedSource: fixed, applied, skipped };
}

// Iterative fix loop — apply, re-lint, apply, re-lint, until no more
// fixes apply OR MAX_FIX_PASSES is reached.  Mirrors ESLint's behaviour
// (default 10 passes) so two adjacent overlapping fixes resolve, and so
// rules whose fix exposes a new violation get a chance to fix that too.
//
// `lintText` is the synchronous in-memory lint function (from
// createSyncLinter().lintText).  Returns { fixedSource, finalDiags,
// totalApplied, passes }.  fixedSource is null when nothing changed.
function applyFixIterative(initialSource, initialDiags, file, lintText) {
  let source = initialSource;
  let diags = initialDiags;
  let totalApplied = 0;
  let passes = 0;
  let anyChange = false;

  while (passes < MAX_FIX_PASSES) {
    const { fixedSource, applied } = applyFixesToSource(source, diags);
    if (fixedSource === null) break;
    source = fixedSource;
    totalApplied += applied.length;
    passes++;
    anyChange = true;
    // Re-lint the new source.  Done in-process / single-thread — the loop
    // is inherently serial (each pass depends on the previous) so worker
    // parallelism doesn't help.
    diags = lintText(source, file);
  }
  return {
    fixedSource: anyChange ? source : null,
    finalDiags: diags,
    totalApplied,
    passes,
  };
}

// ── Per-file fix-or-print orchestrator ──────────────────────────
//
// Given one file's initial diagnostics, either run the iterative fix
// loop (apply → re-lint → apply, up to MAX_FIX_PASSES) when --fix /
// --fix-dry-run is set, OR just print diagnostics in the normal path.
// Returns { totalDiagsPrinted, errorsPrinted, fixedThisFile, fixPasses }.
//
// `lintText` (only used in fix mode) is a sync linter from
// createSyncLinter; main passes it in once after pool init.
function processFileResult(file, diags, args, sink, lintText) {
  let totalDiagsPrinted = 0;
  let errorsPrinted = 0;
  let fixedThisFile = false;
  let fixPasses = 0;

  if (args.fix || args.fixDryRun) {
    const initialSource = fs.readFileSync(file, "utf8");
    const { fixedSource, finalDiags, totalApplied, passes } =
      applyFixIterative(initialSource, diags, file, lintText);
    fixPasses = passes;
    if (fixedSource !== null) {
      if (args.fix) {
        fs.writeFileSync(file, fixedSource);
        fixedThisFile = true;
      } else {
        process.stderr.write(`ezlint: ${file}: would fix ${totalApplied} diag(s) over ${passes} pass(es)\n`);
      }
    }
    // Print the diags that survive after fix convergence.  These are the
    // "leftover" violations the user still needs to act on.
    totalDiagsPrinted = finalDiags.length;
    for (const d of finalDiags) if (d.severity === 2) errorsPrinted++;
    if (!args.quiet) for (const d of finalDiags) sink(formatDiag(file, d));
  } else {
    totalDiagsPrinted = diags.length;
    for (const d of diags) if (d.severity === 2) errorsPrinted++;
    if (!args.quiet) for (const d of diags) sink(formatDiag(file, d));
  }
  return { totalDiagsPrinted, errorsPrinted, fixedThisFile, fixPasses };
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
  // rulesConfigPerWorker — array of length nWorkers (one rules config per
  // worker), or a single rules config which gets sent to every worker.
  //
  // Per-worker configs enable rule-parallelism (split the rule set across
  // workers so each worker runs a subset on the same file).  Single config
  // enables file-parallelism (every worker can lint any file with the
  // full rule set).  Both modes are safe now that the NAPI binding's
  // config cache is thread-local (src/cli/napi.zig:tl_config_cache_*).
  constructor(nWorkers, rulesConfigPerWorker) {
    this.workers = [];
    const workerUrl = new URL("./lint-worker.js", import.meta.url);
    const perWorker = Array.isArray(rulesConfigPerWorker)
      ? rulesConfigPerWorker
      : new Array(nWorkers).fill(rulesConfigPerWorker);
    for (let i = 0; i < nWorkers; i++) {
      const w = new Worker(workerUrl);
      const slot = { id: i, worker: w, ready: false, busy: false, mode: "queue" };
      w.onmessage = (e) => this._onMessage(slot, e);
      w.postMessage({ type: "init", rules: perWorker[i] });
      this.workers.push(slot);
    }
    this._queue = [];
    this._results = []; // { seq, file, diagnostics, error? }
    this._next = 0;     // monotonic seq for stable ordering
    this._inflight = 0;
    this._resolve = null;
    // Rule-parallel state — set by runRuleParallel.
    this._rpFile = null;
    this._rpResults = null;
    this._rpResolve = null;
    this._rpRemaining = 0;
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

  _kickRuleParallel(slot) {
    if (slot.busy) return;
    slot.busy = true;
    slot.worker.postMessage({ type: "lint", file: this._rpFile, seq: slot.id });
  }

  _onMessage(slot, event) {
    const msg = event.data;
    if (msg.type === "ready") {
      slot.ready = true;
      if (slot.mode === "rule-parallel") this._kickRuleParallel(slot);
      else this._dispatch();
    } else if (msg.type === "result") {
      slot.busy = false;
      if (slot.mode === "rule-parallel") {
        this._rpResults.push(msg);
        this._rpRemaining--;
        if (this._rpRemaining === 0 && this._rpResolve) {
          const r = this._rpResolve;
          this._rpResolve = null;
          r(this._rpResults);
        }
      } else {
        this._inflight--;
        this._results.push(msg);
        this._dispatch();
        if (this._inflight === 0 && this._queue.length === 0 && this._resolve) {
          this._resolve();
        }
      }
    }
  }

  async run(files) {
    this._queue = [...files];
    if (this._queue.length === 0) return [];
    return new Promise((resolve) => {
      this._resolve = resolve;
      this._dispatch();
    }).then(() => this._results);
  }

  // Rule-parallel: send the same file to every worker; each worker's
  // pre-configured rule subset (set in the constructor) determines what
  // fires.  Returns the per-worker partial diagnostic arrays so the
  // caller can merge them.  Each worker re-parses the file via NAPI
  // (~200ms × N parallel = ~200ms wall) — overhead is far less than the
  // JS-rules walk savings.
  async runRuleParallel(file) {
    this._rpFile = file;
    this._rpResults = [];
    this._rpRemaining = this.workers.length;
    for (const slot of this.workers) slot.mode = "rule-parallel";
    return new Promise((resolve) => {
      this._rpResolve = resolve;
      // Workers that already reported "ready" before this method was
      // called (i.e. mode flip happened too late for the constructor's
      // postMessage round-trip) are kicked here; still-warming workers
      // are kicked from _onMessage on their "ready" event.
      for (const slot of this.workers) {
        if (slot.ready && !slot.busy) this._kickRuleParallel(slot);
      }
    });
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

  // Resolve the rules set.  Precedence:
  //   --recommended         → bundled 64-rule recommended preset
  //   --config <path>       → load that flat-config file
  //   auto-discover         → walk up from cwd for eslint.config.{js,mjs,cjs}
  //                          (skipped when --no-config-lookup)
  //   nothing               → error (must explicitly pick a config source)
  let rules;
  let configSource = null;
  if (args.recommended) {
    rules = Object.fromEntries(ESLINT_RECOMMENDED.map(r => [r, "error"]));
    configSource = "--recommended";
  } else {
    let cfgPath = args.configPath ? require("node:path").resolve(args.configPath) : null;
    if (!cfgPath && !args.noConfigLookup) cfgPath = findFlatConfig(process.cwd());
    if (!cfgPath) {
      process.stderr.write(
        "ezlint: no config found.  Use --recommended for the bundled preset, " +
        "or place an eslint.config.js in this directory (or an ancestor).\n"
      );
      process.exit(2);
    }
    let cfgArr;
    try {
      cfgArr = await loadConfigFile(cfgPath);
    } catch (e) {
      process.stderr.write(`ezlint: failed to load config ${cfgPath}: ${e.message}\n`);
      process.exit(2);
    }
    const flatRules = extractRulesFromConfig(cfgArr);
    if (Object.keys(flatRules).length === 0) {
      process.stderr.write(`ezlint: ${cfgPath} has no \`rules\` field — nothing to lint\n`);
      process.exit(2);
    }
    // Filter against bundled rules.  Unknown rule names get a one-line
    // warning so the user knows they're inert (binary ships only the
    // 64 recommended rules; non-recommended ones aren't statically
    // imported and bun build --compile can't load them dynamically).
    const known = new Set(CORE_PLUGINS.map(p => p.meta?.name).filter(Boolean));
    rules = {};
    const unknown = [];
    for (const [name, severity] of Object.entries(flatRules)) {
      if (!known.has(name)) { unknown.push(name); continue; }
      rules[name] = severity;
    }
    if (unknown.length > 0) {
      process.stderr.write(
        `ezlint: ${unknown.length} rule(s) in config not bundled in this binary, ignored: ${unknown.slice(0, 5).join(", ")}${unknown.length > 5 ? ", ..." : ""}\n`
      );
    }
    if (Object.keys(rules).length === 0) {
      process.stderr.write(`ezlint: ${cfgPath} enables no rules this binary supports\n`);
      process.exit(2);
    }
    configSource = cfgPath;
  }

  let totalDiags = 0;
  let totalErrors = 0;
  let totalFixedFiles = 0;
  let totalFixPasses = 0;
  // The fix loop is inherently serial — each pass re-lints the prior
  // pass's output.  Worker pool can't help; we use a single in-process
  // synchronous linter only when --fix or --fix-dry-run is set.
  let lintTextSync = null;
  if (args.fix || args.fixDryRun) {
    const { lintText } = await createSyncLinter({ rules, corePlugins: CORE_PLUGINS });
    lintTextSync = lintText;
  }

  // --workers=0 forces inline (no workers at all) — useful for profiling.
  const forceInline = args.workers === 0;
  const hwc = (typeof navigator !== "undefined" && navigator.hardwareConcurrency) || 4;

  if (forceInline) {
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
      const r = processFileResult(file, diags, args, line => process.stdout.write(line + "\n"), lintTextSync);
      totalDiags += r.totalDiagsPrinted;
      totalErrors += r.errorsPrinted;
      if (r.fixedThisFile) totalFixedFiles++;
    }
    const tDone = performance.now();
    if (args.timing) {
      process.stderr.write(
        `\nezlint: ${args.files.length} file(s), ${totalDiags} diags ` +
        `[inline] (startup ${(tReady - tStart).toFixed(0)}ms, lint ${(tDone - tReady).toFixed(0)}ms, ` +
        `total ${(tDone - tStart).toFixed(0)}ms)${args.fix ? `, fixed ${totalFixedFiles} file(s)` : ""}\n`,
      );
    } else if (args.quiet) {
      process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across ${args.files.length} file(s)${args.fix ? `, fixed ${totalFixedFiles} file(s)` : ""}\n`);
    } else if (args.fix && totalFixedFiles > 0) {
      process.stderr.write(`ezlint: fixed ${totalFixedFiles} file(s)\n`);
    }
    process.exit(totalErrors > 0 ? 1 : 0);
  }

  // Single-file: rule-parallel.  Same file goes to every worker, each
  // pre-configured with a disjoint rule subset.  Closes the ~30% gap vs
  // the old Zig-host ezlint which split rules across 2 worker processes.
  if (args.files.length === 1) {
    // Adaptive worker count for single-file rule-parallel mode.
    //
    // Per-worker cost has two components: a fixed warm-up (~485ms init +
    // ~50ms parse + ~10ms postMessage) and a variable JS-rule walk that
    // scales with file size and rule subset.  For tiny files the fixed
    // cost dominates and inline beats any pool; for big files the JS walk
    // dominates and parallelism wins linearly until each worker's per-call
    // parse cost catches up.
    //
    // Empirically on bench/fixtures/typescript.js (8.7MB):
    //                          bun run    dist/ezlint (compiled)
    //   inline:                1675ms     1675ms
    //   rule-parallel n=2:     1395ms     1613ms
    //   rule-parallel n=4:     1323ms     1597ms
    //   rule-parallel n=6:     ~1200ms    1398ms  ← sweet spot for compiled
    //   rule-parallel n=8:     1161ms     1642ms  (compiled regresses here)
    //
    // Compiled binary peaks at n=6 — past that, worker spawn overhead and
    // bytecode-JIT contention overwhelm the parallelism gain.  bun run
    // peaks at n=8 (faster spawn).  We cap at 6 to optimize for the
    // production target (compiled binary).
    //
    // Thresholds keep the worst case (small files paying spawn cost they
    // don't recoup) bounded.  Override with --workers=N or --workers=0 (inline).
    let nWorkers;
    if (args.workers != null) {
      nWorkers = Math.max(1, args.workers);
    } else {
      let bytes;
      try { bytes = require("node:fs").statSync(args.files[0]).size; }
      catch (_) { bytes = 1 << 20; } // assume 1MB if stat fails
      if (bytes < 50 * 1024) nWorkers = 1;          // <50KB: inline
      else if (bytes < 256 * 1024) nWorkers = 2;     // <256KB: 2 workers
      else if (bytes < 1024 * 1024) nWorkers = Math.min(4, hwc); // <1MB: 4
      else nWorkers = Math.min(6, hwc);              // bigger: up to 6
    }
    const file = args.files[0];
    if (nWorkers === 1) {
      // One worker has no parallelism — direct inline is faster (no spawn).
      const lintFile = await createFileLinter({ rules, corePlugins: CORE_PLUGINS });
      const tReady = performance.now();
      let diags;
      try { diags = lintFile(file); }
      catch (e) { process.stderr.write(`ezlint: ${file}: ${e.message}\n`); process.exit(1); }
      const r = processFileResult(file, diags, args, line => process.stdout.write(line + "\n"), lintTextSync);
      totalDiags = r.totalDiagsPrinted;
      totalErrors = r.errorsPrinted;
      if (r.fixedThisFile) totalFixedFiles = 1;
      const tDone = performance.now();
      if (args.timing) {
        process.stderr.write(
          `\nezlint: 1 file(s), ${totalDiags} diags [inline] ` +
          `(startup ${(tReady - tStart).toFixed(0)}ms, lint ${(tDone - tReady).toFixed(0)}ms, ` +
          `total ${(tDone - tStart).toFixed(0)}ms)${args.fix && totalFixedFiles ? ", fixed" : ""}\n`,
        );
      }
      process.exit(totalErrors > 0 ? 1 : 0);
    }
    // Round-robin partition keeps each chunk's mix of cheap+expensive and
    // native+JS rules roughly balanced.  Names are disjoint across
    // partitions so each rule fires in exactly one worker (no double-emit).
    const partitions = Array.from({ length: nWorkers }, () => ({}));
    const ruleNames = Object.keys(rules);
    for (let i = 0; i < ruleNames.length; i++) {
      partitions[i % nWorkers][ruleNames[i]] = rules[ruleNames[i]];
    }
    const pool = new WorkerPool(nWorkers, partitions);
    const tDispatch = performance.now();
    const partials = await pool.runRuleParallel(file);
    const tDone = performance.now();
    pool.shutdown();
    const allDiags = [];
    let workerErr = null;
    for (const r of partials) {
      if (r.error) { workerErr = r.error; continue; }
      for (const d of r.diagnostics) allDiags.push(d);
    }
    if (workerErr) {
      process.stderr.write(`ezlint: ${file}: ${workerErr}\n`);
      process.exit(1);
    }
    allDiags.sort((a, b) => (a.line - b.line) || (a.column - b.column));
    const ruleParallelResult = processFileResult(file, allDiags, args, line => process.stdout.write(line + "\n"), lintTextSync);
    totalDiags = ruleParallelResult.totalDiagsPrinted;
    totalErrors = ruleParallelResult.errorsPrinted;
    if (ruleParallelResult.fixedThisFile) totalFixedFiles = 1;
    if (args.timing) {
      process.stderr.write(
        `\nezlint: 1 file(s), ${totalDiags} diags ` +
        `[rule-parallel n=${nWorkers}] (dispatch ${(tDispatch - tStart).toFixed(0)}ms, ` +
        `lint ${(tDone - tDispatch).toFixed(0)}ms, total ${(tDone - tStart).toFixed(0)}ms)${args.fix && totalFixedFiles ? ", fixed" : ""}\n`,
      );
    } else if (args.quiet) {
      process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across 1 file(s)${args.fix && totalFixedFiles ? `, fixed ${totalFixedFiles}` : ""}\n`);
    }
    process.exit(totalErrors > 0 ? 1 : 0);
  }

  // Multi-file: file-parallel.  Each worker has the full rules config and
  // pulls whole files from a queue.  Workers stay warm across files.
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
    const pr = processFileResult(r.file, r.diagnostics, args, line => process.stdout.write(line + "\n"), lintTextSync);
    totalDiags += pr.totalDiagsPrinted;
    totalErrors += pr.errorsPrinted;
    if (pr.fixedThisFile) totalFixedFiles++;
  }

  if (args.timing) {
    process.stderr.write(
      `\nezlint: ${args.files.length} file(s), ${totalDiags} diags ` +
      `[pool n=${nWorkers}] (dispatch ${(tDispatch - tStart).toFixed(0)}ms, lint ${(tDone - tDispatch).toFixed(0)}ms, ` +
      `total ${(tDone - tStart).toFixed(0)}ms)${args.fix ? `, fixed ${totalFixedFiles} file(s)` : ""}\n`,
    );
  } else if (args.quiet) {
    process.stderr.write(`ezlint: ${totalDiags} diagnostic(s) across ${args.files.length} file(s)${args.fix ? `, fixed ${totalFixedFiles} file(s)` : ""}\n`);
  } else if (args.fix && totalFixedFiles > 0) {
    process.stderr.write(`ezlint: fixed ${totalFixedFiles} file(s)\n`);
  }

  process.exit(totalErrors > 0 ? 1 : 0);
})().catch(e => {
  process.stderr.write(`ezlint: ${e.stack || e.message}\n`);
  process.exit(1);
});
