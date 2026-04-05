"use strict";

/**
 * Differential test — compares both Sanz backends against ESLint+Espree.
 *
 * For each fixture, runs COMPARABLE_RULES three ways:
 *   espree  — ESLint's own Linter (authoritative reference)
 *   native  — sanz binary (zig-out/bin/sanz --lint)
 *   runner  — sanz parse → eslint-runner visitor dispatch (JS path)
 *
 * Reports false negatives (missed) and false positives (extra) per backend.
 *
 * Run: node tests/differential/run.js [dir|file]
 */

const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

// ── Config ───────────────────────────────────────────────────

const SANZ_BIN = path.resolve(__dirname, "../../zig-out/bin/sanz");
const JS_ROOT   = path.resolve(__dirname, "../../js");
const DEFAULT_DIR = path.resolve(__dirname, "fixtures");

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
  "no-irregular-whitespace", "no-new-symbol", "no-obj-calls",
  "no-prototype-builtins", "no-setter-return",
  "no-template-curly-in-string", "no-useless-catch",
  // Suspicious
  "eqeqeq", "no-cond-assign", "no-control-regex", "no-delete-var",
  "no-empty-character-class", "no-eval", "no-implied-eval",
  "no-label-var", "no-lone-blocks", "no-multi-str",
  "no-new-wrappers", "no-nonoctal-decimal-escape", "no-octal",
  "no-redeclare", "no-regex-spaces", "no-restricted-globals",
  "no-shadow-restricted-names", "no-unsafe-finally",
  "no-unused-labels", "no-useless-escape", "no-void", "no-with",
  "require-yield", "no-case-declarations", "no-sequences",
  "no-throw-literal",
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

// ── Espree (reference) ───────────────────────────────────────

const { Linter } = require(path.join(JS_ROOT, "node_modules/eslint"));
const espree = new Linter();
const _espreeRules = {};
for (const r of COMPARABLE_RULES) _espreeRules[r] = "error";

function runEspree(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  const sourceType = /^(import |export )/m.test(source) ? "module" : "script";
  const messages = espree.verify(source, [{
    languageOptions: { ecmaVersion: 2022, sourceType },
    rules: _espreeRules,
  }], { filename: filePath });
  return messages
    .filter(m => !m.fatal && COMPARABLE_RULES.has(m.ruleId))
    .map(m => ({ rule: m.ruleId, line: m.line }));
}

// ── Native binary ────────────────────────────────────────────

function runNative(filePath) {
  try {
    const out = execSync(`"${SANZ_BIN}" --lint "${filePath}"`,
      { encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] });
    return parseNativeOutput(out);
  } catch (e) {
    return parseNativeOutput(e.stdout || e.stderr || "");
  }
}

function parseNativeOutput(output) {
  const results = [];
  for (const line of output.split("\n")) {
    const m = line.match(/:(\d+):\d+: \w+\(([^)]+)\): (.+)/);
    if (m && COMPARABLE_RULES.has(m[2]))
      results.push({ rule: m[2], line: parseInt(m[1]) });
  }
  return results;
}

// ── ESLint-runner (JS path) ──────────────────────────────────

const { parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins } = require(path.join(JS_ROOT, "eslint-runner"));
const RULES_DIR = path.join(JS_ROOT, "node_modules/eslint/lib/rules");
const tagNames = getTagNames();

// Load only the COMPARABLE_RULES as plugins once.
const _runnerPlugins = [];
for (const ruleName of COMPARABLE_RULES) {
  try {
    const mod = require(path.join(RULES_DIR, `${ruleName}.js`));
    _runnerPlugins.push({
      meta: { name: ruleName, defaultOptions: mod.meta?.defaultOptions },
      create: mod.create,
    });
  } catch { /* rule file not found — skip */ }
}

function runRunner(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  try {
    const ast = parse(source, { filename: filePath });
    const reports = runPlugins(ast, _runnerPlugins, { tagNames });
    const results = [];
    for (const r of reports) {
      if (!r.ruleId || !COMPARABLE_RULES.has(r.ruleId)) continue;
      const line = r.loc?.start?.line ?? r.line;
      if (r.message?.startsWith("Plugin error:"))
        results.push({ rule: r.ruleId, line, crash: r.message });
      else
        results.push({ rule: r.ruleId, line });
    }
    return results;
  } catch (e) {
    return [{ crash: e.message }];
  }
}

// ── Diff helper ──────────────────────────────────────────────

function diff(reference, candidate) {
  const refKeys  = new Set(reference.map(r => `${r.rule}:${r.line}`));
  const candKeys = new Set(candidate.filter(r => !r.crash).map(r => `${r.rule}:${r.line}`));
  const crashes  = candidate.filter(r => r.crash);

  const fn = [...refKeys].filter(k => !candKeys.has(k))
    .map(k => { const [rule, line] = k.split(":"); return { rule, line: +line }; });
  const fp = [...candKeys].filter(k => !refKeys.has(k))
    .map(k => { const [rule, line] = k.split(":"); return { rule, line: +line }; });

  return { fn, fp, crashes };
}

// ── Discover files ───────────────────────────────────────────

function discoverFiles(dir) {
  const files = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) files.push(...discoverFiles(full));
    else if (/\.(js|mjs)$/.test(e.name)) files.push(full);
  }
  return files;
}

// ── Main ─────────────────────────────────────────────────────

const target = process.argv[2] || DEFAULT_DIR;
const files = fs.statSync(target).isDirectory() ? discoverFiles(target) : [target];

if (!fs.existsSync(SANZ_BIN)) {
  console.error(`sanz binary not found at ${SANZ_BIN} — run 'zig build' first`);
  process.exit(1);
}

console.log(`Differential test — ${files.length} fixture(s), ${COMPARABLE_RULES.size} rules\n`);

let anyFail = false;
const nativeTotals = { fn: 0, fp: 0, crash: 0 };
const runnerTotals = { fn: 0, fp: 0, crash: 0 };

for (const file of files) {
  const rel = path.relative(process.cwd(), file);

  const espreeResults = runEspree(file);
  const nativeResults = runNative(file);
  const runnerResults = runRunner(file);

  const nativeDiff = diff(espreeResults, nativeResults);
  const runnerDiff = diff(espreeResults, runnerResults);

  nativeTotals.fn += nativeDiff.fn.length; nativeTotals.fp += nativeDiff.fp.length; nativeTotals.crash += nativeDiff.crashes.length;
  runnerTotals.fn += runnerDiff.fn.length; runnerTotals.fp += runnerDiff.fp.length; runnerTotals.crash += runnerDiff.crashes.length;

  const nativeOk = nativeDiff.fn.length === 0 && nativeDiff.fp.length === 0 && nativeDiff.crashes.length === 0;
  const runnerOk = runnerDiff.fn.length === 0 && runnerDiff.fp.length === 0 && runnerDiff.crashes.length === 0;

  if (nativeOk && runnerOk) {
    console.log(`  ✓ ${rel} (${espreeResults.length} violations, both backends match)`);
    continue;
  }

  anyFail = true;
  console.log(`  ✗ ${rel} (${espreeResults.length} espree violations)`);

  function printDiff(label, { fn, fp, crashes }) {
    if (fn.length === 0 && fp.length === 0 && crashes.length === 0) {
      console.log(`    ${label}: ✓`);
      return;
    }
    for (const { rule, line } of fn)
      console.log(`    ${label} MISS:  ${rule} at line ${line}`);
    for (const { rule, line } of fp)
      console.log(`    ${label} EXTRA: ${rule} at line ${line}`);
    for (const { rule, crash } of crashes)
      console.log(`    ${label} CRASH: ${rule || "?"} — ${crash}`);
  }

  printDiff("native", nativeDiff);
  printDiff("runner", runnerDiff);
}

console.log(`\nnative: ${nativeTotals.fn} FN, ${nativeTotals.fp} FP, ${nativeTotals.crash} crashes`);
console.log(`runner: ${runnerTotals.fn} FN, ${runnerTotals.fp} FP, ${runnerTotals.crash} crashes`);

if (anyFail) process.exit(1);
