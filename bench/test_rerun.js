"use strict";
const fs = require("fs"), path = require("path");
const ROOT = path.join(__dirname, "..");
const { parseSource: parse, getTagNames } = require(path.join(ROOT, "js/index"));
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner"));
const tagNames = getTagNames();
const CORPUS = path.join(ROOT, "tests/conformance/test262-parser-tests/pass");

// Simulate exactly what the benchmark does: pre-parse all, then warmup with 2 passes
const allFiles = fs.readdirSync(CORPUS).filter(f => f.endsWith(".js"));
const N_TOTAL = allFiles.length;
const WARMUP_FILES = 50;
const MAX_FILES = 2000;
const files = allFiles.length > MAX_FILES ? allFiles.slice(0, MAX_FILES) : allFiles;
const N = files.length;

console.log(`Pre-parsing ${N} files...`);
const asts = [];
for (const f of files) {
  const src = fs.readFileSync(path.join(CORPUS, f), "utf8");
  try { asts.push(parse(src, { filename: f })); }
  catch { asts.push(null); }
}
console.log("Done.\n");

function makeSyntheticRules(n, handler) {
  return Array.from({ length: n }, (_, i) => ({
    meta: { name: `synthetic-${i}` },
    create() { return handler; },
  }));
}
const HANDLER_IDENTIFIER = { Identifier() {} };
const HANDLER_UNIVERSAL  = { "*"() {} };

const rules200id   = makeSyntheticRules(200, HANDLER_IDENTIFIER);
const rules200univ = makeSyntheticRules(200, HANDLER_UNIVERSAL);

console.log(`Starting 2-pass warmup on first ${WARMUP_FILES} files...`);
for (let pass = 0; pass < 2; pass++) {
  console.log(`Pass ${pass}...`);
  for (let i = 0; i < WARMUP_FILES; i++) {
    if (!asts[i]) continue;
    process.stdout.write(`  [${i}] id...`);
    const t0 = process.hrtime.bigint();
    try { runPlugins(asts[i], rules200id,   { filename: files[i], tagNames }); } catch {}
    const t1 = process.hrtime.bigint();
    process.stdout.write(`${(Number(t1-t0)/1e6).toFixed(1)}ms univ...`);
    try { runPlugins(asts[i], rules200univ, { filename: files[i], tagNames }); } catch {}
    const t2 = process.hrtime.bigint();
    process.stdout.write(`${(Number(t2-t1)/1e6).toFixed(1)}ms\n`);
  }
}
console.log("Warmup done!");
