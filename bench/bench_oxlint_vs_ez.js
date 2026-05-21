"use strict";
/**
 * Head-to-head benchmark: oxlint vs ez runner on large real-world files.
 *
 * Both tools run their full default/core rule set on the same file.
 * Measures end-to-end wall time excluding startup (warmup rounds discarded).
 *
 * Usage:
 *   bun bench/bench_oxlint_vs_ez.js [file] [--iters N] [--warmup N]
 *
 * Defaults: bench/fixtures/typescript.js, 10 iters, 3 warmup
 */

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");

const args    = process.argv.slice(2);
const _flag   = n => args.includes(n);
const _arg    = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; };
const positional = args.filter((a, i) => !a.startsWith("--") && args[i - 1] !== "--iters" && args[i - 1] !== "--warmup");

const files   = positional.length > 0
  ? positional.map(f => path.resolve(f))
  : [
      path.join(ROOT, "bench/fixtures/typescript.js"),
      path.join(ROOT, "bench/fixtures/checker.ts"),
    ];
const ITERS   = parseInt(_arg("--iters",  "10"), 10);
const WARMUP  = parseInt(_arg("--warmup", "3"),  10);

const OXLINT_BIN = (() => { try { return Bun.which("oxlint") || "/opt/homebrew/bin/oxlint"; } catch { return "oxlint"; } })();

// ── oxlint runner ─────────────────────────────────────────────────
function oxlintVersion() {
  try {
    return Buffer.from(Bun.spawnSync([OXLINT_BIN, "--version"], { stdout: "pipe" }).stdout)
      .toString().trim().replace(/^Version: /, "");
  } catch { return "?"; }
}

function runOxlint(filePath) {
  const t0 = performance.now();
  const proc = Bun.spawnSync([OXLINT_BIN, "--format", "json", filePath], { stdout: "pipe", stderr: "pipe" });
  const ms = performance.now() - t0;
  let diagCount = 0;
  try {
    const data = JSON.parse(Buffer.from(proc.stdout).toString("utf8"));
    diagCount = (data.diagnostics || []).length;
  } catch {}
  return { ms, diagCount };
}

// ── ez runner ─────────────────────────────────────────────────────
const { createLinter }  = require(path.join(ROOT, "js/api.js"));
const { loadCoreRules } = require(path.join(ROOT, "js/load-plugin.js"));

// ── stats helpers ──────────────────────────────────────────────────
function stats(times) {
  const s = [...times].sort((a, b) => a - b);
  const mean = times.reduce((a, b) => a + b, 0) / times.length;
  return { mean, p50: s[Math.floor(s.length * 0.5)], min: s[0], max: s[s.length - 1] };
}

function fmt(ms, bytes) {
  const mbps = (bytes / 1024 / 1024 / (ms / 1000)).toFixed(1);
  return `${ms.toFixed(1).padStart(7)} ms  (${mbps} MB/s)`;
}

// ── main ──────────────────────────────────────────────────────────
(async () => {
  const coreRules = loadCoreRules({ only: undefined, includeDeprecated: false });
  const rulesConfig = {};
  for (const d of coreRules) {
    if (d.meta?.name) rulesConfig[d.meta.name] = "error";
  }
  const ezLint = await createLinter({ rules: rulesConfig });

  console.log(`oxlint v${oxlintVersion()}  vs  ez runner`);
  console.log(`Iterations: ${ITERS}  Warmup: ${WARMUP}`);
  console.log(`ez rules:   ${Object.keys(rulesConfig).length} core rules\n`);

  for (const filePath of files) {
    const source = fs.readFileSync(filePath, "utf8");
    const bytes  = Buffer.byteLength(source);
    const label  = path.relative(ROOT, filePath);

    console.log(`── ${label}  (${(bytes / 1024 / 1024).toFixed(2)} MB, ${source.split("\n").length.toLocaleString()} lines) ──`);

    // Warmup both tools
    for (let i = 0; i < WARMUP; i++) {
      runOxlint(filePath);
      await ezLint(source, filePath);
    }

    // Timed oxlint
    const oxTimes = [];
    let oxDiags = 0;
    for (let i = 0; i < ITERS; i++) {
      const r = runOxlint(filePath);
      oxTimes.push(r.ms);
      oxDiags = r.diagCount;
    }

    // Timed ez
    const ezTimes = [];
    let ezDiags = 0;
    for (let i = 0; i < ITERS; i++) {
      const t0 = performance.now();
      const d = await ezLint(source, filePath);
      ezTimes.push(performance.now() - t0);
      ezDiags = d.length;
    }

    const ox = stats(oxTimes);
    const ez = stats(ezTimes);
    const ratio = ox.mean / ez.mean;

    console.log(`  oxlint:   mean ${fmt(ox.mean, bytes)}  p50 ${ox.p50.toFixed(1)}ms  min ${ox.min.toFixed(1)}ms  diags: ${oxDiags}`);
    console.log(`  ez:       mean ${fmt(ez.mean, bytes)}  p50 ${ez.p50.toFixed(1)}ms  min ${ez.min.toFixed(1)}ms  diags: ${ezDiags}`);
    if (ratio >= 1.05)      console.log(`  → ez is ${ratio.toFixed(2)}x faster than oxlint (mean)`);
    else if (ratio <= 0.95) console.log(`  → oxlint is ${(1/ratio).toFixed(2)}x faster than ez (mean)`);
    else                    console.log(`  → roughly equal (~1x)`);
    console.log();
  }
})().catch(e => { console.error(e); process.exit(1); });
