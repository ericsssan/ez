const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const linter = ez.linter;
const parent_builder = ez.parent_builder;
const Language = ez.token.Language;

// ── Fuzz targets ─────────────────────────────────────────────
// Run with: zig build fuzz
// These test that no input can crash the pipeline.

// ── Shared corpora ───────────────────────────────────────────

const CORPUS_JS = &[_][]const u8{
    // Normal JS
    "var x = 1;",
    "function foo(a, b) { return a + b; }",
    "class Foo extends Bar { constructor() { super(); } }",
    "import { x } from 'y'; export default x;",
    "for (let i = 0; i < 10; i++) { if (i % 2) continue; }",
    "const [a, ...rest] = [1, 2, 3];",
    "async function* gen() { yield await fetch(); }",
    "`template ${expr} literal`",
    "// comment\n/* block */",
    "/regex/gi",
    // Error recovery / malformed
    "function(",
    "class {",
    "({",
    "=>",
    "...",
    "/*",
    "var x = ;",
    "if ()",
    "} } }",
    "import",
    "export {",
    // Unicode / special chars
    "var \u{03B1} = 1;",
    "\u{200B}",
    "\u{FEFF}var x = 1;",
    // Long / deeply nested
    "x + " ** 200 ++ "0",
    "({" ++ "a:1," ** 100 ++ "})",
    // Linter targets
    "debugger;",
    "eval('code');",
    "const obj = { a: 1, a: 2 };",
    "function foo(x, x) {}",
    "while (true) {}",
    // Truncated
    "var x",
    "function f() { return",
    "class C extends",
};

const CORPUS_TS = &[_][]const u8{
    // Normal TS
    "interface Foo { bar: string; }",
    "type X = A | B & C;",
    "const x: number = 1 as any;",
    "enum Color { Red, Green, Blue }",
    "function foo<T>(x: T): T { return x; }",
    // Generics
    "type Partial<T> = { [K in keyof T]?: T[K]; };",
    "function identity<T extends object>(x: T): T { return x; }",
    "const map = new Map<string, number>();",
    // Advanced
    "declare module 'foo' { export const x: number; }",
    "abstract class A { abstract foo(): void; }",
    "const x = foo!.bar?.baz ?? 0;",
    "type F = (x: number) => string;",
    // Conditional / mapped types
    "type IsString<T> = T extends string ? true : false;",
    "type Readonly<T> = { readonly [K in keyof T]: T[K]; };",
    // Malformed TS
    "interface {",
    "type = ;",
    "function foo<>() {}",
    "const x: = 1;",
    "enum {",
    // Truncated
    "interface Foo {",
    "type X =",
    "function foo<T",
};

const CORPUS_JSX = &[_][]const u8{
    // Normal JSX
    "<div>hello</div>",
    "<Foo bar={baz} />",
    "<ul>{items.map(i => <li key={i}>{i}</li>)}</ul>",
    "const el = <div className=\"foo\"><span /></div>;",
    "<>{children}</>",
    // Expressions in JSX
    "<Comp {...props} key={k} />",
    "<div style={{color: 'red'}} />",
    // Malformed JSX
    "<div",
    "<div>",
    "</>",
    "</div>",
    "<Foo bar=",
    "<div>{",
    // JSX + JS
    "function App() { return <div />; }",
    "const x = condition ? <A /> : <B />;",
    // Truncated
    "<div><span",
    "<Foo prop={val",
};

const CORPUS_TSX = &[_][]const u8{
    "const el: JSX.Element = <div />;",
    "function App(): React.FC { return <></>; }",
    "<Component value={v} />",
    "interface Props { name: string; }\nconst C = ({name}: Props) => <span>{name}</span>;",
    // Malformed TSX
    "<div",
    "<Component<",
    "const x: = <div>",
};

// ── Helpers ──────────────────────────────────────────────────

fn fuzzParse(allocator: std.mem.Allocator, input: []const u8, lang: Language) void {
    var result = Lexer.tokenizeWithLanguage(allocator, input, lang) catch return;
    defer result.deinit(allocator);
    var tree = Parser.parseWithLanguage(
        allocator, input, result.tokens.slice(), lang,
        lang == .ts or lang == .tsx,
    ) catch return;
    defer tree.deinit(allocator);
}

fn fuzzFullPipeline(allocator: std.mem.Allocator, input: []const u8, lang: Language) void {
    var result = Lexer.tokenizeWithLanguage(allocator, input, lang) catch return;
    defer result.deinit(allocator);
    var tree = Parser.parseWithLanguage(
        allocator, input, result.tokens.slice(), lang,
        lang == .ts or lang == .tsx,
    ) catch return;
    defer tree.deinit(allocator);
    var sem = SemanticAnalyzer.analyze(allocator, &tree) catch return;
    defer sem.deinit(allocator);
    const diags = linter.lint(allocator, &tree, &sem, null) catch return;
    allocator.free(diags);
}

// Exercises parent_builder.buildTraversal — the traversal-order pass that
// the NAPI entry point runs between parse and semantic analysis.
fn fuzzTraversal(allocator: std.mem.Allocator, input: []const u8, lang: Language) void {
    var result = Lexer.tokenizeWithLanguage(allocator, input, lang) catch return;
    defer result.deinit(allocator);
    var tree = Parser.parseWithLanguage(
        allocator, input, result.tokens.slice(), lang,
        lang == .ts or lang == .tsx,
    ) catch return;
    defer tree.deinit(allocator);
    const traversal = parent_builder.buildTraversal(&tree, allocator) catch return;
    allocator.free(traversal.parents);
    allocator.free(traversal.pre_order);
    allocator.free(traversal.post_order);
    allocator.free(traversal.dfs_events);
}

// ── Fuzz: lexer ──────────────────────────────────────────────

test "fuzz lexer" {
    return std.testing.fuzz({}, fuzzLexer, .{ .corpus = CORPUS_JS });
}

fn fuzzLexer(_: void, smith: *std.testing.Smith) !void {
    const allocator = std.testing.allocator;
    var buf: [4096]u8 = undefined;
    const input = buf[0..smith.slice(&buf)];
    var result = Lexer.tokenize(allocator, input) catch return;
    defer result.deinit(allocator);
}

// ── Fuzz: JS parser ──────────────────────────────────────────

test "fuzz JS parser" {
    return std.testing.fuzz({}, fuzzJsParser, .{ .corpus = CORPUS_JS });
}

fn fuzzJsParser(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzParse(std.testing.allocator, buf[0..smith.slice(&buf)], .js);
}

// ── Fuzz: JS full pipeline ───────────────────────────────────

test "fuzz JS full pipeline" {
    return std.testing.fuzz({}, fuzzJsPipeline, .{ .corpus = CORPUS_JS });
}

fn fuzzJsPipeline(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzFullPipeline(std.testing.allocator, buf[0..smith.slice(&buf)], .js);
}

// ── Fuzz: TS parser ──────────────────────────────────────────

test "fuzz TS parser" {
    return std.testing.fuzz({}, fuzzTsParser, .{ .corpus = CORPUS_TS });
}

fn fuzzTsParser(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzParse(std.testing.allocator, buf[0..smith.slice(&buf)], .ts);
}

// ── Fuzz: TS full pipeline ───────────────────────────────────

test "fuzz TS full pipeline" {
    return std.testing.fuzz({}, fuzzTsPipeline, .{ .corpus = CORPUS_TS });
}

fn fuzzTsPipeline(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzFullPipeline(std.testing.allocator, buf[0..smith.slice(&buf)], .ts);
}

// ── Fuzz: JSX parser ─────────────────────────────────────────

test "fuzz JSX parser" {
    return std.testing.fuzz({}, fuzzJsxParser, .{ .corpus = CORPUS_JSX });
}

fn fuzzJsxParser(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzParse(std.testing.allocator, buf[0..smith.slice(&buf)], .jsx);
}

// ── Fuzz: TSX parser ─────────────────────────────────────────

test "fuzz TSX parser" {
    return std.testing.fuzz({}, fuzzTsxParser, .{ .corpus = CORPUS_TSX });
}

fn fuzzTsxParser(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzParse(std.testing.allocator, buf[0..smith.slice(&buf)], .tsx);
}

// ── Fuzz: parent_builder traversal ───────────────────────────
// Exercises the DFS / parent-index pass that the NAPI entry point
// runs between parse and semantic analysis.

test "fuzz traversal JS" {
    return std.testing.fuzz({}, fuzzTraversalJs, .{ .corpus = CORPUS_JS });
}

fn fuzzTraversalJs(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzTraversal(std.testing.allocator, buf[0..smith.slice(&buf)], .js);
}

test "fuzz traversal TS" {
    return std.testing.fuzz({}, fuzzTraversalTs, .{ .corpus = CORPUS_TS });
}

fn fuzzTraversalTs(_: void, smith: *std.testing.Smith) !void {
    var buf: [4096]u8 = undefined;
    fuzzTraversal(std.testing.allocator, buf[0..smith.slice(&buf)], .ts);
}
