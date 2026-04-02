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

  // Reject rules that use APIs the interpreter doesn't support yet
  if (createSource.includes("require(")) return false;
  if (createSource.includes("markVariableAsUsed")) return false;
  if (createSource.includes(".fix(") || createSource.includes("fix:")) return false;

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

    // Serialize: create source + tag mapping + messages + options
    extracted.push({
      name: ruleName,
      severity: 2,
      createSource,
      visitorKeys: Object.entries(tagMap).map(([key, { tags, isExit }]) => ({
        key,
        tags,
        isExit,
      })),
      messages: msgObj,
      options: plugin.meta?.defaultOptions || [],
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
