// Bench all oxlint rules ez can run, JS path only (no native).
// Usage:
//   bun bench/bench_oxlint_matched.js [--file typescript.js] [--iters 3]
//
// Loads ESLint core (with deprecated) + plugins (typescript-eslint, unicorn,
// react, react-hooks, import, n, promise, jsdoc) and filters to the rules
// oxlint also has. Forces the JS runner path even when a native impl exists,
// so the ratio reflects pure ez-runner performance.

const fs   = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
// Plugin sub-requires resolve relative to cwd in some packages
// (e.g. @typescript-eslint/eslint-plugin resolves @typescript-eslint/parser).
// chdir into js/ so node_modules sits one dir up when those resolves fire.
process.chdir(path.join(ROOT, "js"));

const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
const { loadCoreRules, loadPlugin } = require(path.join(ROOT, "js/load-plugin.js"));
const { Linter } = require(path.join(ROOT, "js/node_modules/eslint"));

const OXLINT_BIN = (() => { try { return Bun.which("oxlint") || "/opt/homebrew/bin/oxlint"; } catch { return "oxlint"; } })();

function _arg(name, def) {
  const i = process.argv.indexOf(name);
  return i > 0 && i + 1 < process.argv.length ? process.argv[i + 1] : def;
}

const FIXTURE = _arg("--file", "typescript.js");
const ITERS   = parseInt(_arg("--iters", "3"), 10);
const WARMUP  = parseInt(_arg("--warmup", "1"), 10);

const fixturePath = path.isAbsolute(FIXTURE) ? FIXTURE
  : path.join(ROOT, "bench/fixtures", FIXTURE);
if (!fs.existsSync(fixturePath)) {
  console.error("missing fixture:", fixturePath);
  process.exit(1);
}

// ── Load oxlint's rule list ────────────────────────────────────────────
function loadOxlintRules() {
  const out = Buffer.from(Bun.spawnSync([OXLINT_BIN, "--rules"], { stdout: "pipe" }).stdout).toString();
  // Each table row: `| <rule_name> | <source> | ... |`
  const bySrc = new Map();
  for (const line of out.split("\n")) {
    const cols = line.split("|").map(s => s.trim());
    if (cols.length < 4 || !cols[1] || cols[1] === "Rule name" || /^-+$/.test(cols[1])) continue;
    const name = cols[1], src = cols[2];
    if (!name || !src) continue;
    if (!bySrc.has(src)) bySrc.set(src, new Set());
    bySrc.get(src).add(name);
  }
  return bySrc;
}

// ── Map ez plugin packages → oxlint source labels ──────────────────────
// [ez plugin pkg, oxlint source label, ESLint plugin alias]
const PLUGIN_TO_OX = [
  ["@typescript-eslint/eslint-plugin", "typescript", "@typescript-eslint"],
  ["eslint-plugin-import",             "import",     "import"],
  ["eslint-plugin-unicorn",            "unicorn",    "unicorn"],
  ["eslint-plugin-n",                  "node",       "n"],
  ["eslint-plugin-promise",            "promise",    "promise"],
  ["eslint-plugin-jsdoc",              "jsdoc",      "jsdoc"],
];

function loadOxlintMatched() {
  const oxBySrc = loadOxlintRules();
  const stats = { core: 0, byPlugin: new Map() };
  const descs = [];        // for ez runPlugins
  const oxNames = [];      // for oxlint -D flags (short rule names)
  const eslintRules = {};  // ESLint rule-id → severity
  const eslintPlugins = {}; // ESLint plugins map (for verify config)

  // Core
  const oxEslint = oxBySrc.get("eslint") || new Set();
  for (const r of loadCoreRules({ includeDeprecated: true })) {
    if (oxEslint.has(r.meta.name)) {
      descs.push(r);
      oxNames.push(r.meta.name);
      eslintRules[r.meta.name] = "error";
      stats.core++;
    }
  }

  const resolveOpts = { paths: [
    path.join(ROOT, "js"),
    path.join(ROOT, "js/node_modules"),
  ]};
  // Plugins
  for (const [pkg, oxSrc, alias] of PLUGIN_TO_OX) {
    let rules, mod;
    try { rules = loadPlugin(pkg); } catch (e) { console.error("loadPlugin failed:", pkg, e.message); continue; }
    try { mod = require(require.resolve(pkg, resolveOpts)); }
    catch (e) { console.error("require failed:", pkg, e.message); mod = null; }
    // ESM plugins (e.g. eslint-plugin-unicorn) export rules under .default
    if (mod && !mod.rules && mod.default?.rules) mod = mod.default;
    if (mod && mod.rules) eslintPlugins[alias] = mod;
    else console.error("no usable rules export for", pkg);
    const oxSet = oxBySrc.get(oxSrc) || new Set();
    let n = 0;
    for (const r of rules) {
      const shortName = r.meta.name.split("/").pop();
      if (oxSet.has(shortName)) {
        descs.push(r);
        oxNames.push(shortName);
        // Type-aware rules need a TS LanguageService; ESLint refuses to
        // run them without parserOptions.project. Skip them in the
        // ESLint config (still measured for ez/oxlint though).
        const ruleDef = mod?.rules?.[shortName];
        const typeAware = ruleDef?.meta?.docs?.requiresTypeChecking === true;
        if (!typeAware) eslintRules[`${alias}/${shortName}`] = "error";
        n++;
      }
    }
    if (n) stats.byPlugin.set(pkg + "→" + oxSrc, n);
  }

  return { descs, oxNames, eslintRules, eslintPlugins, stats };
}

// ── Bench helpers ──────────────────────────────────────────────────────
function runEzAll(src, filename, descs) {
  const ast = parseSource(src, { filename });
  const tagNames = getTagNames();
  const t0 = performance.now();
  const reports = runPlugins(ast, descs, { tagNames, filename, ruleConfig: {} });
  return { ms: performance.now() - t0, reports: reports.length };
}

function runOxlintAll(filePath, oxNames) {
  const args = [OXLINT_BIN, "-A", "all"];
  for (const n of oxNames) { args.push("-D"); args.push(n); }
  args.push("--silent", filePath);
  const t0 = performance.now();
  Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  return { ms: performance.now() - t0 };
}

function runOxlintBaseline(filePath) {
  const args = [OXLINT_BIN, "-A", "all", "--silent", filePath];
  const t0 = performance.now();
  Bun.spawnSync(args, { stdout: "pipe", stderr: "pipe" });
  return performance.now() - t0;
}

// Try to load @typescript-eslint/parser so TS-aware rules can read decorators / type annotations.
let _tsParser = null;
try {
  _tsParser = require(require.resolve("@typescript-eslint/parser", {
    paths: [path.join(ROOT, "js"), path.join(ROOT, "js/node_modules")],
  }));
} catch {}

function runEslintAll(src, filename, eslintRules, eslintPlugins) {
  const linter = new Linter();
  const cfg = {
    plugins: eslintPlugins,
    rules: eslintRules,
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      ...(_tsParser ? { parser: _tsParser } : {}),
    },
  };
  const t0 = performance.now();
  let msgs;
  try { msgs = linter.verify(src, cfg, { filename }); }
  catch (e) { console.error("ESLint error:", e.message); return { ms: 0, msgs: 0, error: e.message }; }
  return { ms: performance.now() - t0, msgs: msgs.length };
}

function median(arr) {
  if (!arr.length) return 0;
  const s = [...arr].sort((a, b) => a - b);
  return s[Math.floor(s.length / 2)];
}

// ── Probe ESLint rules: drop any that error at load time (typed-linting,
// missing parserServices, etc.) so the bench's verify call doesn't bail
// on the first failure.
function pruneEslintRules(eslintRules, eslintPlugins) {
  const linter = new Linter();
  const probeSrc = "var x = 1;\n";
  const baseCfg = (rules) => ({
    plugins: eslintPlugins,
    rules,
    languageOptions: { ecmaVersion: 2022, sourceType: "module" },
  });
  const kept = {};
  let dropped = 0;
  for (const [id, sev] of Object.entries(eslintRules)) {
    try {
      const msgs = linter.verify(probeSrc, baseCfg({ [id]: sev }), { filename: "probe.js" });
      // ESLint puts rule-load errors in msgs with severity 2 + ruleId null
      const fatal = msgs.find(m => m.fatal || (m.ruleId == null && /requires type information|Could not find|loading rule/i.test(m.message || "")));
      if (fatal) { dropped++; continue; }
      kept[id] = sev;
    } catch { dropped++; }
  }
  return { kept, dropped };
}

// ── Main ───────────────────────────────────────────────────────────────
const src = fs.readFileSync(fixturePath, "utf8");
const filename = path.basename(fixturePath);
const bytes = Buffer.byteLength(src, "utf8");

const { descs, oxNames, eslintRules: rawEslintRules, eslintPlugins, stats } = loadOxlintMatched();
const { kept: eslintRules, dropped: prunedEslint } = pruneEslintRules(rawEslintRules, eslintPlugins);

console.log(`oxlint-matched bench  —  ${filename}  (${(bytes / 1024 / 1024).toFixed(2)} MB)`);
console.log(`rules: ${descs.length} (core: ${stats.core}, plugins: ${descs.length - stats.core})`);
for (const [k, n] of stats.byPlugin) console.log(`  ${k}: ${n}`);
console.log(`ESLint config: ${Object.keys(eslintRules).length} rules (${prunedEslint} dropped: typed-linting / missing services)`);
console.log(`iters: ${ITERS}  warmup: ${WARMUP}  oxlint: ${OXLINT_BIN}`);
console.log("");

// Warmup
for (let i = 0; i < WARMUP; i++) runEzAll(src, filename, descs);
for (let i = 0; i < WARMUP; i++) runEslintAll(src, filename, eslintRules, eslintPlugins);
const oxBaseline = runOxlintBaseline(fixturePath); // single warmup

// Measure
const ezTimes = [];
const oxTimes = [];
const esTimes = [];
let ezReports = 0, esReports = 0;
for (let i = 0; i < ITERS; i++) {
  process.stderr.write(`\r  iter ${i + 1}/${ITERS}…    `);
  const ez = runEzAll(src, filename, descs);
  ezTimes.push(ez.ms); ezReports = ez.reports;
  oxTimes.push(runOxlintAll(fixturePath, oxNames).ms);
  const es = runEslintAll(src, filename, eslintRules, eslintPlugins);
  esTimes.push(es.ms); esReports = es.msgs;
}
process.stderr.write("\r\x1B[K");

const ezMs = median(ezTimes);
const oxMs = median(oxTimes);
const esMs = median(esTimes);
const oxNet = Math.max(0, oxMs - oxBaseline);

console.log("results (median):");
console.log(`  ez (JS-only, runPlugins all rules):  ${ezMs.toFixed(1)} ms  (${ezReports} reports)`);
console.log(`  ESLint reference (Linter.verify):    ${esMs.toFixed(1)} ms  (${esReports} reports)`);
console.log(`  oxlint baseline (no rules):          ${oxBaseline.toFixed(1)} ms`);
console.log(`  oxlint all matched rules:            ${oxMs.toFixed(1)} ms (rule cost: ${oxNet.toFixed(1)} ms)`);
console.log("");
console.log(`  ez / ESLint:           ${(ezMs / esMs).toFixed(2)}×`);
console.log(`  ez / oxlint (total):   ${(ezMs / oxMs).toFixed(2)}×`);
console.log(`  ESLint / oxlint:       ${(esMs / oxMs).toFixed(2)}×`);
console.log(`  ez / oxlint rule-only: ${oxNet > 0 ? (ezMs / oxNet).toFixed(2) : "n/a"}×`);
console.log("");
console.log(`  report-count delta (ez − ESLint): ${ezReports - esReports}  (ez has ${(ezReports / Math.max(1, esReports)).toFixed(0)}× as many)`);
