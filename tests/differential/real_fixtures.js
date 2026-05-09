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
    get oxlintRules() { return oxlintRules; },
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

// Rule registry: core (incl. deprecated) + every plugin we have locally.
// Keyed by the full ez rule id (e.g. "no-unused-vars" or
// "eslint-plugin-unicorn/no-array-for-each").  oxlint's `-D` argument and
// `--rules` table use the SHORT name (the segment after the last "/"), so
// `runOxlint*` strip the prefix before looking up / passing the flag.
const _PLUGIN_PKGS = [
  "@typescript-eslint/eslint-plugin",
  "eslint-plugin-import",
  "eslint-plugin-unicorn",
  "eslint-plugin-react",
  "eslint-plugin-react-hooks",
  "eslint-plugin-n",
  "eslint-plugin-promise",
  "eslint-plugin-jsdoc",
  "eslint-plugin-es-x",
  "eslint-plugin-sonarjs",
];
function _shortName(id) {
  const i = id.lastIndexOf("/");
  return i < 0 ? id : id.slice(i + 1);
}
const _coreRulesAll = loadCoreRules({ only: undefined, includeDeprecated: true });
const _allRulesByName = new Map(_coreRulesAll.map(d => [d.meta?.name, d]).filter(([n]) => n));
for (const pkg of _PLUGIN_PKGS) {
  let rules;
  try { rules = loadPlugin(pkg); } catch { continue; }
  for (const r of rules) if (r.meta?.name) _allRulesByName.set(r.meta.name, r);
}
// Back-compat alias — earlier callers used this name.
const _coreRulesByName = _allRulesByName;
const _nativeRules = getNativeRules();

function parseEzOnce(src, filename) {
  const ast = parseSource(src, { filename });
  return { src, filename, ast, tagNames: getTagNames() };
}

/**
 * Run ALL `ruleIds` against the cached AST in a SINGLE `runPlugins` call —
 * matches what real ez lint does in a real lint pass.  Returns total wall
 * time, the global diagnostic count, AND a per-rule diagnostic-count map
 * (attributed by `ruleId` on each report — free, no extra rule runs).
 * Use this to benchmark "real" ez throughput vs oxlint's batched throughput.
 */
function runEzAllOnAst(ctx, ruleIds) {
  const descs = [];
  const nativeRules = {};
  const perRule = new Map();
  for (const id of ruleIds) {
    const desc = _coreRulesByName.get(id);
    if (!desc) continue;
    perRule.set(id, 0);
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
      // Disable the per-rule short-circuit so diag counts are honest and
      // comparable to ESLint (which has no cap). Production users still
      // get the default 200 cap via api.js / lintSource — this only
      // affects benchmarking and correctness oracling.
      errorBudget: Infinity,
    });
  }
  const ms = performance.now() - t0;
  // Locations keyed by `${shortRuleId}:${line}`. Lets perf_hunt
  // compute set agreement with the oxlint side without printing
  // individual diagnostics.
  const locs = new Set();
  const _short = (id) => { const i = id.lastIndexOf("/"); return i < 0 ? id : id.slice(i + 1); };
  for (const d of nativeDiags) {
    const id = d.rule_id || d.ruleId;
    if (id && perRule.has(id)) perRule.set(id, perRule.get(id) + 1);
    const line = d.line ?? d.startLine ?? d.loc?.start?.line ?? 0;
    if (id) locs.add(`${_short(id)}:${line}`);
  }
  for (const r of reports) {
    if (r.ruleId && perRule.has(r.ruleId)) perRule.set(r.ruleId, perRule.get(r.ruleId) + 1);
    const line = r.line ?? r.loc?.start?.line ?? 0;
    if (r.ruleId) locs.add(`${_short(r.ruleId)}:${line}`);
  }
  return { ms, totalDiags: nativeDiags.length + reports.length, perRule, locs };
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

// ── ESLint batched (oracle for diagnostic counts) ────────────────────
//
// Loads ESLint core + every plugin in PLUGIN_PKGS_FOR_ESLINT and runs
// ALL `ruleIds` in one Linter.verify call. Type-aware @typescript-eslint
// rules are pruned upfront because they require a configured TS program
// which we don't set up; rules that fail to load on a probe source are
// also dropped so a single bad rule doesn't poison the whole verify.
//
// Returns { ms, perRule: Map<ruleId, count>, total, droppedCount }.
const _ESLINT_PLUGIN_ALIAS = {
  "@typescript-eslint/eslint-plugin": "@typescript-eslint",
  "eslint-plugin-import":             "import",
  "eslint-plugin-unicorn":            "unicorn",
  "eslint-plugin-react":              "react",
  "eslint-plugin-react-hooks":        "react-hooks",
  "eslint-plugin-n":                  "n",
  "eslint-plugin-promise":            "promise",
  "eslint-plugin-jsdoc":              "jsdoc",
  "eslint-plugin-es-x":               "es-x",
  "eslint-plugin-sonarjs":            "sonarjs",
};

let _eslintPlugins = null;
let _eslintCoreNames = null;
function _loadEslintPlugins() {
  if (_eslintPlugins !== null) return { plugins: _eslintPlugins, coreNames: _eslintCoreNames };
  _eslintPlugins = {};
  _eslintCoreNames = new Set();
  // Track core rule names so we know whether a bare ruleId is a core rule.
  for (const r of _coreRulesAll) if (r.meta?.name) _eslintCoreNames.add(r.meta.name);
  const resolveOpts = { paths: [path.join(ROOT, "js"), path.join(ROOT, "js/node_modules")] };
  for (const [pkg, alias] of Object.entries(_ESLINT_PLUGIN_ALIAS)) {
    let mod;
    try { mod = require(require.resolve(pkg, resolveOpts)); } catch { continue; }
    if (mod && !mod.rules && mod.default?.rules) mod = mod.default; // ESM unwrap
    if (mod && mod.rules) _eslintPlugins[alias] = mod;
  }
  return { plugins: _eslintPlugins, coreNames: _eslintCoreNames };
}

function _toEslintRuleId(ruleId, coreNames) {
  // Map ez rule ids to ESLint config keys.
  // Core: bare name (e.g. "no-unused-vars") — use as-is if known.
  if (coreNames.has(ruleId)) return ruleId;
  // Plugin: "<pkg>/<rule>" → "<alias>/<rule>".
  for (const [pkg, alias] of Object.entries(_ESLINT_PLUGIN_ALIAS)) {
    if (ruleId.startsWith(pkg + "/")) return alias + "/" + ruleId.slice(pkg.length + 1);
  }
  return null; // unknown — caller drops
}

function runEslintAllOnce(src, ruleIds, filename) {
  const { plugins, coreNames } = _loadEslintPlugins();
  const isTs = /\.[mc]?tsx?$/.test(filename);
  const tp = isTs ? tsParser() : null;
  const baseLang = { ecmaVersion: 2022, sourceType: "module" };
  if (tp) baseLang.parser = tp;

  // Map ez rule ids to ESLint ids.
  const ezToEs = new Map();
  const esRules = {};
  for (const id of ruleIds) {
    const esId = _toEslintRuleId(id, coreNames);
    if (esId) {
      ezToEs.set(id, esId);
      esRules[esId] = "error";
    }
  }

  // Probe every rule on a tiny source first; drop any that throws or
  // returns a fatal "rule load" diagnostic (most are typed-linting).
  const probeLinter = new Linter();
  const dropped = [];
  for (const id of [...Object.keys(esRules)]) {
    try {
      const msgs = probeLinter.verify("var x = 1;\n",
        { plugins, rules: { [id]: esRules[id] }, languageOptions: baseLang },
        { filename: "probe.js" });
      const fatal = msgs.find(m => m.fatal || (m.ruleId == null &&
        /requires type information|Could not find|loading rule|plugin/i.test(m.message || "")));
      if (fatal) { delete esRules[id]; dropped.push(id); }
    } catch { delete esRules[id]; dropped.push(id); }
  }

  const linter = new Linter();
  const t0 = performance.now();
  let msgs;
  try {
    msgs = linter.verify(src, { plugins, rules: esRules, languageOptions: baseLang }, { filename });
  } catch (e) {
    return { ms: performance.now() - t0, perRule: new Map(), total: 0, droppedCount: dropped.length, error: e.message };
  }
  const ms = performance.now() - t0;
  const perRule = new Map(); // keyed by ez rule id (caller-friendly)
  let total = 0;
  // Reverse map: ESLint rule id → ez rule id
  const esToEz = new Map();
  for (const [ezId, esId] of ezToEs) esToEz.set(esId, ezId);
  for (const m of msgs) {
    const ezId = esToEz.get(m.ruleId);
    if (!ezId) continue;
    perRule.set(ezId, (perRule.get(ezId) || 0) + 1);
    total++;
  }
  return { ms, perRule, total, droppedCount: dropped.length };
}

if (!_isMain) module.exports.runEslintAllOnce = runEslintAllOnce;

// ── oxlint ───────────────────────────────────────────────────────────
const OXLINT_BIN = (() => { try { return Bun.which("oxlint") || "/opt/homebrew/bin/oxlint"; } catch { return "oxlint"; } })();

// Build the set of rule names oxlint actually knows so we don't waste a
// subprocess per unknown rule. `oxlint --rules` prints a markdown-formatted
// table; extract the first column. Result is cached to disk keyed by the
// oxlint binary's mtime so repeat bench/profile runs don't re-spawn — the
// raw spawn was ~480ms and dominated CPU profiles even though it has
// nothing to do with linting.
let _oxlintRules = null;
function oxlintRules() {
  if (_oxlintRules !== null) return _oxlintRules;
  const set = new Set();
  const fs = require("fs");
  const path = require("path");
  const cachePath = path.join(__dirname, ".oxlint-rules-cache.txt");
  let binMtime = 0;
  try { binMtime = fs.statSync(OXLINT_BIN).mtimeMs | 0; } catch {}
  try {
    const cached = fs.readFileSync(cachePath, "utf8");
    const nlIdx = cached.indexOf("\n");
    if (nlIdx > 0 && Number(cached.slice(0, nlIdx)) === binMtime) {
      for (const r of cached.slice(nlIdx + 1).split("\n")) if (r) set.add(r);
      _oxlintRules = set;
      return set;
    }
  } catch {}
  try {
    const out = Buffer.from(Bun.spawnSync([OXLINT_BIN, "--rules"], { stdout: "pipe" }).stdout).toString();
    for (const line of out.split("\n")) {
      const m = line.match(/^\|\s*([@a-z][\w/-]+)\s*\|/i);
      if (m) set.add(m[1]);
    }
    try { fs.writeFileSync(cachePath, binMtime + "\n" + [...set].join("\n")); } catch {}
  } catch {}
  _oxlintRules = set;
  return set;
}

function runOxlint(filePath, ruleId, opts = {}) {
  // ez plugin rules carry a "<pkg>/<rule>" prefix; oxlint indexes them by
  // SHORT name (last segment). Strip before lookup / -D arg.
  const oxName = _shortName(ruleId);
  if (!oxlintRules().has(oxName)) return { ms: 0, diags: [], skipped: "unknown-rule" };
  // -A all silences everything, then -D <rule> turns just the target on.
  // For TIMING-ONLY runs (default), we use `--silent` and discard stdout —
  // otherwise oxlint spends most of its time serializing JSON for high-diag
  // rules (no-var on typescript.js is 11.7s with JSON output, 0.1s without).
  // Callers that need diagnostic content (`--diff` mode) pass `wantDiags:true`.
  const wantDiags = !!opts.wantDiags;
  const args = wantDiags
    ? [OXLINT_BIN, "-A", "all", "-D", oxName, "--format", "json", filePath]
    : [OXLINT_BIN, "-A", "all", "-D", oxName, "--silent", filePath];
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
  const known = ruleIds.map(_shortName).filter(n => oxlintRules().has(n));
  if (known.length === 0) return { totalMs: 0, perRuleMs: 0, knownCount: 0 };
  const args = [OXLINT_BIN, "-A", "all"];
  for (const n of known) { args.push("-D"); args.push(n); }
  args.push("--silent", filePath);
  const t0 = performance.now();
  Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  const totalMs = performance.now() - t0;
  return { totalMs, perRuleMs: totalMs / known.length, knownCount: known.length };
}

/// Batched diag-count run: same rule set as runOxlintBatch, but emits
/// JSON so we can count diagnostics per rule. Slower than --silent (oxlint
/// serializes every diagnostic) — caller should run this ONCE outside the
/// timing loop. Returns { perRule: Map<shortName, count>, total }.
function runOxlintBatchDiagCounts(filePath, ruleIds) {
  const known = ruleIds.map(_shortName).filter(n => oxlintRules().has(n));
  const perRule = new Map(known.map(n => [n, 0]));
  // Set of "<shortRuleId>:<line>" keys — used by perf_hunt to compute
  // agreement % vs ez's diagnostic locations. Same shape as the ez
  // side's loc-key Set so set intersection / size give the agreement.
  const locs = new Set();
  if (known.length === 0) return { perRule, total: 0, locs };
  const args = [OXLINT_BIN, "-A", "all"];
  for (const n of known) { args.push("-D"); args.push(n); }
  args.push("--format", "json", filePath);
  const proc = Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  const out = Buffer.from(proc.stdout).toString("utf8").trim();
  if (!out) return { perRule, total: 0, locs };
  let total = 0;
  // oxlint JSON shape: top-level { diagnostics: [...] } or NDJSON per-line.
  if (out.startsWith("{") && out.includes("\"diagnostics\"")) {
    try {
      const data = JSON.parse(out);
      for (const d of data.diagnostics || []) {
        const code = typeof d.code === "string" ? d.code : d.code?.value;
        if (!code) continue;
        const m = code.match(/\(([^)]+)\)$/);
        const short = m ? m[1] : code;
        if (perRule.has(short)) {
          perRule.set(short, perRule.get(short) + 1);
          total++;
          // labels[0]?.span?.offset is the byte offset; we don't have
          // a line directly. Use d.labels[0].span.offset as a stable
          // key — both sides convert their location to a line below.
          // Actually oxlint emits labels in chars; ez has line/column
          // per report. To make them comparable, try to extract line
          // from the diagnostic's `help`/`labels`/`span` fields if
          // present. Fall back to 0 (still useful: ruleId-equality
          // catches gross-disagreement cases).
          let line = 0;
          if (Array.isArray(d.labels) && d.labels.length > 0) {
            line = d.labels[0].span?.line ?? d.labels[0].line ?? 0;
          }
          locs.add(`${short}:${line}`);
        }
      }
    } catch {}
  } else {
    for (const ln of out.split("\n")) {
      if (!ln.trim()) continue;
      try {
        const d = JSON.parse(ln);
        const id = d.ruleId || d.code;
        const short = typeof id === "string" ? _shortName(id) : null;
        if (short && perRule.has(short)) {
          perRule.set(short, perRule.get(short) + 1);
          total++;
          locs.add(`${short}:${d.line ?? 0}`);
        }
      } catch {}
    }
  }
  return { perRule, total, locs };
}

if (!_isMain) module.exports.runOxlintBatchDiagCounts = runOxlintBatchDiagCounts;

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
