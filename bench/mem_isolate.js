// Isolate which NAPI call leaks. Runs the SAME small source N times.
//
//   bun --expose-gc bench/mem_isolate.js --mode parse    --iters 5000
//   bun --expose-gc bench/mem_isolate.js --mode lintOnly --iters 5000
//   bun --expose-gc bench/mem_isolate.js --mode full     --iters 5000
//   bun --expose-gc bench/mem_isolate.js --mode full-plugins --iters 5000

const path = require("path");
const { parseSource } = require("../js/index.js");
const { lintSource, createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");

const args = process.argv.slice(2);
function flag(n, d = null) { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; }
const mode  = flag("--mode", "full");
const iters = parseInt(flag("--iters", "5000"), 10);
const every = parseInt(flag("--every", "500"), 10);
const pluginFilter = flag("--plugins"); // comma-separated prefix list

const source = `
function foo(x, y) {
  if (x > 0) return y * 2;
  else { let z = x + 1; return z; }
}
const arr = [1, 2, 3].map(n => foo(n, n));
class Bar { constructor() { this.v = 42; } }
`;

function mb(n) { return (n / 1024 / 1024).toFixed(1); }
function rep(i) {
  const m = process.memoryUsage();
  console.log(`i=${String(i).padStart(5)}  rss=${mb(m.rss)}M  heap=${mb(m.heapUsed)}M  ext=${mb(m.external || 0)}M  ab=${mb(m.arrayBuffers || 0)}M`);
}

function loadPlugins(filter) {
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
  const allowSet = filter ? new Set(filter.split(",")) : null;
  for (const { prefix, pkg } of entries) {
    if (allowSet && !allowSet.has(prefix)) continue;
    try {
      const mod = require(require.resolve(pkg, { paths: [path.resolve(__dirname, "../js"), process.cwd()] }));
      const plugin = mod?.default || mod;
      if (plugin && plugin.rules) out.push({ prefix, plugin });
    } catch {}
  }
  return out;
}

async function main() {
  let L = null;
  if (mode === "full" || mode === "full-plugins") {
    const rules = {};
    for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
    const pluginDescs = mode === "full-plugins" ? loadPlugins(pluginFilter) : [];
    for (const { prefix, plugin } of pluginDescs) {
      for (const ruleName of Object.keys(plugin.rules)) {
        const rule = plugin.rules[ruleName];
        const create = rule?.create || rule;
        if (typeof create !== "function") continue;
        if (rule?.meta?.deprecated) continue;
        rules[`${prefix}/${ruleName}`] = "error";
      }
    }
    L = await createLinter({ rules, plugins: pluginDescs });
    console.log(`rules: ${Object.keys(rules).length}  plugins: ${pluginDescs.length}`);
  }
  console.log(`mode=${mode}  iters=${iters}`);
  rep(0);
  for (let i = 0; i < iters; i++) {
    if (mode === "parse") {
      parseSource(source, { filename: "test.js" });
    } else if (mode === "lintOnly") {
      await lintSource(source, { filename: "test.js", rules: { "no-debugger": "error" } });
    } else {
      await L(source, "test.js");
    }
    if ((i + 1) % every === 0) {
      if (typeof global.gc === "function") global.gc();
      rep(i + 1);
    }
  }
  if (typeof global.gc === "function") global.gc();
  rep(iters);
}
main().catch(e => { console.error(e); process.exit(1); });
