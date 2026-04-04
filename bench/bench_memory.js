"use strict";
const { parse, reset, getTagNames } = require("../js/index");
const { runPlugins } = require("../js/eslint-runner");

const tagNames = getTagNames();

const source = `
import React, { useState, useEffect } from "react";
export default function Dashboard({ userId }) {
  const [data, setData] = useState(null);
  useEffect(() => {
    async function fetchData() {
      const result = await fetch("/api/" + userId);
      setData(await result.json());
    }
    fetchData();
  }, [userId]);
  if (!data) return null;
  return React.createElement("div", null, data.title);
}
`;

const plugin = {
  meta: { name: "count" },
  create(ctx) {
    return { Identifier() { ctx.report({ message: "id" }); } };
  },
};

// Warmup
for (let i = 0; i < 10; i++) { parse(source); reset(); }
if (global.gc) global.gc();

const before = process.memoryUsage();

// Parse 1000 files
for (let i = 0; i < 1000; i++) {
  const ast = parse(source);
  runPlugins(ast, [plugin], { tagNames });
  reset();
}

if (global.gc) global.gc();
const after = process.memoryUsage();

console.log("Memory usage (1000 files parsed):");
console.log(`  RSS:          ${(after.rss / 1024 / 1024).toFixed(1)} MB`);
console.log(`  Heap used:    ${(after.heapUsed / 1024 / 1024).toFixed(1)} MB`);
console.log(`  Heap total:   ${(after.heapTotal / 1024 / 1024).toFixed(1)} MB`);
console.log(`  ArrayBuffers: ${(after.arrayBuffers / 1024 / 1024).toFixed(1)} MB`);
console.log(`  External:     ${(after.external / 1024 / 1024).toFixed(1)} MB`);

// Leak check — parse 1000 more
const mid = process.memoryUsage();
for (let i = 0; i < 1000; i++) {
  const ast = parse(source);
  runPlugins(ast, [plugin], { tagNames });
  reset();
}
if (global.gc) global.gc();
const final = process.memoryUsage();

const heapDelta = final.heapUsed - mid.heapUsed;
const abDelta = final.arrayBuffers - mid.arrayBuffers;
console.log(`\nLeak check (2nd 1000 files):`);
console.log(`  Heap delta:   ${(heapDelta / 1024).toFixed(0)} KB ${Math.abs(heapDelta) < 100000 ? "OK" : "⚠ LEAK"}`);
console.log(`  AB delta:     ${(abDelta / 1024).toFixed(0)} KB ${Math.abs(abDelta) < 10000 ? "OK (buffer reused)" : "⚠ LEAK"}`);
