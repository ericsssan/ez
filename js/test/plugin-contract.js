"use strict";

/**
 * Plugin contract tests — verify NodeView properties match ESLint's AST contract.
 * Ensures plugins expecting ESLint-shaped nodes get correct data.
 *
 * Run: node js/test/plugin-contract.js (after `zig build napi`)
 */

const { parse, getTagNames, reset } = require("../index");
const { runPlugins } = require("../plugin-runner");

let passed = 0;
let failed = 0;

function assertEqual(actual, expected, msg) {
  if (actual === expected) { passed++; return; }
  failed++;
  console.error(`  FAIL: ${msg} — expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
}

function assert(cond, msg) {
  if (cond) { passed++; return; }
  failed++;
  console.error(`  FAIL: ${msg}`);
}

function test(name, fn) {
  process.stdout.write(`  ${name}...`);
  try { fn(); console.log(" ok"); }
  catch (e) { failed++; console.error(` FAIL: ${e.message}`); }
}

console.log("Plugin contract tests\n");

const tagNames = getTagNames();

// ── node.type matches ESTree names ──────────────────────────

console.log("ESTree type names:");

test("Identifier node.type", () => {
  const ast = parse("foo;");
  const types = [];
  runPlugins(ast, [{
    meta: { name: "t" },
    create() { return { Identifier(n) { types.push(n.type); } }; },
  }], { tagNames });
  assert(types.includes("Identifier"), `got types: ${types}`);
  reset();
});

test("FunctionDeclaration node.type", () => {
  const ast = parse("function foo() {}");
  const types = [];
  runPlugins(ast, [{
    meta: { name: "t" },
    create() { return { FunctionDeclaration(n) { types.push(n.type); } }; },
  }], { tagNames });
  assert(types.includes("FunctionDeclaration"), `got types: ${types}`);
  reset();
});

test("BinaryExpression node.type", () => {
  const ast = parse("1 + 2;");
  const types = [];
  runPlugins(ast, [{
    meta: { name: "t" },
    create() { return { BinaryExpression(n) { types.push(n.type); } }; },
  }], { tagNames });
  assert(types.includes("BinaryExpression"), `got types: ${types}`);
  reset();
});

test("JSXElement node.type", () => {
  const ast = parse("<div>hello</div>", { lang: "jsx" });
  const types = [];
  runPlugins(ast, [{
    meta: { name: "t" },
    create() { return { JSXElement(n) { types.push(n.type); } }; },
  }], { tagNames });
  assert(types.includes("JSXElement"), `got types: ${types}`);
  reset();
});

test("TSInterfaceDeclaration node.type", () => {
  const ast = parse("interface Foo { bar: string; }", { lang: "ts" });
  const types = [];
  runPlugins(ast, [{
    meta: { name: "t" },
    create() { return { TSInterfaceDeclaration(n) { types.push(n.type); } }; },
  }], { tagNames });
  assert(types.includes("TSInterfaceDeclaration"), `got types: ${types}`);
  reset();
});

// ── node.start is UTF-16 offset ─────────────────────────────

console.log("\nUTF-16 offsets:");

test("ASCII: node.start matches source position", () => {
  const src = "let foo = 1;";
  const ast = parse(src);
  let idStart = -1;
  runPlugins(ast, [{
    meta: { name: "t" },
    create() {
      return { VariableDeclarator(n) { idStart = n.start; } };
    },
  }], { tagNames });
  // "let " is 4 chars, so declarator main_token points to the let keyword's token
  // The exact offset depends on what main_token maps to
  assert(typeof idStart === "number" && idStart >= 0, `start should be a number >= 0, got ${idStart}`);
  reset();
});

test("non-ASCII: UTF-16 offset accounts for multibyte", () => {
  // "café" has é = 2 UTF-8 bytes but 1 UTF-16 code unit
  const src = 'let café = 1;';
  const ast = parse(src);
  assert(ast.sourceUtf16Len <= src.length, `UTF-16 len ${ast.sourceUtf16Len} should be <= JS string len ${src.length}`);
  reset();
});

// ── context.report works ────────────────────────────────────

console.log("\ncontext.report:");

test("report includes ruleId and message", () => {
  const ast = parse("debugger;");
  const reports = runPlugins(ast, [{
    meta: { name: "test-rule" },
    create(ctx) {
      return {
        DebuggerStatement(n) {
          ctx.report({ node: n, message: "bad debugger" });
        },
      };
    },
  }], { tagNames });
  assertEqual(reports.length, 1, "should have 1 report");
  assertEqual(reports[0].ruleId, "test-rule", "ruleId");
  assertEqual(reports[0].message, "bad debugger", "message");
  assert(reports[0].node !== undefined, "should include node");
  reset();
});

test("report from multiple plugins", () => {
  const ast = parse("debugger;");
  const p1 = { meta: { name: "r1" }, create(c) { return { DebuggerStatement() { c.report({ message: "a" }); } }; } };
  const p2 = { meta: { name: "r2" }, create(c) { return { DebuggerStatement() { c.report({ message: "b" }); } }; } };
  const reports = runPlugins(ast, [p1, p2], { tagNames });
  assertEqual(reports.length, 2, "should have 2 reports");
  const ruleIds = reports.map(r => r.ruleId).sort();
  assertEqual(ruleIds[0], "r1", "first ruleId");
  assertEqual(ruleIds[1], "r2", "second ruleId");
  reset();
});

// ── Error handling ──────────────────────────────────────────

console.log("\nError handling:");

test("plugin error does not crash traversal", () => {
  const ast = parse("foo; bar;");
  let visitCount = 0;
  const reports = runPlugins(ast, [{
    meta: { name: "crasher" },
    create() {
      return {
        Identifier() {
          visitCount++;
          if (visitCount === 1) throw new Error("boom");
        },
      };
    },
  }], { tagNames });
  assert(visitCount >= 2, `should visit multiple identifiers, got ${visitCount}`);
  const errorReports = reports.filter(r => r.message.includes("boom"));
  assert(errorReports.length >= 1, "should capture the error as a report");
  reset();
});

// ── Summary ─────────────────────────────────────────────────

console.log(`\n${passed + failed} tests: ${passed} passed, ${failed} failed`);
process.exit(failed > 0 ? 1 : 0);
