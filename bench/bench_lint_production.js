"use strict";
/**
 * Production lint benchmark — mirrors what users run in CI / `ez lint src/**`.
 *
 *   one consolidated config (every rule from every plugin, default options)
 *   × a real-world codebase (TypeScript compiler source, ~700 files / 21 MB)
 *
 * Measures end-to-end wall time through the public `lint(targets, config)`
 * API in js/api.js (currently single-threaded). Captures the baseline we
 * need to beat with a worker pool.
 *
 * Usage:
 *   bun bench/bench_lint_production.js                 # full corpus, all plugins
 *   bun bench/bench_lint_production.js --limit 100     # first 100 files (quick)
 *   bun bench/bench_lint_production.js --core-only     # eslint core rules only
 *   bun bench/bench_lint_production.js --corpus DIR    # lint files under DIR
 *   bun bench/bench_lint_production.js --warmup 5      # warmup file count (default 3)
 *
 * Reports: total wall, files/s, MB/s, diagnostics count, RSS, per-phase breakdown.
 */

if (typeof Bun === "undefined") {
  process.stderr.write("error: requires Bun. Use: bun bench/bench_lint_production.js\n");
  process.exit(1);
}

const fs   = require("fs");
const path = require("path");

const ROOT     = path.resolve(__dirname, "..");
const FIXTURES = path.join(ROOT, "tests/fixtures/extracted/corpus");

// ── CLI ──────────────────────────────────────────────────────────
const args = process.argv.slice(2);
const _arg = (name, def = null) => {
  const i = args.indexOf(name);
  return i >= 0 && i + 1 < args.length ? args[i + 1] : def;
};
const _flag = (name) => args.includes(name);

const limit       = parseInt(_arg("--limit", "0"), 10);
const warmup      = parseInt(_arg("--warmup", "3"), 10);
const coreOnly    = _flag("--core-only");
const corpusArg   = _arg("--corpus");
const showDiag    = _flag("--show-diag");
const printConfig = _flag("--print-config");
const noTsServices = _flag("--no-ts-services");
// Comma-separated plugin prefixes to exclude (e.g. "jsdoc,sonarjs")
const excludePlugins = new Set((_arg("--exclude-plugins", "") || "").split(",").filter(Boolean));
// Comma-separated rule names to exclude (e.g. "jsdoc/imports-as-dependencies")
const excludeRules = new Set((_arg("--exclude-rules", "") || "").split(",").filter(Boolean));
const perFile = _flag("--per-file"); // print per-file timing for slow-file detection

// ── Plugin discovery ─────────────────────────────────────────────
//
// Every plugin we ship a fixture corpus for is enabled. Loaded via
// require.resolve from js/node_modules + the tests/conformance submodules.
// Prefix names match what _cases.json uses (so a `unicorn/` rule resolves
// from the eslint-plugin-unicorn package).

const PLUGIN_ENTRIES = [
  { prefix: "@typescript-eslint", pkg: "@typescript-eslint/eslint-plugin", fixturesDir: "_typescript-eslint" },
  { prefix: "unicorn",            pkg: "eslint-plugin-unicorn",            fixturesDir: "unicorn"            },
  { prefix: "react",              pkg: "eslint-plugin-react",              fixturesDir: "react"              },
  { prefix: "react-hooks",        pkg: "eslint-plugin-react-hooks",        fixturesDir: "react-hooks"        },
  { prefix: "jsdoc",              pkg: "eslint-plugin-jsdoc",              fixturesDir: "jsdoc"              },
  { prefix: "promise",            pkg: "eslint-plugin-promise",            fixturesDir: "promise"            },
  { prefix: "sonarjs",            pkg: "eslint-plugin-sonarjs",            fixturesDir: "sonarjs"            },
  { prefix: "import",             pkg: "eslint-plugin-import",             fixturesDir: "import"             },
  { prefix: "n",                  pkg: "eslint-plugin-n",                  fixturesDir: "n"                  },
  { prefix: "es-x",               pkg: "eslint-plugin-es-x",               fixturesDir: "es-x"               },
];

function loadPlugins() {
  const out = [];
  const pluginResolvePaths = [
    path.join(ROOT, "js"),
    path.join(ROOT, "tests/conformance/eslint-plugin-typescript-eslint/typescript-eslint-src/packages/eslint-plugin"),
    path.join(ROOT, "tests/conformance/eslint-plugin-react-hooks/packages/eslint-plugin-react-hooks"),
    process.cwd(),
  ];
  for (const entry of PLUGIN_ENTRIES) {
    if (excludePlugins.has(entry.prefix)) continue;
    const t0 = performance.now();
    let plugin = null;
    try {
      const resolved = require.resolve(entry.pkg, { paths: pluginResolvePaths });
      const mod = require(resolved);
      plugin = mod?.default || mod;
    } catch (e) {
      process.stderr.write(`  skip ${entry.prefix.padEnd(20)} (could not resolve ${entry.pkg})\n`);
      continue;
    }
    if (!plugin?.rules) {
      process.stderr.write(`  skip ${entry.prefix.padEnd(20)} (no rules in package)\n`);
      continue;
    }
    const dt = performance.now() - t0;
    out.push({ ...entry, plugin, loadMs: dt });
  }
  return out;
}

// ── Build consolidated config ────────────────────────────────────
//
// Every rule from every available plugin enabled at "error" with no options
// → each rule uses its own internal defaults (mostly default settings, per
// the spec). Deprecated rules and rules with `meta.type === "layout"` that
// aren't useful in CI are kept on too — production users can always disable
// them, but for benchmarking we want maximum fan-out.
//
// Rule names cross-checked against the fixture corpus so the config matches
// what we already test conformance against.

function buildConfig(loadedPlugins) {
  const rules = {};
  let coreCount = 0;
  let pluginCount = 0;
  const skipped = { deprecated: 0, missingCreate: 0 };

  // Core rules — read fixture-corpus list to pin down which core rules exist.
  const coreFixturesDir = path.join(FIXTURES, "eslint");
  const coreFixtureRules = new Set(
    fs.existsSync(coreFixturesDir) ? fs.readdirSync(coreFixturesDir) : []
  );
  const { loadCoreRules } = require(path.join(ROOT, "js/load-plugin.js"));
  for (const desc of loadCoreRules({})) {
    const name = desc.meta?.name;
    if (!name) continue;
    if (coreFixtureRules.size > 0 && !coreFixtureRules.has(name)) continue; // limit to fixture coverage
    rules[name] = "error";
    coreCount++;
  }

  if (coreOnly) return { rules, plugins: [], coreCount, pluginCount: 0, skipped };

  // Plugin rules — only enable rules that have a fixture (so config matches corpus).
  for (const { prefix, plugin, fixturesDir } of loadedPlugins) {
    const fxDir = path.join(FIXTURES, fixturesDir);
    const fixtureRuleSet = fs.existsSync(fxDir) ? new Set(fs.readdirSync(fxDir)) : null;
    for (const [ruleLocal, rule] of Object.entries(plugin.rules)) {
      const create = rule?.create || rule;
      if (typeof create !== "function") { skipped.missingCreate++; continue; }
      if (rule?.meta?.deprecated) { skipped.deprecated++; continue; }
      if (fixtureRuleSet && !fixtureRuleSet.has(ruleLocal)) continue; // only what we test
      const fullName = `${prefix}/${ruleLocal}`;
      if (excludeRules.has(fullName)) continue;
      rules[fullName] = "error";
      pluginCount++;
    }
  }

  const pluginsForConfig = loadedPlugins.map(({ prefix, plugin }) => ({ prefix, plugin }));
  return { rules, plugins: pluginsForConfig, coreCount, pluginCount, skipped };
}

// ── Corpus discovery ─────────────────────────────────────────────
//
// Default corpus: TypeScript compiler source (real-world TS, ~700 files,
// ~21 MB total — varied AST shapes, deep type usage, mix of file sizes).
// Override with --corpus DIR to point at any tree.

function discoverCorpus() {
  const root = corpusArg
    ? path.resolve(process.cwd(), corpusArg)
    : path.join(ROOT, "tests/conformance/typescript/src");
  if (!fs.existsSync(root)) {
    throw new Error(`corpus not found: ${root}\n  Pass --corpus DIR to point at a tree of .ts/.js files.`);
  }
  const files = [];
  const walk = (dir) => {
    for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
      if (ent.name.startsWith(".") || ent.name === "node_modules") continue;
      const p = path.join(dir, ent.name);
      if (ent.isDirectory()) walk(p);
      else if (/\.(m?[jt]sx?)$/.test(ent.name)) files.push(p);
    }
  };
  walk(root);
  files.sort();
  return { root, files };
}

// ── ts-services init (so type-aware @typescript-eslint rules don't crash) ──
function initTsServices(corpusRoot) {
  // Synthesize a minimal tsconfig at corpus root so the LanguageService finds something.
  const tsConfigPath = path.join(corpusRoot, "tsconfig.bench.json");
  fs.writeFileSync(tsConfigPath, JSON.stringify({
    compilerOptions: {
      target: "esnext", module: "esnext", moduleResolution: "bundler",
      lib: ["esnext", "dom"], allowJs: true, skipLibCheck: true,
      strict: false, noEmit: true, esModuleInterop: true,
      experimentalDecorators: true, emitDecoratorMetadata: true,
      noResolve: true,
    },
    files: [],
  }, null, 2));
  try {
    const svc = require(path.join(ROOT, "js/ts-services"));
    svc.init(corpusRoot);
    return svc;
  } catch {
    return null;
  }
}

// ── Run ──────────────────────────────────────────────────────────
(async () => {
  const _t0_total = performance.now();

  console.log(`ez production lint benchmark`);
  console.log(`  Bun ${Bun.version}`);

  const _t0_plugins = performance.now();
  const loadedPlugins = coreOnly ? [] : loadPlugins();
  const _dt_plugins = performance.now() - _t0_plugins;

  const cfg = buildConfig(loadedPlugins);
  if (printConfig) {
    console.log(`\nConfig (${Object.keys(cfg.rules).length} rules):`);
    for (const r of Object.keys(cfg.rules).sort()) console.log(`  ${r}`);
    process.exit(0);
  }
  console.log(`  plugins:   ${loadedPlugins.length} loaded in ${_dt_plugins.toFixed(0)}ms` +
              `  (${loadedPlugins.map(p => p.prefix).join(", ") || "core only"})`);
  console.log(`  rules:     ${cfg.coreCount} core + ${cfg.pluginCount} plugin = ${Object.keys(cfg.rules).length} total` +
              `  (skipped: ${cfg.skipped.deprecated} deprecated, ${cfg.skipped.missingCreate} no-create)`);

  const _t0_disc = performance.now();
  const { root, files } = discoverCorpus();
  const _dt_disc = performance.now() - _t0_disc;
  const allFiles = limit > 0 ? files.slice(0, limit) : files;
  const totalBytes = allFiles.reduce((s, f) => s + (fs.statSync(f).size || 0), 0);
  console.log(`  corpus:    ${allFiles.length} files (${(totalBytes / 1024 / 1024).toFixed(1)} MB)` +
              `  rooted at ${path.relative(ROOT, root)}` +
              `  discovered in ${_dt_disc.toFixed(0)}ms`);

  // Chdir to nearest ancestor that has package.json — production users always run
  // from a project root, and rules like jsdoc/imports-as-dependencies read
  // ./package.json from cwd. Without this, those rules console.log per file.
  let cwdRoot = root;
  while (cwdRoot !== path.dirname(cwdRoot) && !fs.existsSync(path.join(cwdRoot, "package.json"))) {
    cwdRoot = path.dirname(cwdRoot);
  }
  if (fs.existsSync(path.join(cwdRoot, "package.json"))) {
    process.chdir(cwdRoot);
    console.log(`  cwd:       ${path.relative(ROOT, cwdRoot) || "."} (has package.json)`);
  }

  // ts-services so @typescript-eslint type-aware rules have a LanguageService.
  if (!noTsServices) {
    const svc = initTsServices(root);
    if (svc) {
      const tsFiles = allFiles.filter(p => /\.[mc]?tsx?$/.test(p));
      if (tsFiles.length > 0) try { svc.registerFiles(tsFiles); } catch { /* best-effort */ }
    }
  }

  const { lint } = require(path.join(ROOT, "js/api.js"));

  // Reuse a single config object so api.js's resolved-config cache hits.
  const lintConfig = { rules: cfg.rules, plugins: cfg.plugins };

  // Warmup — first lint() resolves config, builds visitor cache, JIT specializes.
  if (warmup > 0 && allFiles.length >= warmup) {
    const _wt0 = performance.now();
    await lint(allFiles.slice(0, warmup), lintConfig);
    if (global.gc) global.gc();
    console.log(`  warmup:    ${warmup} files in ${(performance.now() - _wt0).toFixed(0)}ms`);
  }

  // Steady-state measurement
  const _ssRssBefore = process.memoryUsage().rss;
  const _ss0 = performance.now();
  let results;
  if (perFile) {
    // Lint files one at a time so we can spot pathologically slow files.
    results = [];
    const { createFileLinter } = require(path.join(ROOT, "js/api.js"));
    const lintOne = await createFileLinter(lintConfig);
    const fileTimes = [];
    for (const f of allFiles) {
      const _ft0 = performance.now();
      let diags;
      try { diags = lintOne(f); } catch (e) { diags = [{ ruleId: null, message: e.message, severity: 2, line: 0, column: 0 }]; }
      const _ftd = performance.now() - _ft0;
      fileTimes.push({ file: f, ms: _ftd, diags: diags.length });
      if (diags.length > 0) results.push({ file: f, diagnostics: diags });
    }
    fileTimes.sort((a, b) => b.ms - a.ms);
    console.log(`\nSlowest 10 files:`);
    for (const ft of fileTimes.slice(0, 10)) {
      console.log(`  ${ft.ms.toFixed(0).padStart(6)}ms  ${ft.diags.toString().padStart(5)} diags  ${path.relative(process.cwd(), ft.file)}`);
    }
  } else {
    results = await lint(allFiles, lintConfig);
  }
  const _dt_ss = performance.now() - _ss0;
  const _ssRssAfter = process.memoryUsage().rss;

  // ── Aggregate ──
  let totalDiags = 0;
  const filesWithDiags = results.length;
  for (const r of results) totalDiags += r.diagnostics.length;

  const filesPerSec = allFiles.length / (_dt_ss / 1000);
  const mbPerSec    = (totalBytes / 1024 / 1024) / (_dt_ss / 1000);

  console.log(`\nLint (steady state):`);
  console.log(`  total:       ${(_dt_ss / 1000).toFixed(2)}s`);
  console.log(`  throughput:  ${filesPerSec.toFixed(1)} files/s   ${mbPerSec.toFixed(2)} MB/s`);
  console.log(`  diagnostics: ${totalDiags} across ${filesWithDiags} files (${(totalDiags / allFiles.length).toFixed(1)}/file avg)`);
  console.log(`  RSS:         before ${(_ssRssBefore/1024/1024).toFixed(0)} MB → after ${(_ssRssAfter/1024/1024).toFixed(0)} MB`);
  console.log(`\nTotal time (incl. plugin load + discovery + warmup): ${((performance.now() - _t0_total)/1000).toFixed(2)}s`);

  if (showDiag) {
    const sample = results.slice(0, 3);
    console.log(`\nSample diagnostics (first 3 files):`);
    for (const r of sample) {
      console.log(`  ${path.relative(ROOT, r.file)} — ${r.diagnostics.length} diags`);
      for (const d of r.diagnostics.slice(0, 3)) {
        console.log(`    ${d.line}:${d.column} [${d.ruleId}] ${d.message?.slice(0, 80) || ""}`);
      }
    }
  }
})().catch(e => { console.error(e); process.exit(1); });
