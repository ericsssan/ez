"use strict";
/**
 * Shared plugin-loading logic used by both lint.js (main thread) and
 * lint-worker.js (worker threads).
 */

const fs = require("fs");
const path = require("path");

/**
 * Resolve a package name to its directory, searching cwd first.
 */
function resolvePackageDir(pkgName) {
  const searchPaths = [
    path.join(process.cwd(), "node_modules"),
    path.join(path.dirname(__filename), "node_modules"),
  ];
  for (const base of searchPaths) {
    const p = path.join(base, pkgName);
    if (fs.existsSync(p)) return p;
  }
  return null;
}

// Code-path rules that crash with our lightweight CodePathTracker.
// These need full CFG (forking, merging, loop detection) that we don't implement yet.
const _NEEDS_CODE_PATH = new Set([
  "complexity",               // accesses codePath.origin and deep segment graph
  "no-invalid-this",          // accesses codePath properties we don't populate
  "no-fallthrough",           // needs switch case segment merging
  "no-unreachable-loop",      // needs onCodePathSegmentLoop (loop back-edge event)
]);

/**
 * Load an ESLint plugin package and return an array of plugin objects
 * compatible with runPlugins: [{ meta: { name }, create }]
 *
 * @param {string} pkgName
 * @param {Set<string>} ruleFilters  empty = load all rules
 * @returns {{ meta: object, create: Function }[]}
 * @throws on unresolvable package
 */
function loadPlugin(pkgName, ruleFilters) {
  const resolveOpts = {
    paths: [process.cwd(), path.join(path.dirname(__filename), "node_modules"), path.dirname(__filename)],
  };

  // ── ESLint core: scan lib/rules/*.js ────────────────────────
  // ESLint v10 added package exports that block subpath requires.
  // We resolve the package root via its main entry and navigate from there.
  if (pkgName === "eslint") {
    const eslintMain = require.resolve("eslint", resolveOpts);
    const rulesDir = path.join(path.dirname(eslintMain), "..", "lib", "rules");
    const plugins = [];
    for (const file of fs.readdirSync(rulesDir)) {
      if (!file.endsWith(".js")) continue;
      const ruleName = file.slice(0, -3);
      if (ruleFilters.size > 0 && !ruleFilters.has(ruleName) && !ruleFilters.has(`eslint/${ruleName}`)) continue;
      try {
        const rule = require(path.join(rulesDir, file));
        if (typeof rule.create !== "function") continue;
        // Skip deprecated rules unless explicitly requested.
        if (rule.meta?.deprecated && ruleFilters.size === 0) continue;
        // Skip rules that require code path analysis (not yet implemented).
        // These produce false positives with FAKE_CODE_PATH and should not
        // run until real code path analysis is added.
        if (_NEEDS_CODE_PATH.has(ruleName) && ruleFilters.size === 0) continue;
        plugins.push({
          meta: { name: ruleName, defaultOptions: rule.meta?.defaultOptions, schema: rule.meta?.schema, messages: rule.meta?.messages },
          create: rule.create,
        });
      } catch { /* skip broken rules */ }
    }
    return plugins;
  }

  // ── Standard ESLint plugin ───────────────────────────────────
  let pkg;
  try {
    const resolved = require.resolve(pkgName, resolveOpts);
    pkg = require(resolved);
  } catch {
    pkg = require(pkgName);
  }

  const rules = pkg.rules || pkg.default?.rules || {};
  const plugins = [];

  for (const [ruleName, rule] of Object.entries(rules)) {
    const create = rule.create || rule;
    if (typeof create !== "function") continue;
    const fullName = `${pkgName}/${ruleName}`;
    if (ruleFilters.size > 0 && !ruleFilters.has(ruleName) && !ruleFilters.has(fullName)) continue;
    plugins.push({
      meta: { name: fullName, defaultOptions: rule.meta?.defaultOptions, schema: rule.meta?.schema },
      create,
    });
  }

  return plugins;
}

module.exports = { loadPlugin, resolvePackageDir };
