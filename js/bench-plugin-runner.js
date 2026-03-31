"use strict";
/**
 * Phase 5: Benchmark JS plugin runner vs Zig native linter.
 *
 * Measures:
 *   1. Parse time (Zig native)
 *   2. 10 rules via JS plugin runner
 *   3. 10 rules via Zig native linter (sanz lint CLI)
 */

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");
const { parse, getTagNames } = require("./index");
const { runPlugins } = require("./plugin-runner");

const RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");
const FIXTURES_DIR = path.join(__dirname, "../bench/fixtures");
const tagNames = getTagNames();

// 10 representative rules spanning different visitor patterns
const RULE_NAMES = [
  "eqeqeq",           // BinaryExpression visitor, simple
  "no-var",           // VariableDeclaration visitor
  "no-debugger",      // DebuggerStatement visitor
  "no-dupe-keys",     // ObjectExpression visitor
  "no-self-compare",  // BinaryExpression visitor
  "no-nested-ternary",// ConditionalExpression visitor
  "no-extra-semi",    // EmptyStatement, ExpressionStatement visitors
  "no-empty",         // BlockStatement visitor
  "semi",             // ExpressionStatement:exit, many visitors
  "indent",           // Every node type — heaviest rule
];

const FIXTURES = ["jquery.js", "lodash.js", "three.js"];
const ITERATIONS = 5;

function median(arr) {
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}

function fmt(ns) {
  if (ns < 1e6) return (ns / 1e3).toFixed(1) + "µs";
  if (ns < 1e9) return (ns / 1e6).toFixed(1) + "ms";
  return (ns / 1e9).toFixed(2) + "s";
}

// Load rule modules once
const plugins = RULE_NAMES.map(name => {
  const rule = require(path.join(RULES_DIR, name));
  return {
    meta: { name, defaultOptions: rule.meta?.defaultOptions },
    create: rule.create,
  };
});

console.log(`\nBenchmark: JS plugin runner (${RULE_NAMES.length} rules, ${ITERATIONS} iterations)\n`);
console.log(`${"Fixture".padEnd(12)} ${"Size".padStart(8)} ${"Parse(ms)".padStart(10)} ${"JS rules(ms)".padStart(13)} ${"ms/rule".padStart(9)} ${"Violations".padStart(11)}`);
console.log("─".repeat(70));

for (const fixture of FIXTURES) {
  const fixturePath = path.join(FIXTURES_DIR, fixture);
  if (!fs.existsSync(fixturePath)) continue;
  const src = fs.readFileSync(fixturePath, "utf8");
  if (src.startsWith("404")) continue;
  const sizeKB = (src.length / 1024).toFixed(0) + "KB";

  // Warm up
  for (let w = 0; w < 2; w++) {
    const ast = parse(src, { filename: fixture });
    runPlugins(ast, plugins, { tagNames });
  }

  const parseTimes = [];
  const runTimes = [];
  let violationCount = 0;

  for (let iter = 0; iter < ITERATIONS; iter++) {
    let t0 = process.hrtime.bigint();
    const ast = parse(src, { filename: fixture });
    parseTimes.push(Number(process.hrtime.bigint() - t0));

    t0 = process.hrtime.bigint();
    const reports = runPlugins(ast, plugins, { tagNames });
    runTimes.push(Number(process.hrtime.bigint() - t0));

    if (iter === 0) violationCount = reports.filter(r => !r.message.startsWith("Plugin error:")).length;
  }

  const parseMs = (median(parseTimes) / 1e6).toFixed(1);
  const runMs = (median(runTimes) / 1e6).toFixed(1);
  const msPerRule = (median(runTimes) / 1e6 / RULE_NAMES.length).toFixed(1);

  console.log(
    `${fixture.replace(".js","").padEnd(12)} ${sizeKB.padStart(8)} ${parseMs.padStart(10)} ${runMs.padStart(13)} ${msPerRule.padStart(9)} ${String(violationCount).padStart(11)}`
  );
}

// Throughput summary
console.log("\n── Throughput (parse + 10 rules) ──");
for (const fixture of FIXTURES) {
  const fixturePath = path.join(FIXTURES_DIR, fixture);
  if (!fs.existsSync(fixturePath)) continue;
  const src = fs.readFileSync(fixturePath, "utf8");
  if (src.startsWith("404")) continue;

  const times = [];
  for (let iter = 0; iter < ITERATIONS; iter++) {
    const t0 = process.hrtime.bigint();
    const ast = parse(src, { filename: fixture });
    runPlugins(ast, plugins, { tagNames });
    times.push(Number(process.hrtime.bigint() - t0));
  }
  const totalMs = median(times) / 1e6;
  const mbPerSec = (src.length / 1024 / 1024 / (totalMs / 1000)).toFixed(0);
  console.log(`  ${fixture.padEnd(14)}: ${totalMs.toFixed(1)}ms total → ${mbPerSec} MB/s`);
}

console.log();
