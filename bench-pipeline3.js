"use strict";
/**
 * Pipeline timing benchmark v3 — clean, JIT-warmed.
 * Each segment repeats 3 times; we report the median run.
 * Segment 4b isolates ESLint traversal by subtracting parse+scope from seg 4.
 */

const fs = require("fs");
const path = require("path");

const CORPUS_DIR = path.join(__dirname, "tests/conformance/test262-parser-tests/pass");
const JS_DIR = path.join(__dirname, "js");

const files = fs.readdirSync(CORPUS_DIR).map(f => path.join(CORPUS_DIR, f));
const N = files.length;
console.log(`Corpus: ${N} files\n`);

function hrt() { return Number(process.hrtime.bigint()); }
function median(arr) {
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}
function report(label, ns) {
  const ms = (ns / 1e6).toFixed(1);
  const msPerFile = (ns / 1e6 / N).toFixed(3);
  console.log(`  ${label.padEnd(56)} ${ms.padStart(8)} ms   ${msPerFile.padStart(8)} ms/file`);
}

const { parse } = require(path.join(JS_DIR, "index"));
const { buildScopeManager } = require(path.join(JS_DIR, "scope-manager"));
const { Linter } = require(path.join(JS_DIR, "node_modules/eslint"));
const evk = require(path.join(JS_DIR, "node_modules/eslint-visitor-keys"));
const VISITOR_KEYS = evk.KEYS;

const RULES = {
  "no-unused-vars": "error",
  "no-undef": "error",
  "eqeqeq": "warn",
  "no-redeclare": "error",
};

// Load all source code once
const codes = files.map(f => fs.readFileSync(f, "utf8"));

// Warm up JIT: run full pipeline twice before measuring
for (let pass = 0; pass < 2; pass++) {
  const linter = new Linter({ configType: "flat" });
  const p = {
    parseForESLint(code, opts) {
      const ast = parse(code, { filename: (opts && opts.filePath) || "<w>" });
      return { ast: ast.root(), visitorKeys: VISITOR_KEYS, scopeManager: buildScopeManager(ast) };
    }
  };
  const cfg = [{ languageOptions: { parser: p }, rules: RULES }];
  for (let i = 0; i < N; i++) {
    try { linter.verify(codes[i], cfg, { filename: files[i] }); } catch {}
  }
}

const REPS = 3;

function runSegment(label, fn) {
  const times = [];
  for (let r = 0; r < REPS; r++) times.push(fn());
  report(label, median(times));
  return median(times);
}

console.log(`Segment (median of ${REPS} runs)                              Total (ms)   ms/file`);
console.log("─".repeat(80));

// ── 1. I/O only ──────────────────────────────────────────────────────────────
runSegment("1. I/O only (readFileSync)", () => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) fs.readFileSync(files[i], "utf8");
  return hrt() - t0;
});

// ── 2. sanz parse only ───────────────────────────────────────────────────────
runSegment("2. sanz parse only", () => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    try { parse(codes[i], { filename: files[i] }); } catch {}
  }
  return hrt() - t0;
});

// ── 3. parse + buildScopeManager ─────────────────────────────────────────────
const parseAndScopeNs = runSegment("3. parse + buildScopeManager", () => {
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    try {
      const ast = parse(codes[i], { filename: files[i] });
      buildScopeManager(ast);
    } catch {}
  }
  return hrt() - t0;
});

// ── 4. Linter.verify(), NO rules ─────────────────────────────────────────────
const noRulesNs = runSegment("4. Linter.verify(), no rules", () => {
  const linter = new Linter({ configType: "flat" });
  const p = {
    parseForESLint(code, opts) {
      const fn = (opts && opts.filePath) || "<input>";
      const ast = parse(code, { filename: fn });
      return { ast: ast.root(), visitorKeys: VISITOR_KEYS, scopeManager: buildScopeManager(ast) };
    }
  };
  const cfg = [{ languageOptions: { parser: p }, rules: {} }];
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    try { linter.verify(codes[i], cfg, { filename: files[i] }); } catch {}
  }
  return hrt() - t0;
});

// Derived: ESLint overhead with no rules = seg4 - seg3
const eslintOverheadNs = noRulesNs - parseAndScopeNs;
report("  → ESLint traversal overhead (seg4 - seg3)", eslintOverheadNs);

// ── 5. Linter.verify(), rules, NO scope manager ───────────────────────────────
let seg5crashes = 0, seg5diags = 0;
runSegment("5. Linter.verify(), rules, NO scope mgr", () => {
  const linter = new Linter({ configType: "flat" });
  const p = {
    parseForESLint(code, opts) {
      const fn = (opts && opts.filePath) || "<input>";
      const ast = parse(code, { filename: fn });
      return { ast: ast.root(), visitorKeys: VISITOR_KEYS };
    }
  };
  const cfg = [{ languageOptions: { parser: p }, rules: RULES }];
  let crashes = 0, diags = 0;
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    try { const m = linter.verify(codes[i], cfg, { filename: files[i] }); diags += m.length; }
    catch { crashes++; }
  }
  const elapsed = hrt() - t0;
  seg5crashes = crashes; seg5diags = diags;
  return elapsed;
});
console.log(`     → ${seg5crashes} crashes, ${seg5diags} diagnostics`);

// ── 6. Linter.verify(), rules, full scope manager ─────────────────────────────
let seg6crashes = 0, seg6diags = 0;
const fullNs = runSegment("6. Linter.verify(), rules, full scope mgr", () => {
  const linter = new Linter({ configType: "flat" });
  const p = {
    parseForESLint(code, opts) {
      const fn = (opts && opts.filePath) || "<input>";
      const ast = parse(code, { filename: fn });
      return { ast: ast.root(), visitorKeys: VISITOR_KEYS, scopeManager: buildScopeManager(ast) };
    }
  };
  const cfg = [{ languageOptions: { parser: p }, rules: RULES }];
  let crashes = 0, diags = 0;
  const t0 = hrt();
  for (let i = 0; i < N; i++) {
    try { const m = linter.verify(codes[i], cfg, { filename: files[i] }); diags += m.length; }
    catch { crashes++; }
  }
  const elapsed = hrt() - t0;
  seg6crashes = crashes; seg6diags = diags;
  return elapsed;
});
console.log(`     → ${seg6crashes} crashes, ${seg6diags} diagnostics`);

// Derived: rules+scope overhead over no-rules
const rulesOverheadNs = fullNs - noRulesNs;
report("  → Rules overhead (seg6 - seg4)", rulesOverheadNs);

console.log("─".repeat(80));

// ── Summary ───────────────────────────────────────────────────────────────────
console.log("\nBreakdown (seg 6 total):");
const totalNs = fullNs;
function pct(ns) { return ((ns / totalNs) * 100).toFixed(1) + "%"; }
const ioNs = 0; // codes pre-loaded, not in the timed window for seg6
console.log(`  Parse + scope manager:     ${(parseAndScopeNs/1e6).toFixed(1)} ms  (${pct(parseAndScopeNs)} of seg6)`);
console.log(`  ESLint traversal (no rules): ${(eslintOverheadNs/1e6).toFixed(1)} ms  (${pct(eslintOverheadNs)} of seg6)`);
console.log(`  Rules evaluation:          ${(rulesOverheadNs/1e6).toFixed(1)} ms  (${pct(rulesOverheadNs)} of seg6)`);
console.log(`  Total (seg 6):             ${(totalNs/1e6).toFixed(1)} ms`);
console.log(`\n  Target: 100 ms total for ${N} files`);
console.log(`  Gap:    ${((totalNs/1e6) - 100).toFixed(1)} ms over target`);

console.log("\nDone.");
