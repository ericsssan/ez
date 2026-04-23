"use strict";

if (typeof Bun === "undefined") {
  process.stderr.write("error: extract.js requires Bun. Use: bun tests/differential/extract.js <outDir>\n");
  process.exit(1);
}

// Suppress unhandled errors from TypeScript projectService background tasks.
// These are benign — the affected test case is skipped and extraction continues.
const _suppressMsg = (msg) =>
  msg.includes("No project matched") || msg.includes("Could not read tsconfig") ||
  msg.includes("ENOENT") && msg.includes("package.json");
process.on("unhandledRejection", (reason) => {
  if (_suppressMsg(String(reason?.message || reason))) return;
  process.stderr.write(`warn: unhandled rejection: ${String(reason?.message || reason)}\n`);
});
process.on("uncaughtException", (err) => {
  if (_suppressMsg(String(err?.message || err))) return;
  process.stderr.write(`warn: uncaught exception: ${String(err?.message || err)}\n`);
});

/**
 * Fixture extractor — reads ESLint + plugin conformance test files and writes
 * pre-extracted JSON fixture bundles under <outDir>/corpus/<prefix>/<rule>/_cases.json.
 *
 * Usage:
 *   bun tests/differential/extract.js <outDir> [--rule <name>]
 *
 * Example:
 *   bun tests/differential/extract.js tests/fixtures/extracted
 *   bun tests/differential/extract.js tests/fixtures/extracted --rule no-unused-vars
 */

const fs   = require("fs");
const path = require("path");

// ── Paths ────────────────────────────────────────────────────

const JS_ROOT      = path.resolve(__dirname, "../../js");
const ESLINT_ROOT  = path.resolve(__dirname, "../conformance/eslint");
const CONFORMANCE_DIR = path.resolve(__dirname, "../conformance");

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
  static setDefaultConfig(_cfg) {}
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
    build.module("@typescript-eslint/rule-tester", () => ({ loader: "js", contents: `export { RuleTester } from 'eslint'; export { RuleTester as default } from 'eslint'; export const noFormat = (s) => s; export const RuleTesterConfig = {};` }));
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
    // Stub rule source files so imports don't fail. Export default + common named exports.
    build.onLoad({ filter: /eslint-plugin[/\\]src[/\\]rules[/\\].+\.ts$/ }, () => ({ loader: "js", contents: `const _s = {}; export default _s; export const phrases = _s;` }));
    // typescript-eslint-parser/package.json: imported by some eslint-plugin-import tests.
    build.module("typescript-eslint-parser/package.json", () => ({ loader: "js", contents: `export const version = "22.0.0"; export default { version: "22.0.0" };` }));

    // babel-eslint: imported by eslint-plugin-import tests. Stub both named and absolute-path imports
    // to prevent ESM/CJS "already fetched" conflicts when require(absPath) is called after import 'babel-eslint'.
    const _babelEslintStub = { loader: "js", contents: `const p = { parse: () => ({ type: "Program", body: [], range: [0,0] }), parseForESLint: () => ({ ast: { type: "Program", body: [], range: [0,0] }, services: {}, scopeManager: null, visitorKeys: {} }) }; module.exports = p; module.exports.default = p;` };
    build.module("babel-eslint", () => _babelEslintStub);
    build.onLoad({ filter: /babel-eslint[/\\]index\.js$/ }, () => _babelEslintStub);

    // eslint-plugin-import tests use require('rules/<name>') with babel module-resolver.
    // Stubs live at tests/conformance/eslint-plugin-import/tests/src/node_modules/rules/<name>.js
    // and load the real compiled rules so meta.messages etc. are available.
    build.onLoad({ filter: /sonarjs-src[/\\].*[/\\](helpers|files)\.(ts|js)$/ }, () => ({ loader: "js", contents: `export default {}; export const normalizePath = (p) => p;` }));

    // fs-teardown: used by some ESLint core test utilities (_utils/index.js).
    // Stub with no-op functions so test files load without requiring real FS teardown.
    build.module("fs-teardown", () => ({ loader: "js", contents: `
      exports.createTeardown = () => ({ prepare: async () => {}, cleanup: async () => {} });
      exports.addFile = () => {};
    ` }));

    // eslint-v7 / eslint-v8 / eslint-v9: used by react-hooks tests to run against multiple ESLint versions.
    // Redirect their RuleTester to our stub so oracle capture works.
    const ESLINT_PATH_JSON = JSON.stringify(path.join(JS_ROOT, "node_modules/eslint"));
    const _eslintVersionStub = `const _e = require(${ESLINT_PATH_JSON}); module.exports = _e; module.exports.default = _e;`;
    build.module("eslint-v7", () => ({ loader: "js", contents: _eslintVersionStub }));
    build.module("eslint-v8", () => ({ loader: "js", contents: _eslintVersionStub }));
    build.module("eslint-v9", () => ({ loader: "js", contents: _eslintVersionStub }));

    // babel-plugin-react-compiler: needed by ReactCompiler source (src/shared/ReactCompiler.ts).
    // Stub all named imports so the source file loads without the real compiler.
    build.module("babel-plugin-react-compiler", () => ({ loader: "js", contents: `
      exports.CompilerError = class extends Error {};
      exports.ErrorSeverity = { InvalidReact: 'InvalidReact', CannotDevirtualize: 'CannotDevirtualize' };
      exports.findContextIdentifiers = () => new Set();
      exports.transformFromAstSync = () => null;
      exports.default = {};
    ` }));
    // Also stub the ReactCompiler source file itself so it doesn't try to run the compiler.
    build.onLoad({ filter: /eslint-plugin-react-hooks[/\\]src[/\\]shared[/\\]ReactCompiler\.ts$/ }, () => ({ loader: "js", contents: `
      exports.allRules = new Proxy({}, { get(_, k) { return { rule: { create: () => ({}), meta: { messages: {}, schema: [] } } }; } });
    ` }));

    // ── jsdoc performance intercepts ─────────────────────────────
    // Profiling multi-rule lint (20 files × 50 jsdoc rules):
    //   getJSDocComment: ~355k calls / 245ms (62.7%) without cache
    //   parseComment:    ~4.5k calls / 28ms (7.2%) with 10x redundancy per comment
    // Both are deterministic per (sourceCode, node) pair, so stash results on the
    // Comment/Node object itself via a Symbol. Patching at onLoad avoids editing the
    // submodule's node_modules (which would be wiped on reinstall).
    // Additionally: short-circuit iterateJsdoc's *:not(Program) handler for nodes
    // cached as no-jsdoc, so later rules bail before any work.

    // checkIndentation uses `new RegExp(..., 'gv')` with dynamic excludeTags per call.
    // Bun/V8's `v` flag (ES2024 unicodeSets) costs ~5 ms to compile on first encounter
    // with a given pattern. Rule's inputs are ASCII-only JSDoc tag names, and `v`
    // adds nothing — unicode-property-escapes / set-notation are unused. Strip to `g`.
    build.onLoad({ filter: /eslint-plugin-jsdoc[/\\]src[/\\]rules[/\\]checkIndentation\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      // Replace both literal /.../gv and `new RegExp(..., 'gv')` forms.
      const out = src
        .replaceAll("/gmv", "/gm")
        .replaceAll("/gv", "/g")
        .replaceAll("/v", "/")
        .replaceAll("'gv'", "'g'")
        .replaceAll("'gmv'", "'gm'");
      return { loader: "js", contents: out };
    });

    // Memo getDefaultTagStructureForMode by mode (read-only; 4 keys total).
    // Without memo, native `Map` op was ~4.7% of CPU time from rebuild on every rule call.
    build.onLoad({ filter: /eslint-plugin-jsdoc[/\\]src[/\\]getDefaultTagStructureForMode\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      return { loader: "js", contents: src.replace(
        /export default getDefaultTagStructureForMode;?\s*$/,
        `const _ez_gdts_cache = new Map();
const _ez_origGDTS = getDefaultTagStructureForMode;
const _ez_getDefaultTagStructureForMode = (mode) => { let v = _ez_gdts_cache.get(mode); if (v !== undefined) return v; v = _ez_origGDTS(mode); _ez_gdts_cache.set(mode, v); return v; };
export default _ez_getDefaultTagStructureForMode;`
      ) };
    });

    // parseInlineTags.parseDescription: matchAll reads RegExp.prototype.flags on every call
    // (Bun accessor overhead was 7.0% self / 676ms). Replace with explicit exec+lastIndex.
    build.onLoad({ filter: /@es-joy[/\\]jsdoccomment[/\\]src[/\\]parseInlineTags\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      return { loader: "js", contents: src.replace(
        `function parseDescription (description) {
  /** @type {import('.').InlineTag[]} */
  const result = [];

  // This could have been expressed in a single pattern,
  // but having two avoids a potentially exponential time regex.

  const prefixedTextPattern = /(?:\\[(?<text>[^\\]]+)\\])\\{@(?<tag>[^\\}\\s]+)\\s?(?<namepathOrURL>[^\\}\\s\\|]*)\\}/gvd;
  // The pattern used to match for text after tag uses a negative lookbehind
  // on the ']' char to avoid matching the prefixed case too.
  const suffixedAfterPattern = /(?<!\\])\\{@(?<tag>[^\\}\\s]+)\\s?(?<namepathOrURL>[^\\}\\s\\|]*)\\s*(?<separator>[\\s\\|])?\\s*(?<text>[^\\}]*)\\}/gvd;

  const matches = [
    ...description.matchAll(prefixedTextPattern),
    ...description.matchAll(suffixedAfterPattern)
  ];`,
        `const _ez_prefixedTextPattern = /(?:\\[(?<text>[^\\]]+)\\])\\{@(?<tag>[^\\}\\s]+)\\s?(?<namepathOrURL>[^\\}\\s\\|]*)\\}/gvd;
const _ez_suffixedAfterPattern = /(?<!\\])\\{@(?<tag>[^\\}\\s]+)\\s?(?<namepathOrURL>[^\\}\\s\\|]*)\\s*(?<separator>[\\s\\|])?\\s*(?<text>[^\\}]*)\\}/gvd;
function _ez_execAll(re, str) { const out = []; re.lastIndex = 0; let m; while ((m = re.exec(str)) !== null) { out.push(m); if (m.index === re.lastIndex) re.lastIndex++; } return out; }
function parseDescription (description) {
  const result = [];
  const matches = [ ..._ez_execAll(_ez_prefixedTextPattern, description), ..._ez_execAll(_ez_suffixedAfterPattern, description) ];`
      ) };
    });

    // jsdocUtils.getPreferredTagNameSimple: Object.entries(tagNames).find(...) on every call
    // (6% of CPU self time: 617ms / 10.25s). Precompute alias→preferred once per tagNames identity.
    build.onLoad({ filter: /eslint-plugin-jsdoc[/\\]src[/\\]jsdocUtils\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      return { loader: "js", contents: src.replace(
        `  const preferredTagName = Object.entries(tagNames).find(([
    , aliases,
  ]) => {
    return aliases.includes(name);
  })?.[0];`,
        `  if (!globalThis.__ez_aliasCache) globalThis.__ez_aliasCache = new WeakMap();
  let _ez_aliasMap = globalThis.__ez_aliasCache.get(tagNames);
  if (!_ez_aliasMap) {
    _ez_aliasMap = new Map();
    for (const [preferred, aliases] of Object.entries(tagNames)) {
      for (const alias of aliases) _ez_aliasMap.set(alias, preferred);
    }
    globalThis.__ez_aliasCache.set(tagNames, _ez_aliasMap);
  }
  const preferredTagName = _ez_aliasMap.get(name);`
      ) };
    });

    build.onLoad({ filter: /eslint-plugin-jsdoc[/\\]src[/\\]iterateJsdoc\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      let wrapped = src.replace(
        `'*:not(Program)' (node) {
          const commentNode = getJSDocComment(
            sourceCode, node, /** @type {Settings} */ (settings),
          );`,
        `'*:not(Program)' (node) {
          const _ezGjdcCommon = node && typeof node === 'object' ? node[Symbol.for('ez.gjdc.common')] : undefined;
          if (_ezGjdcCommon === null && !ruleConfig.nonComment) return;
          const commentNode = _ezGjdcCommon !== undefined ? _ezGjdcCommon : getJSDocComment(
            sourceCode, node, /** @type {Settings} */ (settings),
          );`
      );
      // Plug upstream leak: trackedJsdocs is a module-scope Set that grows per-lint
      // and is never cleared. Clear it on Program:exit so it doesn't accumulate across files.
      wrapped = wrapped.replace(
        `        'Program:exit' () {`,
        `        'Program:exit' () {
          // EZ patch: clear cross-file accumulation
          const _ezTracked = trackedJsdocs;`
      ).replace(
        `          callIterator(
            context,
            null,
            untrackedJSdoc,
            /** @type {StateObject} */
            (state),
            true,
          );
        },
      };
    },
    meta: ruleConfig.meta,
  };
};`,
        `          callIterator(
            context,
            null,
            untrackedJSdoc,
            /** @type {StateObject} */
            (state),
            true,
          );
          _ezTracked.clear();
        },
      };
    },
    meta: ruleConfig.meta,
  };
};`
      );
      return { loader: "js", contents: wrapped };
    });
    build.onLoad({ filter: /@es-joy[/\\]jsdoccomment[/\\]src[/\\]jsdoccomment\.js$/ }, async (args) => {
      const fs = require("fs");
      const src = fs.readFileSync(args.path, "utf8");
      const wrapped = src.replace(
        /\bexport\s*\{([^}]*)\}/,
        (m, names) => {
          const list = names.split(',').map(s => s.trim()).filter(Boolean);
          return `const _EZ_GJDC_COMMON = Symbol.for('ez.gjdc.common');
const _EZ_GJDC_MAP = Symbol.for('ez.gjdc.map');
const _EZ_GJDC_FALLBACK = new WeakMap();
const _ez_origGetJSDocComment = getJSDocComment;
const _ez_getJSDocComment = function (sourceCode, node, settings, opts) {
  const o = opts || {};
  const isDefault = settings && settings.minLines === 0 && settings.maxLines === 1 &&
    !settings.skipInvokedExpressionsForCommentFinding && !o.checkOverloads && !o.nonJSDoc;
  if (isDefault && node && typeof node === 'object') {
    const hit = node[_EZ_GJDC_COMMON];
    if (hit !== undefined) return hit;
    const r = _ez_origGetJSDocComment(sourceCode, node, settings, o);
    try { node[_EZ_GJDC_COMMON] = r === null ? null : r; } catch {}
    return r;
  }
  if (node && typeof node === 'object') {
    let inner = node[_EZ_GJDC_MAP];
    if (!inner) { inner = _EZ_GJDC_FALLBACK.get(node); }
    const key = settings.minLines + '|' + settings.maxLines + '|' +
      (settings.skipInvokedExpressionsForCommentFinding ? 1 : 0) + '|' +
      (o.checkOverloads ? 1 : 0) + '|' + (o.nonJSDoc ? 1 : 0);
    if (inner && inner.has(key)) return inner.get(key);
    const r = _ez_origGetJSDocComment(sourceCode, node, settings, o);
    if (!inner) { inner = new Map(); try { node[_EZ_GJDC_MAP] = inner; } catch { _EZ_GJDC_FALLBACK.set(node, inner); } }
    inner.set(key, r);
    return r;
  }
  return _ez_origGetJSDocComment(sourceCode, node, settings, o);
};
export { ${list.map(n => n === 'getJSDocComment' ? '_ez_getJSDocComment as getJSDocComment' : n).join(', ')} }`;
        }
      );
      return { loader: "js", contents: wrapped };
    });

    // Note: parseComment memoization was attempted but reverted — the returned JSDoc
    // block is mutable and some callers extend `tags[i].inlineTags` in place, which
    // breaks cached reuse. getJSDocComment's result (a Comment token) is safely cached.
  },
});

// Pre-load eslint redirect into CJS cache so ESM/CJS interop works.
require("eslint");

// ── CLI ───────────────────────────────────────────────────────

const _cliArgs  = process.argv.slice(2);
// Resolve against initial cwd now — sonarjs tests chdir() during phase 1 loading.
const outDir    = _cliArgs.find(a => !a.startsWith("--")) || null;
const _ruleIdx  = _cliArgs.indexOf("--rule");
const filterRule = _ruleIdx >= 0 ? _cliArgs[_ruleIdx + 1] : null;

if (!outDir) {
  process.stderr.write("usage: bun tests/differential/extract.js <outDir> [--rule <name>]\n");
  process.exit(1);
}

const extractDir = path.resolve(process.cwd(), outDir);

// ── Helpers ───────────────────────────────────────────────────

/** Convert camelCase to kebab-case. Used to map test file names to rule names (jsdoc). */
function camelToKebab(str) {
  return str.replace(/[A-Z]/g, c => '-' + c.toLowerCase());
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

// Candidate test subdirectory paths, checked in order of preference per plugin convention.
const _TEST_DIR_CANDIDATES = [
  "tests/lib/rules",        // react, n, es-x
  "tests/src/rules",        // import
  "test/rules/assertions",  // jsdoc
  "__tests__",              // promise
  "test",                   // unicorn
  "tests/rules",
  "tests",
  // typescript-eslint: load directly from submodule source (no extraction script needed)
  "typescript-eslint-src/packages/eslint-plugin/tests/rules",
  // react-hooks: sparse checkout of facebook/react monorepo
  "packages/eslint-plugin-react-hooks/__tests__",
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
          // Allow conformance package.json to override testFormat (e.g. for plugins that use ESM test files but have no type:module).
          if (pkgJson.testFormat) testFormat = pkgJson.testFormat;
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
            if (files.some(f => f.endsWith(".js") || f.endsWith(".ts"))) {
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
          const sample = testsDirFiles.find(f => (f.endsWith(".js") || f.endsWith(".ts")) && !f.endsWith(".d.ts") && f !== "utils.js" && f !== "utils");
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

const { Linter } = require(path.join(JS_ROOT, "node_modules/eslint"));

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

global.__EZ_LINTER_CLASS__ = Linter;

// Stub test-framework globals so TS test files using describe()/it()/test()
// don't crash on import. Callbacks fire synchronously so RuleTester.run() calls
// inside describe blocks are still captured.
const _noop = () => {};
const _syncCall = (_, fn) => { try { if (typeof fn === "function") fn(); } catch {} };
if (!global.describe)    global.describe    = _syncCall;
if (!global.it)          global.it          = _syncCall;
if (!global.test)        global.test        = _syncCall;
if (!global.beforeAll)   global.beforeAll   = _noop;
if (!global.afterAll)    global.afterAll    = _noop;
if (!global.beforeEach)  global.beforeEach  = _noop;
if (!global.afterEach)   global.afterEach   = _noop;
if (!global.expect)      global.expect      = () => ({ toBe: _noop, toEqual: _noop, toMatchSnapshot: _noop });
if (!global.context)     global.context     = _syncCall;  // Mocha alias for describe
context.skip = _noop; context.only = _syncCall;
describe.skip = _noop; describe.only = _syncCall;
// describe.for / describe.each: vitest parameterized tests — call fn for each item.
describe.for = (items) => (_, fn) => { for (const item of (items || [])) { try { fn(item); } catch {} } };
describe.each = describe.for;
it.skip = _noop; it.only = _syncCall;
it.each = describe.for;
test.skip = _noop; test.only = _syncCall;
test.each = describe.for;

// ── Espree (reference) ────────────────────────────────────────

// Register plugin rules with ESLint Linter so espree can run them.
const _espreePlugins = {};
for (const [prefix, pkg] of _pluginPackages) {
  _espreePlugins[prefix] = pkg;
}

// ── Capture state ─────────────────────────────────────────────

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
    name:            c.name || null,            // RuleTester allows test descriptions
    only:            !!c.only,                   // focus flag from ruletester
    output:          c.output !== undefined ? c.output : null, // autofix expected output
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
    let result;
    try { result = _realVerifyOrig.call(this, code, config, options); } catch (e) { return []; }

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
      // Declared intent from __EZ_SILENT_RUN__ (null for core ESLint path).
      declaredKind:   global.__EZ_DECLARED_KIND__   || null,
      declaredErrors: global.__EZ_DECLARED_ERRORS__ || null,
      name:           global.__EZ_CASE_NAME__       || null,
      output:         global.__EZ_CASE_OUTPUT__ !== undefined ? global.__EZ_CASE_OUTPUT__ : null,
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
    // When __EZ_CAPTURE_RULE__ is set, use it as the canonical rule name.
    // This handles cases where the test file calls run('alias-name', rule, ...)
    // but the actual plugin rule is registered under a different name (e.g.
    // ban-ts-comment.test.ts calls run('ts-expect-error', ...) internally).
    const canonicalName = global.__EZ_CAPTURE_RULE__ || name;
    const fullName = prefix ? `${prefix}/${canonicalName}` : canonicalName;

    // Tag each case with declared kind + declared errors before merging.
    // Preserves the test-author's intent (valid/invalid) separately from
    // oracle output so extraction can store both.
    const taggedValid   = (cases.valid   || []).map(c => ({ _declaredKind: "valid",   _declaredErrors: [],                              ...( typeof c === "string" ? { code: c } : c ) }));
    const taggedInvalid = (cases.invalid || []).map(c => ({ _declaredKind: "invalid", _declaredErrors: (typeof c === "object" && c.errors) ? c.errors : [], ...( typeof c === "string" ? { code: c } : c ) }));
    const allInputCases = [...taggedValid, ...taggedInvalid];
    for (let _cIdx = 0; _cIdx < allInputCases.length; _cIdx++) {
      const c = allInputCases[_cIdx];
      const tc = normalizeCase(c, defaultConfig);
      // Carry declared metadata through so the verify intercept and extraction see it.
      tc._declaredKind   = c._declaredKind;
      tc._declaredErrors = c._declaredErrors;
      // @typescript-eslint rules: stub parser lacks parseForESLint so normalizeCase
      // can't detect TS mode. Override based on prefix.
      if (!tc.isTypeScript && _tsParser && prefix && prefix.startsWith("@typescript-eslint")) {
        tc.isTypeScript = true;
      }
      if (tc.hasCustomParser) continue;
      const sourceType  = tc.languageOptions?.sourceType  || "script";
      const ecmaVersion = tc.languageOptions?.ecmaVersion ?? 2022;
      const jsxEnabled  = !!(tc.languageOptions?.parserOptions?.ecmaFeatures?.jsx);
      const useProjectService = !!(tc.languageOptions?.parserOptions?.projectService);
      const useProject = !!(tc.languageOptions?.parserOptions?.project);
      const tcTsconfigRootDir = tc.languageOptions?.parserOptions?.tsconfigRootDir || null;
      const ruleEntry   = tc.options.length > 0 ? ["error", ...tc.options] : "error";
      const pluginPfx   = fullName.includes("/") ? fullName.split("/")[0] : null;
      const pluginCfg   = pluginPfx && _espreePlugins[pluginPfx]
        ? { [pluginPfx]: _espreePlugins[pluginPfx] } : {};
      const langOpts    = { ecmaVersion, sourceType };
      if (jsxEnabled) langOpts.parserOptions = { ecmaFeatures: { jsx: true } };
      // projectService causes async TS Language Service errors that crash extraction.
      // Skip it during extraction — type-aware rules capture oracle results via the TS parser alone.
      if (false && useProjectService && extractDir) {
        langOpts.parserOptions = { ...(langOpts.parserOptions || {}), projectService: { allowDefaultProject: ["*.ts", "*.tsx"] }, tsconfigRootDir: extractDir };
      } else if (useProject && tcTsconfigRootDir) {
        // Pass through project-based type info (uses a specific tsconfig file).
        langOpts.parserOptions = { ...(langOpts.parserOptions || {}), project: tc.languageOptions.parserOptions.project, tsconfigRootDir: tcTsconfigRootDir };
      }
      if (tc.languageOptions?.globals) langOpts.globals = tc.languageOptions.globals;
      // Inject real TS parser for @typescript-eslint rules (stub parser lacks parseForESLint,
      // so normalizeCase can't detect TS mode — detect by prefix instead).
      if (_tsParser && (tc.isTypeScript || (prefix && prefix.startsWith("@typescript-eslint")))) langOpts.parser = _tsParser;
      try {
        const oracleExt      = tc.isTypeScript ? (jsxEnabled ? ".tsx" : ".ts") : ".js";
        // For type-aware rules during extraction, use an absolute filename so projectService
        // can locate the virtual file relative to tsconfigRootDir.
        const _typeAwareDir = useProjectService && extractDir ? extractDir : (useProject && tcTsconfigRootDir ? tcTsconfigRootDir : null);
        const oracleFilename = tc.filename
          ? (_typeAwareDir ? path.join(_typeAwareDir, tc.filename) : tc.filename)
          : (_typeAwareDir ? path.join(_typeAwareDir, "test" + oracleExt) : "test" + oracleExt);
        const flatCfg = [{
          files: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.jsx", "**/*.ts", "**/*.tsx", "**/*.mts", "**/*.cts"],
          plugins: pluginCfg,
          languageOptions: langOpts,
          rules: { [fullName]: ruleEntry },
        }];

        // Pass declared metadata to the verify intercept via globals (verify is sync).
        global.__EZ_DECLARED_KIND__   = tc._declaredKind   || null;
        global.__EZ_DECLARED_ERRORS__ = tc._declaredErrors || null;
        global.__EZ_CASE_NAME__       = tc.name             || null;
        global.__EZ_CASE_OUTPUT__     = tc.output !== undefined ? tc.output : null;
        // Primary call — intercept fires and captures inline
        const messages = linterInst.verify(tc.code, flatCfg, { filename: oracleFilename });
        // Retry with relative filename if "No matching configuration found"
        if (messages.length === 1 && messages[0].ruleId === null &&
            messages[0].message?.startsWith("No matching configuration found")) {
          const ext = path.extname(oracleFilename) || ".js";
          linterInst.verify(tc.code, flatCfg, { filename: "test" + ext });
        }
        global.__EZ_DECLARED_KIND__ = null;
        global.__EZ_DECLARED_ERRORS__ = null;
        global.__EZ_CASE_NAME__ = null;
        global.__EZ_CASE_OUTPUT__ = null;
      } catch {
        global.__EZ_DECLARED_KIND__ = null;
        global.__EZ_DECLARED_ERRORS__ = null;
        global.__EZ_CASE_NAME__ = null;
        global.__EZ_CASE_OUTPUT__ = null;
        continue;
      }
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
      let result;
      try { result = _linterOrig.call(this, code, config, options); } catch (e) { return []; }
      const ruleName = global.__EZ_CAPTURE_RULE__;
      if (!ruleName) return result;
      // Skip fix-check and suggestion-check calls (they operate on mutated output, not original).
      if (_linterSkipCalls > 0) {
        _linterSkipCalls--;
        return result;
      }
      // `config` is a FlatConfigArray; use getConfig() to get normalized rules+languageOptions.
      // The submodule's RuleTester registers the rule under "rule-to-test/<name>" namespace.
      const _RULE_TO_TEST_PREFIX = "rule-to-test/";
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
        filename: _normalizeFilenameExt(filename),
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

// Pre-populate require.cache with stub entries for modules that ESM test files might require()
// synchronously inside callbacks, to avoid "Requested module is already fetched" Bun errors.
function _preCacheStubModules(testDir) {
  // babel-eslint: used by eslint-plugin-import tests via require(require.resolve('babel-eslint'))
  const _STUB_PKGS = ["babel-eslint"];
  for (const pkg of _STUB_PKGS) {
    try {
      const absPath = require.resolve(pkg, { paths: [testDir] });
      if (!require.cache[absPath]) {
        const stub = { parse: () => ({ type: "Program", body: [], range: [0,0] }), parseForESLint: () => ({ ast: { type: "Program", body: [], range: [0,0] }, services: {}, scopeManager: null, visitorKeys: {} }) };
        require.cache[absPath] = { id: absPath, filename: absPath, exports: stub, loaded: true, parent: null, children: [] };
      }
    } catch { /* not available — skip */ }
  }
}

// testFormat:
//   "cjs"           — require() + RuleTester stub calls __EZ_SILENT_RUN__ (react, promise, core)
//   "esm"           — import() + RuleTester stub calls __EZ_SILENT_RUN__ (unicorn)
//   "static-export" — import() + reads export default { valid, invalid } directly (jsdoc)
async function loadRuleCases(testsDir, baseName, { capturePrefix = null, captureRule = null, testFormat = "cjs" } = {}) {
  // Accept .js, .test.ts, or plain .ts test files
  let testFile = path.join(testsDir, `${baseName}.js`);
  if (!fs.existsSync(testFile)) {
    const testTs = path.join(testsDir, `${baseName}.test.ts`);
    const plainTs = path.join(testsDir, `${baseName}.ts`);
    if (fs.existsSync(testTs)) testFile = testTs;
    else if (fs.existsSync(plainTs)) testFile = plainTs;
    else return null;
  }
  _captured = null;
  _linterSkipCalls = 0;
  global.__EZ_CAPTURE_PREFIX__ = capturePrefix;
  global.__EZ_CAPTURE_RULE__   = captureRule;
  // For core rule CJS tests (captureRule set), the real RuleTester runs inside the test file.
  // Bun's build.module() stubs @typescript-eslint/parser with a fake that can't parse TypeScript,
  // causing fatal errors when the test's second run() uses it.  Override the cache entry with the
  // real parser so the submodule RuleTester can successfully run TS test cases.
  const _TS_PARSER_CACHE_KEY = "@typescript-eslint/parser";
  let _savedTsParserCache;
  if (_tsParser && captureRule && testFormat === "cjs") {
    _savedTsParserCache = require.cache[_TS_PARSER_CACHE_KEY];
    require.cache[_TS_PARSER_CACHE_KEY] = {
      id: _TS_PARSER_CACHE_KEY, filename: _TS_PARSER_CACHE_KEY,
      exports: _tsParser, loaded: true,
    };
  }
  try {
    // .ts files always use dynamic import (Bun handles TypeScript natively)
    if (testFile.endsWith(".ts")) {
      await import(`${testFile}?_ez=${Date.now()}`);
    } else if (testFormat === "cjs") {
      delete require.cache[testFile];
      try { require(testFile); } catch { /* partial captures ok */ }
    } else {
      // Pre-cache any modules that might be required() inside ESM test files to avoid
      // "Requested module is already fetched" errors (e.g. babel-eslint in eslint-plugin-import).
      _preCacheStubModules(path.dirname(testFile));
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
    // Restore @typescript-eslint/parser cache if we overrode it.
    if (_savedTsParserCache !== undefined) {
      require.cache[_TS_PARSER_CACHE_KEY] = _savedTsParserCache;
    } else if (_tsParser && captureRule && testFormat === "cjs") {
      delete require.cache[_TS_PARSER_CACHE_KEY];
    }
  }
  return _captured;
}

// ── Main ──────────────────────────────────────────────────────

(async () => {
  if (!fs.existsSync(ESLINT_ROOT)) {
    process.stderr.write("error: ESLint submodule not found. Run: git submodule update --init tests/conformance/eslint\n");
    process.exit(1);
  }
  // Global guard: catch any unhandled errors in the extraction loop and continue.
  // TypeScript Language Service and some ESLint rules throw asynchronously
  // (e.g. "No project matched") in ways that bypass inner try/catch blocks.
  // Bun routes these to stdout via its error display; we swallow them here.
  const _originalConsole = { error: console.error };
  console.error = (...args) => {
    const msg = args.map(String).join(" ");
    if (_suppressMsg(msg)) return;
    _originalConsole.error(...args);
  };

  const TESTS_DIR = path.join(ESLINT_ROOT, "tests/lib/rules");
  const RULES_DIR_SUB = path.join(ESLINT_ROOT, "lib/rules");

  const { restore } = installCorpusIntercept();

  // Plugin test directories — derived from auto-discovered conformance submodules.
  const PLUGIN_TEST_DIRS = _discoveredPlugins.filter(p => p.testsDir);

  const allRuleData = [];

  // 1a: ESLint core rules — real RuleTester runs; Linter.prototype.verify intercept captures cases
  for (const ruleName of COMPARABLE_RULES) {
    if (ruleName.includes("/")) continue; // skip plugin rules here
    if (filterRule && ruleName !== filterRule) continue;
    let cases;
    try { cases = await loadRuleCases(TESTS_DIR, ruleName, { captureRule: ruleName }); } catch { continue; }
    if (!cases) continue;
    const ruleModule = (() => {
      try { return require(path.join(RULES_DIR_SUB, `${ruleName}.js`)); } catch { return null; }
    })();
    const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
    const allCases = cases.cases;
    allRuleData.push({ ruleName, ruleModule, defaultSourceType, allCases });
  }

  // 1b: Plugin rules — load test cases from plugin submodule test dirs.
  for (const { prefix, pluginDir, testsDir, testFormat } of PLUGIN_TEST_DIRS) {
    if (!fs.existsSync(testsDir)) continue;
    try {

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
        if (filterRule && fullName !== filterRule) continue;
        _captured = null;
        _linterSkipCalls = 0;
        global.__EZ_CAPTURE_PREFIX__ = prefix;
        global.__EZ_CAPTURE_RULE__   = null;
        try { evalSonarjsTest(testFile, ruleName); } finally { global.__EZ_CAPTURE_PREFIX__ = null; global.__EZ_CAPTURE_RULE__ = null; }
        if (!_captured) continue;
        allRuleData.push({ ruleName: fullName, ruleModule: null, defaultSourceType: "module", allCases: _captured.cases });
      }
      continue;
    }

    // Normal flat test directory
    const _dirEntries = fs.readdirSync(testsDir, { withFileTypes: true });
    const testFiles = _dirEntries
      .filter(e => e.isFile() && (e.name.endsWith(".js") || e.name.endsWith(".ts")) && e.name !== "utils.js" && e.name !== "utils" && !e.name.endsWith(".d.ts"))
      .map(e => e.name);
    for (const file of testFiles) {
      const baseName = file.replace(/\.test\.ts$|\.ts$|\.js$/, "");
      // Rule names may be kebab-case (react/promise/unicorn) or mapped from camelCase files (jsdoc).
      // Try direct match first, then camelCase → kebab-case conversion.
      const kebabName = camelToKebab(baseName);
      const fullName     = `${prefix}/${baseName}`;
      const fullNameKebab = `${prefix}/${kebabName}`;
      const ruleModule = _pluginRuleModules.get(fullName) || _pluginRuleModules.get(fullNameKebab);
      const canonicalName = _pluginRuleModules.has(fullName) ? fullName : fullNameKebab;
      if (filterRule && canonicalName !== filterRule) continue;
      // Pass canonicalName as captureRule so __EZ_SILENT_RUN__ uses the correct
      // plugin rule name even when the test file calls run() with an alias name.
      const captureRuleShort = canonicalName.replace(/^.*\//, "");
      let cases;
      try { cases = await loadRuleCases(testsDir, baseName, { capturePrefix: prefix, captureRule: captureRuleShort, testFormat }); } catch { continue; }
      if (!cases) continue;
      const defaultSourceType = cases.defaultConfig?.languageOptions?.sourceType || "script";
      const allCases = cases.cases;
      allRuleData.push({ ruleName: canonicalName, ruleModule: ruleModule || null, defaultSourceType, allCases });
    }
    // Subdirectory-based rules:
    //   Type A: subdir is a single rule with multiple test files (e.g. no-shadow/ in @typescript-eslint)
    //   Type B: subdir contains individual rule test files (e.g. prefer-global/{buffer,console,...} in n)
    for (const entry of _dirEntries.filter(e => e.isDirectory())) {
      const dirName = entry.name;
      const kebabName = camelToKebab(dirName);
      const fullName = `${prefix}/${dirName}`;
      const fullNameKebab = `${prefix}/${kebabName}`;
      const ruleModule = _pluginRuleModules.get(fullName) || _pluginRuleModules.get(fullNameKebab);
      const canonicalName = _pluginRuleModules.has(fullName) ? fullName : fullNameKebab;
      const subDirPath = path.join(testsDir, dirName);

      // Type B: subdir has no matching rule but contains individual rule files (prefix/subdir/rule).
      if (!ruleModule) {
        const subEntries = fs.readdirSync(subDirPath, { withFileTypes: true });
        for (const subEntry of subEntries.filter(e => e.isFile())) {
          const subBase = subEntry.name.replace(/\.test\.ts$|\.ts$|\.js$/, "");
          if (subBase === subEntry.name) continue; // no recognized extension
          const subFullName  = `${prefix}/${dirName}/${subBase}`;
          const subKebab     = `${prefix}/${dirName}/${camelToKebab(subBase)}`;
          const subRuleModule = _pluginRuleModules.get(subFullName) || _pluginRuleModules.get(subKebab);
          if (!subRuleModule) continue;
          const subCanonical = _pluginRuleModules.has(subFullName) ? subFullName : subKebab;
          if (filterRule && subCanonical !== filterRule) continue;
          const subRuleShort = `${dirName}/${subBase}`;
          let subCases;
          try { subCases = await loadRuleCases(subDirPath, subBase, { capturePrefix: prefix, captureRule: subRuleShort, testFormat }); } catch { continue; }
          if (!subCases) continue;
          allRuleData.push({ ruleName: subCanonical, ruleModule: subRuleModule || null, defaultSourceType: subCases.defaultConfig?.languageOptions?.sourceType || "script", allCases: subCases.cases });
        }
        continue;
      }

      if (filterRule && canonicalName !== filterRule) continue;
      const subFiles = fs.readdirSync(subDirPath)
        .filter(f => f.endsWith(".test.ts") || (f.endsWith(".js") && f !== "utils.js"))
        .sort();
      _captured = null;
      _linterSkipCalls = 0;
      global.__EZ_CAPTURE_PREFIX__ = prefix;
      global.__EZ_CAPTURE_RULE__   = null;
      for (const file of subFiles) {
        const testFile = path.join(subDirPath, file);
        try { await import(`${testFile}?_ez=${Date.now()}`); } catch (e) {
          if (filterRule) process.stderr.write(`warn: failed to load ${file}: ${e.message}\n`);
        }
      }
      global.__EZ_CAPTURE_PREFIX__ = null;
      global.__EZ_CAPTURE_RULE__   = null;
      if (!_captured) continue;
      allRuleData.push({ ruleName: canonicalName, ruleModule: ruleModule || null, defaultSourceType: "module", allCases: _captured.cases });
    }
    } catch (e) { if (!_suppressMsg(String(e?.message||e))) process.stderr.write(`warn: plugin ${prefix} extraction error: ${e?.message}\n`); }
  }

  restore();

  // ── Write fixtures ────────────────────────────────────────────
  const outRoot = extractDir;
  fs.mkdirSync(outRoot, { recursive: true });
  const corpusRoot = path.join(outRoot, "corpus");
  fs.mkdirSync(corpusRoot, { recursive: true });

  const concat = {
    valid:   { js: "", ts: "" },
    invalid: { js: "", ts: "" },
  };
  const tally = {
    valid:   { js: 0, ts: 0, jsx: 0, tsx: 0 },
    invalid: { js: 0, ts: 0, jsx: 0, tsx: 0 },
  };
  let nRules = 0;

  for (const { ruleName, allCases } of allRuleData) {
    const buckets = { valid: [], invalid: [] };
    for (const c of allCases) {
      // Prefer declared kind (set by __EZ_SILENT_RUN__); fall back to oracle-inferred.
      const k = c.declaredKind || (c.eslintResult && c.eslintResult.length > 0 ? "invalid" : "valid");
      buckets[k].push(c);
    }
    if (buckets.valid.length + buckets.invalid.length === 0) continue;
    nRules++;

    const _slashIdx = ruleName.indexOf("/");
    const [prefix, bareRule] = _slashIdx >= 0
      ? [ruleName.slice(0, _slashIdx), ruleName.slice(_slashIdx + 1)]
      : ["eslint", ruleName];
    const safePrefix = prefix.replace(/[@\/]/g, "_");
    const safeRule = bareRule.replace(/[\/]/g, "_");

    // Also build a per-rule bundle that the fast runner reads in ONE file
    // instead of 100+ per-case reads. Massive speedup on corpus load.
    const ruleBundle = { rule: ruleName, cases: [] };
    for (const kind of ["valid", "invalid"]) {
      if (buckets[kind].length === 0) continue;
      const dir = path.join(corpusRoot, safePrefix, safeRule, kind);
      fs.mkdirSync(dir, { recursive: true });
      for (let i = 0; i < buckets[kind].length; i++) {
        const tc = buckets[kind][i];
        if (typeof tc.code !== "string" || tc.code.length === 0) continue;
        const jsx = !!(tc.languageOptions?.parserOptions?.ecmaFeatures?.jsx);
        const ext = tc.isTypeScript ? (jsx ? ".tsx" : ".ts") : (jsx ? ".jsx" : ".js");
        const base = path.join(dir, `${i}`);
        fs.writeFileSync(`${base}${ext}`, tc.code);
        // Sidecar metadata: options, sourceType, languageOptions, filename,
        // and expected ESLint result lines — everything the fast test runner
        // needs to reproduce the exact run without the oracle.
        const meta = {
          rule: ruleName,
          kind,                                              // declared or oracle-inferred
          index: i,                                          // position within bucket
          name: tc.name || null,                             // test description if declared
          options: tc.options || [],
          // Preserve exact state — don't inject defaults here. Fast-path reader
          // falls back to the rule's defaultSourceType when these are null.
          sourceType: tc.languageOptions?.sourceType || null,
          ecmaVersion: tc.languageOptions?.ecmaVersion ?? null,
          isTypeScript: !!tc.isTypeScript,
          jsx,
          filename: tc.filename || null,                     // preserved for filename-dependent rules
          globals: tc.languageOptions?.globals || null,
          parserOptions: tc.languageOptions?.parserOptions || null,
          output: tc.output !== undefined ? tc.output : null, // expected autofix output
          declaredErrors: tc.declaredErrors || [],           // test-author's expected errors
          oracleLines: (tc.eslintResult || []).map(r => r.line), // what ESLint actually reported
          oracleFixes: tc.eslintFixes || null,               // autofix output from ESLint
        };
        fs.writeFileSync(`${base}.json`, JSON.stringify(meta, null, 2));
        // Add to the per-rule bundle (code embedded for runner fast-load)
        ruleBundle.cases.push({ ...meta, code: tc.code, ext });
        const lang = (ext === ".ts" || ext === ".tsx") ? "ts" : "js";
        concat[kind][lang] += `// === ${ruleName} #${i} (${kind}) ===\n${tc.code}\n;\n`;
        tally[kind][ext.slice(1)]++;
      }
    }
    // Write the per-rule bundle alongside the per-case files.
    fs.writeFileSync(path.join(corpusRoot, safePrefix, safeRule, "_cases.json"), JSON.stringify(ruleBundle));
  }

  const all_js = concat.valid.js + concat.invalid.js;
  const all_ts = concat.valid.ts + concat.invalid.ts;
  fs.writeFileSync(path.join(outRoot, "valid-all.js"),   concat.valid.js);
  fs.writeFileSync(path.join(outRoot, "valid-all.ts"),   concat.valid.ts);
  fs.writeFileSync(path.join(outRoot, "invalid-all.js"), concat.invalid.js);
  fs.writeFileSync(path.join(outRoot, "invalid-all.ts"), concat.invalid.ts);
  fs.writeFileSync(path.join(outRoot, "all.js"),         all_js);
  fs.writeFileSync(path.join(outRoot, "all.ts"),         all_ts);

  const sum = t => t.js + t.ts + t.jsx + t.tsx;
  const summaryLines = [
    `\nExtracted from ${nRules} rules → ${outRoot}`,
    `  valid:   ${sum(tally.valid)}   (js=${tally.valid.js} ts=${tally.valid.ts} jsx=${tally.valid.jsx} tsx=${tally.valid.tsx})`,
    `  invalid: ${sum(tally.invalid)} (js=${tally.invalid.js} ts=${tally.invalid.ts} jsx=${tally.invalid.jsx} tsx=${tally.invalid.tsx})`,
    `  per-file: corpus/<prefix>/<rule>/{valid,invalid}/N.{js,ts,jsx,tsx}`,
    `  concat:   valid-all.{js,ts}  invalid-all.{js,ts}  all.{js,ts}`,
    `  sizes:    valid.js=${concat.valid.js.length} valid.ts=${concat.valid.ts.length}`,
    `            invalid.js=${concat.invalid.js.length} invalid.ts=${concat.invalid.ts.length}`,
    `            all.js=${all_js.length} all.ts=${all_ts.length}`,
  ].join("\n");
  process.stdout.write(summaryLines + "\n");
  process.exit(0);
})().catch(err => {
  if (_suppressMsg(String(err?.message || err))) {
    // Benign async error from TS Language Service — extraction may be partial.
    process.exit(0);
  }
  process.stderr.write(`fatal: extraction failed: ${String(err?.message || err)}\n${err?.stack || ""}\n`);
  process.exit(1);
});
