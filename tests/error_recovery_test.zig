const std = @import("std");
const testing = std.testing;
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const SemanticAnalyzer = sx3lint.semantic.SemanticAnalyzer;
const linter = sx3lint.linter;

// ── Error Recovery Tests ─────────────────────────────────────
// Verify the parser produces a usable AST from broken JS.
// Linters must handle real-world code with errors.

fn parseAndLint(source: []const u8) !struct { nodes: usize, errors: usize, lint_diags: usize } {
    const allocator = testing.allocator;

    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);

    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);

    const parse_errors = tree.errors.len;
    const node_count = tree.nodes.len;

    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);

    const diags = try linter.lint(allocator, &tree, &sem, null);
    defer allocator.free(diags);

    return .{
        .nodes = node_count,
        .errors = parse_errors,
        .lint_diags = diags.len,
    };
}

// ── Missing semicolons ──────────────────────────────────────

test "recovery: missing semicolons" {
    const result = try parseAndLint("let x = 1\nlet y = 2\nconsole.log(x, y)");
    try testing.expect(result.nodes > 0);
}

// ── Unclosed braces ─────────────────────────────────────────

test "recovery: unclosed brace" {
    const result = try parseAndLint("function foo() { return 1;");
    try testing.expect(result.nodes > 0);
    try testing.expect(result.errors > 0);
}

test "recovery: unclosed paren" {
    const result = try parseAndLint("foo(1, 2");
    try testing.expect(result.nodes > 0);
    try testing.expect(result.errors > 0);
}

test "recovery: unclosed bracket" {
    const result = try parseAndLint("let arr = [1, 2, 3");
    try testing.expect(result.nodes > 0);
    try testing.expect(result.errors > 0);
}

// ── Partial expressions ─────────────────────────────────────

test "recovery: trailing operator" {
    const result = try parseAndLint("let x = 1 +");
    try testing.expect(result.nodes > 0);
    try testing.expect(result.errors > 0);
}

test "recovery: empty function body" {
    const result = try parseAndLint("function");
    try testing.expect(result.errors > 0);
}

test "recovery: incomplete if" {
    const result = try parseAndLint("if (true)");
    try testing.expect(result.nodes > 0);
}

// ── Unexpected tokens ───────────────────────────────────────

test "recovery: stray closing brace" {
    const result = try parseAndLint("let x = 1; } let y = 2;");
    try testing.expect(result.nodes > 0);
}

test "recovery: double operator" {
    const result = try parseAndLint("let x = 1 ++ ++ 2;");
    try testing.expect(result.nodes > 0);
}

// ── Mixed valid and invalid ─────────────────────────────────

test "recovery: valid code after error" {
    const result = try parseAndLint(
        \\let x = ;
        \\let y = 2;
        \\console.log(y);
    );
    try testing.expect(result.nodes > 0);
}

test "recovery: multiple errors" {
    const result = try parseAndLint(
        \\function {
        \\  let = ;
        \\  if () {}
        \\}
    );
    try testing.expect(result.errors > 0);
}

// ── Linting still works on partial AST ──────────────────────

test "recovery: lint fires on valid nodes despite errors" {
    const allocator = testing.allocator;
    const source = "debugger;\nlet x = ;\neval('code');";

    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);

    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);

    try testing.expect(tree.errors.len > 0);
    try testing.expect(tree.nodes.len > 0);

    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);

    const diags = try linter.lint(allocator, &tree, &sem, null);
    defer allocator.free(diags);

    var found_debugger = false;
    for (diags) |d| {
        if (std.mem.eql(u8, d.rule_name, "no-debugger")) found_debugger = true;
    }
    try testing.expect(found_debugger);
}

// ── Empty/minimal input ─────────────────────────────────────

test "recovery: empty input" {
    const result = try parseAndLint("");
    try testing.expect(result.nodes > 0); // root node
    try testing.expectEqual(@as(usize, 0), result.errors);
}

test "recovery: only whitespace" {
    const result = try parseAndLint("   \n\n\t  ");
    try testing.expect(result.nodes > 0);
    try testing.expectEqual(@as(usize, 0), result.errors);
}

test "recovery: single token" {
    const result = try parseAndLint(";");
    try testing.expect(result.nodes > 0);
}

// ══════════════════════════════════════════════════════════════
// Parser Conformance Tests
// ══════════════════════════════════════════════════════════════
// Regression tests for specific parser fixes. Each test verifies
// that valid JS parses without errors and invalid JS produces errors.

fn mustParse(source: []const u8) !void {
    const allocator = testing.allocator;
    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    if (tree.errors.len > 0) {
        std.debug.print("Expected no parse errors, got {d}:\n", .{tree.errors.len});
        for (tree.errors) |e| {
            std.debug.print("  {s}\n", .{e.message});
        }
        return error.TestUnexpectedResult;
    }
}

fn mustError(source: []const u8) !void {
    const allocator = testing.allocator;
    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    if (tree.errors.len == 0) {
        std.debug.print("Expected parse errors but got none for: {s}\n", .{source});
        return error.TestUnexpectedResult;
    }
}

// ── Division vs Regex disambiguation ────────────────────────

test "conformance: division after object literal" {
    // {valueOf: function() {return 1}} / 1 — division, not regex
    try mustParse("if ({valueOf: function() {return 1}} / 1 !== 1) {}");
}

test "conformance: division after function expression" {
    // function(){} / x — division after function expression body
    try mustParse("if (isNaN(function(){return 1} / {}) !== true) {}");
    try mustParse("if (isNaN(function(){return 1} / function(){return 1}) !== true) {}");
}

test "conformance: regex after block statement" {
    // {label: expr} /regex/ — regex after block
    try mustParse("{length: 3000}/1/;");
}

test "conformance: division after various expressions" {
    try mustParse("var x = {a: 1} / 2;");
    try mustParse("var x = (1 + 2) / 3;");
    try mustParse("var x = [1][0] / 2;");
}

// ── Private identifiers with keyword names ──────────────────

test "conformance: private field with keyword name" {
    try mustParse(
        \\class C {
        \\  static #await() {}
        \\  static #yield() {}
        \\  static #let() {}
        \\}
    );
}

test "conformance: private member access with keyword name" {
    try mustParse(
        \\class C {
        \\  #await = 1;
        \\  method() { return this.#await; }
        \\}
    );
}

test "conformance: optional chaining with private keyword name" {
    try mustParse(
        \\class C {
        \\  #m = 'test';
        \\  static access(obj) { return obj?.#m; }
        \\}
    );
}

test "conformance: decorator with private identifier" {
    try mustParse(
        \\class C {
        \\  static #foo() {}
        \\  static { @C.#foo class D {} }
        \\}
    );
}

// ── await using in for-of ───────────────────────────────────

test "conformance: for await using of" {
    try mustParse("async function f() { for (await using of of []) {} }");
}

test "conformance: using in for statement" {
    try mustParse("for (using x = null;;) break;");
    try mustParse("for (using of = null;;) break;");
}

// ── let in restricted positions ─────────────────────────────

test "conformance: let in sub-statement is error" {
    try mustError("if(true) let a = 1;");
    try mustError("if (1) let x = 10;");
    try mustError("while(true) let a");
    try mustError("with(true) let a");
}

test "conformance: let after label is error" {
    try mustError("a: let a");
}

test "conformance: let with newline is identifier (valid)" {
    // ASI makes `let` an identifier expression
    try mustParse("for (; false; ) let\n{}");
}

// ── Template literal escape validation ──────────────────────

test "conformance: octal escape in template is error" {
    try mustError("`\\07`");
    try mustError("`\\1`");
    try mustError("`\\37`");
    try mustError("`\\00`");
}

test "conformance: legacy escape in template is error" {
    try mustError("`\\8`");
    try mustError("`\\9`");
}

test "conformance: valid template escapes" {
    try mustParse("`hello world`");
    try mustParse("`\\n\\t\\r`");
    try mustParse("`\\0`"); // null char (not followed by digit)
    try mustParse("`\\u0041`");
    try mustParse("`\\u{41}`");
    try mustParse("`\\x41`");
}

test "conformance: tagged template allows invalid escapes" {
    try mustParse("String.raw`\\01`");
    try mustParse("String.raw`\\8`");
    try mustParse("tag`\\unicode`");
}

// ── for-in/of with parenthesized patterns (no crash) ────────

test "conformance: parenthesized pattern in for-in does not crash" {
    // These should error but not crash/abort
    try mustError("for(([0]) in 0);");
    try mustError("for(({a: 0}) in 0);");
}

test "conformance: parenthesized pattern in for-of does not crash" {
    try mustError("for(([0]) of 0);");
    try mustError("for(({a: 0}) of 0);");
}

// ── yield and with in strict mode (no OOM) ──────────────────

test "conformance: yield in strict function does not OOM" {
    // Should parse without crashing (may have errors in output)
    const allocator = testing.allocator;
    const source = "function a() { \"use strict\"; yield = 1; }";
    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    try testing.expect(tree.nodes.len > 0);
}

// ── for-of let prohibition ──────────────────────────────────

test "conformance: for-of with let LHS is error" {
    try mustError("for(let of 0);");
    try mustError("for(let.a of 0);");
}

test "conformance: for-in with let LHS is valid" {
    try mustParse("for (let in {}) ;");
}

// ── Parenthesized destructuring in for-in/of ────────────────

test "conformance: parenthesized array pattern in for-of is error" {
    try mustError("for(([a]) of 0);");
    try mustError("for(([a]) in 0);");
}

test "conformance: parenthesized object pattern in for-of is error" {
    try mustError("for(({a}) of 0);");
    try mustError("for(({a}) in 0);");
}

// ── Destructuring assignment validation ─────────────────────

test "conformance: literal value in destructuring is error" {
    try mustError("({ obj:20 }) = 42");
}

test "conformance: shorthand with string key in destructuring is error" {
    try mustError("({ \"chance\" }) = obj");
}

test "conformance: shorthand with number key in destructuring is error" {
    try mustError("({ 42 }) = obj");
}

test "conformance: getter in destructuring is error" {
    try mustError("({get a(){}})=0");
    try mustError("( { get x() {} } ) = 0");
}

test "conformance: strict eval/arguments in destructuring is error" {
    try mustError("\"use strict\"; ({ v: eval }) = obj");
    try mustError("\"use strict\"; ({ v: arguments }) = obj");
}

test "conformance: parenthesized destructuring pattern is error" {
    try mustError("(([a])=0);");
    try mustError("(({a})=0);");
}

test "conformance: ternary result as for-in LHS is error" {
    try mustError("for(let ? b : c in 0);");
}

test "conformance: template tail escape validation" {
    // Template `${expr}\02` — octal in tail section
    try mustError("\"use strict\"; `${test}\\02`;");
}

test "conformance: regex backref to non-existent group in unicode mode" {
    try mustError("/\\1/u");
}

test "conformance: regex backref to existing group in unicode mode is valid" {
    try mustParse("/(a)\\1/u;");
}

test "conformance: valid destructuring still works" {
    try mustParse("var {a, b} = {a: 1, b: 2};");
    try mustParse("var [x, y] = [1, 2];");
    try mustParse("({a, b} = {a: 1, b: 2});");
}

// ── Error recovery limits ───────────────────────────────────

test "conformance: unassigned unicode codepoint rejected as identifier" {
    try mustError("var \xf0\xab\xa0\x9e_ = 12;"); // U+2B81E (Cn, unassigned)
}

// ── HTML comments (Annex B) ─────────────────────────────────

test "conformance: HTML open comment <!-- is treated as line comment" {
    try mustParse("<!-- this is a comment\nvar x = 1;");
    try mustParse("<!--");
    try mustParse("<!-- foo");
}

test "conformance: HTML close comment --> at line start" {
    try mustParse("--> comment\nvar x = 1;");
    try mustParse("\n  --> comment\nvar x = 1;");
}

test "conformance: --> not at line start is decrement + greater-than" {
    try mustParse("a = b-->1;");
}

test "conformance: cascading errors do not OOM" {
    // Large file with many errors should not crash
    const allocator = testing.allocator;
    // Generate a source with many invalid statements
    var buf: [4096]u8 = undefined;
    var len: usize = 0;
    for (0..100) |_| {
        const stmt = "var : = ;\n";
        @memcpy(buf[len..][0..stmt.len], stmt);
        len += stmt.len;
    }
    var tokens = try Lexer.tokenize(allocator, buf[0..len]);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, buf[0..len], tokens.slice());
    defer tree.deinit(allocator);
    try testing.expect(tree.nodes.len > 0);
}

test "conformance: with in strict mode does not OOM" {
    const allocator = testing.allocator;
    const source = "(function () { 'use strict'; with (a); }())";
    var tokens = try Lexer.tokenize(allocator, source);
    defer tokens.deinit(allocator);
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    try testing.expect(tree.nodes.len > 0);
}
