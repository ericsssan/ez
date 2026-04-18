// bench/bench_single.js
//
// Lint one real-world fixture with every bundled core rule enabled.
// Measures throughput of ez's full ruleset against realistic code.
//
// The extracted concat files (all.js / invalid-all.js) are NOT safe to use
// here — concatenated test cases contain top-level `return`, duplicate `let`
// bindings, mismatched `import`/`export`, etc. that break as one module.
// Use a real fixture (lodash.js, typescript.js, jquery.js) for single-file.
//
// Usage:
//   bun bench/bench_single.js                  (default: bench/fixtures/lodash.js)
//   bun bench/bench_single.js bench/fixtures/typescript.js
//   bun bench/bench_single.js --iters 20 --warmup 3

const fs   = require("fs");
const path = require("path");
const { createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");

const args = process.argv.slice(2);
const FLAGS = new Set(["--iters", "--warmup"]);
function flag(name, def = null) {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : def;
}
const flagValueIndices = new Set();
for (let i = 0; i < args.length; i++) if (FLAGS.has(args[i])) flagValueIndices.add(i + 1);
const positional = args.filter((a, i) => !FLAGS.has(a) && !flagValueIndices.has(i) && !a.startsWith("--"));

const fileArg = positional[0] || "bench/fixtures/lodash.js";
const iters   = parseInt(flag("--iters", "10"), 10);
const warmup  = parseInt(flag("--warmup", "3"), 10);

const filePath = path.resolve(fileArg);
if (!fs.existsSync(filePath)) {
  console.error(`fixture not found: ${filePath}`);
  console.error(`generate with: bun tests/differential/run.js --extract-fixtures bench/fixtures/extracted`);
  process.exit(1);
}

const source = fs.readFileSync(filePath, "utf8");
const bytes  = Buffer.byteLength(source);

// Enable every bundled core rule as "error" — maximum rule-dispatch stress.
const coreRules = loadCoreRules({ only: undefined, includeDeprecated: false });
const rulesConfig = {};
for (const d of coreRules) {
  if (d.meta?.name) rulesConfig[d.meta.name] = "error";
}

(async () => {
  const L = await createLinter({ rules: rulesConfig });

  console.log(`File:         ${filePath}`);
  console.log(`Size:         ${bytes} bytes (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`Rules:        ${Object.keys(rulesConfig).length} core rules enabled`);
  console.log(`Iterations:   ${iters} (warmup ${warmup})`);
  console.log();

  // Warmup — not timed.
  for (let i = 0; i < warmup; i++) await L(source, filePath);

  const times = [];
  let lastDiagCount = 0;
  for (let i = 0; i < iters; i++) {
    const t0 = performance.now();
    const diags = await L(source, filePath);
    const t = performance.now() - t0;
    times.push(t);
    lastDiagCount = diags.length;
  }

  const sorted = [...times].sort((a, b) => a - b);
  const sum = times.reduce((a, b) => a + b, 0);
  const mean = sum / times.length;
  const p = f => sorted[Math.min(sorted.length - 1, Math.floor(sorted.length * f))];

  console.log(`=== results ===`);
  console.log(`  diags:      ${lastDiagCount}`);
  console.log(`  mean:       ${mean.toFixed(2)} ms  (${(bytes / 1024 / 1024 / (mean / 1000)).toFixed(2)} MB/s)`);
  console.log(`  p50:        ${p(0.50).toFixed(2)} ms`);
  console.log(`  p90:        ${p(0.90).toFixed(2)} ms`);
  console.log(`  min:        ${sorted[0].toFixed(2)} ms`);
  console.log(`  max:        ${sorted[sorted.length - 1].toFixed(2)} ms`);
})().catch(e => { console.error(e); process.exit(1); });
