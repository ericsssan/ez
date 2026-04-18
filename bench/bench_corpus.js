// bench/bench_corpus.js
//
// Walk extracted fixture corpus, lint every file with that fixture's target
// rule enabled. Reports files/s, MB/s, ms/file distribution.
//
// Corpus layout (produced by `bun tests/differential/run.js --extract-fixtures <dir>`):
//   <dir>/corpus/<safePrefix>/<safeRule>/{valid,invalid}/N.{js,ts,jsx,tsx}
//
// IMPORTANT — by default this bench runs only the `eslint` core prefix.
// Plugin rules (unicorn/*, @typescript-eslint/*, sonarjs/*, react/*, jsdoc/*,
// promise/*) require a {prefix, plugin} config that createLinter's inline API
// does not accept, so they silently no-op — which makes plugin-prefix runs
// measure parse-only speed, not lint speed. Use --all-prefixes to include
// them (but understand the numbers are parse-dominated for those prefixes).
//
// Usage:
//   bun bench/bench_corpus.js                              # core only (default)
//   bun bench/bench_corpus.js --all-prefixes               # include plugin prefixes (no rule fire)
//   bun bench/bench_corpus.js --prefix eslint --kind invalid
//   bun bench/bench_corpus.js --limit 2000

const fs   = require("fs");
const path = require("path");
const { createLinter } = require("../js/api.js");

const args = process.argv.slice(2);
const FLAGS = new Set(["--kind", "--prefix", "--limit", "--warmup"]);
const allPrefixes = args.includes("--all-prefixes");
function flag(name, def = null) {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : def;
}
// Positional = arg that is not a flag and is not the value of any flag.
const flagValueIndices = new Set();
for (let i = 0; i < args.length; i++) if (FLAGS.has(args[i])) flagValueIndices.add(i + 1);
const positional = args.filter((a, i) => !FLAGS.has(a) && !flagValueIndices.has(i) && !a.startsWith("--"));

const root    = path.resolve(positional[0] || "bench/fixtures/extracted");
const kindArg = flag("--kind");            // "valid" | "invalid" | null (both)
const prefArg = flag("--prefix");          // filter by plugin safePrefix
const limit   = parseInt(flag("--limit", "0"), 10) || 0;
const warmup  = parseInt(flag("--warmup", "50"), 10);

const corpusRoot = path.join(root, "corpus");
if (!fs.existsSync(corpusRoot)) {
  console.error(`corpus not found: ${corpusRoot}`);
  console.error(`generate with: bun tests/differential/run.js --extract-fixtures ${root}`);
  process.exit(1);
}

function unmapPrefix(safePrefix) {
  if (safePrefix === "eslint") return null;
  if (safePrefix === "_typescript-eslint") return "@typescript-eslint";
  return safePrefix;
}

// Default to eslint-core only. --all-prefixes opts in. --prefix <x> overrides both.
const pluginPrefixes = ["_typescript-eslint", "unicorn", "react", "jsdoc", "promise", "sonarjs"];

// Walk corpus → tasks[]: { file, bytes, code, ruleId, ext }
const tasks = [];
for (const safePrefix of fs.readdirSync(corpusRoot).sort()) {
  if (prefArg) {
    if (safePrefix !== prefArg) continue;
  } else if (!allPrefixes && pluginPrefixes.includes(safePrefix)) {
    continue; // core-only default
  }
  const prefixDir = path.join(corpusRoot, safePrefix);
  if (!fs.statSync(prefixDir).isDirectory()) continue;
  const pluginPrefix = unmapPrefix(safePrefix);

  for (const safeRule of fs.readdirSync(prefixDir).sort()) {
    const ruleDir = path.join(prefixDir, safeRule);
    if (!fs.statSync(ruleDir).isDirectory()) continue;
    const ruleId = pluginPrefix ? `${pluginPrefix}/${safeRule}` : safeRule;

    for (const kind of ["valid", "invalid"]) {
      if (kindArg && kind !== kindArg) continue;
      const kindDir = path.join(ruleDir, kind);
      if (!fs.existsSync(kindDir)) continue;

      for (const entry of fs.readdirSync(kindDir)) {
        const full = path.join(kindDir, entry);
        const stat = fs.statSync(full);
        if (!stat.isFile()) continue;
        tasks.push({
          file: full,
          ext: path.extname(entry),
          ruleId,
          kind,
        });
      }
    }
  }
}

if (limit > 0 && tasks.length > limit) tasks.length = limit;
if (tasks.length === 0) {
  console.error("no fixtures matched");
  process.exit(1);
}

// Preload file contents once (don't time fs).
let totalBytes = 0;
for (const t of tasks) {
  t.code = fs.readFileSync(t.file, "utf8");
  t.bytes = Buffer.byteLength(t.code);
  totalBytes += t.bytes;
}

// Cache one linter per unique rule — avoids config resolution per file.
const linterCache = new Map();
async function linterFor(ruleId) {
  let L = linterCache.get(ruleId);
  if (!L) {
    L = await createLinter({ rules: { [ruleId]: "error" } });
    linterCache.set(ruleId, L);
  }
  return L;
}

async function run(tasks) {
  const times = new Float64Array(tasks.length);
  let diagTotal = 0, errorCount = 0;
  let invalidFired = 0, invalidCount = 0, validSilent = 0, validCount = 0;
  const t0 = performance.now();
  for (let i = 0; i < tasks.length; i++) {
    const t = tasks[i];
    const L = await linterFor(t.ruleId);
    const s = performance.now();
    let nDiags = 0;
    try {
      const diags = await L(t.code, t.file);
      nDiags = diags.length;
      diagTotal += nDiags;
    } catch (e) {
      errorCount++;
    }
    times[i] = performance.now() - s;
    if (t.kind === "invalid") { invalidCount++; if (nDiags > 0) invalidFired++; }
    else { validCount++; if (nDiags === 0) validSilent++; }
  }
  const wall = performance.now() - t0;
  return { times, diagTotal, errorCount, wall, invalidFired, invalidCount, validSilent, validCount };
}

function percentile(sorted, p) {
  const i = Math.min(sorted.length - 1, Math.floor(sorted.length * p));
  return sorted[i];
}

(async () => {
  console.log(`Corpus: ${root}`);
  console.log(`Tasks:  ${tasks.length}  (${(totalBytes / 1024 / 1024).toFixed(2)} MB)`);
  console.log(`Unique rules: ${new Set(tasks.map(t => t.ruleId)).size}`);
  if (kindArg) console.log(`Kind filter:   ${kindArg}`);
  if (prefArg) console.log(`Prefix filter: ${prefArg}`);
  console.log();

  // Warmup: prime linter cache + JIT on first N tasks
  const warmN = Math.min(warmup, tasks.length);
  console.log(`Warmup (${warmN})...`);
  await run(tasks.slice(0, warmN));

  console.log(`Bench...`);
  const { times, diagTotal, errorCount, wall, invalidFired, invalidCount, validSilent, validCount } = await run(tasks);

  const sorted = Float64Array.from(times).sort();
  const sum = times.reduce((a, b) => a + b, 0);
  const mean = sum / times.length;

  console.log();
  console.log(`=== results ===`);
  console.log(`  wall:          ${(wall / 1000).toFixed(2)} s`);
  console.log(`  files:         ${tasks.length}`);
  console.log(`  errors:        ${errorCount}`);
  console.log(`  diags total:   ${diagTotal}`);
  if (invalidCount > 0) {
    const pct = (100 * invalidFired / invalidCount).toFixed(1);
    console.log(`  invalid fire:  ${invalidFired} / ${invalidCount} (${pct}%) — rule actually detected`);
  }
  if (validCount > 0) {
    const pct = (100 * validSilent / validCount).toFixed(1);
    console.log(`  valid silent:  ${validSilent} / ${validCount} (${pct}%) — rule correctly did not fire`);
  }
  console.log(`  files/s:       ${(tasks.length / (wall / 1000)).toFixed(1)}`);
  console.log(`  MB/s:          ${(totalBytes / 1024 / 1024 / (wall / 1000)).toFixed(2)}`);
  console.log(`  mean/file:     ${mean.toFixed(3)} ms`);
  console.log(`  p50/file:      ${percentile(sorted, 0.50).toFixed(3)} ms`);
  console.log(`  p90/file:      ${percentile(sorted, 0.90).toFixed(3)} ms`);
  console.log(`  p99/file:      ${percentile(sorted, 0.99).toFixed(3)} ms`);
  console.log(`  max/file:      ${sorted[sorted.length - 1].toFixed(3)} ms`);
})().catch(e => { console.error(e); process.exit(1); });
