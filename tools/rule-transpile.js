#!/usr/bin/env bun
"use strict";
//
// Build-time rule transpiler.
//
// Bundles eslint core + every supported plugin's rule files into a
// single ESM bundle at `.ez/dist/rules.bundle.js`, applying our
// pattern rewriter (`tools/transforms/patterns.js`) to every rule
// source as an `onLoad` plugin during the build. The runtime loader
// (`js/rule-loader.js`) imports the bundle directly — no Bun.plugin
// onLoad hooks at runtime, no `require.cache` mutations, no per-load
// AST work. Everything is pre-baked.
//
// Output shape (the bundle's exports):
//
//   export const eslint    = { rules: { "no-extra-bind": {create, meta}, ... } };
//   export const unicorn   = { rules: { "no-thenable":   {create, meta}, ... } };
//   export const jsdoc     = { rules: { "check-tag-names": {...}, ... } };
//   ... etc per plugin ...
//
// For each plugin, the bundle imports either the plugin's index (which
// in turn imports each rule and applies the plugin's preferred export
// shape) OR enumerates rule files directly when there's no usable
// plugin index. ESLint core has no "plugin index" so we enumerate.
//
// Usage: bun tools/rule-transpile.js
//
// The build also applies any per-file programmatic transforms found in
// `tools/transforms/files/<key>/<file>.js` — these are functions
// `(upstreamSource) => modifiedSource` that produce upstream-derived
// substitutes by edit, not by checking in a copy of upstream.

import { resolve, basename, dirname, join } from "node:path";
import { readFileSync, statSync, existsSync, mkdirSync } from "node:fs";
import { rewrite as applyPatternRewrite } from "./rule-rewriter-patterns.js";
import { parseSource as _ezParseSource } from "../js/index.js";

const ROOT = resolve(import.meta.dir, "..");
// Output lives under `js/.ez-dist/` so the bundle's externalized
// imports (`@typescript-eslint/utils`, `eslint-visitor-keys`, etc.)
// resolve via Node's normal walk through `js/node_modules/` at
// runtime — same module resolution the rest of the codebase uses.
const OUT_DIR = resolve(ROOT, "js/.ez-dist");
const BUNDLE_OUT = join(OUT_DIR, "rules.bundle.js");

// Each entry: enumerate rule files under `base` matching `glob`. The
// transpiler synthesizes one import per rule into the bundle entry.
//
// `name` is the public plugin name (also the manifest key). `kind`:
//   "core"   — ESLint core; rules live as separate files, no plugin index
//   "plugin" — third-party plugin; bundle imports the plugin index too
//              so configs/meta survive
const TARGETS = [
  {
    name: "eslint",
    kind: "core",
    base: resolve(ROOT, "js/node_modules/eslint/lib/rules"),
    glob: "*.js",
  },
  // Rule-mapping strategy per target:
  //   "files"  — enumerate `base/<glob>` and key by filename. Used when
  //              the plugin's filename matches its canonical rule name
  //              (most plugins do). Avoids importing the plugin index,
  //              which sometimes pulls in unbundleable deps (configs,
  //              `require.resolve()` hops, etc.).
  //   "index"  — import the plugin's npm package and use its `.rules`
  //              map verbatim. Required when filename ≠ rule name
  //              (jsdoc: camelCase files → kebab-case names; sonarjs:
  //              `Sxxx/index.js` → semantic name).
  //
  // `base` + `glob` describe rule files for the rewriter's onLoad
  // filter — the rewriter only transforms files in those paths.
  { name: "unicorn",            mapping: "files", pluginPkg: "eslint-plugin-unicorn",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-unicorn/rules"), glob: "*.js" },
  { name: "react",              mapping: "files", pluginPkg: "eslint-plugin-react",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-react/lib/rules"), glob: "*.js" },
  { name: "promise",            mapping: "files", pluginPkg: "eslint-plugin-promise",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-promise/rules"), glob: "*.js" },
  { name: "import",             mapping: "files", pluginPkg: "eslint-plugin-import",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-import/lib/rules"), glob: "*.js" },
  { name: "n",                  mapping: "files", pluginPkg: "eslint-plugin-n",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-n/lib/rules"), glob: "*.js" },
  { name: "@typescript-eslint", mapping: "files", pluginPkg: "@typescript-eslint/eslint-plugin",
    base: resolve(ROOT, "js/node_modules/@typescript-eslint/eslint-plugin/dist/rules"), glob: "*.js" },
  { name: "es-x",               mapping: "files", pluginPkg: "eslint-plugin-es-x",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-es-x/lib/rules"), glob: "*.js" },
  // jsdoc: filenames are camelCase (`checkTagNames.cjs`) but the
  // plugin maps them to kebab-case rule names (`check-tag-names`).
  { name: "jsdoc",              mapping: "index", pluginPkg: "eslint-plugin-jsdoc",
    base: resolve("/Users/ericsan/node_modules/eslint-plugin-jsdoc/dist/rules"), glob: "*.cjs" },
  // sonarjs: rules live in `Sxxx/index.js`; the plugin index maps
  // them to semantic names (`function-name`, etc.).
  { name: "sonarjs",            mapping: "index", pluginPkg: "eslint-plugin-sonarjs",
    base: resolve(ROOT, "js/node_modules/eslint-plugin-sonarjs/cjs"), glob: "**/*.js" },
];

// Programmatic per-file transforms — functions that take upstream
// source and return modified source. Replaces the old hand-written
// override files in `tools/overrides/` with reproducible scripts.
//
// Each entry maps an absolute upstream path to a transform module
// path; the transform's default export is `(upstreamSrc) => string`.
const FILE_TRANSFORMS_DIR = resolve(ROOT, "tools/transforms/files");

function _safeIdent(s) {
  return s.replace(/[^A-Za-z0-9_]/g, "_");
}

// Public name → safe JS identifier for use as an `export const` name.
// `import` is a reserved word; `@typescript-eslint` has illegal chars.
// Reserved words get a `_` suffix; others get `_safeIdent`.
const _RESERVED = new Set([
  "import", "export", "default", "class", "const", "let", "var",
  "function", "return", "if", "else", "for", "while", "do", "switch",
  "case", "break", "continue", "new", "delete", "void", "typeof",
  "instanceof", "in", "of", "this", "super", "throw", "try", "catch",
  "finally", "yield", "await", "async",
]);
function _exportIdent(name) {
  const id = _safeIdent(name);
  return _RESERVED.has(id) ? `${id}_` : id;
}

async function main() {
  const t0 = Bun.nanoseconds();

  // Enumerate rule files per target so the bundle entry can import them.
  const targetSpecs = [];
  for (const t of TARGETS) {
    if (!existsSync(t.base)) {
      process.stderr.write(`  ${t.name}: missing (${t.base})\n`);
      continue;
    }
    const glob = new Bun.Glob(t.glob);
    const ruleFiles = [];
    for await (const rel of glob.scan({ cwd: t.base, onlyFiles: true })) {
      ruleFiles.push({ rel, abs: join(t.base, rel) });
    }
    // Stable order so the bundle is deterministic across builds.
    ruleFiles.sort((a, b) => a.rel.localeCompare(b.rel));
    targetSpecs.push({ ...t, ruleFiles });
  }

  // Synthesize the bundle entry. Two flavors:
  //
  //   kind: "core" (eslint) — no plugin index, so enumerate rule files
  //     and key by filename. ESLint core uses lowercase-with-dashes
  //     filenames that match the rule names directly.
  //
  //   kind: "plugin" — import the plugin's INDEX module and use its
  //     `.rules` map verbatim. The plugin author owns the canonical
  //     rule-name → rule-module mapping (their index does the rename
  //     from filename `checkTagNames` → name `check-tag-names`).
  //     Bun.build follows the imports and our onLoad hook still fires
  //     for each rule file the index pulls in — so transforms still
  //     apply to every rule.
  const lines = [];
  lines.push("// Generated by tools/rule-transpile.js — do not edit.");
  lines.push("");
  lines.push("function _unwrap(m) { return m && (m.default ?? m); }");
  lines.push("");

  // Per-target wiring.
  for (const t of targetSpecs) {
    const mapping = t.mapping || (t.kind === "core" ? "files" : "files");
    if (mapping === "files") {
      // Enumerate files and import each one directly.
      const entries = [];
      for (const r of t.ruleFiles) {
        const alias = `__r_${_safeIdent(t.name)}_${_safeIdent(r.rel)}`;
        lines.push(`import * as ${alias} from ${JSON.stringify(r.abs)};`);
        const ruleName = basename(r.rel).replace(/\.(?:cjs|mjs|js)$/, "");
        entries.push(`  ${JSON.stringify(ruleName)}: _unwrap(${alias}),`);
      }
      lines.push("");
      lines.push(`const ${_exportIdent(t.name)} = {`);
      lines.push(`  rules: {`);
      lines.push(...entries);
      lines.push(`  },`);
      lines.push(`};`);
      lines.push(`export { ${_exportIdent(t.name)} as ${JSON.stringify(t.name)} };`);
      lines.push("");
    } else if (mapping === "index") {
      // Plugin index: take its `.rules` map verbatim (the plugin author
      // owns the canonical rule-name → rule-module mapping).
      const alias = `__p_${_safeIdent(t.name)}`;
      lines.push(`import * as ${alias} from ${JSON.stringify(t.pluginPkg)};`);
      lines.push(`const ${_exportIdent(t.name)} = (() => { const p = _unwrap(${alias}); return { rules: (p && p.rules) || {} }; })();`);
      lines.push(`export { ${_exportIdent(t.name)} as ${JSON.stringify(t.name)} };`);
      lines.push("");
    }
  }

  // Write the entry file (kept on disk so error traces are useful and
  // it can be inspected during debugging).
  if (!existsSync(OUT_DIR)) mkdirSync(OUT_DIR, { recursive: true });
  const entryPath = join(OUT_DIR, "_rules-entry.js");
  await Bun.write(entryPath, lines.join("\n"));

  // Run the build. The `onLoad` plugin runs the pattern rewriter on
  // every rule file before Bun parses it.
  let totalRewritten = 0;
  let totalRules = 0;
  for (const t of targetSpecs) totalRules += t.ruleFiles.length;

  // Build a Set of upstream paths we should transform — only files
  // that ARE rule files in our targets, not anything else Bun pulls in
  // via transitive imports.
  const ruleFileSet = new Set();
  for (const t of targetSpecs) for (const r of t.ruleFiles) ruleFileSet.add(r.abs);

  // Per-file programmatic transforms (replaces tools/overrides/).
  // Loaded eagerly so build failures surface immediately.
  const fileTransforms = await loadFileTransforms();

  const result = await Bun.build({
    entrypoints: [entryPath],
    outdir: OUT_DIR,
    target: "bun",
    // CJS so the runtime can `require()` it synchronously — `loadCoreRules`
    // and `loadPlugin` are sync APIs in the rest of the codebase.
    format: "cjs",
    naming: "rules.bundle.[ext]",
    // Externalize peer deps that rule files import indirectly.
    // Their resolution stays at runtime via the host's normal module
    // resolution. Bundling them isn't useful (they're large, often
    // platform-specific, and our transforms don't touch them).
    external: [
      "eslint",
      "typescript",
      "jiti",
      "jiti/*",
      "@eslint/*",
      "@typescript-eslint/parser",
      "@typescript-eslint/utils",
      "@typescript-eslint/scope-manager",
      "@typescript-eslint/typescript-estree",
      "ts-api-utils",
      "espree",
      "esquery",
      "eslint-visitor-keys",
      "estraverse",
      "eslint-utils",
      "graphemer",
      "ignore",
      "globby",
      "minimatch",
      "fast-glob",
      "ts-pattern",
      "ramda",
      "fs",
      "path",
      "node:fs",
      "node:path",
      "node:url",
      "node:module",
      "url",
      "module",
      "natural-compare",
      "eslint-rule-composer",
    ],
    plugins: [{
      name: "ez-rule-transpiler",
      setup(b) {
        // Mark helpers + estree-adapter as external so they resolve
        // to the runtime's module instances (which the NAPI binding
        // populates with TAG_NAMES, _typeOverrides, etc. via
        // setTagNames). Without this, the bundle gets its own copy of
        // estree-adapter with TAG_NAMES === null, and every helper
        // comparing buffer-derived strings fails silently.
        b.onResolve({ filter: /rewrite-helpers\.js$|estree-adapter\.js$|tags\.js$/ }, (args) => {
          return { path: args.path, external: true };
        });
        b.onLoad({ filter: /\.(?:js|cjs|mjs)$/ }, async (args) => {
          // Apply transforms in two scopes:
          //   - Rule files (in `ruleFileSet`): generic AST shape
          //     rewrites via `applyPatternRewrite`.
          //   - Files with a registered programmatic transform (e.g.,
          //     unicorn-listeners.js, jsdoccomment): apply the
          //     transform's source-text edits.
          // Either or both can apply. Other modules (helpers, plugin
          // internals pulled in via imports) bundle as-is.
          const isRuleFile = ruleFileSet.has(args.path);
          const fileFn = fileTransforms.get(args.path);
          if (!isRuleFile && !fileFn) return undefined;
          const original = await Bun.file(args.path).text();
          let src = original;
          // No silent fallback. If anything fails — a file-transform
          // throws, the rewriter throws, or the rewriter produces
          // text that doesn't parse — abort the build with a clear
          // error message naming the file. A bundle with silently
          // missing optimizations is worse than no bundle: it ships
          // unverified code that the user thinks was rewritten.
          if (fileFn) {
            try {
              src = fileFn(src);
            } catch (err) {
              process.stderr.write(`\n[FATAL] file-transform threw for ${args.path}\n  ${err.stack || err.message}\n`);
              process.exit(1);
            }
          }
          if (isRuleFile) {
            let r;
            try {
              r = applyPatternRewrite(src);
            } catch (err) {
              process.stderr.write(`\n[FATAL] pattern-rewriter threw for ${args.path}\n  ${err.stack || err.message}\n`);
              process.exit(1);
            }
            // Validate the rewriter's output by re-parsing. A buggy
            // detector or emitter that produces malformed source
            // would otherwise fail much later inside Bun.build with a
            // line number from the post-transform source — confusing
            // to debug. Catch it here with the upstream path.
            try {
              _ezParseSource(r.src, { filename: args.path });
            } catch (parseErr) {
              process.stderr.write(`\n[FATAL] rewriter produced invalid JS for ${args.path}\n  parse error: ${parseErr.message || parseErr}\n  attempted matches: ${r.matches}\n`);
              process.exit(1);
            }
            src = r.src;
            totalRewritten += r.matches;
          }
          return { contents: src };
        });
      },
    }],
  });

  if (!result.success) {
    process.stderr.write(`\n[FATAL] Bun.build failed with ${result.logs.length} log entr${result.logs.length === 1 ? "y" : "ies"}:\n`);
    for (const l of result.logs) {
      // Each log is a BuildMessage — has level, message, position.
      const lvl = l.level || "error";
      const msg = l.message || String(l);
      const pos = l.position ? ` at ${l.position.file ?? "?"}:${l.position.line ?? "?"}:${l.position.column ?? "?"}` : "";
      process.stderr.write(`  [${lvl}] ${msg}${pos}\n`);
      // Excerpt the offending line if available.
      if (l.position && l.position.lineText) {
        process.stderr.write(`         > ${l.position.lineText}\n`);
      }
    }
    process.stderr.write(`\nNo silent fallback — fix the offending transform or rewriter and re-run.\n`);
    process.exit(1);
  }

  const elapsedMs = Math.round((Bun.nanoseconds() - t0) / 1_000_000);
  const bundleSize = (await Bun.file(BUNDLE_OUT).size) || 0;
  process.stderr.write(`\n  bundle:    ${BUNDLE_OUT}\n`);
  process.stderr.write(`  size:      ${(bundleSize / 1024).toFixed(0)} KB\n`);
  process.stderr.write(`  rules:     ${totalRules}\n`);
  process.stderr.write(`  rewrites:  ${totalRewritten}\n`);
  process.stderr.write(`  elapsed:   ${elapsedMs}ms\n`);
}

async function loadFileTransforms() {
  const map = new Map(); // upstream-path → transform-fn
  if (!existsSync(FILE_TRANSFORMS_DIR)) return map;
  // Each transform module exports `{ upstreamPath, transform }`.
  const fsp = await import("node:fs/promises");
  const entries = await fsp.readdir(FILE_TRANSFORMS_DIR, { withFileTypes: true });
  for (const e of entries) {
    if (e.isDirectory()) continue;
    if (!e.name.endsWith(".js") && !e.name.endsWith(".mjs")) continue;
    const modPath = join(FILE_TRANSFORMS_DIR, e.name);
    const mod = await import(modPath);
    const u = mod.upstreamPath;
    const fn = mod.transform;
    if (typeof u === "string" && typeof fn === "function") {
      map.set(u, fn);
    } else {
      process.stderr.write(`  bad transform shape: ${modPath}\n`);
    }
  }
  return map;
}

if (import.meta.main) await main();
