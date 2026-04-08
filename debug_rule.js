const path = require("path");
const fs = require("fs");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames = getTagNames();

// Monkey-patch Module._ load to handle custom parsers
const ESLINT_ROOT = path.resolve(__dirname, "tests/conformance/eslint");
const _JS_NM = path.join(JS_ROOT, "node_modules");
const CUSTOM_PARSER_STUB = { parse() { return { type: "Program", body: [], range: [0, 0] }; } };

const _ruleTestPath = require.resolve(
  path.join(ESLINT_ROOT, "lib/rule-tester/rule-tester")
);
const _ESLINT_PREFIX = ESLINT_ROOT + path.sep;
const _origLoad = Module._load;
Module._load = function (request, parent, isMain) {
  if (parent && parent.filename) {
    // Intercept custom parsers
    try {
      const resolved = Module._resolveFilename(request, parent, isMain);
      if (resolved === _ruleTestPath) return null;
    } catch {}

    // Intercept bare imports from the ESLint submodule:
    if (!request.startsWith(".") && !request.startsWith("/")) {
      if (request === "@typescript-eslint/parser" || request.includes("parsers/")) {
        return CUSTOM_PARSER_STUB;
      }
      // ESLint submodule's own bare dependencies → redirect to js/node_modules
      if (parent.filename.startsWith(_ESLINT_PREFIX)) {
        const redirected = path.join(_JS_NM, request);
        try {
          const resolved = Module._resolveFilename(redirected, parent, isMain);
          return _origLoad.call(this, resolved, parent, isMain);
        } catch {}
      }
    }
  }
  return _origLoad.apply(this, arguments);
};

function runCase(ruleName, ruleModule, testCase, sourceType) {
  const src = testCase.code;
  try {
    const ast = parse(src, { filename: "test.js" });
    const plugin = {
      meta: { name: ruleName, defaultOptions: ruleModule.meta?.defaultOptions },
      create: ruleModule.create,
    };
    const ruleConfig = { [ruleName]: testCase.options };
    const reports = runPlugins(ast, [plugin], { tagNames, sourceType, ruleConfig });
    return reports.filter(r => !r.message?.startsWith("Plugin error:") && r.ruleId === ruleName);
  } catch (e) {
    console.error("Parse error:", e.message);
    return null;
  }
}

const RULES_DIR = path.join(ESLINT_ROOT, "lib/rules");
const TESTS_DIR = path.join(ESLINT_ROOT, "tests/lib/rules");

const ruleName = process.argv[2] || "no-extend-native";

// Load test file without CapturingRuleTester
const testFile = path.join(TESTS_DIR, `${ruleName}.js`);
let testCases = null;

const ruleTesterPath = require.resolve(path.join(ESLINT_ROOT, "lib/rule-tester/rule-tester"));
Module._load = function (request, parent, isMain) {
  if (parent && parent.filename) {
    try {
      const resolved = Module._resolveFilename(request, parent, isMain);
      if (resolved === ruleTesterPath) {
        // Return a minimal stub that captures cases
        return class {
          run(name, rule, { valid, invalid }) {
            testCases = { valid, invalid };
          }
        };
      }
    } catch {}

    if (!request.startsWith(".") && !request.startsWith("/")) {
      if (request === "@typescript-eslint/parser" || request.includes("parsers/")) {
        return CUSTOM_PARSER_STUB;
      }
      if (parent.filename.startsWith(_ESLINT_PREFIX)) {
        const redirected = path.join(_JS_NM, request);
        try {
          const resolved = Module._resolveFilename(redirected, parent, isMain);
          return _origLoad.call(this, resolved, parent, isMain);
        } catch {}
      }
    }
  }
  return _origLoad.apply(this, arguments);
};

delete require.cache[testFile];
require(testFile);

const ruleModule = require(path.join(RULES_DIR, `${ruleName}.js`));
const defaultSourceType = "script";

console.log(`\nChecking ${ruleName}:\n`);

// Check valid cases
for (let i = 0; i < testCases.valid.length; i++) {
  const tc = testCases.valid[i];
  const sourceType = tc.languageOptions?.sourceType || defaultSourceType;
  const reports = runCase(ruleName, ruleModule, tc, sourceType);
  if (reports === null) continue;
  if (reports.length !== 0) {
    console.log(`[VALID #${i}] FAIL: Expected 0, got ${reports.length}`);
    console.log(`  Code: ${tc.code}`);
    console.log(`  Errors: ${JSON.stringify(reports)}`);
  }
}

// Check invalid cases
for (let i = 0; i < testCases.invalid.length; i++) {
  const tc = testCases.invalid[i];
  const sourceType = tc.languageOptions?.sourceType || defaultSourceType;
  const want = (tc.errors || []).length;
  const reports = runCase(ruleName, ruleModule, tc, sourceType);
  if (reports === null) continue;
  if (reports.length !== want) {
    console.log(`[INVALID #${i}] FAIL: Expected ${want}, got ${reports.length}`);
    console.log(`  Code: ${tc.code}`);
    if (reports.length > 0) console.log(`  Errors: ${JSON.stringify(reports.map(r => ({ message: r.message, line: r.line, col: r.column })))}`);
  }
}
