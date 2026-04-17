"use strict";

/**
 * Validates span-based ts.Node resolution:
 *   getTokenAtPosition(start) → walk up → match by [start, end] span
 *
 * This is the proposed bridge for Ez's getTypeAtLocation.
 */

const path = require("path");
const tsPath = path.resolve(__dirname, "../conformance/eslint-plugin-typescript-eslint/node_modules/typescript");
const ts = require(tsPath);

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

const x = 1 + 2;
const y = "a" + "b";

const ternary = true ? "yes" : "no";

const optional: string | null = "hello";
const chained = optional?.length;

const asExpr = (42 as unknown) as string;

const template = \`hello \${result}\`;

interface User { name: string; age: number; }
function getUser(): User { return { name: "a", age: 1 }; }
const user = getUser();
const userName = user.name;

const nums = [1, 2, 3];
const found = nums.find(n => n > 1);

const casted = found!;
`;

const FILENAME = "test.ts";

const compilerOptions = {
  target: ts.ScriptTarget.ESNext,
  module: ts.ModuleKind.ESNext,
  strict: true,
  lib: ["lib.esnext.d.ts"],
  noEmit: true,
};

const host = ts.createCompilerHost(compilerOptions);
const origGetSourceFile = host.getSourceFile;
host.getSourceFile = (fn, lv, onErr) =>
  fn === FILENAME ? ts.createSourceFile(FILENAME, SOURCE, lv, true) : origGetSourceFile.call(host, fn, lv, onErr);
host.readFile = (fn) => fn === FILENAME ? SOURCE : ts.sys.readFile(fn);
host.fileExists = (fn) => fn === FILENAME ? true : ts.sys.fileExists(fn);

const program = ts.createProgram([FILENAME], compilerOptions, host);
const sourceFile = program.getSourceFile(FILENAME);
const checker = program.getTypeChecker();

// ── The bridge function ──────────────────────────────────────
function findTsNodeForSpan(start, end) {
  const token = ts.getTokenAtPosition(sourceFile, start);
  let node = token;
  let best = token;
  while (node) {
    const nodeStart = node.getStart(sourceFile);
    // Stop if node starts before our target (we've gone too high)
    if (nodeStart < start) break;
    // This node starts at our position — check if its end is closer to target end
    if (Math.abs(node.end - end) <= Math.abs(best.end - end)) {
      best = node;
    }
    node = node.parent;
  }
  return best;
}

function bridgedGetType(start, end) {
  const tsNode = findTsNodeForSpan(start, end);
  return checker.getTypeAtLocation(tsNode);
}

function bridgedTypeString(start, end) {
  return checker.typeToString(bridgedGetType(start, end));
}

function bridgedNodeInfo(start, end) {
  const tsNode = findTsNodeForSpan(start, end);
  return {
    kind: ts.SyntaxKind[tsNode.kind],
    text: tsNode.getText(sourceFile).slice(0, 50),
    typeStr: checker.typeToString(checker.getTypeAtLocation(tsNode)),
  };
}

// ── Helpers ──────────────────────────────────────────────────
function spanOf(str, occurrence = 0) {
  let idx = -1;
  for (let i = 0; i <= occurrence; i++) {
    idx = SOURCE.indexOf(str, idx + 1);
    if (idx === -1) throw new Error(`"${str}" occurrence ${occurrence} not found`);
  }
  return [idx, idx + str.length];
}

let passed = 0, failed = 0;
const results = [];

function test(name, span, expected) {
  const typeStr = bridgedTypeString(span[0], span[1]);
  const ok = expected instanceof RegExp ? expected.test(typeStr) : typeStr === expected;
  if (ok) {
    passed++;
    results.push(`  ✓ ${name}: ${typeStr}`);
  } else {
    const info = bridgedNodeInfo(span[0], span[1]);
    failed++;
    results.push(`  ✗ ${name}`);
    results.push(`    expected: ${expected}`);
    results.push(`    got:      ${typeStr}`);
    results.push(`    tsNode:   ${info.kind} "${info.text}"`);
  }
}

// ── Tests ────────────────────────────────────────────────────

console.log("\n=== Span-Based Bridge: Token → Walk Up → Match by [start, end] ===\n");

// KEY TEST: CallExpression span should give RETURN TYPE, not function type
test("CallExpr span: greet(\"world\") → string (return type)",
  spanOf('greet("world")'), "string");

// Identifier span should give IDENTIFIER TYPE (the function itself)
test("Identifier span: greet (just the name) → function type",
  spanOf("greet", 1), "(name: string) => string");  // 2nd occurrence = call site callee

// Variable
test("VarDecl: result",
  spanOf("result", 1), "string");

// Async call expression
test("CallExpr span: fetchData() → Promise<string>",
  spanOf("fetchData()", 1), "Promise<string>");  // 2nd occurrence = call site

// Variable holding promise
test("VarDecl: promise",
  spanOf("promise", 0), "Promise<string>");

// Method call: arr.map(x => x * 2) — full expression span
test("MethodCall span: arr.map(x => x * 2) → number[]",
  spanOf("arr.map(x => x * 2)"), "number[]");

// Just arr.map (without args) — the property access
test("PropAccess span: arr.map → method type",
  spanOf("arr.map"), /\(callbackfn/);

// Property access: obj.a
test("PropAccess span: obj.a → number",
  spanOf("obj.a", 0), "number");

// Just obj
test("Identifier span: obj → object type",
  spanOf("obj", 1), "{ a: number; b: string; }");

// new expression
test("NewExpr span: new Foo() → Foo",
  spanOf("new Foo()"), "Foo");

// Method call on instance
test("MethodCall span: foo.bar() → number",
  spanOf("foo.bar()"), "number");

// Binary expressions
test("BinaryExpr span: 1 + 2 → number",
  spanOf("1 + 2"), "number");

test("BinaryExpr span: \"a\" + \"b\" → string",
  spanOf('"a" + "b"'), "string");

// Ternary — full span
test("ConditionalExpr span: true ? \"yes\" : \"no\"",
  spanOf('true ? "yes" : "no"'), '"yes" | "no"');

// Optional chaining
test("OptionalChain span: optional?.length",
  spanOf("optional?.length"), "number");  // narrowed from "hello", not null

// Type assertion
test("TypeAssertion span: (42 as unknown) as string",
  spanOf("(42 as unknown) as string"), "string");

// Template literal
test("TemplateLiteral span: `hello ${result}`",
  spanOf("`hello ${result}`"), "string");

// Interface-typed access
test("CallExpr span: getUser() → User",
  spanOf("getUser()", 1), "User");  // 2nd occurrence = call site

test("PropAccess span: user.name → string",
  spanOf("user.name"), "string");

// Array find (returns T | undefined)
test("MethodCall span: nums.find(n => n > 1) → number | undefined",
  spanOf("nums.find(n => n > 1)"), "number | undefined");

// Non-null assertion
test("NonNullAssertion span: found!",
  spanOf("found!"), "number");

// ── Print ────────────────────────────────────────────────────
console.log(results.join("\n"));
console.log(`\n${passed} passed, ${failed} failed\n`);
if (failed > 0) process.exit(1);
