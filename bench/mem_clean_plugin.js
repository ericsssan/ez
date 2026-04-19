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

const N = parseInt(process.env.EZ_N || "10000", 10);
const files = discoverFiles([ROOT + "/tests/fixtures/extracted/corpus"]).paths
  .slice()
  .sort()
  .slice(0, N);

console.log(`PID ${process.pid}  files ${files.length}`);

(async () => {
  for (let i = 0; i < files.length; i += 500) {
    await lint(files.slice(i, i + 500), { rules, plugins });
  }
  console.log("done");
})();
