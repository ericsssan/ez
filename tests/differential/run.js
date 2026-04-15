"use strict";

if (typeof Bun === "undefined") {
  process.stderr.write("error: run.js requires Bun. Use: bun tests/differential/run.js\n");
  process.exit(1);
}

/**
 * Differential test — compares Ez backends against ESLint+Espree.
 *
 * Input: ESLint submodule test cases + plugin conformance tests.
 * Compares Ez backends (runner, native, hybrid) against ESLint+Espree oracle.
 * Per-case options and sourceType forwarded to both sides.
 *
 * Flags:
 *   --save-baseline  Write current results as tests/differential/baseline.json
 *   --strict         Fail on any mismatch regardless of baseline
 *   --rule <name>    Run only this rule; show all failing cases with code snippets
 *   --fails          Show code snippets for up to 3 failing cases per rule
 *   --verbose / -v   Show all cases (pass and fail) with details
 *   --json           Output results as JSON (for CI/dashboards)
 *   --diff <file>    Compare current baseline with another baseline file
 *   --bench-eslint   A/B timing: run ESLint on every case, report slower/faster rules
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
    const PARSER_VERSION  = "99.0.0";
    const PARSER_PACKAGES = ["@typescript-eslint/parser", "typescript-eslint-parser", "babel-eslint", "@babel/eslint-parser"];

    // ── eslint redirect with stub RuleTester ────────────────────
    // All plugins must use the SAME eslint Linter so our verify() intercept works.
    // Re-export real Linter/ESLint/SourceCode but replace RuleTester with our stub
    // that delegates to __EZ_SILENT_RUN__ for reliable case capture.
    // Real RuleTester has complex fix/suggestion re-verification that doesn't match
    // our capture model — the stub gives consistent single-verify-per-case behavior.
    const ESLINT_PATH = JSON.stringify(path.join(JS_ROOT, "node_modules/eslint"));
    build.module("eslint", () => ({
      loader: "js",
      contents: `
const _eslint = require(${ESLINT_PATH});
class RuleTester {
  constructor(...args) { this._config = typeof args[0] === 'function' ? (args[1] || {}) : (args[0] || {}); }
  run(name, rule, cases) { if (typeof global.__EZ_SILENT_RUN__ === "function") global.__EZ_SILENT_RUN__(new _eslint.Linter(), name, cases, this._config); }
  static get describe() { return null; }
  static get it()       { return null; }
}
export { RuleTester };
export const Linter = _eslint.Linter;
export const ESLint = _eslint.ESLint;
export const SourceCode = _eslint.SourceCode;
export default { RuleTester, Linter: _eslint.Linter, ESLint: _eslint.ESLint, SourceCode: _eslint.SourceCode };
`,
    }));

    // ── ava stub ──────────────────────────────────────────────
    // ava is not installed. Stub as no-op so import doesn't crash.
    build.module("ava", () => ({
      loader: "js",
      contents: `const s = Object.assign(function(){}, { before:()=>{}, after:()=>{}, beforeEach:()=>{}, afterEach:()=>{}, serial:()=>{}, skip:()=>{}, failing:()=>{}, only:()=>{} }); export default s;`,
    }));

    // ── Test framework redirects ────────────────────────────────
    // These frameworks import from 'eslint' — our redirect gives them the stub
    // RuleTester. But they may also have structural differences (extra constructor
    // args, etc.) so re-export the stub from 'eslint' directly.
    build.module("eslint-ava-rule-tester", () => ({ loader: "js", contents: `export { RuleTester as default } from 'eslint';` }));
    build.module("@typescript-eslint/rule-tester", () => ({ loader: "js", contents: `export { RuleTester } from 'eslint'; export { RuleTester as default } from 'eslint';` }));
    build.onLoad({ filter: /snapshot-rule-tester\.js$/ }, () => ({ loader: "js", contents: `export { RuleTester as default } from 'eslint';` }));

    // ── Parser stubs ──────────────────────────────────────────
    // Prevent loading heavy real parsers. Stub parser cases are detected as
    // custom-parser and skipped in comparison.
    const parserContents = `const parser = { parse() { return { type: "Program", body: [], range: [0, 0] }; } }; export default parser; export const parse = parser.parse;`;
    for (const pkg of PARSER_PACKAGES) {
      build.module(pkg, () => ({ loader: "js", contents: parserContents }));
      build.module(`${pkg}/package.json`, () => ({ loader: "js", contents: `export const version = "${PARSER_VERSION}"; export default { version: "${PARSER_VERSION}" };` }));
    }
    // typescript-eslint — jsdoc uses `import { parser } from 'typescript-eslint'`.
    build.module("typescript-eslint", () => ({
      loader: "js",
      contents: `const parser = { parse() { return { type: "Program", body: [], range: [0,0] }; }, parseForESLint() { return { ast: { type: "Program", body: [], range: [0,0] }, services: {}, scopeManager: null, visitorKeys: {} }; } }; export { parser }; export default { parser };`,
    }));

    // ── Source file stubs (avoid loading real TS rule sources) ─
    build.onLoad({ filter: /eslint-plugin[/\\]src[/\\]rules[/\\].+\.ts$/ }, () => ({ loader: "js", contents: `export default {};` }));
    build.onLoad({ filter: /sonarjs-src[/\\].*[/\\](helpers|files)\.(ts|js)$/ }, () => ({ loader: "js", contents: `export default {}; export const normalizePath = (p) => p;` }));
  },
});

// Pre-load eslint redirect into CJS cache so ESM/CJS interop works.
require("eslint");

// ── CLI flags ─────────────────────────────────────────────────

const args         = process.argv.slice(2);
const saveBaseline = args.includes("--save-baseline");
const strict       = args.includes("--strict");
const showFails    = args.includes("--fails") || args.includes("--show-fails");
const verboseAll   = args.includes("--verbose") || args.includes("-v");
const jsonOutput   = args.includes("--json");
const benchEslint  = args.includes("--bench-eslint");
const _ruleIdx     = args.indexOf("--rule");
const filterRule   = _ruleIdx >= 0 ? args[_ruleIdx + 1] : null;
const _diffIdx     = args.indexOf("--diff");
const diffFile     = _diffIdx >= 0 ? args[_diffIdx + 1] : null;


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

/** Apply ESLint-style fix objects to source code. Mirrors api.js applyFixes(). */
function _applyFixes(source, fixes) {
  if (!fixes || fixes.length === 0) return source;
  const sorted = fixes.slice().sort((a, b) => (a.range?.[0] ?? a[0]) - (b.range?.[0] ?? b[0]));
  let result = "", lastIndex = 0;
  for (const fix of sorted) {
    const range = fix.range || [fix[0], fix[1]];
    const text  = fix.text ?? fix[2] ?? "";
    const [start, end] = range;
    if (start < lastIndex) continue; // skip overlapping
    result += source.slice(lastIndex, start) + text;
    lastIndex = end;
  }
  return result + source.slice(lastIndex);
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
  // typescript-eslint: load directly from submodule source (no extraction script needed)
  "typescript-eslint-src/packages/eslint-plugin/tests/rules",
];

// Scan conformance/ for eslint-plugin-* submodule directories.
// Auto-installs devDependencies (bun install --ignore-scripts) when node_modules is absent.
const _discoveredPlugins = fs.existsSync(CONFORMANCE_DIR)
  ? fs.readdirSync(CONFORMANCE_DIR)
      .filter(d => d.startsWith("eslint-plugin-"))
      .map(d => {
        const pluginDir = path.join(CONFORMANCE_DIR, d);
        let prefix = d.replace(/^eslint-plugin-/, "");
        let testFormat = "cjs";
        try {
          const pkgJson = JSON.parse(fs.readFileSync(path.join(pluginDir, "package.json"), "utf8"));
          if (pkgJson.type === "module") testFormat = "esm";
          // Allow conformance package.json to override the prefix (e.g. scoped packages like @typescript-eslint).
          if (pkgJson.prefix) prefix = pkgJson.prefix;
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
            if (files.some(f => f.endsWith(".js") || f.endsWith(".test.ts"))) {
              testsDir = d2;
              testsDirFiles = files;
              break;
            }
          }
        }
        // sonarjs-nested: S*/unit.test.ts layout — each rule lives in its own S<N>/ subdir.
        if (!testsDir) {
          const sonarRulesDir = path.join(pluginDir, "sonarjs-src/packages/analysis/src/jsts/rules");
          if (fs.existsSync(sonarRulesDir)) {
            testsDir = sonarRulesDir;
            testFormat = "sonarjs-nested";
          }
        }
        // Detect static-export format: test files export { valid, invalid } directly
        // rather than calling RuleTester.run() (e.g. jsdoc vs react/promise/unicorn).
        if (testsDirFiles && testFormat !== "sonarjs-nested") {
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
const _pluginPackages     = new Map(); // prefix  → loaded plugin package

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
const { parseSource: parse, getTagNames, lintSource: ezLint, buildNativeConfig, getNativeRules } = require(path.join(JS_ROOT, "index"));
const { runPlugins, computeGlobals, applyDisableDirectives } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames                  = getTagNames();
const RULES_DIR_NM              = path.join(JS_ROOT, "node_modules/eslint/lib/rules");

// @typescript-eslint/parser for oracle: used when test cases specify a TS parser.
// Load by absolute path so the build.module() stub for "@typescript-eslint/parser" is bypassed.
// The stub (used by react/promise/unicorn) lacks parseForESLint, making all TS cases appear custom.
let _tsParser = null;
{
  const _tsParserDist = path.join(CONFORMANCE_DIR, "eslint-plugin-typescript-eslint/node_modules/@typescript-eslint/parser/dist/index.js");
  try { _tsParser = require(_tsParserDist); } catch { /* not installed */ }
  // Sanity-check: the real parser exposes parseForESLint; stubs don't.
  if (typeof _tsParser?.parseForESLint !== "function") _tsParser = null;
}
global.__EZ_TS_PARSER__ = _tsParser;

const eslintLinter = new Linter();
global.__EZ_LINTER_CLASS__ = Linter;

// Timing accumulators for runner breakdown (parse vs plugin).
let _runnerParseMs = 0, _runnerPluginMs = 0;

// ── Espree (reference) ────────────────────────────────────────

// Register plugin rules with ESLint Linter so espree can run them.
const _espreePlugins = {};
for (const [prefix, pkg] of _pluginPackages) {
  _espreePlugins[prefix] = pkg;
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

// Per-rule runner call (forwards per-case options, sourceType, JSX mode).
// rulePlugin: pre-created { meta, create } object shared across all cases of the same rule.
//   Passing the same object identity across calls triggers the buildVisitorMap fast path,
//   avoiding a new _cachedVM allocation (and new closure set) per case.
function runRunnerForRule(src, ruleName, ruleModule, ruleOptions, sourceType, tcLanguageOptions = {}, isTypeScript = false, tcFilename = null, rulePlugin = null) {
  const jsxEnabled = !!(tcLanguageOptions.parserOptions?.ecmaFeatures?.jsx);
  // Use the same filename as the oracle (tc.filename || "test.js") so filename-checking
  // rules (e.g. react/jsx-filename-extension) see the same path and produce matching results.
  // For JSX parsing mode, pass an explicit `lang` override rather than relying on extension.
  const oracleExt = isTypeScript ? ".ts" : ".js";
  const filename = tcFilename || ("test" + oracleExt);
  const parseLang = isTypeScript ? (jsxEnabled ? "tsx" : "ts") : (jsxEnabled ? "jsx" : "js");
  try {
    const ecmaVersion = tcLanguageOptions.ecmaVersion ?? 2022;
    const globals = computeGlobals(ecmaVersion, false);
    // Test-case globals (e.g., globals.node for unicorn) are passed to the runner
    // via languageOptions so they appear in scope.set (for isGlobalReference, no-undef etc.)
    // but NOT to Zig parse — Zig pre-declaration would create implicit-global symbols with
    // defs=[] that make isGlobalReference return true for things like __dirname, breaking
    // unicorn/prefer-module which checks that __dirname is an unresolved global reference.
    const tcGlobals = tcLanguageOptions.globals || null;
    const _p0 = Date.now();
    const ast = parse(src, { filename, lang: parseLang, globals, sourceType, noPrivateCopy: true });
    _runnerParseMs += Date.now() - _p0;
    // Re-use the caller-provided plugin identity (same object → buildVisitorMap fast path),
    // or create a fresh one (cold path, for backward compatibility if called standalone).
    const plugin = rulePlugin || {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions, schema: ruleModule.meta?.schema },
      create: ruleModule.create,
    };
    const _pl0 = Date.now();
    const rawReports = runPlugins(ast, [plugin], {
      tagNames, sourceType, ruleConfig: { [ruleName]: ruleOptions }, ecmaVersion, envGlobals: false,
      filename,
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
        results.push({ rule: r.ruleId, line, fix: r.fix || null });
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

/** Returns true if the parser is a TypeScript parser (ez can handle these with lang:"ts"). */
function _isTsParser(parser) {
  if (!parser) return false;
  // @typescript-eslint/parser and typescript-eslint both expose parseForESLint.
  if (typeof parser?.parseForESLint === "function") return true;
  // typescript-eslint stub (our build.module() shim) also has parseForESLint.
  return false;
}

/** Lowercase the file extension so ESLint glob patterns (case-sensitive) can match it. */
function _normalizeFilenameExt(filename) {
  const dot = filename.lastIndexOf(".");
  if (dot < 0) return filename;
  return filename.slice(0, dot) + filename.slice(dot).toLowerCase();
}

function normalizeCase(c, defaultConfig = {}) {
  const defaultLO = defaultConfig.languageOptions || {};
  if (typeof c === "string") {
    const _defParser = defaultLO.parser || null;
    const _isCustomDef = (p) => p && !_isNativeParser(p) && !_isTsParser(p);
    return {
      code: c,
      options: [],
      languageOptions: defaultLO,
      hasCustomParser: !!_isCustomDef(_defParser),
      isTypeScript: _isTsParser(_defParser),
      eslintResult: null,
    };
  }
  const caseLO = c.languageOptions || {};
  // Merge with default (case overrides default)
  const mergedLO = { ...defaultLO, ...caseLO };
  const caseParser = c.parser || caseLO.parser || null;
  const defaultParser = defaultLO.parser || null;
  // A parser is "custom" (not handled by ez) only if it is neither espree nor a TS parser.
  // TS parsers are treated as native because ez can parse TypeScript with lang:"ts".
  const _isCustom = (p) => p && !_isNativeParser(p) && !_isTsParser(p);
  const hasCustomParser = !!_isCustom(caseParser) || !!_isCustom(defaultParser);
  // Track whether this case uses a TS parser so the runner passes lang:"ts" to ez.
  const isTypeScript = _isTsParser(caseParser) || _isTsParser(defaultParser);
  return {
    code:            c.code || "",
    options:         c.options || [],
    languageOptions: mergedLO,
    filename:        c.filename ? _normalizeFilenameExt(c.filename) : null,
    hasCustomParser,
    isTypeScript,
    eslintResult: null,  // filled during capture by running real ESLint
  };
}

function installCorpusIntercept() {
  const TESTS_DIR = path.join(ESLINT_ROOT, "tests/lib/rules");

  // ── Plugin path: universal Linter.prototype.verify intercept ─────────────
  // Patch the real Linter (npm-installed eslint) so any verify() call during
  // corpus capture is recorded inline.  __EZ_CAPTURE_PREFIX__ activates capture.
  const _realVerifyOrig = Linter.prototype.verify;
  Linter.prototype.verify = function patchedVerify(code, config, options) {
    const result = _realVerifyOrig.call(this, code, config, options);

    if (!global.__EZ_CAPTURE_PREFIX__) return result;
    // Skip "No matching configuration found"
    if (result.length === 1 && result[0].ruleId === null &&
        result[0].message?.startsWith("No matching configuration found")) return result;
    // Skip fatal parse errors
    if (result.some(m => m.fatal)) return result;
    // Extract rule name + options from flat config
    const flatConfig = Array.isArray(config) ? config : [config];
    let fullName = null, ruleOptions = [], langOpts = {};
    for (const cfg of flatConfig) {
      if (cfg.rules && !fullName) {
        const names = Object.keys(cfg.rules);
        if (names.length > 0) {
          fullName = names[0];
          const entry = cfg.rules[fullName];
          ruleOptions = Array.isArray(entry) ? entry.slice(1) : [];
        }
      }
      if (cfg.languageOptions) langOpts = cfg.languageOptions;
    }
    if (!fullName) return result;
    const _isTsCase = typeof langOpts.parser?.parseForESLint === "function";
    const filename = typeof options === "string" ? options : options?.filename;
    const eslintResult = result
      .filter(m => !m.fatal && m.ruleId === fullName)
      .map(m => ({ rule: fullName, line: m.line }));
    // Capture ESLint's autofix output for fix verification.
    const eslintFixes = result
      .filter(m => m.fix && m.ruleId === fullName)
      .map(m => m.fix);
    const tc = {
      code: typeof code === "string" ? code : "",
      options: ruleOptions,
      languageOptions: langOpts,
      filename: filename ? _normalizeFilenameExt(filename) : null,
      hasCustomParser: false,
      isTypeScript: _isTsCase,
      eslintResult,
      eslintFixes: eslintFixes.length > 0 ? eslintFixes : null,
    };
    if (!_captured) _captured = { name: fullName, defaultConfig: {}, cases: [] };
    _captured.cases.push(tc);
    return result;
  };

  // __EZ_SILENT_RUN__ — called by all RuleTester stubs.
  // Iterates test cases, calls linter.verify() per case; the intercept above captures inline.
  // global.__EZ_CAPTURE_PREFIX__ must be set by the caller before invoking.
  global.__EZ_SILENT_RUN__ = (linterInst, name, cases, defaultConfig = {}) => {
    const prefix = global.__EZ_CAPTURE_PREFIX__ || null;
    const fullName = prefix ? `${prefix}/${name}` : name;

    const allInputCases = [...(cases.valid || []), ...(cases.invalid || [])];
    for (let _cIdx = 0; _cIdx < allInputCases.length; _cIdx++) {
      const c = allInputCases[_cIdx];
      const tc = normalizeCase(c, defaultConfig);
      // @typescript-eslint rules: stub parser lacks parseForESLint so normalizeCase
      // can't detect TS mode. Override based on prefix.
      if (!tc.isTypeScript && _tsParser && prefix && prefix.startsWith("@typescript-eslint")) {
        tc.isTypeScript = true;
      }
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
      if (tc.languageOptions?.globals) langOpts.globals = tc.languageOptions.globals;
      // Inject real TS parser for @typescript-eslint rules (stub parser lacks parseForESLint,
      // so normalizeCase can't detect TS mode — detect by prefix instead).
      if (_tsParser && (tc.isTypeScript || (prefix && prefix.startsWith("@typescript-eslint")))) langOpts.parser = _tsParser;
      try {
        const oracleExt      = tc.isTypeScript ? (jsxEnabled ? ".tsx" : ".ts") : ".js";
        const oracleFilename = tc.filename || ("test" + oracleExt);
        const flatCfg = [{
          files: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.mts", "**/*.cts"],
          plugins: pluginCfg,
          languageOptions: langOpts,
          rules: { [fullName]: ruleEntry },
        }];

        // Primary call — intercept fires and captures inline
        const messages = linterInst.verify(tc.code, flatCfg, { filename: oracleFilename });
        // Retry with relative filename if "No matching configuration found"
        if (messages.length === 1 && messages[0].ruleId === null &&
            messages[0].message?.startsWith("No matching configuration found")) {
          const ext = path.extname(oracleFilename) || ".js";
          linterInst.verify(tc.code, flatCfg, { filename: "test" + ext });
        }
      } catch { continue; }
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
      // Single pass: detect fatal parse errors, collect fix flag, and build eslintResult.
      const _isTsCase = typeof langOpts.parser?.parseForESLint === "function";
      // Babel parsers (no latestEcmaVersion, no parseForESLint-that-we-trust) — skip.
      // TS parser cases: capture using oracle result (already ran with TS parser).
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
      const eslintFixes = result
        .filter(m => m.fix && (m.ruleId === fullRuleId || m.ruleId === ruleName))
        .map(m => m.fix);
      const tc = {
        code: typeof code === "string" ? code : "",
        options: ruleOptions,
        languageOptions: langOpts,
        hasCustomParser: false,
        isTypeScript: _isTsCase,
        eslintResult,
        eslintFixes: eslintFixes.length > 0 ? eslintFixes : null,
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
      Linter.prototype.verify = _realVerifyOrig;
      delete global.__EZ_SILENT_RUN__;
      delete global.__EZ_CAPTURE_RULE__;
      delete global.__EZ_CAPTURE_PREFIX__;
    },
  };
}

// evalSonarjsTest — synchronous eval-based loader for sonarjs unit.test.ts files.
// Sonarjs is a special case: tests use `node:test`'s describe/it which Bun.plugin cannot
// intercept (built-in module). Callbacks schedule asynchronously, so await import() resolves
// before stubs fire. Workaround: transpile TS → strip imports → inject preamble → eval().
// The preamble uses the same __EZ_SILENT_RUN__ mechanism as all other plugin stubs.
// Two sonarjs-specific details:
//   - describe/it wrappers fire callbacks synchronously (can't stub node:test)
//   - _ezRuleName overrides run()'s first arg (sonarjs passes descriptions, not rule names)
function evalSonarjsTest(testFile, ruleName) {
  const content = fs.readFileSync(testFile, "utf8");
  let js;
  try {
    js = new Bun.Transpiler({ loader: "ts", target: "node" }).transformSync(content);
  } catch { return; }
  // Strip all import/export lines so the eval scope resolves them from the preamble.
  js = js.replace(/^import\s[^]*?from\s+['"][^'"]+['"]\s*;?\s*$/gm, "");
  js = js.replace(/^import\s+['"][^'"]+['"]\s*;?\s*$/gm, "");
  js = js.replace(/^export\s+\{[^}]*\}\s*;?\s*$/gm, "");
  // Replace import.meta.dirname (used in rule-tester.ts fixtures paths — not in test files,
  // but handle defensively).
  js = js.replace(/import\.meta\.dirname/g, JSON.stringify(path.dirname(testFile)));
  const PREAMBLE = [
    "const rule = {};",
    `const _ezRuleName = ${JSON.stringify(ruleName)};`,
    "class _EzRuleTester {",
    "  constructor() {}",
    "  run(_name, r, cases) { if (typeof global.__EZ_SILENT_RUN__ === 'function') global.__EZ_SILENT_RUN__(new (global.__EZ_LINTER_CLASS__)(), _ezRuleName, cases, {}); }",
    "}",
    "const DefaultParserRuleTester = _EzRuleTester;",
    "const NoTypeCheckingRuleTester = _EzRuleTester;",
    "const RuleTester = _EzRuleTester;",
    "const describe = (name, fn) => { try { fn(); } catch {} };",
    "const it = (name, fn) => { try { fn(); } catch {} };",
  ].join("\n");
  try { eval(PREAMBLE + "\n" + js); } catch { /* partial captures ok */ }
}

// testFormat:
//   "cjs"           — require() + RuleTester stub calls __EZ_SILENT_RUN__ (react, promise, core)
//   "esm"           — import() + RuleTester stub calls __EZ_SILENT_RUN__ (unicorn)
//   "static-export" — import() + reads export default { valid, invalid } directly (jsdoc)
async function loadRuleCases(testsDir, baseName, { capturePrefix = null, captureRule = null, testFormat = "cjs" } = {}) {
  // Accept both .js and .test.ts (typescript-eslint source tests)
  let testFile = path.join(testsDir, `${baseName}.js`);
  if (!fs.existsSync(testFile)) {
    const tsFile = path.join(testsDir, `${baseName}.test.ts`);
    if (fs.existsSync(tsFile)) testFile = tsFile;
    else return null;
  }
  _captured = null;
  _linterSkipCalls = 0;
  global.__EZ_CAPTURE_PREFIX__ = capturePrefix;
  global.__EZ_CAPTURE_RULE__   = captureRule;
  try {
    // .ts files always use dynamic import (Bun handles TypeScript natively)
    if (testFile.endsWith(".ts")) {
      await import(`${testFile}?_ez=${Date.now()}`);
    } else if (testFormat === "cjs") {
      delete require.cache[testFile];
      try { require(testFile); } catch { /* partial captures ok */ }
    } else {
      const mod = await import(`${testFile}?_ez=${Date.now()}`);
      if (testFormat === "static-export") {
        const testCases = mod.default || mod;
        if (testCases && typeof testCases === "object" && ("valid" in testCases || "invalid" in testCases)) {
          const ruleBaseName = camelToKebab(baseName);
          global.__EZ_SILENT_RUN__(new (global.__EZ_LINTER_CLASS__)(), ruleBaseName, testCases, {});
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

// ── Baseline diff (--diff) ────────────────────────────────────
// Compare two baselines without running any tests.

if (diffFile) {
  const a = JSON.parse(fs.readFileSync(BASELINE_FILE, "utf8"));
  const b = JSON.parse(fs.readFileSync(diffFile, "utf8"));
  const allRules = new Set([...Object.keys(a.corpus || {}), ...Object.keys(b.corpus || {})]);
  const improved = [], regressed = [], newRules = [], removedRules = [];
  for (const rule of [...allRules].sort()) {
    const da = a.corpus[rule], db = b.corpus[rule];
    if (!da) { newRules.push(rule); continue; }
    if (!db) { removedRules.push(rule); continue; }
    const aRunner = da.runner || da, bRunner = db.runner || db;
    const aNative = da.native || {}, bNative = db.native || {};
    const aHybrid = da.hybrid || {}, bHybrid = db.hybrid || {};
    const aTotal = (aRunner.fn||0) + (aRunner.fp||0) + (aRunner.crash||0) + (aNative.fn||0) + (aNative.fp||0);
    const bTotal = (bRunner.fn||0) + (bRunner.fp||0) + (bRunner.crash||0) + (bNative.fn||0) + (bNative.fp||0);
    if (bTotal < aTotal) {
      improved.push({ rule, delta: aTotal - bTotal, from: aTotal, to: bTotal });
    } else if (bTotal > aTotal) {
      regressed.push({ rule, delta: bTotal - aTotal, from: aTotal, to: bTotal });
    }
  }
  console.log(`Baseline diff: ${path.basename(BASELINE_FILE)} → ${path.basename(diffFile)}`);
  console.log(`  Rules: ${allRules.size} total, ${newRules.length} new, ${removedRules.length} removed\n`);
  if (a.perf && b.perf) {
    const aCps = a.perf.runnerCasesPerSec || 0, bCps = b.perf.runnerCasesPerSec || 0;
    const aNCps = a.perf.nativeCasesPerSec || 0, bNCps = b.perf.nativeCasesPerSec || 0;
    console.log(`  Perf: runner ${aCps.toLocaleString()} → ${bCps.toLocaleString()} cases/s  native ${aNCps.toLocaleString()} → ${bNCps.toLocaleString()} cases/s`);
  }
  if (improved.length > 0) {
    improved.sort((a, b) => b.delta - a.delta);
    console.log(`\nImproved (${improved.length} rules, ${improved.reduce((s, r) => s + r.delta, 0)} fewer gaps):`);
    for (const r of improved.slice(0, 30)) {
      console.log(`  -${String(r.delta).padStart(4)}  ${r.rule.padEnd(40)} ${r.from} → ${r.to}`);
    }
    if (improved.length > 30) console.log(`  ... and ${improved.length - 30} more`);
  }
  if (regressed.length > 0) {
    regressed.sort((a, b) => b.delta - a.delta);
    console.log(`\nRegressed (${regressed.length} rules, ${regressed.reduce((s, r) => s + r.delta, 0)} more gaps):`);
    for (const r of regressed.slice(0, 30)) {
      console.log(`  +${String(r.delta).padStart(4)}  ${r.rule.padEnd(40)} ${r.from} → ${r.to}`);
    }
    if (regressed.length > 30) console.log(`  ... and ${regressed.length - 30} more`);
  }
  if (improved.length === 0 && regressed.length === 0) console.log("No changes.");
  process.exit(regressed.length > 0 ? 1 : 0);
}

// ── Main ──────────────────────────────────────────────────────

const nativeAvailable = typeof ezLint === "function";
const _nativeRuleSet = nativeAvailable ? getNativeRules() : new Map();

const baseline = loadBaseline();
const newBaseline = { corpus: {}, perf: null };

let anyRegression = false;
const regressedRules = [];
const _startTime = Date.now();
// Top-level accumulators (populated inside corpus IIFE, read in JSON output).
let _topFlakyRules = new Map();
let _topFixable = 0, _topFixMatch = 0, _topFixMismatch = 0;

// Wall-clock timeout: if elapsed > baseline.perf.totalElapsedMs × 1.3, kill the run.
// Only active when baseline has perf data and we're not saving a new baseline.
const _timeoutMs = !saveBaseline && baseline?.perf?.totalElapsedMs > 0
  ? Math.ceil(baseline.perf.totalElapsedMs * 1.3)
  : 0;

// ── Corpus — espree + runner + native + hybrid ───────────────

// Wrapped in async IIFE so unicorn ESM test files can be loaded with await import().
(async () => {
if (fs.existsSync(ESLINT_ROOT)) {
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
  for (const { prefix, pluginDir, testsDir, testFormat } of PLUGIN_TEST_DIRS) {
    if (!fs.existsSync(testsDir)) continue;

    // sonarjs-nested: S*/unit.test.ts layout — build S→ruleName map then scan subdirs
    if (testFormat === "sonarjs-nested") {
      const pluginPkg = _pluginPackages.get(prefix);
      const sNumToName = new Map();
      for (const [name, rule] of Object.entries(pluginPkg?.rules || {})) {
        const url = rule.meta?.docs?.url || "";
        const m = url.match(/\/S(\d+)/);
        if (m) sNumToName.set("S" + m[1], name);
      }
      // Supplement with cjs/S*/meta.js (eslintId field) — look in js/node_modules first, fall back to pluginDir
      const cjsDir = fs.existsSync(path.join(JS_ROOT, "node_modules/eslint-plugin-sonarjs/cjs"))
        ? path.join(JS_ROOT, "node_modules/eslint-plugin-sonarjs/cjs")
        : path.join(pluginDir, "node_modules/eslint-plugin-sonarjs/cjs");
      if (fs.existsSync(cjsDir)) {
        for (const d of fs.readdirSync(cjsDir)) {
          if (!d.startsWith("S")) continue;
          try {
            const meta = require(path.join(cjsDir, d, "meta.js"));
            if (meta.eslintId && !sNumToName.has(d)) sNumToName.set(d, meta.eslintId);
          } catch { /* skip */ }
        }
      }
      for (const sDir of fs.readdirSync(testsDir).filter(d => /^S\d+$/.test(d))) {
        const testFile = path.join(testsDir, sDir, "unit.test.ts");
        if (!fs.existsSync(testFile)) continue;
        const ruleName = sNumToName.get(sDir);
        if (!ruleName) continue;
        const fullName = `${prefix}/${ruleName}`;
        const ruleModule = _pluginRuleModules.get(fullName);
        if (!ruleModule) continue;
        if (filterRule && fullName !== filterRule) continue;
        _captured = null;
        _linterSkipCalls = 0;
        global.__EZ_CAPTURE_PREFIX__ = prefix;
        global.__EZ_CAPTURE_RULE__   = null;
        try { evalSonarjsTest(testFile, ruleName); } finally { global.__EZ_CAPTURE_PREFIX__ = null; global.__EZ_CAPTURE_RULE__ = null; }
        if (!_captured) continue;
        allRuleData.push({ ruleName: fullName, ruleModule, defaultSourceType: "module", isTypeScript: false, allCases: _captured.cases });
      }
      continue;
    }

    // Normal flat test directory
    const testFiles = fs.readdirSync(testsDir)
      .filter(f => (f.endsWith(".js") || f.endsWith(".test.ts")) && f !== "utils.js" && f !== "utils");
    for (const file of testFiles) {
      const baseName = file.replace(/\.(test\.ts|js)$/, "");
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
      const isTypeScript = defaultParser && _isTsParser(defaultParser);
      const allCases = cases.cases;
      allRuleData.push({ ruleName: canonicalName, ruleModule, defaultSourceType, isTypeScript, allCases });
    }
  }

  // Phase 2: Per-rule analysis (native runs in-process via NAPI, same loop as runner).
  const runnerT0 = Date.now();
  let totalCases = 0, totalPass = 0, totalSkip = 0, totalCrash = 0;
  let totalNativePass = 0, totalNativeFn = 0, totalNativeFp = 0,
      totalNativeSkip = 0, totalNativeCrash = 0;
  let totalHybridPass = 0, totalHybridFn = 0, totalHybridFp = 0, totalHybridCrash = 0;
  let runnerOnlyMs = 0, nativeOnlyMs = 0, eslintOnlyMs = 0;
  // TS vs JS breakdown
  let tsCases = 0, tsPass = 0, jsCases = 0, jsPass = 0;
  // Fix verification
  let totalFixable = 0, totalFixMatch = 0, totalFixMismatch = 0;
  // Flaky detection
  const flakyRules = new Map(); // ruleName → count of flaky cases

  const _showCases = showFails || verboseAll || filterRule !== null;
  let _processed = 0, _total = allRuleData.reduce((s, r) => s + r.allCases.length, 0);
  const _ruleTimes = []; // { rule, runnerMs, nativeMs, cases }

  for (const { ruleName, ruleModule, defaultSourceType, isTypeScript, allCases } of allRuleData) {
    if (filterRule && ruleName !== filterRule) continue;

    // Pre-build native config for this rule (one per rule, reused across cases).
    const _ruleHasNativeImpl = _nativeRuleSet.has(ruleName);
    const nativeRuleConfig = nativeAvailable
      ? buildNativeConfig({ [ruleName]: "warn" })
      : null;

    // Create plugin once per rule so runPlugins can take the fast path on all subsequent cases.
    // The fast path skips _cachedVM rebuild and updates options per-case via ruleConfig.
    const rulePlugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions, schema: ruleModule.meta?.schema },
      create: ruleModule.create,
    };

    let fn = 0, fp = 0, crash = 0, pass = 0, skipCustomParser = 0, skipEspreeParse = 0;
    let nativeFn = 0, nativeFp = 0, nativeCrash = 0, nativePass = 0, nativeSkipOptions = 0;
    let hybridFn = 0, hybridFp = 0, hybridCrash = 0, hybridPass = 0;
    let ruleFixable = 0, ruleFixMatch = 0, ruleFixMismatch = 0;
    let _ruleRunnerMs = 0, _ruleNativeMs = 0, _ruleEslintMs = 0;
    const _ruleParseSnap = _runnerParseMs, _rulePluginSnap = _runnerPluginMs;

    // Build reusable ESLint flat config for this rule's A/B timing.
    const _pluginPfx = ruleName.includes("/") ? ruleName.split("/")[0] : null;
    const _eslintPluginCfg = _pluginPfx && _espreePlugins[_pluginPfx]
      ? { [_pluginPfx]: _espreePlugins[_pluginPfx] } : {};
    // Collect failing cases for --fails / --verbose output
    const failedCases = [];  // { tcIdx, kind:"runner"|"native", espreeLines, ourLines, code }

    if (!filterRule && !verboseAll) {
      const pct = _total > 0 ? (_processed / _total * 100).toFixed(0) : "0";
      process.stderr.write(`\r  ${pct}% (${_processed}/${_total})  ${ruleName}  \x1B[K`);
    }
    let _caseLoopT0 = performance.now();
    for (let tcIdx = 0; tcIdx < allCases.length; tcIdx++) {
      const tc = allCases[tcIdx];
      if (tc.hasCustomParser) { skipCustomParser++; continue; }
      const sourceType = tc.languageOptions?.sourceType || defaultSourceType;

      _processed++;

      // Oracle: ESLint's actual output, captured during test-file loading.
      // Cases where ESLint couldn't run (parse errors, schema errors) were dropped during capture.
      const espreeResult = tc.eslintResult;
      if (!espreeResult) { skipEspreeParse++; continue; }

      const _rt0 = performance.now();
      const runnerResult = runRunnerForRule(tc.code, ruleName, ruleModule, tc.options, sourceType, tc.languageOptions, isTypeScript || !!tc.isTypeScript, tc.filename, rulePlugin);
      const _rtDelta = performance.now() - _rt0;
      runnerOnlyMs += _rtDelta;
      _ruleRunnerMs += _rtDelta;

      // A/B timing: run ESLint on the same case (opt-in via --bench-eslint)
      if (benchEslint) {
        const _et0 = performance.now();
        const ecmaVersion = tc.languageOptions?.ecmaVersion ?? 2022;
        const jsxEnabled = !!(tc.languageOptions?.parserOptions?.ecmaFeatures?.jsx);
        const langOpts = { ecmaVersion, sourceType };
        if (jsxEnabled) langOpts.parserOptions = { ecmaFeatures: { jsx: true } };
        if (tc.languageOptions?.globals) langOpts.globals = tc.languageOptions.globals;
        const ruleEntry = tc.options.length > 0 ? ["error", ...tc.options] : "error";
        const oracleExt = (isTypeScript || tc.isTypeScript) ? ".ts" : ".js";
        const oracleFilename = tc.filename || ("test" + oracleExt);
        eslintLinter.verify(tc.code, [{
          files: ["**/*"],
          plugins: _eslintPluginCfg,
          languageOptions: langOpts,
          rules: { [ruleName]: ruleEntry },
        }], { filename: oracleFilename });
        const _etDelta = performance.now() - _et0;
        eslintOnlyMs += _etDelta;
        _ruleEslintMs += _etDelta;
      }

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
            filename: tc.filename,
          });
        }
      }

      // TS vs JS tracking
      const _isTsCase = isTypeScript || !!tc.isTypeScript;
      if (_isTsCase) { tsCases++; if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) tsPass++; }
      else { jsCases++; if (caseFn === 0 && caseFp === 0 && runnerCrashes.length === 0) jsPass++; }

      // Fix verification: compare runner autofix output vs ESLint autofix output.
      // Only check cases where diagnostics match (caseFn===0, caseFp===0) so fix
      // comparison is meaningful — otherwise different diagnostics produce different fixes.
      if (tc.eslintFixes && caseFn === 0 && caseFp === 0) {
        ruleFixable++;
        // Apply ESLint fixes to get expected output
        const eslintFixed = _applyFixes(tc.code, tc.eslintFixes);
        // Apply runner fixes to get our output
        const runnerFixes = runnerNormal.filter(r => r.fix).flatMap(r => r.fix);
        if (runnerFixes.length > 0) {
          const runnerFixed = _applyFixes(tc.code, runnerFixes);
          if (runnerFixed === eslintFixed) ruleFixMatch++;
          else ruleFixMismatch++;
        } else {
          // Runner didn't produce fixes but ESLint did — mismatch
          ruleFixMismatch++;
        }
      }

      // Native comparison (in-process NAPI call).
      const _nt0 = Date.now();
      const nativeResult = runNativeForCase(tc.code, ruleName, nativeRuleConfig, tc.hasCustomParser, tc.options.length > 0, tc.options);
      const _ntDelta = Date.now() - _nt0;
      nativeOnlyMs += _ntDelta;
      _ruleNativeMs += _ntDelta;
      let nativeUsable = false; // did native produce a usable result for this case?
      if (nativeResult === "skip") {
        nativeSkipOptions++;
      } else if (nativeResult === null) {
        nativeCrash++;
      } else {
        nativeUsable = true;
        const nativeKeys = new Set(nativeResult.map(r => `${r.rule}:${r.line}`));
        const caseNativeFn = [...espreeKeys].filter(k => !nativeKeys.has(k)).length;
        const caseNativeFp = [...nativeKeys].filter(k => !espreeKeys.has(k)).length;
        if (caseNativeFn === 0 && caseNativeFp === 0) nativePass++;
        else { nativeFn += caseNativeFn; nativeFp += caseNativeFp; }
      }

      // Hybrid comparison: prefer native when usable AND rule has native impl, else runner.
      // Mirrors production path in api.js: native rules via Zig, JS-only rules via runner.
      if (nativeAvailable) {
        const hybridResult = (_ruleHasNativeImpl && nativeUsable) ? nativeResult : runnerNormal;
        const hybridKeys = new Set(hybridResult.map(r => `${r.rule}:${r.line}`));
        const caseHybridFn = [...espreeKeys].filter(k => !hybridKeys.has(k)).length;
        const caseHybridFp = [...hybridKeys].filter(k => !espreeKeys.has(k)).length;
        if (caseHybridFn === 0 && caseHybridFp === 0) hybridPass++;
        else { hybridFn += caseHybridFn; hybridFp += caseHybridFp; }
      }
    }

    const _caseLoopMs = performance.now() - _caseLoopT0;

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
    totalHybridPass  += hybridPass;
    totalHybridFn    += hybridFn;
    totalHybridFp    += hybridFp;
    totalHybridCrash += hybridCrash;
    totalFixable     += ruleFixable;
    totalFixMatch    += ruleFixMatch;
    totalFixMismatch += ruleFixMismatch;

    // Flaky detection: re-run a sample of failed cases to detect non-determinism.
    if (failedCases.length > 0 && failedCases.length <= 50) {
      let ruleFlaky = 0;
      for (const fc of failedCases.slice(0, 10)) {
        if (fc.kind === "crash") continue;
        const tcr = allCases[fc.tcIdx];
        if (!tcr) continue;
        const st = tcr.languageOptions?.sourceType || defaultSourceType;
        const r2 = runRunnerForRule(tcr.code, ruleName, ruleModule, tcr.options, st, tcr.languageOptions, isTypeScript || !!tcr.isTypeScript, tcr.filename, rulePlugin);
        if (!r2) continue;
        const r2Normal = r2.filter(r => !r.crash);
        const r2Keys = new Set(r2Normal.map(r => `${r.rule}:${r.line}`));
        const runnerKeys2 = new Set((fc.ourLines || []).map(l => `${ruleName}:${l}`));
        // Compare re-run to original run — if different, it's flaky
        if (r2Keys.size !== runnerKeys2.size || [...r2Keys].some(k => !runnerKeys2.has(k))) {
          ruleFlaky++;
        }
      }
      if (ruleFlaky > 0) flakyRules.set(ruleName, ruleFlaky);
    }

    // Free the old _cachedVM (rule closures from create()). JSC under-counts external
    // TypedArray backing stores toward GC budget, so GC never fires spontaneously when
    // switching rules. Each rule creates a new _cachedVM (~10-40 MB for jsdoc-sized rules);
    // without explicit collection, 1039 rules × 40 MB = 40 GB accumulates before GC.

    // Baseline — supports old flat format {fn,fp,crash} and new nested format.
    newBaseline.corpus[ruleName] = {
      runner: { fn, fp, crash },
      native: { fn: nativeFn, fp: nativeFp, crash: nativeCrash, skip: nativeSkipOptions },
      hybrid: { fn: hybridFn, fp: hybridFp, crash: hybridCrash },
    };
    const baseRule   = baseline?.corpus?.[ruleName];
    const baseRunner = baseRule?.runner ?? baseRule ?? null;  // old: flat, new: nested
    const baseNative = baseRule?.native ?? null;
    const baseHybrid = baseRule?.hybrid ?? null;

    let ruleRegression = false;
    if (!strict && (baseRunner || baseNative || baseHybrid)) {
      if (baseRunner)
        ruleRegression = fn > baseRunner.fn || fp > baseRunner.fp || crash > baseRunner.crash;
      if (nativeAvailable && baseNative)
        ruleRegression = ruleRegression || nativeFn > baseNative.fn || nativeFp > baseNative.fp || nativeCrash > baseNative.crash;
      if (nativeAvailable && baseHybrid)
        ruleRegression = ruleRegression || hybridFn > baseHybrid.fn || hybridFp > baseHybrid.fp || hybridCrash > baseHybrid.crash;
    } else if (strict) {
      ruleRegression = fn > 0 || fp > 0 || crash > 0 ||
                       (nativeAvailable && (nativeFn > 0 || nativeFp > 0 || nativeCrash > 0)) ||
                       (nativeAvailable && (hybridFn > 0 || hybridFp > 0 || hybridCrash > 0));
    }

    if (ruleRegression) {
      anyRegression = true;
      const deltaFn   = baseRunner ? fn   - baseRunner.fn   : fn;
      const deltaFp   = baseRunner ? fp   - baseRunner.fp   : fp;
      const deltaCr   = baseRunner ? crash - baseRunner.crash : crash;
      const nDeltaFn  = baseNative ? nativeFn    - baseNative.fn    : nativeFn;
      const nDeltaFp  = baseNative ? nativeFp    - baseNative.fp    : nativeFp;
      const nDeltaCr  = baseNative ? nativeCrash - baseNative.crash : nativeCrash;
      const hDeltaFn  = baseHybrid ? hybridFn    - baseHybrid.fn    : hybridFn;
      const hDeltaFp  = baseHybrid ? hybridFp    - baseHybrid.fp    : hybridFp;
      const hDeltaCr  = baseHybrid ? hybridCrash - baseHybrid.crash : hybridCrash;
      regressedRules.push({ rule: ruleName, deltaFn, deltaFp, deltaCr, nDeltaFn, nDeltaFp, nDeltaCr, hDeltaFn, hDeltaFp, hDeltaCr });
    }

    const allClean = (fn + fp + crash) === 0 &&
                     (!nativeAvailable || (nativeFn + nativeFp + nativeCrash) === 0) &&
                     (!nativeAvailable || (hybridFn + hybridFp + hybridCrash) === 0);
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

    // Per-rule output: show regressions always, others only with --verbose or --rule
    const _showRule = ruleRegression || verboseAll || filterRule;
    if (_showRule) {
      if (nativeAvailable) {
        const nativeDetail = [
          nativeFn       > 0 ? `${nativeFn} FN`             : "",
          nativeFp       > 0 ? `${nativeFp} FP`             : "",
          nativeCrash    > 0 ? `${nativeCrash} crash`       : "",
          nativeSkipOptions > 0 ? `${nativeSkipOptions} skip` : "",
        ].filter(Boolean).join(", ");
        const hybridTotal = hybridPass + hybridFn + hybridFp + hybridCrash;
        const hybridDetail = [
          hybridFn    > 0 ? `${hybridFn} FN`    : "",
          hybridFp    > 0 ? `${hybridFp} FP`    : "",
          hybridCrash > 0 ? `${hybridCrash} crash` : "",
        ].filter(Boolean).join(", ");
        const nativeStr = `native ${nativePass}/${nativeTotal}${nativeDetail ? ` (${nativeDetail})` : ""}`;
        const hybridStr = `hybrid ${hybridPass}/${hybridTotal}${hybridDetail ? ` (${hybridDetail})` : ""}`;
        console.log(`  ${status} ${ruleName}: runner ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}  ${nativeStr}  ${hybridStr}`);
      } else {
        console.log(`  ${status} ${ruleName}: ${pass}/${total}${runnerDetail ? ` (${runnerDetail})` : ""}`);
      }
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
          const fnStr = c.filename ? ` file=${c.filename}` : "";
          console.log(`    [case ${c.tcIdx}${opts}${st}${fnStr}]  ESLint: ${espreeStr}  ours: ${oursStr}`);
          printCodeSnippet(c.code, [...c.espreeLines, ...c.ourLines], "    ");
        }
      }
      if (failedCases.length > maxShow) {
        console.log(`    ... and ${failedCases.length - maxShow} more failing cases (use --rule ${ruleName} to see all)`);
      }
    }

    _ruleTimes.push({
      rule: ruleName, runnerMs: _ruleRunnerMs, nativeMs: _ruleNativeMs, eslintMs: _ruleEslintMs, cases: total,
      parseMs: _runnerParseMs - _ruleParseSnap, pluginMs: _runnerPluginMs - _rulePluginSnap,
    });

    // Wall-clock timeout guard: check at each rule boundary.
    if (_timeoutMs > 0) {
      const _elapsed = Date.now() - _startTime;
      if (_elapsed > _timeoutMs) {
        process.stderr.write("\r\x1B[K");
        console.error(`\nTimeout: elapsed ${(_elapsed / 1000).toFixed(1)}s exceeds baseline ${(baseline.perf.totalElapsedMs / 1000).toFixed(1)}s × 1.3. Possible performance regression.`);
        process.exit(2);
      }
    }
  }
  if (!filterRule && !verboseAll) process.stderr.write("\r\x1B[K"); // clear progress line

  restore();
  const runnerMs = Date.now() - runnerT0;

  // Derived totals reused in perf + summary output.
  const _nativeTotal = totalNativePass + totalNativeFn + totalNativeFp + totalNativeCrash;
  const _hybridTotal = totalHybridPass + totalHybridFn + totalHybridFp + totalHybridCrash;

  // Store perf data in newBaseline so --save-baseline captures throughput.
  newBaseline.perf = {
    totalElapsedMs: Date.now() - _startTime,
    runnerCasesPerSec: runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)) : 0,
    nativeCasesPerSec: nativeOnlyMs > 0 ? Math.round(_nativeTotal / (nativeOnlyMs / 1000)) : 0,
    totalCases,
  };

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
      for (const g of ruleGaps.slice(0, 20)) {
        const parts = [];
        if (g.fn > 0) parts.push(`${g.fn} FN`);
        if (g.fp > 0) parts.push(`${g.fp} FP`);
        if (g.crash > 0) parts.push(`${g.crash} crash`);
        console.log(`  ${String(g.total).padStart(4)}  ${g.rule.padEnd(35)} ${parts.join(", ")}`);
      }
      if (ruleGaps.length > 20) console.log(`  ... and ${ruleGaps.length - 20} more rules`);
    }
  }

  if (nativeAvailable) {
    const runnerCasesSec = runnerOnlyMs > 0 ? Math.round(totalCases / (runnerOnlyMs / 1000)).toLocaleString() : "∞";
    const nativeCasesSec = nativeOnlyMs > 0 ? Math.round(_nativeTotal / (nativeOnlyMs / 1000)).toLocaleString() : "∞";
    const runnerPct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    const nativePct = _nativeTotal > 0 ? (totalNativePass / _nativeTotal * 100).toFixed(1) : "0";
    const hybridPct = _hybridTotal > 0 ? (totalHybridPass / _hybridTotal * 100).toFixed(1) : "0";
    const runnerGaps = totalCases - totalPass;
    const nativeGaps = _nativeTotal - totalNativePass;
    const hybridGaps = _hybridTotal - totalHybridPass;
    console.log(`\nCorpus runner:  ${totalPass}/${totalCases} pass (${runnerPct}%), ${totalSkip} skipped, ${totalCrash} crashes, ${runnerGaps} gaps`);
    console.log(`  linting: ${(runnerOnlyMs/1000).toFixed(2)}s  (${runnerCasesSec} cases/s)  [parse: ${(_runnerParseMs/1000).toFixed(2)}s, js-rules: ${(_runnerPluginMs/1000).toFixed(2)}s]`);
    console.log(`Corpus native:  ${totalNativePass}/${_nativeTotal} pass (${nativePct}%), ${totalNativeSkip} skipped, ${totalNativeCrash} crashes, ${nativeGaps} gaps`);
    console.log(`  linting: ${(nativeOnlyMs/1000).toFixed(2)}s  (${nativeCasesSec} cases/s)`);
    console.log(`Corpus hybrid:  ${totalHybridPass}/${_hybridTotal} pass (${hybridPct}%), ${hybridGaps} gaps  (native when available, runner fallback)`);
    if (benchEslint) console.log(`Corpus eslint:  ${(eslintOnlyMs/1000).toFixed(2)}s  (runner/eslint ratio: ${(runnerOnlyMs / eslintOnlyMs).toFixed(2)}x)`);

    if (_ruleTimes.length > 0 && !filterRule) {
      // Top 10 slowest rules by total time (runner + native).
      const sorted = [..._ruleTimes].sort((a, b) => (b.runnerMs + b.nativeMs) - (a.runnerMs + a.nativeMs));
      console.log(`\nSlowest rules (runner + native):`);
      for (const t of sorted.slice(0, 10)) {
        const totalMs = Math.round(t.runnerMs + t.nativeMs);
        const perCase = t.cases > 0 ? (totalMs / t.cases * 1000).toFixed(0) : "—";
        const eslintCmp = benchEslint && t.eslintMs > 0 ? `  vs eslint ${Math.round(t.eslintMs)}ms (${(t.runnerMs / t.eslintMs).toFixed(1)}x)` : "";
        console.log(`  ${String(totalMs).padStart(5)}ms  ${t.rule.padEnd(40)} ${t.cases} cases  (${perCase} µs/case)  [parse ${Math.round(t.parseMs)}ms, js-rules ${Math.round(t.pluginMs)}ms, native ${Math.round(t.nativeMs)}ms]${eslintCmp}`);
      }

      if (benchEslint) {
        // Rules slower than ESLint (ratio > 1.0, sorted by absolute delta).
        const slower = _ruleTimes
          .filter(t => t.eslintMs > 1 && t.runnerMs > t.eslintMs)
          .map(t => ({ ...t, delta: t.runnerMs - t.eslintMs, ratio: t.runnerMs / t.eslintMs }))
          .sort((a, b) => b.delta - a.delta);
        if (slower.length > 0) {
          console.log(`\nSlower than ESLint (${slower.length} rules):`);
          for (const t of slower.slice(0, 20)) {
            console.log(`  +${String(Math.round(t.delta)).padStart(4)}ms  ${t.rule.padEnd(40)} ez ${Math.round(t.runnerMs)}ms vs eslint ${Math.round(t.eslintMs)}ms  (${t.ratio.toFixed(1)}x)  ${t.cases} cases`);
          }
          if (slower.length > 20) console.log(`  ... and ${slower.length - 20} more`);
        }

        // Rules faster than ESLint.
        const faster = _ruleTimes
          .filter(t => t.eslintMs > 1 && t.runnerMs < t.eslintMs)
          .map(t => ({ ...t, delta: t.eslintMs - t.runnerMs, ratio: t.eslintMs / t.runnerMs }))
          .sort((a, b) => b.delta - a.delta);
        if (faster.length > 0) {
          const totalSaved = faster.reduce((s, t) => s + t.delta, 0);
          console.log(`\nFaster than ESLint (${faster.length} rules, ${Math.round(totalSaved)}ms saved):`);
          for (const t of faster.slice(0, 10)) {
            console.log(`  -${String(Math.round(t.delta)).padStart(4)}ms  ${t.rule.padEnd(40)} ez ${Math.round(t.runnerMs)}ms vs eslint ${Math.round(t.eslintMs)}ms  (${t.ratio.toFixed(1)}x faster)  ${t.cases} cases`);
          }
        }
      }
    }

    // TS vs JS breakdown
    if (!filterRule && (tsCases + jsCases > 0)) {
      const jsPct = jsCases > 0 ? (jsPass / jsCases * 100).toFixed(1) : "—";
      const tsPct = tsCases > 0 ? (tsPass / tsCases * 100).toFixed(1) : "—";
      console.log(`\nJS cases:  ${jsPass}/${jsCases} pass (${jsPct}%)`);
      console.log(`TS cases:  ${tsPass}/${tsCases} pass (${tsPct}%)`);
    }

    // Native coverage dashboard
    if (!filterRule) {
      const totalRules = allRuleData.length;
      let nativeImplCount = 0, nativeImplCases = 0, totalAllCases = 0;
      for (const { ruleName, allCases: ac } of allRuleData) {
        const cases = ac.length;
        totalAllCases += cases;
        if (_nativeRuleSet.has(ruleName)) { nativeImplCount++; nativeImplCases += cases; }
      }
      const coveragePct = totalAllCases > 0 ? (nativeImplCases / totalAllCases * 100).toFixed(1) : "0";
      console.log(`\nNative coverage: ${nativeImplCount}/${totalRules} rules (${coveragePct}% of cases)`);
    }

    // Fix verification summary
    if (!filterRule && totalFixable > 0) {
      const fixPct = (totalFixMatch / totalFixable * 100).toFixed(1);
      console.log(`\nFix verification: ${totalFixMatch}/${totalFixable} match (${fixPct}%), ${totalFixMismatch} mismatch`);
    }

    // Flaky rules
    if (flakyRules.size > 0) {
      console.log(`\nFlaky rules (${flakyRules.size} rules with non-deterministic results):`);
      for (const [rule, count] of [...flakyRules.entries()].sort((a, b) => b[1] - a[1])) {
        console.log(`  ${rule}: ${count} flaky cases`);
      }
    }
  } else {
    const pct = totalCases > 0 ? (totalPass / totalCases * 100).toFixed(1) : "0";
    console.log(`\nCorpus: ${totalPass}/${totalCases} pass (${pct}%), ${totalSkip} skipped, ${totalCrash} crashes  (${(runnerMs/1000).toFixed(2)}s)`);
  }
  // Export IIFE-local accumulators to top-level for JSON output.
  _topFlakyRules = flakyRules;
  _topFixable = totalFixable; _topFixMatch = totalFixMatch; _topFixMismatch = totalFixMismatch;
} else {
  console.log("\n(ESLint submodule not found. Run: git submodule update --init tests/conformance/eslint)");
}

// ── Save baseline / exit ──────────────────────────────────────

const elapsed = ((Date.now() - _startTime) / 1000).toFixed(2);
const mem = process.memoryUsage();
const rss = (mem.rss / 1024 / 1024).toFixed(0);
const heap = (mem.heapUsed / 1024 / 1024).toFixed(0);
const heapTotal = (mem.heapTotal / 1024 / 1024).toFixed(0);
console.log(`\nTotal time: ${elapsed}s  |  RSS: ${rss} MB  heap: ${heap}/${heapTotal} MB`);

// Perf regression check (>30% throughput drop vs baseline).
if (!saveBaseline && baseline?.perf?.runnerCasesPerSec > 0 && newBaseline.perf?.runnerCasesPerSec > 0) {
  const perfRatio = newBaseline.perf.runnerCasesPerSec / baseline.perf.runnerCasesPerSec;
  if (perfRatio < 0.7) {
    anyRegression = true;
    regressedRules.push({
      rule: "(runner throughput)",
      deltaFn: 0, deltaFp: 0, deltaCr: 0, nDeltaFn: 0, nDeltaFp: 0, nDeltaCr: 0, hDeltaFn: 0, hDeltaFp: 0, hDeltaCr: 0,
      _perfNote: `${newBaseline.perf.runnerCasesPerSec.toLocaleString()} cases/s vs baseline ${baseline.perf.runnerCasesPerSec.toLocaleString()} cases/s (${(perfRatio * 100).toFixed(0)}%)`,
    });
  }
}
if (!saveBaseline && baseline?.perf?.nativeCasesPerSec > 0 && newBaseline.perf?.nativeCasesPerSec > 0) {
  const perfRatio = newBaseline.perf.nativeCasesPerSec / baseline.perf.nativeCasesPerSec;
  if (perfRatio < 0.7) {
    anyRegression = true;
    regressedRules.push({
      rule: "(native throughput)",
      deltaFn: 0, deltaFp: 0, deltaCr: 0, nDeltaFn: 0, nDeltaFp: 0, nDeltaCr: 0, hDeltaFn: 0, hDeltaFp: 0, hDeltaCr: 0,
      _perfNote: `${newBaseline.perf.nativeCasesPerSec.toLocaleString()} cases/s vs baseline ${baseline.perf.nativeCasesPerSec.toLocaleString()} cases/s (${(perfRatio * 100).toFixed(0)}%)`,
    });
  }
}

// JSON output (--json): machine-readable results for CI/dashboards.
if (jsonOutput) {
  const jsonResult = {
    baseline: newBaseline,
    regressions: regressedRules.map(r => ({
      rule: r.rule,
      runner: { fn: r.deltaFn, fp: r.deltaFp, crash: r.deltaCr },
      native: { fn: r.nDeltaFn, fp: r.nDeltaFp, crash: r.nDeltaCr },
      hybrid: { fn: r.hDeltaFn, fp: r.hDeltaFp, crash: r.hDeltaCr },
      perfNote: r._perfNote || null,
    })),
    anyRegression,
    elapsedMs: Date.now() - _startTime,
    flaky: Object.fromEntries(_topFlakyRules),
    fixes: { fixable: _topFixable, match: _topFixMatch, mismatch: _topFixMismatch },
  };
  console.log(JSON.stringify(jsonResult, null, 2));
  process.exit(anyRegression ? 1 : 0);
}

if (saveBaseline) {
  fs.writeFileSync(BASELINE_FILE, JSON.stringify(newBaseline, null, 2));
  console.log(`Baseline saved → ${path.relative(path.resolve(__dirname, "../.."), BASELINE_FILE)}`);
} else if (anyRegression) {
  console.log("Regressions detected:");
  for (const r of regressedRules) {
    if (r._perfNote) {
      console.log(`  ${r.rule}: throughput regression — ${r._perfNote}`);
    } else {
      const parts = [];
      if (r.deltaFn > 0) parts.push(`runner +${r.deltaFn} FN`);
      if (r.deltaFp > 0) parts.push(`runner +${r.deltaFp} FP`);
      if (r.deltaCr > 0) parts.push(`runner +${r.deltaCr} crash`);
      if (r.nDeltaFn > 0) parts.push(`native +${r.nDeltaFn} FN`);
      if (r.nDeltaFp > 0) parts.push(`native +${r.nDeltaFp} FP`);
      if (r.nDeltaCr > 0) parts.push(`native +${r.nDeltaCr} crash`);
      if (r.hDeltaFn > 0) parts.push(`hybrid +${r.hDeltaFn} FN`);
      if (r.hDeltaFp > 0) parts.push(`hybrid +${r.hDeltaFp} FP`);
      if (r.hDeltaCr > 0) parts.push(`hybrid +${r.hDeltaCr} crash`);
      console.log(`  ${r.rule}: ${parts.join(", ")}`);
    }
  }
  console.log("Run with --save-baseline to update baseline after intentional changes.");
  process.exit(1);
} else {
  console.log("No regressions.");
}
})(); // end async IIFE (wraps corpus + summary so unicorn ESM loading can use await)
