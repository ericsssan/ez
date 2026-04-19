#!/usr/bin/env bun
// Profile the current lint pipeline with Tier A live.
// Breaks per-file time into phases (parse, native, JS dispatch) and ranks
// hotspots to pick the next real bottleneck.
//
// Uses real fixture files (varied JS from tests/conformance) to avoid the
// synthetic-input bias of bench-tier-a.js.

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { performance } = require("node:perf_hooks");

const ROOT = path.join(__dirname, "..");

// Pick a source directory with varied realistic JS. test262 parser tests are
// small + compile-able, a good mix of syntax shapes.
const CORPUS_CANDIDATES = [
  "tests/conformance/test262-parser-tests/pass",
  "tests/fixtures",
];

function pickCorpus() {
  for (const c of CORPUS_CANDIDATES) {
    const full = path.join(ROOT, c);
    if (fs.existsSync(full) && fs.statSync(full).isDirectory()) return full;
  }
  throw new Error("No corpus directory found");
}

function collectFiles(dir, limit) {
  const out = [];
  const walk = (d) => {
    for (const e of fs.readdirSync(d, { withFileTypes: true })) {
      if (out.length >= limit) return;
      const p = path.join(d, e.name);
      if (e.isDirectory()) walk(p);
      else if (e.name.endsWith(".js") || e.name.endsWith(".ts")) out.push(p);
    }
  };
  walk(dir);
  return out;
}

const FILE_LIMIT = parseInt(process.env.PROF_FILES || "500", 10);
const ITER = parseInt(process.env.PROF_ITER || "3", 10);

// Representative rule set. --recommended switches to ~50-rule config to measure
// realistic production load. Default: 14-rule mixed-tier.
const RULES_SMALL = {
  // Tier A
  "no-buffer-constructor": "error",
  "strict": "error",
  "func-name-matching": "error",
  "eol-last": "error",
  "no-restricted-syntax": ["error", "WithStatement"],
  "init-declarations": "error",
  // Tier B
  "sort-vars": "error",
  "arrow-parens": "error",
  "one-var": "error",
  "semi-spacing": "error",
  "space-infix-ops": "error",
  "curly": "error",
  // Tier D
  "no-loop-func": "error",
  "no-fallthrough": "error",
};

// Large representative set — mirrors typical eslint-recommended + extras.
const RULES_LARGE = {
  ...RULES_SMALL,
  "no-var": "error", "no-console": "error", "prefer-const": "error",
  "no-eval": "error", "no-undef": "error", "eqeqeq": "error",
  "no-shadow": "error", "no-redeclare": "error", "no-unused-expressions": "error",
  "no-multi-str": "error", "no-new-wrappers": "error", "no-proto": "error",
  "no-caller": "error", "no-with": "error", "no-return-assign": "error",
  "no-sequences": "error", "no-self-compare": "error", "no-throw-literal": "error",
  "no-useless-call": "error", "no-useless-concat": "error",
  "prefer-arrow-callback": "error", "prefer-template": "error",
  "no-array-constructor": "error", "no-lonely-if": "error",
  "no-mixed-operators": "error", "no-nested-ternary": "error",
  "no-unneeded-ternary": "error", "object-shorthand": "error",
  "one-var-declaration-per-line": "error", "operator-assignment": "error",
  "prefer-destructuring": "error", "prefer-rest-params": "error",
  "prefer-spread": "error", "quote-props": ["error", "consistent"],
  "radix": "error", "require-yield": "error", "yoda": "error",
};

const RULES = process.argv.includes("--recommended") ? RULES_LARGE : RULES_SMALL;

async function main() {
  const corpus = pickCorpus();
  const files = collectFiles(corpus, FILE_LIMIT);
  if (files.length === 0) throw new Error(`No files in ${corpus}`);

  console.error(`corpus: ${corpus}`);
  console.error(`files: ${files.length}, iterations: ${ITER}\n`);

  // Load sources up front so I/O is not in the timed section.
  const sources = files.map(f => ({
    filename: path.relative(ROOT, f),
    source: fs.readFileSync(f, "utf8"),
  }));

  const api = require(path.resolve(ROOT, "js/api.js"));
  const runner = require(path.resolve(ROOT, "js/eslint-runner.js"));
  const { parseSource } = require(path.resolve(ROOT, "js/index.js"));

  const lintText = await api.createLinter({ rules: RULES });

  // Warmup: lint a handful of files to let V8 tier up.
  for (const s of sources.slice(0, 20)) await lintText(s.source, s.filename);

  // Split rules: native-handled vs JS-dispatched. Build three linters to isolate
  // each phase's contribution: parse / native-only / full (native + JS).
  const { getNativeRules } = require(path.resolve(ROOT, "js/index.js"));
  const native = getNativeRules();
  const nativeOnlyRules = {};
  const jsOnlyRules = {};
  for (const [k, v] of Object.entries(RULES)) {
    if (native.has(k)) nativeOnlyRules[k] = v;
    else jsOnlyRules[k] = v;
  }

  const nativeLinter = await api.createLinter({ rules: nativeOnlyRules });
  // Warm
  for (const s of sources.slice(0, 20)) await nativeLinter(s.source, s.filename);

  // Full-pipeline timing: parse + native + JS dispatch.
  const fullTimes = [];
  for (let iter = 0; iter < ITER; iter++) {
    const start = performance.now();
    for (const s of sources) await lintText(s.source, s.filename);
    fullTimes.push(performance.now() - start);
  }

  // Native-only timing (parse + Zig rule dispatch, no JS).
  const nativeTimes = [];
  for (let iter = 0; iter < ITER; iter++) {
    const start = performance.now();
    for (const s of sources) await nativeLinter(s.source, s.filename);
    nativeTimes.push(performance.now() - start);
  }

  // Parse-only timing.
  const parseTimes = [];
  for (let iter = 0; iter < ITER; iter++) {
    const start = performance.now();
    for (const s of sources) {
      try { parseSource(s.source, { filename: s.filename }); } catch {}
    }
    parseTimes.push(performance.now() - start);
  }

  const fullMin = Math.min(...fullTimes);
  const nativeMin = Math.min(...nativeTimes);
  const parseMin = Math.min(...parseTimes);
  const nFiles = sources.length;

  const fullPer = fullMin / nFiles;
  const nativePer = nativeMin / nFiles;
  const parsePer = parseMin / nFiles;

  const jsPer = Math.max(0, fullPer - nativePer);
  const zigRulesPer = Math.max(0, nativePer - parsePer);

  const pctParse = (parsePer / fullPer) * 100;
  const pctZigRules = (zigRulesPer / fullPer) * 100;
  const pctJs = (jsPer / fullPer) * 100;

  console.log("─────────────────────────────────────────────");
  console.log(`Configured:      ${Object.keys(RULES).length} rules (${Object.keys(nativeOnlyRules).length} native, ${Object.keys(jsOnlyRules).length} JS)`);
  console.log(`Full pipeline:   ${fullMin.toFixed(0)} ms (${nFiles} files, ${fullPer.toFixed(3)} ms/file)`);
  console.log(`  Parse (NAPI):  ${parseMin.toFixed(0)} ms (${parsePer.toFixed(3)} ms/file, ${pctParse.toFixed(0)}%)`);
  console.log(`  Zig rules:     ${(zigRulesPer * nFiles).toFixed(0)} ms (${zigRulesPer.toFixed(3)} ms/file, ${pctZigRules.toFixed(0)}%)`);
  console.log(`  JS dispatch:   ${(jsPer * nFiles).toFixed(0)} ms (${jsPer.toFixed(3)} ms/file, ${pctJs.toFixed(0)}%)`);
  console.log(`Throughput:     ${(nFiles / (fullMin / 1000)).toFixed(0)} files/sec`);
  console.log("─────────────────────────────────────────────");

  // Tier A on/off comparison (restart subprocess would be cleaner, but we approximate
  // by recording hot-path-create-count via the existing global hook).
  let totalCreates = 0;
  globalThis.__EZ_BENCH_CREATE_COUNTER__ = () => totalCreates++;
  for (const s of sources) await lintText(s.source, s.filename);
  console.log(`plugin.create() calls: ${totalCreates} (${(totalCreates / nFiles).toFixed(1)} per file)`);
  console.log("");

  console.log("Interpretation:");
  const perJsRule = jsPer / Math.max(1, Object.keys(jsOnlyRules).length);
  const perZigRule = zigRulesPer / Math.max(1, Object.keys(nativeOnlyRules).length);
  console.log(`  Per-rule cost: Zig ${(perZigRule * 1000).toFixed(2)} µs/rule/file, JS ${(perJsRule * 1000).toFixed(2)} µs/rule/file (${(perJsRule / perZigRule).toFixed(1)}× ratio)`);
  if (pctJs > 40) {
    console.log(`  JS dispatch dominates (${pctJs.toFixed(0)}%). Look at prefix trie, precompiled esquery, or porting hot rules to Zig.`);
  } else if (pctParse > 40) {
    console.log(`  Parse dominates (${pctParse.toFixed(0)}%). Look at NAPI overhead or Zig parser hot path.`);
  } else if (pctZigRules > 40) {
    console.log(`  Zig rules dominate (${pctZigRules.toFixed(0)}%). Look at SoA layout, selector dispatch tables, or rule-specific hot paths.`);
  } else {
    console.log(`  Balanced: parse ${pctParse.toFixed(0)}% / Zig ${pctZigRules.toFixed(0)}% / JS ${pctJs.toFixed(0)}%.`);
  }
}

main().catch(err => {
  console.error(err.stack || err);
  process.exit(1);
});
