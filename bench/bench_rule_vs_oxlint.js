"use strict";
/**
 * Single-rule benchmark: ez (JS plugin runner) vs oxlint (native Rust).
 *
 * Rule: no-useless-return
 * File: bench/fixtures/typescript.js  (~9 MB)
 *
 * Usage:
 *   node bench/bench_rule_vs_oxlint.js
 *   RULE=no-eval node bench/bench_rule_vs_oxlint.js
 */

const { execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const { lintSource } = require("../js/api.js");

const RULE     = process.env.RULE || "no-useless-return";
const FILE     = path.resolve(__dirname, "fixtures/typescript.js");
const WARMUP   = 3;
const RUNS     = 10;

const src  = fs.readFileSync(FILE, "utf8");
const MB   = src.length / 1024 / 1024;

// ── ez ────────────────────────────────────────────────────────────────────────

async function benchEz() {
  // Stable config object — same reference every call so _resolvedCache hits.
  const cfg = { filename: FILE, rules: { [RULE]: "error" } };

  let diagCount = 0;
  for (let i = 0; i < WARMUP; i++) {
    const r = await lintSource(src, cfg);
    if (i === 0) diagCount = r.diagnostics?.length ?? r.length ?? 0;
  }

  const times = [];
  for (let i = 0; i < RUNS; i++) {
    const t = performance.now();
    await lintSource(src, cfg);
    times.push(performance.now() - t);
  }
  times.sort((a, b) => a - b);
  const med = times[Math.floor(times.length / 2)];
  return { med, diagCount };
}

// ── oxlint ────────────────────────────────────────────────────────────────────

function measureStartupMs() {
  const bin = "oxlint";
  // Lint /dev/null — zero tokens, no rules fire, just process launch overhead.
  const args = ["--threads=1", "-A", "all", "/dev/null"];
  const times = [];
  for (let i = 0; i < RUNS; i++) {
    const t = performance.now();
    try { execFileSync(bin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }); }
    catch { /* non-zero exit is normal */ }
    times.push(performance.now() - t);
  }
  times.sort((a, b) => a - b);
  return times[Math.floor(times.length / 2)];
}

function benchOxlint() {
  const bin = "oxlint";
  // Disable all rules, enable only the one we want.
  const args = ["--threads=1", "-A", "all", "-D", RULE, FILE];

  // Warmup
  for (let i = 0; i < WARMUP; i++) {
    try { execFileSync(bin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }); }
    catch (e) { /* oxlint exits non-zero when it finds errors */ }
  }

  // Parse diagnostic count from last warmup run.
  let diagCount = 0;
  try { execFileSync(bin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }); }
  catch (e) {
    const out = (e.stdout || "") + (e.stderr || "");
    const m = out.match(/Found \d+ warnings and (\d+) errors/);
    if (m) diagCount = parseInt(m[1]);
  }

  const times = [];
  for (let i = 0; i < RUNS; i++) {
    const t = performance.now();
    try { execFileSync(bin, args, { encoding: "utf8", stdio: ["ignore", "pipe", "pipe"] }); }
    catch { /* non-zero exit is normal */ }
    times.push(performance.now() - t);
  }
  times.sort((a, b) => a - b);
  const startupMs = measureStartupMs();
  const med = Math.max(0, times[Math.floor(times.length / 2)] - startupMs);
  return { med, startupMs, diagCount };
}

// ── main ──────────────────────────────────────────────────────────────────────

(async () => {
  console.log(`rule: ${RULE}  |  file: ${path.basename(FILE)}  (${MB.toFixed(2)} MB)`);
  console.log(`runs: ${RUNS} measured + ${WARMUP} warmup\n`);

  process.stdout.write("ez      warming up...\r");
  const ez = await benchEz();
  process.stdout.write("oxlint  warming up...\r");
  const ox = benchOxlint();

  const ezMBps  = (MB / (ez.med  / 1000)).toFixed(0);
  const oxMBps  = ox.med > 0 ? (MB / (ox.med  / 1000)).toFixed(0) : "∞";
  const ratio   = ox.med > 0 ? (ez.med / ox.med).toFixed(2) : "N/A";

  console.log(`${"tool".padEnd(8)}  ${"net median".padStart(10)}  ${"MB/s".padStart(8)}  diags`);
  console.log("-".repeat(48));
  console.log(`${"ez".padEnd(8)}  ${(ez.med.toFixed(1) + " ms").padStart(10)}  ${ezMBps.padStart(8)}  ${ez.diagCount}`);
  console.log(`${"oxlint".padEnd(8)}  ${(ox.med.toFixed(1) + " ms").padStart(10)}  ${oxMBps.padStart(8)}  ${ox.diagCount}  (startup: ${ox.startupMs.toFixed(1)} ms subtracted)`);
  console.log(`\nez / oxlint = ${ratio}× (net linting time, startup subtracted)`);
})().catch(e => { console.error(e); process.exit(1); });
