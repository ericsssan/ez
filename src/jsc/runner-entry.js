// Entry point for the JSC-embedded rule runner.
//
// Bun bundles this into a single self-contained script that gets loaded into
// each JSC context at init time. From Zig we then call `globalThis.ezLint(...)`
// to execute rules against a parsed AST buffer.
//
// What we expose:
//   globalThis.ezLint(astBuffer: ArrayBuffer, source: string, ruleNames: string[]) => Uint32Array
//
// The returned Uint32Array is a compact diagnostic format:
//   [count, (ruleIdIdx, line, col)*count, ruleId_strings_offset, ruleId_strings_bytes...]
//   For Phase 1 we'll keep it even simpler: triples of (ruleIdIdx, line, col).

"use strict";

const { runPlugins } = require("../../js/eslint-runner.js");
const { AstView, setTagNames } = require("../../js/estree-adapter.js");

// All available rules, lazy-loaded. For Phase 1 we only ship a few; the full
// bundle will pull in all core rules in Phase 2.
const RULE_MODULES = {
  "no-debugger": require("../../tests/conformance/eslint/lib/rules/no-debugger.js"),
};

// Zig pushes tag names once at init via globalThis.__ezSetTagNames(arr).
// We store them on globalThis AND propagate to the adapter.
globalThis.__ezSetTagNames = function (tagNames) {
  globalThis.__ez_tag_names = tagNames;
  setTagNames(tagNames);
};

// Main entry point. Called once per (file, rule-subset) job.
// tagNames may be passed as the 5th arg as a fallback (init path); if absent
// we read from globalThis.__ez_tag_names (set by __ezSetTagNames).
globalThis.ezLint = function (astBuffer, sourceText, ruleNames, filename, tagNamesOverride) {
  const ast = new AstView(astBuffer);
  const tagNames = tagNamesOverride || globalThis.__ez_tag_names || [];

  const plugins = [];
  for (const name of ruleNames) {
    const mod = RULE_MODULES[name];
    if (!mod) continue; // unknown rule — skip silently in Phase 1
    plugins.push({
      meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
      create: mod.create || mod,
    });
  }

  const ruleConfig = Object.fromEntries(ruleNames.map((n) => [n, "error"]));

  const reports = runPlugins(ast, plugins, {
    tagNames,
    filename: filename || "<input>",
    ruleConfig,
    errorBudget: Infinity,
  });

  // Pack into a flat Uint32Array of triples: (ruleIdIdx, line, col).
  // Phase 1: ignore ruleIds (we know it's all one rule). Phase 2: encode index.
  const out = new Uint32Array(reports.length * 3);
  for (let i = 0; i < reports.length; i++) {
    const r = reports[i];
    out[i * 3 + 0] = 0; // ruleIdIdx — unused for Phase 1
    out[i * 3 + 1] = r.line || (r.loc?.start?.line ?? 0);
    out[i * 3 + 2] = (r.column ?? r.loc?.start?.column ?? 0) - 1; // 0-based
  }
  return out;
};
