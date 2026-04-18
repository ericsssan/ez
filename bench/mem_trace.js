// bench/mem_trace.js
//
// Walks the same corpus but logs RSS every N files and dumps heap snapshots
// at two configurable checkpoints. Use snapshot diff to find the retained
// object type.
//
//   bun --expose-gc bench/mem_trace.js --limit 20000 --every 1000 --snap-at 500,15000

const fs   = require("fs");
const path = require("path");
const { createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");

const args = process.argv.slice(2);
function flag(name, def = null) {
  const i = args.indexOf(name);
  return i >= 0 ? args[i + 1] : def;
}
const limit  = parseInt(flag("--limit", "15000"), 10);
const every  = parseInt(flag("--every", "500"), 10);
const snapAt = flag("--snap-at", "500,15000").split(",").map(n => parseInt(n, 10));
const forceGc = args.includes("--gc");

const root = path.resolve("bench/fixtures/extracted");
const corpusRoot = path.join(root, "corpus");

function unmapPrefix(s) { return s === "eslint" ? null : s === "_typescript-eslint" ? "@typescript-eslint" : s; }

const tasks = [];
for (const safePrefix of fs.readdirSync(corpusRoot).sort()) {
  const prefixDir = path.join(corpusRoot, safePrefix);
  if (!fs.statSync(prefixDir).isDirectory()) continue;
  for (const safeRule of fs.readdirSync(prefixDir).sort()) {
    const ruleDir = path.join(prefixDir, safeRule);
    if (!fs.statSync(ruleDir).isDirectory()) continue;
    for (const kind of ["valid", "invalid"]) {
      const kindDir = path.join(ruleDir, kind);
      if (!fs.existsSync(kindDir)) continue;
      for (const entry of fs.readdirSync(kindDir)) {
        const full = path.join(kindDir, entry);
        if (!fs.statSync(full).isFile()) continue;
        tasks.push({ file: full, kind });
        if (tasks.length >= limit) break;
      }
      if (tasks.length >= limit) break;
    }
    if (tasks.length >= limit) break;
  }
  if (tasks.length >= limit) break;
}

for (const t of tasks) t.code = fs.readFileSync(t.file, "utf8");

const coreRules = loadCoreRules({});
const rulesConfig = {};
for (const d of coreRules) if (d.meta?.name) rulesConfig[d.meta.name] = "error";

function mb(n) { return (n / 1024 / 1024).toFixed(1); }
function report(i) {
  const m = process.memoryUsage();
  console.log(`i=${String(i).padStart(6)}  rss=${mb(m.rss)}M  heap=${mb(m.heapUsed)}/${mb(m.heapTotal)}M  ext=${mb(m.external || 0)}M  ab=${mb(m.arrayBuffers || 0)}M`);
}

async function main() {
  const L = await createLinter({ rules: rulesConfig });
  console.log(`Tasks: ${tasks.length}, rules: ${Object.keys(rulesConfig).length}, gc: ${forceGc ? "yes" : "no"}`);
  console.log("i=     0  (baseline)");
  report(0);
  console.log();

  const snapSet = new Set(snapAt);
  let diagTotal = 0;
  for (let i = 0; i < tasks.length; i++) {
    const t = tasks[i];
    try {
      const diags = await L(t.code, t.file);
      diagTotal += diags.length;
    } catch {}
    if ((i + 1) % every === 0) {
      if (forceGc && typeof global.gc === "function") global.gc();
      report(i + 1);
    }
    if (snapSet.has(i + 1)) {
      if (forceGc && typeof global.gc === "function") global.gc();
      const snapFile = `/tmp/ez-heap-${i + 1}.heapsnapshot`;
      try {
        const snap = Bun.generateHeapSnapshot();
        fs.writeFileSync(snapFile, JSON.stringify(snap));
        console.log(`    ↳ snapshot written: ${snapFile}`);
      } catch (e) {
        console.log(`    ↳ snapshot failed: ${e.message}`);
      }
    }
  }
  console.log();
  console.log(`diags total: ${diagTotal}`);
  report(tasks.length);
}
main().catch(e => { console.error(e); process.exit(1); });
