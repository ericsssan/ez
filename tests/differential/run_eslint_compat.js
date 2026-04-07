"use strict";
/**
 * Differential correctness test — sanz eslint-runner vs real ESLint.
 *
 * For each test file, runs both linters via their JS APIs and compares findings:
 *   - False negatives: ESLint flags, sanz doesn't
 *   - False positives: Sanz flags, ESLint doesn't
 *
 * Baseline mode:
 *   --save-baseline   Save current results as baseline.json (establishes known state)
 *   (default)         Load baseline.json and fail only on REGRESSIONS vs baseline.
 *                     Known mismatches in baseline are tolerated — only new ones fail.
 *   --strict          Fail on any mismatch regardless of baseline.
 *
 * Usage:
 *   node tests/differential/run_eslint_compat.js [--save-baseline] [--strict] [dir|file]
 *
 * Requires:  npm install eslint  (in js/ directory)
 */

const fs   = require("fs");
const path = require("path");

const ROOT    = path.join(__dirname, "../..");
const JS_DIR  = path.join(ROOT, "js");
const BASELINE_FILE = path.join(__dirname, "baseline_eslint_compat.json");

const { parseSource: parse, getTagNames } = require(path.join(JS_DIR, "index"));
const { runPlugins }         = require(path.join(JS_DIR, "eslint-runner"));
const { loadPlugin }         = require(path.join(JS_DIR, "load-plugin"));
const { Linter }             = require(path.join(JS_DIR, "node_modules/eslint"));

const tagNames = getTagNames();

// ── Rules ────────────────────────────────────────────────────────
// Rules where sanz and ESLint should agree exactly.
// Excludes rules that differ by design or known limitations.
const COMPARABLE_RULES = new Set([
  // Correctness
  "no-debugger", "no-empty", "no-extra-semi", "no-dupe-keys",
  "no-dupe-args", "no-sparse-arrays", "no-unreachable",
  "no-unsafe-negation", "use-isnan", "valid-typeof",
  "no-constant-condition", "no-func-assign", "no-import-assign",
  "no-self-assign", "no-self-compare", "no-loss-of-precision",
  "no-const-assign", "no-unsafe-optional-chaining",
  "for-direction", "getter-return", "no-async-promise-executor",
  "no-compare-neg-zero", "no-dupe-class-members", "no-dupe-else-if",
  "no-duplicate-case", "no-empty-pattern", "no-ex-assign",
  "no-fallthrough", "no-global-assign", "no-inner-declarations",
  "no-new-symbol", "no-obj-calls", "no-prototype-builtins",
  "no-setter-return", "no-template-curly-in-string", "no-useless-catch",
  // Suspicious
  "eqeqeq", "no-cond-assign", "no-control-regex", "no-delete-var",
  "no-empty-character-class", "no-eval", "no-implied-eval",
  "no-label-var", "no-lone-blocks", "no-multi-str",
  "no-new-wrappers", "no-nonoctal-decimal-escape", "no-octal",
  "no-redeclare", "no-regex-spaces", "no-shadow-restricted-names",
  "no-unsafe-finally", "no-unused-labels", "no-useless-escape",
  "no-void", "no-with", "require-yield", "no-case-declarations",
  "no-sequences", "no-throw-literal",
  // Style
  "no-var", "prefer-const", "no-array-constructor", "no-bitwise",
  "no-caller", "no-continue", "no-else-return", "no-eq-null",
  "no-extend-native", "no-extra-bind", "no-extra-boolean-cast",
  "no-floating-decimal", "no-iterator", "no-labels", "no-lonely-if",
  "no-multi-assign", "no-negated-condition", "no-nested-ternary",
  "no-new", "no-new-func", "no-new-object", "no-octal-escape",
  "no-param-reassign", "no-plusplus", "no-proto",
  "no-return-assign", "no-unneeded-ternary", "prefer-template",
]);

// ── Build plugin list ─────────────────────────────────────────────

const plugins = loadPlugin("eslint", COMPARABLE_RULES);

// ── ESLint JS API runner ─────────────────────────────────────────

let _linter = null;
function getLinter() {
  if (_linter) return _linter;
  _linter = new Linter({ configType: "flat" });
  return _linter;
}

function runESLint(src, filename) {
  const linter = getLinter();
  const rules = {};
  for (const r of COMPARABLE_RULES) rules[r] = "error";
  const sourceType = /^(import |export )/m.test(src) ? "module" : "script";
  try {
    const messages = linter.verify(src, [{
      languageOptions: { ecmaVersion: 2022, sourceType },
      rules,
    }], { filename });
    return messages
      .filter(m => m.ruleId && COMPARABLE_RULES.has(m.ruleId))
      .map(m => ({ rule: m.ruleId, line: m.line }));
  } catch {
    return [];
  }
}

// ── Sanz runner ──────────────────────────────────────────────────

function runSanz(src, filename) {
  let ast;
  try { ast = parse(src, { filename }); } catch { return []; }

  const reports = [];
  const ctx = { filename, tagNames, onReport(r) { reports.push(r); } };

  // Collect reports via the standard runPlugins return value
  let findings;
  try { findings = runPlugins(ast, plugins, { filename, tagNames }); } catch { return []; }

  return (findings || [])
    .filter(f => f.ruleId && COMPARABLE_RULES.has(f.ruleId) && f.loc)
    .map(f => ({ rule: f.ruleId, line: f.loc.start ? f.loc.start.line : f.loc.line }));
}

// ── Comparison ───────────────────────────────────────────────────

function compare(eslintFindings, sanzFindings) {
  const eslintSet = new Set(eslintFindings.map(f => `${f.rule}:${f.line}`));
  const sanzSet   = new Set(sanzFindings.map(f => `${f.rule}:${f.line}`));

  const falseNeg = [...eslintSet].filter(k => !sanzSet.has(k))
    .map(k => { const [rule, line] = k.split(":"); return { rule, line: +line }; });
  const falsePos = [...sanzSet].filter(k => !eslintSet.has(k))
    .map(k => { const [rule, line] = k.split(":"); return { rule, line: +line }; });

  return { falseNeg, falsePos, matched: eslintSet.size - falseNeg.length };
}

// ── File discovery ────────────────────────────────────────────────

function discoverFiles(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory() && e.name !== "node_modules") out.push(...discoverFiles(full));
    else if (/\.(js|mjs)$/.test(e.name)) out.push(full);
  }
  return out;
}

// ── CLI ───────────────────────────────────────────────────────────

const args         = process.argv.slice(2);
const saveBaseline = args.includes("--save-baseline");
const strict       = args.includes("--strict");
const targetArg    = args.find(a => !a.startsWith("--"))
  || path.join(__dirname, "fixtures");

const files = fs.statSync(targetArg).isDirectory()
  ? discoverFiles(targetArg)
  : [targetArg];

const baseline = (!saveBaseline && fs.existsSync(BASELINE_FILE))
  ? JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"))
  : null;

console.log(`Differential: sanz eslint-runner vs ESLint (${COMPARABLE_RULES.size} rules)`);
console.log(`Files: ${files.length}  Mode: ${saveBaseline ? "save-baseline" : strict ? "strict" : "regression-only"}\n`);

const results = {};
let totalFN = 0, totalFP = 0, totalMatched = 0, regressions = 0;

for (const filePath of files) {
  const src      = fs.readFileSync(filePath, "utf8");
  const rel      = path.relative(ROOT, filePath);
  const eslint   = runESLint(src, filePath);
  const sanz     = runSanz(src, rel);
  const { falseNeg, falsePos, matched } = compare(eslint, sanz);

  results[rel] = {
    falseNeg: falseNeg.map(f => `${f.rule}:${f.line}`).sort(),
    falsePos: falsePos.map(f => `${f.rule}:${f.line}`).sort(),
  };

  totalFN      += falseNeg.length;
  totalFP      += falsePos.length;
  totalMatched += matched;

  // In regression mode, only count new mismatches vs baseline as failures
  const base     = baseline ? (baseline[rel] || { falseNeg: [], falsePos: [] }) : null;
  const baseSet  = base ? new Set([...base.falseNeg, ...base.falsePos]) : null;
  const newFN    = base ? falseNeg.filter(f => !baseSet.has(`${f.rule}:${f.line}`)) : falseNeg;
  const newFP    = base ? falsePos.filter(f => !baseSet.has(`${f.rule}:${f.line}`)) : falsePos;
  const isNew    = newFN.length > 0 || newFP.length > 0;
  const isFail   = strict ? (falseNeg.length > 0 || falsePos.length > 0) : isNew;

  if (isFail) {
    regressions++;
    console.log(`  ✗ ${rel}`);
    for (const { rule, line } of (strict ? falseNeg : newFN))
      console.log(`    MISS  ${rule}:${line}  (ESLint flags, sanz doesn't)`);
    for (const { rule, line } of (strict ? falsePos : newFP))
      console.log(`    EXTRA ${rule}:${line}  (sanz flags, ESLint doesn't)`);
  } else if (falseNeg.length === 0 && falsePos.length === 0) {
    console.log(`  ✓ ${rel}  (${matched} matched)`);
  } else {
    // Known mismatches from baseline — tolerated
    console.log(`  ~ ${rel}  (${matched} matched, ${falseNeg.length} known FN, ${falsePos.length} known FP)`);
  }
}

console.log(`\nResults: ${totalMatched} matched, ${totalFN} false negatives, ${totalFP} false positives`);

if (saveBaseline) {
  fs.writeFileSync(BASELINE_FILE, JSON.stringify(results, null, 2));
  console.log(`Baseline saved → ${path.relative(ROOT, BASELINE_FILE)}`);
} else if (regressions > 0) {
  console.log(`Regressions: ${regressions} file(s) have new mismatches vs baseline.`);
  console.log(`Run with --save-baseline to update baseline after intentional changes.`);
  process.exit(1);
} else {
  console.log("No regressions.");
}
