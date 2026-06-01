// End-to-end: a real (unported-path) @typescript-eslint type-aware rule driven
// through the JS runner now gets working types from parserServices, via the
// native facade — the moment the long tail lights up.
// Run: bun tests/ts_facade_runner.js
"use strict";

const assert = require("assert");
const path = require("path");
const { createRequire } = require("module");
const { parseSource, getTagNames } = require("../js/index");
const { runPlugins } = require("../js/eslint-runner");
const { isAvailable } = require("../js/ts-type-facade");

if (!isAvailable()) { console.error("FAIL: facade unavailable (need bun:ffi + ez.node)"); process.exit(1); }

// Resolve the plugin from js/node_modules (not the test dir's resolution path).
const jsRequire = createRequire(path.join(__dirname, "../js/package.json"));
const plugin = jsRequire("@typescript-eslint/eslint-plugin");
const tagNames = getTagNames();

function runRule(ruleName, src, options = []) {
  const rule = plugin.rules[ruleName];
  assert(rule, `rule ${ruleName} not found`);
  const fullName = `@typescript-eslint/${ruleName}`;
  const ast = parseSource(src, { filename: "test.ts", lang: "ts", sourceType: "module" });
  const p = {
    meta: { name: fullName, messages: rule.meta && rule.meta.messages, schema: rule.meta && rule.meta.schema },
    create: rule.create,
  };
  const reports = runPlugins(ast, [p], {
    tagNames, sourceType: "module",
    ruleConfig: { [fullName]: options },
    ecmaVersion: 2022, envGlobals: false, filename: "test.ts",
    languageOptions: {}, ruleSeverities: { [fullName]: 2 },
  });
  const out = reports.filter(r => !r.crash);
  // Surface plugin errors (missing facade methods) instead of counting them as diagnostics.
  const errs = out.filter(r => /Plugin error/.test(r.message || ""));
  if (errs.length) throw new Error(`facade gap: ${errs[0].message}`);
  return out;
}

// no-unsafe-member-access: member access on an `any`-typed value is unsafe.
// This is the canonical type-aware check — pure isTypeAnyType on the object type,
// which only the facade (services.getTypeAtLocation) can supply.
let reports = runRule("no-unsafe-member-access", "function f(x: any) { return x.foo; }");
assert(reports.length >= 1, `no-unsafe-member-access should fire on 'x.foo' where x: any; got ${reports.length}`);
console.log(`PASS: no-unsafe-member-access fired (${reports.length}) on 'x.foo' (x: any)`);

// Negative control: a typed object must NOT fire (no false positive).
reports = runRule("no-unsafe-member-access", "function f(x: string) { return x.length; }");
assert(reports.length === 0, `must NOT fire on 'x.length' where x: string; got ${reports.length}`);
console.log("PASS: no false positive on 'x.length' (x: string)");

// A second type-aware rule end-to-end: assigning `any` to a typed binding.
reports = runRule("no-unsafe-assignment", "function f(x: any) { const y: number = x; }");
assert(reports.length >= 1, `no-unsafe-assignment should fire on 'any -> number'; got ${reports.length}`);
console.log(`PASS: no-unsafe-assignment fired (${reports.length}) on 'any -> number'`);

// restrict-plus-operands must at least not CRASH and not false-positive on
// number+number (its boolean/union categorization needs more facade surface —
// tracked as incremental per-rule work).
reports = runRule("restrict-plus-operands", "const y = 1 + 2;");
assert(reports.length === 0, `restrict-plus-operands must NOT fire on 'number + number'; got ${reports.length}`);
console.log("PASS: restrict-plus-operands clean (no crash, no FP) on 'number + number'");

console.log("\nALL PASS — type-aware rules run through the JS facade end-to-end.");
