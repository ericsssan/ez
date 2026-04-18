// Isolate which NAPI call leaks. Runs the SAME small source N times.
// Flag controls what's called.
//
//   bun --expose-gc bench/mem_isolate.js --mode parse --iters 5000
//   bun --expose-gc bench/mem_isolate.js --mode lintOnly --iters 5000
//   bun --expose-gc bench/mem_isolate.js --mode full --iters 5000

const { parseSource } = require("../js/index.js");
const { lintSource, createLinter } = require("../js/api.js");
const { loadCoreRules } = require("../js/load-plugin.js");

const args = process.argv.slice(2);
function flag(n, d = null) { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : d; }
const mode  = flag("--mode", "full");
const iters = parseInt(flag("--iters", "5000"), 10);
const every = parseInt(flag("--every", "500"), 10);

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

async function main() {
  let L = null;
  if (mode === "full") {
    const rules = {};
    for (const d of loadCoreRules({})) if (d.meta?.name) rules[d.meta.name] = "error";
    L = await createLinter({ rules });
  }
  console.log(`mode=${mode}  iters=${iters}`);
  rep(0);
  for (let i = 0; i < iters; i++) {
    if (mode === "parse") {
      parseSource(source, { filename: "test.js" });
    } else if (mode === "lintOnly") {
      // Only native — no JS rules
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
