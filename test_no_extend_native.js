const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames = getTagNames();

// Set up module loading for ESLint rules
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
    try {
      const resolved = Module._resolveFilename(request, parent, isMain);
      if (resolved === _ruleTestPath) return null;
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

// Test both working and failing cases
const testCases = [
  { code: "Object.prototype.p = 0", shouldError: true, name: "regular" },
  { code: "(Object?.prototype).p = 0", shouldError: true, name: "optional chaining" },
];

for (const testCase of testCases) {
  console.log(`\nTesting: ${testCase.name}`);
  console.log(`Code: ${testCase.code}`);

  try {
    const ast = parse(testCase.code, { filename: "test.js" });

    // Try to find the Object identifier's parent chain
    // We'll do this by running the rule and seeing if it reports
    const ruleModule = require(path.join(__dirname, "tests/conformance/eslint/lib/rules/no-extend-native.js"));
    const plugin = {
      meta: { name: "no-extend-native", defaultOptions: ruleModule.meta?.defaultOptions },
      create: ruleModule.create,
    };
    const ruleConfig = { "no-extend-native": [] };
    const reports = runPlugins(ast, [plugin], { tagNames, sourceType: "script", ruleConfig });

    const ruleReports = reports.filter(r => r.ruleId === "no-extend-native");
    console.log(`Expected errors: ${testCase.shouldError ? 1 : 0}`);
    console.log(`Got errors: ${ruleReports.length}`);

    if (ruleReports.length > 0) {
      console.log(`Reports: ${JSON.stringify(ruleReports.map(r => ({ message: r.message, line: r.line })))}`);
    }

    if ((ruleReports.length > 0) !== testCase.shouldError) {
      console.log("❌ TEST FAILED");
    } else {
      console.log("✓ TEST PASSED");
    }
  } catch (e) {
    console.log(`Error: ${e.message}`);
  }
}
