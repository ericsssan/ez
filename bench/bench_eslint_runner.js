"use strict";
/**
 * Rule-runner benchmark — measures runPlugins dispatch scaling.
 *
 * Uses synthetic noop rules (Identifier handler that does nothing) to isolate
 * pure dispatch overhead from rule evaluation cost. This directly measures
 * the context mutation / per-handler overhead we want to optimize.
 *
 * Key question: does adding more rules increase time proportionally?
 *   time(200 rules) / time(4 rules) ≈ 50×  → O(rules) bad
 *   time(200 rules) / time(4 rules) ≈ 1×   → O(1) good
 *
 * Usage: node bench/bench_eslint_runner.js [A|B|C]
 * For memory stats with GC forcing: node --expose-gc bench/bench_eslint_runner.js [A|B|C]
 */

const fs   = require("fs");
const path = require("path");

const CORPUSES = {
  A: "tests/conformance/test262-parser-tests/pass",
  B: "tests/conformance/babel/packages/babel-parser/test/fixtures",
  C: "tests/conformance/test262/test/language",
};

const corpusArg = ((process.argv[2] || "A").toUpperCase());
if (!CORPUSES[corpusArg]) {
  console.error("Usage: node bench/bench_rule_runner.js [A|B|C]");
  process.exit(1);
}

const ROOT       = path.join(__dirname, "..");
const CORPUS_DIR = path.join(ROOT, CORPUSES[corpusArg]);
const JS_DIR     = path.join(ROOT, "js");

// ── File collection ──────────────────────────────────────────────
function collectFiles(dir) {
  const out = [];
  for (const e of fs.readdirSync(dir, { withFileTypes: true })) {
    if (e.name.startsWith(".") || e.name === "node_modules") continue;
    const full = path.join(dir, e.name);
    if (e.isDirectory()) out.push(...collectFiles(full));
    else if (e.name.endsWith(".js")) out.push(full);
  }
  return out;
}

const allFiles = corpusArg === "A"
  ? fs.readdirSync(CORPUS_DIR).filter(f => f.endsWith(".js")).map(f => path.join(CORPUS_DIR, f))
  : collectFiles(CORPUS_DIR);
// Cap at 2000 files so each timed segment stays under ~1 second.
const MAX_FILES = 2000;
const files = allFiles.length > MAX_FILES ? allFiles.slice(0, MAX_FILES) : allFiles;
const N = files.length;

// Pre-load all source outside timing window
const codes = files.map(f => fs.readFileSync(f, "utf8"));

// ── Load modules ─────────────────────────────────────────────────
const { parse, getTagNames } = require(path.join(JS_DIR, "index"));
const { runPlugins }         = require(path.join(JS_DIR, "eslint-runner"));
const { loadPlugin }         = require(path.join(JS_DIR, "load-plugin"));

const tagNames = getTagNames();

// ── Synthetic rule factories ──────────────────────────────────────
function makeSyntheticRules(n, handler) {
  return Array.from({ length: n }, (_, i) => ({
    meta: { name: `synthetic-${i}` },
    create() { return handler; },
  }));
}

const HANDLER_IDENTIFIER = { Identifier() {} };
const HANDLER_UNIVERSAL  = { "*"() {} };
const HANDLER_PROGRAM    = { Program() {} };

// All non-deprecated, non-code-path ESLint rules
const pluginsAll = loadPlugin("eslint", new Set());

const COUNTS = [0, 1, 4, 10, 25, 50, 100, 200];

// Pre-parse all ASTs once — shared across all handler pattern benchmarks.
process.stdout.write("Pre-parsing corpus...");
const asts = [];
for (let i = 0; i < N; i++) {
  try { asts.push(parse(codes[i], { filename: files[i] })); }
  catch { asts.push(null); }
}
let totalNodes = 0, validFiles = 0;
for (const ast of asts) { if (ast) { totalNodes += ast.nodeCount; validFiles++; } }
const avgNodes = validFiles ? (totalNodes / validFiles).toFixed(1) : "?";
console.log(` done  (avg ${avgNodes} nodes/file)\n`);

console.log(`Corpus ${corpusArg}: ${N} files`);
console.log(`All rules: ${pluginsAll.length} loaded`);
console.log(`Synthetic sets: ${COUNTS.join(", ")} rules`);

// ── Helpers ───────────────────────────────────────────────────────
const WARMUP_FILES = Math.min(N, 50);
const REPS         = 3;

function hrt()       { return Number(process.hrtime.bigint()); }
function median(arr) { const s = [...arr].sort((a,b) => a-b); return s[Math.floor(s.length/2)]; }

function segment(fn) {
  const times = [];
  for (let r = 0; r < REPS; r++) times.push(fn());
  return median(times);
}

// ── JIT warmup ──────────────────────────────────────────────────
process.stdout.write("Warming up JIT (synthetic)...");
const rules200id   = makeSyntheticRules(200, HANDLER_IDENTIFIER);
const rules200univ = makeSyntheticRules(200, HANDLER_UNIVERSAL);
for (let pass = 0; pass < 2; pass++) {
  for (let i = 0; i < WARMUP_FILES; i++) {
    if (!asts[i]) continue;
    try { runPlugins(asts[i], rules200id,   { filename: files[i], tagNames }); } catch {}
    try { runPlugins(asts[i], rules200univ, { filename: files[i], tagNames }); } catch {}
  }
}
console.log(" done");
process.stdout.write("Warming up JIT (all rules)...\n");
// Separate warmup for all-rules
for (let i = 0; i < Math.min(N, 20); i++) {
  if (!asts[i]) continue;
  const _wt0 = process.hrtime.bigint();
  process.stdout.write(`  file[${i}] ${files[i].split('/').pop()} (${asts[i].nodeCount} nodes)... `);
  try { runPlugins(asts[i], pluginsAll, { filename: files[i], tagNames }); } catch {}
  process.stdout.write(`${(Number(process.hrtime.bigint()-_wt0)/1e6).toFixed(1)}ms\n`);
}
console.log("Warmup done.\n");

// ── runPlugins-only baseline (pre-parsed, 0 rules) ────────────────
const baseNs = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    if (!asts[i]) continue;
    try { runPlugins(asts[i], [], { filename: files[i], tagNames }); } catch {}
  }
  return hrt() - t0;
});

// ── Scaling benchmark for one handler pattern ─────────────────────
function runScalingBench(label, handlerObj, hitsPerFile) {
  const HDR = `${"Rules".padEnd(8)} ${"Total ms".padStart(10)}  ${"ms/file".padStart(10)}  ${"Dispatch ms".padStart(12)}  ${"Factor".padStart(8)}  ${"ns/call".padStart(9)}`;
  console.log(`\n${label}  (hits/file ≈ ${hitsPerFile.toFixed(1)})`);
  console.log("  " + HDR);
  console.log("  " + "─".repeat(HDR.length));

  const results = [];
  for (const n of COUNTS) {
    const plugins = makeSyntheticRules(n, handlerObj);
    const ns = segment(() => {
      const t0 = hrt();
      for (let i = 0; i < N; i++) {
        if (!asts[i]) continue;
        try { runPlugins(asts[i], plugins, { filename: files[i], tagNames }); } catch {}
      }
      return hrt() - t0;
    });
    results.push({ n, ns });
    const dispNs  = ns - baseNs;
    const totalMs = (ns / 1e6).toFixed(1);
    const msf     = (ns / 1e6 / N).toFixed(4);
    const dispMs  = (dispNs / 1e6).toFixed(1);
    const base1   = results.length > 1 ? results[1].ns - baseNs : 0;
    const factor  = n === 0 ? "—" : (base1 > 0 ? (dispNs / base1).toFixed(2) + "×" : "—");
    const totalCalls = n * hitsPerFile * N;
    const nsPerCall  = n > 0 && totalCalls > 0 ? (dispNs / totalCalls).toFixed(1) : "—";
    console.log(`  ${String(n).padEnd(8)} ${totalMs.padStart(10)}  ${msf.padStart(10)}  ${dispMs.padStart(12)}  ${factor.padStart(8)}  ${nsPerCall.padStart(9)}`);
  }

  const ns1   = results[1] ? results[1].ns - baseNs : 1;
  const ns200 = results[results.length - 1].ns - baseNs;
  const ratio = ns200 / (ns1 || 1);
  // Ratio buckets: 200x more rules → how much slower?
  //   < 3x  → O(1): traversal/parse dominates, adding rules is essentially free
  //   < 15x → sub-linear: good (~O(log n) territory, dispatch tables working)
  //   < 80x → moderate: noticeable scaling, room for improvement
  //   else  → near-linear: O(rules) dispatch problem
  let verdict;
  if      (ratio < 3)   verdict = "✓ O(1)  (traversal dominates, rules are free)";
  else if (ratio < 15)  verdict = "~ sub-linear  (~O(log n) dispatch overhead)";
  else if (ratio < 80)  verdict = "~ moderate  (noticeable scaling)";
  else                  verdict = "✗ near-linear  ← O(rules) problem";
  console.log(`  Rules 1→200: 200×  |  Dispatch 1→200: ${ratio.toFixed(1)}×  |  ${verdict}`);
  return results;
}

// ── Count hits per file ───────────────────────────────────────────
let identHits = 0, allHits = 0;
for (const ast of asts) {
  if (!ast) continue;
  allHits += ast.nodeCount;
  const identTag = tagNames.indexOf('Identifier');
  if (identTag >= 0) {
    for (let i = 0; i < ast.nodeCount; i++) {
      if (ast.nodeTags[i] === identTag) identHits++;
    }
  }
}
const hitsId   = identHits / validFiles;
const hitsAll  = allHits   / validFiles;
const hitsProg = 1.0;

// ── Segments ──────────────────────────────────────────────────────
console.log(`${"Baseline (pre-parsed, 0 rules)".padEnd(48)} ${(baseNs/1e6).toFixed(1).padStart(8)} ms  ${(baseNs/1e6/N).toFixed(4).padStart(9)} ms/file`);

runScalingBench("Handler: Identifier  (sparse — exposes parse-dominance illusion)", HANDLER_IDENTIFIER, hitsId);
runScalingBench("Handler: *           (every node — exposes real dispatch scaling)", HANDLER_UNIVERSAL,  hitsAll);
runScalingBench("Handler: Program     (once/file — pure per-file overhead)",         HANDLER_PROGRAM,    hitsProg);

// ── All rules benchmark ───────────────────────────────────────────
console.log();
const nsAll = segment(() => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    if (!asts[i]) continue;
    try { runPlugins(asts[i], pluginsAll, { filename: files[i], tagNames }); } catch {}
  }
  return hrt() - t0;
});
console.log(`All rules (${pluginsAll.length}): ${(nsAll/1e6).toFixed(1)} ms  dispatch ${((nsAll-baseNs)/1e6).toFixed(1)} ms  (${(nsAll/1e6/N).toFixed(4)} ms/file)`);

console.log("\nDone.");
