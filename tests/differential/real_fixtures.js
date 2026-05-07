"use strict";
/**
 * Per-rule differential benchmark on real-world fixtures.
 *
 * For each (file, rule) pair, runs ez, ESLint, and oxlint with ONLY that
 * rule enabled and measures wall time + diagnostic count. Optional --diff
 * mode also compares diagnostic line numbers across engines.
 *
 * Goal: per-rule throughput and per-rule correctness vs. the two reference
 * implementations on representative production-size files.
 *
 * Usage:
 *   bun tests/differential/real_fixtures.js
 *   bun tests/differential/real_fixtures.js --rule no-unused-vars
 *   bun tests/differential/real_fixtures.js --file checker.ts --iters 5
 *   bun tests/differential/real_fixtures.js --rules no-unused-vars,no-undef --diff
 *   bun tests/differential/real_fixtures.js --all-rules     # every core rule (slow)
 *   bun tests/differential/real_fixtures.js --all-files     # every fixture (slow)
 */

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "../..");
const FIXTURES_DIR = path.join(ROOT, "bench/fixtures");

// When required as a module (perf_hunt.js etc.), skip the CLI and just
// expose the runner helpers.
const _isMain = require.main === module;
if (!_isMain) {
  module.exports = {
    get runEz() { return runEz; },
    get runEzOnAst() { return runEzOnAst; },
    get parseEzOnce() { return parseEzOnce; },
    get runEslint() { return runEslint; },
    get runOxlint() { return runOxlint; },
    get runOxlintBatch() { return runOxlintBatch; },
  };
}

// ── arg parsing ──────────────────────────────────────────────────────
const args = process.argv.slice(2);
const _flag = n => args.includes(n);
const _arg  = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };

const ITERS  = parseInt(_arg("--iters",  "3"), 10);
const WARMUP = parseInt(_arg("--warmup", "1"), 10);
const DIFF   = _flag("--diff");

const DEFAULT_FILES = [
  "react-hooks.js",
  "react-dom.js",
  "jquery.js",
  "lodash.js",
  "three.js",
];
const HEAVY_FILES = [
  "react-dom.development.js",
  "angular-classes.ts",
  "checker.ts",
  "typescript.js",
];

let files;
const fileArg = _arg("--file", null);
const filesArg = _arg("--files", null);
if (fileArg) files = [fileArg];
else if (filesArg) files = filesArg.split(",");
else if (_flag("--all-files")) files = [...DEFAULT_FILES, ...HEAVY_FILES];
else files = DEFAULT_FILES;
files = files.map(f => path.isAbsolute(f) ? f : path.join(FIXTURES_DIR, f));

// Curated default rule set: core, syntactic, no type info needed, distinct
// shapes (scope-tracking, AST-shape, regex, comments, control-flow).
const DEFAULT_RULES = [
  "no-unused-vars",
  "no-undef",
  "no-redeclare",
  "no-shadow",
  "no-unreachable",
  "no-cond-assign",
  "no-empty",
  "no-fallthrough",
  "no-extra-boolean-cast",
  "eqeqeq",
  "prefer-const",
  "no-var",
  "no-useless-return",
];

let rules;
const ruleArg = _arg("--rule", null);
const rulesArg = _arg("--rules", null);
if (ruleArg) rules = [ruleArg];
else if (rulesArg) rules = rulesArg.split(",");
else if (_flag("--all-rules")) {
  const { loadCoreRules } = require(path.join(ROOT, "js/load-plugin.js"));
  rules = loadCoreRules({ only: undefined, includeDeprecated: false })
    .map(r => r.meta?.name).filter(Boolean);
} else rules = DEFAULT_RULES;

// ── ez ───────────────────────────────────────────────────────────────
const { lintSource } = require(path.join(ROOT, "js/api.js"));

// Memoize config objects — `lintSource` re-resolves config (filesystem
// checks for eslint.config.js, core-rule reload) on every call, gated by
// a WeakMap on object identity. Passing the SAME object across iters lets
// the cache hit and isolates lint time from config setup. Without this
// the bench over-reports by ~18 ms / iter on typescript.js.
const _cfgMemo = new Map();
function _ezCfg(filename, ruleId) {
  const key = filename + "\0" + ruleId;
  let cfg = _cfgMemo.get(key);
  if (!cfg) {
    cfg = { filename, rules: { [ruleId]: "error" } };
    _cfgMemo.set(key, cfg);
  }
  return cfg;
}

async function runEz(src, ruleId, filename) {
  const cfg = _ezCfg(filename, ruleId);
  const t0 = performance.now();
  const diags = await lintSource(src, cfg);
  const ms = performance.now() - t0;
  return { ms, diags: diags.filter(d => d.ruleId === ruleId).map(d => d.line).sort((a, b) => a - b) };
}

// ── parse-reuse helpers (perf_hunt amortizes parse across rules) ────
//
// `parseEzOnce(src, filename)` parses the source ONCE and returns a context
// for reused per-rule lint runs.  `runEzOnAst(ctx, ruleId)` runs only the
// rule against the cached AST and times JUST the rule-checking work.
//
// Caveat: this trims away parse cost, so per-rule numbers are NOT
// directly comparable to `runEz()` numbers (which include parse).  Use the
// batched mode for cross-rule ranking on `--all-rules`; use `runEz()` when
// each rule's "cold-start" cost matters (e.g. editor invocation modeling).
const { parseSource, getNativeRules, buildNativeConfig, getTagNames, lintSourceNative } =
  require(path.join(ROOT, "js/index.js"));
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
const { loadCoreRules, loadPlugin } = require(path.join(ROOT, "js/load-plugin.js"));

const _coreRulesAll = loadCoreRules({ only: undefined });
const _coreRulesByName = new Map(_coreRulesAll.map(d => [d.meta?.name, d]).filter(([n]) => n));
const _nativeRules = getNativeRules();

function parseEzOnce(src, filename) {
  const ast = parseSource(src, { filename });
  return { src, filename, ast, tagNames: getTagNames() };
}

/**
 * Run ALL `ruleIds` against the cached AST in a SINGLE `runPlugins` call —
 * matches what real ez lint does in a real lint pass.  Returns total wall
 * time and the diagnostic-line lists per rule.  Use this to benchmark
 * "real" ez throughput vs oxlint's batched throughput.
 */
function runEzAllOnAst(ctx, ruleIds) {
  const descs = [];
  const nativeRules = {};
  for (const id of ruleIds) {
    const desc = _coreRulesByName.get(id);
    if (!desc) continue;
    if (_nativeRules.has(id)) {
      nativeRules[id] = _nativeRules.get(id).defaultSeverity;
    } else {
      descs.push(desc);
    }
  }
  const t0 = performance.now();
  let nativeDiags = [];
  if (Object.keys(nativeRules).length > 0) {
    const cfg = buildNativeConfig({ rules: nativeRules });
    nativeDiags = lintSourceNative(ctx.src, { filename: ctx.filename, config: cfg });
  }
  let reports = [];
  if (descs.length > 0) {
    reports = runPlugins(ctx.ast, descs, {
      tagNames: ctx.tagNames,
      filename: ctx.filename,
      ruleConfig: {},
    });
  }
  const ms = performance.now() - t0;
  return { ms, totalDiags: nativeDiags.length + reports.length };
}

if (!_isMain) module.exports.runEzAllOnAst = runEzAllOnAst;

function runEzOnAst(ctx, ruleId) {
  const desc = _coreRulesByName.get(ruleId);
  if (!desc) return { ms: 0, diags: [], skipped: "unknown-core-rule" };
  const isNative = _nativeRules.has(ruleId);
  const t0 = performance.now();
  let nativeDiags = [];
  let reports = [];
  if (isNative) {
    const info = _nativeRules.get(ruleId);
    const cfg = buildNativeConfig({ rules: { [ruleId]: info.defaultSeverity } });
    nativeDiags = lintSourceNative(ctx.src, { filename: ctx.filename, config: cfg });
  } else {
    reports = runPlugins(ctx.ast, [desc], {
      tagNames: ctx.tagNames,
      filename: ctx.filename,
      ruleConfig: {},
    });
  }
  const ms = performance.now() - t0;
  const lines = isNative
    ? nativeDiags.filter(d => d.rule_id === ruleId || d.ruleId === ruleId).map(d => d.line || d.startLine).sort((a, b) => a - b)
    : reports.filter(r => r.ruleId === ruleId).map(r => r.line).sort((a, b) => a - b);
  return { ms, diags: lines };
}

// ── ESLint ───────────────────────────────────────────────────────────
const { Linter } = require(path.join(ROOT, "js/node_modules/eslint"));
let _tsParser = null;
function tsParser() {
  if (_tsParser !== null) return _tsParser;
  try {
    _tsParser = require(path.join(ROOT, "js/node_modules/@typescript-eslint/parser"));
  } catch { _tsParser = null; }
  return _tsParser;
}

function runEslint(src, ruleId, filename) {
  const linter = new Linter();
  const isTs = /\.[mc]?tsx?$/.test(filename);
  const config = {
    rules: { [ruleId]: "error" },
    languageOptions: { ecmaVersion: 2022, sourceType: "module" },
  };
  if (isTs) {
    const tp = tsParser();
    if (!tp) return { ms: 0, diags: [], skipped: "no-ts-parser" };
    config.languageOptions.parser = tp;
  }
  const t0 = performance.now();
  let diags;
  try {
    diags = linter.verify(src, config, filename);
  } catch (e) {
    return { ms: performance.now() - t0, diags: [], error: e.message };
  }
  const ms = performance.now() - t0;
  return { ms, diags: diags.filter(d => d.ruleId === ruleId).map(d => d.line).sort((a, b) => a - b) };
}

// ── oxlint ───────────────────────────────────────────────────────────
const OXLINT_BIN = (() => { try { return Bun.which("oxlint") || "/opt/homebrew/bin/oxlint"; } catch { return "oxlint"; } })();

// Build the set of rule names oxlint actually knows so we don't waste a
// subprocess per unknown rule. `oxlint --rules` prints a markdown-formatted
// table; extract the first column.
let _oxlintRules = null;
function oxlintRules() {
  if (_oxlintRules !== null) return _oxlintRules;
  const set = new Set();
  try {
    const out = Buffer.from(Bun.spawnSync([OXLINT_BIN, "--rules"], { stdout: "pipe" }).stdout).toString();
    for (const line of out.split("\n")) {
      const m = line.match(/^\|\s*([@a-z][\w/-]+)\s*\|/i);
      if (m) set.add(m[1]);
    }
  } catch {}
  _oxlintRules = set;
  return set;
}

function runOxlint(filePath, ruleId, opts = {}) {
  if (!oxlintRules().has(ruleId)) return { ms: 0, diags: [], skipped: "unknown-rule" };
  // -A all silences everything, then -D <rule> turns just the target on.
  // For TIMING-ONLY runs (default), we use `--silent` and discard stdout —
  // otherwise oxlint spends most of its time serializing JSON for high-diag
  // rules (no-var on typescript.js is 11.7s with JSON output, 0.1s without).
  // Callers that need diagnostic content (`--diff` mode) pass `wantDiags:true`.
  const wantDiags = !!opts.wantDiags;
  const args = wantDiags
    ? [OXLINT_BIN, "-A", "all", "-D", ruleId, "--format", "json", filePath]
    : [OXLINT_BIN, "-A", "all", "-D", ruleId, "--silent", filePath];
  const t0 = performance.now();
  const proc = Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  const ms = performance.now() - t0;
  if (!wantDiags) return { ms, diags: [] }; // diag list intentionally empty
  const lines = [];
  try {
    const out = Buffer.from(proc.stdout).toString("utf8");
    // oxlint --format json emits one JSON object per diagnostic, separated by NDJSON
    // OR a wrapper depending on version. Handle both.
    const trimmed = out.trim();
    if (!trimmed) return { ms, diags: [] };
    if (trimmed.startsWith("{") && trimmed.includes("\"diagnostics\"")) {
      const data = JSON.parse(trimmed);
      // oxlint reports the rule as `eslint(no-unused-vars)` or `<plugin>(<rule>)`.
      // Match by the parenthesized rule name to avoid false positives from
      // category-named rules.
      const ruleMatch = `(${ruleId})`;
      for (const d of data.diagnostics || []) {
        const code = typeof d.code === "string" ? d.code : d.code?.value;
        if (code && (code === ruleId || code.endsWith(ruleMatch))) {
          lines.push(d.labels?.[0]?.span?.line ?? 0);
        }
      }
    } else {
      // NDJSON
      for (const ln of trimmed.split("\n")) {
        if (!ln.trim()) continue;
        try {
          const d = JSON.parse(ln);
          // Diagnostic shape: { ruleId, lineNumber, ... } or { code, labels: [{ span: { line } }] }
          if (d.lineNumber) lines.push(d.lineNumber);
          else if (d.labels?.[0]?.span?.line) lines.push(d.labels[0].span.line);
        } catch {}
      }
    }
  } catch {}
  return { ms, diags: lines.sort((a, b) => a - b) };
}

// ── oxlint batched ───────────────────────────────────────────────────
//
// Runs oxlint ONCE with multiple `-D` flags so all rules in `ruleIds` are
// enabled in a single subprocess.  Returns { totalMs, perRuleMs } where
// perRuleMs ≈ (totalMs - estimated_baseline) / known.length.
//
// Caveats:
//   - Per-rule numbers are amortized — useful for cross-rule ranking,
//     not for measuring absolute single-rule cost.
//   - Unknown-to-oxlint rules are filtered out; the divisor uses only the
//     rules oxlint actually ran.
//   - Caller should subtract `runOxlintBaseline(filePath)` to discount
//     subprocess startup + parse from `totalMs` for sharper per-rule
//     numbers.
function runOxlintBatch(filePath, ruleIds) {
  const known = ruleIds.filter(id => oxlintRules().has(id));
  if (known.length === 0) return { totalMs: 0, perRuleMs: 0, knownCount: 0 };
  const args = [OXLINT_BIN, "-A", "all"];
  for (const id of known) { args.push("-D"); args.push(id); }
  args.push("--silent", filePath);
  const t0 = performance.now();
  Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  const totalMs = performance.now() - t0;
  return { totalMs, perRuleMs: totalMs / known.length, knownCount: known.length };
}

// Baseline: oxlint with NO rules enabled — measures subprocess startup +
// parse cost so callers can subtract it from batch totals.
function runOxlintBaseline(filePath) {
  const args = [OXLINT_BIN, "-A", "all", "--silent", filePath];
  const t0 = performance.now();
  Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  return performance.now() - t0;
}

if (!_isMain) module.exports.runOxlintBaseline = runOxlintBaseline;

// ── stats ────────────────────────────────────────────────────────────
function median(arr) {
  if (!arr.length) return 0;
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}

function fmtMs(ms)     { return ms === 0 ? "    -" : ms.toFixed(1).padStart(7); }
function fmtMbs(ms, bytes) {
  if (ms === 0) return "    -";
  const mbs = bytes / 1024 / 1024 / (ms / 1000);
  return mbs.toFixed(0).padStart(5);
}
function fmtCount(n, skipped) { return skipped ? "    -" : String(n).padStart(5); }

function listAgreement(a, b) {
  // Set-of-lines comparison (allow duplicate lines collapsed)
  const sa = new Set(a), sb = new Set(b);
  if (sa.size !== sb.size) return false;
  for (const x of sa) if (!sb.has(x)) return false;
  return true;
}

// ── main ─────────────────────────────────────────────────────────────
if (!_isMain) return;
(async () => {
  console.log(`ez vs ESLint vs oxlint  —  per-rule benchmark on real fixtures`);
  console.log(`fixtures: ${files.length}  rules: ${rules.length}  iters: ${ITERS} (warmup ${WARMUP})`);
  console.log("");

  // Column widths
  const W = { rule: 28, ms: 7, mbs: 5, count: 5 };
  const dash = "─";
  // Header: "rule | ez ms | ez MBs | eslint ms | eslint MBs | oxlint ms | oxlint MBs | ez/es/ox | agree"
  const head =
    "rule".padEnd(W.rule) + " │ " +
    "ez ms".padStart(W.ms) + " " + "MB/s".padStart(W.mbs) + " │ " +
    "es ms".padStart(W.ms) + " " + "MB/s".padStart(W.mbs) + " │ " +
    "ox ms".padStart(W.ms) + " " + "MB/s".padStart(W.mbs) + " │ " +
    "ez".padStart(W.count) + " " + "es".padStart(W.count) + " " + "ox".padStart(W.count) + " │ " +
    "vs es  vs ox";
  const rule_w = W.rule + 3 + (W.ms + 1 + W.mbs + 3) * 3 + (W.count + 1) * 3 - 1 + 3 + 12;

  for (const filePath of files) {
    if (!fs.existsSync(filePath)) { console.log(`SKIP  missing: ${filePath}`); continue; }
    const src = fs.readFileSync(filePath, "utf8");
    const bytes = Buffer.byteLength(src, "utf8");
    const filename = path.basename(filePath);
    console.log(`\n${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
    console.log(dash.repeat(rule_w));
    console.log(head);
    console.log(dash.repeat(rule_w));

    for (const ruleId of rules) {
      const ezTimes = [], esTimes = [], oxTimes = [];
      let ezDiags = [], esDiags = [], oxDiags = [];
      let esSkipped = null, oxSkipped = null;

      // One slow oxlint run with JSON output for the diag agreement check
      // (rules with many diagnostics like no-var spend most of subprocess
      // time serializing JSON; we don't want that to skew timing).
      const oxDiagsRun = runOxlint(filePath, ruleId, { wantDiags: true });
      if (oxDiagsRun.skipped) oxSkipped = oxDiagsRun.skipped;
      oxDiags = oxDiagsRun.diags;

      // Warmup (timings discarded)
      for (let i = 0; i < WARMUP; i++) {
        await runEz(src, ruleId, filename);
        runEslint(src, ruleId, filename);
        if (!oxSkipped) runOxlint(filePath, ruleId); // --silent timing
      }
      // Measured iters — timing only, no JSON serialization in the hot loop.
      for (let i = 0; i < ITERS; i++) {
        const ez = await runEz(src, ruleId, filename);
        const es = runEslint(src, ruleId, filename);
        ezTimes.push(ez.ms); esTimes.push(es.ms);
        ezDiags = ez.diags; esDiags = es.diags;
        if (es.skipped) esSkipped = es.skipped;
        if (!oxSkipped) {
          const ox = runOxlint(filePath, ruleId); // --silent fast path
          oxTimes.push(ox.ms);
        }
      }

      const ezMs = median(ezTimes);
      const esMs = esSkipped ? 0 : median(esTimes);
      const oxMs = oxSkipped ? 0 : median(oxTimes);
      const ez_es = esSkipped ? "  -  " : (listAgreement(ezDiags, esDiags) ? "  ✓  " : "DIFF ");
      const ez_ox = oxSkipped ? "  -  " : (listAgreement(ezDiags, oxDiags) ? "  ✓  " : "DIFF ");

      console.log(
        ruleId.padEnd(W.rule) + " │ " +
        fmtMs(ezMs) + " " + fmtMbs(ezMs, bytes) + " │ " +
        fmtMs(esMs) + " " + fmtMbs(esMs, bytes) + " │ " +
        fmtMs(oxMs) + " " + fmtMbs(oxMs, bytes) + " │ " +
        fmtCount(ezDiags.length) + " " + fmtCount(esDiags.length, esSkipped) + " " + fmtCount(oxDiags.length, oxSkipped) + " │ " +
        ez_es + "  " + ez_ox,
      );

      if (DIFF && (ez_es.includes("DIFF") || ez_ox.includes("DIFF"))) {
        const ezSet = new Set(ezDiags), esSet = new Set(esDiags), oxSet = new Set(oxDiags);
        if (ez_es.includes("DIFF") && !esSkipped) {
          const onlyEz = ezDiags.filter(l => !esSet.has(l));
          const onlyEs = esDiags.filter(l => !ezSet.has(l));
          if (onlyEz.length) console.log(`    ez-only vs eslint: L${onlyEz.slice(0, 10).join(",L")}${onlyEz.length > 10 ? `... (+${onlyEz.length - 10})` : ""}`);
          if (onlyEs.length) console.log(`    eslint-only vs ez: L${onlyEs.slice(0, 10).join(",L")}${onlyEs.length > 10 ? `... (+${onlyEs.length - 10})` : ""}`);
        }
        if (ez_ox.includes("DIFF") && !oxSkipped) {
          const onlyEz = ezDiags.filter(l => !oxSet.has(l));
          const onlyOx = oxDiags.filter(l => !ezSet.has(l));
          if (onlyEz.length) console.log(`    ez-only vs oxlint: L${onlyEz.slice(0, 10).join(",L")}${onlyEz.length > 10 ? `... (+${onlyEz.length - 10})` : ""}`);
          if (onlyOx.length) console.log(`    oxlint-only vs ez: L${onlyOx.slice(0, 10).join(",L")}${onlyOx.length > 10 ? `... (+${onlyOx.length - 10})` : ""}`);
        }
      }
    }
    console.log(dash.repeat(rule_w));
  }
})();
