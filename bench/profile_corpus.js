// bench/profile_corpus.js
//
// Sample-friendly harness.  Holds a stable PID and lints the extracted
// fixture corpus via the public `lint(targets, config)` multi-file API.
// No JS-side timing — use `sample(1)` or `bun --cpu-prof` to capture an
// end-to-end JS → NAPI → Zig → NAPI → JS call graph.
//
// Usage:
//   bun bench/profile_corpus.js &
//   PID=$!
//   sleep 3                # let JIT warm up
//   sample $PID 20 -file /tmp/ez-sample.txt
//   kill $PID
//   less /tmp/ez-sample.txt
//
// With symbolicated JS frames:
//   bun --cpu-prof --cpu-prof-md --cpu-prof-dir=/tmp bench/profile_corpus.js
//   # writes /tmp/CPU.*.md and .cpuprofile
//
// Env:
//   EZ_PROFILE_LOOP=1      keep linting the corpus in a loop
//                          (single pass takes ~30s at 1240 rules)

const fs   = require("fs");
const path = require("path");
const _t = { start: performance.now() };
const _stamp = (k) => { _t[k] = performance.now(); };

// ── ts-services: init against the fixture root before api.js ──
// api.js's module-level init() uses process.cwd(), which has no tsconfig.
// Write a synthetic tsconfig at the fixture root covering corpus/** so
// type-aware @typescript-eslint rules get real parserServices instead
// of throwing on every call. The extracted/ directory is gitignored,
// so the file lives alongside the regenerable fixtures.
(() => {
  const tsInitRoot = path.resolve(process.argv[2] || "tests/fixtures/extracted");
  const tsConfigPath = path.join(tsInitRoot, "tsconfig.json");
  if (!fs.existsSync(tsConfigPath) && fs.existsSync(tsInitRoot)) {
    // `files: []` + no `include` keeps TS from compiling glob patterns into
    // filename regexes and matching every file against them.  ts-services'
    // LanguageService host adds files on demand via getScriptFileNames, so
    // we don't need include globs at all.  With globs present, the regex
    // match dominates the profile (80%+) on corpus-size file sets.
    fs.writeFileSync(tsConfigPath, JSON.stringify({
      compilerOptions: {
        target: "esnext", module: "esnext", moduleResolution: "bundler",
        lib: ["esnext", "dom"], jsx: "react", allowJs: true,
        skipLibCheck: true, strict: false, noEmit: true,
        esModuleInterop: true, allowSyntheticDefaultImports: true,
        resolveJsonModule: true, experimentalDecorators: true,
        emitDecoratorMetadata: true,
        // Skip module resolution — corpus fixtures contain `import`
        // statements that TS would recursively pull into the program,
        // inflating getOrCreateSourceFile / readFileSync by 15%+.  Type
        // queries inside a single fixture still work; only cross-file
        // imports are stubbed.
        noResolve: true,
      },
      files: [],
    }, null, 2));
  }
  _stamp("tsBefore");
  try { require("../js/ts-services").init(tsInitRoot); } catch { /* typescript optional */ }
  _stamp("tsAfter");
})();

_stamp("apiBefore");
const { lint } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");
const { discoverFiles } = require("../js/index.js");
_stamp("apiAfter");

const corpusRoot = path.resolve(process.argv[2] || "tests/fixtures/extracted/corpus");
const loopForever = process.env.EZ_PROFILE_LOOP === "1";

function loadPlugins() {
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
  // EZ_PROFILE_PLUGINS="unicorn"  → load just unicorn
  // EZ_PROFILE_PLUGINS=""         → core-only baseline
  // unset                         → load all (default)
  const filter = process.env.EZ_PROFILE_PLUGINS;
  const allow = filter === undefined ? null
              : filter === ""        ? new Set()
              :                        new Set(filter.split(","));
  const out = [];
  for (const { prefix, pkg } of entries) {
    if (allow && !allow.has(prefix)) continue;
    const t0 = performance.now();
    try {
      const mod = require(require.resolve(pkg, {
        paths: [path.resolve(__dirname, "../js"), process.cwd()],
      }));
      const plugin = mod?.default || mod;
      if (plugin && plugin.rules) out.push({ prefix, plugin });
    } catch { /* skip missing */ }
    const dt = performance.now() - t0;
    if (process.env.EZ_DEBUG_PLUGIN_LOAD) console.log(`  ${prefix.padEnd(20)} ${dt.toFixed(1).padStart(7)}ms`);
  }
  return out;
}

(async () => {
  _stamp("pluginsBefore");
  const pluginDescs = loadPlugins();
  _stamp("pluginsAfter");
  const rules = {};
  for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
  for (const { prefix, plugin } of pluginDescs) {
    for (const r of Object.keys(plugin.rules)) {
      const rule = plugin.rules[r];
      const create = rule?.create || rule;
      if (typeof create !== "function") continue;
      if (rule?.meta?.deprecated) continue;
      rules[`${prefix}/${r}`] = "error";
    }
  }

  // Pre-discover so each lint() call is bounded. Signals are checked between
  // chunks; one chunk takes ~1-2s, so SIGINT/SIGTERM propagate quickly enough
  // for bun --cpu-prof to flush the profile on exit.
  const discovered = discoverFiles([corpusRoot]).paths;
  const limit = parseInt(process.env.EZ_PROFILE_LIMIT || "0", 10) || 0;
  const allFiles = limit > 0 ? discovered.slice(0, limit) : discovered;
  const CHUNK = 500;

  // Batch-register all TS files with ts-services so the LanguageService
  // rebinds the program once on first type query rather than per-file.
  try {
    const tsFiles = allFiles.filter(p => /\.[mc]?tsx?$/.test(p));
    if (tsFiles.length > 0) {
      const svc = require("../js/ts-services");
      svc.init(path.resolve(corpusRoot, ".."));
      svc.registerFiles(tsFiles);
    }
  } catch { /* ts optional */ }
  console.log(`PID ${process.pid}  rules ${Object.keys(rules).length}  files ${allFiles.length}  chunk ${CHUNK}${loopForever ? "  loop=forever" : ""}`);

  const durationMs = parseInt(process.env.EZ_PROFILE_SECONDS || "30", 10) * 1000;
  const startedAt = Date.now();
  let stop = false;
  process.on("SIGINT",  () => { stop = true; });
  process.on("SIGTERM", () => { stop = true; });

  // Reuse one config object across every lint call so api.js's resolved-
  // config cache hits and the runner's visitor cache stays stable.  A
  // fresh `{ rules, plugins }` literal per call would make lint() rebuild
  // every rule's visitors from scratch on each file — a per-file leak that
  // balloons RSS past 10 GB on corpora of a few thousand files.
  const lintConfig = { rules, plugins: pluginDescs };

  // Separate startup warmup (first lint() resolves config, builds VM cold)
  // from steady-state linting so per-file numbers are meaningful.
  let totalDiags = 0;
  const t0 = performance.now();
  const wr = await lint(allFiles.slice(0, 1), lintConfig);
  for (const f of wr) totalDiags += f.diagnostics.length;
  const tWarm = performance.now();

  const mbFmt = (n) => (n / 1024 / 1024).toFixed(0);
  const mem = process.env.EZ_PROFILE_MEM === "1";
  const forceGc = process.env.EZ_PROFILE_GC === "1";
  let chunksSinceMem = 0;
  do {
    for (let i = 0; i < allFiles.length && !stop; i += CHUNK) {
      const r = await lint(allFiles.slice(i, i + CHUNK), lintConfig);
      for (const f of r) totalDiags += f.diagnostics.length;
      if (forceGc && typeof Bun !== "undefined" && typeof Bun.gc === "function") Bun.gc(true);
      if (mem && ++chunksSinceMem >= 4) {
        chunksSinceMem = 0;
        const m = process.memoryUsage();
        console.log(`  i=${i + CHUNK}  rss=${mbFmt(m.rss)}M  heap=${mbFmt(m.heapUsed)}/${mbFmt(m.heapTotal)}M  ext=${mbFmt(m.external || 0)}M`);
      }
      if (loopForever && Date.now() - startedAt > durationMs) stop = true;
    }
  } while (loopForever && !stop);
  const tEnd = performance.now();

  const warmupMs = tWarm - t0;
  const lintMs = tEnd - tWarm;
  const totalFiles = allFiles.length;
  console.log();
  console.log(`=== startup (one-time) ===`);
  console.log(`  ts-services.init:   ${(_t.tsAfter - _t.tsBefore).toFixed(1)}ms`);
  console.log(`  require api.js:     ${(_t.apiAfter - _t.apiBefore).toFixed(1)}ms`);
  console.log(`  loadPlugins:        ${(_t.pluginsAfter - _t.pluginsBefore).toFixed(1)}ms`);
  console.log(`  total to first lint ${(_t.tsBefore - _t.start + (_t.tsAfter - _t.tsBefore) + (_t.apiAfter - _t.apiBefore) + (_t.pluginsAfter - _t.pluginsBefore)).toFixed(1)}ms+`);
  console.log(`=== lint ===`);
  console.log(`  warmup (1 file):    ${warmupMs.toFixed(1)}ms`);
  console.log(`  steady (${totalFiles} files):   ${lintMs.toFixed(1)}ms = ${(lintMs / totalFiles).toFixed(2)}ms/file`);
  console.log(`  total diags:        ${totalDiags}`);

  console.log("done");
})().catch((e) => { console.error(e); process.exit(1); });
