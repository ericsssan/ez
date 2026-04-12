"use strict";

if (typeof Bun === "undefined") {
  process.stderr.write("error: run.js requires Bun. Use: bun tests/differential/run.js\n");
  process.exit(1);
}

/**
 * Differential test — compares Ez backends against ESLint+Espree.
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
 * Run: bun tests/differential/run.js [options]
 *      make test-differential
 */

const fs   = require("fs");
const path = require("path");

// ── Paths ────────────────────────────────────────────────────

const JS_ROOT      = path.resolve(__dirname, "../../js");
const ESLINT_ROOT  = path.resolve(__dirname, "../conformance/eslint");
const FIXTURES_DIR = path.resolve(__dirname, "fixtures");
const BASELINE_FILE = path.resolve(__dirname, "baseline.json");

// ── Bun plugin stubs ─────────────────────────────────────────
// Intercept module resolution for test framework packages so that
// importing plugin test files captures their valid/invalid cases
// instead of running a real test suite.
//
// build.module() registers virtual modules that win over any local
// node_modules/ for both CJS require() and ESM import() from any
// subdirectory.  This handles plugins that ship their own eslint
// (e.g. jsdoc) without needing per-plugin guards.
//
// Note: require(absolute_path) bypasses build.module interception,
// so the eslintLinter below (loaded via absolute JS_ROOT path) stays real.
const { plugin: _bunPlugin } = require("bun");
_bunPlugin({
  name: "ez-capture",
  setup(build) {
    // Version strings used in package.json stubs — bumped high so semver
    // checks in plugin test helpers (e.g. `eslint >= 9`) always pass.
    const ESLINT_VERSION  = "9.99.0";
    const PARSER_VERSION  = "99.0.0";
    // Parser packages that react/promise/unicorn test files try to require.
    const PARSER_PACKAGES = ["@typescript-eslint/parser", "typescript-eslint-parser", "babel-eslint", "@babel/eslint-parser"];

    // ── eslint stub ───────────────────────────────────────────
    // ESM syntax: provides `default` export for jsdoc's `import eslint from 'eslint'`
    // and named exports accessible via CJS `require('eslint').RuleTester`.
    // CJS/ESM conflict is handled by the `require("eslint")` pre-load below setup().
    // RuleTester.run() delegates to __EZ_CAPTURE__ for case capture.
    build.module("eslint", () => ({
      loader: "js",
      contents: `
class RuleTester {
  constructor(config) { this._config = config || {}; }
  run(name, rule, cases) { if (typeof global.__EZ_CAPTURE__ === "function") global.__EZ_CAPTURE__(name, rule, cases, this._config); }
  static get describe() { return null; }
  static get it()       { return null; }
}
export { RuleTester };
export const Linter = class {};
export const ESLint = class {};
export default { RuleTester, Linter, ESLint };
`,
    }));
    build.module("eslint/package.json", () => ({
      loader: "js",
      // Named exports so CJS `require('eslint/package.json').version` works.
      // (CJS require of an ESM module gets named exports directly, not default.)
      contents: `export const name = "eslint"; export const version = "${ESLINT_VERSION}"; export default { name: "eslint", version: "${ESLINT_VERSION}" };`,
    }));

    // ── ava + eslint-ava-rule-tester stubs (unicorn ESM tests) ───
    // ESM syntax so `import test from 'ava'` and
    // `import RuleTester from 'eslint-ava-rule-tester'` get proper default exports.
    build.module("ava", () => ({
      loader: "js",
      contents: `
const avaStub = Object.assign(function avaStub() {}, {
  before: () => {}, after: () => {}, beforeEach: () => {}, afterEach: () => {},
  serial: () => {}, skip: () => {}, failing: () => {}, only: () => {},
});
export default avaStub;
`,
    }));

    build.module("eslint-ava-rule-tester", () => ({
      loader: "js",
      contents: `
export default class FakeAvaRuleTester {
  constructor(_t, config) { this._config = config || {}; }
  run(name, rule, cases) { if (typeof global.__EZ_CAPTURE__ === "function") global.__EZ_CAPTURE__(name, rule, cases, this._config); }
}
`,
    }));

    // ── parser stubs ──────────────────────────────────────────
    // ESM syntax with named + default exports for compatibility with both
    // CJS require() and ESM import() from react/promise/unicorn test files.
    const parserContents = `
const parser = { parse() { return { type: "Program", body: [], range: [0, 0] }; } };
export default parser;
export const parse = parser.parse;
`;
    for (const pkg of PARSER_PACKAGES) {
      build.module(pkg, () => ({ loader: "js", contents: parserContents }));
      build.module(`${pkg}/package.json`, () => ({ loader: "js", contents: `export const version = "${PARSER_VERSION}"; export default { version: "${PARSER_VERSION}" };` }));
    }

    // typescript-eslint — used by jsdoc test files (`import { parser } from 'typescript-eslint'`).
    // parseForESLint marks it as a custom parser so cases using it are skipped in comparison.
    build.module("typescript-eslint", () => ({
      loader: "js",
      contents: `
const parser = {
  parse() { return { type: "Program", body: [], range: [0, 0] }; },
  parseForESLint() { return { ast: { type: "Program", body: [], range: [0, 0] }, services: {}, scopeManager: null, visitorKeys: {} }; },
};
export { parser };
export default { parser };
`,
    }));

    // unicorn's snapshot-rule-tester — intercept by filename since it's a local file, not a package
    build.onLoad({ filter: /snapshot-rule-tester\.js$/ }, () => ({
      loader: "js",
      contents: [
        "export default class FakeSnapshotRuleTester {",
        "  constructor(_t, config) { this._config = config || {}; }",
        "  run(name, rule, cases) {",
        "    if (typeof global.__EZ_CAPTURE__ === 'function') global.__EZ_CAPTURE__(name, rule, cases, this._config);",
        "  }",
        "}",
      ].join("\n"),
    }));
  },
});

// Pre-load the eslint stub into CJS require.cache immediately after registration.
// This must happen before any ESM import() (e.g. jsdoc's await import()) runs.
// Sequence: CJS require first → stub in CJS cache → jsdoc's ESM import interops
// with the CJS cache entry rather than creating a fresh ESM registry entry,
// avoiding "Requested module is already fetched" for later CJS require() callers
// (react, promise test files).
require("eslint");

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


// ── Helpers ───────────────────────────────────────────────────

/** Convert camelCase to kebab-case. Used to map test file names to rule names (jsdoc). */
function camelToKebab(str) {
  return str.replace(/[A-Z]/g, c => '-' + c.toLowerCase());
}

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

// Discover ALL available ESLint rules from the installed package.
const COMPARABLE_RULES = new Set(
  fs.readdirSync(path.join(JS_ROOT, "node_modules/eslint/lib/rules"))
    .filter(f => f.endsWith(".js") && !f.startsWith("_") && !f.startsWith("index"))
    .map(f => f.replace(/\.js$/, ""))
);

// ── Third-party plugins — auto-discovered from conformance submodules ────────
// Any git submodule at tests/conformance/eslint-plugin-<name>/ is picked up
// automatically. No code changes needed when adding a new plugin.

const CONFORMANCE_DIR = path.resolve(__dirname, "../conformance");

// Candidate test subdirectory paths, checked in order of preference per plugin convention.
const _TEST_DIR_CANDIDATES = [
  "tests/lib/rules",        // react
  "test/rules/assertions",  // jsdoc
  "__tests__",              // promise
  "test",                   // unicorn
  "tests/rules",
  "tests",
];

// Scan conformance/ for eslint-plugin-* submodule directories.
// Auto-installs devDependencies (bun install --ignore-scripts) when node_modules is absent.
const _discoveredPlugins = fs.existsSync(CONFORMANCE_DIR)
  ? fs.readdirSync(CONFORMANCE_DIR)
      .filter(d => d.startsWith("eslint-plugin-"))
      .map(d => {
        const pluginDir = path.join(CONFORMANCE_DIR, d);
        const prefix = d.replace(/^eslint-plugin-/, "");
        let testFormat = "cjs";
        try {
          const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
          if (pkgJson.type === "module") testFormat = "esm";
        } catch { /* no package.json — assume CJS */ }
        // Auto-install only when node_modules is absent AND require() would fail.
        // We skip plugins whose index.js works without installed deps (react, promise) — installing
        // their devDeps would put a real `eslint` in node_modules and shadow our Bun.plugin stub.
        if (!fs.existsSync(path.join(pluginDir, "node_modules"))) {
          let needsInstall = false;
          try { require(pluginDir); } catch { needsInstall = true; }
          if (needsInstall) {
            process.stderr.write(`info: installing ${d}...\n`);
            const r = Bun.spawnSync(["bun", "install", "--ignore-scripts"], { cwd: pluginDir, stderr: "pipe" });
            if (r.exitCode !== 0) {
              process.stderr.write(`warn: bun install failed for ${d}: ${r.stderr?.toString().trim()}\n`);
            }
          }
        }
        // Find the test directory; cache its file listing to avoid a second readdirSync below.
        let testsDir = null, testsDirFiles = null;
        for (const c of _TEST_DIR_CANDIDATES) {
          const d2 = path.join(pluginDir, c);
          if (fs.existsSync(d2)) {
            const files = fs.readdirSync(d2);
            if (files.some(f => f.endsWith(".js"))) {
              testsDir = d2;
              testsDirFiles = files;
              break;
            }
          }
        }
        // Detect static-export format: test files export { valid, invalid } directly
        // rather than calling RuleTester.run() (e.g. jsdoc vs react/promise/unicorn).
        if (testsDirFiles) {
          const sample = testsDirFiles.find(f => f.endsWith(".js") && f !== "utils.js" && f !== "utils");
          if (sample) {
            const peek = fs.readFileSync(path.join(testsDir, sample), "utf8");
            if (/^\s*export default\b/m.test(peek) && !peek.includes("RuleTester")) {
              testFormat = "static-export";
            }
          }
        }
        return { prefix, pluginDir, testsDir, testFormat };
      })
  : [];

const _pluginRuleModules = new Map(); // fullName → { create, meta }
const _pluginPackages     = new Map(); // prefix  → loaded plugin package (for _espreePlugins)

for (const { prefix, pluginDir, testsDir, testFormat } of _discoveredPlugins) {
  let pkg = null;
  // CJS plugins: require() resolves via "main".
  // ESM plugins that lack a built CJS dist: fall back to dynamic import() of the ESM entry.
  try { pkg = require(pluginDir); } catch {
    if (testFormat !== "cjs") {
      let esmEntry = null;
      try {
        const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
        const exp = pkgJson.exports?.["."];
        esmEntry = exp?.import?.default ?? exp?.default ?? null;
      } catch { /* ignore */ }
      if (esmEntry) {
        const absEntry = path.join(pluginDir, esmEntry);
        try { pkg = (await import(absEntry)).default; } catch { /* fall through */ }
      }
    }
  }
  if (pkg?.__esModule && pkg.default) pkg = pkg.default;
  if (!pkg) {
    process.stderr.write(`warn: ${path.basename(pluginDir)} could not be loaded\n`);
    continue;
  }
  if (!testsDir) {
    process.stderr.write(`warn: ${path.basename(pluginDir)} loaded but no test directory found (non-standard layout?)\n`);
  }
  _pluginPackages.set(prefix, pkg);
  const rulesMap = pkg.rules || {};
  for (const [name, rule] of Object.entries(rulesMap)) {
    const fullName = `${prefix}/${name}`;
    const create = rule.create || rule;
    if (typeof create !== "function") continue;
    COMPARABLE_RULES.add(fullName);
    _pluginRuleModules.set(fullName, { create, meta: rule.meta || {} });
  }
}

// ── ESLint + Ez runner setup ────────────────────────────────

const { Linter }                = require(path.join(JS_ROOT, "node_modules/eslint"));
const { parseSource: parse, getTagNames, lintSource: ezLint, buildNativeConfig } = require(path.join(JS_ROOT, "index"));
const { runPlugins, computeGlobals, applyDisableDirectives } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames                  = getTagNames();
const RULES_DIR_NM              = path.join(JS_ROOT, "node_modules/eslint/lib/rules");

const eslintLinter = new Linter();

// Timing accumulators for runner breakdown (parse vs plugin).
let _runnerParseMs = 0, _runnerPluginMs = 0;

// Pre-load runner plugins for fixture-file mode (all rules at once).
const _runnerPlugins = [];
for (const ruleName of COMPARABLE_RULES) {
  if (_pluginRuleModules.has(ruleName)) {
    const mod = _pluginRuleModules.get(ruleName);
    _runnerPlugins.push({
      meta: { name: ruleName, defaultOptions: mod.meta?.defaultOptions },
      create: mod.create,
    });
    continue;
  }
  try {
    const mod = require(path.join(RULES_DIR_NM, `${ruleName}.js`));
    _runnerPlugins.push({
      meta: { name: ruleName, defaultOptions: mod.meta?.defaultOptions },
      create: mod.create,
    });
  } catch { /* rule file not found */ }
}

// ── Espree (reference) ────────────────────────────────────────

// Register plugin rules with ESLint Linter so espree can run them.
const _espreePlugins = {};
for (const [prefix, pkg] of _pluginPackages) {
  _espreePlugins[prefix] = pkg;
}

const _espreeRules = {};
for (const r of COMPARABLE_RULES) _espreeRules[r] = "error";

function runEspree(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  const sourceType = /^(import |export )/m.test(source) ? "module" : "script";
  const messages = eslintLinter.verify(source, [{
    plugins: _espreePlugins,
    languageOptions: { ecmaVersion: 2022, sourceType },
    rules: _espreeRules,
  }], { filename: filePath });
  return messages
    .filter(m => !m.fatal && COMPARABLE_RULES.has(m.ruleId))
    .map(m => ({ rule: m.ruleId, line: m.line }));
}


// ── Native (NAPI) ─────────────────────────────────────────────

function runNative(filePath) {
  const source = fs.readFileSync(filePath, "utf-8");
  try {
    const diags = ezLint(source, {});
    return diags
      .filter(d => COMPARABLE_RULES.has(d.ruleName))
      .map(d => ({ rule: d.ruleName, line: offsetToLine(source, d.offset) }));
  } catch { return []; }
}

// Run native for a single corpus test case (in-process, no subprocess).
// ruleConfig is a pre-built Uint8Array from buildNativeConfig for the target rule.
// Returns [{rule,line}] on success, "skip" if case is unsupported, null on crash.
function runNativeForCase(code, ruleName, ruleConfig, hasCustomParser, hasOptions, ruleOptions) {
  if (hasCustomParser) return "skip";
  try {
    // If the case has options, build a config with options embedded
    let config = ruleConfig;
    if (hasOptions && ruleOptions && ruleOptions.length > 0) {
      const optionsObj = {};
      optionsObj[ruleName] = ruleOptions[0]; // first option (usually the options object)
      config = buildNativeConfig({ [ruleName]: "warn" }, optionsObj);
    }
    const diags = ezLint(code, { config });
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
    const globals = computeGlobals(2022, false);
    const ast = parse(source, { filename: filePath, globals });
    const reports = runPlugins(ast, _runnerPlugins, { tagNames, sourceType });
    const results = [];
    for (const r of reports) {
      if (!r.ruleId || !COMPARABLE_RULES.has(r.ruleId)) continue;
      const line = r.loc?.start?.line ?? r.loc?.line ?? r.line;
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
function runRunnerForRule(src, ruleName, ruleModule, ruleOptions, sourceType, tcLanguageOptions = {}, isTypeScript = false) {
  const jsxEnabled = !!(tcLanguageOptions.parserOptions?.ecmaFeatures?.jsx);
  const ext = isTypeScript ? ".ts" : jsxEnabled ? ".jsx" : ".js";
  try {
    const ecmaVersion = tcLanguageOptions.ecmaVersion ?? 2022;
    const baseGlobals = computeGlobals(ecmaVersion, false);
    // Merge test-case globals (e.g., globals.browser for browser env tests)
    const tcGlobals = tcLanguageOptions.globals || null;
    const extraGlobalNames = tcGlobals
      ? Object.entries(tcGlobals).filter(([,v]) => v !== false && v !== 'off').map(([k]) => k)
      : [];
    const globals = extraGlobalNames.length ? [...baseGlobals, ...extraGlobalNames] : baseGlobals;
    const _p0 = Date.now();
    const ast = parse(src, { filename: "test" + ext, globals });
    _runnerParseMs += Date.now() - _p0;
    const plugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions, schema: ruleModule.meta?.schema },
      create: ruleModule.create,
    };
    const _pl0 = Date.now();
    const rawReports = runPlugins(ast, [plugin], {
      tagNames, sourceType, ruleConfig: { [ruleName]: ruleOptions }, ecmaVersion, envGlobals: false,
      languageOptions: { globals: tcGlobals || null, parserOptions: tcLanguageOptions.parserOptions },
    });
    // Apply disable directives — the oracle (ESLint) applies them automatically.
    const reports = applyDisableDirectives(src, rawReports.filter(r => !r.crash));
    // Re-add crashes (they bypass directive suppression).
    const crashReports = rawReports.filter(r => r.crash);
    _runnerPluginMs += Date.now() - _pl0;
    const results = [];
    for (const r of [...reports, ...crashReports]) {
      if (r.ruleId !== ruleName) continue;
      const line = r.loc?.start?.line ?? r.loc?.line ?? r.line;
      if (r.message?.startsWith("Plugin error:")) {
        results.push({ rule: r.ruleId, line, crash: r.message.slice("Plugin error: ".length) });
      } else {
        results.push({ rule: r.ruleId, line });
      }
    }
    return results;
  } catch (e) {
    return [{ crash: e.message }];
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

// ESLint's RuleTester registers rules under this namespace internally.
const _RULE_TO_TEST_PREFIX = "rule-to-test/";

let _captured = null;
// Number of upcoming verify() calls to skip. After the primary capture, RuleTester calls
// verify() once more for each autofix (fix-check) and once per suggestion (suggestion-check).
// All of these operate on the mutated output code, not the original — skip them.
let _linterSkipCalls = 0;

// Returns true when parser is one we handle natively (espree or absent).
function _isNativeParser(parser) {
  if (!parser) return true;
  if (parser?.name === "espree") return true;
  // Espree module object (exported by the 'espree' package): has parse() + latestEcmaVersion.
  // Different installed versions all match this shape, so we don't check by name alone.
  if (typeof parser?.parse === "function" && typeof parser?.latestEcmaVersion === "number") return true;
  return false;
}

function normalizeCase(c, defaultConfig = {}) {
  const defaultLO = defaultConfig.languageOptions || {};
  const defaultHasParser = !_isNativeParser(defaultLO.parser);
  if (typeof c === "string") {
    return {
      code: c,
      options: [],
      languageOptions: defaultLO,
      hasCustomParser: defaultHasParser,
      eslintResult: null,
    };
  }
  const caseLO = c.languageOptions || {};
  // Merge with default (case overrides default)
  const mergedLO = { ...defaultLO, ...caseLO };
  return {
    code:            c.code || "",
    options:         c.options || [],
    languageOptions: mergedLO,
    hasCustomParser: !!(c.parser && !_isNativeParser(c.parser))
      || !!(caseLO.parser && !_isNativeParser(caseLO.parser))
      || defaultHasParser,
    eslintResult: null,  // filled during capture by running real ESLint
  };
}

function installCorpusIntercept() {
  const TESTS_DIR = path.join(ESLINT_ROOT, "tests/lib/rules");

  // ── Plugin path: __EZ_CAPTURE__ (Bun.plugin stubs → here) ─────────────────
  // Called when plugin test files (react/promise/unicorn) are loaded.
  // global.__EZ_CAPTURE_PREFIX__ is set by loadRuleCases() before require/import.
  global.__EZ_CAPTURE__ = (name, rule, cases, defaultConfig = {}) => {
    const prefix   = global.__EZ_CAPTURE_PREFIX__ || null;
    const fullName = prefix ? `${prefix}/${name}` : name;
    const allInputCases = [...(cases.valid || []), ...(cases.invalid || [])];
    for (const c of allInputCases) {
      const tc = normalizeCase(c, defaultConfig);
      if (tc.hasCustomParser) continue;
      const sourceType  = tc.languageOptions?.sourceType  || "script";
      const ecmaVersion = tc.languageOptions?.ecmaVersion ?? 2022;
      const jsxEnabled  = !!(tc.languageOptions?.parserOptions?.ecmaFeatures?.jsx);
      const ruleEntry   = tc.options.length > 0 ? ["error", ...tc.options] : "error";
      const pluginPfx   = fullName.includes("/") ? fullName.split("/")[0] : null;
      const pluginCfg   = pluginPfx && _espreePlugins[pluginPfx]
        ? { [pluginPfx]: _espreePlugins[pluginPfx] } : {};
      const langOpts    = { ecmaVersion, sourceType };
      if (jsxEnabled) langOpts.parserOptions = { ecmaFeatures: { jsx: true } };
      try {
        const messages = eslintLinter.verify(tc.code, [{
          plugins: pluginCfg,
          languageOptions: langOpts,
          rules: { [fullName]: ruleEntry },
        }], { filename: "test.js" });
        if (messages.some(m => m.fatal)) continue; // espree parse error — skip case
        tc.eslintResult = messages
          .filter(m => m.ruleId === fullName && !m.fatal)
          .map(m => ({ rule: fullName, line: m.line }));
      } catch { continue; }
      if (!_captured) _captured = { name: fullName, defaultConfig, cases: [] };
      _captured.cases.push(tc);
    }
  };

  // ── Core rule path: Linter.prototype.verify intercept ─────────────────────
  // For ESLint core tests, we let the REAL RuleTester run (no stub) and intercept
  // verify() on the submodule's own Linter class.  global.__EZ_CAPTURE_RULE__ = "ruleName"
  // activates capture for the currently-loading test file.
  let _linterOrig = null;
  let _SubmoduleLinter = null;
  try {
    _SubmoduleLinter = require(path.join(ESLINT_ROOT, "lib/linter/linter"))?.Linter;
  } catch { /* submodule not present — skip core intercept */ }

  if (_SubmoduleLinter) {
    _linterOrig = _SubmoduleLinter.prototype.verify;
    _SubmoduleLinter.prototype.verify = function patchedVerify(code, config, options) {
      const result = _linterOrig.call(this, code, config, options);
      const ruleName = global.__EZ_CAPTURE_RULE__;
      if (!ruleName) return result;
      // Skip fix-check and suggestion-check calls (they operate on mutated output, not original).
      if (_linterSkipCalls > 0) {
        _linterSkipCalls--;
        return result;
      }
      // `config` is a FlatConfigArray; use getConfig() to get normalized rules+languageOptions.
      // The submodule's RuleTester registers the rule under "rule-to-test/<name>" namespace.
      const filename = typeof options === "string" ? options : (options?.filename ?? "test.js");
      let ruleOptions = [], langOpts = {};
      let fullRuleId = ruleName;
      try {
        const normalized = typeof config.getConfig === "function"
          ? config.getConfig(filename)
          : null;
        if (normalized) {
          // Try "rule-to-test/<name>" (RuleTester's internal namespace) first, then bare name.
          const prefixed = _RULE_TO_TEST_PREFIX + ruleName;
          fullRuleId = normalized.rules?.[prefixed] !== undefined ? prefixed : ruleName;
          const entry = normalized.rules?.[fullRuleId];
          ruleOptions = Array.isArray(entry) ? entry.slice(1) : [];
          if (normalized.languageOptions) langOpts = normalized.languageOptions;
        }
      } catch { /* skip if config extraction fails */ }
      // TypeScript/Babel parsers expose parseForESLint; espree wrapper {parse:fn} does not.
      if (typeof langOpts.parser?.parseForESLint === "function") return result;
      // Single pass: detect fatal parse errors, collect fix flag, and build eslintResult.
      let hasFatal = false, hasFix = false;
      const eslintResult = [];
      for (const m of result) {
        if (m.fatal) { hasFatal = true; continue; }
        if (m.fix) hasFix = true;
        if (m.ruleId === fullRuleId || m.ruleId === ruleName) {
          eslintResult.push({ rule: ruleName, line: m.line }); // short rule name for comparison
        }
      }
      if (hasFatal) return result; // parse error — skip
      const tc = {
        code: typeof code === "string" ? code : "",
        options: ruleOptions,
        languageOptions: langOpts,
        hasCustomParser: false,
        eslintResult,
      };
      if (!_captured) _captured = { name: ruleName, defaultConfig: {}, cases: [] };
      _captured.cases.push(tc);
      // Count upcoming secondary verify() calls to skip:
      // 1 for the fix-check (if any autofix), plus 1 per suggestion across all messages.
      const suggestionCount = result.reduce((n, m) => n + (m.suggestions?.length || 0), 0);
      _linterSkipCalls = (hasFix ? 1 : 0) + suggestionCount;
      return result;
    };
  }

  return {
    TESTS_DIR,
    restore: () => {
      if (_SubmoduleLinter && _linterOrig) _SubmoduleLinter.prototype.verify = _linterOrig;
      delete global.__EZ_CAPTURE__;
      delete global.__EZ_CAPTURE_RULE__;
      delete global.__EZ_CAPTURE_PREFIX__;
    },
  };
}

// testFormat:
//   "cjs"           — require() + RuleTester stub calls __EZ_CAPTURE__ (react, promise, core)
//   "esm"           — import() + RuleTester stub calls __EZ_CAPTURE__ (unicorn)
//   "static-export" — import() + reads export default { valid, invalid } directly (jsdoc)
async function loadRuleCases(testsDir, baseName, { capturePrefix = null, captureRule = null, testFormat = "cjs" } = {}) {
  const testFile = path.join(testsDir, `${baseName}.js`);
  if (!fs.existsSync(testFile)) return null;
  _captured = null;
  _linterSkipCalls = 0;
  global.__EZ_CAPTURE_PREFIX__ = capturePrefix;
  global.__EZ_CAPTURE_RULE__   = captureRule;
  try {
    if (testFormat === "cjs") {
      delete require.cache[testFile];
      try { require(testFile); } catch { /* partial captures ok */ }
    } else {
      const mod = await import(`${testFile}?_ez=${Date.now()}`);
      if (testFormat === "static-export") {
        const testCases = mod.default || mod;
        if (testCases && typeof testCases === "object" && ("valid" in testCases || "invalid" in testCases)) {
          const ruleBaseName = camelToKebab(baseName);
          global.__EZ_CAPTURE__(ruleBaseName, null, testCases, {});
        }
      }
      // "esm": __EZ_CAPTURE__ already called by RuleTester.run() stub during import
    }
  } catch (e) {
    if (filterRule) process.stderr.write(`warn: failed to load ${path.basename(testFile)}: ${e.message}\n`);
    return null;
  } finally {
    global.__EZ_CAPTURE_PREFIX__ = null;
    global.__EZ_CAPTURE_RULE__   = null;
  }
  return _captured;
}

// ── Baseline ──────────────────────────────────────────────────

function loadBaseline() {
  if (saveBaseline || !fs.existsSync(BASELINE_FILE)) return null;
  return JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"));
}

// ── Main ──────────────────────────────────────────────────────

const nativeAvailable = typeof ezLint === "function";

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

// Wrapped in async IIFE so unicorn ESM test files can be loaded with await import().
(async () => {
if (!fixturesOnly && fs.existsSync(ESLINT_ROOT)) {
  const nativeLabel = nativeAvailable ? "espree + runner + native" : "espree + runner";
  console.log(`\nESLint corpus (${COMPARABLE_RULES.size} rules, ${nativeLabel})\n`);

  const { TESTS_DIR, restore } = installCorpusIntercept();
  const RULES_DIR_SUB = path.join(ESLINT_ROOT, "lib/rules");

  // Plugin test directories — derived from auto-discovered conformance submodules.
  const PLUGIN_TEST_DIRS = _discoveredPlugins.filter(p => p.testsDir);

  // Phase 1: Load all rule cases upfront.
  const allRuleData = [];

  // 1a: ESLint core rules — real RuleTester runs; Linter.prototype.verify intercept captures cases
  for (const ruleName of COMPARABLE_RULES) {
    if (ruleName.includes("/")) continue; // skip plugin rules here
    const cases = await loadRuleCases(TESTS_DIR, ruleName, { captureRule: ruleName });
    if (!cases) continue;
    const ruleModule = (() => {
      try { return require(path.join(RULES_DIR_SUB, `${ruleName}.js`)); } catch { return null; }
    })();
    if (!ruleModule) continue;
    const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
    const defaultParser = cases.defaultConfig?.languageOptions?.parser;
    const isTypeScript = defaultParser && typeof defaultParser === 'object';
    const allCases = cases.cases;
    allRuleData.push({ ruleName, ruleModule, defaultSourceType, isTypeScript, allCases });
  }

  // 1b: Plugin rules — load test cases from plugin submodule test dirs.
  for (const { prefix, testsDir, testFormat } of PLUGIN_TEST_DIRS) {
    if (!fs.existsSync(testsDir)) continue;
    const testFiles = fs.readdirSync(testsDir).filter(f => f.endsWith(".js") && f !== "utils");
    for (const file of testFiles) {
      const baseName = file.replace(/\.js$/, "");
      // Rule names may be kebab-case (react/promise/unicorn) or mapped from camelCase files (jsdoc).
      // Try direct match first, then camelCase → kebab-case conversion.
      const kebabName = camelToKebab(baseName);
      const fullName     = `${prefix}/${baseName}`;
      const fullNameKebab = `${prefix}/${kebabName}`;
      const ruleModule = _pluginRuleModules.get(fullName) || _pluginRuleModules.get(fullNameKebab);
      if (!ruleModule) continue;
      const canonicalName = _pluginRuleModules.has(fullName) ? fullName : fullNameKebab;
      if (filterRule && canonicalName !== filterRule) continue;
      const cases = await loadRuleCases(testsDir, baseName, { capturePrefix: prefix, testFormat });
      if (!cases) continue;
      const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
      const defaultParser = cases.defaultConfig?.languageOptions?.parser;
      const isTypeScript = defaultParser && typeof defaultParser === 'object';
      const allCases = cases.cases;
      allRuleData.push({ ruleName: canonicalName, ruleModule, defaultSourceType, isTypeScript, allCases });
    }
  }

  // Phase 2: Per-rule analysis (native runs in-process via NAPI, same loop as runner).
  const runnerT0 = Date.now();
  let totalCases = 0, totalPass = 0, totalSkip = 0, totalCrash = 0;
  let totalNativePass = 0, totalNativeFn = 0, totalNativeFp = 0,
      totalNativeSkip = 0, totalNativeCrash = 0;
  let runnerOnlyMs = 0, nativeOnlyMs = 0;

  const _showCases = showFails || verboseAll || filterRule !== null;
  let _processed = 0, _total = allRuleData.reduce((s, r) => s + r.allCases.length, 0);

  for (const { ruleName, ruleModule, defaultSourceType, isTypeScript, allCases } of allRuleData) {
    if (filterRule && ruleName !== filterRule) continue;

    // Pre-build native config for this rule (one per rule, reused across cases).
    const nativeRuleConfig = nativeAvailable
      ? buildNativeConfig({ [ruleName]: "warn" })
      : null;

    let fn = 0, fp = 0, crash = 0, pass = 0, skipCustomParser = 0, skipEspreeParse = 0;
    let nativeFn = 0, nativeFp = 0, nativeCrash = 0, nativePass = 0, nativeSkipOptions = 0;
    // Collect failing cases for --fails / --verbose output
    const failedCases = [];  // { tcIdx, kind:"runner"|"native", espreeLines, ourLines, code }

    for (let tcIdx = 0; tcIdx < allCases.length; tcIdx++) {
      const tc = allCases[tcIdx];
      if (tc.hasCustomParser) { skipCustomParser++; continue; }
      const sourceType = tc.languageOptions?.sourceType || defaultSourceType;

      // Progress indicator when running all rules (no filter)
      if (!filterRule && !verboseAll && (_processed % 200 === 0)) {
        process.stderr.write(`\r  [${_processed}/${_total}]  ${ruleName}...  \x1B[K`);
      }
      _processed++;

      // Oracle: ESLint's actual output, captured during test-file loading.
      // Cases where ESLint couldn't run (parse errors, schema errors) were dropped during capture.
      const espreeResult = tc.eslintResult;
      if (!espreeResult) { skipEspreeParse++; continue; }

      const _rt0 = Date.now();
      const runnerResult = runRunnerForRule(tc.code, ruleName, ruleModule, tc.options, sourceType, tc.languageOptions, isTypeScript);
      runnerOnlyMs += Date.now() - _rt0;
      if (runnerResult === null) { crash++; continue; }

      // Separate crashes from normal results
      const runnerCrashes = runnerResult.filter(r => r.crash);
      const runnerNormal  = runnerResult.filter(r => !r.crash);
      if (runnerCrashes.length > 0) {
        crash += runnerCrashes.length;
        if (_showCases) {
          for (const c of runnerCrashes) {
            failedCases.push({ tcIdx, kind: "crash", crashMsg: c.crash, code: tc.code, options: tc.options, sourceType });
          }
        }
      }

      const espreeKeys = new Set(espreeResult.map(r => `${r.rule}:${r.line}`));
      const runnerKeys = new Set(runnerNormal.map(r => `${r.rule}:${r.line}`));
      const caseFn = [...espreeKeys].filter(k => !runnerKeys.has(k)).length;
      const caseFp = [...runnerKeys].filter(k => !espreeKeys.has(k)).length;

      if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) {
        pass++;
        if (verboseAll && _showCases) {
          const diags = espreeResult.map(r => r.line);
          console.log(`    [${tcIdx}] PASS  diags=${diags.length ? diags.join(",") : "none"}`);
        }
      } else {
        fn += caseFn; fp += caseFp;
        if (_showCases && (caseFn > 0 || caseFp > 0)) {
          failedCases.push({
            tcIdx,
            kind: "runner",
            espreeLines: espreeResult.map(r => r.line),
            ourLines:    runnerNormal.map(r => r.line),
            code: tc.code,
            options: tc.options,
            sourceType,
          });
        }
      }

      // Native comparison (in-process NAPI call).
      const _nt0 = Date.now();
      const nativeResult = runNativeForCase(tc.code, ruleName, nativeRuleConfig, tc.hasCustomParser, tc.options.length > 0, tc.options);
      nativeOnlyMs += Date.now() - _nt0;
      if (nativeResult === "skip") {
        nativeSkipOptions++;
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

    const skip = skipCustomParser + skipEspreeParse;
    const total = pass + fn + fp + crash;
    const nativeTotal = nativePass + nativeFn + nativeFp + nativeCrash;
    totalCases       += total;
    totalPass        += pass;
    totalSkip        += skip;
    totalCrash       += crash;
    totalNativePass  += nativePass;
    totalNativeFn    += nativeFn;
    totalNativeFp    += nativeFp;
    totalNativeSkip  += nativeSkipOptions;
    totalNativeCrash += nativeCrash;

    // Baseline — supports old flat format {fn,fp,crash} and new nested format.
    newBaseline.corpus[ruleName] = {
      runner: { fn, fp, crash },
      native: { fn: nativeFn, fp: nativeFp, crash: nativeCrash, skip: nativeSkipOptions },
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

    const skipDetail = [];
    if (skipCustomParser > 0) skipDetail.push(`${skipCustomParser} custom-parser`);
    if (skipEspreeParse > 0) skipDetail.push(`${skipEspreeParse} eslint-error`);
    const runnerDetail = [
      fn    > 0 ? `${fn} FN`       : "",
      fp    > 0 ? `${fp} FP`       : "",
      crash > 0 ? `${crash} crash` : "",
      skipDetail.length > 0 ? `skip: ${skipDetail.join(", ")}` : "",
    ].filter(Boolean).join(", ");

    if (nativeAvailable) {
      const nativeDetail = [
        nativeFn       > 0 ? `${nativeFn} FN`             : "",
        nativeFp       > 0 ? `${nativeFp} FP`             : "",
        nativeCrash    > 0 ? `${nativeCrash} crash`       : "",
        nativeSkipOptions > 0 ? `${nativeSkipOptions} skip` : "",
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
        if (c.kind === "crash") {
          const opts = c.options?.length ? ` options=${JSON.stringify(c.options)}` : "";
          console.log(`    [case ${c.tcIdx}${opts}]  CRASH: ${c.crashMsg}`);
          printCodeSnippet(c.code, [], "    ");
        } else {
          const espreeStr = c.espreeLines.length ? `line(s) ${c.espreeLines.join(",")}` : "nothing";
          const oursStr   = c.ourLines.length    ? `line(s) ${c.ourLines.join(",")}`    : "nothing";
          const opts = c.options.length ? ` options=${JSON.stringify(c.options)}` : "";
          const st   = c.sourceType !== "script" ? ` sourceType=${c.sourceType}` : "";
          console.log(`    [case ${c.tcIdx}${opts}${st}]  ESLint: ${espreeStr}  ours: ${oursStr}`);
          printCodeSnippet(c.code, [...c.espreeLines, ...c.ourLines], "    ");
        }
      }
      if (failedCases.length > maxShow) {
        console.log(`    ... and ${failedCases.length - maxShow} more failing cases (use --rule ${ruleName} to see all)`);
      }
    }
  }
  if (!filterRule && !verboseAll) process.stderr.write("\r\x1B[K"); // clear progress line

  restore();
  const runnerMs = Date.now() - runnerT0;

  // Top gaps summary — show rules with most remaining failures
  if (!filterRule) {
    const ruleGaps = [];
    for (const [rule, data] of Object.entries(newBaseline.corpus)) {
      const r = data.runner || data;
      const total = (r.fn || 0) + (r.fp || 0) + (r.crash || 0);
      if (total > 0) ruleGaps.push({ rule, fn: r.fn || 0, fp: r.fp || 0, crash: r.crash || 0, total });
    }
    ruleGaps.sort((a, b) => b.total - a.total);
    if (ruleGaps.length > 0) {
      console.log(`\nTop gaps (runner, ${ruleGaps.length} rules with issues):`);
      for (const g of ruleGaps.slice(0, 15)) {
        const parts = [];
        if (g.fn > 0) parts.push(`${g.fn} FN`);
        if (g.fp > 0) parts.push(`${g.fp} FP`);
        if (g.crash > 0) parts.push(`${g.crash} crash`);
        console.log(`  ${String(g.total).padStart(4)}  ${g.rule.padEnd(35)} ${parts.join(", ")}`);
      }
      if (ruleGaps.length > 15) console.log(`  ... and ${ruleGaps.length - 15} more rules`);
    }
  }

  if (nativeAvailable) {
    const nativeTotal    = totalNativePass + totalNativeFn + totalNativeFp + totalNativeCrash;
    const runnerCasesSec = runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)).toLocaleString() : "∞";
    const nativeCasesSec = nativeOnlyMs > 0 ? Math.round(nativeTotal / (nativeOnlyMs / 1000)).toLocaleString() : "∞";
    const runnerPct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    const nativePct = nativeTotal > 0 ? (totalNativePass / nativeTotal * 100).toFixed(1) : "0";
    const runnerGaps = totalCases - totalPass;
    const nativeGaps = nativeTotal - totalNativePass;
    console.log(`\nCorpus runner:  ${totalPass}/${totalCases} pass (${runnerPct}%), ${totalSkip} skipped, ${totalCrash} crashes, ${runnerGaps} gaps`);
    console.log(`  linting: ${(runnerOnlyMs/1000).toFixed(2)}s  (${runnerCasesSec} cases/s)  [parse: ${(_runnerParseMs/1000).toFixed(2)}s, plugin: ${(_runnerPluginMs/1000).toFixed(2)}s]`);
    console.log(`Corpus native:  ${totalNativePass}/${nativeTotal} pass (${nativePct}%), ${totalNativeSkip} skipped, ${totalNativeCrash} crashes, ${nativeGaps} gaps`);
    console.log(`  linting: ${(nativeOnlyMs/1000).toFixed(2)}s  (${nativeCasesSec} cases/s)`);
  } else {
    const pct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    console.log(`\nCorpus: ${totalPass}/${totalCases} pass (${pct}%), ${totalSkip} skipped, ${totalCrash} crashes  (${(runnerMs/1000).toFixed(2)}s)`);
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
})(); // end async IIFE (wraps corpus + summary so unicorn ESM loading can use await)
