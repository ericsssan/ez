"use strict";
/**
 * Tight-loop profile harness for the JS rule dispatch path.
 *
 * Pre-parses ONE big file (binder.ts), then loops `runPlugins` against the
 * cached AST. This isolates pure JS dispatch (visitor build + traversal +
 * rule callbacks) from parsing and native lint output buffer size issues.
 *
 * Usage:
 *   bun --cpu-prof --cpu-prof-dir=/tmp bench/profile_lint_dispatch.js
 *   ls -1t /tmp/CPU.*.cpuprofile | head -1   # newest profile
 *
 * Or for quick steady-state numbers (no profiler):
 *   bun bench/profile_lint_dispatch.js --iters 20
 */

if (typeof Bun === "undefined") { console.error("requires bun"); process.exit(1); }

const fs   = require("fs");
const path = require("path");
const ROOT = path.resolve(__dirname, "..");

const args = process.argv.slice(2);
const _arg = (n, d) => { const i = args.indexOf(n); return i >= 0 ? args[i+1] : d; };

const iters     = parseInt(_arg("--iters", "10"), 10);
const fileArg   = _arg("--file", path.join(ROOT, "tests/conformance/typescript/src/compiler/binder.ts"));
const profile   = _arg("--profile", "all"); // "all" | "core"
const useNative = !args.includes("--no-native"); // keep native rules in config (default)

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
const FIXTURES = path.join(ROOT, "tests/fixtures/extracted/corpus");

(async () => {
  // Move into TS project root so plugins that read ./package.json work.
  const tsRoot = path.join(ROOT, "tests/conformance/typescript");
  if (fs.existsSync(path.join(tsRoot, "package.json"))) process.chdir(tsRoot);

  // Load plugins
  const paths = [path.join(ROOT, "js"), process.cwd()];
  const plugins = profile === "core" ? [] : PLUGIN_ENTRIES.flatMap(e => {
    try {
      const mod = require(require.resolve(e.pkg, { paths }));
      const plugin = mod?.default || mod;
      return plugin?.rules ? [{ ...e, plugin }] : [];
    } catch { return []; }
  });

  // Build rule descriptors (jsPlugins shape that runPlugins wants)
  const { loadCoreRules } = require(path.join(ROOT, "js/load-plugin.js"));
  const { getNativeRules } = require(path.join(ROOT, "js/index.js"));
  const nativeRuleSet = new Set([...getNativeRules().keys()]);

  const coreFx = path.join(FIXTURES, "eslint");
  const coreSet = fs.existsSync(coreFx) ? new Set(fs.readdirSync(coreFx)) : null;

  const jsPlugins = [];
  let coreCount = 0, pluginCount = 0, nativeSkipped = 0;

  for (const d of loadCoreRules({})) {
    const n = d.meta?.name; if (!n) continue;
    if (coreSet && !coreSet.has(n)) continue;
    if (!useNative && nativeRuleSet.has(n)) { nativeSkipped++; continue; }
    jsPlugins.push(d);
    coreCount++;
  }
  for (const { prefix, plugin, fixturesDir } of plugins) {
    const fxDir = path.join(FIXTURES, fixturesDir);
    const fxSet = fs.existsSync(fxDir) ? new Set(fs.readdirSync(fxDir)) : null;
    for (const [r, rule] of Object.entries(plugin.rules)) {
      const create = rule?.create || rule;
      if (typeof create !== "function") continue;
      if (rule?.meta?.deprecated) continue;
      if (fxSet && !fxSet.has(r)) continue;
      const fullName = `${prefix}/${r}`;
      if (!useNative && nativeRuleSet.has(fullName)) { nativeSkipped++; continue; }
      jsPlugins.push({
        meta: { name: fullName, defaultOptions: rule.meta?.defaultOptions, schema: rule.meta?.schema, messages: rule.meta?.messages },
        create,
      });
      pluginCount++;
    }
  }

  // ruleConfig: rule-name → options array (empty for default)
  const ruleConfig = {};
  for (const p of jsPlugins) ruleConfig[p.meta.name] = [];

  // Pre-parse the file ONCE
  const { parseSource, getTagNames } = require(path.join(ROOT, "js/index.js"));
  const { runPlugins } = require(path.join(ROOT, "js/eslint-runner.js"));
  const tagNames = getTagNames();

  const src = fs.readFileSync(fileArg, "utf8");
  console.log(`File: ${path.basename(fileArg)} (${(src.length/1024).toFixed(0)} KB, ${src.split("\n").length} lines)`);
  const _pt0 = performance.now();
  const ast = parseSource(src, { filename: fileArg });
  console.log(`Parsed in ${(performance.now() - _pt0).toFixed(1)}ms, ${ast.nodeCount} nodes, ${ast.tokenCount} tokens`);
  console.log(`Rules: ${coreCount} core + ${pluginCount} plugin = ${jsPlugins.length} total` +
              (useNative ? "" : ` (${nativeSkipped} native skipped)`));

  // Warmup
  const _wt0 = performance.now();
  const wReports = runPlugins(ast, jsPlugins, { tagNames, filename: fileArg, ruleConfig });
  console.log(`Warmup runPlugins: ${(performance.now() - _wt0).toFixed(0)}ms (${wReports.length} reports)`);

  // Hot loop
  console.log(`\nHot loop: ${iters} iterations`);
  const times = [];
  for (let i = 0; i < iters; i++) {
    const t0 = performance.now();
    const reports = runPlugins(ast, jsPlugins, { tagNames, filename: fileArg, ruleConfig });
    const dt = performance.now() - t0;
    times.push(dt);
  }
  times.sort((a, b) => a - b);
  const min = times[0], max = times[times.length - 1];
  const p50 = times[Math.floor(times.length / 2)];
  const avg = times.reduce((a, b) => a + b, 0) / times.length;

  console.log(`  min ${min.toFixed(0)}ms  p50 ${p50.toFixed(0)}ms  avg ${avg.toFixed(0)}ms  max ${max.toFixed(0)}ms`);
  console.log(`  per-rule per-file avg: ${(avg * 1000 / jsPlugins.length).toFixed(1)}µs`);
  if (process.env.EZ_PROFILE_DISPATCH && globalThis.__ez_dispatch_stats__) {
    const s = globalThis.__ez_dispatch_stats__;
    const total = s.fast_hit + s.esq_call;
    console.log(`\nDispatch stats (across ${iters + 1} runs incl warmup):`);
    console.log(`  fast-path hits:   ${s.fast_hit.toLocaleString().padStart(12)}  (${(s.fast_hit / total * 100).toFixed(1)}%)`);
    console.log(`  esquery calls:    ${s.esq_call.toLocaleString().padStart(12)}  (${(s.esq_call / total * 100).toFixed(1)}%)`);
    console.log(`    no fast matcher:${s.esq_no_fm.toLocaleString().padStart(12)}`);
    console.log(`    partial fm only:${s.esq_partial.toLocaleString().padStart(12)}`);
    if (s.by_sel) {
      const top = [...s.by_sel.entries()].sort((a, b) => b[1] - a[1]).slice(0, 25);
      console.log(`\nTop 25 selectors hitting esquery (no fast matcher):`);
      for (const [sel, n] of top) {
        console.log(`  ${n.toString().padStart(8)}  ${sel}`);
      }
    }
  }
  console.log(`\nTotal samples: ${(iters * avg / 1000).toFixed(1)}s of dispatch work for the profiler.`);
})().catch(e => { console.error(e); process.exit(1); });
