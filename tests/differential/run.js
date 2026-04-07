"use strict";

/**
 * Differential test — compares Sanz backends against ESLint+Espree.
 *
 * Two input sources:
 *   1. Fixture files (tests/differential/fixtures/) — all 3 backends
 *      espree (oracle), native Zig binary, JS runner
 *   2. ESLint submodule test cases — espree + runner only
 *      Per-case options and sourceType forwarded to both sides.
 *
 * Flags:
 *   --save-baseline  Write current results as tests/differential/baseline.json
 *   --strict         Fail on any mismatch regardless of baseline
 *   --fixtures-only  Skip corpus extraction
 *   --corpus-only    Skip fixture files
 *   --rule <name>    Run only this rule; show all failing cases with code snippets
 *   --fails          Show code snippets for up to 3 failing cases per rule
 *   --verbose / -v   Show all cases (pass and fail) with details
 *
 * Default: load baseline.json; fail only on new regressions.
 *
 * Run: node tests/differential/run.js [options]
 *      make test-differential
 */

const fs     = require("fs");
const path   = require("path");
const Module = require("module");

// ── Paths ────────────────────────────────────────────────────

const JS_ROOT      = path.resolve(__dirname, "../../js");
const ESLINT_ROOT  = path.resolve(__dirname, "../conformance/eslint");
const FIXTURES_DIR = path.resolve(__dirname, "fixtures");
const BASELINE_FILE = path.resolve(__dirname, "baseline.json");

// ── CLI flags ─────────────────────────────────────────────────

const args         = process.argv.slice(2);
const saveBaseline = args.includes("--save-baseline");
const strict       = args.includes("--strict");
const fixturesOnly = args.includes("--fixtures-only");
const corpusOnly   = args.includes("--corpus-only");
const showFails    = args.includes("--fails") || args.includes("--show-fails");
const verboseAll   = args.includes("--verbose") || args.includes("-v");
const _ruleIdx     = args.indexOf("--rule");
const filterRule   = _ruleIdx >= 0 ? args[_ruleIdx + 1] : null;

const ESPREE_SKIP = Symbol("espree-parse-skip"); // espree couldn't parse → count as skip

// ── Helpers ───────────────────────────────────────────────────

/** Truncate a multi-line code string to N lines, adding ellipsis. */
function truncateCode(code, maxLines = 8) {
  const lines = code.split("\n");
  if (lines.length <= maxLines) return code;
  return lines.slice(0, maxLines).join("\n") + `\n  ... (${lines.length - maxLines} more lines)`;
}

/** Print a code snippet with line numbers, highlighting specific lines. */
function printCodeSnippet(code, highlightLines, indent = "    ") {
  const lines = code.split("\n");
  const hlSet = new Set(highlightLines);
  // Show a window of ±2 lines around each highlighted line
  const toShow = new Set();
  for (const hl of hlSet) {
    for (let i = Math.max(1, hl - 2); i <= Math.min(lines.length, hl + 2); i++) toShow.add(i);
  }
  let prev = -1;
  for (const lineNum of [...toShow].sort((a, b) => a - b)) {
    if (prev >= 0 && lineNum > prev + 1) console.log(indent + "  ...");
    const marker = hlSet.has(lineNum) ? "►" : " ";
    const num = String(lineNum).padStart(3);
    console.log(`${indent}${marker}${num}: ${lines[lineNum - 1]}`);
    prev = lineNum;
  }
}

/** Format a single test-case mismatch for debugging. */
function printCaseDiff(label, code, espreeLines, ourLines, indent = "  ") {
  const espreeSet = new Set(espreeLines);
  const ourSet    = new Set(ourLines);
  const fn = [...espreeSet].filter(l => !ourSet.has(l));
  const fp = [...ourSet].filter(l => !espreeSet.has(l));
  if (fn.length === 0 && fp.length === 0) return;
  console.log(`${indent}${label}`);
  if (fn.length) console.log(`${indent}  ESLint fires at line(s): ${fn.join(", ")} — we MISS`);
  if (fp.length) console.log(`${indent}  We fire at line(s):      ${fp.join(", ")} — ESLint doesn't`);
  printCodeSnippet(code, [...fn, ...fp], indent + "  ");
}

/** Convert a byte offset to a 1-based line number. */
function offsetToLine(source, offset) {
  let line = 1;
  const end = Math.min(offset, source.length);
  for (let i = 0; i < end; i++) {
    if (source.charCodeAt(i) === 10) line++;
  }
  return line;
}

// ── Rules ─────────────────────────────────────────────────────

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

// ── ESLint + Sanz runner setup ────────────────────────────────

const { Linter }                = require(path.join(JS_ROOT, "node_modules/eslint"));
const { parseSource: parse, getTagNames, lintSource: sanzLint, buildNativeConfig } = require(path.join(JS_ROOT, "index"));
const { runPlugins }            = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames                  = getTagNames();
const RULES_DIR_NM              = path.join(JS_ROOT, "node_modules/eslint/lib/rules");

const eslintLinter = new Linter();

// Pre-load runner plugins for fixture-file mode (all rules at once).
const _runnerPlugins = [];
for (const ruleName of COMPARABLE_RULES) {
  try {
    const mod = require(path.join(RULES_DIR_NM, `${ruleName}.js`));
    _runnerPlugins.push({
      meta: { name: ruleName, defaultOptions: mod.meta?.defaultOptions },
      create: mod.create,
    });
  } catch { /* rule file not found */ }
}

// ── Espree (reference) ────────────────────────────────────────

const _espreeRules = {};
for (const r of COMPARABLE_RULES) _espreeRules[r] = "error";

function runEspree(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  const sourceType = /^(import |export )/m.test(source) ? "module" : "script";
  const messages = eslintLinter.verify(source, [{
    languageOptions: { ecmaVersion: 2022, sourceType },
    rules: _espreeRules,
  }], { filename: filePath });
  return messages
    .filter(m => !m.fatal && COMPARABLE_RULES.has(m.ruleId))
    .map(m => ({ rule: m.ruleId, line: m.line }));
}

// Per-rule espree call for corpus mode (forwards per-case options, sourceType, ecmaVersion, JSX).
function runEspreeForRule(src, ruleName, ruleOptions, sourceType, tcLanguageOptions = {}) {
  const ruleEntry = ruleOptions.length > 0 ? ["error", ...ruleOptions] : "error";
  const ecmaVersion = tcLanguageOptions.ecmaVersion ?? 2022;
  const jsxEnabled = !!(tcLanguageOptions.parserOptions?.ecmaFeatures?.jsx);
  const langOpts = { ecmaVersion, sourceType };
  if (jsxEnabled) langOpts.parserOptions = { ecmaFeatures: { jsx: true } };
  try {
    const messages = eslintLinter.verify(src, [{
      languageOptions: langOpts,
      rules: { [ruleName]: ruleEntry },
    // Always use test.js — ESLint flat config doesn't apply rules to .jsx by default,
    // which would cause "No matching configuration found" and empty results.
    // The JSX parser feature is set via parserOptions, not the filename.
    }], { filename: "test.js" });
    // If espree had a fatal parse error the case is unparseable by espree; skip it
    // rather than treating our output as FP (sanz can parse TS/JSX that espree can't).
    if (messages.some(m => m.fatal)) return ESPREE_SKIP;
    return messages
      .filter(m => m.ruleId === ruleName)
      .map(m => ({ rule: m.ruleId, line: m.line }));
  } catch {
    return null;
  }
}

// ── Native (NAPI) ─────────────────────────────────────────────

function runNative(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  try {
    const diags = sanzLint(source, {});
    return diags
      .filter(d => COMPARABLE_RULES.has(d.ruleName))
      .map(d => ({ rule: d.ruleName, line: offsetToLine(source, d.offset) }));
  } catch { return []; }
}

// Run native for a single corpus test case (in-process, no subprocess).
// ruleConfig is a pre-built Uint8Array from buildNativeConfig for the target rule.
// Returns [{rule,line}] on success, "skip" if case is unsupported, null on crash.
function runNativeForCase(code, ruleName, ruleConfig, hasCustomParser, hasOptions) {
  if (hasCustomParser || hasOptions) return "skip";
  try {
    const diags = sanzLint(code, { config: ruleConfig });
    return diags
      .filter(d => d.ruleName === ruleName)
      .map(d => ({ rule: d.ruleName, line: offsetToLine(code, d.offset) }));
  } catch { return null; }
}

// ── ESLint-runner (JS path) ───────────────────────────────────

function runRunner(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  try {
    const sourceType = /^(import |export )/m.test(source) ? "module" : "script";
    const ast = parse(source, { filename: filePath });
    const reports = runPlugins(ast, _runnerPlugins, { tagNames, sourceType });
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

// Per-rule runner call for corpus mode (forwards per-case options, sourceType, JSX mode).
function runRunnerForRule(src, ruleName, ruleModule, ruleOptions, sourceType, tcLanguageOptions = {}) {
  const jsxEnabled = !!(tcLanguageOptions.parserOptions?.ecmaFeatures?.jsx);
  try {
    const ast = parse(src, { filename: jsxEnabled ? "test.jsx" : "test.js" });
    const plugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions },
      create: ruleModule.create,
    };
    const ecmaVersion = tcLanguageOptions.ecmaVersion ?? 2022;
    const reports = runPlugins(ast, [plugin], {
      tagNames, sourceType, ruleConfig: { [ruleName]: ruleOptions }, ecmaVersion,
    });
    return reports
      .filter(r => r.ruleId === ruleName && !r.message?.startsWith("Plugin error:"))
      .map(r => ({ rule: r.ruleId, line: r.loc?.start?.line ?? r.line }));
  } catch {
    return null;
  }
}


// ── Diff helper ───────────────────────────────────────────────

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

// ── File discovery ────────────────────────────────────────────

function discoverFiles(dir) {
  const files = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, e.name);
    if (e.isDirectory()) files.push(...discoverFiles(full));
    else if (/\.(js|mjs)$/.test(e.name)) files.push(full);
  }
  return files;
}

// ── ESLint submodule corpus extraction ────────────────────────
// Intercept Module._load to:
//   - Route rule-tester → CapturingRuleTester (extracts test cases without running them)
//   - Redirect bare imports from ESLint submodule → js/node_modules
//   - Stub custom parsers (@typescript-eslint/parser, fixture parsers)

const CUSTOM_PARSER_STUB = {
  parse() { return { type: "Program", body: [], range: [0, 0] }; }
};

let _captured = null;

class CapturingRuleTester {
  constructor(defaultConfig) { this._config = defaultConfig || {}; }

  run(name, rule, cases) {
    _captured = {
      name,
      defaultConfig: this._config,
      valid:   (cases.valid   || []).map(normalizeCase),
      invalid: (cases.invalid || []).map(normalizeCase),
    };
  }

  static get describe() { return null; }
  static get it()       { return null; }
  static defineRule()   {}
  static setDefaultConfig() {}
}

function normalizeCase(c) {
  if (typeof c === "string") return { code: c, options: [], languageOptions: {}, errors: [], hasCustomParser: false };
  return {
    code:            c.code || "",
    options:         c.options || [],
    languageOptions: c.languageOptions || {},
    errors:          c.errors || [],
    hasCustomParser: !!(c.parser || (c.languageOptions && c.languageOptions.parser)),
  };
}

function installCorpusIntercept() {
  const TESTS_DIR    = path.join(ESLINT_ROOT, "tests/lib/rules");
  const _ruleTestPath = require.resolve(
    path.join(ESLINT_ROOT, "lib/rule-tester/rule-tester")
  );
  const _ESLINT_PREFIX = ESLINT_ROOT + path.sep;
  const _JS_NM         = path.join(JS_ROOT, "node_modules");
  const _origLoad = Module._load;

  Module._load = function (request, parent, isMain) {
    if (parent && parent.filename) {
      try {
        const resolved = Module._resolveFilename(request, parent, isMain);
        if (resolved === _ruleTestPath) return CapturingRuleTester;
      } catch { /* unresolvable */ }

      if (!request.startsWith(".") && !request.startsWith("/")) {
        if (request === "@typescript-eslint/parser" || request.includes("parsers/"))
          return CUSTOM_PARSER_STUB;
        if (parent.filename.startsWith(_ESLINT_PREFIX)) {
          const redirected = path.join(_JS_NM, request);
          try {
            const resolved = Module._resolveFilename(redirected, parent, isMain);
            return _origLoad.call(this, resolved, parent, isMain);
          } catch { /* not in js/node_modules — fall through */ }
        }
      }
    }
    return _origLoad.apply(this, arguments);
  };

  return { TESTS_DIR, _origLoad, restore: () => { Module._load = _origLoad; } };
}

function loadRuleCases(testsDir, ruleName) {
  const testFile = path.join(testsDir, `${ruleName}.js`);
  if (!fs.existsSync(testFile)) return null;
  _captured = null;
  delete require.cache[testFile];
  try { require(testFile); } catch { return null; }
  return _captured;
}

// ── Baseline ──────────────────────────────────────────────────

function loadBaseline() {
  if (saveBaseline || !fs.existsSync(BASELINE_FILE)) return null;
  return JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"));
}

// ── Main ──────────────────────────────────────────────────────

const nativeAvailable = typeof sanzLint === "function";

const baseline = loadBaseline();
const newBaseline = { files: {}, corpus: {} };

let anyRegression = false;
const _startTime = Date.now();

// ── Source 1: Fixture files — all 3 backends ──────────────────

if (!corpusOnly) {
  const files = discoverFiles(FIXTURES_DIR);
  const nativeTotals  = { fn: 0, fp: 0, crash: 0 };
  const runnerTotals  = { fn: 0, fp: 0, crash: 0 };

  console.log(`Fixture files: ${files.length}, ${COMPARABLE_RULES.size} rules\n`);

  for (const file of files) {
    const rel = path.relative(path.resolve(__dirname, "../.."), file);

    const espreeResults = runEspree(file);
    const nativeResults = runNative(file);
    const runnerResults = runRunner(file);

    const nativeDiff = diff(espreeResults, nativeResults);
    const runnerDiff = diff(espreeResults, runnerResults);

    nativeTotals.fn += nativeDiff.fn.length;
    nativeTotals.fp += nativeDiff.fp.length;
    nativeTotals.crash += nativeDiff.crashes.length;
    runnerTotals.fn += runnerDiff.fn.length;
    runnerTotals.fp += runnerDiff.fp.length;
    runnerTotals.crash += runnerDiff.crashes.length;

    newBaseline.files[rel] = {
      native: { fn: nativeDiff.fn.map(r => `${r.rule}:${r.line}`).sort(), fp: nativeDiff.fp.map(r => `${r.rule}:${r.line}`).sort() },
      runner: { fn: runnerDiff.fn.map(r => `${r.rule}:${r.line}`).sort(), fp: runnerDiff.fp.map(r => `${r.rule}:${r.line}`).sort() },
    };

    const basefile  = baseline?.files?.[rel];
    const nativeOk  = !nativeAvailable || (nativeDiff.fn.length === 0 && nativeDiff.fp.length === 0 && nativeDiff.crashes.length === 0);
    const runnerOk  = runnerDiff.fn.length === 0 && runnerDiff.fp.length === 0 && runnerDiff.crashes.length === 0;

    let fileRegression = false;
    if (!strict && basefile) {
      const baseNativeFn = new Set(basefile.native?.fn || []);
      const baseNativeFp = new Set(basefile.native?.fp || []);
      const baseRunnerFn = new Set(basefile.runner?.fn || []);
      const baseRunnerFp = new Set(basefile.runner?.fp || []);
      const newNativeFn  = nativeDiff.fn.filter(r => !baseNativeFn.has(`${r.rule}:${r.line}`));
      const newNativeFp  = nativeDiff.fp.filter(r => !baseNativeFp.has(`${r.rule}:${r.line}`));
      const newRunnerFn  = runnerDiff.fn.filter(r => !baseRunnerFn.has(`${r.rule}:${r.line}`));
      const newRunnerFp  = runnerDiff.fp.filter(r => !baseRunnerFp.has(`${r.rule}:${r.line}`));
      fileRegression = newNativeFn.length > 0 || newNativeFp.length > 0 ||
                       newRunnerFn.length > 0 || newRunnerFp.length > 0 ||
                       nativeDiff.crashes.length > 0 || runnerDiff.crashes.length > 0;
    } else {
      fileRegression = !nativeOk || !runnerOk;
    }

    if (fileRegression) anyRegression = true;

    if (nativeOk && runnerOk) {
      console.log(`  ✓ ${rel} (${espreeResults.length} violations, both backends match)`);
    } else if (!fileRegression) {
      console.log(`  ~ ${rel} (known mismatches in baseline)`);
    } else {
      console.log(`  ✗ ${rel} (${espreeResults.length} espree violations)`);
      function printDiff(label, { fn, fp, crashes }) {
        if (fn.length === 0 && fp.length === 0 && crashes.length === 0) return;
        for (const { rule, line } of fn)   console.log(`    ${label} MISS:  ${rule} at line ${line}`);
        for (const { rule, line } of fp)   console.log(`    ${label} EXTRA: ${rule} at line ${line}`);
        for (const { rule, crash } of crashes) console.log(`    ${label} CRASH: ${rule || "?"} — ${crash}`);
      }
      printDiff("native", nativeDiff);
      printDiff("runner", runnerDiff);
    }
  }

  console.log(`\nnative: ${nativeTotals.fn} FN, ${nativeTotals.fp} FP, ${nativeTotals.crash} crashes`);
  console.log(`runner: ${runnerTotals.fn} FN, ${runnerTotals.fp} FP, ${runnerTotals.crash} crashes`);
}

// ── Source 2: ESLint submodule corpus — espree + runner + native ──

if (!fixturesOnly && fs.existsSync(ESLINT_ROOT)) {
  const nativeLabel = nativeAvailable ? "espree + runner + native" : "espree + runner";
  console.log(`\nESLint corpus (${COMPARABLE_RULES.size} rules, ${nativeLabel})\n`);

  const { TESTS_DIR, restore } = installCorpusIntercept();
  const RULES_DIR_SUB = path.join(ESLINT_ROOT, "lib/rules");

  // Phase 1: Load all rule cases upfront.
  const allRuleData = [];
  for (const ruleName of COMPARABLE_RULES) {
    const cases = loadRuleCases(TESTS_DIR, ruleName);
    if (!cases) continue;
    const ruleModule = (() => {
      try { return require(path.join(RULES_DIR_SUB, `${ruleName}.js`)); } catch { return null; }
    })();
    if (!ruleModule) continue;
    const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
    const allCases = [...cases.valid, ...cases.invalid];
    allRuleData.push({ ruleName, ruleModule, defaultSourceType, allCases });
  }

  // Phase 2: Per-rule analysis (native runs in-process via NAPI, same loop as runner).
  const runnerT0 = Date.now();
  let totalCases = 0, totalPass = 0, totalSkip = 0, totalCrash = 0;
  let totalNativePass = 0, totalNativeFn = 0, totalNativeFp = 0,
      totalNativeSkip = 0, totalNativeCrash = 0;
  let runnerOnlyMs = 0, nativeOnlyMs = 0;

  const _showCases = showFails || verboseAll || filterRule !== null;
  let _processed = 0, _total = allRuleData.reduce((s, r) => s + r.allCases.length, 0);

  for (const { ruleName, ruleModule, defaultSourceType, allCases } of allRuleData) {
    if (filterRule && ruleName !== filterRule) continue;

    // Pre-build native config for this rule (one per rule, reused across cases).
    const nativeRuleConfig = nativeAvailable
      ? buildNativeConfig({ [ruleName]: "warn" })
      : null;

    let fn = 0, fp = 0, crash = 0, pass = 0, skip = 0;
    let nativeFn = 0, nativeFp = 0, nativeCrash = 0, nativePass = 0, nativeSkip = 0;
    // Collect failing cases for --fails / --verbose output
    const failedCases = [];  // { tcIdx, kind:"runner"|"native", espreeLines, ourLines, code }

    for (let tcIdx = 0; tcIdx < allCases.length; tcIdx++) {
      const tc = allCases[tcIdx];
      if (tc.hasCustomParser) { skip++; continue; }
      const sourceType = tc.languageOptions?.sourceType || defaultSourceType;

      // Progress indicator when running all rules (no filter)
      if (!filterRule && !verboseAll && (_processed % 200 === 0)) {
        process.stderr.write(`\r  [${_processed}/${_total}]  ${ruleName}...  \x1B[K`);
      }
      _processed++;

      const espreeResult = runEspreeForRule(tc.code, ruleName, tc.options, sourceType, tc.languageOptions);
      if (espreeResult === ESPREE_SKIP) { skip++; continue; }
      if (espreeResult === null) { crash++; continue; }

      const _rt0 = Date.now();
      const runnerResult = runRunnerForRule(tc.code, ruleName, ruleModule, tc.options, sourceType, tc.languageOptions);
      runnerOnlyMs += Date.now() - _rt0;
      if (runnerResult === null) { crash++; continue; }

      const espreeKeys = new Set(espreeResult.map(r => `${r.rule}:${r.line}`));
      const runnerKeys = new Set(runnerResult.map(r => `${r.rule}:${r.line}`));
      const caseFn = [...espreeKeys].filter(k => !runnerKeys.has(k)).length;
      const caseFp = [...runnerKeys].filter(k => !espreeKeys.has(k)).length;

      if (caseFn === 0 && caseFp === 0) {
        pass++;
        if (verboseAll && _showCases) {
          const diags = espreeResult.map(r => r.line);
          console.log(`    [${tcIdx}] PASS  diags=${diags.length ? diags.join(",") : "none"}`);
        }
      } else {
        fn += caseFn; fp += caseFp;
        if (_showCases) {
          failedCases.push({
            tcIdx,
            kind: "runner",
            espreeLines: espreeResult.map(r => r.line),
            ourLines:    runnerResult.map(r => r.line),
            code: tc.code,
            options: tc.options,
            sourceType,
          });
        }
      }

      // Native comparison (in-process NAPI call).
      const _nt0 = Date.now();
      const nativeResult = runNativeForCase(tc.code, ruleName, nativeRuleConfig, tc.hasCustomParser, tc.options.length > 0);
      nativeOnlyMs += Date.now() - _nt0;
      if (nativeResult === "skip") {
        nativeSkip++;
      } else if (nativeResult === null) {
        nativeCrash++;
      } else {
        const nativeKeys = new Set(nativeResult.map(r => `${r.rule}:${r.line}`));
        const caseNativeFn = [...espreeKeys].filter(k => !nativeKeys.has(k)).length;
        const caseNativeFp = [...nativeKeys].filter(k => !espreeKeys.has(k)).length;
        if (caseNativeFn === 0 && caseNativeFp === 0) nativePass++;
        else { nativeFn += caseNativeFn; nativeFp += caseNativeFp; }
      }
    }

    const total = pass + fn + fp + crash;
    const nativeTotal = nativePass + nativeFn + nativeFp + nativeCrash;
    totalCases       += total;
    totalPass        += pass;
    totalSkip        += skip;
    totalCrash       += crash;
    totalNativePass  += nativePass;
    totalNativeFn    += nativeFn;
    totalNativeFp    += nativeFp;
    totalNativeSkip  += nativeSkip;
    totalNativeCrash += nativeCrash;

    // Baseline — supports old flat format {fn,fp,crash} and new nested format.
    newBaseline.corpus[ruleName] = {
      runner: { fn, fp, crash },
      native: { fn: nativeFn, fp: nativeFp, crash: nativeCrash, skip: nativeSkip },
    };
    const baseRule   = baseline?.corpus?.[ruleName];
    const baseRunner = baseRule?.runner ?? baseRule ?? null;  // old: flat, new: nested
    const baseNative = baseRule?.native ?? null;

    let ruleRegression = false;
    if (!strict && (baseRunner || baseNative)) {
      if (baseRunner)
        ruleRegression = fn > baseRunner.fn || fp > baseRunner.fp || crash > baseRunner.crash;
      if (nativeAvailable && baseNative)
        ruleRegression = ruleRegression || nativeFn > baseNative.fn || nativeFp > baseNative.fp;
    } else if (strict) {
      ruleRegression = fn > 0 || fp > 0 || crash > 0 ||
                       (nativeAvailable && (nativeFn > 0 || nativeFp > 0));
    }

    if (ruleRegression) anyRegression = true;

    const allClean = (fn + fp + crash) === 0 &&
                     (!nativeAvailable || (nativeFn + nativeFp + nativeCrash) === 0);
    const status = allClean ? "✓" : ruleRegression ? "✗" : "~";

    const runnerDetail = [
      fn    > 0 ? `${fn} FN`       : "",
      fp    > 0 ? `${fp} FP`       : "",
      crash > 0 ? `${crash} crash` : "",
      skip  > 0 ? `${skip} skip`   : "",
    ].filter(Boolean).join(", ");

    if (nativeAvailable) {
      const nativeDetail = [
        nativeFn    > 0 ? `${nativeFn} FN`       : "",
        nativeFp    > 0 ? `${nativeFp} FP`       : "",
        nativeCrash > 0 ? `${nativeCrash} crash` : "",
        nativeSkip  > 0 ? `${nativeSkip} skip`   : "",
      ].filter(Boolean).join(", ");
      const nativeStr = `native ${nativePass}/${nativeTotal}${nativeDetail ? ` (${nativeDetail})` : ""}`;
      console.log(`  ${status} ${ruleName}: runner ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}  ${nativeStr}`);
    } else {
      console.log(`  ${status} ${ruleName}: ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}`);
    }

    // Print failing cases when --fails / --verbose / --rule
    if (failedCases.length > 0 && _showCases) {
      const maxShow = filterRule ? failedCases.length : 3; // show all for --rule, 3 otherwise
      for (let i = 0; i < Math.min(failedCases.length, maxShow); i++) {
        const c = failedCases[i];
        const espreeStr = c.espreeLines.length ? `line(s) ${c.espreeLines.join(",")}` : "nothing";
        const oursStr   = c.ourLines.length    ? `line(s) ${c.ourLines.join(",")}`    : "nothing";
        const opts = c.options.length ? ` options=${JSON.stringify(c.options)}` : "";
        const st   = c.sourceType !== "script" ? ` sourceType=${c.sourceType}` : "";
        console.log(`    [case ${c.tcIdx}${opts}${st}]  ESLint: ${espreeStr}  ours: ${oursStr}`);
        printCodeSnippet(c.code, [...c.espreeLines, ...c.ourLines], "    ");
      }
      if (failedCases.length > maxShow) {
        console.log(`    ... and ${failedCases.length - maxShow} more failing cases (use --rule ${ruleName} to see all)`);
      }
    }
  }
  if (!filterRule && !verboseAll) process.stderr.write("\r\x1B[K"); // clear progress line

  restore();
  const runnerMs = Date.now() - runnerT0;

  if (nativeAvailable) {
    const nativeTotal    = totalNativePass + totalNativeFn + totalNativeFp + totalNativeCrash;
    const runnerCasesSec = runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)).toLocaleString() : "∞";
    const nativeCasesSec = nativeOnlyMs > 0 ? Math.round(nativeTotal / (nativeOnlyMs / 1000)).toLocaleString() : "∞";
    console.log(`\nCorpus runner:  ${totalPass}/${totalCases} pass, ${totalSkip} skipped, ${totalCrash} crashes`);
    console.log(`  linting: ${(runnerOnlyMs/1000).toFixed(2)}s  (${runnerCasesSec} cases/s)`);
    console.log(`Corpus native:  ${totalNativePass}/${nativeTotal} pass, ${totalNativeSkip} skipped, ${totalNativeCrash} crashes`);
    console.log(`  linting: ${(nativeOnlyMs/1000).toFixed(2)}s  (${nativeCasesSec} cases/s)`);
  } else {
    console.log(`\nCorpus: ${totalPass}/${totalCases} pass, ${totalSkip} skipped, ${totalCrash} crashes  (${(runnerMs/1000).toFixed(2)}s)`);
  }
} else if (!fixturesOnly) {
  console.log("\n(ESLint submodule not found — skipping corpus. Run: git submodule update --init tests/conformance/eslint)");
}

// ── Save baseline / exit ──────────────────────────────────────

const elapsed = ((Date.now() - _startTime) / 1000).toFixed(2);
console.log(`\nTotal time: ${elapsed}s`);

if (saveBaseline) {
  fs.writeFileSync(BASELINE_FILE, JSON.stringify(newBaseline, null, 2));
  console.log(`Baseline saved → ${path.relative(path.resolve(__dirname, "../.."), BASELINE_FILE)}`);
} else if (anyRegression) {
  console.log("Regressions detected. Run with --save-baseline to update baseline after intentional changes.");
  process.exit(1);
} else {
  console.log("No regressions.");
}
