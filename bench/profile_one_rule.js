"use strict";
/**
 * Lint ONE rule on ONE fixture, repeated N times — designed to be invoked
 * under `bun --cpu-prof --cpu-prof-md` so the resulting profile attributes
 * cost to that single rule's hot path.
 *
 * Usage:
 *   bun --cpu-prof --cpu-prof-md bench/profile_one_rule.js <rule> <fixture-path> [iters]
 */

const fs   = require("fs");
const path = require("path");

const args = process.argv.slice(2);
const ruleId  = args[0];
const fixture = args[1];
const ITERS   = parseInt(args[2] || "5", 10);

if (!ruleId || !fixture) {
  console.error("Usage: bun --cpu-prof --cpu-prof-md bench/profile_one_rule.js <rule> <fixture> [iters]");
  process.exit(1);
}

const ROOT = path.resolve(__dirname, "..");
const { lintSource } = require(path.join(ROOT, "js/api.js"));

const filePath = path.isAbsolute(fixture) ? fixture : path.join(ROOT, fixture);
const src = fs.readFileSync(filePath, "utf8");
const filename = path.basename(filePath);

(async () => {
  // Warmup — the first run pays parser-cache and rule-loader costs we don't
  // want polluting the profile.
  await lintSource(src, { filename, rules: { [ruleId]: "error" } });

  const t0 = performance.now();
  for (let i = 0; i < ITERS; i++) {
    await lintSource(src, { filename, rules: { [ruleId]: "error" } });
  }
  const ms = performance.now() - t0;
  const bytes = Buffer.byteLength(src, "utf8");
  const mbs = (bytes * ITERS) / 1024 / 1024 / (ms / 1000);
  console.error(`profile  ${ruleId}  on  ${filename}  ${ITERS}× = ${ms.toFixed(0)} ms  (${mbs.toFixed(0)} MB/s)`);
})();
