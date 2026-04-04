"use strict";
/**
 * Test every ESLint rule individually to find which ones hang.
 * Uses separate child processes with actual timeouts per rule.
 */

const fs   = require("fs");
const path = require("path");
const { spawnSync } = require("child_process");

const ROOT    = path.join(__dirname, "..");
const JS_DIR  = path.join(ROOT, "js");
const CORPUS  = path.join(ROOT, "tests/conformance/test262-parser-tests/pass");

const { loadPlugin }         = require(path.join(JS_DIR, "load-plugin"));
const allPlugins = loadPlugin("eslint", new Set());

// Range to test (pass as args: start end)
const start = parseInt(process.argv[2] || "0", 10);
const end   = parseInt(process.argv[3] || String(allPlugins.length), 10);
const N_FILES = parseInt(process.argv[4] || "10", 10);
const TIMEOUT_MS = 8000;

const slow = [];

for (let pi = start; pi < end && pi < allPlugins.length; pi++) {
  const name = allPlugins[pi].meta?.name || `rule-${pi}`;
  const t0 = Date.now();
  const res = spawnSync(process.execPath, [
    path.join(__dirname, "diagnose_slow_rules.js"),
    name.includes("/") ? name.split("/").pop() : name,
    String(N_FILES),
  ], { timeout: TIMEOUT_MS, encoding: "utf8", cwd: ROOT });

  const ms = Date.now() - t0;
  if (res.status === null || res.signal) {
    console.log(`HANG  [${pi.toString().padStart(3)}] ${name}  (killed after ${ms}ms)`);
    slow.push({ pi, name, ms, status: 'HANG' });
  } else if (ms > 2000) {
    console.log(`SLOW  [${pi.toString().padStart(3)}] ${name}  (${ms}ms)`);
    slow.push({ pi, name, ms, status: 'SLOW' });
  } else {
    process.stdout.write(`[${pi}]`);
  }
}

console.log(`\n\nSummary:`);
for (const s of slow) console.log(`  ${s.status.padEnd(6)} #${s.pi} ${s.name}  ${s.ms}ms`);
if (!slow.length) console.log("  None — all rules fast!");
