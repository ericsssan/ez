"use strict";
/**
 * Rule loading — core rules + third-party ESLint plugins.
 */

const fs = require("fs");
const path = require("path");

const BUNDLED_RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");

// ── Core rules ───────────────────────────────────────────────

/**
 * Load bundled core rules (shipped with ez).
 * Returns array of { meta: { name, ... }, create } descriptors.
 *
 * @param {object} [opts]
 * @param {Set<string>} [opts.only]  If provided, load only these rule names
 * @param {boolean} [opts.includeDeprecated]  Include deprecated rules (default: false)
 * @returns {{ meta: object, create: Function }[]}
 */
function loadCoreRules(opts = {}) {
  const { only, includeDeprecated = false } = opts;
  const rulesDir = BUNDLED_RULES_DIR;
  if (!fs.existsSync(rulesDir)) {
    throw new Error("ez: eslint rules not found at " + rulesDir + " — run `npm install` in js/");
  }
  const rules = [];
  for (const file of fs.readdirSync(rulesDir)) {
    if (!file.endsWith(".js") || file === "index.js") continue;
    const name = file.slice(0, -3);
    if (only && !only.has(name)) continue;
    try {
      const mod = require(path.join(rulesDir, file));
      if (typeof mod.create !== "function") continue;
      if (mod.meta?.deprecated && !includeDeprecated && !(only && only.has(name))) continue;
      rules.push({
        meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema, messages: mod.meta?.messages, fixable: mod.meta?.fixable },
        create: mod.create,
      });
    } catch { /* skip broken rules */ }
  }
  return rules;
}

// ── Third-party plugins ──────────────────────────────────────

/**
 * Load a third-party ESLint plugin package.
 * Returns array of { meta: { name }, create } descriptors.
 *
 * @param {string} pkgName  e.g. "eslint-plugin-react"
 * @param {object} [opts]
 * @param {Set<string>} [opts.only]  If provided, load only these rule names
 * @returns {{ meta: object, create: Function }[]}
 */
function loadPlugin(pkgName, opts = {}) {
  const { only } = opts;
  const resolveOpts = {
    paths: [process.cwd(), path.join(__dirname, "node_modules"), __dirname],
  };

  let pkg;
  try {
    pkg = require(require.resolve(pkgName, resolveOpts));
  } catch {
    pkg = require(pkgName);
  }

  const rulesMap = pkg.rules || pkg.default?.rules || {};
  const rules = [];
  for (const [ruleName, rule] of Object.entries(rulesMap)) {
    const create = rule.create || rule;
    if (typeof create !== "function") continue;
    const fullName = `${pkgName}/${ruleName}`;
    if (only && !only.has(ruleName) && !only.has(fullName)) continue;
    rules.push({
      meta: { name: fullName, defaultOptions: rule.meta?.defaultOptions, schema: rule.meta?.schema, messages: rule.meta?.messages, fixable: rule.meta?.fixable },
      create,
    });
  }
  return rules;
}

module.exports = { loadCoreRules, loadPlugin };
