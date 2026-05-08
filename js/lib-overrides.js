"use strict";
//
// Runtime loader for build-time module substitutions.
//
// Reads `.ez/rules-rewritten-patterns/manifest.json` produced by
// `tools/build-pattern-rewrites.js`. Each manifest entry names a
// prebuilt substitute file, the upstream module path it replaces, and
// the upstream package's module type (esm | cjs).
//
// Two routes, picked per-entry by `module`:
//
//   esm  →  Bun.plugin onLoad. The filter regex matches the upstream
//           path; onLoad returns the prebuilt's bytes. Bun parses them
//           as ESM (its only supported mode for `{ contents }`
//           returns in 1.3.9), which is correct for ESM packages.
//
//   cjs  →  require.cache install. We `require()` the prebuilt
//           directly (file extension or upstream package.json gives it
//           CJS semantics on disk), then place the resulting
//           `module.exports` into `require.cache[upstreamPath]`. Any
//           subsequent `require(upstreamPath)` from rule code returns
//           the substitute. ESM `import` and dynamic `import()` bypass
//           require.cache, so this only affects CJS callers — exactly
//           the code in CJS plugins that we want to redirect.
//
// Why two mechanisms: Bun.plugin's onLoad with `{ contents }` always
// parses as ESM in 1.3.9. CJS modules served through Bun.plugin return
// empty `module.exports`. Until that's fixed, ESM uses Bun.plugin (the
// only path that works for ESM `import` resolution) and CJS uses
// require.cache (the only path that works for CJS `require()`).
// Manifest-driven so the build is the single source of truth.

const path = require("node:path");
const fs = require("node:fs");
const Module = require("node:module");

const _patternsDir = path.join(__dirname, "..", ".ez", "rules-rewritten-patterns");
const _manifestPath = path.join(_patternsDir, "manifest.json");

let _bunPluginHits = 0;
let _cjsCacheHits = 0;

function _readManifest() {
  if (!fs.existsSync(_manifestPath)) return [];
  try {
    return JSON.parse(fs.readFileSync(_manifestPath, "utf8"));
  } catch {
    return [];
  }
}

function _installCjsSubstitutes(entries) {
  // Pre-load each substitute and stash its exports under the upstream
  // path's cache slot. The substitute lives on disk at the prebuilt
  // location, but its source has relative `require("./...")` calls
  // that need to resolve from the UPSTREAM directory (where the
  // sibling files actually exist). We compile the bytes as a Module
  // whose filename is the upstream path, so Node's resolver looks for
  // siblings next to the original — same way the upstream module
  // would have resolved them.
  for (const e of entries) {
    if (e.module !== "cjs") continue;
    const prebuiltPath = path.join(_patternsDir, e.key, e.file);
    if (!fs.existsSync(prebuiltPath)) continue;
    let upstreamResolved;
    try {
      upstreamResolved = require.resolve(e.upstreamPath);
    } catch {
      continue;
    }
    let subExports;
    try {
      const code = fs.readFileSync(prebuiltPath, "utf8");
      const m = new Module(upstreamResolved, module);
      m.filename = upstreamResolved;
      m.paths = Module._nodeModulePaths(path.dirname(upstreamResolved));
      m._compile(code, upstreamResolved);
      subExports = m.exports;
    } catch (err) {
      if (process.env.EZ_TRACE_OVERRIDES === "1") {
        process.stderr.write(`[ez:rewriter] cjs prebuilt failed to load: ${e.key}/${e.file}: ${err.message}\n`);
      }
      continue;
    }
    require.cache[upstreamResolved] = {
      id: upstreamResolved,
      filename: upstreamResolved,
      loaded: true,
      exports: subExports,
      children: [],
      paths: [],
    };
    _cjsCacheHits++;
    if (process.env.EZ_TRACE_OVERRIDES === "1") {
      process.stderr.write(`[ez:rewriter] cjs cache install ${e.key}/${e.file}\n`);
    }
  }
}

function _registerBunPluginEsmSubstitutes(entries) {
  if (typeof Bun === "undefined" || !Bun.plugin) return;
  const esmEntries = entries.filter(e => e.module === "esm");
  if (esmEntries.length === 0) return;
  // Build a precise filter regex from the absolute upstream paths so
  // the onLoad hook only fires for paths we have prebuilts for. No
  // pass-through case — every match has a substitute on disk.
  const escape = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const filter = new RegExp(esmEntries.map(e => escape(e.upstreamPath) + "$").join("|"));
  // Map from absolute path → substitute path so the onLoad callback
  // can answer in O(1) without re-scanning.
  const byPath = new Map();
  for (const e of esmEntries) {
    byPath.set(e.upstreamPath, path.join(_patternsDir, e.key, e.file));
  }
  Bun.plugin({
    name: "ez-pattern-rewriter",
    setup(build) {
      build.onLoad({ filter }, (args) => {
        const sub = byPath.get(args.path);
        if (!sub) return { contents: fs.readFileSync(args.path, "utf8") };
        _bunPluginHits++;
        if (process.env.EZ_TRACE_OVERRIDES === "1") {
          process.stderr.write(`[ez:rewriter] esm bun.plugin ${path.basename(args.path)}\n`);
        }
        return { contents: fs.readFileSync(sub, "utf8") };
      });
    },
  });
}

if (process.env.EZ_DISABLE_PATTERN_REWRITE !== "1") {
  const entries = _readManifest();
  if (entries.length > 0) {
    _installCjsSubstitutes(entries);
    _registerBunPluginEsmSubstitutes(entries);
  }
}

module.exports = {
  _patternRewriteHits: () => _bunPluginHits + _cjsCacheHits,
  _bunPluginHits: () => _bunPluginHits,
  _cjsCacheHits: () => _cjsCacheHits,
};
