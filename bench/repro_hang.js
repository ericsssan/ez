"use strict";
const fs = require("fs"), path = require("path");
const ROOT = path.join(__dirname, "..");
const { parseSource: parse, getTagNames } = require(path.join(ROOT, "js/index"));
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner"));
const { loadPlugin } = require(path.join(ROOT, "js/load-plugin"));
const tagNames = getTagNames();
const CORPUS = path.join(ROOT, "tests/conformance/test262-parser-tests/pass");

const allFiles = fs.readdirSync(CORPUS).filter(f => f.endsWith(".js"));
const asts = allFiles.map(f => {
  try { return parse(fs.readFileSync(path.join(CORPUS, f), "utf8"), { filename: f }); }
  catch { return null; }
});

function makeSyntheticRules(n, handler) {
  return Array.from({ length: n }, (_, i) => ({ meta: { name: `syn-${i}` }, create() { return handler; } }));
}
const pluginsAll = loadPlugin("eslint", new Set());
const noCC = pluginsAll.find(p => (p.meta?.name || '').includes('no-constant-condition'));
console.log("no-constant-condition rule:", noCC ? "found" : "NOT FOUND");

// Minimal reproduction: just run no-constant-condition on file[0] then file[1]
// with the _nodeCachePool state that the benchmark creates

// Step 1: synthetic warmup to set up _nodeCachePool state
for (let pass = 0; pass < 2; pass++) {
  for (let i = 0; i < 50; i++) {
    if (!asts[i]) continue;
    try { runPlugins(asts[i], makeSyntheticRules(200, { Identifier() {} }), { filename: allFiles[i], tagNames }); } catch {}
  }
}
console.log("Synthetic warmup done\n");

// Step 2: Run no-constant-condition alone on file[0]
process.stdout.write(`file[0] (${asts[0]?.nodeCount} nodes) with no-constant-condition... `);
let t = process.hrtime.bigint();
try { runPlugins(asts[0], [noCC], { filename: allFiles[0], tagNames }); } catch(e) { console.error(e.message); }
console.log(`${(Number(process.hrtime.bigint()-t)/1e6).toFixed(1)}ms`);

// Step 3: Run no-constant-condition on file[1]
process.stdout.write(`file[1] (${asts[1]?.nodeCount} nodes) with no-constant-condition... `);
t = process.hrtime.bigint();
try { runPlugins(asts[1], [noCC], { filename: allFiles[1], tagNames }); } catch(e) { console.error(e.message); }
console.log(`${(Number(process.hrtime.bigint()-t)/1e6).toFixed(1)}ms`);
console.log("DONE");
