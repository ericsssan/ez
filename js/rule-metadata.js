// Runtime loader for per-plugin rule metadata produced by tools/rule-analyzer.js.
//
// The dispatcher queries describeRule(pluginId, ruleName) to learn how each rule
// should be instantiated (strategy field). Unknown rules default to
// "fresh-per-file" (the conservative today's-behavior path).
//
// Cache files live at <cacheDir>/<pluginId>.json, keyed by plugin@version.
// Missing cache → on-demand analysis via tools/rule-analyzer.js.

"use strict";

const fs = require("node:fs");
const path = require("node:path");
const { spawnSync } = require("node:child_process");

const ANALYZER_VERSION = 1;
const DEFAULT_STRATEGY = "fresh-per-file";

class RuleMetadataIndex {
  constructor({ cacheDir = ".ez/rules", analyzerPath = null } = {}) {
    this.cacheDir = path.resolve(cacheDir);
    this.analyzerPath =
      analyzerPath ||
      path.resolve(__dirname, "..", "tools", "rule-analyzer.js");
    this._plugins = new Map(); // pluginId → { rules, analyzerVersion, ... } | null (miss)
  }

  // Public: return the runtime record for a single rule, or a conservative fallback.
  describeRule(pluginId, ruleName) {
    const plugin = this._getPlugin(pluginId);
    if (!plugin) return defaultRecord("plugin not indexed");
    const rec = plugin.rules[ruleName];
    if (!rec) return defaultRecord("rule not indexed");
    return rec;
  }

  // Public: ensure a plugin's cache file exists, running the analyzer if needed.
  // Returns true if the cache is now usable, false on failure.
  ensurePluginIndexed(pluginId, ruleDir) {
    const cachePath = this._cachePath(pluginId);
    if (fs.existsSync(cachePath)) {
      const loaded = this._loadFromDisk(pluginId);
      if (loaded && loaded.analyzerVersion === ANALYZER_VERSION) return true;
      // Version skew — re-analyze.
    }
    if (!ruleDir || !fs.existsSync(ruleDir)) return false;
    return this._runAnalyzer(pluginId, ruleDir);
  }

  // Public: bulk describe — all rules for a plugin. Returns null if not indexed.
  describePlugin(pluginId) {
    const plugin = this._getPlugin(pluginId);
    if (!plugin) return null;
    return plugin.rules;
  }

  // Internal: cache-first plugin lookup. Loads from disk on first access.
  _getPlugin(pluginId) {
    if (this._plugins.has(pluginId)) return this._plugins.get(pluginId);
    const loaded = this._loadFromDisk(pluginId);
    this._plugins.set(pluginId, loaded);
    return loaded;
  }

  _loadFromDisk(pluginId) {
    // Exact match first: `.ez/rules/<pluginId>.json`.
    const exact = this._cachePath(pluginId);
    if (fs.existsSync(exact)) {
      const parsed = tryParse(exact);
      if (parsed) return parsed;
    }
    // Prefix fallback: pluginId="eslint" matches "eslint@10.2.0.json". Pick most recent.
    if (!fs.existsSync(this.cacheDir)) return null;
    let best = null;
    let bestMtime = 0;
    for (const name of fs.readdirSync(this.cacheDir)) {
      if (!name.endsWith(".json")) continue;
      if (name === `${pluginId}.json`) continue; // already tried
      const base = name.slice(0, -5);
      if (base === pluginId || base.startsWith(`${pluginId}@`)) {
        const full = path.join(this.cacheDir, name);
        const stat = fs.statSync(full);
        if (stat.mtimeMs > bestMtime) {
          bestMtime = stat.mtimeMs;
          best = full;
        }
      }
    }
    return best ? tryParse(best) : null;
  }

  _cachePath(pluginId) {
    return path.join(this.cacheDir, `${pluginId}.json`);
  }

  _runAnalyzer(pluginId, ruleDir) {
    fs.mkdirSync(this.cacheDir, { recursive: true });
    const result = spawnSync(
      process.execPath,
      [this.analyzerPath, "--out", this.cacheDir, "--plugin", pluginId, ruleDir],
      { stdio: ["ignore", "ignore", "inherit"] }
    );
    if (result.status !== 0) {
      // Try Bun as a fallback if node couldn't execute the analyzer (e.g., missing espree in node path).
      const bunResult = spawnSync(
        "bun",
        [this.analyzerPath, "--out", this.cacheDir, "--plugin", pluginId, ruleDir],
        { stdio: ["ignore", "ignore", "inherit"] }
      );
      if (bunResult.status !== 0) return false;
    }
    // Invalidate memory cache and reload.
    this._plugins.delete(pluginId);
    const reloaded = this._loadFromDisk(pluginId);
    this._plugins.set(pluginId, reloaded);
    return !!reloaded;
  }
}

function defaultRecord(reason) {
  return { strategy: DEFAULT_STRATEGY, reason };
}

function tryParse(file) {
  try {
    const parsed = JSON.parse(fs.readFileSync(file, "utf8"));
    if (!parsed || typeof parsed.rules !== "object") return null;
    return parsed;
  } catch (_e) {
    return null;
  }
}

module.exports = {
  RuleMetadataIndex,
  ANALYZER_VERSION,
  DEFAULT_STRATEGY,
};
