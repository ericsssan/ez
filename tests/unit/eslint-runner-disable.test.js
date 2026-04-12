"use strict";
const { applyDisableDirectives, runPlugins } = require("../../js/eslint-runner");
const { parseSource, getTagNames } = require("../../js/index");
const { test, expect } = require("bun:test");

function v(ruleId, line) {
  return { ruleId, loc: { start: { line } } };
}

test("no directives — returns violations unchanged", () => {
  const src = "const x = 1;\n";
  const violations = [v("no-unused-vars", 1)];
  expect(applyDisableDirectives(src, violations)).toEqual(violations);
});

test("eslint-disable-next-line suppresses next line", () => {
  const src = "// eslint-disable-next-line no-unused-vars\nconst x = 1;\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 2)])).toEqual([]);
});

test("eslint-disable-next-line does not suppress other rules", () => {
  const src = "// eslint-disable-next-line no-unused-vars\nconst x = 1;\n";
  const violations = [v("eqeqeq", 2)];
  expect(applyDisableDirectives(src, violations)).toEqual(violations);
});

test("eslint-disable-line suppresses same line", () => {
  const src = "const x = 1; // eslint-disable-line no-unused-vars\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 1)])).toEqual([]);
});

test("eslint-disable / eslint-enable range", () => {
  const src = [
    "/* eslint-disable no-unused-vars */",
    "const x = 1;",
    "/* eslint-enable no-unused-vars */",
    "const y = 2;",
  ].join("\n");
  const violations = [v("no-unused-vars", 2), v("no-unused-vars", 4)];
  const result = applyDisableDirectives(src, violations);
  expect(result).toHaveLength(1);
  expect(result[0].loc.start.line).toBe(4);
});

test("eslint-disable with no rule list suppresses all rules", () => {
  const src = "/* eslint-disable */\nconst x = 1;\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 2), v("eqeqeq", 2)])).toEqual([]);
});

test("global eslint-disable / eslint-enable range with no rule list", () => {
  const src = [
    "/* eslint-disable */",
    "const x = 1;",
    "/* eslint-enable */",
    "const y = 2;",
  ].join("\n");
  const violations = [v("no-unused-vars", 2), v("eqeqeq", 4)];
  const result = applyDisableDirectives(src, violations);
  expect(result).toHaveLength(1);
  expect(result[0].loc.start.line).toBe(4);
});

test("block comment eslint-disable-next-line suppresses next line", () => {
  const src = "/* eslint-disable-next-line no-unused-vars */\nconst x = 1;\n";
  expect(applyDisableDirectives(src, [v("no-unused-vars", 2)])).toEqual([]);
});

test("block comment eslint-disable-next-line does not suppress other rules", () => {
  const src = "/* eslint-disable-next-line no-unused-vars */\nconst x = 1;\n";
  const violations = [v("eqeqeq", 2)];
  expect(applyDisableDirectives(src, violations)).toEqual(violations);
});

test("empty violations returns empty array", () => {
  const src = "/* eslint-disable */\n";
  expect(applyDisableDirectives(src, [])).toEqual([]);
});

test("runPlugins passes settings to rule context", () => {
  const src = "var x = 1;";
  const ast = parseSource(src);
  const tagNames = getTagNames();
  let capturedSettings = null;
  const plugins = [{
    meta: { name: "test/capture-settings" },
    create(ctx) {
      capturedSettings = ctx.settings;
      return {};
    }
  }];
  runPlugins(ast, plugins, { tagNames, settings: { myKey: "myValue" } });
  expect(capturedSettings).toEqual({ myKey: "myValue" });
});
