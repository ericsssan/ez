"use strict";
//
// Runtime rule loader.
//
// All source transformation happens at build time
// (`tools/rule-transpile.js` produces `js/.ez-dist/rules.bundle.js`
// using `Bun.build` with our pattern rewriter as an `onLoad` plugin).
// At runtime this loader does nothing more than `require()` the
// pre-bundled file and expose `{ ruleName: ruleObject }` per plugin.
//
// No `Bun.plugin` onLoad hooks. No `require.cache` mutations. No AST
// parsing. No runtime rewriting. The bundle is parsed and compiled by
// V8/JSC the same way any other JS module is.

const path = require("node:path");
const fs = require("node:fs");

const BUNDLE_PATH = path.join(__dirname, ".ez-dist", "rules.bundle.js");

let _cached = null;

/**
 * Load (or return cached) bundle. Returns the namespace object whose
 * keys are plugin names (e.g. "eslint", "unicorn", "@typescript-eslint")
 * and whose values are `{ rules: { [ruleName]: ruleModule } }`.
 *
 * If the bundle is missing, returns null — callers fall back to
 * traditional dynamic-require resolution. Building the bundle is part
 * of the dev/release workflow (`bun tools/rule-transpile.js`).
 */
function _loadBundle() {
  if (_cached !== null) return _cached;
  if (!fs.existsSync(BUNDLE_PATH)) return _cached = false;
  _cached = require(BUNDLE_PATH);
  return _cached;
}

/**
 * Map an ESLint plugin package name to its key inside the bundle.
 * Returns null if the package isn't in the bundle (caller falls back
 * to dynamic require).
 */
function _bundleKey(pkgName) {
  if (pkgName === "eslint") return "eslint";
  if (pkgName === "@typescript-eslint/eslint-plugin") return "@typescript-eslint";
  // Strip the `eslint-plugin-` prefix.
  if (pkgName.startsWith("eslint-plugin-")) return pkgName.slice("eslint-plugin-".length);
  return null;
}

function bundleHas(pkgName) {
  const b = _loadBundle();
  if (!b) return false;
  const key = _bundleKey(pkgName);
  return key !== null && !!b[key];
}

function bundleRulesFor(pkgName) {
  const b = _loadBundle();
  if (!b) return null;
  const key = _bundleKey(pkgName);
  if (!key) return null;
  return b[key]?.rules || null;
}

module.exports = {
  bundleHas,
  bundleRulesFor,
};
