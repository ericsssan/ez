"use strict";
//
// Runtime loader for build-time module substitutions.
//
// At startup, enumerate `.ez/rules-rewritten-patterns/<plugin>/<file>`
// produced by `tools/build-pattern-rewrites.js` and register a
// Bun.plugin onLoad hook with a precise filter that matches ONLY paths
// we have prebuilds for. When `require()` / `import` resolves a
// matching module, we serve the prebuilt bytes; module identity (path,
// stack frames, source-map origin) is preserved by Bun.
//
// There is no in-process AST transform, no runtime mutation of cached
// module exports, and no pass-through path. Stale build = stale rules,
// not a runtime mystery — re-run the build to refresh.
//
// Two flavors of substitution funnel through this same loader:
//
//   1. Pattern-rewritten rule sources (per-shape AST detector + emit;
//      `tools/rule-rewriter-patterns.js`). Output dir keyed by plugin
//      name.
//   2. Override substitutes — third-party modules whose source has a
//      build-time-injected line wiring our native helper into the
//      upstream `module.exports` (e.g. `eslint-utils/ast-utils.js`
//      appends `require("...native-ast-utils").wrapAstUtils(module.exports)`).
//      The substitute file is upstream source plus a footer; the wiring
//      is module-local, no startup mutation, and falls back gracefully
//      if upstream renamed/removed the targeted export.

const path = require("node:path");

if (typeof Bun !== "undefined" && Bun.plugin && process.env.EZ_DISABLE_PATTERN_REWRITE !== "1") {
  const fs = require("node:fs");
  const _patternsDir = path.join(__dirname, "..", ".ez", "rules-rewritten-patterns");

  // Plugin-key → path-fragment regex. Tested longest-prefix first so
  // eslint-plugin-react-hooks doesn't fall into the eslint-plugin-react
  // bucket. `eslint-utils` is a separate bucket from `eslint` because
  // `lib/rules/utils/` is a subdirectory of `lib/rules/` and would
  // otherwise be ambiguous in the filter.
  const _LAYOUT_FOR_PLUGIN = {
    "unicorn-rule":        /[\\/]eslint-plugin-unicorn[\\/]rules[\\/]rule[\\/]/,
    unicorn:               /[\\/]eslint-plugin-unicorn[\\/]rules[\\/]/,
    react:                 /[\\/]eslint-plugin-react[\\/]lib[\\/]rules[\\/]/,
    promise:               /[\\/]eslint-plugin-promise[\\/]rules[\\/]/,
    import:                /[\\/]eslint-plugin-import[\\/]lib[\\/]rules[\\/]/,
    n:                     /[\\/]eslint-plugin-n[\\/]lib[\\/]rules[\\/]/,
    jsdoc:                 /[\\/]eslint-plugin-jsdoc[\\/]dist[\\/]/,
    "@typescript-eslint":  /[\\/]@typescript-eslint[\\/]eslint-plugin[\\/]dist[\\/]rules[\\/]/,
    "eslint-utils":        /[\\/]eslint[\\/]lib[\\/]rules[\\/]utils[\\/]/,
    eslint:                /[\\/]eslint[\\/]lib[\\/]rules[\\/]/,
  };

  const _PREBUILT_BY_KEY = new Map();
  const _filterAlternation = [];
  if (fs.existsSync(_patternsDir)) {
    const escape = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    for (const plugin of fs.readdirSync(_patternsDir)) {
      const layout = _LAYOUT_FOR_PLUGIN[plugin];
      if (!layout) continue;
      const dir = path.join(_patternsDir, plugin);
      for (const file of fs.readdirSync(dir)) {
        if (!file.endsWith(".js") && !file.endsWith(".cjs") && !file.endsWith(".mjs")) continue;
        const prebuiltPath = path.join(dir, file);
        _PREBUILT_BY_KEY.set(`${plugin}:${file}`, { plugin, file, layout, prebuiltPath });
        _filterAlternation.push(layout.source + escape(file) + "$");
      }
    }
  }

  let _hits = 0;

  if (_filterAlternation.length > 0) {
    const filter = new RegExp(_filterAlternation.join("|"));

    Bun.plugin({
      name: "ez-pattern-rewriter",
      setup(build) {
        build.onLoad({ filter }, (args) => {
          for (const v of _PREBUILT_BY_KEY.values()) {
            if (path.basename(args.path) !== v.file) continue;
            if (!v.layout.test(args.path)) continue;
            _hits++;
            if (process.env.EZ_TRACE_OVERRIDES === "1") {
              process.stderr.write(`[ez:pattern-rewriter] prebuilt ${v.plugin}/${v.file}\n`);
            }
            return { contents: fs.readFileSync(v.prebuiltPath, "utf8") };
          }
          return { contents: fs.readFileSync(args.path, "utf8") };
        });
      },
    });
  }

  globalThis.__ez_patternRewriteHits = () => _hits;
}

module.exports = {
  _patternRewriteHits: () => globalThis.__ez_patternRewriteHits ? globalThis.__ez_patternRewriteHits() : 0,
};
