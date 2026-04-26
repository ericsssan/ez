const ROOT = "/Users/ericsan/Development/OpenSource/Ez";
const { lint } = require(ROOT + "/js/api.js");
const { loadCoreRules } = require(ROOT + "/js/load-plugin.js");
const { discoverFiles } = require(ROOT + "/js/index.js");

const rules = {};
for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";

const N = parseInt(process.env.EZ_N || "50000", 10);
const GC_EVERY = parseInt(process.env.EZ_GC || "5000", 10);
const files = discoverFiles([ROOT + "/tests/fixtures/extracted/corpus"]).paths.slice(0, N);

console.log(`PID ${process.pid}  files ${files.length}  gc-every ${GC_EVERY}`);

(async () => {
  let lastGc = 0;
  for (let i = 0; i < files.length; i += 500) {
    await lint(files.slice(i, i + 500), { rules });
    if (i - lastGc >= GC_EVERY) { Bun.gc(true); lastGc = i; }
  }
  console.log("done");
})();
