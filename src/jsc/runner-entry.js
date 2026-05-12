// Entry point for the JSC-embedded rule runner.
//
// Bun bundles this into a single self-contained script that gets loaded into
// each JSC context at init time. From Zig we then call `globalThis.ezLint(...)`
// to execute rules against a parsed AST buffer.
//
// We DON'T re-bundle the rule sources here — instead we pull from the
// existing build-time bundle at js/.ez-dist/rules.bundle.js (produced by
// tools/rule-transpile.js). That bundle exports `{ eslint: { rules: {...} } }`
// (plus plugin namespaces). Bun statically links it into THIS bundle when we
// require it by relative path.
//
// API:
//   globalThis.ezLint(astBuffer, sourceText, ruleNames, filename, [profile])
//     → Uint32Array  (compact diagnostics: triples of [ruleIdx, line, col])
//
//   If profile === true, ezLint also populates:
//     globalThis.__ezProfile = Float64Array(ruleNames.length)  per-rule ms
//     globalThis.__ezProfileRules = string[]                   in same order
//
//   globalThis.__ezSetTagNames(tagNames)  — call once at init

"use strict";

const { runPlugins } = require("../../js/eslint-runner.js");
const { AstView, setTagNames } = require("../../js/estree-adapter.js");

// Rules are bundled directly from the conformance vendor copy of ESLint. We
// tried using js/.ez-dist/rules.bundle.js, but Bun's CJS-wrapped bundle is
// not re-bundlable (its `(function(exports, require, module){...})` body
// has runtime `require()` calls for ez's internal helpers — fine in the
// host runtime, broken under JSC where no native `require` exists).
//
// IMPORTANT: each path must be a static string literal (no template
// literals, no variables) so Bun statically resolves it at bundle time.
const ESLINT_RULES = {
  "constructor-super": require("../../tests/conformance/eslint/lib/rules/constructor-super.js"),
  "for-direction": require("../../tests/conformance/eslint/lib/rules/for-direction.js"),
  "getter-return": require("../../tests/conformance/eslint/lib/rules/getter-return.js"),
  "no-async-promise-executor": require("../../tests/conformance/eslint/lib/rules/no-async-promise-executor.js"),
  "no-case-declarations": require("../../tests/conformance/eslint/lib/rules/no-case-declarations.js"),
  "no-class-assign": require("../../tests/conformance/eslint/lib/rules/no-class-assign.js"),
  "no-compare-neg-zero": require("../../tests/conformance/eslint/lib/rules/no-compare-neg-zero.js"),
  "no-cond-assign": require("../../tests/conformance/eslint/lib/rules/no-cond-assign.js"),
  "no-const-assign": require("../../tests/conformance/eslint/lib/rules/no-const-assign.js"),
  "no-constant-binary-expression": require("../../tests/conformance/eslint/lib/rules/no-constant-binary-expression.js"),
  "no-constant-condition": require("../../tests/conformance/eslint/lib/rules/no-constant-condition.js"),
  "no-control-regex": require("../../tests/conformance/eslint/lib/rules/no-control-regex.js"),
  "no-debugger": require("../../tests/conformance/eslint/lib/rules/no-debugger.js"),
  "no-delete-var": require("../../tests/conformance/eslint/lib/rules/no-delete-var.js"),
  "no-dupe-args": require("../../tests/conformance/eslint/lib/rules/no-dupe-args.js"),
  "no-dupe-class-members": require("../../tests/conformance/eslint/lib/rules/no-dupe-class-members.js"),
  "no-dupe-else-if": require("../../tests/conformance/eslint/lib/rules/no-dupe-else-if.js"),
  "no-dupe-keys": require("../../tests/conformance/eslint/lib/rules/no-dupe-keys.js"),
  "no-duplicate-case": require("../../tests/conformance/eslint/lib/rules/no-duplicate-case.js"),
  "no-empty": require("../../tests/conformance/eslint/lib/rules/no-empty.js"),
  "no-empty-character-class": require("../../tests/conformance/eslint/lib/rules/no-empty-character-class.js"),
  "no-empty-pattern": require("../../tests/conformance/eslint/lib/rules/no-empty-pattern.js"),
  "no-empty-static-block": require("../../tests/conformance/eslint/lib/rules/no-empty-static-block.js"),
  "no-ex-assign": require("../../tests/conformance/eslint/lib/rules/no-ex-assign.js"),
  "no-extra-boolean-cast": require("../../tests/conformance/eslint/lib/rules/no-extra-boolean-cast.js"),
  "no-fallthrough": require("../../tests/conformance/eslint/lib/rules/no-fallthrough.js"),
  "no-func-assign": require("../../tests/conformance/eslint/lib/rules/no-func-assign.js"),
  "no-global-assign": require("../../tests/conformance/eslint/lib/rules/no-global-assign.js"),
  "no-import-assign": require("../../tests/conformance/eslint/lib/rules/no-import-assign.js"),
  "no-invalid-regexp": require("../../tests/conformance/eslint/lib/rules/no-invalid-regexp.js"),
  "no-irregular-whitespace": require("../../tests/conformance/eslint/lib/rules/no-irregular-whitespace.js"),
  "no-loss-of-precision": require("../../tests/conformance/eslint/lib/rules/no-loss-of-precision.js"),
  "no-misleading-character-class": require("../../tests/conformance/eslint/lib/rules/no-misleading-character-class.js"),
  "no-new-native-nonconstructor": require("../../tests/conformance/eslint/lib/rules/no-new-native-nonconstructor.js"),
  "no-nonoctal-decimal-escape": require("../../tests/conformance/eslint/lib/rules/no-nonoctal-decimal-escape.js"),
  "no-obj-calls": require("../../tests/conformance/eslint/lib/rules/no-obj-calls.js"),
  "no-octal": require("../../tests/conformance/eslint/lib/rules/no-octal.js"),
  "no-prototype-builtins": require("../../tests/conformance/eslint/lib/rules/no-prototype-builtins.js"),
  "no-redeclare": require("../../tests/conformance/eslint/lib/rules/no-redeclare.js"),
  "no-regex-spaces": require("../../tests/conformance/eslint/lib/rules/no-regex-spaces.js"),
  "no-self-assign": require("../../tests/conformance/eslint/lib/rules/no-self-assign.js"),
  "no-setter-return": require("../../tests/conformance/eslint/lib/rules/no-setter-return.js"),
  "no-shadow-restricted-names": require("../../tests/conformance/eslint/lib/rules/no-shadow-restricted-names.js"),
  "no-sparse-arrays": require("../../tests/conformance/eslint/lib/rules/no-sparse-arrays.js"),
  "no-this-before-super": require("../../tests/conformance/eslint/lib/rules/no-this-before-super.js"),
  "no-unassigned-vars": require("../../tests/conformance/eslint/lib/rules/no-unassigned-vars.js"),
  "no-undef": require("../../tests/conformance/eslint/lib/rules/no-undef.js"),
  "no-unexpected-multiline": require("../../tests/conformance/eslint/lib/rules/no-unexpected-multiline.js"),
  "no-unreachable": require("../../tests/conformance/eslint/lib/rules/no-unreachable.js"),
  "no-unsafe-finally": require("../../tests/conformance/eslint/lib/rules/no-unsafe-finally.js"),
  "no-unsafe-negation": require("../../tests/conformance/eslint/lib/rules/no-unsafe-negation.js"),
  "no-unsafe-optional-chaining": require("../../tests/conformance/eslint/lib/rules/no-unsafe-optional-chaining.js"),
  "no-unused-labels": require("../../tests/conformance/eslint/lib/rules/no-unused-labels.js"),
  "no-unused-private-class-members": require("../../tests/conformance/eslint/lib/rules/no-unused-private-class-members.js"),
  "no-unused-vars": require("../../tests/conformance/eslint/lib/rules/no-unused-vars.js"),
  "no-useless-assignment": require("../../tests/conformance/eslint/lib/rules/no-useless-assignment.js"),
  "no-useless-backreference": require("../../tests/conformance/eslint/lib/rules/no-useless-backreference.js"),
  "no-useless-catch": require("../../tests/conformance/eslint/lib/rules/no-useless-catch.js"),
  "no-useless-escape": require("../../tests/conformance/eslint/lib/rules/no-useless-escape.js"),
  "no-with": require("../../tests/conformance/eslint/lib/rules/no-with.js"),
  "preserve-caught-error": require("../../tests/conformance/eslint/lib/rules/preserve-caught-error.js"),
  "require-yield": require("../../tests/conformance/eslint/lib/rules/require-yield.js"),
  "use-isnan": require("../../tests/conformance/eslint/lib/rules/use-isnan.js"),
  "valid-typeof": require("../../tests/conformance/eslint/lib/rules/valid-typeof.js"),
};

// Probe — Zig can JSON.stringify this to confirm bundle is wired up.
globalThis.__ezBundleInfo = {
  eslintRuleCount: Object.keys(ESLINT_RULES).length,
};

// eslint:recommended — the 65 rules in the official preset. Kept inline so
// we don't have to bundle the preset definition (it's a tiny config file).
// Source: tests/conformance/eslint/packages/js/src/configs/eslint-recommended.js
const RECOMMENDED = [
  "constructor-super",
  "for-direction",
  "getter-return",
  "no-async-promise-executor",
  "no-case-declarations",
  "no-class-assign",
  "no-compare-neg-zero",
  "no-cond-assign",
  "no-const-assign",
  "no-constant-binary-expression",
  "no-constant-condition",
  "no-control-regex",
  "no-debugger",
  "no-delete-var",
  "no-dupe-args",
  "no-dupe-class-members",
  "no-dupe-else-if",
  "no-dupe-keys",
  "no-duplicate-case",
  "no-empty",
  "no-empty-character-class",
  "no-empty-pattern",
  "no-empty-static-block",
  "no-ex-assign",
  "no-extra-boolean-cast",
  "no-fallthrough",
  "no-func-assign",
  "no-global-assign",
  "no-import-assign",
  "no-invalid-regexp",
  "no-irregular-whitespace",
  "no-loss-of-precision",
  "no-misleading-character-class",
  "no-new-native-nonconstructor",
  "no-nonoctal-decimal-escape",
  "no-obj-calls",
  "no-octal",
  "no-prototype-builtins",
  "no-redeclare",
  "no-regex-spaces",
  "no-self-assign",
  "no-setter-return",
  "no-shadow-restricted-names",
  "no-sparse-arrays",
  "no-this-before-super",
  "no-unassigned-vars",
  "no-undef",
  "no-unexpected-multiline",
  "no-unreachable",
  "no-unsafe-finally",
  "no-unsafe-negation",
  "no-unsafe-optional-chaining",
  "no-unused-labels",
  "no-unused-private-class-members",
  "no-unused-vars",
  "no-useless-assignment",
  "no-useless-backreference",
  "no-useless-catch",
  "no-useless-escape",
  "no-with",
  "preserve-caught-error",
  "require-yield",
  "use-isnan",
  "valid-typeof",
];

globalThis.__ezGetRecommended = () => RECOMMENDED.slice();

// Tag-name bridge — Zig pushes the AST tag names once at init.
globalThis.__ezSetTagNames = function (tagNames) {
  globalThis.__ez_tag_names = tagNames;
  setTagNames(tagNames);
};

// Main entry. Called once per (file, rule-subset) job.
globalThis.ezLint = function (astBuffer, sourceText, ruleNames, filename, profile) {
  // Resolve "__recommended" → full preset.
  if (ruleNames.length === 1 && ruleNames[0] === "__recommended") {
    ruleNames = RECOMMENDED;
  }

  const ast = new AstView(astBuffer);
  const tagNames = globalThis.__ez_tag_names || [];

  // Build plugin array, filter out unknown rules silently.
  const plugins = [];
  const usedRuleNames = [];
  for (const name of ruleNames) {
    const mod = ESLINT_RULES[name];
    if (!mod) continue;
    plugins.push({
      meta: { name, defaultOptions: mod.meta?.defaultOptions, schema: mod.meta?.schema },
      create: mod.create || mod,
    });
    usedRuleNames.push(name);
  }
  const ruleConfig = Object.fromEntries(usedRuleNames.map((n) => [n, "error"]));

  let reports;
  if (profile === true) {
    // Per-rule timing AND per-rule diag counts — run each plugin individually
    // so we can attribute cost and report volume. SLOWER than batched (each
    // rule rebuilds visitor map). Wall time and total diags should NOT be
    // compared between profile=true and profile=false.
    const profileBuf = new Float64Array(plugins.length);
    const diagsBuf = new Uint32Array(plugins.length);
    reports = [];
    for (let i = 0; i < plugins.length; i++) {
      const t0 = performance.now();
      const r = runPlugins(ast, [plugins[i]], {
        tagNames,
        filename: filename || "<input>",
        ruleConfig: { [plugins[i].meta.name]: "error" },
        errorBudget: Infinity,
      });
      profileBuf[i] = performance.now() - t0;
      diagsBuf[i] = r.length;
      for (const x of r) reports.push(x);
    }
    globalThis.__ezProfile = profileBuf;
    globalThis.__ezProfileDiags = diagsBuf;
    globalThis.__ezProfileRules = usedRuleNames;
  } else {
    reports = runPlugins(ast, plugins, {
      tagNames,
      filename: filename || "<input>",
      ruleConfig,
      errorBudget: Infinity,
    });
    globalThis.__ezProfile = null;
  }

  // Pack diagnostics: triples of (ruleIdxInUsedRuleNames, line, col).
  globalThis.__ezLastRuleNames = usedRuleNames;
  const ruleIdxByName = Object.create(null);
  for (let i = 0; i < usedRuleNames.length; i++) ruleIdxByName[usedRuleNames[i]] = i;

  // Optional: stash full diagnostics on globalThis for the Zig host's
  // `--dump-locs` mode to read. Cheap (just references) and only matters
  // when the host reads it back.
  globalThis.__ezLastReports = reports;

  const out = new Uint32Array(reports.length * 3);
  for (let i = 0; i < reports.length; i++) {
    const r = reports[i];
    out[i * 3 + 0] = ruleIdxByName[r.ruleId] ?? 0;
    out[i * 3 + 1] = r.line || (r.loc?.start?.line ?? 0);
    const col1 = r.column ?? r.loc?.start?.column ?? 0;
    out[i * 3 + 2] = col1 > 0 ? col1 - 1 : 0;
  }
  return out;
};
