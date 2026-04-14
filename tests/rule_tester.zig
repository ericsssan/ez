const std = @import("std");
const testing = std.testing;
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const linter = ez.linter;
const LintDiagnostic = ez.lint_context.LintDiagnostic;
const Language = ez.token.Language;

// ── Types ────────────────────────────────────────────────────

pub const InvalidCase = struct {
    code: []const u8,
    errors: usize = 1,
};

pub const Spec = struct {
    rule: []const u8,
    valid: []const []const u8 = &.{},
    invalid: []const InvalidCase = &.{},
    lang: Language = .js,
};

// ── RuleTester ───────────────────────────────────────────────

pub const RuleTester = struct {
    /// Run valid/invalid test cases for a single rule.
    ///
    /// Usage:
    ///   try RuleTester.run(.{
    ///       .rule = "no-debugger",
    ///       .valid = &.{ "var x = 1;", "console.log()" },
    ///       .invalid = &.{
    ///           .{ .code = "debugger;" },
    ///           .{ .code = "debugger; debugger;", .errors = 2 },
    ///       },
    ///   });
    pub fn run(spec: Spec) !void {
        for (spec.valid) |code| {
            try expectClean(spec.rule, code, spec.lang);
        }
        for (spec.invalid) |case| {
            try expectErrors(spec.rule, case.code, case.errors, spec.lang);
        }
    }

    fn expectClean(rule: []const u8, code: []const u8, lang: Language) !void {
        const diags = try lintWithLang(code, lang);
        defer testing.allocator.free(diags);

        for (diags) |d| {
            const name = linter.rule_names[d.rule_index];
            if (std.mem.eql(u8, name, rule)) {
                std.debug.print("\n  FAIL (valid): '{s}' should not fire on:\n    {s}\n", .{ rule, code });
                return error.TestExpectedEqual;
            }
        }
    }

    fn expectErrors(rule: []const u8, code: []const u8, expected: usize, lang: Language) !void {
        const diags = try lintWithLang(code, lang);
        defer testing.allocator.free(diags);

        var actual: usize = 0;
        for (diags) |d| {
            if (std.mem.eql(u8, linter.rule_names[d.rule_index], rule)) actual += 1;
        }

        if (actual != expected) {
            std.debug.print("\n  FAIL (invalid): '{s}' — expected {d} error(s), got {d} on:\n    {s}\n", .{ rule, expected, actual, code });
            if (actual == 0) {
                std.debug.print("  All diagnostics ({d}):\n", .{diags.len});
                for (diags) |d| {
                    std.debug.print("    - {s}\n", .{linter.rule_names[d.rule_index]});
                }
            }
            return error.TestExpectedEqual;
        }
    }
};

// ── Pipeline ─────────────────────────────────────────────────

fn lintWithLang(source: []const u8, lang: Language) ![]const LintDiagnostic {
    const allocator = testing.allocator;

    var lex_result = try Lexer.tokenizeWithLanguage(allocator, source, lang);
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;

    var tree = try Parser.parseWithLanguage(allocator, source, tokens.slice(), lang, false);
    defer tree.deinit(allocator);

    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);

    return linter.lint(allocator, &tree, &sem, null);
}
