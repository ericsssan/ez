"use strict";
/**
 * Rule loading — core rules + third-party ESLint plugins.
 */

const fs = require("fs");
const path = require("path");

// Install load-time overrides for hot helpers in libraries that ESLint rules
// depend on (currently: ast-utils.getStaticPropertyName). Must run BEFORE any
// rule is `require()`'d, since rules destructure helper names at top level
// and capture references at that moment. Side-effecting import; no exports.
require("./lib-overrides");

const BUNDLED_RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");

// Rewritten rule sources live under .ez/rules-rewritten/<plugin-key>/<rule>.js.
// Produced by tools/rule-rewriter.js for rules whose metadata marks them as
// shared-handlers-via-rewrite. Loading the rewritten version gives the rule a
// Tier A shape (no capture), so the dispatcher's shared-handlers short-circuit
// activates with zero runtime overhead.
const REWRITE_DIR = path.resolve(process.cwd(), ".ez/rules-rewritten");

function rewrittenPath(pluginKey, ruleName) {
  if (!fs.existsSync(REWRITE_DIR)) return null;
  // Try common file extensions that analyzer+rewriter preserved (.js, .cjs, .mjs).
  for (const ext of [".js", ".cjs", ".mjs"]) {
    const p = path.join(REWRITE_DIR, pluginKey, ruleName + ext);
    if (fs.existsSync(p)) return p;
  }
  return null;
}

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
  let rewriteCount = 0;
  for (const file of fs.readdirSync(rulesDir)) {
    if (!file.endsWith(".js") || file === "index.js") continue;
    const name = file.slice(0, -3);
    if (only && !only.has(name)) continue;
    try {
      // Prefer rewritten source if available — gives Tier A shape.
      const rw = rewrittenPath("eslint", name);
      const mod = require(rw || path.join(rulesDir, file));
      if (typeof mod.create !== "function") continue;
      if (mod.meta?.deprecated && !includeDeprecated && !(only && only.has(name))) continue;
      if (rw) rewriteCount++;
      rules.push({
        meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema, messages: mod.meta?.messages, fixable: mod.meta?.fixable },
        create: mod.create,
      });
    } catch { /* skip broken rules */ }
  }
  if (process.env.EZ_DEBUG_STRATEGY === "1" && rewriteCount > 0) {
    process.stderr.write(`[ez:rewrite] loaded ${rewriteCount} rewritten core rules\n`);
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
