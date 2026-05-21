#!/usr/bin/env bun
"use strict";
/**
 * Break down lintSource time for a single rule into constituent phases.
 * Usage: RULE=no-constant-binary-expression bun bench/bench_phase_breakdown.js
 */

const path = require("path");
const fs   = require("fs");
const api  = require("../js/api.js");
const { parseSource } = require("../js/index.js");

const RULE = process.env.RULE || "no-constant-binary-expression";
const FILE = path.resolve(__dirname, "fixtures/typescript.js");
const src  = fs.readFileSync(FILE, "utf8");
const MB   = src.length / 1024 / 1024;

const cfg     = { filename: FILE, rules: { [RULE]: "error" } };
const noopCfg = { filename: FILE, rules: { "__noop__": "error" } };
const WARMUP = 5, RUNS = 8;

function med(arr) { const s = [...arr].sort((a,b)=>a-b); return s[Math.floor(s.length/2)]; }

(async () => {
  process.stderr.write(`rule: ${RULE}  file: ${path.basename(FILE)} (${MB.toFixed(2)} MB)\n`);
  process.stderr.write("warming up...\n");
  for (let i = 0; i < WARMUP; i++) {
    globalThis.__ezPhaseLog = [];
    await api.lintSource(src, cfg);
  }

  // Measure parse-only cost (no rule, no scope setup)
  const parseTimes = [];
  const globals = []; // minimal globals
  for (let i = 0; i < RUNS; i++) {
    const t = performance.now();
    parseSource(src, { filename: FILE, globals });
    parseTimes.push(performance.now() - t);
  }
  const parseOnly = med(parseTimes);

  // Measure no-op baseline (parse + empty dispatch, no getScope)
  const noopTimes = [];
  for (let i = 0; i < RUNS; i++) {
    globalThis.__ezPhaseLog = [];
    const t = performance.now();
    await api.lintSource(src, noopCfg);
    noopTimes.push(performance.now() - t);
  }
  const noopTotal = med(noopTimes);

  // Measure full rule
  const logs = [];
  for (let i = 0; i < RUNS; i++) {
    globalThis.__ezPhaseLog = [];
    const t0 = performance.now();
    await api.lintSource(src, cfg);
    const total = performance.now() - t0;
    const entry = globalThis.__ezPhaseLog[0] || {};
    entry.total = total;
    logs.push(entry);
  }
  globalThis.__ezPhaseLog = null;

  function medField(key) { return med(logs.map(e => e[key] ?? 0)); }

  const total      = medField("total");
  const parse      = medField("parse");
  const runPlugins = medField("runPlugins");
  const bvm        = medField("buildVisitorMap");
  const walk       = medField("walkNodes");
  const precompute = medField("precomputeScopes");
  const walkRule   = walk - precompute;
  const other      = runPlugins - bvm - walk;

  console.log(`\nphase breakdown (median of ${RUNS} runs)\n`);
  console.log(`parseSource() alone       ${parseOnly.toFixed(1).padStart(7)} ms   (Zig parse, no NAPI overhead in api.js)`);
  console.log(`no-op lintSource          ${noopTotal.toFixed(1).padStart(7)} ms   (parse + resolveConfig + empty dispatch)`);
  console.log(`─────────────────────────────────────────────────────────────────`);
  console.log(`full lintSource           ${total.toFixed(1).padStart(7)} ms`);
  console.log(`  parse (in _lintSourceOne)  ${parse.toFixed(1).padStart(7)} ms`);
  console.log(`  runPlugins total           ${runPlugins.toFixed(1).padStart(7)} ms`);
  console.log(`    buildVisitorMap          ${bvm.toFixed(1).padStart(7)} ms`);
  console.log(`    walkNodes total          ${walk.toFixed(1).padStart(7)} ms`);
  console.log(`      _precomputeScopes      ${precompute.toFixed(1).padStart(7)} ms`);
  console.log(`      dispatch + rule        ${walkRule.toFixed(1).padStart(7)} ms   (${Math.round(walkRule*1000/40396)} µs/node × ~40K nodes)`);
  console.log(`    other (ctx reset etc.)   ${other.toFixed(1).padStart(7)} ms`);
  console.log(`  unaccounted               ${(total-parse-runPlugins).toFixed(1).padStart(7)} ms`);
  console.log(`─────────────────────────────────────────────────────────────────`);
  console.log(`rule net over no-op       ${(total - noopTotal).toFixed(1).padStart(7)} ms`);
})().catch(e => { console.error(e); process.exit(1); });
