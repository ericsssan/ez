"use strict";
/**
 * Per-rule perf hunt: time every rule under ez and oxlint on a real fixture,
 * surface diag-count mismatches, and emit a ready-to-run CPU-profile command
 * for the heaviest rule.
 *
 * Default behaviour:
 *   - Rule set: every rule ez has that oxlint also has (intersection by short
 *     name).  Override with `--rules a,b,c` or `--rule x`.
 *   - Mode: amortized — parse once, then run all rules in ONE `runPlugins`
 *     call (matches how a real lint pass works).  `--no-amortize` reverts to
 *     the legacy per-rule-cold-call mode (slower; useful only for absolute
 *     single-rule cost in isolation).
 *   - Iterations: 1 run, no warmup. The script measures total work done by
 *     each linter, not per-rule micro-benchmarks; multi-iter medians don't
 *     buy anything for this comparison.
 *
 * Diagnostic-count check:
 *   The script always counts ez vs oxlint diagnostics per rule (a rule that
 *   produces 1M phantom reports vs oxlint's 19 looks fast in raw time but is
 *   broken).  Pass `--with-eslint` to also run ESLint as the oracle —
 *   ESLint is slow on the full corpus but the most authoritative.
 *
 * Workflow:
 *   1. Run this script. It prints a sorted table and a diag-count delta list.
 *   2. Copy the suggested `bun --cpu-prof-md ... profile_one_rule.js <rule>`
 *      command for the heaviest rule.
 *   3. Open the produced markdown profile, find the bottleneck, fix it.
 *   4. Re-run to confirm the rule moved.
 *
 * Usage:
 *   bun tests/differential/perf_hunt.js
 *   bun tests/differential/perf_hunt.js --file checker.ts
 *   bun tests/differential/perf_hunt.js --rules no-shadow,no-undef
 *   bun tests/differential/perf_hunt.js --with-eslint     # run ESLint as oracle
 *   bun tests/differential/perf_hunt.js --top 5           # show top 5 (default 10)
 */

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "../..");
const FIXTURES_DIR = path.join(ROOT, "bench/fixtures");

const args = process.argv.slice(2);
const _flag = n => args.includes(n);
const _arg  = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };

const TOP_N  = parseInt(_arg("--top", "10"), 10);

// Default to a mid-size fixture so oxlint subprocess startup doesn't dominate.
const fileArg = _arg("--file", "three.js");
const filePath = path.isAbsolute(fileArg) ? fileArg : path.join(FIXTURES_DIR, fileArg);

// Build the default rule set: all rules ez has that oxlint also has.
// This is the apples-to-apples surface — both linters can check exactly
// the same rules. Earlier this was a hand-picked 13-rule list, which
// hid both phantom-report bugs (rules that ez gets wrong on most files)
// and rules where ez has a real perf advantage. The same logic is
// invoked by `--all-rules` for backward compat.
function _commonRulesWithOxlint() {
  const { loadCoreRules, loadPlugin } = require(path.join(ROOT, "js/load-plugin.js"));
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
else if (_flag("--all-rules")) rules = _commonRulesWithOxlint();
else rules = _commonRulesWithOxlint();

const {
  runEz, runOxlint,
  parseEzOnce, runEzOnAst, runEzAllOnAst,
  runOxlintBatch, runOxlintBaseline, runOxlintBatchDiagCounts,
  runEslintAllOnce,
} = require(path.join(ROOT, "tests/differential/real_fixtures.js"));

// Default to amortized mode when many rules are tested (so `--all-rules`
// finishes in seconds instead of minutes).  `--no-amortize` forces the
// classic per-rule-cold-call mode regardless of count.
const FORCE_AMORTIZE   = _flag("--amortize");
const FORCE_NO_AMORTIZE = _flag("--no-amortize");
const WITH_ESLINT      = _flag("--with-eslint");

(async () => {
  if (!fs.existsSync(filePath)) {
    console.error(`Missing fixture: ${filePath}`);
    process.exit(1);
  }
  const src = fs.readFileSync(filePath, "utf8");
  const bytes = Buffer.byteLength(src, "utf8");
  const filename = path.basename(filePath);

  // Default: amortized mode. The per-rule mode pays full subprocess
  // startup + parse cost on each rule, which dominates timing and is
  // not how a real lint pass runs. `--no-amortize` opts back into the
  // legacy per-rule mode for cases where you want absolute single-rule
  // cost in isolation.
  const amortize = !FORCE_NO_AMORTIZE;
  void FORCE_AMORTIZE; // retained for backward-compat; amortize is the default now

  console.log(`perf hunt  —  ${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`rules: ${rules.length}  mode: ${amortize ? "amortized" : "per-rule"}`);
  console.log("");

  const results = [];

  if (amortize) {
    // Parse the source ONCE for ez; oxlint runs all rules in one subprocess.
    // Per-rule timings are amortized (divide-by-N approximations) — useful
    // for ranking but not for absolute single-rule cost.

    const ezPerRule = new Map();
    const ezDiagCounts = new Map();
    const ctx = parseEzOnce(src, filename);
    for (let i = 0; i < rules.length; i++) {
      const ruleId = rules[i];
      process.stderr.write(`\r  ez [${i + 1}/${rules.length}] ${ruleId.padEnd(40)}`);
      const r = runEzOnAst(ctx, ruleId);
      ezPerRule.set(ruleId, r.ms);
      ezDiagCounts.set(ruleId, r.diags.length);
    }

    process.stderr.write(`\r${" ".repeat(80)}\r  oxlint baseline ...`);
    const oxBaseline = runOxlintBaseline(filePath);
    process.stderr.write(`\r${" ".repeat(80)}\r  oxlint batch (${rules.length} rules) ...`);
    const oxBatchResult = runOxlintBatch(filePath, rules);
    const oxBatchTotal = oxBatchResult.totalMs;
    const oxKnown = oxBatchResult.knownCount;
    const oxPerRuleMs = oxKnown > 0 ? Math.max(0, oxBatchTotal - oxBaseline) / oxKnown : 0;

    process.stderr.write(`\r${" ".repeat(80)}\r`);

    // Identify which rules oxlint actually knows. Earlier this spawned
    // an oxlint subprocess per rule (~150 ms × N) — useless overhead
    // since we already have oxlint's catalog. Look up by short name
    // ("<plugin>/<rule>" → "<rule>") against the cached set.
    const { oxlintRules } = require(path.join(ROOT, "tests/differential/real_fixtures.js"));
    const _oxSet = oxlintRules ? oxlintRules() : new Set();
    const _shortId = (id) => { const i = id.lastIndexOf("/"); return i < 0 ? id : id.slice(i + 1); };
    const oxKnownSet = new Set();
    for (const r of rules) if (_oxSet.has(_shortId(r))) oxKnownSet.add(r);

    for (const ruleId of rules) {
      const ezMs = ezPerRule.get(ruleId);
      const known = oxKnownSet.has(ruleId);
      // In amortized mode the oxlint per-rule average is uniform (= batch
      // total / N) — meaningless for cross-rule ranking.  We surface it as
      // a single footer number and rank by ez time.  Per-rule ratios are
      // suppressed to avoid the misleading "100× slower" artifacts.
      results.push({
        ruleId, ezMs, oxMs: null, ratio: null,
        oxSkipped: known ? null : "unknown-rule",
        ezDiagN: ezDiagCounts.get(ruleId) ?? 0,
      });
    }
    // Bonus: realistic ez throughput — parse once, then run ALL rules in
    // ONE `runPlugins` call (matches real lint).  This avoids the per-rule
    // visitor-map rebuild that inflates the per-rule loop.
    const ctx2 = parseEzOnce(src, filename);
    const ezAllInOneMs = runEzAllOnAst(ctx2, rules).ms;

    // ── Diag counts ────────────────────────────────────────────────
    // One non-timed oxlint run with --format json so we can compare
    // diagnostic volume per rule. Phantom-report bugs in ez (e.g. a rule
    // generating 1M reports vs oxlint's 19) get masked by raw timing,
    // so surface counts here.
    process.stderr.write(`\r${" ".repeat(80)}\r  oxlint diag counts ...`);
    const oxDiagCounts = runOxlintBatchDiagCounts(filePath, rules).perRule;
    process.stderr.write(`\r${" ".repeat(80)}\r`);

    // ESLint as the diagnostic-count oracle. Opt-in via `--with-eslint`
    // because ESLint is slow on the full corpus (~ minutes on 8 MB) and
    // type-aware @typescript-eslint rules need a TS program we don't
    // configure — they get pruned by `runEslintAllOnce`.
    let esDiagCounts = null, esRuleCount = 0, esMs = 0, esDropped = 0;
    if (WITH_ESLINT) {
      process.stderr.write(`\r${" ".repeat(80)}\r  eslint diag counts ...`);
      const r = runEslintAllOnce(src, rules, filename);
      esDiagCounts = r.perRule;
      esRuleCount = rules.length - r.droppedCount;
      esDropped = r.droppedCount;
      esMs = r.ms;
      process.stderr.write(`\r${" ".repeat(80)}\r`);
    }

    let ezTotalDiags = 0, oxTotalDiags = 0, esTotalDiags = 0;
    const diagDeltas = []; // { ruleId, ez, ox, es?, ratio }
    for (const ruleId of rules) {
      const ezN = ezDiagCounts.get(ruleId) ?? 0;
      const shortId = _shortId(ruleId);
      const oxN = oxDiagCounts.get(shortId) ?? 0;
      const esN = esDiagCounts ? (esDiagCounts.get(ruleId) ?? 0) : null;
      ezTotalDiags += ezN;
      if (oxKnownSet.has(ruleId)) oxTotalDiags += oxN;
      if (esN !== null) esTotalDiags += esN;
      // Flag mismatches. With ESLint as oracle: compare ez vs ESLint.
      // Without: compare ez vs oxlint.
      const ref = esN !== null ? esN : (oxKnownSet.has(ruleId) ? oxN : null);
      if (ref !== null && Math.abs(ezN - ref) >= 5 &&
          Math.max(ezN, ref) >= 2 * Math.max(1, Math.min(ezN, ref))) {
        diagDeltas.push({ ruleId, ez: ezN, ox: oxN, es: esN, ratio: ref > 0 ? ezN / ref : Infinity });
      }
    }

    // Stash totals for the footer
    results._amortized = { oxBaseline, oxBatchTotal, oxKnown, oxPerRuleMs,
                          ezTotalMs: rules.reduce((s, r) => s + ezPerRule.get(r), 0),
                          ezAllInOneMs,
                          ezTotalDiags, oxTotalDiags,
                          esTotalDiags, esRuleCount, esMs, esDropped,
                          diagDeltas };
  } else {
    for (let i = 0; i < rules.length; i++) {
      const ruleId = rules[i];
      process.stderr.write(`\r  [${i + 1}/${rules.length}] ${ruleId.padEnd(40)}`);

      const ez = await runEz(src, ruleId, filename);
      const ox = runOxlint(filePath, ruleId, { wantDiags: true });

      const ezMs = ez.ms;
      const oxSkipped = ox.skipped || null;
      const oxMs = oxSkipped ? null : ox.ms;
      const ratio = oxMs ? ezMs / oxMs : null;
      results.push({
        ruleId, ezMs, oxMs, ratio, oxSkipped,
        ezDiagN: (ez.diags || []).length,
        oxDiagN: (ox.diags || []).length,
      });
    }
    process.stderr.write(`\r${" ".repeat(60)}\r`);
  }

  // Amortized mode: rank by ez time descending.  Per-rule mode: rank by
  // ez/oxlint ratio descending (= relative slowness vs oxlint).
  if (amortize) {
    results.sort((a, b) => b.ezMs - a.ezMs);
  } else {
    results.sort((a, b) => {
      if (a.ratio == null && b.ratio == null) return 0;
      if (a.ratio == null) return 1;
      if (b.ratio == null) return -1;
      return b.ratio - a.ratio;
    });
  }

  const W = { rule: 28, n: 8, count: 7 };
  const dash = "─";
  const head = amortize
    ? "rank".padStart(4) + "  " + "rule".padEnd(W.rule) + " │ " +
      "ez ms".padStart(W.n) + " │ " + "ez#".padStart(W.count) + " │ note"
    : "rank".padStart(4) + "  " + "rule".padEnd(W.rule) + " │ " +
      "ez ms".padStart(W.n) + " │ " + "ox ms".padStart(W.n) + " │ " +
      "ez/ox".padStart(W.n) + " │ " + "ez#".padStart(W.count) + " │ " +
      "ox#".padStart(W.count) + " │ verdict";
  const rule_w = head.length;

  console.log(dash.repeat(rule_w));
  console.log(head);
  console.log(dash.repeat(rule_w));

  for (let i = 0; i < results.length; i++) {
    const r = results[i];
    const rank = String(i + 1).padStart(4);
    const ezC = r.ezMs.toFixed(1).padStart(W.n);
    if (amortize) {
      const note = r.oxSkipped ? "(unknown to oxlint)" : "";
      const ezN = String(r.ezDiagN ?? 0).padStart(W.count);
      console.log(`${rank}  ${r.ruleId.padEnd(W.rule)} │ ${ezC} │ ${ezN} │ ${note}`);
    } else {
      const oxC = r.oxSkipped ? "skip".padStart(W.n) : r.oxMs.toFixed(1).padStart(W.n);
      const ratioC = r.oxSkipped ? "    -   " : (r.ratio.toFixed(2) + "×").padStart(W.n);
      const ezN = String(r.ezDiagN ?? 0).padStart(W.count);
      const oxN = r.oxSkipped ? "-".padStart(W.count) : String(r.oxDiagN ?? 0).padStart(W.count);
      const verdict = r.oxSkipped ? "(unknown to oxlint)"
                    : r.ratio > 1.0 ? `slower by ${r.ratio.toFixed(1)}×`
                    : `faster by ${(1 / r.ratio).toFixed(1)}×`;
      console.log(`${rank}  ${r.ruleId.padEnd(W.rule)} │ ${ezC} │ ${oxC} │ ${ratioC} │ ${ezN} │ ${oxN} │ verdict`.replace("verdict", verdict));
    }
  }
  console.log(dash.repeat(rule_w));

  if (amortize) {
    const a = results._amortized;
    console.log("");
    console.log(`amortized totals:`);
    console.log(`  ez per-rule sum: parse once + ${rules.length} separate rule runs = ${a.ezTotalMs.toFixed(0)} ms`);
    console.log(`  ez all-in-one:   parse once + 1 runPlugins with all rules    = ${a.ezAllInOneMs.toFixed(0)} ms  ← realistic`);
    console.log(`  oxlint batch:    1 subprocess with ${a.oxKnown} rules        = ${a.oxBatchTotal.toFixed(0)} ms total`);
    console.log(`                   (${a.oxBaseline.toFixed(0)} ms baseline subtracted → ${a.oxPerRuleMs.toFixed(2)} ms/rule avg)`);
    console.log(`  realistic ratio (ez all-in-one / oxlint batch): ${(a.ezAllInOneMs / a.oxBatchTotal).toFixed(2)}×`);
    console.log("");
    // ── Diagnostic counts ─────────────────────────────────────────
    console.log(`diagnostic counts:`);
    console.log(`  ez:     ${a.ezTotalDiags}`);
    if (a.esRuleCount > 0) {
      console.log(`  ESLint: ${a.esTotalDiags}  (${a.esRuleCount}/${rules.length} rules, ${a.esDropped} pruned, ${a.esMs.toFixed(0)} ms)`);
    }
    const oxDelta = a.ezTotalDiags - a.oxTotalDiags;
    console.log(`  oxlint: ${a.oxTotalDiags}${oxDelta === 0 ? "" : `  (ez delta ${oxDelta >= 0 ? "+" : ""}${oxDelta})`}`);
    if (a.diagDeltas.length > 0) {
      const sorted = [...a.diagDeltas].sort((x, y) => {
        const refY = y.es != null ? y.es : y.ox;
        const refX = x.es != null ? x.es : x.ox;
        return Math.abs(y.ez - refY) - Math.abs(x.ez - refX);
      });
      const oracle = a.esRuleCount > 0 ? "ESLint" : "oxlint";
      console.log(`  rules where ez disagrees with ${oracle} (top ${Math.min(10, sorted.length)}):`);
      for (const d of sorted.slice(0, 10)) {
        const ratio = d.ratio === Infinity ? "∞" : d.ratio.toFixed(1) + "×";
        const esCol = d.es != null ? `  es=${d.es}` : "";
        console.log(`    ${d.ruleId.padEnd(50)} ez=${d.ez}${esCol}  ox=${d.ox}  (${ratio})`);
      }
    }
    console.log("");
    // Profile the heaviest ez rule
    const heaviest = results.filter(r => r.ezMs > 0).slice(0, TOP_N);
    if (heaviest.length > 0) {
      console.log(`Top ${heaviest.length} heaviest ez rules (candidates to profile):`);
      for (const r of heaviest) {
        console.log(`  ${r.ruleId}  (ez ${r.ezMs.toFixed(1)} ms${r.oxSkipped ? "  — unknown to oxlint" : ""})`);
      }
      const worst = heaviest[0];
      const profileName = `prof-${worst.ruleId.replace(/\W+/g, "_")}-${filename.replace(/\W+/g, "_")}`;
      console.log(`\nProfile heaviest:`);
      console.log(`  bun --cpu-prof --cpu-prof-md --cpu-prof-name=${profileName} \\`);
      console.log(`      bench/profile_one_rule.js ${worst.ruleId} ${filePath} 20`);
    }
    return;
  }

  // Per-rule mode: pick top N where ez is slower than oxlint.
  const slow = results.filter(r => r.ratio && r.ratio > 1.0).slice(0, TOP_N);
  if (slow.length === 0) {
    console.log(`\nNo rules where ez is slower than oxlint on ${filename}. Try --file checker.ts or --file typescript.js.`);
    return;
  }

  console.log(`\nTop ${slow.length} rules where ez is slower than oxlint:`);
  for (const r of slow) {
    console.log(`  ${r.ruleId}  (ez ${r.ezMs.toFixed(1)} ms vs ox ${r.oxMs.toFixed(1)} ms — ${r.ratio.toFixed(1)}× slower)`);
  }

  const worst = slow[0];
  const profileName = `prof-${worst.ruleId.replace(/\W+/g, "_")}-${filename.replace(/\W+/g, "_")}`;
  console.log(`\nWorst offender: ${worst.ruleId} on ${filename}`);
  console.log(`\nProfile it:`);
  console.log(`  bun --cpu-prof --cpu-prof-md --cpu-prof-name=${profileName} \\`);
  console.log(`      bench/profile_one_rule.js ${worst.ruleId} ${filePath} 20`);
  console.log(`\nThen open ${profileName}.md, identify the hot path, fix, and re-run this script.`);
})();
