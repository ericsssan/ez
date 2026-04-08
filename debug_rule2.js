const path = require("path");
const JS_ROOT = path.resolve(__dirname, "js");
const Module = require("module");

Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { runPlugins } = require(path.join(JS_ROOT, "eslint-runner"));
const tagNames = getTagNames();

const code = "(Object?.prototype).p = 0";
const ast = parse(code, { filename: "test.js" });

console.log("AST:", JSON.stringify(ast, null, 2).slice(0, 2000));

// Now check what's in the scope
const ruleModule = require("./tests/conformance/eslint/lib/rules/no-extend-native.js");
const plugin = {
  meta: { name: "no-extend-native", defaultOptions: ruleModule.meta?.defaultOptions },
  create: ruleModule.create,
};
const ruleConfig = { "no-extend-native": [] };
const reports = runPlugins(ast, [plugin], { tagNames, sourceType: "script", ruleConfig });

console.log("\n\nReports:", reports.filter(r => r.ruleId === "no-extend-native"));
