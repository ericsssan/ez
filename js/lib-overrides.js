"use strict";
//
// Load-time swap of selected helpers from libraries that ESLint rules depend on.
// Re-implements hot paths using ez's native primitives (direct buffer reads,
// numeric tag compares) rather than going through ESTree-shaped property
// getters. The swap is a feasibility prototype — a JS-side demonstration that
// (a) the require-cache patch reaches every consumer of the helper,
// (b) the re-implementation is observably equivalent on the differential corpus,
// (c) future Zig-backed implementations only need to slot a NAPI call into the
//     same JS shim — the swap mechanism itself is unchanged.
//
// Loaded once at startup before any rule's `require()` resolves the helper
// module. Subsequent `require('eslint/lib/rules/utils/ast-utils')` returns the
// same exports object with our overrides in place; rules that destructure
// `const { getStaticPropertyName } = require(...)` capture the patched
// reference at top-level evaluation time.

const path = require("node:path");
const T = require("./tags").T;

// Helper-tag bitsets. AoS Set<number>.has() is fast and IC-friendly.
const _MEMBER_EXPR_TAGS = new Set([
  T.member_expr, T.computed_member_expr,
  T.optional_member_expr, T.optional_computed_member_expr,
]);
const _MEMBER_EXPR_COMPUTED_TAGS = new Set([
  T.computed_member_expr, T.optional_computed_member_expr,
]);
// Property-like nodes whose `key` is at lhs in the ez buffer. The `computed`
// flag is implicit in the tag (computed_* variants).
const _PROPERTY_KEY_LHS_TAGS = new Set([
  T.property, T.shorthand_property, T.computed_property,
  T.method_def, T.computed_method_def,
  T.getter_def, T.computed_getter_def,
  T.setter_def, T.computed_setter_def,
  T.constructor_def,
  T.ts_property_signature, T.ts_method_signature,
]);
const _PROPERTY_LIKE_COMPUTED_TAGS = new Set([
  T.computed_property, T.computed_method_def,
  T.computed_getter_def, T.computed_setter_def,
]);

const NONE = 0xFFFFFFFF;

// Resolve and warm the require cache. Subsequent `require(samePath)` returns
// the already-loaded `module.exports` object — patches we apply now propagate
// to every later consumer (including those that destructure at top level).
const _astUtilsPath = require.resolve(
  path.join(__dirname, "node_modules/eslint/lib/rules/utils/ast-utils")
);
const astUtils = require(_astUtilsPath);

// Save originals for fallback paths and for benches that compare delta.
const _origGetStaticPropertyName = astUtils.getStaticPropertyName;
const _origGetStaticStringValue  = astUtils.getStaticStringValue;

// Native re-implementation of `getStaticPropertyName`.
//
// Original (eslint/lib/rules/utils/ast-utils.js:304) walks ESTree node types
// via string compares: `node.type === "MemberExpression"`, etc. Our version
// reads the ez tag (a u8) and compares numerically — same observable result,
// fewer property-getter hops.
//
// Falls back to the original implementation for nodes without an ez `_ast`
// (synthetic wrappers like JSXOpeningElement) or with tags we don't yet
// special-case. Correctness is gated by the differential corpus.
function _ezGetStaticPropertyName(node) {
  if (!node) return null;
  const ast = node._ast;
  if (!ast || node._i === undefined) return _origGetStaticPropertyName(node);

  const tags = ast._nodeTags;
  const tag = tags[node._i];

  // Resolve the property/key node index in one tag-bucket lookup.
  let propIdx, computed;
  if (_MEMBER_EXPR_TAGS.has(tag)) {
    propIdx = ast.nodeRhs(node._i);                    // .property is rhs
    computed = _MEMBER_EXPR_COMPUTED_TAGS.has(tag);
  } else if (_PROPERTY_KEY_LHS_TAGS.has(tag)) {
    propIdx = ast.nodeLhs(node._i);                    // .key is lhs
    computed = _PROPERTY_LIKE_COMPUTED_TAGS.has(tag);
  } else {
    // ChainExpression, unknown shapes, synthetic nodes — original handles them.
    return _origGetStaticPropertyName(node);
  }

  if (propIdx === NONE) return null;

  const propTag = tags[propIdx];
  // Most common case (~90%+ of calls): plain identifier in non-computed
  // position. ESTree exposes both `T.identifier` (variable/binding refs)
  // and `T.property_ident` (member-access property names) as `Identifier`;
  // we must accept both here. Read source text via the lex helper.
  if ((propTag === T.identifier || propTag === T.property_ident) && !computed) {
    return ast._identAt(ast._mainTokens[propIdx]);
  }

  // Fall back to the original `getStaticStringValue` for the long tail —
  // string/number/bigint literals, template literals, unary-minus literals,
  // null/true/false. Re-implementing all of those in JS would just be a
  // mechanical port; the speedup vs the original is already captured by
  // the identifier-path above (the dominant case in real codebases).
  // Wrap the prop index in a NodeView so the original receives the
  // ESTree-shaped input it expects.
  const propNode = _nodeView(ast, propIdx);
  return _origGetStaticStringValue(propNode);
}

// Lazy-import nodeView via estree-adapter to avoid a circular require at
// module load. Resolved on first call.
let _nodeView = null;
{
  const { nodeView } = require("./estree-adapter");
  _nodeView = nodeView;
}

// Install. The override survives across `require(...)` calls because CJS
// caches the exports object by resolved path; our mutation is on the
// shared instance. Verified by the differential corpus.
astUtils.getStaticPropertyName = _ezGetStaticPropertyName;

// Diagnostic counters — exposed for bench / sanity checks. Not needed in
// production. EZ_TRACE_OVERRIDES=1 enables a one-shot stderr line on first
// call so smoke tests can confirm the swap took effect.
let _hits = 0;
if (process.env.EZ_TRACE_OVERRIDES === "1") {
  const wrapped = astUtils.getStaticPropertyName;
  astUtils.getStaticPropertyName = function (node) {
    if (++_hits === 1) {
      process.stderr.write("[ez:lib-overrides] getStaticPropertyName intercepted\n");
    }
    return wrapped(node);
  };
}

// ─── Bun.plugin: serve pre-built pattern-rewritten rule sources ────
//
// Plugin rule files load via `require()` from inside the plugin's
// package — they don't go through `loadCoreRules`, so the static
// `.ez/rules-rewritten/` redirect can't reach them. Bun.plugin's
// `onLoad` lets us substitute source at load time.
//
// Substitution is purely a redirect to a pre-built rewrite at
// `.ez/rules-rewritten-patterns/<plugin-key>/<rule>.js` (produced
// offline by `bun tools/build-pattern-rewrites.js`). No in-process
// transform: if the pre-built file is missing, we fall through and
// Bun loads the original source unmodified. Stale build = stale rules,
// not a runtime mystery — re-run the build to refresh.

if (typeof Bun !== "undefined" && Bun.plugin && process.env.EZ_DISABLE_PATTERN_REWRITE !== "1") {
  const fs = require("node:fs");
  const _patternsDir = path.join(__dirname, "..", ".ez", "rules-rewritten-patterns");

  // Plugin-key → path-fragment regex. Tested longest-prefix first so
  // eslint-plugin-react-hooks doesn't fall into the eslint-plugin-react
  // bucket.
  const _LAYOUT_FOR_PLUGIN = {
    unicorn:               /[\\/]eslint-plugin-unicorn[\\/]rules[\\/]/,
    react:                 /[\\/]eslint-plugin-react[\\/]lib[\\/]rules[\\/]/,
    promise:               /[\\/]eslint-plugin-promise[\\/]rules[\\/]/,
    import:                /[\\/]eslint-plugin-import[\\/]lib[\\/]rules[\\/]/,
    n:                     /[\\/]eslint-plugin-n[\\/]lib[\\/]rules[\\/]/,
    jsdoc:                 /[\\/]eslint-plugin-jsdoc[\\/]dist[\\/]/,
    "@typescript-eslint":  /[\\/]@typescript-eslint[\\/]eslint-plugin[\\/]dist[\\/]rules[\\/]/,
    eslint:                /[\\/]eslint[\\/]lib[\\/]rules[\\/]/,
  };

  // Enumerate prebuilt rewrites at startup. The filter regex is built to
  // match ONLY paths we'll actually substitute (layout + exact filename).
  // This avoids the bug where a broad filter + "return original contents
  // for unrecognized paths" pass-through corrupted module identity in
  // Bun 1.3.9 — symptom was rules silently dropping ~60% of diagnostics
  // on typescript.js, traced via comparison with ESLint's native diag
  // output (parity confirmed when filter is tight).
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
          // The filter ensures we only see paths we have prebuilds for.
          // Find which one and return its contents.
          for (const v of _PREBUILT_BY_KEY.values()) {
            if (path.basename(args.path) !== v.file) continue;
            if (!v.layout.test(args.path)) continue;
            _hits++;
            if (process.env.EZ_TRACE_OVERRIDES === "1") {
              process.stderr.write(`[ez:pattern-rewriter] prebuilt ${v.plugin}/${v.file}\n`);
            }
            return { contents: fs.readFileSync(v.prebuiltPath, "utf8") };
          }
          // Filter matched but no entry — shouldn't happen with the
          // exact filename match. Defensive: return the original.
          return { contents: fs.readFileSync(args.path, "utf8") };
        });
      },
    });
  }

  globalThis.__ez_patternRewriteHits = () => _hits;
}

module.exports = {
  _interceptCount: () => _hits,
  _origGetStaticPropertyName,
  _patternRewriteHits: () => globalThis.__ez_patternRewriteHits ? globalThis.__ez_patternRewriteHits() : 0,
};
