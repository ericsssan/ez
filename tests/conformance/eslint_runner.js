"use strict";

/**
 * ESLint rule conformance test.
 *
 * Runs ESLint's own rule test suite (tests/conformance/eslint/tests/lib/rules/)
 * against the sanz eslint-runner, checking that sanz produces the correct
 * number of violations for each valid/invalid test case.
 *
 * For invalid cases: violation count must match errors.length.
 * For valid cases:   zero violations.
 *
 * Run: node tests/conformance/eslint_runner.js [rulename]
 *   node tests/conformance/eslint_runner.js             # all COMPARABLE_RULES
 *   node tests/conformance/eslint_runner.js no-var      # single rule
 */

const path   = require("path");
const fs     = require("fs");
const Module = require("module");

const JS_ROOT      = path.resolve(__dirname, "../../js");
const ESLINT_ROOT  = path.resolve(__dirname, "../conformance/eslint");

// ESLint submodule rules depend on packages (eslint-visitor-keys etc.) that
// live in js/node_modules, not in the submodule's own node_modules.
// Add js/node_modules to the module search path so they resolve correctly.
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));
const RULES_DIR    = path.join(ESLINT_ROOT, "lib/rules");
const TESTS_DIR    = path.join(ESLINT_ROOT, "tests/lib/rules");

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins }         = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames               = getTagNames();

// ── Rules under test ─────────────────────────────────────────────

const COMPARABLE_RULES = new Set([
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
  "eqeqeq", "no-cond-assign", "no-control-regex", "no-delete-var",
  "no-empty-character-class", "no-eval", "no-implied-eval",
  "no-label-var", "no-lone-blocks", "no-multi-str",
  "no-new-wrappers", "no-nonoctal-decimal-escape", "no-octal",
  "no-redeclare", "no-regex-spaces", "no-restricted-globals",
  "no-shadow-restricted-names", "no-unsafe-finally",
  "no-unused-labels", "no-useless-escape", "no-void", "no-with",
  "require-yield", "no-case-declarations", "no-sequences",
  "no-throw-literal",
  "no-var", "prefer-const", "no-array-constructor", "no-bitwise",
  "no-caller", "no-continue", "no-else-return", "no-eq-null",
  "no-extend-native", "no-extra-bind", "no-extra-boolean-cast",
  "no-floating-decimal", "no-iterator", "no-labels", "no-lonely-if",
  "no-multi-assign", "no-negated-condition", "no-nested-ternary",
  "no-new", "no-new-func", "no-new-object", "no-octal-escape",
  "no-param-reassign", "no-plusplus", "no-proto",
  "no-return-assign", "no-unneeded-ternary", "prefer-template",
]);

// ── RuleTester intercept ─────────────────────────────────────────
// ESLint test files require("../../../lib/rule-tester/rule-tester").
// We intercept that require and return a capturing stub so we can
// extract test cases without running mocha/jest infrastructure.

let _captured = null; // set by CapturingRuleTester.run()

class CapturingRuleTester {
  constructor(defaultConfig) {
    this._config = defaultConfig || {};
  }

  run(name, rule, cases) {
    _captured = {
      name,
      rule,
      defaultConfig: this._config,
      valid:   (cases.valid   || []).map(normalizeCase),
      invalid: (cases.invalid || []).map(normalizeCase),
    };
  }

  // ESLint v9+ flat config statics — no-op
  static get describe() { return null; }
  static get it()       { return null; }
  static defineRule()   {}
  static setDefaultConfig() {}
}

function normalizeCase(c) {
  if (typeof c === "string") return { code: c, options: [], languageOptions: {}, errors: [] };
  return {
    code:            c.code || "",
    options:         c.options || [],
    languageOptions: c.languageOptions || {},
    errors:          c.errors || [],
    // parser: present (either old-style c.parser or new c.languageOptions.parser) means
    // non-Espree parser — mark for skip
    hasCustomParser: !!(c.parser || (c.languageOptions && c.languageOptions.parser)),
  };
}

// ── Stub for custom parsers ───────────────────────────────────────
// Some test files inline-require @typescript-eslint/parser or fixture parsers.
// We can't run those cases, but we need the require() to succeed so the test
// file loads.  Return a minimal stub; cases that use it get hasCustomParser=true
// and are skipped.
const CUSTOM_PARSER_STUB = { parse() { return { type: "Program", body: [], range: [0,0] }; } };

// Patch Module._load once for the lifetime of this process.
const _ruleTestPath = require.resolve(
  path.join(ESLINT_ROOT, "lib/rule-tester/rule-tester")
);
const _ESLINT_PREFIX = ESLINT_ROOT + path.sep;
const _JS_NM         = path.join(JS_ROOT, "node_modules");
const _origLoad = Module._load;
Module._load = function (request, parent, isMain) {
  if (parent && parent.filename) {
    // Intercept rule-tester → return CapturingRuleTester
    try {
      const resolved = Module._resolveFilename(request, parent, isMain);
      if (resolved === _ruleTestPath) return CapturingRuleTester;
    } catch { /* unresolvable */ }

    // Intercept bare imports from the ESLint submodule:
    if (!request.startsWith(".") && !request.startsWith("/")) {
      // 1. Custom parsers (e.g. @typescript-eslint/parser, fixture parsers)
      //    that aren't ESLint's own packages → stub them out
      if (request === "@typescript-eslint/parser" ||
          request.includes("parsers/")) {
        return CUSTOM_PARSER_STUB;
      }
      // 2. ESLint submodule's own bare dependencies → redirect to js/node_modules
      if (parent.filename.startsWith(_ESLINT_PREFIX)) {
        const redirected = path.join(_JS_NM, request);
        try {
          const resolved = Module._resolveFilename(redirected, parent, isMain);
          return _origLoad.call(this, resolved, parent, isMain);
        } catch { /* not in js/node_modules either — fall through */ }
      }
    }
  }
  return _origLoad.apply(this, arguments);
};

// ── Load test cases for one rule ─────────────────────────────────

function loadRuleCases(ruleName) {
  const testFile = path.join(TESTS_DIR, `${ruleName}.js`);
  if (!fs.existsSync(testFile)) return null;

  _captured = null;
  // Clear from require cache so it re-runs on each call.
  delete require.cache[testFile];
  // Also clear the rule module cache so helper functions defined in the
  // test file (like error()) are fresh.
  try { require(testFile); } catch { return null; }
  return _captured;
}

// ── Run one test case through sanz ───────────────────────────────

function runCase(ruleName, ruleModule, testCase, sourceType) {
  const src = testCase.code;
  try {
    const ast     = parse(src, { filename: "test.js" });
    const plugin  = {
      meta:   { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions },
      create: ruleModule.create,
    };
    const ruleConfig = { [ruleName]: testCase.options };
    const reports = runPlugins(ast, [plugin], { tagNames, sourceType, ruleConfig });
    return reports.filter(r => !r.message?.startsWith("Plugin error:") && r.ruleId === ruleName);
  } catch {
    return null; // parse failure
  }
}

// ── Main ─────────────────────────────────────────────────────────

const targetArg = process.argv[2];
const rules = targetArg
  ? (COMPARABLE_RULES.has(targetArg) ? [targetArg] : (() => { console.error(`Unknown rule: ${targetArg}`); process.exit(1); })())
  : [...COMPARABLE_RULES];

let totalValid = 0, totalInvalid = 0;
let passValid = 0, passInvalid = 0;
let skipCount = 0, crashCount = 0;

const failDetails = [];

for (const ruleName of rules) {
  const cases = loadRuleCases(ruleName);
  if (!cases) {
    console.log(`  ${ruleName}: no test file`);
    continue;
  }

  const ruleModule = (() => {
    try { return require(path.join(RULES_DIR, `${ruleName}.js`)); } catch { return null; }
  })();
  if (!ruleModule) continue;

  // Determine default sourceType from the RuleTester config
  const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";

  let rulePassV = 0, ruleFailV = 0, rulePassI = 0, ruleFailI = 0, ruleSkip = 0, ruleCrash = 0;

  // Valid cases — expect zero violations
  for (const tc of cases.valid) {
    if (tc.hasCustomParser) { ruleSkip++; skipCount++; continue; }
    const sourceType = tc.languageOptions?.sourceType || defaultSourceType;
    const reports = runCase(ruleName, ruleModule, tc, sourceType);
    totalValid++;
    if (reports === null) { ruleCrash++; crashCount++; continue; }
    if (reports.length === 0) {
      rulePassV++;
      passValid++;
    } else {
      ruleFailV++;
      failDetails.push({ rule: ruleName, kind: "valid", code: tc.code.slice(0, 80), got: reports.length, want: 0 });
    }
  }

  // Invalid cases — expect errors.length violations
  for (const tc of cases.invalid) {
    if (tc.hasCustomParser) { ruleSkip++; skipCount++; continue; }
    const sourceType = tc.languageOptions?.sourceType || defaultSourceType;
    const want = (tc.errors || []).length;
    const reports = runCase(ruleName, ruleModule, tc, sourceType);
    totalInvalid++;
    if (reports === null) { ruleCrash++; crashCount++; continue; }
    if (reports.length === want) {
      rulePassI++;
      passInvalid++;
    } else {
      ruleFailI++;
      failDetails.push({ rule: ruleName, kind: "invalid", code: tc.code.slice(0, 80), got: reports.length, want });
    }
  }

  const total = rulePassV + ruleFailV + rulePassI + ruleFailI;
  const pass  = rulePassV + rulePassI;
  const status = (ruleFailV + ruleFailI + ruleCrash) === 0 ? "✓" : "✗";
  const detail = [
    ruleFailV  > 0 ? `${ruleFailV} valid-FP`    : "",
    ruleFailI  > 0 ? `${ruleFailI} invalid-miss` : "",
    ruleCrash  > 0 ? `${ruleCrash} crash`        : "",
    ruleSkip   > 0 ? `${ruleSkip} skip`          : "",
  ].filter(Boolean).join(", ");
  console.log(`  ${status} ${ruleName}: ${pass}/${total}${detail ? ` (${detail})` : ""}`);
}

const grandTotal = totalValid + totalInvalid;
const grandPass  = passValid  + passInvalid;
console.log(`\nTotal: ${grandPass}/${grandTotal} pass, ${skipCount} skipped, ${crashCount} crashes`);

if (failDetails.length > 0) {
  console.log("\nFailures:");
  for (const { rule, kind, code, got, want } of failDetails.slice(0, 50)) {
    console.log(`  [${rule}] ${kind}: got ${got} want ${want} — ${code.replace(/\n/g, "\\n")}`);
  }
  if (failDetails.length > 50) console.log(`  ... and ${failDetails.length - 50} more`);
}

if (failDetails.length > 0 || crashCount > 0) process.exit(1);
