// Native-side memory tracer.  Runs lint on increasing file counts and
// dumps vmmap summaries between rounds so we can see which native memory
// regions grow per file (distinct from V8 heap / ArrayBuffers).
//
// Usage:
//   bun bench/mem_native_trace.js
//   # Then from another terminal, watch /tmp/vmmap-*.txt as they land.

const path = require("path");
const { lint } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");
const { discoverFiles } = require("../js/index.js");
const child_process = require("child_process");
const fs = require("fs");

const pid = process.pid;

function snapVmmap(label) {
  const out = `/tmp/vmmap-${label}.txt`;
  try {
    child_process.execSync(`vmmap --summary ${pid} > ${out}`, { stdio: ["ignore", "ignore", "ignore"] });
    const m = process.memoryUsage();
    const mb = (n) => (n / 1024 / 1024).toFixed(0);
    console.log(`${label.padEnd(8)}  rss=${mb(m.rss)}M  heap=${mb(m.heapUsed)}M  ext=${mb(m.external || 0)}M  → ${out}`);
  } catch (e) {
    console.log(`vmmap failed: ${e.message}`);
  }
}

function loadPlugins() {
  const entries = [
    { prefix: "@typescript-eslint", pkg: "@typescript-eslint/eslint-plugin" },
    { prefix: "unicorn",            pkg: "eslint-plugin-unicorn"            },
  ];
  const out = [];
  for (const { prefix, pkg } of entries) {
    try {
      const mod = require(require.resolve(pkg, {
        paths: [path.resolve(__dirname, "../js"), process.cwd()],
      }));
      const plugin = mod?.default || mod;
      if (plugin && plugin.rules) out.push({ prefix, plugin });
    } catch {}
  }
  return out;
}

(async () => {
  console.log(`PID ${pid}`);
  snapVmmap("boot");

  const rules = {};
  for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
  const pluginDescs = loadPlugins();
  for (const { prefix, plugin } of pluginDescs) {
    for (const r of Object.keys(plugin.rules)) {
      const rule = plugin.rules[r];
      if (typeof (rule?.create || rule) !== "function") continue;
      if (rule?.meta?.deprecated) continue;
      rules[`${prefix}/${r}`] = "error";
    }
  }

  const corpusRoot = path.resolve("tests/fixtures/extracted/corpus");
  const files = discoverFiles([corpusRoot]).paths.slice(0, 10000);
  snapVmmap("rules_loaded");

  // Warmup
  await lint(files.slice(0, 10), { rules, plugins: pluginDescs });
  if (typeof Bun !== "undefined" && typeof Bun.gc === "function") Bun.gc(true);
  snapVmmap("warm");

  for (const n of [1000, 2000, 5000, 10000]) {
    const slice = files.slice(0, n);
    // Fresh lint of first N files
    await lint(slice, { rules, plugins: pluginDescs });
    if (typeof Bun !== "undefined" && typeof Bun.gc === "function") Bun.gc(true);
    snapVmmap(`after_${n}`);
  }

  console.log("\nDiff key regions between snapshots:");
  console.log("  diff /tmp/vmmap-warm.txt /tmp/vmmap-after_10000.txt");
})();
