const std = @import("std");
const sanz = @import("sanz");
const Lexer = sanz.Lexer;
const Parser = sanz.Parser;
const SemanticAnalyzer = sanz.semantic.SemanticAnalyzer;
const linter = sanz.linter;
const Language = sanz.token.Language;

// ── Fuzz targets ─────────────────────────────────────────────
// Run with: zig build fuzz
// These test that no input can crash the pipeline.

test "fuzz lexer" {
    return std.testing.fuzz({}, fuzzLexer, .{
        .corpus = &.{
            "var x = 1;",
            "function foo() { return 42; }",
            "const obj = { a: 1, b: 'hello' };",
            "if (x) { } else { }",
            "`template ${expr} literal`",
            "// comment\n/* block */",
            "/regex/gi",
        },
    });
}

fn fuzzLexer(_: void, input: []const u8) !void {
    const allocator = std.testing.allocator;
    var tokens = Lexer.tokenize(allocator, input) catch return;
    tokens.deinit(allocator);
}

test "fuzz parser" {
    return std.testing.fuzz({}, fuzzParser, .{
        .corpus = &.{
            "var x = 1;",
            "function foo(a, b) { return a + b; }",
            "class Foo extends Bar { constructor() { super(); } }",
            "import { x } from 'y'; export default x;",
            "for (let i = 0; i < 10; i++) { if (i % 2) continue; }",
            "const [a, ...rest] = [1, 2, 3];",
            "async function* gen() { yield await fetch(); }",
        },
    });
}

fn fuzzParser(_: void, input: []const u8) !void {
    const allocator = std.testing.allocator;

    var tokens = Lexer.tokenize(allocator, input) catch return;
    defer tokens.deinit(allocator);

    var tree = Parser.parse(allocator, input, tokens.slice()) catch return;
    tree.deinit(allocator);
}

test "fuzz full pipeline" {
    return std.testing.fuzz({}, fuzzFullPipeline, .{
        .corpus = &.{
            "let x = 1; console.log(x);",
            "debugger; eval('code');",
            "const obj = { a: 1, a: 2 };",
            "function foo(x, x) {}",
        },
    });
}

fn fuzzFullPipeline(_: void, input: []const u8) !void {
    const allocator = std.testing.allocator;

    var tokens = Lexer.tokenize(allocator, input) catch return;
    defer tokens.deinit(allocator);

    var tree = Parser.parse(allocator, input, tokens.slice()) catch return;
    defer tree.deinit(allocator);

    var sem = SemanticAnalyzer.analyze(allocator, &tree) catch return;
    defer sem.deinit(allocator);

    const diags = linter.lint(allocator, &tree, &sem, null) catch return;
    allocator.free(diags);
}

test "fuzz TypeScript parser" {
    return std.testing.fuzz({}, fuzzTsParser, .{
        .corpus = &.{
            "interface Foo { bar: string; }",
            "type X = A | B & C;",
            "const x: number = 1 as any;",
            "enum Color { Red, Green, Blue }",
            "function foo<T>(x: T): T { return x; }",
        },
    });
}

fn fuzzTsParser(_: void, input: []const u8) !void {
    const allocator = std.testing.allocator;

    var tokens = Lexer.tokenizeWithLanguage(allocator, input, .ts) catch return;
    defer tokens.deinit(allocator);

    var tree = Parser.parseWithLanguage(allocator, input, tokens.slice(), .ts) catch return;
    tree.deinit(allocator);
}
