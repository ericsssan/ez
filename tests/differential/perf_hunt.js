"use strict";
/**
 * Headline lint perf check + correctness oracle.
 *
 * Parses the fixture ONCE on each side, then runs ALL rules in a SINGLE
 * pass — `runPlugins(ast, allRuleDescs, ...)` for ez and `oxlint --rules
 * a,b,c,...` for oxlint.  This matches how a real lint actually runs:
 * one parse, one walk, all rules dispatched together.
 *
 * Why no per-rule timing: running rules one at a time over a cached AST
 * (the previous mode) added a visitor-map rebuild and dispatch
 * setup cost on EVERY rule, inflating ez's apparent total by ~75% on
 * `--all-rules` runs.  It also was not comparable to oxlint, which
 * never runs rules in isolation.  If you want per-rule cost in
 * isolation, use `bench/profile_one_rule.js <rule>` directly.
 *
 * Output:
 *   - ez all-rules ms vs oxlint batch ms (same parse, same fixture)
 *   - per-rule diagnostic counts (attributed from a single runPlugins
 *     call; free), so correctness regressions surface even though
 *     timing is global
 *   - regression check vs a per-fixture baseline (totals + per-rule
 *     diag counts)
 *
 * Usage:
 *   bun tests/differential/perf_hunt.js                  # default fixture
 *   bun tests/differential/perf_hunt.js --file checker.ts
 *   bun tests/differential/perf_hunt.js --rules no-shadow,no-undef
 *   bun tests/differential/perf_hunt.js --with-eslint     # ESLint as oracle
 *   bun tests/differential/perf_hunt.js --diag-counts     # also pull oxlint diag counts
 *   bun tests/differential/perf_hunt.js --save-baseline   # capture / refresh baseline
 */

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "../..");
const FIXTURES_DIR = path.join(ROOT, "bench/fixtures");

const args = process.argv.slice(2);
const _flag = n => args.includes(n);
const _arg  = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };

// Default to a mid-size fixture so oxlint subprocess startup doesn't dominate.
const fileArg = _arg("--file", "three.js");
const filePath = path.isAbsolute(fileArg) ? fileArg : path.join(FIXTURES_DIR, fileArg);

// Build the default rule set: every rule ez has that oxlint also has.
//
// All plugins enabled by default. unicorn and jsdoc were previously
// excluded for over-skewing the bench (single rules eating 28% / 17%
// of total) but re-included now that we're targeting per-rule rewrites
// — the heaviest rules are precisely the ones that justify the
// rewrite work.
function _commonRulesWithOxlint() {
  const { loadCoreRules, loadPlugin } = require(path.join(ROOT, "js/load-plugin.js"));
  // Note: only `eslint-plugin-unicorn` is ESM. The other plugins are CJS
  // (or ship `.cjs` rule files) — Bun 1.3.9's `Bun.plugin` onLoad can't
  // return CJS modules so the build-time rewriter can't reach them yet.
  // The bench still loads all of them to measure realistic total cost;
  // optimizations will simply have zero effect on CJS rules until the
  // CJS substitution path lands.
  const PLUGIN_PKGS = [
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
  const all = loadCoreRules({ includeDeprecated: true })
    .map(r => r.meta?.name).filter(Boolean);
  for (const pkg of PLUGIN_PKGS) {
    try {
      for (const r of loadPlugin(pkg)) if (r.meta?.name) all.push(r.meta.name);
    } catch {}
  }
  const { oxlintRules } = require(path.join(ROOT, "tests/differential/real_fixtures.js"));
  const ox = oxlintRules ? oxlintRules() : new Set();
  const _short = (id) => { const i = id.lastIndexOf("/"); return i < 0 ? id : id.slice(i + 1); };
  const seen = new Set();
  const out = [];
  for (const id of all) {
    if (seen.has(id)) continue;
    if (ox.size > 0 && !ox.has(_short(id))) continue;
    seen.add(id);
    out.push(id);
  }
  return out;
}

let rules;
const ruleArg = _arg("--rule", null);
const rulesArg = _arg("--rules", null);
if (ruleArg) rules = [ruleArg];
else if (rulesArg) rules = rulesArg.split(",");
else rules = _commonRulesWithOxlint();

// Filter rules by fixture extension — same convention a real ESLint
// flat config uses via `files: ["**/*.tsx", ...]`.
if (!ruleArg && !rulesArg) {
  const ext = path.extname(filePath).toLowerCase();
  const isJsx = ext === ".jsx" || ext === ".tsx";
  const isTs  = ext === ".ts"  || ext === ".tsx" || ext === ".mts" || ext === ".cts";
  const _isReactPlugin = (id) =>
    id.startsWith("eslint-plugin-react/") ||
    id.startsWith("eslint-plugin-react-hooks/") ||
    id.startsWith("eslint-plugin-jsx-a11y/") ||
    id.startsWith("react/") || id.startsWith("react-hooks/") || id.startsWith("jsx-a11y/");
  const _isTsPlugin = (id) =>
    id.startsWith("@typescript-eslint/") ||
    id.startsWith("@typescript-eslint/eslint-plugin/");
  const before = rules.length;
  rules = rules.filter(id => {
    if (_isReactPlugin(id) && !isJsx) return false;
    if (_isTsPlugin(id) && !isTs) return false;
    return true;
  });
  if (rules.length !== before) {
    console.error(`  filtered ${before - rules.length} rules not applicable to ${path.basename(filePath)} (kept ${rules.length})`);
  }
}

const {
  parseEzOnce, runEzAllOnAst,
  runOxlintBatch, runOxlintBaseline, runOxlintBatchDiagCounts,
  runEslintAllOnce, oxlintRules,
} = require(path.join(ROOT, "tests/differential/real_fixtures.js"));

const WITH_ESLINT      = _flag("--with-eslint");
const WITH_DIAG_COUNTS = _flag("--diag-counts") || WITH_ESLINT;
const SAVE_BASELINE    = _flag("--save-baseline");

function round1(x) { return Math.round(x * 10) / 10; }

function compareToBaseline(prev, ezDiagCounts, ezAllInOneMs, oxBatchTotal, ezTotalDiags) {
  const diagChanged = []; // { ruleId, prev, cur, delta }
  for (const [ruleId, info] of Object.entries(prev.rules || {})) {
    const prevD = info.diags ?? 0;
    const curD = ezDiagCounts.get(ruleId) ?? 0;
    if (curD !== prevD) diagChanged.push({ ruleId, prev: prevD, cur: curD, delta: curD - prevD });
  }
  diagChanged.sort((a, b) => Math.abs(b.delta) - Math.abs(a.delta));
  return {
    diagChanged,
    totals: {
      ezAllInOneMs: { prev: prev.totals?.ezAllInOneMs ?? 0, cur: round1(ezAllInOneMs) },
      oxBatchMs:    { prev: prev.totals?.oxBatchMs    ?? 0, cur: round1(oxBatchTotal) },
      ezTotalDiags: { prev: prev.totals?.ezTotalDiags ?? 0, cur: ezTotalDiags },
    },
  };
}

(async () => {
  if (!fs.existsSync(filePath)) {
    console.error(`Missing fixture: ${filePath}`);
    process.exit(1);
  }
  const src = fs.readFileSync(filePath, "utf8");
  const bytes = Buffer.byteLength(src, "utf8");
  const filename = path.basename(filePath);

  console.log(`perf hunt  —  ${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`rules: ${rules.length}`);
  console.log("");

  // ── ez side: parse once, run all rules in ONE runPlugins call ──
  // First call triggers V8/JSC JIT compilation of rule bodies and
  // dispatch hot paths (~300 ms warmup cost on typescript.js). Run a
  // throwaway warmup pass first so the measured number reflects
  // steady-state perf — what an LSP / long-running linter sees.
  process.stderr.write(`  ez all-rules (warmup) ...`);
  const ctx = parseEzOnce(src, filename);
  runEzAllOnAst(ctx, rules);
  process.stderr.write(`\r${" ".repeat(80)}\r  ez all-rules ...`);
  const ezAll = runEzAllOnAst(ctx, rules);
  const ezAllInOneMs = ezAll.ms;
  const ezDiagCounts = ezAll.perRule;
  const ezTotalDiags = ezAll.totalDiags;
  const ezLocs = ezAll.locs;
  process.stderr.write(`\r${" ".repeat(80)}\r`);

  // ── oxlint side: one subprocess running all rules ──
  process.stderr.write(`  oxlint baseline ...`);
  const oxBaseline = runOxlintBaseline(filePath);
  process.stderr.write(`\r${" ".repeat(80)}\r  oxlint batch (${rules.length} rules) ...`);
  const oxBatchResult = runOxlintBatch(filePath, rules);
  const oxBatchTotal = oxBatchResult.totalMs;
  const oxKnown = oxBatchResult.knownCount;
  process.stderr.write(`\r${" ".repeat(80)}\r`);

  // Which rules oxlint actually knows (for diag-count comparison only).
  const _oxSet = oxlintRules ? oxlintRules() : new Set();
  const _shortId = (id) => { const i = id.lastIndexOf("/"); return i < 0 ? id : id.slice(i + 1); };
  const oxKnownSet = new Set();
  for (const r of rules) if (_oxSet.has(_shortId(r))) oxKnownSet.add(r);

  // ── Optional oxlint diag counts (extra subprocess with --format json) ──
  let oxDiagCounts = new Map();
  let oxLocs = null; // Set<"<shortRuleId>:<line>">
  if (WITH_DIAG_COUNTS) {
    process.stderr.write(`  oxlint diag counts ...`);
    const r = runOxlintBatchDiagCounts(filePath, rules);
    oxDiagCounts = r.perRule;
    oxLocs = r.locs;
    process.stderr.write(`\r${" ".repeat(80)}\r`);
  }

  // ── Optional ESLint as the diag-count oracle ──
  let esDiagCounts = null, esRuleCount = 0, esMs = 0, esDropped = 0;
  let esResultLocs = null; // Map<ruleId, Set<"line:col">>
  if (WITH_ESLINT) {
    process.stderr.write(`  eslint diag counts ...`);
    const r = runEslintAllOnce(src, rules, filename);
    esDiagCounts = r.perRule;
    esResultLocs = r.locsByRule;
    esRuleCount = rules.length - r.droppedCount;
    esDropped = r.droppedCount;
    esMs = r.ms;
    process.stderr.write(`\r${" ".repeat(80)}\r`);
  }

  // Aggregate diag totals from sources we collected.
  let oxTotalDiags = 0, esTotalDiags = 0;
  const diagDeltas = []; // { ruleId, ez, ox, es?, ratio }
  for (const ruleId of rules) {
    const ezN = ezDiagCounts.get(ruleId) ?? 0;
    const shortId = _shortId(ruleId);
    const oxN = WITH_DIAG_COUNTS ? (oxDiagCounts.get(shortId) ?? 0) : null;
    const esN = esDiagCounts ? (esDiagCounts.get(ruleId) ?? 0) : null;
    if (oxN !== null && oxKnownSet.has(ruleId)) oxTotalDiags += oxN;
    if (esN !== null) esTotalDiags += esN;
    const ref = esN !== null ? esN : (oxN !== null && oxKnownSet.has(ruleId) ? oxN : null);
    if (ref !== null && Math.abs(ezN - ref) >= 5 &&
        Math.max(ezN, ref) >= 2 * Math.max(1, Math.min(ezN, ref))) {
      diagDeltas.push({ ruleId, ez: ezN, ox: oxN, es: esN, ratio: ref > 0 ? ezN / ref : Infinity });
    }
  }

  // ── Headline numbers ─────────────────────────────────────────────
  console.log(`headline (parse once, run all rules together):`);
  console.log(`  ez:     ${ezAllInOneMs.toFixed(0)} ms   (${rules.length} rules in one runPlugins)`);
  console.log(`  oxlint: ${oxBatchTotal.toFixed(0)} ms   (1 subprocess with ${oxKnown} rules)`);
  console.log(`          (${oxBaseline.toFixed(0)} ms baseline subtracted = ${(oxBatchTotal - oxBaseline).toFixed(0)} ms net)`);
  console.log(`  ratio:  ${(ezAllInOneMs / oxBatchTotal).toFixed(2)}× (vs total)  ${oxBatchTotal > oxBaseline ? `${(ezAllInOneMs / (oxBatchTotal - oxBaseline)).toFixed(2)}× (vs net)` : ""}`);
  console.log("");

  // ── Diagnostic counts ────────────────────────────────────────────
  console.log(`diagnostic counts:`);
  console.log(`  ez:     ${ezTotalDiags}`);
  if (esRuleCount > 0) {
    console.log(`  ESLint: ${esTotalDiags}  (${esRuleCount}/${rules.length} rules, ${esDropped} pruned, ${esMs.toFixed(0)} ms)`);
  }
  if (WITH_DIAG_COUNTS) {
    const oxDelta = ezTotalDiags - oxTotalDiags;
    console.log(`  oxlint: ${oxTotalDiags}${oxDelta === 0 ? "" : `  (ez delta ${oxDelta >= 0 ? "+" : ""}${oxDelta})`}`);
    // Force the harness to actually compare outputs, not just counts.
    // Agreement = |ez ∩ ox| / |ez ∪ ox| (Jaccard) over keys
    // `<shortRuleId>:<line>`. Catches cases where counts roughly
    // match but the two engines disagree on which lines.
    if (oxLocs && ezLocs) {
      let inter = 0;
      for (const k of ezLocs) if (oxLocs.has(k)) inter++;
      const union = ezLocs.size + oxLocs.size - inter;
      const ezOnly = ezLocs.size - inter;
      const oxOnly = oxLocs.size - inter;
      const pct = union === 0 ? 100 : (inter / union * 100);
      console.log(`  agreement: ${pct.toFixed(1)}% jaccard  (matched=${inter}, ez-only=${ezOnly}, ox-only=${oxOnly})`);
    }
  } else {
    console.log(`  (oxlint counts skipped — pass --diag-counts to enable; slow on big fixtures)`);
  }
  if (diagDeltas.length > 0) {
    diagDeltas.sort((x, y) => {
      const refY = y.es != null ? y.es : y.ox;
      const refX = x.es != null ? x.es : x.ox;
      return Math.abs(y.ez - refY) - Math.abs(x.ez - refX);
    });
    const oracle = esRuleCount > 0 ? "ESLint" : "oxlint";
    console.log(`  rules where ez disagrees with ${oracle} (top ${Math.min(10, diagDeltas.length)}):`);
    for (const d of diagDeltas.slice(0, 10)) {
      const ratio = d.ratio === Infinity ? "∞" : d.ratio.toFixed(1) + "×";
      const esCol = d.es != null ? `  es=${d.es}` : "";
      console.log(`    ${d.ruleId.padEnd(50)} ez=${d.ez}${esCol}  ox=${d.ox ?? "?"}  (${ratio})`);
    }
  }
  console.log("");

  // ── Per-rule oracle conformance: ez locations must match ESLint ──
  // Policy: ez runs the same JS rules as ESLint, so they MUST emit
  // identical (line:col) sets per rule. Any deviation is a bug to fix
  // in ez. The harness FAILS LOUDLY here so disagreements can't slip
  // past unnoticed.
  if (WITH_ESLINT) {
    const ezAll2 = ezAll; // Map<ruleId, Set<"line:col">>
    const esLocs = esResultLocs; // Map<ruleId, Set<"line:col">> from runEslintAllOnce
    const failures = [];
    for (const ruleId of rules) {
      const ezL = ezAll2.locsByRule ? ezAll2.locsByRule.get(ruleId) : null;
      const esL = esLocs ? esLocs.get(ruleId) : null;
      if (!ezL || !esL) continue;
      let ezOnly = 0, esOnly = 0;
      for (const k of ezL) if (!esL.has(k)) ezOnly++;
      for (const k of esL) if (!ezL.has(k)) esOnly++;
      if (ezOnly !== 0 || esOnly !== 0) {
        failures.push({ ruleId, ezN: ezL.size, esN: esL.size, ezOnly, esOnly });
      }
    }
    if (failures.length === 0) {
      console.log(`✓ ez ↔ ESLint location oracle: 100% match across ${rules.length} rules`);
    } else {
      failures.sort((a, b) => (b.ezOnly + b.esOnly) - (a.ezOnly + a.esOnly));
      console.log(`✗ ez ↔ ESLint LOCATION ORACLE FAIL: ${failures.length}/${rules.length} rules disagree`);
      console.log(`  (per the ez-runs-eslint-rules invariant, every miss is a bug to fix in ez)`);
      console.log(`  rule${" ".repeat(36)}  ez   es  ez-only  es-only`);
      for (const f of failures) {
        console.log(`  ${f.ruleId.padEnd(40)}  ${f.ezN.toString().padStart(4)}  ${f.esN.toString().padStart(4)}  ${f.ezOnly.toString().padStart(7)}  ${f.esOnly.toString().padStart(7)}`);
      }
      process.exitCode = 1;
    }
    console.log("");
  }

  // ── Baseline (load → compare, or save) ───────────────────────────
  const baselineFile = path.join(ROOT, "bench", `perf_hunt_baseline.${filename.replace(/\W+/g, "_")}.json`);
  if (SAVE_BASELINE) {
    const snapshot = {
      fixture: filename,
      bytes,
      ruleCount: rules.length,
      savedAt: new Date().toISOString(),
      totals: {
        ezAllInOneMs: round1(ezAllInOneMs),
        oxBatchMs:    round1(oxBatchTotal),
        oxBaselineMs: round1(oxBaseline),
        ezTotalDiags,
      },
      rules: {},
    };
    for (const r of rules) {
      snapshot.rules[r] = { diags: ezDiagCounts.get(r) ?? 0 };
    }
    fs.writeFileSync(baselineFile, JSON.stringify(snapshot, null, 2));
    console.log(`→ baseline saved to ${path.relative(ROOT, baselineFile)} (${rules.length} rules)`);
    return;
  }

  if (fs.existsSync(baselineFile)) {
    let prev;
    try { prev = JSON.parse(fs.readFileSync(baselineFile, "utf8")); }
    catch { prev = null; }
    if (prev && prev.fixture === filename) {
      const b = compareToBaseline(prev, ezDiagCounts, ezAllInOneMs, oxBatchTotal, ezTotalDiags);
      console.log(`vs baseline (${path.relative(ROOT, baselineFile)}, saved ${prev.savedAt}):`);
      const fmtTotal = (label, t) => {
        const delta = t.cur - t.prev;
        const sign = delta > 0 ? "+" : "";
        const pct = t.prev > 0 ? ` (${sign}${(100 * delta / t.prev).toFixed(1)}%)` : "";
        return `  ${label.padEnd(20)} ${t.prev} → ${t.cur} ms${pct}`;
      };
      console.log(fmtTotal("ez all-rules", b.totals.ezAllInOneMs));
      console.log(fmtTotal("oxlint batch", b.totals.oxBatchMs));
      const dt = b.totals.ezTotalDiags;
      const dDelta = dt.cur - dt.prev;
      console.log(`  ${"ez total diags".padEnd(20)} ${dt.prev} → ${dt.cur}${dDelta === 0 ? "" : `  (${dDelta > 0 ? "+" : ""}${dDelta})`}`);
      if (b.diagChanged.length > 0) {
        console.log(`  rules with diag-count changes (top ${Math.min(10, b.diagChanged.length)}):`);
        for (const d of b.diagChanged.slice(0, 10)) {
          console.log(`    ${d.ruleId.padEnd(50)} ${d.prev} → ${d.cur}  (${d.delta > 0 ? "+" : ""}${d.delta})`);
        }
      } else {
        console.log(`  no per-rule diag-count changes`);
      }
    }
  } else {
    console.log(`(no baseline at bench/perf_hunt_baseline.${filename.replace(/\W+/g, "_")}.json — pass --save-baseline to capture one)`);
  }
})();
