"use strict";

/**
 * Validates whether getTokenAtPosition + checker.getTypeAtLocation
 * returns the correct type for expression-level ESTree nodes.
 *
 * Tests:
 *   1. Token vs expression mismatch (CallExpression, BinaryExpression, etc.)
 *   2. esTreeNodeToTSNodeMap direct access patterns (tsNode.kind, .parent)
 *   3. Position alignment across node types
 */

const path = require("path");

// Use TypeScript from the conformance test dir (user would have their own)
const tsPath = path.resolve(__dirname, "../conformance/eslint-plugin-typescript-eslint/node_modules/typescript");
const ts = require(tsPath);

// ── Test source code ─────────────────────────────────────────
const SOURCE = `
function greet(name: string): string {
  return "hello " + name;
}

const result = greet("world");

async function fetchData(): Promise<string> {
  return "data";
}

const promise = fetchData();

const arr = [1, 2, 3];
const mapped = arr.map(x => x * 2);

const obj = { a: 1, b: "hi" };
const val = obj.a;

class Foo {
  bar(): number { return 42; }
}
const foo = new Foo();
const baz = foo.bar();

const ternary = true ? "yes" : "no";

const optional: string | null = null;
const chained = optional?.length;

type MyType = { x: number };
const typed: MyType = { x: 1 };

const asExpr = (42 as unknown) as string;

const template = \`hello \${result}\`;
`;

const FILENAME = "test.ts";

// ── Create program ───────────────────────────────────────────
const compilerOptions = {
  target: ts.ScriptTarget.ESNext,
  module: ts.ModuleKind.ESNext,
  strict: true,
  lib: ["lib.esnext.d.ts"],
  noEmit: true,
};

const host = ts.createCompilerHost(compilerOptions);
const originalGetSourceFile = host.getSourceFile;
host.getSourceFile = (fileName, languageVersion, onError) => {
  if (fileName === FILENAME) {
    return ts.createSourceFile(FILENAME, SOURCE, languageVersion, true);
  }
  return originalGetSourceFile.call(host, fileName, languageVersion, onError);
};
host.readFile = (fileName) => {
  if (fileName === FILENAME) return SOURCE;
  return ts.sys.readFile(fileName);
};
host.fileExists = (fileName) => {
  if (fileName === FILENAME) return true;
  return ts.sys.fileExists(fileName);
};

const program = ts.createProgram([FILENAME], compilerOptions, host);
const sourceFile = program.getSourceFile(FILENAME);
const checker = program.getTypeChecker();

// ── Helpers ──────────────────────────────────────────────────

function getTokenAt(pos) {
  return ts.getTokenAtPosition(sourceFile, pos);
}

function typeStringAt(pos) {
  const token = getTokenAt(pos);
  const type = checker.getTypeAtLocation(token);
  return checker.typeToString(type);
}

function nodeInfoAt(pos) {
  const token = getTokenAt(pos);
  return {
    kind: ts.SyntaxKind[token.kind],
    text: token.getText(sourceFile),
    pos: token.getStart(sourceFile),
    parentKind: ts.SyntaxKind[token.parent?.kind],
  };
}

// Find position of a string in source
function posOf(str, occurrence = 0) {
  let idx = -1;
  for (let i = 0; i <= occurrence; i++) {
    idx = SOURCE.indexOf(str, idx + 1);
    if (idx === -1) throw new Error(`"${str}" occurrence ${occurrence} not found`);
  }
  return idx;
}

// ── Validation Tests ─────────────────────────────────────────
const results = [];
let passed = 0;
let failed = 0;

function test(name, pos, expected, opts = {}) {
  const token = getTokenAt(pos);
  const type = checker.getTypeAtLocation(token);
  const typeStr = checker.typeToString(type);
  const ok = expected instanceof RegExp ? expected.test(typeStr) : typeStr === expected;

  if (ok) {
    passed++;
    results.push(`  ✓ ${name}: ${typeStr}`);
  } else {
    failed++;
    const info = nodeInfoAt(pos);
    results.push(`  ✗ ${name}`);
    results.push(`    expected: ${expected}`);
    results.push(`    got:      ${typeStr}`);
    results.push(`    token:    ${info.kind} "${info.text}" (parent: ${info.parentKind})`);
  }

  if (opts.checkNode) {
    const token2 = getTokenAt(pos);
    const parentKind = ts.SyntaxKind[token2.parent?.kind];
    const hasParent = !!token2.parent;
    const canWalkUp = hasParent && token2.parent.parent != null;
    results.push(`    node access: kind=${ts.SyntaxKind[token2.kind]} parent=${parentKind} canWalkUp=${canWalkUp}`);
  }
}

console.log("\n=== Validation 1: Token vs Expression Type Resolution ===\n");
console.log("Does checker.getTypeAtLocation(token) return the expression-level type?\n");

// Call expression: greet("world") — position at "greet" identifier
// Rule expects: return type "string". Token is Identifier "greet".
// checker.getTypeAtLocation(greet) → function type? or string?
test("CallExpr: identifier 'greet' in greet(\"world\")",
  posOf('greet("world")'),
  "(name: string) => string");

// The result variable: const result = greet("world")
// Position at "result" → should be string (the variable's type)
test("VarDecl: 'result' in const result = greet(...)",
  posOf("result", 1),  // second occurrence (first is in function body)
  "string");

// Promise return: fetchData()
// Position at "fetchData" in "fetchData()" call
test("AsyncCall: 'fetchData' in fetchData()",
  posOf("fetchData()"),
  "() => Promise<string>");

// The promise variable
test("VarDecl: 'promise'",
  posOf("promise"),
  "Promise<string>");

// Binary expression: "hello " + name — position at "hello "
test("BinaryExpr: string literal in concatenation",
  posOf('"hello "'),
  '"hello "');

// Array.map: arr.map(x => x * 2) — position at "arr" in "arr.map"
test("MethodCall: 'arr' in arr.map(...)",
  posOf("arr.map"),
  "number[]");

// mapped result
test("VarDecl: 'mapped' (arr.map result)",
  posOf("mapped"),
  "number[]");

// Property access: obj.a — position at "obj" in "obj.a"
test("PropAccess: 'obj' in obj.a",
  posOf("obj.a"),
  "{ a: number; b: string; }");

// Position at "a" in "obj.a" (the property)
test("PropAccess: 'a' in obj.a",
  posOf(".a") + 1,  // skip the dot
  "number");

// val = obj.a
test("VarDecl: 'val' = obj.a",
  posOf("val"),
  "number");

// Class method call: foo.bar()
test("MethodCall: 'foo' in foo.bar()",
  posOf("foo.bar()"),
  "Foo");

test("MethodCall: 'bar' in foo.bar()",
  posOf(".bar()") + 1,
  "() => number");

test("VarDecl: 'baz' = foo.bar()",
  posOf("baz"),
  "number");

// Ternary
test("Ternary: 'ternary' = true ? yes : no",
  posOf("ternary"),
  "string");

// Optional chaining
test("OptionalChain: 'optional' in optional?.length",
  posOf("optional?."),
  "string | null");

test("OptionalChain: 'chained' = optional?.length",
  posOf("chained"),
  "number | undefined");

// Type assertion
test("TypeAssertion: 'asExpr' = (42 as unknown) as string",
  posOf("asExpr"),
  "string");

// Template literal
test("TemplateLiteral: 'template'",
  posOf("template"),
  "string");

// Typed variable
test("TypedVar: 'typed' with explicit MyType",
  posOf("typed"),
  "MyType");

console.log("\n=== Validation 2: Direct tsNode Access Patterns ===\n");
console.log("Can we walk token.parent to get expression-level nodes?\n");

// Rules that access esTreeNodeToTSNodeMap.get(node) and then inspect the ts.Node
test("DirectAccess: 'greet' — check node.parent is CallExpression?",
  posOf('greet("world")'),
  "(name: string) => string",
  { checkNode: true });

test("DirectAccess: 'foo.bar()' — check parent chain",
  posOf("foo.bar()"),
  "Foo",
  { checkNode: true });

// Test: can we find the CallExpression by walking up from token?
{
  const callPos = posOf('greet("world")');
  const token = getTokenAt(callPos);
  let node = token;
  while (node && node.kind !== ts.SyntaxKind.CallExpression) {
    node = node.parent;
  }
  if (node && node.kind === ts.SyntaxKind.CallExpression) {
    const callType = checker.typeToString(checker.getTypeAtLocation(node));
    const ok = callType === "string";
    if (ok) { passed++; results.push(`  ✓ WalkUp: token→CallExpression type = ${callType}`); }
    else { failed++; results.push(`  ✗ WalkUp: token→CallExpression type = ${callType} (expected "string")`); }
  } else {
    failed++;
    results.push(`  ✗ WalkUp: could not find CallExpression parent`);
  }
}

console.log("\n=== Validation 3: Position Alignment ===\n");
console.log("Do ESTree-style positions match getTokenAtPosition results?\n");

// Verify positions are correct for various constructs
const positionTests = [
  ["function keyword", posOf("function greet"), "function"],
  ["async keyword", posOf("async function"), "async"],
  ["class keyword", posOf("class Foo"), "class"],
  ["const keyword", posOf("const result"), "const"],
  ["arrow param", posOf("x => x"), "x"],
  ["template backtick", posOf("`hello"), "`hello ${result}`"],
  ["optional chain", posOf("optional?."), "optional"],
  ["type annotation", posOf("MyType =", 0), "MyType"],
  ["as keyword", posOf("as unknown"), "as"],
];

for (const [name, pos, expectedText] of positionTests) {
  const token = getTokenAt(pos);
  const text = token.getText(sourceFile);
  const ok = text === expectedText;
  if (ok) {
    passed++;
    results.push(`  ✓ Pos "${name}": token="${text}" at ${pos}`);
  } else {
    failed++;
    results.push(`  ✗ Pos "${name}": expected="${expectedText}" got="${text}" at ${pos} (kind=${ts.SyntaxKind[token.kind]})`);
  }
}

// ── Print Results ────────────────────────────────────────────
console.log(results.join("\n"));
console.log(`\n${passed} passed, ${failed} failed\n`);

if (failed > 0) process.exit(1);
