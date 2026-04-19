// Zero in-process instrumentation.  Just lint.  PID is printed at start
// so an external watcher can poll `ps -o rss -p $PID` to see RSS over
// time without any Bun.gc / memoryUsage / heap-snapshot calls polluting
// the measurement.

const ROOT = "/Users/ericsan/Development/OpenSource/Ez";
const { lint } = require(ROOT + "/js/api.js");
const { loadCoreRules } = require(ROOT + "/js/load-plugin.js");
const { discoverFiles } = require(ROOT + "/js/index.js");

const rules = {};
for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
const N = parseInt(process.env.EZ_N || "20000", 10);
const files = discoverFiles([ROOT + "/bench/fixtures/extracted/corpus"]).paths
  .slice()
  .sort()
  .slice(0, N);

console.log(`PID ${process.pid}  files ${files.length}`);

(async () => {
  for (let i = 0; i < files.length; i += 500) {
    await lint(files.slice(i, i + 500), { rules });
    if (process.env.EZ_LOG_I) console.log(`i=${i + 500}`);
  }
  console.log("done");
})();
