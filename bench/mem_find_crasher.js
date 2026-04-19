// Lint files one at a time starting at some offset. Log RSS per file so
// we can see which specific file blows up memory.
const ROOT = "/Users/ericsan/Development/OpenSource/Ez";
const { lint } = require(ROOT + "/js/api.js");
const { loadCoreRules } = require(ROOT + "/js/load-plugin.js");
const { discoverFiles } = require(ROOT + "/js/index.js");

const rules = {};
for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";

const START = parseInt(process.env.EZ_START || "37500", 10);
const END = parseInt(process.env.EZ_END || "38000", 10);
const files = discoverFiles([ROOT + "/bench/fixtures/extracted/corpus"]).paths;

console.log(`PID ${process.pid}  range [${START},${END})  total ${files.length}`);

const fs = require("fs");
const logFd = fs.openSync("/tmp/crasher.log", "w");
function log(s) { fs.writeSync(logFd, s + "\n"); fs.fsyncSync(logFd); }

(async () => {
  for (let i = START; i < END && i < files.length; i++) {
    const rss = (process.memoryUsage().rss / 1e6).toFixed(0);
    log(`i=${i} rss=${rss}MB ${files[i]}`);
    await lint([files[i]], { rules });
  }
  log("done");
})();
