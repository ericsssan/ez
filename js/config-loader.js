"use strict";
const fs = require("fs");
const path = require("path");
const { minimatch } = require("minimatch");

// ── Glob helper ──────────────────────────────────────────────────

/**
 * Returns true if filePath matches any of the given glob patterns.
 * Patterns evaluated relative to baseDir first, then as absolute globs.
 * @param {string} filePath  Absolute path to the file
 * @param {string[]} patterns  Glob patterns (may be relative or absolute)
 * @param {string} baseDir  Base directory for relative resolution
 */
function matchesAny(filePath, patterns, baseDir) {
  const rel = path.relative(baseDir, filePath);
  const opts = { dot: true };
  return patterns.some(p =>
    minimatch(rel, p, opts) ||
    minimatch(filePath, p, opts) ||
    minimatch(rel, p.replace(/^\.\//, ""), opts)
  );
}

// ── Rule normalization ───────────────────────────────────────────

/**
 * Convert a rules record (with severity) into:
 *   enabledRules: Set<string>  — rule names where severity != 'off'/0
 *   ruleOptions: Record<string, any[]>  — options array (severity stripped)
 * Matches the shape that runPlugins() expects as `ruleConfig`.
 *
 * @param {Record<string, string|number|Array>} rulesRecord
 * @returns {{ enabledRules: Set<string>, ruleOptions: Record<string, any[]> }}
 */
function normalizeRules(rulesRecord) {
  const enabledRules = new Set();
  const ruleOptions = {};
  for (const [name, value] of Object.entries(rulesRecord)) {
    const severity = Array.isArray(value) ? value[0] : value;
    if (severity === 0 || severity === "off") continue;
    enabledRules.add(name);
    ruleOptions[name] = Array.isArray(value) ? value.slice(1) : [];
  }
  return { enabledRules, ruleOptions };
}

// ── Plugin extraction ────────────────────────────────────────────

/**
 * Convert flat config `plugins` map into the { meta, create }[] shape
 * that runPlugins() expects. Only includes rules present in enabledRules.
 *
 * @param {Record<string, object>} pluginsMap  e.g. { react: eslintPluginReact }
 * @param {Set<string>} enabledRules  Set of full rule names (ns/rule) that are enabled
 * @param {Set<string>} [ruleFilter]  Optional: further restrict to these rule names
 * @returns {{ meta: object, create: Function }[]}
 */
function pluginsFromConfig(pluginsMap, enabledRules, ruleFilter) {
  const result = [];
  for (const [ns, plugin] of Object.entries(pluginsMap)) {
    for (const [ruleName, rule] of Object.entries(plugin.rules || {})) {
      const fullName = `${ns}/${ruleName}`;
      if (!enabledRules.has(fullName) && !enabledRules.has(ruleName)) continue;
      if (ruleFilter && !ruleFilter.has(ruleName) && !ruleFilter.has(fullName)) continue;
      const create = rule.create || rule;
      if (typeof create !== "function") continue;
      result.push({
        meta: {
          name: fullName,
          schema: rule.meta?.schema,
          messages: rule.meta?.messages,
          fixable: rule.meta?.fixable,
          defaultOptions: rule.meta?.defaultOptions,
        },
        create,
      });
    }
  }
  return result;
}

// ── ConfigResolver ───────────────────────────────────────────────

class ConfigResolver {
  /**
   * @param {object[]} flatArray  Flat config array (ESLint 9 format)
   * @param {string} baseDir  Root directory for relative glob resolution
   */
  constructor(flatArray, baseDir) {
    this._flatArray = flatArray;
    this._baseDir = baseDir;
    this._cache = new Map(); // absPath → resolved config | null
  }

  /**
   * Resolve merged config for a given file.
   * Returns null if the file is globally ignored.
   * @param {string} filePath  Absolute path
   * @returns {{ plugins: object, rules: object, settings: object } | null}
   */
  resolveForFile(filePath) {
    if (this._cache.has(filePath)) return this._cache.get(filePath);

    let plugins = {};
    let rules = {};
    let settings = {};

    for (const cfg of this._flatArray) {
      // Global ignores: { ignores: [...] } with no files: key — ignored for whole project
      if (cfg.ignores && !cfg.files) {
        if (matchesAny(filePath, cfg.ignores, this._baseDir)) {
          this._cache.set(filePath, null);
          return null;
        }
      }

      const fileMatches = !cfg.files || matchesAny(filePath, cfg.files, this._baseDir);
      const notIgnored = !cfg.ignores || !matchesAny(filePath, cfg.ignores, this._baseDir);
      if (!fileMatches || !notIgnored) continue;

      // Shallow merge — later entries win
      if (cfg.plugins)  Object.assign(plugins, cfg.plugins);
      if (cfg.rules)    Object.assign(rules, cfg.rules);
      if (cfg.settings) Object.assign(settings, cfg.settings);
    }

    const result = { plugins, rules, settings };
    this._cache.set(filePath, result);
    return result;
  }
}

// ── Config file detection ────────────────────────────────────────

const FLAT_NAMES = ["eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"];
const LEGACY_NAMES = [
  ".eslintrc.js", ".eslintrc.cjs",
  ".eslintrc.yaml", ".eslintrc.yml",
  ".eslintrc.json", ".eslintrc",
];

/**
 * Parse a raw legacy config file (.eslintrc.*) synchronously.
 * Handles JSON, YAML (.yaml/.yml), and JS (.js/.cjs) formats.
 * @param {string} configPath  Absolute path
 * @returns {object} Parsed config object
 */
function parseRawConfig(configPath) {
  const ext = path.extname(configPath);
  if (ext === ".json" || ext === "" /* .eslintrc */) {
    return JSON.parse(fs.readFileSync(configPath, "utf8"));
  }
  if (ext === ".yaml" || ext === ".yml") {
    const yaml = require("js-yaml");
    return yaml.load(fs.readFileSync(configPath, "utf8"));
  }
  // .js, .cjs
  return require(configPath);
}

/**
 * Walk up from startDir collecting legacy config paths.
 * Returns ordered array [outermost, ..., innermost].
 * Stops when a config with root:true is found or filesystem root is reached.
 */
function _collectLegacyPaths(startDir, innerPath) {
  const result = [innerPath];
  try {
    const raw = parseRawConfig(innerPath);
    if (raw.root) return result;
  } catch { return result; }

  let dir = path.dirname(startDir);
  while (true) {
    const parent = path.dirname(dir);
    if (parent === dir) break; // filesystem root

    for (const name of LEGACY_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) {
        result.unshift(p); // prepend = outermost first
        try {
          const raw = parseRawConfig(p);
          if (raw.root) return result;
        } catch { return result; }
        break;
      }
    }

    dir = parent;
  }

  return result;
}

/**
 * Detect the ESLint config file(s) for the given directory.
 * Returns:
 *   { type: 'flat', path: string }
 *   { type: 'legacy', paths: string[] }  — ordered [outermost, ..., innermost]
 *   null
 * @param {string} startDir  Absolute directory to start from (typically cwd)
 */
function detectConfigFile(startDir) {
  let dir = path.resolve(startDir);

  while (true) {
    for (const name of FLAT_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) return { type: "flat", path: p };
    }

    for (const name of LEGACY_NAMES) {
      const p = path.join(dir, name);
      if (fs.existsSync(p)) {
        const paths = _collectLegacyPaths(dir, p);
        return { type: "legacy", paths };
      }
    }

    const parent = path.dirname(dir);
    if (parent === dir) return null;
    dir = parent;
  }
}

// ── Config loading ───────────────────────────────────────────────

/**
 * Load an ESLint 9 flat config file.
 * @param {string} configPath  Absolute path
 * @returns {Promise<ConfigResolver>}
 */
async function loadFlatConfig(configPath) {
  const mod = await import(configPath);
  const configArray = mod.default ?? mod;
  if (!Array.isArray(configArray)) {
    throw new Error(
      `${path.basename(configPath)} must export an array (got ${typeof configArray}). ` +
      `Check your config file.`
    );
  }
  return new ConfigResolver(configArray, path.dirname(configPath));
}

/**
 * Load legacy config files using FlatCompat for full extends/plugin support.
 * @param {string[]} orderedPaths  Config paths, outermost first
 * @returns {ConfigResolver}
 */
function loadLegacyConfig(orderedPaths) {
  const { FlatCompat } = require("@eslint/eslintrc");
  let flatArray = [];
  for (const configPath of orderedPaths) {
    let raw;
    try {
      raw = parseRawConfig(configPath);
    } catch (e) {
      throw new Error(`Cannot parse legacy config ${configPath}: ${e.message}`);
    }
    const compat = new FlatCompat({ baseDirectory: path.dirname(configPath) });
    try {
      flatArray = flatArray.concat(compat.config(raw));
    } catch (e) {
      throw new Error(`Cannot process legacy config ${configPath}: ${e.message}`);
    }
  }
  const baseDir = path.dirname(orderedPaths[orderedPaths.length - 1]);
  return new ConfigResolver(flatArray, baseDir);
}

/**
 * Auto-detect and load the ESLint config.
 * If configPathOrDir is a file, loads it directly (bypasses walk-up detection).
 * If it is a directory, walks up to find the nearest config.
 * Returns null if no config file is found.
 * @param {string} configPathOrDir  File path or directory to start detection from
 * @returns {Promise<ConfigResolver | null>}
 */
async function loadConfig(configPathOrDir) {
  const abs = path.resolve(configPathOrDir);

  // If it's a file, load directly based on filename
  let stat;
  try { stat = fs.statSync(abs); } catch { return null; }

  if (stat.isFile()) {
    const base = path.basename(abs);
    if (FLAT_NAMES.includes(base)) return loadFlatConfig(abs);
    return loadLegacyConfig([abs]);
  }

  // It's a directory — walk up
  const detected = detectConfigFile(abs);
  if (!detected) return null;
  if (detected.type === "flat") return loadFlatConfig(detected.path);
  return loadLegacyConfig(detected.paths);
}

module.exports = {
  matchesAny,
  normalizeRules,
  pluginsFromConfig,
  ConfigResolver,
  detectConfigFile,
  parseRawConfig,
  loadFlatConfig,
  loadLegacyConfig,
  loadConfig,
};
