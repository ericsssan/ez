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
import { resolve, basename, dirname, join } from "node:path";
import { readFileSync, statSync } from "node:fs";

const ROOT = resolve(import.meta.dir, "..");
const OUT_ROOT = resolve(ROOT, ".ez/rules-rewritten-patterns");

// Bun 1.3.9's `Bun.plugin` `onLoad({ contents })` always parses the
// returned source as ESM. CJS modules served through this path return
// empty `module.exports`. Until Bun fixes that, the substitution
// pipeline only works for ESM packages. We detect by walking up from
// the source dir to the nearest package.json and checking `type`.
function packageIsEsm(srcDir) {
  let dir = srcDir;
  for (let i = 0; i < 12; i++) {
    const pj = join(dir, "package.json");
    try {
      if (statSync(pj).isFile()) {
        const j = JSON.parse(readFileSync(pj, "utf8"));
        return j.type === "module";
      }
    } catch {}
    const parent = dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  return false;
}

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
    // eslint-plugin-jsdoc dist ships `.cjs` files (rules under
    // `dist/rules/*.cjs`) despite the package's `"type": "module"`.
    // Use a recursive glob over both extensions so the rule files in
    // the `rules/` subdirectory are picked up. Earlier builds had
    // `glob: "*.js"` which matched zero files, leaving every jsdoc
    // rule unsubstituted (~225ms × 10 jsdoc rules unrewritten on
    // typescript.js).
    key: "jsdoc",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-jsdoc/dist"),
    glob: "**/*.{cjs,js,mjs}",
  },
];

async function buildOne(target, manifestEntries) {
  if (!(await Bun.file(target.base).exists?.()) && !await directoryExists(target.base)) {
    return { key: target.key, attempted: 0, written: 0, totalMatches: 0, skipped: "missing" };
  }
  // Bun 1.3.9's `Bun.plugin` `onLoad({ contents })` returns parse as
  // ESM regardless of the file's package. ESM packages route through
  // Bun.plugin at runtime; CJS packages use a `require.cache` install
  // instead — both written here, the loader picks the right path
  // based on the manifest's `module` field.
  const isEsm = packageIsEsm(target.base);
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
    // Per-file module type — extension overrides package `"type"` for
    // `.cjs` and `.mjs` (Node/Bun semantics). Without this override,
    // a CJS .cjs file inside an ESM-typed package (e.g. eslint-plugin-jsdoc
    // ships `.cjs` rules under `"type": "module"`) gets labelled "esm",
    // routes through Bun.plugin onLoad, and parses as ESM — `module.exports`
    // is unbound, body silently no-ops, exported empty `{__esModule: true}`.
    const isEntryCjs = entry.endsWith(".cjs");
    const isEntryMjs = entry.endsWith(".mjs");
    const fileModule = isEntryCjs ? "cjs" : isEntryMjs ? "esm" : (isEsm ? "esm" : "cjs");
    manifestEntries.push({
      key: target.key,
      file: entry,
      upstreamPath: inPath,
      module: fileModule,
    });
    written++;
    totalMatches += r.matches;
  }
  return { key: target.key, attempted, written, totalMatches, module: isEsm ? "esm" : "cjs" };
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

// Hand-written substitute files under `tools/overrides/<key>/<file>` are
// copied verbatim to `.ez/rules-rewritten-patterns/<key>/<file>` and
// served by the runtime loader via the same Bun.plugin mechanism as
// pattern-detected rewrites. Use these when an upstream module is a
// good fit for replacement but doesn't match a generic AST shape — e.g.
// a small piece of plugin infrastructure where we want to swap the
// implementation wholesale (unicorn's listener pipeline).
const OVERRIDES_ROOT = resolve(ROOT, "tools/overrides");

// Map override `key` (directory under `tools/overrides/`) → upstream
// dir + module type. The loader uses this to pick Bun.plugin (ESM) vs
// require.cache (CJS) when wiring the substitute at runtime.
const OVERRIDE_KEY_TO_UPSTREAM = {
  "unicorn-rule": {
    upstreamDir: resolve("/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule"),
    module: "esm",
  },
  // jsdoccomment is dual-built; eslint-plugin-jsdoc requires the CJS
  // bundle (its rules ship as `.cjs` files), so the substitute targets
  // dist/index.cjs.cjs and routes through require.cache.
  "jsdoccomment": {
    upstreamDir: resolve("/Users/ericsan/node_modules/@es-joy/jsdoccomment/dist"),
    module: "cjs",
  },
};

async function copyOverrides(manifestEntries) {
  const results = [];
  if (!await directoryExists(OVERRIDES_ROOT)) return results;
  const fsp = await import("node:fs/promises");
  const keys = await fsp.readdir(OVERRIDES_ROOT, { withFileTypes: true });
  for (const k of keys) {
    if (!k.isDirectory()) continue;
    const inDir = join(OVERRIDES_ROOT, k.name);
    const meta = OVERRIDE_KEY_TO_UPSTREAM[k.name];
    const files = await fsp.readdir(inDir, { withFileTypes: true });
    for (const f of files) {
      if (!f.isFile()) continue;
      if (!/\.(?:js|cjs|mjs)$/.test(f.name)) continue;
      const src = await Bun.file(join(inDir, f.name)).text();
      await Bun.write(join(OUT_ROOT, k.name, f.name), src);
      results.push({ key: k.name, file: f.name });
      if (meta) {
        manifestEntries.push({
          key: k.name,
          file: f.name,
          upstreamPath: join(meta.upstreamDir, f.name),
          module: meta.module,
        });
      }
    }
  }
  return results;
}

async function main() {
  const t0 = Bun.nanoseconds();
  const results = [];
  const manifestEntries = [];
  for (const target of DEFAULT_TARGETS) {
    results.push(await buildOne(target, manifestEntries));
  }
  const overrideResults = await copyOverrides(manifestEntries);
  // Manifest: machine-readable list of all prebuilts, used by the
  // runtime loader to wire each one (Bun.plugin for ESM, require.cache
  // for CJS). Path keys are absolute so the loader never resolves a
  // dependency itself.
  await Bun.write(join(OUT_ROOT, "manifest.json"), JSON.stringify(manifestEntries, null, 2) + "\n");
  const elapsedMs = Math.round((Bun.nanoseconds() - t0) / 1_000_000);
  let totalAttempted = 0, totalWritten = 0, totalMatches = 0;
  for (const r of results) {
    totalAttempted += r.attempted;
    totalWritten += r.written;
    totalMatches += r.totalMatches;
    const note = r.skipped ? `  (${r.skipped})` : "";
    process.stderr.write(
      `  ${r.key.padEnd(24)} attempted=${String(r.attempted).padStart(4)}  written=${String(r.written).padStart(3)}  matches=${String(r.totalMatches).padStart(4)}${note}\n`
    );
  }
  if (overrideResults.length > 0) {
    process.stderr.write(`\n  overrides:\n`);
    for (const r of overrideResults) {
      totalWritten += 1;
      process.stderr.write(`    ${r.key.padEnd(22)} ${r.file}\n`);
    }
  }
  process.stderr.write(
    `\n  totals: written=${totalWritten}  pattern-matches=${totalMatches}  in ${elapsedMs}ms\n`
  );
  process.stderr.write(`  output: ${OUT_ROOT}\n`);
}

if (import.meta.main) await main();
