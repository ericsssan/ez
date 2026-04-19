// Find who retains per-file state after GC.
//
// Lint N files, force GC, dump heap snapshot via bun --heap-prof-md.
// Then lint another N, force GC, snapshot again.  Types whose count
// went up by ~N are the leak per-file.
//
// Usage:
//   bun --heap-prof-md --heap-prof-dir=/tmp bench/mem_js_leak.js

const path = require("path");
const ROOT = "/Users/ericsan/Development/OpenSource/Ez";
const { lint } = require(ROOT + "/js/api.js");
const { loadCoreRules } = require(ROOT + "/js/load-plugin.js");
const { discoverFiles } = require(ROOT + "/js/index.js");

const uPath = require.resolve("eslint-plugin-unicorn", { paths: [ROOT + "/js"] });
const unicorn = require(uPath);
const uPlugin = unicorn.default || unicorn;
const plugins = [{ prefix: "unicorn", plugin: uPlugin }];

const rules = {};
for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
for (const r of Object.keys(uPlugin.rules)) {
  const rule = uPlugin.rules[r];
  if (typeof (rule?.create || rule) !== "function") continue;
  if (rule?.meta?.deprecated) continue;
  rules[`unicorn/${r}`] = "error";
}

const files = discoverFiles([ROOT + "/bench/fixtures/extracted/corpus"]).paths.slice(0, 4000);
const N = 2000;
const mb = n => (n/1024/1024).toFixed(0);

(async () => {
  // phase 1: lint first N files
  for (let i = 0; i < N; i += 500) {
    await lint(files.slice(i, i + 500), { rules, plugins });
  }
  Bun.gc(true); Bun.gc(true);
  const m1 = process.memoryUsage();
  console.log(`after ${N}: rss=${mb(m1.rss)}M heap=${mb(m1.heapUsed)}M ext=${mb(m1.external||0)}M`);

  // phase 2: lint next N
  for (let i = N; i < 2 * N; i += 500) {
    await lint(files.slice(i, i + 500), { rules, plugins });
  }
  Bun.gc(true); Bun.gc(true);
  const m2 = process.memoryUsage();
  console.log(`after ${2*N}: rss=${mb(m2.rss)}M heap=${mb(m2.heapUsed)}M ext=${mb(m2.external||0)}M`);

  const heapDelta = m2.heapUsed - m1.heapUsed;
  const rssDelta = m2.rss - m1.rss;
  console.log(`\ndelta over ${N} files:  heap=${(heapDelta/1024/1024).toFixed(0)}MB  rss=${(rssDelta/1024/1024).toFixed(0)}MB`);
  console.log(`per-file: heap=${(heapDelta/N/1024).toFixed(1)}KB  rss=${(rssDelta/N/1024).toFixed(1)}KB`);
})();
