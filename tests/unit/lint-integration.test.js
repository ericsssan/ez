"use strict";
const { test, expect } = require("bun:test");
const path = require("path");
const { parse, getTagNames } = require("../../js/index");
const { runPlugins, applyDisableDirectives } = require("../../js/eslint-runner");
const { loadConfig, normalizeRules, pluginsFromConfig } = require("../../js/config-loader");
const { loadCoreRules } = require("../../js/load-plugin");

const FLAT_FIXTURE_SRC = path.resolve(__dirname, "../fixtures/eslint-config-flat/src/index.js");
const LEGACY_FIXTURE_SRC = path.resolve(__dirname, "../fixtures/eslint-config-legacy/src/index.js");
const FLAT_FIXTURE_DIR = path.resolve(__dirname, "../fixtures/eslint-config-flat");
const LEGACY_FIXTURE_DIR = path.resolve(__dirname, "../fixtures/eslint-config-legacy");

async function lintFile(configDir, filePath) {
  const configResolver = await loadConfig(configDir);
  expect(configResolver).not.toBeNull();

  const fileConfig = configResolver.resolveForFile(filePath);
  expect(fileConfig).not.toBeNull();

  const { enabledRules, ruleOptions } = normalizeRules(fileConfig.rules);
  const fromConfig = pluginsFromConfig(fileConfig.plugins, enabledRules);
  const bareNames = new Set([...enabledRules].filter(n => !n.includes("/")));
  const plugins = [...fromConfig, ...(bareNames.size > 0 ? loadCoreRules({ only: bareNames }) : [])];

  const ast = parse(filePath);
  const tagNames = getTagNames();
  const jsReports = runPlugins(ast, plugins, {
    filename: filePath, tagNames, ruleConfig: ruleOptions, settings: fileConfig.settings,
  });

  return applyDisableDirectives(ast.source, jsReports);
}

test("flat config: reports 2 violations, suppresses 1 disable-next-line", async () => {
  const violations = await lintFile(FLAT_FIXTURE_DIR, FLAT_FIXTURE_SRC);
  expect(violations).toHaveLength(2);
  const ruleIds = violations.map(v => v.ruleId).sort();
  expect(ruleIds).toContain("no-console");
  expect(ruleIds).toContain("eqeqeq");
  // Confirm suppressed line (line 2) is not reported
  expect(violations.every(v => v.loc?.start?.line !== 2)).toBe(true);
});

test("legacy config: reports 2 violations, suppresses 1 disable-next-line", async () => {
  const violations = await lintFile(LEGACY_FIXTURE_DIR, LEGACY_FIXTURE_SRC);
  expect(violations).toHaveLength(2);
  const ruleIds = violations.map(v => v.ruleId).sort();
  expect(ruleIds).toContain("no-console");
  expect(ruleIds).toContain("eqeqeq");
  expect(violations.every(v => v.loc?.start?.line !== 2)).toBe(true);
});
