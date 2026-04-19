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

// ── ts-services: init against the fixture root before api.js ──
// api.js's module-level init() uses process.cwd(), which has no tsconfig.
// Write a synthetic tsconfig at the fixture root covering corpus/** so
// type-aware @typescript-eslint rules get real parserServices instead
// of throwing on every call. The extracted/ directory is gitignored,
// so the file lives alongside the regenerable fixtures.
(() => {
  const tsInitRoot = path.resolve(process.argv[2] || "bench/fixtures/extracted");
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
      },
      files: [],
    }, null, 2));
  }
  try { require("../js/ts-services").init(tsInitRoot); } catch { /* typescript optional */ }
})();

const { lint } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");
const { discoverFiles } = require("../js/index.js");

const corpusRoot = path.resolve(process.argv[2] || "bench/fixtures/extracted/corpus");
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
  const out = [];
  for (const { prefix, pkg } of entries) {
    try {
      const mod = require(require.resolve(pkg, {
        paths: [path.resolve(__dirname, "../js"), process.cwd()],
      }));
      const plugin = mod?.default || mod;
      if (plugin && plugin.rules) out.push({ prefix, plugin });
    } catch { /* skip missing */ }
  }
  return out;
}

(async () => {
  const pluginDescs = loadPlugins();
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
  console.log(`PID ${process.pid}  rules ${Object.keys(rules).length}  files ${allFiles.length}  chunk ${CHUNK}${loopForever ? "  loop=forever" : ""}`);

  // Time-based stop so the process exits cleanly and Bun --cpu-prof flushes
  // the profile file. SIGINT is racy with async lint() awaits; a timer is
  // deterministic. Override with EZ_PROFILE_SECONDS.
  const durationMs = parseInt(process.env.EZ_PROFILE_SECONDS || "30", 10) * 1000;
  const startedAt = Date.now();
  let stop = false;
  process.on("SIGINT",  () => { stop = true; });
  process.on("SIGTERM", () => { stop = true; });

  do {
    for (let i = 0; i < allFiles.length && !stop; i += CHUNK) {
      await lint(allFiles.slice(i, i + CHUNK), { rules, plugins: pluginDescs });
      if (loopForever && Date.now() - startedAt > durationMs) stop = true;
    }
  } while (loopForever && !stop);

  console.log("done");
})().catch((e) => { console.error(e); process.exit(1); });
