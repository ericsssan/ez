"use strict";
// Profile one rule with REUSED config so the bench measures lint time, not
// config resolution. Same shape as profile_one_rule.js otherwise.
const fs = require("fs");
const path = require("path");

const args = process.argv.slice(2);
const positional = args.filter(a => !a.startsWith("--"));
const ruleId  = positional[0];
const fixture = positional[1];
const ITERS   = parseInt(positional[2] || "20", 10);

const ROOT = path.resolve(__dirname, "..");
const filePath = path.isAbsolute(fixture) ? fixture : path.join(ROOT, fixture);
const src = fs.readFileSync(filePath, "utf8");
const filename = path.basename(filePath);
const bytes = Buffer.byteLength(src, "utf8");

(async () => {
  const { lintSource } = require(path.join(ROOT, "js/api.js"));
  // Stable config object — _resolvedCache hits across iters.
  const cfg = { filename, rules: { [ruleId]: "error" } };
  await lintSource(src, cfg); // warmup

  const tStart = performance.now();
  for (let i = 0; i < ITERS; i++) await lintSource(src, cfg);
  const ms = performance.now() - tStart;
  const mbs = (bytes * ITERS) / 1024 / 1024 / (ms / 1000);
  console.error(`${ruleId} on ${filename}  ${ITERS}× = ${ms.toFixed(0)} ms  (${(ms/ITERS).toFixed(1)} ms/iter, ${mbs.toFixed(0)} MB/s)`);
})();
