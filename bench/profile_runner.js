"use strict";
/**
 * CPU profiling harness for eslint-runner.js hot paths.
 *
 * Loads fixture cases from the corpus, runs runPlugins() in-process (no worker
 * pool), does a JIT warm-up pass, then runs enough iterations for a clean sample.
 *
 * Usage:
 *   bun --cpu-prof-md --cpu-prof-name=runner.cpuprofile bench/profile_runner.js
 *   bun --cpu-prof-md bench/profile_runner.js 2>profile.md
 */

const path = require("path");
const fs   = require("fs");

const EZ_ROOT   = path.resolve(__dirname, "..");
const JS_ROOT   = path.join(EZ_ROOT, "js");
const CORPUS    = path.join(EZ_ROOT, "tests/fixtures/extracted/corpus/eslint");

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins, applyDisableDirectives, computeGlobals } = require(path.join(JS_ROOT, "eslint-runner"));
const { setTagNames } = require(path.join(JS_ROOT, "estree-adapter"));

const tagNames = getTagNames();
setTagNames(tagNames);

const ESLINT_RULES_DIR = path.join(JS_ROOT, "node_modules/eslint/lib/rules");

// Rules to include in the profile run — pick heavy, semantically rich ones.
const TARGET_RULES = [
  "no-unused-vars",
  "no-shadow",
  "no-use-before-define",
  "camelcase",
  "array-callback-return",
  "prefer-const",
  "no-redeclare",
  "eqeqeq",
  "no-param-reassign",
];

// Load rule modules once.
const ruleModules = new Map();
for (const name of TARGET_RULES) {
  try {
    const mod = require(path.join(ESLINT_RULES_DIR, `${name}.js`));
    ruleModules.set(name, mod);
  } catch { /* skip */ }
}

// Load fixture cases.
const cases = []; // { code, ruleName, ruleModule, options, sourceType, globals }
for (const ruleName of TARGET_RULES) {
  const f = path.join(CORPUS, ruleName, "_cases.json");
  if (!fs.existsSync(f)) continue;
  const { cases: tc } = JSON.parse(fs.readFileSync(f, "utf8"));
  const mod = ruleModules.get(ruleName);
  if (!mod) continue;
  for (const c of tc) {
    if (c.isTypeScript) continue; // keep to JS for focused profile
    cases.push({
      code: c.code,
      ruleName,
      ruleModule: mod,
      options: c.options || [],
      sourceType: c.sourceType || "script",
      ecmaVersion: c.ecmaVersion || 2022,
    });
  }
}

console.error(`Loaded ${cases.length} cases across ${ruleModules.size} rules`);

// Pre-build stable plugin + array per rule (mirrors lint-worker fix for buildVisitorMap cache).
const rulePlugins = new Map(); // name → { plugin, pluginsArray }
for (const [name, mod] of ruleModules) {
  const plugin = {
    meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
    create: mod.create || mod,
  };
  rulePlugins.set(name, { plugin, pluginsArray: [plugin] });
}

function runOnce(caseList) {
  for (const c of caseList) {
    let ast;
    try {
      ast = parse(c.code, { sourceType: c.sourceType, lang: "js" });
    } catch { continue; }

    const { pluginsArray } = rulePlugins.get(c.ruleName);
    try {
      const reports = runPlugins(ast, pluginsArray, {
        tagNames,
        sourceType: c.sourceType,
        ecmaVersion: c.ecmaVersion,
        ruleConfig: { [c.ruleName]: c.options },
        envGlobals: false,
        filename: "test.js",
        languageOptions: { globals: null, parserOptions: null },
      });
      applyDisableDirectives(c.code, reports.filter(r => !r.crash));
    } catch { /* count as crash, continue */ }
  }
}

// ── Warm-up: 3 passes to let JIT settle ──────────────────────
console.error("Warming up (3 passes)...");
for (let i = 0; i < 3; i++) runOnce(cases);

// ── Timed profiling run: 5 passes ────────────────────────────
console.error("Profiling (5 passes)...");
const t0 = performance.now();
for (let i = 0; i < 5; i++) runOnce(cases);
const elapsed = performance.now() - t0;

const total = cases.length * 5;
console.error(`Done: ${total} case-runs in ${elapsed.toFixed(0)}ms = ${(elapsed / total * 1000).toFixed(1)}µs/case`);
