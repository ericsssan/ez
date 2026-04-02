"use strict";
/**
 * Rule loader v2: passes the entire create() source to Zig.
 * The Zig interpreter evaluates create(context) to produce the visitor map.
 * All closure variables are naturally captured — no JS-side extraction hacks.
 *
 * Usage:
 *   const { extractRules } = require('./rule-loader');
 *   const { json, extractedNames, remainingPlugins } = extractRules(plugins, tagNames);
 *   native.loadRules(json);
 */

const { T } = require("./tags");

// ── ESTree type name → sanz tag ordinal(s) ──
const ESTREE_TO_TAGS = {};

function buildTagMap(tagNames) {
  for (let i = 0; i < tagNames.length; i++) {
    const name = tagNames[i];
    if (!name) continue;
    if (!ESTREE_TO_TAGS[name]) ESTREE_TO_TAGS[name] = [];
    ESTREE_TO_TAGS[name].push(i);
  }
}

/**
 * Check if a rule can be extracted for Zig interpretation.
 * The Zig interpreter evaluates the create() body, so we only reject
 * patterns that the interpreter fundamentally can't handle.
 */
function canExtract(createSource) {
  // Must have context.report somewhere (directly or in helper functions)
  if (!createSource.includes("context.report") && !createSource.includes(".report(")) return false;

  // Reject only truly unsupported patterns
  if (createSource.includes("markVariableAsUsed")) return false;
  // Note: require() is handled natively by the Zig interpreter
  // Note: fix/suggest are ignored — rules still produce diagnostics

  return true;
}

/**
 * Extract rules from loaded ESLint plugins.
 * For each rule, passes the entire create() source to Zig.
 */
function extractRules(plugins, tagNames) {
  if (Object.keys(ESTREE_TO_TAGS).length === 0) {
    buildTagMap(tagNames);
  }

  const extracted = [];
  const extractedNames = new Set();
  const remainingPlugins = [];

  for (const plugin of plugins) {
    const ruleName = plugin.meta?.name || "unknown";

    // Get create() source — prepend 'function' if missing (method shorthand)
    let createSource;
    try {
      createSource = plugin.create.toString();
      // Method shorthand: "create(context) {" → "function create(context) {"
      if (!createSource.startsWith("function ") && !createSource.startsWith("(")) {
        createSource = "function " + createSource;
      }
    } catch {
      remainingPlugins.push(plugin);
      continue;
    }

    if (!canExtract(createSource)) {
      remainingPlugins.push(plugin);
      continue;
    }

    // Read the FULL rule file — Zig interprets the entire module
    let fullFileSource = null;
    let moduleRequires = [];
    try {
      const fs = require("fs");
      const path = require("path");
      const eslintPkg = path.dirname(require.resolve("eslint/package.json"));
      const rulePath = path.join(eslintPkg, "lib/rules", ruleName + ".js");
      fullFileSource = fs.readFileSync(rulePath, "utf8");
      const fullSource = fullFileSource;
      const reqRegex = /(?:const|let|var)\s+(?:(\w+)|(\{[^}]+\}))\s*=\s*require\(["']([^"']+)["']\)/g;
      let m;
      while ((m = reqRegex.exec(fullSource)) !== null) {
        const varName = m[1] || null;
        const destructured = m[2] || null;
        const modPath = m[3];
        if (varName) {
          moduleRequires.push({ name: varName, path: modPath });
        } else if (destructured) {
          // { a, b, c } → individual names
          const names = destructured.replace(/[{}]/g, "").split(",").map(s => s.trim().split(/\s+as\s+/).pop().trim()).filter(Boolean);
          for (const n of names) {
            moduleRequires.push({ name: n, path: modPath, destructured: true });
          }
        }
      }
    } catch { /* ignore — not all rules are in eslint core */ }

    // Call create() in JS to get the visitor keys (we need to know
    // which ESTree types map to which sanz tags for the dispatch table).
    // The Zig side will re-evaluate create() to get the actual handlers.
    let visitorKeys;
    try {
      const mockContext = {
        options: plugin.meta?.defaultOptions || [],
        sourceCode: {},
        filename: "",
        report() {},
        getScope() { return {}; },
        parserOptions: { ecmaVersion: 2022, ecmaFeatures: { jsx: true } },
        languageOptions: { ecmaVersion: 2022, sourceType: "module" },
        settings: {},
        id: ruleName,
      };
      const visitors = plugin.create(mockContext);
      if (!visitors || typeof visitors !== "object") {
        remainingPlugins.push(plugin);
        continue;
      }
      visitorKeys = Object.keys(visitors).filter(k => typeof visitors[k] === "function");
    } catch {
      remainingPlugins.push(plugin);
      continue;
    }

    // Map visitor keys to sanz tags
    let hasSelector = false;
    const tagMap = {};
    for (const key of visitorKeys) {
      const isExit = key.endsWith(":exit");
      const typeName = isExit ? key.slice(0, -5) : key;
      const tags = ESTREE_TO_TAGS[typeName];
      if (!tags || tags.length === 0) {
        hasSelector = true;
        break;
      }
      tagMap[key] = { tags, isExit };
    }
    if (hasSelector) {
      remainingPlugins.push(plugin);
      continue;
    }

    // Get message templates
    let msgObj = {};
    try {
      const ruleMod = require("./node_modules/eslint/lib/rules/" + ruleName);
      if (ruleMod?.meta?.messages) msgObj = ruleMod.meta.messages;
    } catch {
      if (plugin.meta?.messages) msgObj = plugin.meta.messages;
    }

    // createSource = always the create() function (for Zig to parse/interpret)
    // fullSource = the complete file (for module-level code extraction)
    extracted.push({
      name: ruleName,
      severity: 2,
      createSource,
      fullSource: fullFileSource || "",
      visitorKeys: Object.entries(tagMap).map(([key, { tags, isExit }]) => ({
        key,
        tags,
        isExit,
      })),
      messages: msgObj,
      options: plugin.meta?.defaultOptions || [],
      requires: moduleRequires,
    });
    extractedNames.add(ruleName);
  }

  return {
    json: JSON.stringify(extracted),
    extractedNames,
    remainingPlugins,
    extractedCount: extracted.length,
    remainingCount: remainingPlugins.length,
  };
}

module.exports = { extractRules, buildTagMap };
