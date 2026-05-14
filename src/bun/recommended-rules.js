// Static rule-module map for the standalone `ezlint` binary.
//
// Why static requires (instead of api.js's loadCoreRules which goes through
// js/.ez-dist/rules.bundle.js)?
//
// `bun build --compile` bundles the static dependency graph into a single
// executable.  loadCoreRules uses dynamic paths
// (`require(path.join(BUNDLED_RULES_DIR, file))`) that the bundler can't
// follow.  Pre-built rules.bundle.js works for `bun run` from a checkout
// (the runtime walks /node_modules), but the standalone binary has no
// /node_modules at runtime so its transitive requires (eslint, espree,
// eslint/use-at-your-own-risk, ...) fail.
//
// Each `require(...)` below is statically resolvable, so `bun build`
// follows the rule's source file plus its real transitive deps and inlines
// them into the binary.  The cost of duplication (this file mirrors the
// 64 entries of ESLINT_RECOMMENDED in src/bun/lint.js) is one short list
// vs. the alternative of bundling every plugin in the bundle.

"use strict";

const RULE_MODULES = {
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

// Convert each module into the {meta, create} descriptor shape api.js wants.
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

const DESCRIPTORS = Object.entries(RULE_MODULES)
  .map(([name, mod]) => _toDescriptor(name, mod))
  .filter(Boolean);

module.exports = { DESCRIPTORS, RULE_NAMES: Object.keys(RULE_MODULES) };
