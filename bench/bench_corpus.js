// bench/bench_corpus.js
//
// Walk extracted fixture corpus, lint every file with ALL rules enabled —
// the same shape as a real editor save or CI lint pass. One linter instance,
// all bundled core + installed plugin rules, re-used across every file.
//
// Corpus layout (produced by `bun tests/differential/run.js --extract-fixtures <dir>`):
//   <dir>/corpus/<safePrefix>/<safeRule>/{valid,invalid}/N.{js,ts,jsx,tsx}
//
// All file I/O — directory walking and per-file read — happens in Zig.
// JS never calls fs.readFile/readdir for the corpus; the bench hands the
// corpus root path to ez.discoverFiles() and paths to createFileLinter,
// which uses the fused parseAndLintFile NAPI call (open + read + parse +
// native lint in one Zig trip).
//
// Modes:
//   (default)      all rules on every file (production shape)
//   --per-rule     one-rule-per-file (synthetic — for A/B rule-impl timing)
//
// Filters:
//   --kind {valid|invalid}   (only honoured in per-rule mode)
//   --prefix <safePrefix>    (only honoured in per-rule mode)
//   --limit N                truncate task list
//   --warmup N               (default 50)
//
// Usage:
//   bun bench/bench_corpus.js                                  # all-rules default
//   bun bench/bench_corpus.js --per-rule                       # synthetic per-rule mode
//   bun bench/bench_corpus.js --per-rule --prefix eslint --kind invalid
//   bun bench/bench_corpus.js --limit 5000

const path = require("path");
const { createFileLinter, createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");
const ezIndex = require("../js/index.js");

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

// ── Corpus discovery (Zig-side) ─────────────────────────────
// ez.discoverFiles returns { paths, sizes } walked recursively from the root.
// No JS file I/O. Paths come in whatever order the native walker emits.
//
// We sort the paths deterministically here — unsorted `readdir` order on the
// full 56k corpus triggers a Bun/JSC heap pathology that balloons RSS past
// 48 GB. Sorting sidesteps it.
const discovered = ezIndex.discoverFiles(corpusRoot);
const sortedIdx = Array.from(discovered.paths.keys()).sort(
  (a, b) => discovered.paths[a].localeCompare(discovered.paths[b]),
);

// Parse rule/kind metadata out of the path so per-rule mode can route
// and optional filters can apply. In all-rules mode metadata is unused.
function unmapPrefix(safePrefix) {
  if (safePrefix === "eslint") return null;
  if (safePrefix === "_typescript-eslint") return "@typescript-eslint";
  return safePrefix;
}
function taskFromPath(full) {
  // <corpusRoot>/<safePrefix>/<safeRule>/<kind>/<N.ext>
  const rel = full.startsWith(corpusRoot + path.sep) ? full.slice(corpusRoot.length + 1) : full;
  const segs = rel.split(path.sep);
  const [safePrefix, safeRule, kind] = segs;
  const pluginPrefix = unmapPrefix(safePrefix);
  const ruleId = pluginPrefix ? `${pluginPrefix}/${safeRule}` : safeRule;
  return { file: full, ruleId, kind, safePrefix };
}

let tasks = [];
let totalBytes = 0;
for (const i of sortedIdx) {
  const full = discovered.paths[i];
  const size = discovered.sizes[i];
  const meta = taskFromPath(full);
  if (prefArg && meta.safePrefix !== prefArg) continue;
  if (kindArg && meta.kind !== kindArg) continue;
  meta.bytes = size;
  totalBytes += size;
  tasks.push(meta);
}
if (limit > 0 && tasks.length > limit) { tasks.length = limit; totalBytes = tasks.reduce((s, t) => s + t.bytes, 0); }
if (tasks.length === 0) {
  console.error(`no fixtures matched under ${corpusRoot}`);
  console.error(`generate with: bun tests/differential/run.js --extract-fixtures ${root}`);
  process.exit(1);
}

// ── Plugin descriptors ──────────────────────────────────────
// Load every installed plugin package from js/node_modules. `prefix` is the
// short ESLint name the fixtures reference (unicorn, @typescript-eslint, …);
// the plugin module is required live so we can pass {prefix, plugin} through
// createFileLinter/createLinter instead of a package-name string. That keeps
// rule IDs short (`unicorn/foo`, not `eslint-plugin-unicorn/foo`).
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
    if (rule?.meta?.deprecated) continue;
    allRulesConfig[`${prefix}/${ruleName}`] = "error";
    pluginRuleCount++;
  }
}

// Linter selection:
//  - all-rules mode: createFileLinter → lintFile(path) → fused parseAndLintFile
//    NAPI call (open + read + parse + native lint in Zig). No JS fs.
//  - per-rule mode:  createLinter → lintText(source, filename). Per-rule mode
//    exists for A/B timing of individual rule implementations, and the current
//    multi-rule NAPI config serialisation does not yet support single-rule
//    slicing efficiently; paying the JS readFile cost here is acceptable since
//    the mode is diagnostic.
const fsForPerRule = perRule ? require("fs") : null;
const linterCache = new Map();
async function linterFor(ruleId) {
  if (!perRule) {
    let L = linterCache.get("__all__");
    if (!L) {
      L = await createFileLinter({ rules: allRulesConfig, plugins: pluginDescs });
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
  const gcFn = typeof Bun !== "undefined" && typeof Bun.gc === "function"
    ? () => Bun.gc(true)
    : (typeof global.gc === "function" ? global.gc : null);
  const t0 = performance.now();
  for (let i = 0; i < tasks.length; i++) {
    const t = tasks[i];
    const L = await linterFor(t.ruleId);
    const s = performance.now();
    try {
      if (perRule) {
        const code = fsForPerRule.readFileSync(t.file, "utf8");
        const diags = await L(code, t.file);
        diagTotal += diags.length;
      } else {
        const diags = L(t.file);
        diagTotal += diags.length;
      }
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
