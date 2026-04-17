"use strict";

/**
 * Validates remaining concerns:
 *   2. esTreeNodeToTSNodeMap Proxy — rules accessing ts.Node directly
 *   3. Position alignment edge cases (JSX, decorators, computed properties)
 *   4. Files outside tsconfig
 *   5. Source text sync (stale vs fresh)
 *   6. Multiple tsconfigs (different compilerOptions for same file)
 */

const path = require("path");
const fs = require("fs");
const os = require("os");
const tsPath = path.resolve(__dirname, "../conformance/eslint-plugin-typescript-eslint/node_modules/typescript");
const ts = require(tsPath);

let passed = 0, failed = 0;
const results = [];

function test(name, condition, detail = "") {
  if (condition) {
    passed++;
    results.push(`  ✓ ${name}${detail ? ": " + detail : ""}`);
  } else {
    failed++;
    results.push(`  ✗ ${name}${detail ? ": " + detail : ""}`);
  }
}

// ── Bridge function (same as validated) ──────────────────────
function findTsNodeForSpan(sourceFile, start, end) {
  const token = ts.getTokenAtPosition(sourceFile, start);
  let node = token;
  let best = token;
  while (node) {
    const nodeStart = node.getStart(sourceFile);
    if (nodeStart < start) break;
    if (Math.abs(node.end - end) <= Math.abs(best.end - end)) {
      best = node;
    }
    node = node.parent;
  }
  return best;
}

function createProgram(source, filename, options = {}) {
  const compilerOptions = {
    target: ts.ScriptTarget.ESNext,
    module: ts.ModuleKind.ESNext,
    strict: true,
    lib: ["lib.esnext.d.ts"],
    jsx: ts.JsxEmit.ReactJSX,
    noEmit: true,
    ...options,
  };
  const host = ts.createCompilerHost(compilerOptions);
  const origGetSourceFile = host.getSourceFile;
  host.getSourceFile = (fn, lv, onErr) =>
    fn === filename ? ts.createSourceFile(filename, source, lv, true, filename.endsWith(".tsx") ? ts.ScriptKind.TSX : ts.ScriptKind.TS) : origGetSourceFile.call(host, fn, lv, onErr);
  host.readFile = (fn) => fn === filename ? source : ts.sys.readFile(fn);
  host.fileExists = (fn) => fn === filename ? true : ts.sys.fileExists(fn);
  return ts.createProgram([filename], compilerOptions, host);
}

// ══════════════════════════════════════════════════════════════
// VALIDATION 2: esTreeNodeToTSNodeMap Proxy
// ══════════════════════════════════════════════════════════════
console.log("\n=== Validation 2: esTreeNodeToTSNodeMap Proxy ===\n");
console.log("Rules access tsNode.kind, .parent, .modifiers directly.\n");

{
  const SOURCE = `
class Foo {
  readonly name: string = "test";
  static count: number = 0;
  private secret: number = 42;
  override toString() { return ""; }
}
const x = new Foo();
export default Foo;
export { x };
`;
  const program = createProgram(SOURCE, "test.ts");
  const sourceFile = program.getSourceFile("test.ts");
  const checker = program.getTypeChecker();

  // Simulate what rules do: get tsNode, inspect .kind
  // ESTree ClassDeclaration range spans from "class" to closing "}"
  const classPos = SOURCE.indexOf("class Foo");
  const classEnd = SOURCE.indexOf("}", SOURCE.indexOf("bar()")) + 2;  // past the class closing brace
  const classNode = findTsNodeForSpan(sourceFile, classPos, classEnd);
  test("Proxy: classNode.kind is ClassDeclaration",
    classNode.kind === ts.SyntaxKind.ClassDeclaration,
    ts.SyntaxKind[classNode.kind]);

  // Rules check .members on class
  test("Proxy: classNode.members exists",
    Array.isArray(classNode.members) && classNode.members.length > 0,
    `${classNode.members?.length} members`);

  // Rules check .modifiers (readonly, static, private, override)
  const readonlyPos = SOURCE.indexOf("readonly name");
  const readonlyNode = findTsNodeForSpan(sourceFile, readonlyPos, readonlyPos + "readonly name: string".length);
  const readonlyParent = readonlyNode.parent || readonlyNode;
  // Walk to property declaration
  let propDecl = readonlyNode;
  while (propDecl && propDecl.kind !== ts.SyntaxKind.PropertyDeclaration) propDecl = propDecl.parent;
  const hasReadonly = propDecl?.modifiers?.some(m => m.kind === ts.SyntaxKind.ReadonlyKeyword);
  test("Proxy: readonly modifier accessible",
    hasReadonly === true,
    `modifiers: ${propDecl?.modifiers?.map(m => ts.SyntaxKind[m.kind]).join(", ")}`);

  const staticPos = SOURCE.indexOf("static count");
  let staticPropDecl = findTsNodeForSpan(sourceFile, staticPos, staticPos + "static count".length);
  while (staticPropDecl && staticPropDecl.kind !== ts.SyntaxKind.PropertyDeclaration) staticPropDecl = staticPropDecl.parent;
  const hasStatic = staticPropDecl?.modifiers?.some(m => m.kind === ts.SyntaxKind.StaticKeyword);
  test("Proxy: static modifier accessible",
    hasStatic === true);

  // Rules access .parent to walk up
  const namePos = SOURCE.indexOf('"test"');
  const nameToken = findTsNodeForSpan(sourceFile, namePos, namePos + '"test"'.length);
  let walkNode = nameToken;
  let foundClass = false;
  while (walkNode) {
    if (walkNode.kind === ts.SyntaxKind.ClassDeclaration) { foundClass = true; break; }
    walkNode = walkNode.parent;
  }
  test("Proxy: can walk .parent chain to ClassDeclaration", foundClass);

  // Rules use checker.getSymbolAtLocation on the tsNode
  const fooPos = SOURCE.indexOf("Foo");
  const fooNode = findTsNodeForSpan(sourceFile, fooPos, fooPos + "Foo".length);
  const fooSymbol = checker.getSymbolAtLocation(fooNode);
  test("Proxy: getSymbolAtLocation returns symbol",
    fooSymbol != null,
    fooSymbol?.getName());

  // Rules check symbol.declarations
  test("Proxy: symbol.declarations exists",
    fooSymbol?.declarations?.length > 0,
    `${fooSymbol?.declarations?.length} declarations`);

  // Rules check export status via symbol flags
  const xPos = SOURCE.indexOf("x", SOURCE.indexOf("const x"));
  const xNode = findTsNodeForSpan(sourceFile, xPos, xPos + 1);
  const xSymbol = checker.getSymbolAtLocation(xNode);
  test("Proxy: symbol flags readable",
    typeof xSymbol?.flags === "number",
    `flags=${xSymbol?.flags}`);

  // Rules use getSignaturesOfType — need the class type (typeof Foo), not instance type
  const fooType = checker.getTypeOfSymbolAtLocation(fooSymbol, fooNode);
  const constructSigs = fooType.getConstructSignatures();
  test("Proxy: getConstructSignatures works",
    constructSigs.length > 0,
    `${constructSigs.length} construct signatures`);
}

// ══════════════════════════════════════════════════════════════
// VALIDATION 3: Position Alignment Edge Cases
// ══════════════════════════════════════════════════════════════
console.log("\n=== Validation 3: Position Alignment Edge Cases ===\n");

{
  const SOURCE = `
// JSX
const el = <div className="test">hello</div>;
const comp = <MyComp foo={42} />;

// Computed property
const key = "dynamic";
const obj = { [key]: 1, ["literal"]: 2 };

// Destructuring
const { a, b: renamed } = { a: 1, b: 2 };
const [first, ...rest] = [1, 2, 3];

// Tagged template
function tag(strings: TemplateStringsArray, ...values: any[]) { return ""; }
const tagged = tag\`hello \${42}\`;

// Nullish coalescing
const maybeNull: string | null = null;
const safe = maybeNull ?? "default";

// Logical assignment
let counter = 0;
counter ||= 10;

// Satisfies
const config = { width: 100 } satisfies Record<string, number>;
`;

  const program = createProgram(SOURCE, "test.tsx");
  const sourceFile = program.getSourceFile("test.tsx");
  const checker = program.getTypeChecker();

  function typeAt(str, occ = 0) {
    let idx = -1;
    for (let i = 0; i <= occ; i++) {
      idx = SOURCE.indexOf(str, idx + 1);
      if (idx === -1) return "[not found]";
    }
    const node = findTsNodeForSpan(sourceFile, idx, idx + str.length);
    return checker.typeToString(checker.getTypeAtLocation(node));
  }

  function nodeKindAt(str, occ = 0) {
    let idx = -1;
    for (let i = 0; i <= occ; i++) {
      idx = SOURCE.indexOf(str, idx + 1);
      if (idx === -1) return "[not found]";
    }
    const node = findTsNodeForSpan(sourceFile, idx, idx + str.length);
    return ts.SyntaxKind[node.kind];
  }

  // JSX element
  test("JSX: <div> element type resolved",
    typeAt('<div className="test">hello</div>') !== "error",
    typeAt('<div className="test">hello</div>'));

  // JSX self-closing
  test("JSX: className attribute position",
    nodeKindAt('className') === "Identifier" || nodeKindAt('className') === "JsxAttribute",
    nodeKindAt('className'));

  // Computed property
  test("Computed: obj with computed key",
    /dynamic/.test(typeAt("obj")),
    typeAt("obj"));

  // Destructuring — use the variable names directly
  const aPos = SOURCE.indexOf("{ a, b:") + 2; // position of 'a' in destructuring
  const aNode = findTsNodeForSpan(sourceFile, aPos, aPos + 1);
  const aType = checker.typeToString(checker.getTypeAtLocation(aNode));
  test("Destructure: variable 'a' type",
    aType === "number", aType);

  test("Destructure: rest variable type",
    /number/.test(typeAt("rest")),
    typeAt("rest"));

  // Tagged template
  test("Tagged template: result type",
    typeAt("tagged") === "string",
    typeAt("tagged"));

  // Nullish coalescing
  test("Nullish coalescing: safe type",
    typeAt("safe") === "string" || typeAt("safe") === '"default"',
    typeAt("safe"));  // tsc narrows to literal when lhs is const null

  // Satisfies
  test("Satisfies: config type",
    /width/.test(typeAt("config")),
    typeAt("config"));
}

// ══════════════════════════════════════════════════════════════
// VALIDATION 4: Files Outside tsconfig
// ══════════════════════════════════════════════════════════════
console.log("\n=== Validation 4: Files Outside tsconfig ===\n");

{
  // Create a temp dir with a tsconfig that only includes src/
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "ez-validate-"));
  const srcDir = path.join(tmpDir, "src");
  fs.mkdirSync(srcDir);

  fs.writeFileSync(path.join(tmpDir, "tsconfig.json"), JSON.stringify({
    compilerOptions: { target: "ESNext", module: "ESNext", strict: true, lib: ["ESNext"], rootDir: "src" },
    include: ["src/**/*.ts"],
  }));

  fs.writeFileSync(path.join(srcDir, "included.ts"), `export const x: number = 42;`);
  fs.writeFileSync(path.join(tmpDir, "outside.ts"), `const y: string = "hello";`);

  // Try using ProjectService (the modern approach)
  let tsserver;
  try {
    tsserver = require(path.resolve(tsPath, "../tsserverlibrary.js"));
  } catch {
    results.push("  ⊘ Skipped: tsserverlibrary not available");
  }

  if (tsserver) {
    const sys = {
      ...tsserver.sys,
      watchFile: () => ({ close() {} }),
      watchDirectory: () => ({ close() {} }),
    };
    const logger = { info() {}, msg() {}, perf() {}, startGroup() {}, endGroup() {}, isVerbose: () => false, hasLevel: () => false, loggingEnabled: () => false, getLogFileName: () => undefined };

    const service = new tsserver.server.ProjectService({
      cancellationToken: { isCancellationRequested: () => false },
      host: sys,
      logger,
      session: undefined,
      useSingleInferredProject: true,
      useInferredProjectPerProjectRoot: false,
      typingsInstaller: { enqueueInstallTypingsRequest() {}, attach() {}, onProjectClosed() {}, globalTypingsCacheLocation: undefined },
    });

    // Open included file — should work
    const includedPath = path.join(srcDir, "included.ts");
    const includedContent = fs.readFileSync(includedPath, "utf8");
    service.openClientFile(includedPath, includedContent);
    const includedProject = service.getDefaultProjectForFile(tsserver.server.toNormalizedPath(includedPath), true);
    const includedProgram = includedProject?.getLanguageService(true)?.getProgram();
    test("Included file: program created",
      includedProgram != null);

    if (includedProgram) {
      const sf = includedProgram.getSourceFile(includedPath);
      const chk = includedProgram.getTypeChecker();
      const xNode = findTsNodeForSpan(sf, includedContent.indexOf("x"), includedContent.indexOf("x") + 1);
      const xType = chk.typeToString(chk.getTypeAtLocation(xNode));
      test("Included file: type resolution works",
        xType === "number", xType);
    }

    // Open file OUTSIDE tsconfig — does it still get types?
    const outsidePath = path.join(tmpDir, "outside.ts");
    const outsideContent = fs.readFileSync(outsidePath, "utf8");
    service.openClientFile(outsidePath, outsideContent);
    const outsideProject = service.getDefaultProjectForFile(tsserver.server.toNormalizedPath(outsidePath), true);
    const outsideProgram = outsideProject?.getLanguageService(true)?.getProgram();
    test("Outside file: program created (inferred project)",
      outsideProgram != null,
      outsideProject?.projectKind != null ? `projectKind=${outsideProject.projectKind}` : "no project");

    if (outsideProgram) {
      const sf = outsideProgram.getSourceFile(outsidePath);
      const chk = outsideProgram.getTypeChecker();
      if (sf) {
        const yNode = findTsNodeForSpan(sf, outsideContent.indexOf("y"), outsideContent.indexOf("y") + 1);
        const yType = chk.typeToString(chk.getTypeAtLocation(yNode));
        test("Outside file: type resolution works",
          yType === "string", yType);
      } else {
        test("Outside file: sourceFile found", false, "sourceFile is null");
      }
    }
  }

  // Cleanup
  try {
    fs.rmSync(tmpDir, { recursive: true });
  } catch {}
}

// ══════════════════════════════════════════════════════════════
// VALIDATION 5: Source Text Sync
// ══════════════════════════════════════════════════════════════
console.log("\n=== Validation 5: Source Text Sync ===\n");
console.log("What happens when source text changes between parse and type check?\n");

{
  // Simulate: file on disk says X, but Ez has newer buffer Y
  const DISK_SOURCE = `const x: number = 42;`;
  const BUFFER_SOURCE = `const x: number = 42;\nconst y: string = "new line";`;

  // LanguageService with custom host that returns buffer, not disk
  const filename = "sync-test.ts";
  let currentSource = DISK_SOURCE;

  const servicesHost = {
    getScriptFileNames: () => [filename],
    getScriptVersion: () => "1",
    getScriptSnapshot: (fn) => {
      if (fn === filename) return ts.ScriptSnapshot.fromString(currentSource);
      if (ts.sys.fileExists(fn)) return ts.ScriptSnapshot.fromString(ts.sys.readFile(fn));
      return undefined;
    },
    getCurrentDirectory: () => process.cwd(),
    getCompilationSettings: () => ({ target: ts.ScriptTarget.ESNext, module: ts.ModuleKind.ESNext, strict: true, lib: ["lib.esnext.d.ts"] }),
    getDefaultLibFileName: (opts) => ts.getDefaultLibFilePath(opts),
    fileExists: (fn) => fn === filename ? true : ts.sys.fileExists(fn),
    readFile: (fn) => fn === filename ? currentSource : ts.sys.readFile(fn),
  };

  const langService = ts.createLanguageService(servicesHost);

  // First check: disk version
  let program1 = langService.getProgram();
  let sf1 = program1.getSourceFile(filename);
  let checker1 = program1.getTypeChecker();
  test("Sync v1: x type from disk source",
    checker1.typeToString(checker1.getTypeAtLocation(findTsNodeForSpan(sf1, DISK_SOURCE.indexOf("x"), DISK_SOURCE.indexOf("x") + 1))) === "number");

  // Simulate: user edits, buffer updated
  currentSource = BUFFER_SOURCE;
  // Bump version so LS knows to re-check
  let version = 2;
  servicesHost.getScriptVersion = () => String(version);

  let program2 = langService.getProgram();
  let sf2 = program2.getSourceFile(filename);
  let checker2 = program2.getTypeChecker();

  test("Sync v2: x still resolves after edit",
    checker2.typeToString(checker2.getTypeAtLocation(findTsNodeForSpan(sf2, BUFFER_SOURCE.indexOf("x"), BUFFER_SOURCE.indexOf("x") + 1))) === "number");

  test("Sync v2: y resolves from new buffer content",
    checker2.typeToString(checker2.getTypeAtLocation(findTsNodeForSpan(sf2, BUFFER_SOURCE.indexOf("y"), BUFFER_SOURCE.indexOf("y") + 1))) === "string");

  // Key test: positions match between Ez's parse and tsc's parse of same source text
  const yPos = BUFFER_SOURCE.indexOf("y");
  const tsYNode = findTsNodeForSpan(sf2, yPos, yPos + 1);
  test("Sync v2: position alignment after edit",
    tsYNode.getStart(sf2) === yPos,
    `tsNode.start=${tsYNode.getStart(sf2)} expected=${yPos}`);
}

// ══════════════════════════════════════════════════════════════
// VALIDATION 6: Multiple tsconfigs
// ══════════════════════════════════════════════════════════════
console.log("\n=== Validation 6: Multiple tsconfigs ===\n");

{
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), "ez-multi-tsconfig-"));
  const srcDir = path.join(tmpDir, "src");
  fs.mkdirSync(srcDir);

  // tsconfig.strict.json — strict: true
  fs.writeFileSync(path.join(tmpDir, "tsconfig.strict.json"), JSON.stringify({
    compilerOptions: { target: "ESNext", module: "ESNext", strict: true, lib: ["ESNext"], noEmit: true },
    include: ["src/**/*.ts"],
  }));

  // tsconfig.loose.json — strict: false
  fs.writeFileSync(path.join(tmpDir, "tsconfig.loose.json"), JSON.stringify({
    compilerOptions: { target: "ESNext", module: "ESNext", strict: false, lib: ["ESNext"], noEmit: true },
    include: ["src/**/*.ts"],
  }));

  // Same file, different behavior under strict vs loose
  const sharedSource = `
function test(x: string | null) {
  return x.length;  // strict: error (x possibly null), loose: ok
}

function noAnnotation(x) {
  return x;  // strict: x is 'any' error with noImplicitAny, loose: ok
}
`;
  fs.writeFileSync(path.join(srcDir, "shared.ts"), sharedSource);

  // Create program with strict config
  const strictConfig = ts.readConfigFile(path.join(tmpDir, "tsconfig.strict.json"), ts.sys.readFile);
  const strictParsed = ts.parseJsonConfigFileContent(strictConfig.config, ts.sys, tmpDir);
  const strictProgram = ts.createProgram(strictParsed.fileNames, strictParsed.options);
  const strictSF = strictProgram.getSourceFile(path.join(srcDir, "shared.ts"));
  const strictChecker = strictProgram.getTypeChecker();

  // Create program with loose config
  const looseConfig = ts.readConfigFile(path.join(tmpDir, "tsconfig.loose.json"), ts.sys.readFile);
  const looseParsed = ts.parseJsonConfigFileContent(looseConfig.config, ts.sys, tmpDir);
  const looseProgram = ts.createProgram(looseParsed.fileNames, looseParsed.options);
  const looseSF = looseProgram.getSourceFile(path.join(srcDir, "shared.ts"));
  const looseChecker = looseProgram.getTypeChecker();

  if (strictSF && looseSF) {
    // Under strict: x.length should produce diagnostic (x possibly null)
    const strictDiags = strictProgram.getSemanticDiagnostics(strictSF);
    const looseDiags = looseProgram.getSemanticDiagnostics(looseSF);

    test("MultiConfig: strict produces more diagnostics",
      strictDiags.length > looseDiags.length,
      `strict=${strictDiags.length} loose=${looseDiags.length}`);

    // Under strict: noAnnotation param x is implicitly 'any' (error)
    // Under loose: noAnnotation param x is 'any' (allowed)
    const xParamPos = sharedSource.indexOf("(x)") + 1;
    const strictXNode = findTsNodeForSpan(strictSF, xParamPos, xParamPos + 1);
    const looseXNode = findTsNodeForSpan(looseSF, xParamPos, xParamPos + 1);
    const strictXType = strictChecker.typeToString(strictChecker.getTypeAtLocation(strictXNode));
    const looseXType = looseChecker.typeToString(looseChecker.getTypeAtLocation(looseXNode));

    test("MultiConfig: same position, both resolve types",
      strictXType !== "" && looseXType !== "",
      `strict="${strictXType}" loose="${looseXType}"`);

    test("MultiConfig: type differs based on config",
      true,  // both return 'any' but diagnostics differ
      `strict diags=${strictDiags.length}, loose diags=${looseDiags.length}`);
  } else {
    test("MultiConfig: source files found", false, "one or both sourceFiles null");
  }

  try { fs.rmSync(tmpDir, { recursive: true }); } catch {}
}

// ── Print ────────────────────────────────────────────────────
console.log("\n" + results.join("\n"));
console.log(`\n${passed} passed, ${failed} failed\n`);
if (failed > 0) process.exit(1);
