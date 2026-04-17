"use strict";

/**
 * Integration test: ts-services.js → buildParserServices → type queries
 *
 * Creates a temp project with tsconfig.json, runs buildParserServices,
 * and verifies type resolution works through the span bridge.
 */

const fs = require("fs");
const path = require("path");
const os = require("os");

// Create temp project
const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "ez-ts-services-test-"));
const srcDir = path.join(tmpDir, "src");
fs.mkdirSync(srcDir);

fs.writeFileSync(path.join(tmpDir, "tsconfig.json"), JSON.stringify({
  compilerOptions: {
    target: "ESNext",
    module: "ESNext",
    strict: true,
    lib: ["ESNext"],
    noEmit: true,
  },
  include: ["src/**/*.ts"],
}));

const testSource = `
interface User {
  name: string;
  age: number;
}

function getUser(): User {
  return { name: "Alice", age: 30 };
}

const user = getUser();
const userName = user.name;

async function fetchData(): Promise<string> {
  return "data";
}

const promise = fetchData();

const arr = [1, 2, 3];
const mapped = arr.map(x => x * 2);

class Service {
  readonly port: number = 8080;
  start(): void {}
}

const svc = new Service();
`;

const testFile = path.join(srcDir, "test.ts");
fs.writeFileSync(testFile, testSource);

// Load ts-services
const tsServices = require("../../js/ts-services");

let passed = 0, failed = 0;

function test(name, condition, detail = "") {
  if (condition) {
    passed++;
    console.log(`  ✓ ${name}${detail ? ": " + detail : ""}`);
  } else {
    failed++;
    console.log(`  ✗ ${name}${detail ? ": " + detail : ""}`);
  }
}

// ── Test init ────────────────────────────────────────────────
console.log("\n=== ts-services.js Integration Test ===\n");

const initResult = tsServices.init(tmpDir);
test("init() finds tsconfig and creates service", initResult === true);

// ── Test buildParserServices ─────────────────────────────────
const services = tsServices.buildParserServices(testFile, testSource);
test("buildParserServices() returns non-null", services != null);

if (!services) {
  console.log("\n0 passed, all failed — services is null\n");
  process.exit(1);
}

test("services.program exists", services.program != null);
test("services.esTreeNodeToTSNodeMap exists", services.esTreeNodeToTSNodeMap != null);
test("services.getTypeAtLocation is a function", typeof services.getTypeAtLocation === "function");
test("services.getSymbolAtLocation is a function", typeof services.getSymbolAtLocation === "function");
test("services.getContextualType is a function", typeof services.getContextualType === "function");
test("services.getResolvedSignature is a function", typeof services.getResolvedSignature === "function");

// ── Test type resolution via fake ESTree nodes ───────────────
// Simulate ESTree nodes with just { range: [start, end] }

function fakeNode(str, occurrence = 0) {
  let idx = -1;
  for (let i = 0; i <= occurrence; i++) {
    idx = testSource.indexOf(str, idx + 1);
    if (idx === -1) return null;
  }
  return { range: [idx, idx + str.length] };
}

const ts = require(path.resolve(__dirname, "../conformance/eslint-plugin-typescript-eslint/node_modules/typescript"));
const checker = services.program.getTypeChecker();

function typeStr(estreeNode) {
  const type = services.getTypeAtLocation(estreeNode);
  return checker.typeToString(type);
}

console.log("\n--- Type Resolution ---\n");

test("getUser() returns User",
  typeStr(fakeNode("getUser()", 1)) === "User",
  typeStr(fakeNode("getUser()", 1)));

// "user" occurrence 1 is inside "userName", so match "user =" for the variable declaration
const userVarPos = testSource.indexOf("const user =") + 6;  // position of "user" in "const user ="
test("user is User",
  typeStr({ range: [userVarPos, userVarPos + 4] }) === "User",
  typeStr({ range: [userVarPos, userVarPos + 4] }));

test("userName is string",
  typeStr(fakeNode("userName")) === "string",
  typeStr(fakeNode("userName")));

test("fetchData() returns Promise<string>",
  typeStr(fakeNode("fetchData()", 1)) === "Promise<string>",
  typeStr(fakeNode("fetchData()", 1)));

test("promise is Promise<string>",
  typeStr(fakeNode("promise")) === "Promise<string>",
  typeStr(fakeNode("promise")));

test("arr.map(x => x * 2) returns number[]",
  typeStr(fakeNode("arr.map(x => x * 2)")) === "number[]",
  typeStr(fakeNode("arr.map(x => x * 2)")));

test("new Service() returns Service",
  typeStr(fakeNode("new Service()")) === "Service",
  typeStr(fakeNode("new Service()")));

console.log("\n--- esTreeNodeToTSNodeMap Proxy ---\n");

const userNode = fakeNode("user", 1);
const tsNode = services.esTreeNodeToTSNodeMap.get(userNode);
test("esTreeNodeToTSNodeMap.get() returns ts.Node",
  tsNode != null && typeof tsNode.kind === "number",
  tsNode ? `kind=${ts.SyntaxKind[tsNode.kind]}` : "null");

test("esTreeNodeToTSNodeMap.has() returns true",
  services.esTreeNodeToTSNodeMap.has(userNode));

console.log("\n--- getSymbolAtLocation ---\n");

const userSymbol = services.getSymbolAtLocation(fakeNode("User"));
test("getSymbolAtLocation(User) returns symbol",
  userSymbol != null,
  userSymbol?.getName());

test("symbol has declarations",
  userSymbol?.declarations?.length > 0);

console.log("\n--- updateFile + re-query ---\n");

const updatedSource = testSource + "\nconst extra: boolean = true;\n";
tsServices.updateFile(testFile, updatedSource);
const services2 = tsServices.buildParserServices(testFile, updatedSource);
test("After updateFile, buildParserServices works",
  services2 != null);

if (services2) {
  const extraNode = { range: [updatedSource.indexOf("extra"), updatedSource.indexOf("extra") + 5] };
  const extraType = checker.typeToString(services2.getTypeAtLocation(extraNode));
  // Need new checker from new program
  const checker2 = services2.program.getTypeChecker();
  const extraType2 = checker2.typeToString(services2.getTypeAtLocation(extraNode));
  test("New variable 'extra' resolves to boolean",
    extraType2 === "boolean", extraType2);
}

// ── Cleanup ──────────────────────────────────────────────────
tsServices.dispose();
try { fs.rmSync(tmpDir, { recursive: true }); } catch {}

console.log(`\n${passed} passed, ${failed} failed\n`);
if (failed > 0) process.exit(1);
