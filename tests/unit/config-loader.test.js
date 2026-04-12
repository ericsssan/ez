"use strict";
const { test, expect } = require("bun:test");
const path = require("path");
const fs = require("fs");
const { matchesAny, normalizeRules, pluginsFromConfig } = require("../../js/config-loader");

// ── matchesAny ───────────────────────────────────────────────────

test("matchesAny: relative glob matches", () => {
  const base = "/project";
  expect(matchesAny("/project/src/foo.js", ["src/**/*.js"], base)).toBe(true);
});

test("matchesAny: no match returns false", () => {
  const base = "/project";
  expect(matchesAny("/project/src/foo.ts", ["src/**/*.js"], base)).toBe(false);
});

test("matchesAny: absolute pattern matches absolute path", () => {
  expect(matchesAny("/project/dist/foo.js", ["**/dist/**"], "/project")).toBe(true);
});

// ── normalizeRules ───────────────────────────────────────────────

test("normalizeRules: strips severity, builds enabledRules Set", () => {
  const { enabledRules, ruleOptions } = normalizeRules({
    "no-console": "error",
    "no-unused-vars": ["warn", { vars: "all" }],
    "eqeqeq": 0,
    "semi": "off",
  });
  expect(enabledRules.has("no-console")).toBe(true);
  expect(enabledRules.has("no-unused-vars")).toBe(true);
  expect(enabledRules.has("eqeqeq")).toBe(false);
  expect(enabledRules.has("semi")).toBe(false);
  expect(ruleOptions["no-console"]).toEqual([]);
  expect(ruleOptions["no-unused-vars"]).toEqual([{ vars: "all" }]);
});

test("normalizeRules: empty input returns empty results", () => {
  const { enabledRules, ruleOptions } = normalizeRules({});
  expect(enabledRules.size).toBe(0);
  expect(Object.keys(ruleOptions)).toHaveLength(0);
});

// ── pluginsFromConfig ────────────────────────────────────────────

test("pluginsFromConfig: extracts enabled rules from plugin map", () => {
  const pluginsMap = {
    react: {
      rules: {
        "jsx-key": { create: () => ({}), meta: { fixable: null } },
        "no-direct-mutation-state": { create: () => ({}), meta: {} },
      }
    }
  };
  const enabledRules = new Set(["react/jsx-key"]);
  const result = pluginsFromConfig(pluginsMap, enabledRules);
  expect(result).toHaveLength(1);
  expect(result[0].meta.name).toBe("react/jsx-key");
  expect(typeof result[0].create).toBe("function");
});

test("pluginsFromConfig: skips rules not in enabledRules", () => {
  const pluginsMap = {
    react: { rules: { "jsx-key": { create: () => ({}) } } }
  };
  const result = pluginsFromConfig(pluginsMap, new Set());
  expect(result).toHaveLength(0);
});

test("pluginsFromConfig: ruleFilter narrows further", () => {
  const pluginsMap = {
    react: {
      rules: {
        "jsx-key": { create: () => ({}) },
        "no-direct-mutation-state": { create: () => ({}) },
      }
    }
  };
  const enabledRules = new Set(["react/jsx-key", "react/no-direct-mutation-state"]);
  const result = pluginsFromConfig(pluginsMap, enabledRules, new Set(["jsx-key"]));
  expect(result).toHaveLength(1);
  expect(result[0].meta.name).toBe("react/jsx-key");
});
