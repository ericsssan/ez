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

test("matchesAny: positive match without negation returns true", () => {
  expect(matchesAny("/project/src/foo.js", ["**/*.js", "!node_modules/**"], "/project")).toBe(true);
});

test("matchesAny: negation overrides positive match", () => {
  // dist/keep.js matches dist/**, but the negation !dist/keep.js overrides it
  expect(matchesAny("/project/dist/keep.js", ["dist/**", "!dist/keep.js"], "/project")).toBe(false);
});

test("matchesAny: file not negated still matches positive", () => {
  expect(matchesAny("/project/dist/bundle.js", ["dist/**", "!dist/keep.js"], "/project")).toBe(true);
});

test("matchesAny: only-negation pattern array matches nothing", () => {
  expect(matchesAny("/project/src/foo.js", ["!node_modules/**"], "/project")).toBe(false);
});

// ── normalizeRules ───────────────────────────────────────────────

test("normalizeRules: strips severity, builds enabledRules Set", () => {
  const { enabledRules, ruleOptions, ruleSeverities } = normalizeRules({
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
  expect(ruleSeverities["no-console"]).toBe(2);
  expect(ruleSeverities["no-unused-vars"]).toBe(1);
  expect(ruleSeverities["eqeqeq"]).toBeUndefined();
});

test("normalizeRules: numeric severity values", () => {
  const { ruleSeverities } = normalizeRules({
    "rule-a": 2,
    "rule-b": 1,
    "rule-c": ["error"],
    "rule-d": ["warning"],
  });
  expect(ruleSeverities["rule-a"]).toBe(2);
  expect(ruleSeverities["rule-b"]).toBe(1);
  expect(ruleSeverities["rule-c"]).toBe(2);
  expect(ruleSeverities["rule-d"]).toBe(1);
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

// ── ConfigResolver ───────────────────────────────────────────────

const { ConfigResolver } = require("../../js/config-loader");

test("resolveForFile: no files: key applies globally", () => {
  const flat = [{ rules: { "no-console": "error" } }];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result).not.toBeNull();
  expect(result.rules["no-console"]).toBe("error");
});

test("resolveForFile: files: glob filters correctly", () => {
  const flat = [
    { files: ["**/*.ts"], rules: { "@typescript-eslint/no-explicit-any": "error" } },
    { rules: { "no-console": "warn" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");

  const tsResult = resolver.resolveForFile("/project/src/foo.ts");
  expect(tsResult.rules["@typescript-eslint/no-explicit-any"]).toBe("error");
  expect(tsResult.rules["no-console"]).toBe("warn");

  const jsResult = resolver.resolveForFile("/project/src/bar.js");
  expect(jsResult.rules["@typescript-eslint/no-explicit-any"]).toBeUndefined();
  expect(jsResult.rules["no-console"]).toBe("warn");
});

test("resolveForFile: global ignores returns null", () => {
  const flat = [
    { ignores: ["dist/**"] },
    { rules: { "no-console": "error" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  expect(resolver.resolveForFile("/project/dist/bundle.js")).toBeNull();
  expect(resolver.resolveForFile("/project/src/foo.js")).not.toBeNull();
});

test("resolveForFile: later entries override earlier ones", () => {
  const flat = [
    { rules: { "no-console": "warn" } },
    { rules: { "no-console": "error" } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result.rules["no-console"]).toBe("error");
});

test("resolveForFile: merges plugins from multiple entries", () => {
  const pluginA = { rules: { "rule-a": { create: () => ({}) } } };
  const pluginB = { rules: { "rule-b": { create: () => ({}) } } };
  const flat = [
    { plugins: { a: pluginA } },
    { plugins: { b: pluginB } },
  ];
  const resolver = new ConfigResolver(flat, "/project");
  const result = resolver.resolveForFile("/project/src/foo.js");
  expect(result.plugins.a).toBe(pluginA);
  expect(result.plugins.b).toBe(pluginB);
});

// ── detectConfigFile ─────────────────────────────────────────────

const os = require("os");
const { detectConfigFile } = require("../../js/config-loader");

test("detectConfigFile: finds eslint.config.js (flat)", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, "eslint.config.js"), "module.exports = [];");
  try {
    const result = detectConfigFile(tmp);
    expect(result).not.toBeNull();
    expect(result.type).toBe("flat");
    expect(result.path).toBe(path.join(tmp, "eslint.config.js"));
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: finds .eslintrc.json (legacy)", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), JSON.stringify({ root: true, rules: {} }));
  try {
    const result = detectConfigFile(tmp);
    expect(result).not.toBeNull();
    expect(result.type).toBe("legacy");
    expect(result.paths).toHaveLength(1);
    expect(result.paths[0]).toBe(path.join(tmp, ".eslintrc.json"));
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: flat config takes priority over legacy in same dir", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  fs.writeFileSync(path.join(tmp, "eslint.config.js"), "module.exports = [];");
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), "{}");
  try {
    const result = detectConfigFile(tmp);
    expect(result.type).toBe("flat");
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});

test("detectConfigFile: legacy cascades until root:true", () => {
  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "ez-test-"));
  const sub = path.join(tmp, "sub");
  fs.mkdirSync(sub);
  fs.writeFileSync(path.join(tmp, ".eslintrc.json"), JSON.stringify({ root: true, rules: { "no-console": "error" } }));
  fs.writeFileSync(path.join(sub, ".eslintrc.json"), JSON.stringify({ rules: { semi: "warn" } }));
  try {
    const result = detectConfigFile(sub);
    expect(result.type).toBe("legacy");
    expect(result.paths).toHaveLength(2);
    expect(result.paths[0]).toBe(path.join(tmp, ".eslintrc.json")); // outermost first
    expect(result.paths[1]).toBe(path.join(sub, ".eslintrc.json")); // innermost last
  } finally {
    fs.rmSync(tmp, { recursive: true });
  }
});
