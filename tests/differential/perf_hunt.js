"use strict";
/**
 * Per-rule perf hunt: find rules where ez is slower than oxlint on a real
 * fixture, sort by slowdown, and emit a ready-to-run CPU-profile command for
 * the worst offender.
 *
 * Workflow:
 *   1. Run this script. It times every rule against the chosen fixture under
 *      both ez and oxlint and prints a sorted table.
 *   2. Copy the suggested `bun --cpu-prof-md ... profile_one_rule.js <rule>`
 *      command for the worst rule.
 *   3. Open the produced markdown profile, find the bottleneck, fix it.
 *   4. Re-run this script to confirm the rule moved up the ranking.
 *
 * Usage:
 *   bun tests/differential/perf_hunt.js
 *   bun tests/differential/perf_hunt.js --file checker.ts
 *   bun tests/differential/perf_hunt.js --rules no-shadow,no-undef
 *   bun tests/differential/perf_hunt.js --all-rules     # every core rule (slow)
 *   bun tests/differential/perf_hunt.js --top 5         # show top 5 worst (default 10)
 */

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "../..");
const FIXTURES_DIR = path.join(ROOT, "bench/fixtures");

const args = process.argv.slice(2);
const _flag = n => args.includes(n);
const _arg  = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };

const ITERS  = parseInt(_arg("--iters", "5"), 10);
const WARMUP = parseInt(_arg("--warmup", "2"), 10);
const TOP_N  = parseInt(_arg("--top", "10"), 10);

// Default to a mid-size fixture so oxlint subprocess startup doesn't dominate.
const fileArg = _arg("--file", "three.js");
const filePath = path.isAbsolute(fileArg) ? fileArg : path.join(FIXTURES_DIR, fileArg);

const DEFAULT_RULES = [
  "no-unused-vars", "no-undef", "no-redeclare", "no-shadow", "no-unreachable",
  "no-cond-assign", "no-empty", "no-fallthrough", "no-extra-boolean-cast",
  "eqeqeq", "prefer-const", "no-var", "no-useless-return",
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

const {
  runEz, runOxlint,
  parseEzOnce, runEzOnAst, runEzAllOnAst,
  runOxlintBatch, runOxlintBaseline,
} = require(path.join(ROOT, "tests/differential/real_fixtures.js"));

// Default to amortized mode when many rules are tested (so `--all-rules`
// finishes in seconds instead of minutes).  `--no-amortize` forces the
// classic per-rule-cold-call mode regardless of count.
const FORCE_AMORTIZE   = _flag("--amortize");
const FORCE_NO_AMORTIZE = _flag("--no-amortize");

function median(arr) {
  if (!arr.length) return 0;
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}

(async () => {
  if (!fs.existsSync(filePath)) {
    console.error(`Missing fixture: ${filePath}`);
    process.exit(1);
  }
  const src = fs.readFileSync(filePath, "utf8");
  const bytes = Buffer.byteLength(src, "utf8");
  const filename = path.basename(filePath);

  // Decide mode: amortized cuts per-rule subprocess + parse cost so
  // `--all-rules` finishes in seconds instead of minutes.  Default: ON
  // when rules.length >= 30, OFF otherwise.
  const amortize = FORCE_NO_AMORTIZE ? false
                : FORCE_AMORTIZE     ? true
                : rules.length >= 30;

  console.log(`perf hunt  —  ${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`rules: ${rules.length}  iters: ${ITERS} (warmup ${WARMUP})  mode: ${amortize ? "amortized" : "per-rule"}`);
  console.log("");

  const results = [];

  if (amortize) {
    // Parse the source ONCE for ez; oxlint runs all rules in one subprocess.
    // Per-rule timings are amortized (divide-by-N approximations) — useful
    // for ranking but not for absolute single-rule cost.

    for (let j = 0; j < WARMUP; j++) {
      const ctx = parseEzOnce(src, filename);
      for (const ruleId of rules) runEzOnAst(ctx, ruleId);
    }

    const ezPerRule = new Map(rules.map(r => [r, []]));
    for (let j = 0; j < ITERS; j++) {
      const ctx = parseEzOnce(src, filename);
      for (let i = 0; i < rules.length; i++) {
        const ruleId = rules[i];
        process.stderr.write(`\r  ez iter ${j + 1}/${ITERS} [${i + 1}/${rules.length}] ${ruleId.padEnd(40)}`);
        const r = runEzOnAst(ctx, ruleId);
        ezPerRule.get(ruleId).push(r.ms);
      }
    }

    for (let j = 0; j < WARMUP; j++) runOxlintBatch(filePath, rules);

    process.stderr.write(`\r${" ".repeat(80)}\r  oxlint baseline ...`);
    const baselineRuns = [];
    for (let j = 0; j < Math.max(WARMUP, 1); j++) baselineRuns.push(runOxlintBaseline(filePath));
    const oxBaseline = median(baselineRuns);
    process.stderr.write(`\r${" ".repeat(80)}\r  oxlint batch (${rules.length} rules) ...`);
    const oxBatchRuns = [];
    let oxKnown = 0;
    for (let j = 0; j < ITERS; j++) {
      const r = runOxlintBatch(filePath, rules);
      oxBatchRuns.push(r.totalMs);
      oxKnown = r.knownCount;
    }
    const oxBatchTotal = median(oxBatchRuns);
    const oxPerRuleMs = oxKnown > 0 ? Math.max(0, oxBatchTotal - oxBaseline) / oxKnown : 0;

    process.stderr.write(`\r${" ".repeat(80)}\r`);

    // Identify which rules oxlint actually knows so we mark unknowns
    // separately rather than smearing them across the per-rule average.
    const oxKnownSet = new Set();
    for (const r of rules) {
      const probe = runOxlint(filePath, r);
      if (!probe.skipped) oxKnownSet.add(r);
    }

    for (const ruleId of rules) {
      const ezMs = median(ezPerRule.get(ruleId));
      const known = oxKnownSet.has(ruleId);
      // In amortized mode the oxlint per-rule average is uniform (= batch
      // total / N) — meaningless for cross-rule ranking.  We surface it as
      // a single footer number and rank by ez time.  Per-rule ratios are
      // suppressed to avoid the misleading "100× slower" artifacts.
      results.push({ ruleId, ezMs, oxMs: null, ratio: null, oxSkipped: known ? null : "unknown-rule" });
    }
    // Bonus: realistic ez throughput — parse once, then run ALL rules in
    // ONE `runPlugins` call (matches real lint).  This avoids the per-rule
    // visitor-map rebuild that inflates the per-rule loop.
    let ezAllInOneMs = 0;
    {
      for (let j = 0; j < WARMUP; j++) {
        const ctx2 = parseEzOnce(src, filename);
        runEzAllOnAst(ctx2, rules);
      }
      const runs = [];
      for (let j = 0; j < ITERS; j++) {
        const ctx2 = parseEzOnce(src, filename);
        runs.push(runEzAllOnAst(ctx2, rules).ms);
      }
      ezAllInOneMs = median(runs);
    }

    // Stash totals for the footer
    results._amortized = { oxBaseline, oxBatchTotal, oxKnown, oxPerRuleMs,
                          ezTotalMs: rules.reduce((s, r) => s + median(ezPerRule.get(r)), 0),
                          ezAllInOneMs };
  } else {
    for (let i = 0; i < rules.length; i++) {
      const ruleId = rules[i];
      process.stderr.write(`\r  [${i + 1}/${rules.length}] ${ruleId.padEnd(40)}`);

      for (let j = 0; j < WARMUP; j++) {
        await runEz(src, ruleId, filename);
        runOxlint(filePath, ruleId);
      }

      const ezTimes = [], oxTimes = [];
      let oxSkipped = null;
      for (let j = 0; j < ITERS; j++) {
        const ez = await runEz(src, ruleId, filename);
        const ox = runOxlint(filePath, ruleId);
        ezTimes.push(ez.ms);
        oxTimes.push(ox.ms);
        if (ox.skipped) oxSkipped = ox.skipped;
      }

      const ezMs = median(ezTimes);
      const oxMs = oxSkipped ? null : median(oxTimes);
      const ratio = oxMs ? ezMs / oxMs : null;
      results.push({ ruleId, ezMs, oxMs, ratio, oxSkipped });
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

  const W = { rule: 28, n: 8 };
  const dash = "─";
  const head = amortize
    ? "rank".padStart(4) + "  " + "rule".padEnd(W.rule) + " │ " +
      "ez ms".padStart(W.n) + " │ note"
    : "rank".padStart(4) + "  " + "rule".padEnd(W.rule) + " │ " +
      "ez ms".padStart(W.n) + " │ " + "ox ms".padStart(W.n) + " │ " +
      "ez/ox".padStart(W.n) + " │ verdict";
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
      console.log(`${rank}  ${r.ruleId.padEnd(W.rule)} │ ${ezC} │ ${note}`);
    } else {
      const oxC = r.oxSkipped ? "skip".padStart(W.n) : r.oxMs.toFixed(1).padStart(W.n);
      const ratioC = r.oxSkipped ? "    -   " : (r.ratio.toFixed(2) + "×").padStart(W.n);
      const verdict = r.oxSkipped ? "(unknown to oxlint)"
                    : r.ratio > 1.0 ? `slower by ${r.ratio.toFixed(1)}×`
                    : `faster by ${(1 / r.ratio).toFixed(1)}×`;
      console.log(`${rank}  ${r.ruleId.padEnd(W.rule)} │ ${ezC} │ ${oxC} │ ${ratioC} │ verdict`.replace("verdict", verdict));
    }
  }
  console.log(dash.repeat(rule_w));

  if (amortize) {
    const a = results._amortized;
    console.log("");
    console.log(`amortized totals (per iter, median of ${ITERS}):`);
    console.log(`  ez per-rule sum: parse once + ${rules.length} separate rule runs = ${a.ezTotalMs.toFixed(0)} ms`);
    console.log(`  ez all-in-one:   parse once + 1 runPlugins with all rules    = ${a.ezAllInOneMs.toFixed(0)} ms  ← realistic`);
    console.log(`  oxlint batch:    1 subprocess with ${a.oxKnown} rules        = ${a.oxBatchTotal.toFixed(0)} ms total`);
    console.log(`                   (${a.oxBaseline.toFixed(0)} ms baseline subtracted → ${a.oxPerRuleMs.toFixed(2)} ms/rule avg)`);
    console.log(`  realistic ratio (ez all-in-one / oxlint batch): ${(a.ezAllInOneMs / a.oxBatchTotal).toFixed(2)}×`);
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
