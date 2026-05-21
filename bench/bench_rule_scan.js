#!/usr/bin/env bun
"use strict";
/**
 * Scan all shared ez/oxlint rules and find where ez is slower.
 *
 * Usage:  bun bench/bench_rule_scan.js
 *
 * Runs in ~45s: no ez warmup (JIT carries over), oxlint timeout 1.2s.
 */

const { execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const { lintSource } = require("../js/api.js");

const FILE    = path.resolve(__dirname, "fixtures/typescript.js");
const OX_TIMEOUT = 1200; // ms — skip rules where oxlint is pathologically slow
const src = fs.readFileSync(FILE, "utf8");
const MB  = src.length / 1024 / 1024;

const RULES = [
  "accessor-pairs","array-callback-return","arrow-body-style","block-scoped-var",
  "capitalized-comments","class-methods-use-this","complexity","constructor-super",
  "curly","default-case","default-case-last","default-param-last","eqeqeq",
  "for-direction","func-names","func-style","getter-return","grouped-accessor-pairs",
  "guard-for-in","id-length","init-declarations","max-classes-per-file","max-depth",
  "max-lines","max-lines-per-function","max-nested-callbacks","max-params",
  "max-statements","new-cap","no-alert","no-array-constructor","no-async-promise-executor",
  "no-await-in-loop","no-bitwise","no-caller","no-case-declarations","no-class-assign",
  "no-compare-neg-zero","no-cond-assign","no-console","no-const-assign",
  "no-constant-binary-expression","no-constant-condition","no-constructor-return",
  "no-continue","no-control-regex","no-debugger","no-delete-var","no-div-regex",
  "no-dupe-class-members","no-dupe-else-if","no-dupe-keys","no-duplicate-case",
  "no-duplicate-imports","no-else-return","no-empty","no-empty-character-class",
  "no-empty-function","no-empty-pattern","no-empty-static-block","no-eq-null",
  "no-eval","no-ex-assign","no-extend-native","no-extra-bind","no-extra-boolean-cast",
  "no-extra-label","no-fallthrough","no-func-assign","no-global-assign",
  "no-implicit-coercion","no-import-assign","no-inline-comments","no-inner-declarations",
  "no-invalid-regexp","no-irregular-whitespace","no-iterator","no-label-var",
  "no-labels","no-lone-blocks","no-lonely-if","no-loop-func","no-loss-of-precision",
  "no-magic-numbers","no-misleading-character-class","no-multi-assign","no-multi-str",
  "no-negated-condition","no-nested-ternary","no-new","no-new-func",
  "no-new-native-nonconstructor","no-new-wrappers","no-nonoctal-decimal-escape",
  "no-obj-calls","no-object-constructor","no-param-reassign","no-plusplus",
  "no-promise-executor-return","no-proto","no-prototype-builtins","no-redeclare",
  "no-regex-spaces","no-restricted-globals","no-restricted-imports","no-return-assign",
  "no-script-url","no-self-assign","no-self-compare","no-sequences","no-setter-return",
  "no-shadow","no-shadow-restricted-names","no-sparse-arrays","no-template-curly-in-string",
  "no-ternary","no-this-before-super","no-throw-literal","no-unassigned-vars",
  "no-undef","no-undefined","no-unexpected-multiline","no-unmodified-loop-condition",
  "no-unneeded-ternary","no-unreachable","no-unsafe-finally","no-unsafe-negation",
  "no-unsafe-optional-chaining","no-unused-expressions","no-unused-labels",
  "no-unused-private-class-members","no-unused-vars","no-use-before-define",
  "no-useless-backreference","no-useless-call","no-useless-catch",
  "no-useless-computed-key","no-useless-concat","no-useless-constructor",
  "no-useless-escape","no-useless-rename","no-useless-return","no-var","no-void",
  "no-warning-comments","no-with","operator-assignment","prefer-const",
  "prefer-destructuring","prefer-exponentiation-operator","prefer-numeric-literals",
  "prefer-object-has-own","prefer-object-spread","prefer-promise-reject-errors",
  "prefer-rest-params","prefer-spread","prefer-template","preserve-caught-error",
  "radix","require-await","require-yield","sort-imports","sort-keys","sort-vars",
  "symbol-description","unicode-bom","use-isnan","valid-typeof","vars-on-top","yoda",
];

// Measure oxlint startup: 3 serial probes on /dev/null, take median.
function measureStartup() {
  const args = ["--threads=1", "-A", "all", "/dev/null"];
  const t = () => {
    const s = performance.now();
    try { execFileSync("oxlint", args, { stdio: "ignore" }); } catch {}
    return performance.now() - s;
  };
  const times = [t(), t(), t()].sort((a, b) => a - b);
  return times[1];
}

function timeOx(rule) {
  const args = ["--threads=1", "-A", "all", "-D", rule, FILE];
  const t = performance.now();
  try { execFileSync("oxlint", args, { stdio: "ignore", timeout: OX_TIMEOUT }); }
  catch (e) {
    if (e.signal === "SIGTERM" || e.killed) return null; // timed out
  }
  return performance.now() - t;
}

(async () => {
  process.stderr.write(`file: ${path.basename(FILE)} (${MB.toFixed(2)} MB)  ox_timeout: ${OX_TIMEOUT}ms\n`);
  process.stderr.write("measuring oxlint startup...\n");
  const startupMs = measureStartup();
  process.stderr.write(`oxlint startup: ${startupMs.toFixed(1)} ms\n\n`);

  // Warm ez JIT with baseline (also serves as ez parse-only baseline).
  // Must have a non-empty rules object so api.js doesn't load all 294 core rules.
  const baseCfg = { filename: FILE, rules: { "__ez_scan_noop__": "error" } };
  process.stderr.write("warming ez JIT + measuring baseline...\n");
  await lintSource(src, baseCfg); // first: triggers NAPI init + JIT entry
  const bt = performance.now();
  await lintSource(src, baseCfg);
  const ezBaseline = performance.now() - bt;
  process.stderr.write(`ez baseline: ${ezBaseline.toFixed(1)} ms\n\n`);

  const results = [];
  const start = performance.now();
  for (let i = 0; i < RULES.length; i++) {
    const rule = RULES[i];
    const elapsed = ((performance.now() - start) / 1000).toFixed(0);
    process.stderr.write(`[${String(i + 1).padStart(3)}/${RULES.length}] ${elapsed}s  ${rule.padEnd(44)}\r`);

    // ez: 1 run, no warmup (JIT already warm from baseline + prior rules)
    const ezCfg = { filename: FILE, rules: { [rule]: "error" } };
    const ezT = performance.now();
    await lintSource(src, ezCfg);
    const ezMs = Math.max(0, (performance.now() - ezT) - ezBaseline);

    // oxlint: 1 run with timeout
    const oxRaw = timeOx(rule);
    const oxMs  = oxRaw === null ? null : Math.max(0, oxRaw - startupMs);

    const ratio = (oxMs !== null && oxMs > 1) ? ezMs / oxMs : null;
    results.push({ rule, ezMs, oxMs: oxMs ?? -1, ratio, timedOut: oxRaw === null });
  }
  const totalSec = ((performance.now() - start) / 1000).toFixed(1);
  process.stderr.write(`\n\ndone in ${totalSec}s\n\n`);

  const valid = results.filter(r => r.ratio !== null);
  valid.sort((a, b) => b.ratio - a.ratio);

  console.log(`baselines subtracted — ez: -${ezBaseline.toFixed(1)}ms  oxlint: -${startupMs.toFixed(1)}ms startup\n`);
  console.log(`${"rule".padEnd(42)} ${"ez net".padStart(9)} ${"ox net".padStart(9)} ${"ratio".padStart(7)}`);
  console.log("-".repeat(72));
  for (const r of valid) {
    const flag = r.ratio > 2 ? " <<" : r.ratio > 1.3 ? " <" : "";
    console.log(`${r.rule.padEnd(42)} ${(r.ezMs.toFixed(1)+"ms").padStart(9)} ${(r.oxMs.toFixed(1)+"ms").padStart(9)} ${(r.ratio.toFixed(2)+"×").padStart(7)}${flag}`);
  }

  const timedOut = results.filter(r => r.timedOut);
  if (timedOut.length) {
    console.log(`\nskipped (oxlint >${OX_TIMEOUT}ms): ${timedOut.map(r => r.rule).join(", ")}`);
  }
  const slower = valid.filter(r => r.ratio > 1.3);
  console.log(`\nez slower (>1.3×): ${slower.length} / ${valid.length} rules`);
  if (slower.length) {
    console.log("top targets:", slower.slice(0, 8).map(r => `${r.rule}(${r.ratio.toFixed(1)}×)`).join("  "));
  }
})().catch(e => { console.error(e); process.exit(1); });
