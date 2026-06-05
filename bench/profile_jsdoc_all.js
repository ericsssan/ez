"use strict";
// Lint typescript.js with ALL jsdoc rules, repeated N times. Designed to be
// run under `bun --cpu-prof --cpu-prof-md` so the resulting profile shows
// where time actually goes inside jsdoc rule execution.

const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const { lintSource } = require(path.join(ROOT, "js/api.js"));
const { bundleRulesFor } = require(path.join(ROOT, "js/rule-loader.js"));

const ITERS = parseInt(process.argv[2] || "5", 10);
const fixture = process.argv[3] || "bench/fixtures/typescript.js";
const filePath = path.isAbsolute(fixture) ? fixture : path.join(ROOT, fixture);
const src = fs.readFileSync(filePath, "utf8");
const filename = path.basename(filePath);

const allRules = Object.keys(bundleRulesFor("eslint-plugin-jsdoc") || {});
const rules = {};
for (const r of allRules) rules["eslint-plugin-jsdoc/" + r] = "error";
const cfg = { filename, rules, plugins: ["eslint-plugin-jsdoc"] };

(async () => {
  await lintSource(src, cfg); // warmup
  const t0 = performance.now();
  for (let i = 0; i < ITERS; i++) await lintSource(src, cfg);
  const ms = performance.now() - t0;
  const bytes = Buffer.byteLength(src, "utf8");
  const mbs = (bytes * ITERS) / 1024 / 1024 / (ms / 1000);
  console.error(`profile  ALL_jsdoc(${allRules.length})  on  ${filename}  ${ITERS}× = ${ms.toFixed(0)} ms  (${mbs.toFixed(0)} MB/s)`);
})();
