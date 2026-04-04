"use strict";
/**
 * Corpus differential: sanz eslint-compat vs ESLint, per-rule breakdown.
 * Only compares rules that sanz successfully loaded.
 */
const { execSync, spawnSync } = require("child_process");
const { ESLint } = require("../js/node_modules/eslint");
const fs = require("fs");
const path = require("path");

const SANZ = path.resolve(__dirname, "../zig-out/bin/sanz");
const RULES_DIR = path.resolve(__dirname, "../js/node_modules/eslint/lib/rules");
const CORPUS = process.argv[2] || path.resolve(__dirname, "../tests/conformance/test262-parser-tests/pass");

async function main() {
  // Step 1: Run sanz, capture per-rule counts and which rules loaded
  console.error("Running sanz...");
  let sanzOut = "";
  try {
    sanzOut = execSync(`"${SANZ}" --lint --eslint-rules="${RULES_DIR}" "${CORPUS}"`, {
      encoding: "utf-8", maxBuffer: 50 * 1024 * 1024,
    });
  } catch (e) { sanzOut = e.stdout || ""; }

  const sanzByRule = {};
  const loadedRules = new Set();
  for (const line of sanzOut.split("\n")) {
    const m = line.match(/:(\d+):\d+: \w+\(([^)]+)\):/);
    if (m) {
      const rule = m[2];
      loadedRules.add(rule);
      sanzByRule[rule] = (sanzByRule[rule] || 0) + 1;
    }
  }

  // Step 2: Run ESLint with only those rules
  console.error(`Running ESLint with ${loadedRules.size} rules sanz loaded...`);
  const rules = {};
  for (const r of loadedRules) rules[r] = "error";

  const linter = new ESLint({
    cwd: CORPUS,
    overrideConfigFile: true,
    overrideConfig: [{
      files: ["**/*.js"],
      languageOptions: { ecmaVersion: 2022, sourceType: "script" },
      rules,
    }],
    ignore: false,
  });

  const results = await linter.lintFiles(".");
  const eslintByRule = {};
  for (const r of results) {
    for (const m of r.messages) {
      if (!m.ruleId || !loadedRules.has(m.ruleId)) continue;
      eslintByRule[m.ruleId] = (eslintByRule[m.ruleId] || 0) + 1;
    }
  }

  // Step 3: Compare
  const allRules = new Set([...Object.keys(sanzByRule), ...Object.keys(eslintByRule)]);
  const rows = [];
  let totalSanz = 0, totalEslint = 0;
  for (const rule of allRules) {
    const s = sanzByRule[rule] || 0;
    const e = eslintByRule[rule] || 0;
    totalSanz += s;
    totalEslint += e;
    rows.push({ rule, sanz: s, eslint: e, diff: s - e });
  }

  // Sort by absolute gap descending
  rows.sort((a, b) => Math.abs(b.diff) - Math.abs(a.diff));

  console.log(`\nCorpus: ${CORPUS}`);
  console.log(`Rules compared: ${allRules.size}`);
  console.log(`Total — Sanz: ${totalSanz}  ESLint: ${totalEslint}  Gap: ${totalEslint - totalSanz} missing\n`);
  console.log(`${"Rule".padEnd(40)} ${"Sanz".padStart(6)} ${"ESLint".padStart(6)} ${"Diff".padStart(7)}`);
  console.log("-".repeat(62));
  for (const r of rows) {
    if (r.sanz === r.eslint) continue; // skip exact matches
    const flag = r.sanz > r.eslint ? "FP+" : "FN-";
    console.log(`${r.rule.padEnd(40)} ${String(r.sanz).padStart(6)} ${String(r.eslint).padStart(6)} ${String(r.diff).padStart(6)} ${flag}`);
  }
}

main().catch(e => { console.error(e); process.exit(1); });
