const std = @import("std");
const testing = std.testing;
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const SemanticAnalyzer = ez.semantic.SemanticAnalyzer;
const linter = ez.linter;
const LintDiagnostic = ez.lint_context.LintDiagnostic;
const Config = ez.config.Config;
const RuleSeverity = ez.config.RuleSeverity;
const InlineDisables = ez.inline_disable.InlineDisables;

// ── Config Integration Tests ─────────────────────────────────
// Tests the full config chain: config → severity overrides →
// inline disables → final diagnostic output.

fn lintWithConfig(source: []const u8, config: ?*const Config) ![]const LintDiagnostic {
    const allocator = testing.allocator;
    var _lr = try Lexer.tokenize(allocator, source); defer _lr.deinit(allocator); var tokens = _lr.tokens;
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);
    return linter.lint(allocator, &tree, &sem, config, .js);
}

fn lintWithInlineDisables(source: []const u8) ![]const LintDiagnostic {
    const allocator = testing.allocator;
    var _lr = try Lexer.tokenize(allocator, source); defer _lr.deinit(allocator); var tokens = _lr.tokens;
    var tree = try Parser.parse(allocator, source, tokens.slice());
    defer tree.deinit(allocator);
    var sem = try SemanticAnalyzer.analyze(allocator, &tree);
    defer sem.deinit(allocator);
    const raw = try linter.lint(allocator, &tree, &sem, null, .js);
    defer allocator.free(raw);
    var disables = InlineDisables.parse(allocator, source) catch InlineDisables.empty();
    defer disables.deinit();
    return linter.filterByInlineDisables(allocator, raw, &disables, source);
}

fn hasRule(diags: []const LintDiagnostic, rule: []const u8) bool {
    for (diags) |d| {
        if (std.mem.eql(u8, linter.rule_names[d.rule_index], rule)) return true;
    }
    return false;
}

// ── Severity override via Config ─────────────────────────────

test "config: rule turned off produces no diagnostic" {
    const allocator = testing.allocator;
    var config = Config.initDefault(allocator);
    defer config.deinit();
    try config.rule_severities.put(allocator, "no-debugger", .off);
    config.buildSeverityTable();

    const diags = try lintWithConfig("debugger;", &config);
    defer allocator.free(diags);
    try testing.expect(!hasRule(diags, "no-debugger"));
}

test "config: rule set to error still fires" {
    const allocator = testing.allocator;
    var config = Config.initDefault(allocator);
    defer config.deinit();
    try config.rule_severities.put(allocator, "no-debugger", .@"error");
    config.buildSeverityTable();

    const diags = try lintWithConfig("debugger;", &config);
    defer allocator.free(diags);
    try testing.expect(hasRule(diags, "no-debugger"));
}

test "config: multiple rules toggled off" {
    const allocator = testing.allocator;
    var config = Config.initDefault(allocator);
    defer config.deinit();
    try config.rule_severities.put(allocator, "no-debugger", .off);
    try config.rule_severities.put(allocator, "no-eval", .off);
    config.buildSeverityTable();

    const diags = try lintWithConfig("debugger; eval('x');", &config);
    defer allocator.free(diags);
    try testing.expect(!hasRule(diags, "no-debugger"));
    try testing.expect(!hasRule(diags, "no-eval"));
}

test "config: null config enables all rules with defaults" {
    const diags = try lintWithConfig("debugger;", null);
    defer testing.allocator.free(diags);
    try testing.expect(hasRule(diags, "no-debugger"));
}

// ── Inline disable directives ────────────────────────────────

test "inline disable: next-line suppresses diagnostic" {
    const diags = try lintWithInlineDisables(
        \\// ez-disable-next-line no-debugger
        \\debugger;
    );
    defer testing.allocator.free(diags);
    try testing.expect(!hasRule(diags, "no-debugger"));
}

test "inline disable: wrong rule name does not suppress" {
    const diags = try lintWithInlineDisables(
        \\// ez-disable-next-line no-eval
        \\debugger;
    );
    defer testing.allocator.free(diags);
    try testing.expect(hasRule(diags, "no-debugger"));
}

test "inline disable: block disable/enable range" {
    const diags = try lintWithInlineDisables(
        \\// ez-disable no-debugger
        \\debugger;
        \\debugger;
        \\// ez-enable no-debugger
        \\debugger;
    );
    defer testing.allocator.free(diags);

    var count: usize = 0;
    for (diags) |d| {
        if (std.mem.eql(u8, linter.rule_names[d.rule_index], "no-debugger")) count += 1;
    }
    try testing.expectEqual(@as(usize, 1), count);
}

test "inline disable: disable all rules" {
    const diags = try lintWithInlineDisables(
        \\// ez-disable
        \\debugger;
        \\eval('x');
    );
    defer testing.allocator.free(diags);
    try testing.expect(!hasRule(diags, "no-debugger"));
    try testing.expect(!hasRule(diags, "no-eval"));
}

test "inline disable: in block comment" {
    const diags = try lintWithInlineDisables(
        \\/* ez-disable-next-line no-debugger */
        \\debugger;
    );
    defer testing.allocator.free(diags);
    try testing.expect(!hasRule(diags, "no-debugger"));
}

test "inline disable: inside string is not a directive" {
    const diags = try lintWithInlineDisables(
        \\let x = "// ez-disable-next-line no-debugger";
        \\debugger;
    );
    defer testing.allocator.free(diags);
    try testing.expect(hasRule(diags, "no-debugger"));
}

// ── Config + inline disable combined ─────────────────────────

test "config off overrides everything" {
    const allocator = testing.allocator;
    var config = Config.initDefault(allocator);
    defer config.deinit();
    try config.rule_severities.put(allocator, "no-debugger", .off);
    config.buildSeverityTable();

    const raw = try lintWithConfig("debugger;", &config);
    defer allocator.free(raw);
    try testing.expect(!hasRule(raw, "no-debugger"));
}
