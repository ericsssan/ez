// bench/bench_corpus.js
//
// Walk extracted fixture corpus, lint every file with ALL core rules enabled —
// the same shape as a real editor save or CI lint pass. One linter instance,
// 199 bundled rules, re-used across every file.
//
// Corpus layout (produced by `bun tests/differential/run.js --extract-fixtures <dir>`):
//   <dir>/corpus/<safePrefix>/<safeRule>/{valid,invalid}/N.{js,ts,jsx,tsx}
//
// Plugin-prefix fixtures (unicorn/*, @typescript-eslint/*, sonarjs/*, react/*,
// jsdoc/*, promise/*) are still used as input source text — the core rules
// just run over whatever bytes are there. That's closer to real usage too,
// since those test files contain idiomatic JS/TS that any real project
// contains.
//
// Modes:
//   (default)      all core rules on every file (production shape)
//   --per-rule     one-rule-per-file (synthetic — for A/B rule-impl timing)
//
// Filters:
//   --kind {valid|invalid}
//   --prefix <safePrefix>
//   --limit N       truncate task list
//   --warmup N      (default 50)
//
// Usage:
//   bun bench/bench_corpus.js                                  # all-rules default
//   bun bench/bench_corpus.js --per-rule                       # old per-rule mode
//   bun bench/bench_corpus.js --prefix eslint --kind invalid
//   bun bench/bench_corpus.js --limit 5000

const fs   = require("fs");
const path = require("path");
const { createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");

const args = process.argv.slice(2);
const FLAGS = new Set(["--kind", "--prefix", "--limit", "--warmup"]);
const perRule = args.includes("--per-rule");
function flag(name, def = null) {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : def;
}
const flagValueIndices = new Set();
for (let i = 0; i < args.length; i++) if (FLAGS.has(args[i])) flagValueIndices.add(i + 1);
const positional = args.filter((a, i) => !FLAGS.has(a) && !flagValueIndices.has(i) && !a.startsWith("--"));

const root    = path.resolve(positional[0] || "bench/fixtures/extracted");
const kindArg = flag("--kind");
const prefArg = flag("--prefix");
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

// Walk corpus → tasks[]: { file, ext, ruleId, kind }
// Sort at EVERY level. Unsorted filesystem order within a kind/ directory
// triggers a Bun/JSC pathology on the full corpus (some adversarial sequence
// of rule/code pairs makes RSS jump from ~400 MB to 48 GB in one step and
// crashes with Bus error). Alphabetical order avoids it.
const tasks = [];
for (const safePrefix of fs.readdirSync(corpusRoot).sort()) {
  if (prefArg && safePrefix !== prefArg) continue;
  const prefixDir = path.join(corpusRoot, safePrefix);
  if (!fs.statSync(prefixDir).isDirectory()) continue;
  const pluginPrefix = unmapPrefix(safePrefix);

  for (const safeRule of fs.readdirSync(prefixDir).sort()) {
    const ruleDir = path.join(prefixDir, safeRule);
    if (!fs.statSync(ruleDir).isDirectory()) continue;
    const ruleId = pluginPrefix ? `${pluginPrefix}/${safeRule}` : safeRule;

    for (const kind of ["invalid", "valid"]) {
      if (kindArg && kind !== kindArg) continue;
      const kindDir = path.join(ruleDir, kind);
      if (!fs.existsSync(kindDir)) continue;

      for (const entry of fs.readdirSync(kindDir).sort()) {
        const full = path.join(kindDir, entry);
        if (!fs.statSync(full).isFile()) continue;
        tasks.push({ file: full, ext: path.extname(entry), ruleId, kind });
      }
    }
  }
}

if (limit > 0 && tasks.length > limit) tasks.length = limit;
if (tasks.length === 0) {
  console.error("no fixtures matched");
  process.exit(1);
}

// Read file contents lazily during bench; preloading 56K strings + their
// NAPI-side parsed AST mirrors caused OOM on full corpus runs.
// Stat the files once to compute a total-bytes headline, then re-read per call.
let totalBytes = 0;
for (const t of tasks) {
  t.bytes = fs.statSync(t.file).size;
  totalBytes += t.bytes;
}

// Build all-rules config (production shape): every bundled core rule +
// every installed plugin rule, all at "error". Mirrors a maxed-out editor
// or CI config.
//
// Plugins are resolved from js/node_modules. Each entry's `prefix` is the
// ESLint short name (drop `eslint-plugin-` or custom like `@typescript-eslint`);
// the `plugin` is the required package module. createLinter accepts both
// name strings AND {prefix, plugin} objects; we use the latter to get the
// short `unicorn/foo` style rule IDs instead of `eslint-plugin-unicorn/foo`.
function loadPluginDescriptors() {
  const entries = [
    { prefix: "@typescript-eslint", pkg: "@typescript-eslint/eslint-plugin" },
    { prefix: "unicorn",            pkg: "eslint-plugin-unicorn"            },
    { prefix: "react",              pkg: "eslint-plugin-react"              },
    { prefix: "react-hooks",        pkg: "eslint-plugin-react-hooks"        },
    { prefix: "jsdoc",              pkg: "eslint-plugin-jsdoc"              },
    { prefix: "promise",            pkg: "eslint-plugin-promise"            },
    { prefix: "sonarjs",            pkg: "eslint-plugin-sonarjs"            },
    { prefix: "import",             pkg: "eslint-plugin-import"             },
    { prefix: "n",                  pkg: "eslint-plugin-n"                  },
    { prefix: "es-x",               pkg: "eslint-plugin-es-x"               },
  ];
  const out = [];
  for (const { prefix, pkg } of entries) {
    try {
      const mod = require(require.resolve(pkg, {
        paths: [path.resolve(__dirname, "../js"), process.cwd()],
      }));
      const plugin = mod?.default || mod;
      if (plugin && plugin.rules) out.push({ prefix, plugin });
    } catch { /* not installed */ }
  }
  return out;
}
const pluginDescs = loadPluginDescriptors();

const coreRules = loadCoreRules({});
const allRulesConfig = {};
for (const d of coreRules) if (d.meta?.name) allRulesConfig[d.meta.name] = "error";
let pluginRuleCount = 0;
for (const { prefix, plugin } of pluginDescs) {
  for (const ruleName of Object.keys(plugin.rules)) {
    const rule = plugin.rules[ruleName];
    const create = rule?.create || rule;
    if (typeof create !== "function") continue;
    // Skip deprecated rules — mirrors loadCoreRules behavior.
    if (rule?.meta?.deprecated) continue;
    allRulesConfig[`${prefix}/${ruleName}`] = "error";
    pluginRuleCount++;
  }
}

// Linter selection:
//  - all-rules mode: one linter with every core rule enabled, shared across files
//  - per-rule mode:  one linter per unique ruleId, with only that rule enabled
const linterCache = new Map();
async function linterFor(ruleId) {
  if (!perRule) {
    let L = linterCache.get("__all__");
    if (!L) {
      L = await createLinter({ rules: allRulesConfig, plugins: pluginDescs });
      linterCache.set("__all__", L);
    }
    return L;
  }
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
  // Periodic GC nudges JSC so heap peak stays bounded when short-lived
  // objects (parsed ASTs, diagnostic arrays) are created in a tight loop.
  const gcFn = typeof Bun !== "undefined" && typeof Bun.gc === "function"
    ? () => Bun.gc(true)
    : (typeof global.gc === "function" ? global.gc : null);
  const t0 = performance.now();
  for (let i = 0; i < tasks.length; i++) {
    const t = tasks[i];
    const L = await linterFor(t.ruleId);
    const code = fs.readFileSync(t.file, "utf8");
    const s = performance.now();
    try {
      const diags = await L(code, t.file);
      diagTotal += diags.length;
    } catch (e) {
      errorCount++;
    }
    times[i] = performance.now() - s;
    if (gcFn && (i & 4095) === 4095) gcFn();
  }
  const wall = performance.now() - t0;
  return { times, diagTotal, errorCount, wall };
}

function percentile(sorted, p) {
  const i = Math.min(sorted.length - 1, Math.floor(sorted.length * p));
  return sorted[i];
}

(async () => {
  console.log(`Corpus: ${root}`);
  console.log(`Mode:   ${perRule ? "per-rule (synthetic)" : "all-rules (production shape)"}`);
  console.log(`Tasks:  ${tasks.length}  (${(totalBytes / 1024 / 1024).toFixed(2)} MB)`);
  if (perRule) console.log(`Unique rules: ${new Set(tasks.map(t => t.ruleId)).size}`);
  else         console.log(`Rules enabled: ${Object.keys(allRulesConfig).length} total ` +
                            `(${coreRules.length} core + ${pluginRuleCount} plugin from ${pluginDescs.length} plugins)`);
  if (kindArg) console.log(`Kind filter:   ${kindArg}`);
  if (prefArg) console.log(`Prefix filter: ${prefArg}`);
  console.log();

  const warmN = Math.min(warmup, tasks.length);
  console.log(`Warmup (${warmN})...`);
  await run(tasks.slice(0, warmN));

  console.log(`Bench...`);
  const { times, diagTotal, errorCount, wall } = await run(tasks);

  const sorted = Float64Array.from(times).sort();
  const sum = times.reduce((a, b) => a + b, 0);
  const mean = sum / times.length;

  console.log();
  console.log(`=== results ===`);
  console.log(`  wall:        ${(wall / 1000).toFixed(2)} s`);
  console.log(`  files:       ${tasks.length}`);
  console.log(`  errors:      ${errorCount}`);
  console.log(`  diags:       ${diagTotal}  (mean ${(diagTotal / tasks.length).toFixed(1)} per file)`);
  console.log(`  files/s:     ${(tasks.length / (wall / 1000)).toFixed(1)}`);
  console.log(`  MB/s:        ${(totalBytes / 1024 / 1024 / (wall / 1000)).toFixed(2)}`);
  console.log(`  mean/file:   ${mean.toFixed(3)} ms`);
  console.log(`  p50/file:    ${percentile(sorted, 0.50).toFixed(3)} ms`);
  console.log(`  p90/file:    ${percentile(sorted, 0.90).toFixed(3)} ms`);
  console.log(`  p99/file:    ${percentile(sorted, 0.99).toFixed(3)} ms`);
  console.log(`  max/file:    ${sorted[sorted.length - 1].toFixed(3)} ms`);
})().catch(e => { console.error(e); process.exit(1); });
