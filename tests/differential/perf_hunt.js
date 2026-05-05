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

const { runEz, runOxlint } = require(path.join(ROOT, "tests/differential/real_fixtures.js"));

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

  console.log(`perf hunt  —  ${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`rules: ${rules.length}  iters: ${ITERS} (warmup ${WARMUP})`);
  console.log("");

  const results = [];

  for (let i = 0; i < rules.length; i++) {
    const ruleId = rules[i];
    process.stderr.write(`\r  [${i + 1}/${rules.length}] ${ruleId.padEnd(40)}`);

    // Warmup
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
    // Slowdown = ez / oxlint. > 1 means ez is slower; < 1 means ez is faster.
    const ratio = oxMs ? ezMs / oxMs : null;
    results.push({ ruleId, ezMs, oxMs, ratio, oxSkipped });
  }
  process.stderr.write(`\r${" ".repeat(60)}\r`);

  // Sort by ratio descending — slowest ez (vs oxlint) first.
  results.sort((a, b) => {
    if (a.ratio == null && b.ratio == null) return 0;
    if (a.ratio == null) return 1;
    if (b.ratio == null) return -1;
    return b.ratio - a.ratio;
  });

  const W = { rule: 28, n: 8 };
  const dash = "─";
  const head =
    "rank".padStart(4) + "  " + "rule".padEnd(W.rule) + " │ " +
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
    const oxC = r.oxSkipped ? "skip".padStart(W.n) : r.oxMs.toFixed(1).padStart(W.n);
    const ratioC = r.oxSkipped ? "    -   " : (r.ratio.toFixed(2) + "×").padStart(W.n);
    const verdict = r.oxSkipped ? "(unknown to oxlint)"
                  : r.ratio > 1.0 ? `slower by ${r.ratio.toFixed(1)}×`
                  : `faster by ${(1 / r.ratio).toFixed(1)}×`;
    console.log(`${rank}  ${r.ruleId.padEnd(W.rule)} │ ${ezC} │ ${oxC} │ ${ratioC} │ ${verdict}`);
  }
  console.log(dash.repeat(rule_w));

  // Pick top N where ez is slower than oxlint.
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
