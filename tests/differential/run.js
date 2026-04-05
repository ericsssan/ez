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
 *
 * Default: load baseline.json; fail only on new regressions.
 *
 * Run: node tests/differential/run.js [options]
 *      make test-differential
 */

const { execSync } = require("child_process");
const fs     = require("fs");
const path   = require("path");
const Module = require("module");

// ── Paths ────────────────────────────────────────────────────

const SANZ_BIN     = path.resolve(__dirname, "../../zig-out/bin/sanz");
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
const { parse, getTagNames }    = require(path.join(JS_ROOT, "index"));
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

// Per-rule espree call for corpus mode (forwards per-case options + sourceType).
function runEspreeForRule(src, ruleName, ruleOptions, sourceType) {
  const ruleEntry = ruleOptions.length > 0 ? ["error", ...ruleOptions] : "error";
  try {
    const messages = eslintLinter.verify(src, [{
      languageOptions: { ecmaVersion: 2022, sourceType },
      rules: { [ruleName]: ruleEntry },
    }], { filename: "test.js" });
    return messages
      .filter(m => m.ruleId === ruleName && !m.fatal)
      .map(m => ({ rule: m.ruleId, line: m.line }));
  } catch {
    return null;
  }
}

// ── Native binary ─────────────────────────────────────────────

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

// Per-rule runner call for corpus mode (forwards per-case options + sourceType).
function runRunnerForRule(src, ruleName, ruleModule, ruleOptions, sourceType) {
  try {
    const ast = parse(src, { filename: "test.js" });
    const plugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions },
      create: ruleModule.create,
    };
    const reports = runPlugins(ast, [plugin], {
      tagNames, sourceType, ruleConfig: { [ruleName]: ruleOptions },
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

if (!corpusOnly && !fs.existsSync(SANZ_BIN)) {
  console.error(`sanz binary not found at ${SANZ_BIN} — run 'make build' first`);
  process.exit(1);
}

const baseline = loadBaseline();
const newBaseline = { files: {}, corpus: {} };

let anyRegression = false;

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
    const nativeOk  = nativeDiff.fn.length === 0 && nativeDiff.fp.length === 0 && nativeDiff.crashes.length === 0;
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

// ── Source 2: ESLint submodule corpus — espree + runner ───────

if (!fixturesOnly && fs.existsSync(ESLINT_ROOT)) {
  console.log(`\nESLint corpus (${COMPARABLE_RULES.size} rules, espree + runner)\n`);

  const { TESTS_DIR, restore } = installCorpusIntercept();
  const RULES_DIR_SUB = path.join(ESLINT_ROOT, "lib/rules");

  let totalCases = 0, totalPass = 0, totalSkip = 0, totalCrash = 0;
  const ruleResults = {}; // ruleName → { fn, fp, crash, total }

  for (const ruleName of COMPARABLE_RULES) {
    const cases = loadRuleCases(TESTS_DIR, ruleName);
    if (!cases) continue;

    const ruleModule = (() => {
      try { return require(path.join(RULES_DIR_SUB, `${ruleName}.js`)); } catch { return null; }
    })();
    if (!ruleModule) continue;

    const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
    let fn = 0, fp = 0, crash = 0, pass = 0, skip = 0;

    for (const tc of [...cases.valid, ...cases.invalid]) {
      if (tc.hasCustomParser) { skip++; continue; }
      const sourceType = tc.languageOptions?.sourceType || defaultSourceType;

      const espreeResult = runEspreeForRule(tc.code, ruleName, tc.options, sourceType);
      if (espreeResult === null) { crash++; continue; }

      const runnerResult = runRunnerForRule(tc.code, ruleName, ruleModule, tc.options, sourceType);
      if (runnerResult === null) { crash++; continue; }

      const espreeKeys = new Set(espreeResult.map(r => `${r.rule}:${r.line}`));
      const runnerKeys = new Set(runnerResult.map(r => `${r.rule}:${r.line}`));
      const caseFn = [...espreeKeys].filter(k => !runnerKeys.has(k)).length;
      const caseFp = [...runnerKeys].filter(k => !espreeKeys.has(k)).length;

      if (caseFn === 0 && caseFp === 0) pass++;
      else { fn += caseFn; fp += caseFp; }
    }

    const total = pass + fn + fp + crash;
    totalCases += total;
    totalPass  += pass;
    totalSkip  += skip;
    totalCrash += crash;

    ruleResults[ruleName] = { fn, fp, crash, total };
    newBaseline.corpus[ruleName] = { fn, fp, crash };

    const baseRule = baseline?.corpus?.[ruleName];
    let ruleRegression = false;
    if (!strict && baseRule) {
      ruleRegression = fn > baseRule.fn || fp > baseRule.fp || crash > baseRule.crash;
    } else if (strict) {
      ruleRegression = fn > 0 || fp > 0 || crash > 0;
    }

    if (ruleRegression) anyRegression = true;

    const status = (fn + fp + crash) === 0 ? "✓"
                 : ruleRegression            ? "✗"
                 : "~";
    const detail = [
      fn    > 0 ? `${fn} FN`    : "",
      fp    > 0 ? `${fp} FP`    : "",
      crash > 0 ? `${crash} crash` : "",
      skip  > 0 ? `${skip} skip`   : "",
    ].filter(Boolean).join(", ");
    console.log(`  ${status} ${ruleName}: ${pass}/${total}${detail ? ` (${detail})` : ""}`);
  }

  restore();

  console.log(`\nCorpus: ${totalPass}/${totalCases} pass, ${totalSkip} skipped, ${totalCrash} crashes`);
} else if (!fixturesOnly) {
  console.log("\n(ESLint submodule not found — skipping corpus. Run: git submodule update --init tests/conformance/eslint)");
}

// ── Save baseline / exit ──────────────────────────────────────

if (saveBaseline) {
  fs.writeFileSync(BASELINE_FILE, JSON.stringify(newBaseline, null, 2));
  console.log(`\nBaseline saved → ${path.relative(path.resolve(__dirname, "../.."), BASELINE_FILE)}`);
} else if (anyRegression) {
  console.log("\nRegressions detected. Run with --save-baseline to update baseline after intentional changes.");
  process.exit(1);
} else {
  console.log("\nNo regressions.");
}
