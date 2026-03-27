const std = @import("std");
const Config = @import("config.zig").Config;
const RuleSeverity = @import("config.zig").RuleSeverity;
const applyPreset = @import("config.zig").applyPreset;

// ── ESLint Rule Name Mapping ──────────────────────────────────────
//
// Maps ESLint rule names (including @typescript-eslint/ prefixed ones)
// to Sx3lint rule names.  Most rules share the same name in both
// linters; the TypeScript rules additionally accept the namespaced
// ESLint form.

pub const eslint_rule_map = std.StaticStringMap([]const u8).initComptime(.{
    // ── Correctness (40) ──────────────────────────────────────────
    .{ "no-debugger", "no-debugger" },
    .{ "no-empty", "no-empty" },
    .{ "no-extra-semi", "no-extra-semi" },
    .{ "no-dupe-keys", "no-dupe-keys" },
    .{ "no-dupe-args", "no-dupe-args" },
    .{ "no-sparse-arrays", "no-sparse-arrays" },
    .{ "no-unreachable", "no-unreachable" },
    .{ "no-unsafe-negation", "no-unsafe-negation" },
    .{ "use-isnan", "use-isnan" },
    .{ "valid-typeof", "valid-typeof" },
    .{ "no-unused-vars", "no-unused-vars" },
    .{ "no-undef", "no-undef" },
    .{ "no-constant-condition", "no-constant-condition" },
    .{ "no-func-assign", "no-func-assign" },
    .{ "no-import-assign", "no-import-assign" },
    .{ "no-self-assign", "no-self-assign" },
    .{ "no-self-compare", "no-self-compare" },
    .{ "no-unsafe-optional-chaining", "no-unsafe-optional-chaining" },
    .{ "no-loss-of-precision", "no-loss-of-precision" },
    .{ "no-const-assign", "no-const-assign" },
    .{ "for-direction", "for-direction" },
    .{ "getter-return", "getter-return" },
    .{ "no-async-promise-executor", "no-async-promise-executor" },
    .{ "no-compare-neg-zero", "no-compare-neg-zero" },
    .{ "no-dupe-class-members", "no-dupe-class-members" },
    .{ "no-dupe-else-if", "no-dupe-else-if" },
    .{ "no-duplicate-case", "no-duplicate-case" },
    .{ "no-empty-pattern", "no-empty-pattern" },
    .{ "no-ex-assign", "no-ex-assign" },
    .{ "no-fallthrough", "no-fallthrough" },
    .{ "no-global-assign", "no-global-assign" },
    .{ "no-inner-declarations", "no-inner-declarations" },
    .{ "no-irregular-whitespace", "no-irregular-whitespace" },
    .{ "no-new-symbol", "no-new-symbol" },
    .{ "no-obj-calls", "no-obj-calls" },
    .{ "no-prototype-builtins", "no-prototype-builtins" },
    .{ "no-setter-return", "no-setter-return" },
    .{ "no-template-curly-in-string", "no-template-curly-in-string" },
    .{ "no-this-before-super", "no-this-before-super" },
    .{ "no-useless-catch", "no-useless-catch" },

    // ── Suspicious (28) ──────────────────────────────────────────
    .{ "eqeqeq", "eqeqeq" },
    .{ "no-cond-assign", "no-cond-assign" },
    .{ "no-control-regex", "no-control-regex" },
    .{ "no-delete-var", "no-delete-var" },
    .{ "no-empty-character-class", "no-empty-character-class" },
    .{ "no-eval", "no-eval" },
    .{ "no-implied-eval", "no-implied-eval" },
    .{ "no-label-var", "no-label-var" },
    .{ "no-lone-blocks", "no-lone-blocks" },
    .{ "no-misleading-character-class", "no-misleading-character-class" },
    .{ "no-mixed-spaces-and-tabs", "no-mixed-spaces-and-tabs" },
    .{ "no-multi-str", "no-multi-str" },
    .{ "no-new-wrappers", "no-new-wrappers" },
    .{ "no-nonoctal-decimal-escape", "no-nonoctal-decimal-escape" },
    .{ "no-octal", "no-octal" },
    .{ "no-redeclare", "no-redeclare" },
    .{ "no-regex-spaces", "no-regex-spaces" },
    .{ "no-restricted-globals", "no-restricted-globals" },
    .{ "no-shadow-restricted-names", "no-shadow-restricted-names" },
    .{ "no-unsafe-finally", "no-unsafe-finally" },
    .{ "no-unused-labels", "no-unused-labels" },
    .{ "no-useless-escape", "no-useless-escape" },
    .{ "no-void", "no-void" },
    .{ "no-with", "no-with" },
    .{ "require-yield", "require-yield" },
    .{ "no-case-declarations", "no-case-declarations" },
    .{ "no-sequences", "no-sequences" },
    .{ "no-throw-literal", "no-throw-literal" },

    // ── Style (30) ───────────────────────────────────────────────
    .{ "no-var", "no-var" },
    .{ "prefer-const", "prefer-const" },
    .{ "no-array-constructor", "no-array-constructor" },
    .{ "no-bitwise", "no-bitwise" },
    .{ "no-caller", "no-caller" },
    .{ "no-continue", "no-continue" },
    .{ "no-else-return", "no-else-return" },
    .{ "no-eq-null", "no-eq-null" },
    .{ "no-extend-native", "no-extend-native" },
    .{ "no-extra-bind", "no-extra-bind" },
    .{ "no-extra-boolean-cast", "no-extra-boolean-cast" },
    .{ "no-floating-decimal", "no-floating-decimal" },
    .{ "no-iterator", "no-iterator" },
    .{ "no-labels", "no-labels" },
    .{ "no-lonely-if", "no-lonely-if" },
    .{ "no-multi-assign", "no-multi-assign" },
    .{ "no-negated-condition", "no-negated-condition" },
    .{ "no-nested-ternary", "no-nested-ternary" },
    .{ "no-new", "no-new" },
    .{ "no-new-func", "no-new-func" },
    .{ "no-new-object", "no-new-object" },
    .{ "no-octal-escape", "no-octal-escape" },
    .{ "no-param-reassign", "no-param-reassign" },
    .{ "no-plusplus", "no-plusplus" },
    .{ "no-proto", "no-proto" },
    .{ "no-return-assign", "no-return-assign" },
    .{ "no-script-url", "no-script-url" },
    .{ "no-unneeded-ternary", "no-unneeded-ternary" },
    .{ "no-useless-computed-key", "no-useless-computed-key" },
    .{ "prefer-template", "prefer-template" },

    // ── TypeScript (8) — direct names ────────────────────────────
    .{ "no-explicit-any", "no-explicit-any" },
    .{ "no-non-null-assertion", "no-non-null-assertion" },
    .{ "prefer-as-const", "prefer-as-const" },
    .{ "no-empty-interface", "no-empty-interface" },
    .{ "no-namespace", "no-namespace" },
    .{ "no-unnecessary-type-assertion", "no-unnecessary-type-assertion" },
    .{ "prefer-interface", "prefer-interface" },
    .{ "no-require-imports", "no-require-imports" },

    // ── TypeScript (8) — @typescript-eslint/ prefixed ────────────
    .{ "@typescript-eslint/no-explicit-any", "no-explicit-any" },
    .{ "@typescript-eslint/no-non-null-assertion", "no-non-null-assertion" },
    .{ "@typescript-eslint/prefer-as-const", "prefer-as-const" },
    .{ "@typescript-eslint/no-empty-interface", "no-empty-interface" },
    .{ "@typescript-eslint/no-namespace", "no-namespace" },
    .{ "@typescript-eslint/no-unnecessary-type-assertion", "no-unnecessary-type-assertion" },
    .{ "@typescript-eslint/prefer-interface", "prefer-interface" },
    .{ "@typescript-eslint/no-require-imports", "no-require-imports" },

    // ── Common ESLint aliases ────────────────────────────────────
    .{ "no-constant-binary-expression", "no-constant-condition" },
});

// ── ESLint Config Parsing ─────────────────────────────────────────

/// Parse an `.eslintrc.json` file and convert it to an Sx3lint `Config`.
///
/// Supported ESLint config fields:
///   - `"extends"`: array of strings — recognises `"eslint:recommended"`
///   - `"rules"`: object mapping rule names to severities
///
/// Rule severities may be:
///   - A string: `"off"`, `"warn"`, `"error"`
///   - An integer: `0` (off), `1` (warn), `2` (error)
///   - An array whose first element is a string or integer severity
///     (extra options are ignored)
///
/// Unknown rule names (no mapping in `eslint_rule_map`) are silently
/// skipped.
pub fn parseEslintConfig(allocator: std.mem.Allocator, json_source: []const u8) !Config {
    var parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_source, .{});
    errdefer parsed.deinit();

    const root = parsed.value;
    if (root != .object) return error.InvalidConfig;

    var config = Config{
        .rule_severities = .{},
        .include_patterns = &.{},
        .exclude_patterns = &.{},
        .overrides = &.{},
        .rule_severity_table = undefined,
        .allocator = allocator,
        .json_parsed = parsed,
    };

    // 1. Handle "extends" — look for "eslint:recommended"
    if (root.object.get("extends")) |extends_val| {
        switch (extends_val) {
            .array => |arr| {
                for (arr.items) |item| {
                    if (item == .string) {
                        if (std.mem.eql(u8, item.string, "eslint:recommended")) {
                            applyPreset(&config, "recommended");
                        }
                    }
                }
            },
            .string => |s| {
                if (std.mem.eql(u8, s, "eslint:recommended")) {
                    applyPreset(&config, "recommended");
                }
            },
            else => {},
        }
    }

    // 2. Handle "rules" — map ESLint rule names to Sx3lint and parse severities
    if (root.object.get("rules")) |rules_val| {
        if (rules_val == .object) {
            var rule_iter = rules_val.object.iterator();
            while (rule_iter.next()) |entry| {
                const eslint_name = entry.key_ptr.*;
                const sx3_name = eslint_rule_map.get(eslint_name) orelse continue;

                const severity = parseSeverityValue(entry.value_ptr.*) orelse continue;
                config.rule_severities.put(allocator, sx3_name, severity) catch {};
            }
        }
    }

    // 3. Build the comptime-indexed severity table
    config.buildSeverityTable();

    return config;
}

// ── Helpers ───────────────────────────────────────────────────────

/// Extract a `RuleSeverity` from an ESLint rule value.
///
/// Handles all three ESLint formats:
///   - String: `"off"` / `"warn"` / `"error"`
///   - Integer: `0` / `1` / `2`
///   - Array: first element is a string or integer severity
fn parseSeverityValue(value: std.json.Value) ?RuleSeverity {
    switch (value) {
        .string => |s| return RuleSeverity.fromString(s),
        .integer => |n| return severityFromInt(n),
        .array => |arr| {
            if (arr.items.len == 0) return null;
            const first = arr.items[0];
            switch (first) {
                .string => |s| return RuleSeverity.fromString(s),
                .integer => |n| return severityFromInt(n),
                else => return null,
            }
        },
        else => return null,
    }
}

/// Map an ESLint numeric severity (0/1/2) to a `RuleSeverity`.
fn severityFromInt(n: i64) ?RuleSeverity {
    return switch (n) {
        0 => .off,
        1 => .warning,
        2 => .@"error",
        else => null,
    };
}

// ── Tests ─────────────────────────────────────────────────────────

test "eslint rule map" {
    const expect = std.testing.expect;

    // Direct matches
    try expect(eslint_rule_map.get("no-debugger") != null);
    try std.testing.expectEqualStrings("no-debugger", eslint_rule_map.get("no-debugger").?);

    try expect(eslint_rule_map.get("eqeqeq") != null);
    try std.testing.expectEqualStrings("eqeqeq", eslint_rule_map.get("eqeqeq").?);

    try expect(eslint_rule_map.get("prefer-const") != null);
    try std.testing.expectEqualStrings("prefer-const", eslint_rule_map.get("prefer-const").?);

    // TypeScript prefixed
    try expect(eslint_rule_map.get("@typescript-eslint/no-explicit-any") != null);
    try std.testing.expectEqualStrings(
        "no-explicit-any",
        eslint_rule_map.get("@typescript-eslint/no-explicit-any").?,
    );

    // Alias
    try expect(eslint_rule_map.get("no-constant-binary-expression") != null);
    try std.testing.expectEqualStrings(
        "no-constant-condition",
        eslint_rule_map.get("no-constant-binary-expression").?,
    );

    // Unknown rule returns null
    try expect(eslint_rule_map.get("some-unknown-rule") == null);
}

test "parseEslintConfig basic" {
    const json =
        \\{
        \\  "rules": {
        \\    "no-debugger": "error",
        \\    "eqeqeq": "warn",
        \\    "no-var": "off"
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // no-debugger -> error
    const debugger_sev = config.rule_severities.get("no-debugger");
    try std.testing.expect(debugger_sev != null);
    try std.testing.expect(debugger_sev.? == .@"error");

    // eqeqeq -> warning
    const eqeqeq_sev = config.rule_severities.get("eqeqeq");
    try std.testing.expect(eqeqeq_sev != null);
    try std.testing.expect(eqeqeq_sev.? == .warning);

    // no-var -> off
    const novar_sev = config.rule_severities.get("no-var");
    try std.testing.expect(novar_sev != null);
    try std.testing.expect(novar_sev.? == .off);
}

test "parseEslintConfig array severity" {
    const json =
        \\{
        \\  "rules": {
        \\    "eqeqeq": ["warn", "always"],
        \\    "no-unused-vars": ["error", { "args": "after-used" }]
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // eqeqeq -> warning (first element of array)
    const eqeqeq_sev = config.rule_severities.get("eqeqeq");
    try std.testing.expect(eqeqeq_sev != null);
    try std.testing.expect(eqeqeq_sev.? == .warning);

    // no-unused-vars -> error
    const unused_sev = config.rule_severities.get("no-unused-vars");
    try std.testing.expect(unused_sev != null);
    try std.testing.expect(unused_sev.? == .@"error");
}

test "parseEslintConfig extends recommended" {
    const json =
        \\{
        \\  "extends": ["eslint:recommended"],
        \\  "rules": {
        \\    "no-debugger": "off"
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // The "recommended" preset sets correctness rules to error.
    // no-unreachable is a correctness rule — should be error from preset.
    const unreachable_sev = config.rule_severities.get("no-unreachable");
    try std.testing.expect(unreachable_sev != null);
    try std.testing.expect(unreachable_sev.? == .@"error");

    // But no-debugger was explicitly overridden to off after the preset.
    const debugger_sev = config.rule_severities.get("no-debugger");
    try std.testing.expect(debugger_sev != null);
    try std.testing.expect(debugger_sev.? == .off);

    // The severity table should reflect the override for no-debugger (index 0).
    try std.testing.expect(config.rule_severity_table[0] == .off);
}

test "parseEslintConfig integer severity" {
    const json =
        \\{
        \\  "rules": {
        \\    "no-unused-vars": 2,
        \\    "no-var": 0,
        \\    "prefer-const": 1
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // no-unused-vars -> error (2)
    const unused_sev = config.rule_severities.get("no-unused-vars");
    try std.testing.expect(unused_sev != null);
    try std.testing.expect(unused_sev.? == .@"error");

    // no-var -> off (0)
    const novar_sev = config.rule_severities.get("no-var");
    try std.testing.expect(novar_sev != null);
    try std.testing.expect(novar_sev.? == .off);

    // prefer-const -> warning (1)
    const prefconst_sev = config.rule_severities.get("prefer-const");
    try std.testing.expect(prefconst_sev != null);
    try std.testing.expect(prefconst_sev.? == .warning);
}

test "parseEslintConfig typescript prefixed rules" {
    const json =
        \\{
        \\  "rules": {
        \\    "@typescript-eslint/no-explicit-any": "warn",
        \\    "@typescript-eslint/no-namespace": "error"
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // @typescript-eslint/no-explicit-any -> no-explicit-any -> warning
    const any_sev = config.rule_severities.get("no-explicit-any");
    try std.testing.expect(any_sev != null);
    try std.testing.expect(any_sev.? == .warning);

    // @typescript-eslint/no-namespace -> no-namespace -> error
    const ns_sev = config.rule_severities.get("no-namespace");
    try std.testing.expect(ns_sev != null);
    try std.testing.expect(ns_sev.? == .@"error");
}

test "parseEslintConfig unknown rules skipped" {
    const json =
        \\{
        \\  "rules": {
        \\    "some-plugin/unknown-rule": "error",
        \\    "no-debugger": "warn"
        \\  }
        \\}
    ;

    var config = try parseEslintConfig(std.testing.allocator, json);
    defer config.deinit();

    // Unknown rule should not appear
    try std.testing.expect(config.rule_severities.get("some-plugin/unknown-rule") == null);

    // Known rule should still be parsed
    const debugger_sev = config.rule_severities.get("no-debugger");
    try std.testing.expect(debugger_sev != null);
    try std.testing.expect(debugger_sev.? == .warning);
}
