const fs = require("fs");
const path = require("path");
const { lintSourceNative, parseSource } = require("../js/index");
const { parseSync: oxcParseSync } = require("oxc-parser");

const fixtures = [
  "bench/fixtures/jquery.js",
  "bench/fixtures/lodash.js",
  "bench/fixtures/three.js",
  "bench/fixtures/typescript.js",
];

const WARMUP = 10, ITERATIONS = 50;

function bench(fn, n) { for (let i=0;i<WARMUP;i++) fn(); const t=performance.now(); for (let i=0;i<n;i++) fn(); return (performance.now()-t)/n; }

console.log("ez paths vs oxc parseSync (parse only)\n");
console.log(`${'fixture'.padEnd(20)} ${'ez parse'.padStart(10)} ${'ez lint'.padStart(10)} ${'oxc'.padStart(10)} ${'lint/oxc'.padStart(10)}`);
for (const fx of fixtures) {
  const p = path.join(__dirname, '..', fx);
  const src = fs.readFileSync(p, 'utf-8');
  const fname = path.basename(fx);
  const ezP = bench(() => parseSource(src, { filename: fname }), ITERATIONS);
  const ezL = bench(() => lintSourceNative(src, { filename: fname }), ITERATIONS);
  const oxc = bench(() => oxcParseSync(fname, src), ITERATIONS);
  console.log(`${fname.padEnd(20)} ${ezP.toFixed(2).padStart(10)} ${ezL.toFixed(2).padStart(10)} ${oxc.toFixed(2).padStart(10)} ${(ezL/oxc).toFixed(2).padStart(8)}x`);
}
