"use strict";
//
// Plugin loading: rule descriptors for ESLint core + third-party plugins.
//
// Backed by the build-time rule bundle (`js/.ez-dist/rules.bundle.js`)
// when present. The bundle is produced by `tools/rule-transpile.js` —
// which runs our pattern rewriter as a `Bun.build` `onLoad` plugin
// over every rule source. At runtime there's no per-load hook and no
// AST work; this file just shapes the bundled rule modules into the
// `{ meta: { name, ... }, create }` descriptors the rest of the
// codebase expects.
//
// If the bundle isn't present (development without a build, or a
// plugin not configured in the bundle), falls back to traditional
// dynamic `require()` resolution.

const fs = require("fs");
const path = require("path");

const { bundleHas, bundleRulesFor } = require("./rule-loader");

const BUNDLED_RULES_DIR = path.join(__dirname, "node_modules/eslint/lib/rules");

function _toDescriptor(name, ruleModule) {
  if (!ruleModule || typeof ruleModule !== "object") return null;
  const create = typeof ruleModule.create === "function" ? ruleModule.create : ruleModule;
  if (typeof create !== "function") return null;
  const meta = ruleModule.meta || {};
  return {
    meta: {
      name,
      defaultOptions: meta.defaultOptions,
      schema: meta.schema,
      messages: meta.messages,
      fixable: meta.fixable,
      deprecated: meta.deprecated,
    },
    create,
  };
}

// ── Core rules ───────────────────────────────────────────────

/**
 * Load bundled core rules.
 *
 * @param {object} [opts]
 * @param {Set<string>} [opts.only]
 * @param {boolean} [opts.includeDeprecated]
 * @returns {{ meta: object, create: Function }[]}
 */
function loadCoreRules(opts = {}) {
  const { only, includeDeprecated = false } = opts;
  const fromBundle = bundleRulesFor("eslint");
  if (fromBundle) {
    const rules = [];
    for (const [name, mod] of Object.entries(fromBundle)) {
      if (only && !only.has(name)) continue;
      const desc = _toDescriptor(name, mod);
      if (!desc) continue;
      if (desc.meta.deprecated && !includeDeprecated && !(only && only.has(name))) continue;
      rules.push(desc);
    }
    return rules;
  }
  // Fallback: dynamic require from upstream rules dir.
  if (!fs.existsSync(BUNDLED_RULES_DIR)) {
    throw new Error("ez: eslint rules not found at " + BUNDLED_RULES_DIR + " — run `npm install` in js/ or `bun tools/rule-transpile.js`");
  }
  const rules = [];
  for (const file of fs.readdirSync(BUNDLED_RULES_DIR)) {
    if (!file.endsWith(".js") || file === "index.js") continue;
    const name = file.slice(0, -3);
    if (only && !only.has(name)) continue;
    try {
      const mod = require(path.join(BUNDLED_RULES_DIR, file));
      const desc = _toDescriptor(name, mod);
      if (!desc) continue;
      if (desc.meta.deprecated && !includeDeprecated && !(only && only.has(name))) continue;
      rules.push(desc);
    } catch { /* skip broken rules */ }
  }
  return rules;
}

// ── Third-party plugins ──────────────────────────────────────

/**
 * Load a third-party ESLint plugin's rules.
 *
 * @param {string} pkgName
 * @param {object} [opts]
 * @param {Set<string>} [opts.only]
 * @returns {{ meta: object, create: Function }[]}
 */
function loadPlugin(pkgName, opts = {}) {
  const { only } = opts;
  const rules = [];

  if (bundleHas(pkgName)) {
    const map = bundleRulesFor(pkgName);
    for (const [ruleName, mod] of Object.entries(map)) {
      const fullName = `${pkgName}/${ruleName}`;
      if (only && !only.has(ruleName) && !only.has(fullName)) continue;
      const desc = _toDescriptor(fullName, mod);
      if (desc) rules.push(desc);
    }
    return rules;
  }

  // Fallback: dynamic require for plugins not in the bundle.
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
  for (const [ruleName, rule] of Object.entries(rulesMap)) {
    const fullName = `${pkgName}/${ruleName}`;
    if (only && !only.has(ruleName) && !only.has(fullName)) continue;
    const desc = _toDescriptor(fullName, rule);
    if (desc) rules.push(desc);
  }
  return rules;
}

// ── Native rule message lookup ───────────────────────────────
//
// Native (Zig) diagnostics carry a `messageId` but not the human-readable
// message text — JS-side hydrates the message from the rule module's
// `meta.messages` map.  Two ways to populate the lookup:
//
//   * `setNativeMessageSource(descriptors)` — called by the CLI binary at
//     startup with the static CORE_PLUGINS bundle.  Bypasses loadCoreRules,
//     which goes through dynamic require paths that `bun build --compile`
//     can't follow into the standalone binary.
//
//   * Fallback — when no source is set (library API path), lazily call
//     loadCoreRules on first lookup.
let _nativeMessageMap = null;
function _ensureNativeMessageMap() {
  if (_nativeMessageMap) return _nativeMessageMap;
  _nativeMessageMap = new Map();
  for (const desc of loadCoreRules({ includeDeprecated: true })) {
    const msgs = desc.meta?.messages;
    if (msgs && typeof msgs === "object") _nativeMessageMap.set(desc.meta.name, msgs);
  }
  return _nativeMessageMap;
}

function setNativeMessageSource(descriptors) {
  _nativeMessageMap = new Map();
  for (const desc of descriptors) {
    const msgs = desc.meta?.messages;
    if (msgs && typeof msgs === "object") _nativeMessageMap.set(desc.meta.name, msgs);
  }
}

function getNativeMessageTemplate(ruleName, messageId) {
  if (!ruleName || !messageId) return null;
  const map = _ensureNativeMessageMap();
  const msgs = map.get(ruleName);
  return msgs ? (msgs[messageId] ?? null) : null;
}

module.exports = { loadCoreRules, loadPlugin, getNativeMessageTemplate, setNativeMessageSource };
