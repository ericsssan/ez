"use strict";
/**
 * ez public API — consolidated entry point.
 *
 * Three functions:
 *   lint(targets, config)       — lint files, return diagnostics
 *   lintSource(source, config)  — lint source text (LSP/editor)
 *   fix(targets, config)        — lint + apply fixes, write back
 *
 * Every call runs BOTH native Zig rules AND ESLint JS rules.
 * Diagnostics are merged into one unified format.
 */

const fs   = require("fs");
const path = require("path");
const {
  parseSource, parseAndLint, parseAndLintSource,
  getTagNames, getNativeRules, buildNativeConfig, detectLang, LANG,
} = require("./index");
const { runPlugins } = require("./eslint-runner");
const { loadCoreRules, loadPlugin } = require("./load-plugin");

// ── Constants ───────────────────────────────────────────────────

const JS_EXTS = new Set([".js", ".mjs", ".cjs", ".jsx", ".ts", ".mts", ".cts", ".tsx"]);
const SKIP_PLUGINS = new Set(["@typescript-eslint", "@typescript-eslint/eslint-plugin", "typescript-eslint"]);

// ── Config resolution ───────────────────────────────────────────

/**
 * Resolve a flat config file from cwd. Returns the config array or null.
 */
async function _loadFlatConfig(configFile, cwd) {
  const candidates = configFile
    ? [path.resolve(cwd, configFile)]
    : ["eslint.config.js", "eslint.config.mjs", "eslint.config.cjs"].map(f => path.join(cwd, f));

  for (const p of candidates) {
    if (!fs.existsSync(p)) continue;
    try {
      // ESM config: use dynamic import
      if (p.endsWith(".mjs") || p.endsWith(".js")) {
        const mod = await import(p);
        return mod.default || mod;
      }
      // CJS config
      return require(p);
    } catch { continue; }
  }
  return null;
}

/**
 * Resolve config into { rules, pluginDescriptors, nativeConfig }.
 * Accepts user config options or loads from eslint.config.js.
 */
async function _resolveConfig(config = {}) {
  const cwd = config.cwd || process.cwd();
  let rules = {};       // ruleId → severity or [severity, ...options]
  let pluginPkgs = [];  // plugin package names to load

  // Load flat config if present
  const flatConfig = await _loadFlatConfig(config.configFile, cwd);
  if (flatConfig) {
    const configs = Array.isArray(flatConfig) ? flatConfig : [flatConfig];
    for (const cfg of configs) {
      if (cfg.rules) Object.assign(rules, cfg.rules);
      if (cfg.plugins) {
        for (const [prefix, plugin] of Object.entries(cfg.plugins)) {
          if (SKIP_PLUGINS.has(prefix)) continue;
          // Flat config plugins are already loaded objects, not package names.
          // We'll handle them directly later.
          if (plugin && plugin.rules) {
            pluginPkgs.push({ prefix, plugin });
          }
        }
      }
    }
  }

  // Override with inline config
  if (config.rules) Object.assign(rules, config.rules);
  if (config.plugins) {
    for (const name of config.plugins) {
      if (SKIP_PLUGINS.has(name)) continue;
      pluginPkgs.push(name);
    }
  }

  const loadCoreByDefault = pluginPkgs.length === 0 && !flatConfig;

  // Build rule severity/options maps
  const ruleSeverities = {};
  const ruleOptions = {};
  for (const [name, value] of Object.entries(rules)) {
    if (Array.isArray(value)) {
      const sev = _normalizeSeverity(value[0]);
      if (sev === 0) continue;
      ruleSeverities[name] = sev;
      if (value.length > 1) ruleOptions[name] = value.slice(1);
    } else {
      const sev = _normalizeSeverity(value);
      if (sev === 0) continue;
      ruleSeverities[name] = sev;
    }
  }

  // Load plugin descriptors
  const ruleFilters = new Set(Object.keys(ruleSeverities));
  const allPluginDescs = [];

  // Always load core rules
  if (loadCoreByDefault) {
    allPluginDescs.push(...loadCoreRules({ only: ruleFilters.size > 0 ? ruleFilters : undefined }));
  }

  for (const entry of pluginPkgs) {
    if (typeof entry === "string") {
      // Package name — load via loadPlugin
      if (SKIP_PLUGINS.has(entry)) continue;
      try {
        const descs = loadPlugin(entry, { only: ruleFilters.size > 0 ? ruleFilters : undefined });
        allPluginDescs.push(...descs);
      } catch { /* skip unresolvable */ }
    } else if (entry.prefix && entry.plugin) {
      // Flat config pre-loaded plugin object
      for (const [name, rule] of Object.entries(entry.plugin.rules)) {
        const fullName = `${entry.prefix}/${name}`;
        if (ruleFilters.size > 0 && !ruleFilters.has(name) && !ruleFilters.has(fullName)) continue;
        const create = rule.create || rule;
        if (typeof create !== "function") continue;
        allPluginDescs.push({
          meta: { name: fullName, schema: rule.meta?.schema, messages: rule.meta?.messages },
          create,
        });
      }
    }
  }

  // If no specific rules configured, load all from plugins with default severity
  if (ruleFilters.size === 0 && allPluginDescs.length === 0) {
    try {
      allPluginDescs.push(...loadCoreRules());
    } catch { /* eslint not installed */ }
  }

  // Split into native vs JS-only
  const nativeRules = getNativeRules();
  const nativeRuleObj = {};
  for (const desc of allPluginDescs) {
    const name = desc.meta?.name;
    if (!name) continue;
    const info = nativeRules.get(name);
    if (info) {
      nativeRuleObj[name] = ruleSeverities[name] || info.defaultSeverity;
    }
  }
  const nativeConfig = Object.keys(nativeRuleObj).length > 0
    ? buildNativeConfig(nativeRuleObj, ruleOptions)
    : null;
  const jsPlugins = allPluginDescs.filter(p => !nativeRules.has(p.meta?.name));

  return { jsPlugins, nativeConfig, ruleSeverities, ruleOptions, cwd };
}

function _normalizeSeverity(val) {
  if (val === "off" || val === 0) return 0;
  if (val === "warn" || val === "warning" || val === 1) return 1;
  if (val === "error" || val === 2) return 2;
  return typeof val === "number" ? Math.min(2, Math.max(0, val)) : 2;
}

// ── Diagnostic format ───────────────────────────────────────────

function _fromRunnerReport(r) {
  return {
    ruleId: r.ruleId || null,
    message: r.message,
    severity: r.severity || 2,
    line: r.loc?.start?.line ?? 0,
    column: r.loc?.start?.column ?? 0,
    endLine: r.loc?.end?.line ?? undefined,
    endColumn: r.loc?.end?.column ?? undefined,
    fix: r.fix || undefined,
  };
}

function _fromNativeDiag(d) {
  return {
    ruleId: d.ruleName,
    message: `[${d.ruleName}]`, // message comes from bundled rule meta.messages on JS side
    severity: d.severity || 2,
    line: d.line ?? 0,
    column: d.col ?? 0,
    endLine: undefined,
    endColumn: undefined,
    fix: undefined,
  };
}

// ── File discovery ──────────────────────────────────────────────

function _discoverFiles(targets, extensions) {
  const exts = extensions ? new Set(extensions) : JS_EXTS;
  const results = [];
  function walk(p) {
    const abs = path.resolve(p);
    const stat = fs.statSync(abs, { throwIfNoEntry: false });
    if (!stat) return;
    if (stat.isDirectory()) {
      for (const entry of fs.readdirSync(abs)) {
        if (entry.startsWith(".") || entry === "node_modules") continue;
        walk(path.join(abs, entry));
      }
    } else if (stat.isFile() && exts.has(path.extname(abs)) &&
               !abs.endsWith(".d.ts") && !abs.endsWith(".d.mts") && !abs.endsWith(".d.cts")) {
      results.push(abs);
    }
  }
  for (const t of (Array.isArray(targets) ? targets : [targets])) walk(t);
  return results;
}

// ── Fix application ─────────────────────────────────────────────

function _applyFixes(source, fixes) {
  if (!fixes || fixes.length === 0) return source;
  const sorted = fixes.slice().sort((a, b) => a.range[0] - b.range[0]);
  let result = "";
  let lastIndex = 0;
  for (const fix of sorted) {
    const [start, end] = fix.range;
    if (start < lastIndex) continue; // skip overlapping
    result += source.slice(lastIndex, start) + fix.text;
    lastIndex = end;
  }
  return result + source.slice(lastIndex);
}

// ── Core lint logic (single file) ───────────────────────────────

function _lintOne(filePath, resolved) {
  const tagNames = getTagNames();
  const { jsPlugins, nativeConfig, ruleSeverities, ruleOptions } = resolved;

  // Parse + native lint in one pass
  const { ast, diags: nativeDiags } = nativeConfig
    ? parseAndLint(filePath, { config: nativeConfig })
    : { ast: require("./index").parse(filePath), diags: [] };

  // Run JS rules
  const ruleConfig = {};
  for (const p of jsPlugins) {
    const name = p.meta?.name;
    if (name && ruleOptions[name]) ruleConfig[name] = ruleOptions[name];
  }
  const reports = jsPlugins.length > 0
    ? runPlugins(ast, jsPlugins, { tagNames, filename: filePath, ruleConfig })
    : [];

  // Merge diagnostics
  const diagnostics = [
    ...nativeDiags.map(_fromNativeDiag),
    ...reports.map(_fromRunnerReport),
  ].sort((a, b) => (a.line - b.line) || (a.column - b.column));

  return diagnostics;
}

function _lintSourceOne(source, filename, resolved) {
  const tagNames = getTagNames();
  const { jsPlugins, nativeConfig, ruleSeverities, ruleOptions } = resolved;

  const { ast, diags: nativeDiags } = nativeConfig
    ? parseAndLintSource(source, { filename, config: nativeConfig })
    : { ast: parseSource(source, { filename }), diags: [] };

  const ruleConfig = {};
  for (const p of jsPlugins) {
    const name = p.meta?.name;
    if (name && ruleOptions[name]) ruleConfig[name] = ruleOptions[name];
  }
  const reports = jsPlugins.length > 0
    ? runPlugins(ast, jsPlugins, { tagNames, filename, ruleConfig })
    : [];

  return [
    ...nativeDiags.map(_fromNativeDiag),
    ...reports.map(_fromRunnerReport),
  ].sort((a, b) => (a.line - b.line) || (a.column - b.column));
}

// ── Public API ──────────────────────────────────────────────────

/**
 * Lint files. Returns array of { file, diagnostics }.
 *
 * @param {string|string[]} targets - File paths, directories, or globs
 * @param {object} [config] - Configuration options
 * @returns {Promise<Array<{file: string, diagnostics: Array}>>}
 */
async function lint(targets, config = {}) {
  const resolved = await _resolveConfig(config);
  const files = _discoverFiles(targets, config.extensions);
  const results = [];
  for (const file of files) {
    try {
      const diagnostics = _lintOne(file, resolved);
      if (diagnostics.length > 0 || config.includeClean) {
        results.push({ file, diagnostics });
      }
    } catch (e) {
      results.push({ file, diagnostics: [{ ruleId: null, message: `Parse error: ${e.message}`, severity: 2, line: 0, column: 0 }] });
    }
  }
  return results;
}

/**
 * Lint source text. Returns diagnostics array.
 *
 * @param {string} source - Source code text
 * @param {object} [config] - Configuration options (must include filename)
 * @returns {Promise<Array>}
 */
async function lintSource(source, config = {}) {
  const resolved = await _resolveConfig(config);
  const filename = config.filename || "<input>";
  return _lintSourceOne(source, filename, resolved);
}

/**
 * Lint files and apply fixes. Returns { results, fixedFiles }.
 *
 * @param {string|string[]} targets - File paths, directories, or globs
 * @param {object} [config] - Configuration options
 * @returns {Promise<{results: Array, fixedFiles: string[]}>}
 */
async function fix(targets, config = {}) {
  const resolved = await _resolveConfig(config);
  const files = _discoverFiles(targets, config.extensions);
  const results = [];
  const fixedFiles = [];

  for (const file of files) {
    try {
      const diagnostics = _lintOne(file, resolved);
      const fixes = diagnostics.filter(d => d.fix).flatMap(d => Array.isArray(d.fix) ? d.fix : [d.fix]);
      if (fixes.length > 0) {
        const source = fs.readFileSync(file, "utf8");
        const fixed = _applyFixes(source, fixes);
        if (fixed !== source) {
          fs.writeFileSync(file, fixed);
          fixedFiles.push(file);
        }
      }
      const remaining = diagnostics.filter(d => !d.fix);
      if (remaining.length > 0) results.push({ file, diagnostics: remaining });
    } catch (e) {
      results.push({ file, diagnostics: [{ ruleId: null, message: `Error: ${e.message}`, severity: 2, line: 0, column: 0 }] });
    }
  }

  return { results, fixedFiles };
}

module.exports = { lint, lintSource, fix };
