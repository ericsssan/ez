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
