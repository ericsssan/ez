// Single-process Bun ezlint prototype.
//
// Replaces the Zig-host + N-bun-workers architecture for the CI
// single-shot use case. Loads ez.node (Zig parser via NAPI) and all 64
// recommended ESLint rules into ONE Bun process, parses, lints,
// prints diags. No subprocesses, no IPC, no AST publish.
//
// Usage: bun run src/bun/lint.js <source-file>

"use strict";

const fs = require("node:fs");
const path = require("node:path");

const ROOT = path.resolve(__dirname, "../..");

const tStart = performance.now();

// Load ezlint's parser + adapter + runner.
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
const { AstView, setTagNames } = require(path.join(ROOT, "js/estree-adapter.js"));
const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
setTagNames(getTagNames());

// Load all 64 ESLint recommended rules. Mirrors src/bun/worker.js.
// no-useless-assignment is dropped — the native rule already produced
// its diags during the parse step.
const RULES_DIR = path.join(ROOT, "tests/conformance/eslint/lib/rules");
const RECOMMENDED = [
  "constructor-super","for-direction","getter-return","no-async-promise-executor",
  "no-case-declarations","no-class-assign","no-compare-neg-zero","no-cond-assign",
  "no-const-assign","no-constant-binary-expression","no-constant-condition",
  "no-control-regex","no-debugger","no-delete-var","no-dupe-args","no-dupe-class-members",
  "no-dupe-else-if","no-dupe-keys","no-duplicate-case","no-empty",
  "no-empty-character-class","no-empty-pattern","no-empty-static-block","no-ex-assign",
  "no-extra-boolean-cast","no-fallthrough","no-func-assign","no-global-assign",
  "no-import-assign","no-invalid-regexp","no-irregular-whitespace","no-loss-of-precision",
  "no-misleading-character-class","no-new-native-nonconstructor","no-nonoctal-decimal-escape",
  "no-obj-calls","no-octal","no-prototype-builtins","no-redeclare","no-regex-spaces",
  "no-self-assign","no-setter-return","no-shadow-restricted-names","no-sparse-arrays",
  "no-this-before-super","no-unassigned-vars","no-undef","no-unexpected-multiline",
  "no-unreachable","no-unsafe-finally","no-unsafe-negation","no-unsafe-optional-chaining",
  "no-unused-labels","no-unused-private-class-members","no-unused-vars",
  "no-useless-backreference","no-useless-catch","no-useless-escape",
  "no-with","require-yield","use-isnan","valid-typeof",
];
const RULE_MODULES = Object.fromEntries(
  RECOMMENDED.map(name => [name, require(path.join(RULES_DIR, name + ".js"))])
);
const tLoaded = performance.now();

// Read source file.
const srcPath = process.argv[2];
const src = fs.readFileSync(srcPath, "utf8");
const tRead = performance.now();

// Parse via parseSource — uses the same NAPI path but handles isModule,
// source_type header, and tag-names properly.
const ast = parseSource(src, { filename: srcPath, sourceType: "module" });
const tParse = performance.now();

// Lint.
const tagNames = getTagNames();
const plugins = RECOMMENDED.map(name => {
  const mod = RULE_MODULES[name];
  return {
    meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
    create: mod.create || mod,
  };
});
const ruleConfig = Object.fromEntries(RECOMMENDED.map(n => [n, "error"]));
const reports = runPlugins(ast, plugins, {
  tagNames,
  filename: srcPath,
  ruleConfig,
  errorBudget: Infinity,
});
const tLint = performance.now();

console.log(`load:  ${(tLoaded-tStart).toFixed(0)}ms  (ez.node + runner + ${RECOMMENDED.length} rules)`);
console.log(`read:  ${(tRead-tLoaded).toFixed(0)}ms  (${(src.length/1024/1024).toFixed(2)}MB source)`);
console.log(`parse: ${(tParse-tRead).toFixed(0)}ms  (Zig via NAPI)`);
console.log(`lint:  ${(tLint-tParse).toFixed(0)}ms  (runPlugins, ${RECOMMENDED.length} rules)`);
console.log(`TOTAL: ${(tLint-tStart).toFixed(0)}ms  diags: ${reports.length}`);

// Debug: rule diag counts
const counts = Object.create(null);
for (const r of reports) counts[r.ruleId] = (counts[r.ruleId] || 0) + 1;
const sorted = Object.entries(counts).sort((a, b) => b[1] - a[1]);
console.log("\ntop rules by diag count:");
for (const [name, c] of sorted.slice(0, 8)) console.log(`  ${String(c).padStart(6)} ${name}`);
