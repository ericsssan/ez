"use strict";

/**
 * Integration tests for the sanz JS bindings.
 * Run with: node js/test/test.js (after `zig build napi`)
 * Or:       bun js/test/test.js
 */

const { parse, reset, getTagNames, MAGIC, HEADER_SIZE } = require("../index");
const { runPlugins } = require("../plugin-runner");

let passed = 0;
let failed = 0;

function assert(condition, message) {
  if (condition) {
    passed++;
  } else {
    failed++;
    console.error(`  FAIL: ${message}`);
  }
}

function assertEqual(actual, expected, message) {
  if (actual === expected) {
    passed++;
  } else {
    failed++;
    console.error(`  FAIL: ${message} — expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

function test(name, fn) {
  process.stdout.write(`  ${name}...`);
  try {
    fn();
    console.log(" ok");
  } catch (err) {
    failed++;
    console.error(` FAIL: ${err.message}`);
  }
}

// ── Tests ────────────────────────────────────────────────────────

console.log("sanz JS integration tests\n");

// Tag names
console.log("Tag names:");
test("getTagNames returns array", () => {
  const names = getTagNames();
  assert(Array.isArray(names), "should be an array");
  assert(names.length > 100, `should have >100 tags, got ${names.length}`);
  assertEqual(names[0], "Program", "first tag should be Program");
});

// Parse basic JS
console.log("\nParse:");
test("parse simple expression", () => {
  const ast = parse("const x = 1;");
  assert(ast.nodeCount > 0, "should have nodes");
  assert(ast.tokenCount > 0, "should have tokens");
  assertEqual(ast.hasBOM, false, "no BOM");
});

test("parse returns AstView with source", () => {
  const ast = parse("let y = 2;");
  assertEqual(ast.source, "let y = 2;", "source should match");
});

test("parse with language option", () => {
  const ast = parse("const x: number = 1;", { lang: "ts" });
  assert(ast.nodeCount > 0, "should parse TS");
});

test("parse with filename detection", () => {
  const ast = parse("const x: number = 1;", { filename: "test.ts" });
  assert(ast.nodeCount > 0, "should detect TS from filename");
});

// NodeView
console.log("\nNodeView:");
test("root node is Program", () => {
  const tagNames = getTagNames();
  const ast = parse("const x = 1;");
  const root = ast.root();
  assertEqual(root.tag, 0, "root tag should be 0");
  assertEqual(tagNames[root.tag], "Program", "root should be Program");
});

test("node properties", () => {
  const ast = parse("const x = 1;");
  const root = ast.root();
  assert(root.mainToken !== undefined, "should have mainToken");
  assert(root.lhs !== undefined, "should have lhs");
  assert(root.rhs !== undefined, "should have rhs");
  assert(typeof root.start === "number", "start should be a number");
});

// Buffer reuse
console.log("\nBuffer reuse:");
test("parse multiple files with same buffer", () => {
  for (let i = 0; i < 10; i++) {
    const ast = parse(`const x${i} = ${i};`);
    assert(ast.nodeCount > 0, `file ${i} should parse`);
    reset();
  }
});

// Plugin runner
console.log("\nPlugin runner:");
test("plugin visits nodes", () => {
  const tagNames = getTagNames();
  const ast = parse("debugger; debugger;");

  let count = 0;
  const plugin = {
    meta: { name: "count-debugger" },
    create(context) {
      return {
        DebuggerStatement(node) {
          count++;
          context.report({ node, message: "found debugger" });
        },
      };
    },
  };

  const reports = runPlugins(ast, [plugin], { tagNames });
  assertEqual(count, 2, "should visit 2 debugger statements");
  assertEqual(reports.length, 2, "should have 2 reports");
  assertEqual(reports[0].ruleId, "count-debugger", "ruleId should match");
});

test("plugin visits identifiers", () => {
  const tagNames = getTagNames();
  const ast = parse("const foo = bar + baz;");

  const identifiers = [];
  const plugin = {
    meta: { name: "collect-ids" },
    create() {
      return {
        Identifier(node) {
          identifiers.push(node.start);
        },
      };
    },
  };

  runPlugins(ast, [plugin], { tagNames });
  assert(identifiers.length >= 3, `should find >=3 identifiers, got ${identifiers.length}`);
});

test("multiple plugins run together", () => {
  const tagNames = getTagNames();
  const ast = parse("debugger; const x = 1;");

  const plugin1 = {
    meta: { name: "p1" },
    create(ctx) {
      return { DebuggerStatement() { ctx.report({ message: "p1" }); } };
    },
  };
  const plugin2 = {
    meta: { name: "p2" },
    create(ctx) {
      return { VariableDeclaration() { ctx.report({ message: "p2" }); } };
    },
  };

  const reports = runPlugins(ast, [plugin1, plugin2], { tagNames });
  const p1Reports = reports.filter(r => r.ruleId === "p1");
  const p2Reports = reports.filter(r => r.ruleId === "p2");
  assert(p1Reports.length >= 1, "p1 should fire");
  assert(p2Reports.length >= 1, "p2 should fire");
});

// Reset
console.log("\nReset:");
test("reset clears pool references", () => {
  parse("const a = 1;");
  reset();
  // After reset, parsing again should work fine
  const ast = parse("const b = 2;");
  assert(ast.nodeCount > 0, "should parse after reset");
});

// ── Summary ─────────────────────────────────────────────────────

console.log(`\n${passed + failed} tests: ${passed} passed, ${failed} failed`);
process.exit(failed > 0 ? 1 : 0);
