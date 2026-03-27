"use strict";

/**
 * Benchmark for sx3lint NAPI / Bun FFI parse performance.
 * Run with: node bench/bench_napi.js [file.js]
 * Or:       bun bench/bench_napi.js [file.js]
 */

const { parse, reset, getTagNames } = require("../js/index");
const { runPlugins } = require("../js/plugin-runner");
const fs = require("fs");
const path = require("path");

// ── Config ───────────────────────────────────────────────────────

const WARMUP = 5;
const ITERATIONS = 100;

const sampleSource = `
import React, { useState, useEffect } from "react";
import { api } from "./api";

export default function Dashboard({ userId }) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;
    async function fetchData() {
      try {
        const result = await api.get("/dashboard/" + userId);
        if (!cancelled) {
          setData(result);
          setLoading(false);
        }
      } catch (err) {
        console.error("Failed to load:", err);
        if (!cancelled) setLoading(false);
      }
    }
    fetchData();
    return () => { cancelled = true; };
  }, [userId]);

  if (loading) return <div className="spinner">Loading...</div>;
  if (!data) return <div>No data</div>;

  return (
    <div className="dashboard">
      <h1>{data.title}</h1>
      <ul>
        {data.items.map((item, i) => (
          <li key={i}>{item.name}: {item.value}</li>
        ))}
      </ul>
    </div>
  );
}
`;

// ── Helpers ──────────────────────────────────────────────────────

function bench(name, fn, iterations = ITERATIONS) {
  // Warmup
  for (let i = 0; i < WARMUP; i++) fn();

  const start = performance.now();
  for (let i = 0; i < iterations; i++) fn();
  const elapsed = performance.now() - start;

  const perOp = elapsed / iterations;
  const opsPerSec = Math.round(1000 / perOp);
  console.log(`  ${name}: ${perOp.toFixed(3)}ms/op (${opsPerSec} ops/sec)`);
  return perOp;
}

// ── Benchmarks ──────────────────────────────────────────────────

const inputFile = process.argv[2];
const source = inputFile
  ? fs.readFileSync(inputFile, "utf-8")
  : sampleSource;
const filename = inputFile || "sample.jsx";

console.log(`sx3lint NAPI benchmark`);
console.log(`  Runtime: ${typeof Bun !== "undefined" ? "Bun" : "Node.js"}`);
console.log(`  Source: ${inputFile || "(built-in sample)"} (${source.length} bytes)`);
console.log(`  Iterations: ${ITERATIONS}\n`);

// Parse only
const parseTime = bench("parse", () => {
  const ast = parse(source, { filename });
  reset();
});

// Parse + plugin traversal
const tagNames = getTagNames();
const noopPlugin = {
  meta: { name: "noop" },
  create() {
    return { Identifier() {} };
  },
};

bench("parse + noop plugin", () => {
  const ast = parse(source, { filename });
  runPlugins(ast, [noopPlugin], { tagNames });
  reset();
});

// Parse + real plugin (count identifiers)
const countPlugin = {
  meta: { name: "count" },
  create(ctx) {
    return {
      Identifier() { ctx.report({ message: "id" }); },
    };
  },
};

bench("parse + count-ids plugin", () => {
  const ast = parse(source, { filename });
  runPlugins(ast, [countPlugin], { tagNames });
  reset();
});

// Multi-file throughput
console.log("");
const FILES = 100;
const multiStart = performance.now();
for (let i = 0; i < FILES; i++) {
  const ast = parse(source, { filename });
  reset();
}
const multiElapsed = performance.now() - multiStart;
console.log(`  ${FILES} files: ${multiElapsed.toFixed(1)}ms total (${(multiElapsed / FILES).toFixed(3)}ms/file)`);
console.log(`  Throughput: ${Math.round((source.length * FILES) / (multiElapsed / 1000) / 1024)} KB/s`);
