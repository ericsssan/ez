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
  parseSource, parseAndLintNative, lintSourceNative, discoverFiles,
  getTagNames, getNativeRules, buildNativeConfig, detectLang, LANG,
} = require("./index");
const { runPlugins, applyDisableDirectives } = require("./eslint-runner");
const { loadCoreRules, loadPlugin, getNativeMessageTemplate } = require("./load-plugin");

// Type-aware services init is deferred — eslint-runner calls ts-services
// lazily on the first file that needs parserServices.  Keeps JS-only
// workloads from paying the 70+ ms typescript + LanguageService init.

// ── Constants ───────────────────────────────────────────────────

const SKIP_PLUGINS = new Set([]);

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
// Memoize resolved config by config-object identity.  Without it, every
// lint() call rebuilds jsPlugins into a fresh Array and the runner's
// buildVisitorMap cache (_cachedVMPlugins === plugins) misses every call,
// forcing a full cold rebuild of every rule's visitors on every file.
// WeakMap so one-shot callers don't keep resolved state alive.
const _resolvedCache = new WeakMap();

async function _resolveConfig(config = {}) {
  const cached = _resolvedCache.get(config);
  if (cached) return cached;
  const resolved = await _resolveConfigImpl(config);
  _resolvedCache.set(config, resolved);
  return resolved;
}

async function _resolveConfigImpl(config = {}) {
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
        for (const [prefix, rawPlugin] of Object.entries(cfg.plugins)) {
          if (SKIP_PLUGINS.has(prefix)) continue;
          // Unwrap ESM default export (e.g. eslint-plugin-unicorn uses { default: { rules } })
          const plugin = rawPlugin?.default || rawPlugin;
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
    for (const entry of config.plugins) {
      if (typeof entry === "string") {
        if (SKIP_PLUGINS.has(entry)) continue;
        pluginPkgs.push(entry);
      } else if (entry && entry.prefix && entry.plugin) {
        if (SKIP_PLUGINS.has(entry.prefix)) continue;
        pluginPkgs.push(entry);
      }
    }
  }

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

  // Always load core rules that are referenced in the config (or all if no config)
  const coreOnly = ruleFilters.size > 0 ? ruleFilters : undefined;
  // Allow callers to supply pre-required rule descriptors instead of going
  // through loadCoreRules (which uses dynamic require paths that `bun build
  // --compile` can't follow into the standalone binary).  The CLI binary
  // entry uses this to ship a static-import set of recommended rules; the
  // library API (no corePlugins) keeps the bundle path.
  if (Array.isArray(config.corePlugins) && config.corePlugins.length > 0) {
    for (const desc of config.corePlugins) {
      if (coreOnly && !coreOnly.has(desc.meta?.name)) continue;
      allPluginDescs.push(desc);
    }
  } else {
    allPluginDescs.push(...loadCoreRules({ only: coreOnly }));
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
          meta: { name: fullName, schema: rule.meta?.schema, messages: rule.meta?.messages, defaultOptions: rule.meta?.defaultOptions, fixable: rule.meta?.fixable },
          create,
        });
      }
    }
  }

  // Split into native vs JS-only
  const nativeRules = getNativeRules();
  const nativeRuleObj = {};
  for (const desc of allPluginDescs) {
    const name = desc.meta?.name;
    if (!name) continue;
    const info = nativeRules.get(name);
    if (info) {
      const sev = ruleSeverities[name] || info.defaultSeverity;
      const opts = ruleOptions[name];
      nativeRuleObj[name] = opts && opts.length > 0 ? [sev, ...opts] : sev;
    }
  }
  const nativeConfig = Object.keys(nativeRuleObj).length > 0
    ? buildNativeConfig({ rules: nativeRuleObj })
    : null;
  const jsPlugins = allPluginDescs.filter(p => !nativeRules.has(p.meta?.name));

  // Pre-compute the per-plugin ruleConfig lookup table used by runPlugins.
  // It's derived entirely from stable resolved config, so compute once here
  // and reuse across every lint() call — the reference-equality check in
  // buildVisitorMap's stable-config short-circuit depends on this.
  const ruleConfig = {};
  for (const p of jsPlugins) {
    const name = p.meta?.name;
    if (name && ruleOptions[name]) ruleConfig[name] = ruleOptions[name];
  }

  return { jsPlugins, nativeConfig, ruleSeverities, ruleOptions, ruleConfig, cwd };
}

function _normalizeSeverity(val) {
  if (val === "off" || val === 0) return 0;
  if (val === "warn" || val === "warning" || val === 1) return 1;
  if (val === "error" || val === 2) return 2;
  return typeof val === "number" ? Math.min(2, Math.max(0, val)) : 2;
}

// ── Diagnostic format ───────────────────────────────────────────

function _fromRunnerReport(r) {
  // ESLint Linter.verify() returns 1-based columns even though ESTree node.loc
  // is 0-based; convert at the API boundary so consumers get the ESLint shape.
  const startCol = r.loc?.start?.column;
  const endCol   = r.loc?.end?.column;
  const out = {
    ruleId: r.ruleId || null,
    message: r.message,
    severity: r.severity || 2,
    messageId: r.messageId ?? undefined,
    line: r.loc?.start?.line ?? 0,
    column: startCol != null ? startCol + 1 : 0,
    endLine: r.loc?.end?.line ?? undefined,
    endColumn: endCol != null ? endCol + 1 : undefined,
    fix: r.fix || undefined,
  };
  if (r.suggestions) out.suggestions = r.suggestions;
  return out;
}

function _fromNativeDiag(d) {
  // Wire format carries (offset, endOffset, ruleName, [messageId], [fix], [data]).
  // Hydrate ESLint-shape fields on the JS side: message text from
  // rule.meta.messages, line/col from precomputed line-starts in _parseDiags.
  const template = getNativeMessageTemplate(d.ruleName, d.messageId);
  // Interpolate `{{key}}` placeholders if the native side sent template data
  // — so dynamic messages like "Duplicate param 'X'." come out fully formed.
  let message = template ?? (d.messageId ? `[${d.ruleName}/${d.messageId}]` : `[${d.ruleName}]`);
  if (template && d.data) {
    message = template.replace(/\{\{\s*(\w+)\s*\}\}/g, (_, k) => d.data[k] ?? `{{${k}}}`);
  }
  // ESLint columns are 1-based; native diags carry 0-based byte columns.
  const col    = d.col != null ? d.col + 1 : 0;
  const endCol = d.endCol != null ? d.endCol + 1 : undefined;
  return {
    ruleId: d.ruleName,
    message,
    messageId: d.messageId ?? undefined,
    severity: d.severity || 2,
    line: d.line ?? 0,
    column: col,
    endLine: d.endLine ?? undefined,
    endColumn: endCol,
    fix: d.fix,
  };
}

// ── Fix application ─────────────────────────────────────────────

function applyFixes(source, fixes) {
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
  const { jsPlugins, nativeConfig, ruleConfig, ruleSeverities } = resolved;

  // Parse + native lint in one pass
  const { ast, diags: nativeDiags } = nativeConfig
    ? parseAndLintNative(filePath, { config: nativeConfig })
    : { ast: require("./index").parse(filePath), diags: [] };

  const rawReports = jsPlugins.length > 0
    ? runPlugins(ast, jsPlugins, { tagNames, filename: filePath, ruleConfig, ruleSeverities })
    : [];
  // ESLint suppresses violations covered by `eslint-disable*` comments. Apply the
  // same filter to runner reports so directives in the source actually take effect.
  const reports = rawReports.length > 0 ? applyDisableDirectives(ast.source, rawReports) : rawReports;

  // Merge diagnostics
  const diagnostics = [
    ...nativeDiags.map(_fromNativeDiag),
    ...reports.map(_fromRunnerReport),
  ].sort((a, b) => (a.line - b.line) || (a.column - b.column));

  return { diagnostics, ast };
}

function _lintSourceOne(source, filename, resolved, opts = {}) {
  const tagNames = getTagNames();
  const { jsPlugins, nativeConfig, ruleConfig, ruleSeverities } = resolved;

  const ast = parseSource(source, { filename });
  const nativeDiags = nativeConfig ? lintSourceNative(source, { filename, config: nativeConfig }) : [];

  const rawReports = jsPlugins.length > 0
    ? runPlugins(ast, jsPlugins, {
        tagNames,
        filename,
        ruleConfig,
        ruleSeverities,
        // Pass through optional advanced flags. errorBudget controls the
        // per-rule short-circuit (default 200 in production); benchmarks
        // pass Infinity for honest counts.
        errorBudget: opts.errorBudget,
      })
    : [];
  const reports = rawReports.length > 0 ? applyDisableDirectives(source, rawReports) : rawReports;

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
// Quick shape test: every entry looks like a concrete file path (no glob, known
// JS/TS extension, no trailing slash). Used to skip discoverFiles when caller
// has pre-discovered the set.
const _FILE_PATH_RE = /\.(?:m?js|c?js|m?ts|c?ts|jsx|tsx|mjs|cjs|mts|cts)$/;
const _GLOB_CHARS_RE = /[*?{}[\]]/;
function _looksLikeFileList(targets) {
  if (process.env.EZ_DISABLE_DISCOVER_FAST === "1") return false;
  if (!Array.isArray(targets) || targets.length === 0) return false;
  for (const t of targets) {
    if (typeof t !== "string") return false;
    if (t.length === 0) return false;
    if (t.endsWith("/")) return false;
    if (_GLOB_CHARS_RE.test(t)) return false;
    if (!_FILE_PATH_RE.test(t)) return false;
  }
  return true;
}

async function lint(targets, config = {}) {
  const resolved = await _resolveConfig(config);
  const targetList = Array.isArray(targets) ? targets : [targets];
  // Sort paths.  Unsorted readdir order interleaves varied AST shapes in a
  // way that thrashes JSC's JIT specialization: on corpora past ~30k files
  // the cumulative deoptimizations spiral into a multi-GB allocation burst
  // and crash Bun with a bus error.  Lexicographic ordering groups similar
  // files together and keeps the JIT stable.  Same fixture set, same total
  // work — just a deterministic visit order.
  //
  // Fast path: when every target is already a plain file path (no glob chars,
  // known JS/TS extension, no trailing slash), skip the NAPI discoverFiles
  // round-trip and its stat() per path. Batch callers that pre-discover files
  // (profile_corpus.js, CI pipelines) hit this path repeatedly — each skipped
  // discovery saves ~40-50ms on a 500-file chunk.
  const files = _looksLikeFileList(targetList)
    ? [...targetList].sort()
    : discoverFiles(targetList).paths.sort();
  const results = [];
  for (const file of files) {
    try {
      const { diagnostics } = _lintOne(file, resolved);
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
  return _lintSourceOne(source, filename, resolved, { errorBudget: config.errorBudget });
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
  const targetList = Array.isArray(targets) ? targets : [targets];
  // Sort paths.  Unsorted readdir order interleaves varied AST shapes in a
  // way that thrashes JSC's JIT specialization: on corpora past ~30k files
  // the cumulative deoptimizations spiral into a multi-GB allocation burst
  // and crash Bun with a bus error.  Lexicographic ordering groups similar
  // files together and keeps the JIT stable.  Same fixture set, same total
  // work — just a deterministic visit order. Fast path when caller already
  // supplied a plain file list — see _looksLikeFileList above.
  const files = _looksLikeFileList(targetList)
    ? [...targetList].sort()
    : discoverFiles(targetList).paths.sort();
  const results = [];
  const fixedFiles = [];

  for (const file of files) {
    try {
      const { diagnostics, ast } = _lintOne(file, resolved);
      const fixes = diagnostics.filter(d => d.fix).flatMap(d => Array.isArray(d.fix) ? d.fix : [d.fix]);
      if (fixes.length > 0) {
        const source = ast.source;
        const fixed = applyFixes(source, fixes);
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

/**
 * Lint source text and apply fixes. Returns { fixed, remaining } where `fixed`
 * is the new source string (== input if nothing fixed) and `remaining` is the
 * diagnostics that had no fix. Symmetric to fix() but operates in memory only.
 *
 * @param {string} source - Source code text
 * @param {object} [config] - Configuration options (must include filename)
 * @returns {Promise<{fixed: string, remaining: Array}>}
 */
async function fixSource(source, config = {}) {
  const resolved = await _resolveConfig(config);
  const filename = config.filename || "<input>";
  const diagnostics = _lintSourceOne(source, filename, resolved);
  const fixes = diagnostics.filter(d => d.fix).flatMap(d => Array.isArray(d.fix) ? d.fix : [d.fix]);
  const fixed = fixes.length > 0 ? applyFixes(source, fixes) : source;
  const remaining = diagnostics.filter(d => !d.fix);
  return { fixed, remaining };
}

/**
 * Create a cached linter for LSP/editor use.
 * Resolves config once; returns async lintText(source, filename) → diags[].
 *
 * @param {object} [config] - Configuration options (cwd, configFile, rules, plugins)
 * @returns {Promise<function(source: string, filename: string): Promise<Array>>}
 */
async function createLinter(config = {}) {
  const resolved = await _resolveConfig(config);
  return function lintText(source, filename) {
    return Promise.resolve(_lintSourceOne(source, filename || "<input>", resolved));
  };
}

/**
 * Synchronous variant of createLinter for callers (like the CLI's --fix loop)
 * that need to lint in-memory source text without paying the await tax.
 * Caller is responsible for resolving config first via _resolveConfig — or
 * use the simpler `createLinter` if a Promise return is acceptable.
 *
 * Returns lintText(source, filename) → diags[] (NOT a Promise).
 *
 * @param {object} resolved - Output of _resolveConfig (jsPlugins, nativeConfig, ruleConfig, ruleSeverities)
 * @returns {function(source: string, filename: string): Array}
 */
function lintTextSync(resolved, source, filename) {
  return _lintSourceOne(source, filename || "<input>", resolved);
}

/**
 * Resolve config and return both the resolved object and the sync linter.
 * Helper for callers that want both.
 */
async function createSyncLinter(config = {}) {
  const resolved = await _resolveConfig(config);
  return { resolved, lintText: (source, filename) => lintTextSync(resolved, source, filename) };
}

/**
 * Create a cached file linter for CI / batch runs.
 * Resolves config once; returns lintFile(path) → diags[] using the fused
 * parseAndLintNative NAPI path (one Zig trip = read + parse + native lint),
 * then the shared JS plugin runner. No JS-side string copy of the source.
 *
 * @param {object} [config] - Configuration options (cwd, configFile, rules, plugins)
 * @returns {Promise<function(filePath: string): Array>}
 */
async function createFileLinter(config = {}) {
  const resolved = await _resolveConfig(config);
  return function lintFile(filePath) {
    const { diagnostics } = _lintOne(filePath, resolved);
    return diagnostics;
  };
}

module.exports = { lint, lintSource, fix, fixSource, applyFixes, createLinter, createSyncLinter, createFileLinter };
