#!/usr/bin/env bun
"use strict";
//
// Build-time pattern rewriter — pre-computes pattern-rewritten copies of
// rule sources so the runtime loader can serve the rewritten file directly
// instead of running the AST analysis + textual transform on every cold
// load. Output goes to `.ez/rules-rewritten-patterns/<plugin>/<rule>.js`.
//
// Deep Bun integration: uses `Bun.file`, `Bun.write`, and `Bun.Glob` for
// fast IO and discovery. The transform itself comes from
// `tools/rule-rewriter-patterns.js` so the offline-build and runtime
// fallback share one detector + emitter.
//
// Usage:
//   bun tools/build-pattern-rewrites.js
//     → builds rewrites for the default plugin set
//   bun tools/build-pattern-rewrites.js --src <dir> --plugin <key>
//     → builds rewrites for a single plugin's rules dir

import { rewrite as applyPatternRewrite } from "./rule-rewriter-patterns.js";
import { resolve, basename, join } from "node:path";

const ROOT = resolve(import.meta.dir, "..");
const OUT_ROOT = resolve(ROOT, ".ez/rules-rewritten-patterns");

// Each entry: { key (used in output dir), srcGlobBase, glob }. globs use
// Bun.Glob — patterns relative to srcGlobBase.
const DEFAULT_TARGETS = [
  {
    key: "eslint",
    base: resolve(ROOT, "js/node_modules/eslint/lib/rules"),
    glob: "*.js",
  },
  {
    key: "unicorn",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-unicorn/rules"),
    glob: "*.js",
  },
  {
    key: "react",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-react/lib/rules"),
    glob: "*.js",
  },
  {
    key: "promise",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-promise/rules"),
    glob: "*.js",
  },
  {
    key: "import",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-import/lib/rules"),
    glob: "*.js",
  },
  {
    key: "n",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-n/lib/rules"),
    glob: "*.js",
  },
  {
    key: "@typescript-eslint",
    base: resolve(ROOT, "js/node_modules/@typescript-eslint/eslint-plugin/dist/rules"),
    glob: "*.js",
  },
  {
    key: "jsdoc",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-jsdoc/dist"),
    glob: "*.js",
  },
];

async function buildOne(target) {
  if (!(await Bun.file(target.base).exists?.()) && !await directoryExists(target.base)) {
    return { key: target.key, attempted: 0, written: 0, totalMatches: 0, skipped: "missing" };
  }
  const glob = new Bun.Glob(target.glob);
  let attempted = 0, written = 0, totalMatches = 0;
  const outDir = join(OUT_ROOT, target.key);
  for await (const entry of glob.scan({ cwd: target.base, onlyFiles: true })) {
    attempted++;
    const inPath = join(target.base, entry);
    const src = await Bun.file(inPath).text();
    let r;
    try {
      r = applyPatternRewrite(src);
    } catch {
      continue;
    }
    if (r.matches === 0) continue;
    const outPath = join(outDir, entry);
    await Bun.write(outPath, r.src);
    written++;
    totalMatches += r.matches;
  }
  return { key: target.key, attempted, written, totalMatches };
}

async function directoryExists(p) {
  try {
    const fs = await import("node:fs/promises");
    const s = await fs.stat(p);
    return s.isDirectory();
  } catch {
    return false;
  }
}

async function main() {
  const t0 = Bun.nanoseconds();
  const results = [];
  for (const target of DEFAULT_TARGETS) {
    results.push(await buildOne(target));
  }
  const elapsedMs = Math.round((Bun.nanoseconds() - t0) / 1_000_000);
  let totalAttempted = 0, totalWritten = 0, totalMatches = 0;
  for (const r of results) {
    totalAttempted += r.attempted;
    totalWritten += r.written;
    totalMatches += r.totalMatches;
    const note = r.skipped ? ` (${r.skipped})` : "";
    process.stderr.write(
      `  ${r.key.padEnd(24)} attempted=${String(r.attempted).padStart(4)}  written=${String(r.written).padStart(3)}  matches=${String(r.totalMatches).padStart(4)}${note}\n`
    );
  }
  process.stderr.write(
    `\n  totals: attempted=${totalAttempted}  written=${totalWritten}  matches=${totalMatches}  in ${elapsedMs}ms\n`
  );
  process.stderr.write(`  output: ${OUT_ROOT}\n`);
}

if (import.meta.main) await main();
