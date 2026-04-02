"use strict";
/**
 * Rule loader: extracts ESLint rule handler source code and metadata,
 * serializes to JSON for the Zig interpreter.
 *
 * Usage:
 *   const { extractRules } = require('./rule-loader');
 *   const { json, extractedNames, remainingPlugins } = extractRules(plugins, tagNames);
 *   native.loadRules(json);
 */

const { T } = require("./tags");

// ── ESTree type name → sanz tag ordinal(s) ──────────────────────
// One ESTree visitor key may map to multiple sanz tags.
// e.g., "BinaryExpression" → [add, subtract, multiply, ..., equal, not_equal, ...]

const ESTREE_TO_TAGS = {};

function buildTagMap(tagNames) {
  // tagNames[i] = ESTree type name for sanz tag i
  // Build reverse: ESTree name → [tag ordinals]
  for (let i = 0; i < tagNames.length; i++) {
    const name = tagNames[i];
    if (!name) continue;
    if (!ESTREE_TO_TAGS[name]) ESTREE_TO_TAGS[name] = [];
    ESTREE_TO_TAGS[name].push(i);
  }
}

// ── Handler source extraction ───────────────────────────────────

/**
 * Check if a handler function can be interpreted by Zig.
 * Phase 1: only accept simple handlers (no complex closures, no external calls).
 */
function canExtract(handlerSource) {
  // Extract handlers that use only:
  //   - node property access (node.type, node.kind, node.operator, etc.)
  //   - string/number comparisons (===, !==)
  //   - if/else, return, logical operators (&&, ||, !)
  //   - context.report()
  // Reject handlers that use closure variables, loops, scope/token APIs,
  // helper function calls, or complex patterns.

  // Extract handlers that the Zig interpreter can evaluate:
  // - Node property access (node.type, node.kind, node.operator, etc.)
  // - String/number comparisons (===, !==, ==, !=)
  // - If/else, return, logical operators (&&, ||, !)
  // - context.report()
  // Reject: closures, loops, scope/token APIs, helper functions.

  if (!handlerSource.includes("context.report")) return false;

  // ── Unsupported APIs ──
  if (handlerSource.includes("getScope")) return false;
  if (handlerSource.includes("getDeclaredVariables")) return false;
  if (handlerSource.includes("getToken")) return false;
  if (handlerSource.includes("getComments")) return false;
  if (handlerSource.includes("getText(")) return false;
  if (handlerSource.includes("getAncestors")) return false;
  if (handlerSource.includes("markVariableAsUsed")) return false;
  if (handlerSource.includes(".fix")) return false;
  if (handlerSource.includes("suggest")) return false;
  if (handlerSource.includes("try {")) return false;
  if (handlerSource.includes("catch ")) return false;
  if (handlerSource.includes("require(")) return false;

  // ── Unsupported control flow ──
  if (handlerSource.includes("for ") || handlerSource.includes("for(")) return false;
  if (handlerSource.includes("while")) return false;
  if (handlerSource.includes("switch")) return false;
  if (handlerSource.includes(".forEach")) return false;
  if (handlerSource.includes(".filter")) return false;
  if (handlerSource.includes(".map(")) return false;
  if (handlerSource.includes(".some(")) return false;
  if (handlerSource.includes(".every(")) return false;

  // ── Reject closure function calls ──
  const body = handlerSource.replace(/^[^{]*\{/, "{");
  const calls = body.match(/(?<![.\w"'])([a-zA-Z_]\w*)\s*\(/g) || [];
  for (const call of calls) {
    const name = call.replace(/\s*\($/, "");
    if (["context", "node", "report", "sourceCode",
         "String", "Number", "Boolean", "Array", "Object", "Math", "JSON",
         "parseInt", "parseFloat", "isNaN", "isFinite", "RegExp",
         "typeof", "instanceof", "delete", "void", "new",
         "if", "else", "return", "throw", "function"].includes(name)) continue;
    return false;
  }

  return true;
}

/**
 * Extract the function body from handler.toString().
 * Strips the function wrapper: "function(node) { ... }" → "{ ... }"
 * Or arrow: "(node) => { ... }" → "{ ... }"
 */
function extractBody(fnStr) {
  // Arrow with block body: (node) => { ... } or node => { ... }
  const arrowBlock = fnStr.match(/^(?:\(?\w*\)?\s*=>\s*)(\{[\s\S]*\})$/);
  if (arrowBlock) return arrowBlock[1];

  // Arrow with expression body: (node) => expr → { return expr; }
  const arrowExpr = fnStr.match(/^(?:\(?\w*\)?\s*=>\s*)([\s\S]+)$/);
  if (arrowExpr && !arrowExpr[1].startsWith("{")) {
    return "{ return " + arrowExpr[1] + "; }";
  }

  // Regular function: function(node) { ... } or function name(node) { ... }
  const funcMatch = fnStr.match(/^function\s*\w*\s*\([^)]*\)\s*(\{[\s\S]*\})$/);
  if (funcMatch) return funcMatch[1];

  // Method shorthand: name(node) { ... }
  const methodMatch = fnStr.match(/^\w+\s*\([^)]*\)\s*(\{[\s\S]*\})$/);
  if (methodMatch) return methodMatch[1];

  // Fallback: wrap in block
  return "{ " + fnStr + " }";
}

/**
 * Extract rules from loaded ESLint plugins.
 * Returns JSON for Zig + set of extracted rule names + remaining plugins for JS fallback.
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
    const messages = plugin.meta?.messages || (plugin.create.length > 0 ? {} : {});

    // Create a mock context that captures visitor registrations
    let visitors = null;
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
      visitors = plugin.create(mockContext);
    } catch {
      // Rule's create() failed — keep in JS fallback
      remainingPlugins.push(plugin);
      continue;
    }

    if (!visitors || typeof visitors !== "object") {
      remainingPlugins.push(plugin);
      continue;
    }

    // Check if ALL visitors can be extracted
    let allExtractable = true;
    const visitorDescs = [];

    for (const [key, handler] of Object.entries(visitors)) {
      if (typeof handler !== "function") continue;

      const isExit = key.endsWith(":exit");
      const typeName = isExit ? key.slice(0, -5) : key;

      // Map ESTree type to sanz tags
      const tags = ESTREE_TO_TAGS[typeName];
      if (!tags || tags.length === 0) {
        // Unknown ESTree type (might be a selector) — can't extract
        allExtractable = false;
        break;
      }

      // Get handler source
      const src = handler.toString();
      if (!canExtract(src, null)) {
        allExtractable = false;
        break;
      }

      const body = extractBody(src);
      visitorDescs.push({
        tags,
        isExit,
        source: body,
      });
    }

    if (allExtractable && visitorDescs.length > 0) {
      // Get message templates from rule meta
      let msgObj = {};
      try {
        const ruleMod = require("./node_modules/eslint/lib/rules/" + ruleName);
        if (ruleMod?.meta?.messages) msgObj = ruleMod.meta.messages;
      } catch {
        // Not an ESLint core rule — try plugin.meta
        if (plugin.meta?.messages) msgObj = plugin.meta.messages;
      }

      extracted.push({
        name: ruleName,
        severity: 2, // error by default
        visitors: visitorDescs,
        messages: msgObj,
      });
      extractedNames.add(ruleName);
    } else {
      remainingPlugins.push(plugin);
    }
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
