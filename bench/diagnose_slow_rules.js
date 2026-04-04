"use strict";
/**
 * Diagnostic: identify bottlenecks in slow ESLint rules.
 * Times each file individually and prints progress.
 * Usage: node bench/diagnose_slow_rules.js [rule-name]
 */

const fs   = require("fs");
const path = require("path");

const ROOT    = path.join(__dirname, "..");
const JS_DIR  = path.join(ROOT, "js");
const CORPUS  = path.join(ROOT, "tests/conformance/test262-parser-tests/pass");

const { parse, getTagNames } = require(path.join(JS_DIR, "index"));
const { runPlugins }         = require(path.join(JS_DIR, "eslint-runner"));
const { loadPlugin }         = require(path.join(JS_DIR, "load-plugin"));

const tagNames = getTagNames();
const TARGET = (process.argv[2] || "camelcase").toLowerCase();
const MAX_FILES = parseInt(process.argv[3] || "5", 10);

const all = loadPlugin("eslint", new Set());
const pluginsToTest = TARGET === "all" ? all : all.filter(p => {
  const n = (p.meta?.name || "").includes("/") ? p.meta.name.split("/").pop() : p.meta?.name || "";
  return TARGET.split(",").includes(n);
});

console.log(`Testing ${pluginsToTest.length} rule(s): ${pluginsToTest.map(p => p.meta?.name).join(", ")}`);

const allFiles = fs.readdirSync(CORPUS).filter(f => f.endsWith(".js")).slice(0, MAX_FILES);
console.log(`Files: ${allFiles.length} from corpus A\n`);

for (const f of allFiles) {
  const src = fs.readFileSync(path.join(CORPUS, f), "utf8");
  let ast;
  try { ast = parse(src, { filename: f }); }
  catch { process.stdout.write(`  PARSE_ERR  ${f}\n`); continue; }

  process.stdout.write(`  processing ${f} (${ast.nodeCount} nodes)... `);
  const t0 = process.hrtime.bigint();
  try { runPlugins(ast, pluginsToTest, { filename: f, tagNames }); }
  catch (e) { process.stdout.write(`ERROR: ${e.message}\n`); continue; }
  const dt = Number(process.hrtime.bigint() - t0) / 1e6;
  process.stdout.write(`${dt.toFixed(1)} ms\n`);
}
console.log("\nDone.");
