const std = @import("std");
const Severity = @import("es_parser").diagnostic.Severity;
const registry = @import("native/registry.zig");
const Category = @import("native/rule.zig").Category;
const linter = @import("linter.zig");
const globMatch = @import("gitignore.zig").globMatch;

// ── Rule Severity ──────────────────────────────────────────────────

pub const RuleSeverity = enum {
    off,
    warning,
    @"error",

    /// Parse a string into a RuleSeverity.
    /// Accepts: "off", "warning", "warn", "error", "0", "1", "2".
    pub fn fromString(s: []const u8) ?RuleSeverity {
        if (std.mem.eql(u8, s, "off") or std.mem.eql(u8, s, "0")) return .off;
        if (std.mem.eql(u8, s, "warning") or std.mem.eql(u8, s, "warn") or std.mem.eql(u8, s, "1")) return .warning;
        if (std.mem.eql(u8, s, "error") or std.mem.eql(u8, s, "2")) return .@"error";
        return null;
    }

    /// Convert to the diagnostic Severity. Returns null for `.off`.
    pub fn toSeverity(self: RuleSeverity) ?Severity {
        return switch (self) {
            .off => null,
            .warning => .warning,
            .@"error" => .@"error",
        };
    }

    /// Parse an integer (0=off, 1=warning, ≥2=error) into a RuleSeverity.
    pub fn fromInt(n: i64) RuleSeverity {
        return if (n == 0) .off else if (n == 1) .warning else .@"error";
    }

    /// Map a diagnostic Severity to the corresponding RuleSeverity.
    pub fn fromSeverity(sev: Severity) RuleSeverity {
        return switch (sev) {
            .@"error" => .@"error",
            .warning => .warning,
            .info => .warning,
            .hint => .off,
        };
    }
};

// ── Override ───────────────────────────────────────────────────────

pub const Override = struct {
    file_patterns: []const []const u8,
    rule_severities: std.StringHashMapUnmanaged(RuleSeverity),
};

// ── Config ────────────────────────────────────────────────────────

pub const Config = struct {
    rule_severities: std.StringHashMapUnmanaged(RuleSeverity),
    include_patterns: []const []const u8,
    exclude_patterns: []const []const u8,
    overrides: []const Override,
    rule_severity_table: [rule_count]RuleSeverity,
    /// Per-rule JSON options value. null = no options configured.
    /// Points into the retained json_parsed tree — valid for the config's lifetime.
    rule_options: [rule_count]?*const std.json.Value = @splat(null),
    /// Second rule option (items[2] when config has 3+ elements). null if absent.
    rule_options2: [rule_count]?*const std.json.Value = @splat(null),
    /// Slice of all options (items[1..]) for rules like no-restricted-globals
    /// that take a variable-length list.  Lifetime tied to the config arena.
    rule_options_all: [rule_count]?[]std.json.Value = @splat(null),
    /// Synthetic JSON array values allocated for rules with 2+ options.
    /// (reserved for future use — currently unused)
    synthetic_options: std.ArrayListUnmanaged(*std.json.Value) = .empty,
    /// ESLint `settings` object. Points into the retained json_parsed tree.
    settings: ?*const std.json.Value = null,
    /// ESLint `languageOptions` object. Points into the retained json_parsed tree.
    language_options: ?*const std.json.Value = null,
    allocator: std.mem.Allocator,
    /// Retained JSON parse tree — keeps string pointers alive when config
    /// was loaded from JSON.  Null for programmatically constructed configs.
    json_parsed: ?std.json.Parsed(std.json.Value) = null,

    const rule_count = registry.count;

    /// Create a default configuration: every rule at its default severity,
    /// no include/exclude patterns, no overrides.
    pub fn initDefault(allocator: std.mem.Allocator) Config {
        var config = blankConfig(allocator);
        config.buildSeverityTable();
        return config;
    }

    /// Create an all-off configuration: every rule disabled.
    pub fn initAllOff(allocator: std.mem.Allocator) Config {
        var config = blankConfig(allocator);
        config.buildSeverityTableWithDefault(.off);
        return config;
    }

    pub fn deinit(self: *Config) void {
        self.rule_severities.deinit(self.allocator);

        // Free allocated pattern slices (the strings themselves are owned
        // by the retained JSON tree or are comptime literals).
        if (self.include_patterns.len > 0) {
            self.allocator.free(self.include_patterns);
        }
        if (self.exclude_patterns.len > 0) {
            self.allocator.free(self.exclude_patterns);
        }

        // Free overrides.
        if (self.overrides.len > 0) {
            const mutable_overrides = @constCast(self.overrides);
            for (mutable_overrides) |*ov| {
                ov.rule_severities.deinit(self.allocator);
                if (ov.file_patterns.len > 0) {
                    self.allocator.free(ov.file_patterns);
                }
            }
            self.allocator.free(self.overrides);
        }

        // Free synthetic option arrays (allocated for multi-option rules).
        for (self.synthetic_options.items) |v| {
            self.allocator.destroy(v);
        }
        self.synthetic_options.deinit(self.allocator);

        // Release the JSON parse tree (frees all JSON string memory).
        if (self.json_parsed) |*jp| {
            jp.deinit();
        }
    }

    /// Check whether a file path should be linted according to include/exclude.
    pub fn hasPatterns(self: *const Config) bool {
        return self.include_patterns.len > 0 or self.exclude_patterns.len > 0;
    }

    ///   - If include_patterns is empty, all files are included.
    ///   - If include_patterns is non-empty, the path must match at least one.
    ///   - If the path matches any exclude_pattern, it is excluded.
    pub fn shouldLintFile(self: *const Config, path: []const u8) bool {
        // Check excludes first — an excluded file is always excluded.
        for (self.exclude_patterns) |pat| {
            if (globMatch(pat, path)) return false;
        }

        // If no include patterns, include everything.
        if (self.include_patterns.len == 0) return true;

        // Otherwise, must match at least one include pattern.
        for (self.include_patterns) |pat| {
            if (globMatch(pat, path)) return true;
        }
        return false;
    }

    /// Populate `rule_severity_table` from the rule_severities hashmap
    /// and rule default severities.  Uses comptime iteration so the table
    /// is indexed by the same comptime index as `registry.all_rules`.
    pub fn buildSeverityTable(self: *Config) void {
        for (0..rule_count) |i| {
            self.rule_severity_table[i] = self.rule_severities.get(linter.rule_names[i]) orelse linter.default_severities[i];
        }
    }

    /// Like buildSeverityTable but uses a uniform `default` for rules not
    /// in rule_severities (instead of per-rule registry defaults).
    pub fn buildSeverityTableWithDefault(self: *Config, default: RuleSeverity) void {
        for (0..rule_count) |i| {
            self.rule_severity_table[i] = self.rule_severities.get(linter.rule_names[i]) orelse default;
        }
    }
};

// ── Presets ────────────────────────────────────────────────────────

/// Apply a named preset to a config, setting rule severities by category.
pub fn applyPreset(config: *Config, name: []const u8) void {
    if (std.mem.eql(u8, name, "recommended")) {
        for (0..registry.count) |i| {
            const sev: RuleSeverity = switch (linter.rule_categories[i]) {
                .correctness => .@"error",
                .suspicious => .warning,
                .style, .performance => .off,
            };
            config.rule_severities.put(config.allocator, linter.rule_names[i], sev) catch {};
        }
    } else if (std.mem.eql(u8, name, "all")) {
        for (0..registry.count) |i| {
            config.rule_severities.put(config.allocator, linter.rule_names[i], linter.default_severities[i]) catch {};
        }
    } else if (std.mem.eql(u8, name, "strict")) {
        for (0..registry.count) |i| {
            config.rule_severities.put(config.allocator, linter.rule_names[i], .@"error") catch {};
        }
    }
}

// ── JSON Config Parsing ───────────────────────────────────────────

/// Parse a `ez.config.json` file from raw JSON source.
pub fn parseConfigJson(allocator: std.mem.Allocator, json_source: []const u8) !Config {
    var parsed = try std.json.parseFromSlice(std.json.Value, allocator, json_source, .{});
    errdefer parsed.deinit();

    const root = parsed.value;
    if (root != .object) return error.InvalidConfig;

    var config = blankConfig(allocator);
    config.json_parsed = parsed;

    // 1. "extends" — array of preset names
    if (root.object.get("extends")) |extends_val| {
        if (extends_val == .array) {
            for (extends_val.array.items) |item| {
                if (item == .string) {
                    applyPreset(&config, item.string);
                }
            }
        }
    }

    // 2. "categories" — category-level severity overrides
    if (root.object.get("categories")) |cats_val| {
        if (cats_val == .object) {
            var cat_iter = cats_val.object.iterator();
            while (cat_iter.next()) |entry| {
                const cat_name = entry.key_ptr.*;
                const sev_str = if (entry.value_ptr.* == .string) entry.value_ptr.string else continue;
                const sev = RuleSeverity.fromString(sev_str) orelse continue;

                const category = parseCategoryName(cat_name) orelse continue;
                applyCategorySeverity(&config, category, sev);
            }
        }
    }

    // 3. "rules" — individual rule severity overrides
    //    Keys point directly into the retained JSON tree (no duplication needed).
    if (root.object.get("rules")) |rules_val| {
        if (rules_val == .object) {
            var rule_iter = rules_val.object.iterator();
            while (rule_iter.next()) |entry| {
                const rule_name = entry.key_ptr.*;
                var sev: RuleSeverity = .off;
                if (entry.value_ptr.* == .string) {
                    sev = RuleSeverity.fromString(entry.value_ptr.string) orelse continue;
                } else if (entry.value_ptr.* == .array) {
                    // ESLint format: ["error"|0-2, { options... }]
                    const items = entry.value_ptr.array.items;
                    if (items.len == 0) continue;
                    if (items[0] == .string) {
                        sev = RuleSeverity.fromString(items[0].string) orelse continue;
                    } else if (items[0] == .integer) {
                        sev = RuleSeverity.fromInt(items[0].integer);
                    } else continue;
                    // Store pointer to the first options value (after severity).
                    // Also store the second option (if any) in rule_options2.
                    if (items.len > 1) {
                        for (linter.rule_names, 0..) |rn, ri| {
                            if (std.mem.eql(u8, rn, rule_name)) {
                                config.rule_options[ri] = &items[1];
                                if (items.len > 2) {
                                    config.rule_options2[ri] = &items[2];
                                }
                                config.rule_options_all[ri] = items[1..];
                                break;
                            }
                        }
                    }
                } else if (entry.value_ptr.* == .integer) {
                    sev = RuleSeverity.fromInt(entry.value_ptr.integer);
                } else continue;

                config.rule_severities.put(allocator, rule_name, sev) catch {};
            }
        }
    }

    // 4. "include" — glob patterns for files to lint
    if (root.object.get("include")) |inc_val| {
        config.include_patterns = parseStringArray(allocator, inc_val) catch &.{};
    }

    // 5. "exclude" — glob patterns for files to skip
    if (root.object.get("exclude")) |exc_val| {
        config.exclude_patterns = parseStringArray(allocator, exc_val) catch &.{};
    }

    // 6. "overrides" — file-specific rule overrides
    if (root.object.get("overrides")) |ov_val| {
        if (ov_val == .array) {
            config.overrides = parseOverrides(allocator, ov_val.array.items) catch &.{};
        }
    }

    // 7. "settings" — ESLint settings object forwarded to rules.
    if (root.object.getPtr("settings")) |settings_ptr| {
        if (settings_ptr.* == .object) config.settings = settings_ptr;
    }

    // 8. "languageOptions" — ESLint languageOptions object forwarded to rules.
    if (root.object.getPtr("languageOptions")) |lo_ptr| {
        if (lo_ptr.* == .object) config.language_options = lo_ptr;
    }

    // 9. Build the comptime-indexed severity table.
    config.buildSeverityTable();

    return config;
}

// ── Helpers ───────────────────────────────────────────────────────

fn blankConfig(allocator: std.mem.Allocator) Config {
    return Config{
        .rule_severities = .{},
        .include_patterns = &.{},
        .exclude_patterns = &.{},
        .overrides = &.{},
        .rule_severity_table = undefined,
        .allocator = allocator,
    };
}

fn parseCategoryName(name: []const u8) ?Category {
    if (std.mem.eql(u8, name, "correctness")) return .correctness;
    if (std.mem.eql(u8, name, "suspicious")) return .suspicious;
    if (std.mem.eql(u8, name, "style")) return .style;
    if (std.mem.eql(u8, name, "performance")) return .performance;
    return null;
}

fn applyCategorySeverity(config: *Config, category: Category, sev: RuleSeverity) void {
    for (0..registry.count) |i| {
        if (linter.rule_categories[i] == category) {
            config.rule_severities.put(config.allocator, linter.rule_names[i], sev) catch {};
        }
    }
}

fn parseStringArray(allocator: std.mem.Allocator, val: std.json.Value) ![]const []const u8 {
    if (val != .array) return error.InvalidConfig;

    const items = val.array.items;
    // First pass: count how many are strings.
    var str_count: usize = 0;
    for (items) |item| {
        if (item == .string) str_count += 1;
    }

    const result = try allocator.alloc([]const u8, str_count);
    var idx: usize = 0;
    for (items) |item| {
        if (item == .string) {
            // String data is owned by the retained JSON parse tree.
            result[idx] = item.string;
            idx += 1;
        }
    }
    return result;
}

fn parseOverrides(allocator: std.mem.Allocator, items: []const std.json.Value) ![]const Override {
    // Count valid override objects.
    var obj_count: usize = 0;
    for (items) |item| {
        if (item == .object) obj_count += 1;
    }

    const result = try allocator.alloc(Override, obj_count);
    var idx: usize = 0;

    for (items) |item| {
        if (item != .object) continue;

        var ov = Override{
            .file_patterns = &.{},
            .rule_severities = .{},
        };

        // "files" array
        if (item.object.get("files")) |files_val| {
            ov.file_patterns = parseStringArray(allocator, files_val) catch &.{};
        }

        // "rules" object
        if (item.object.get("rules")) |rules_val| {
            if (rules_val == .object) {
                var rule_iter = rules_val.object.iterator();
                while (rule_iter.next()) |entry| {
                    const rule_name = entry.key_ptr.*;
                    const sev_str = if (entry.value_ptr.* == .string) entry.value_ptr.string else continue;
                    const sev = RuleSeverity.fromString(sev_str) orelse continue;

                    // Key points into the retained JSON parse tree.
                    ov.rule_severities.put(allocator, rule_name, sev) catch {};
                }
            }
        }

        result[idx] = ov;
        idx += 1;
    }
    return result;
}

// ── Tests ─────────────────────────────────────────────────────────

test "RuleSeverity.fromString" {
    const expect = std.testing.expect;

    // Named values
    try expect(RuleSeverity.fromString("off").? == .off);
    try expect(RuleSeverity.fromString("warning").? == .warning);
    try expect(RuleSeverity.fromString("warn").? == .warning);
    try expect(RuleSeverity.fromString("error").? == .@"error");

    // ESLint numeric compat
    try expect(RuleSeverity.fromString("0").? == .off);
    try expect(RuleSeverity.fromString("1").? == .warning);
    try expect(RuleSeverity.fromString("2").? == .@"error");

    // Invalid
    try expect(RuleSeverity.fromString("invalid") == null);
    try expect(RuleSeverity.fromString("") == null);
    try expect(RuleSeverity.fromString("3") == null);
}

test "RuleSeverity.toSeverity" {
    const expect = std.testing.expect;

    try expect(RuleSeverity.off.toSeverity() == null);
    try expect(RuleSeverity.warning.toSeverity().? == .warning);
    try expect(RuleSeverity.@"error".toSeverity().? == .@"error");
}

test "Config.initDefault" {
    const config = Config.initDefault(std.testing.allocator);

    // The severity table should be populated — spot-check first rule.
    // no_debugger is correctness with default_severity = .warning => RuleSeverity.warning
    try std.testing.expect(config.rule_severity_table[0] == .warning);

    // Verify table length matches registry count.
    try std.testing.expectEqual(registry.count, config.rule_severity_table.len);

    // Empty patterns by default.
    try std.testing.expectEqual(@as(usize, 0), config.include_patterns.len);
    try std.testing.expectEqual(@as(usize, 0), config.exclude_patterns.len);
}

test "globMatch" {
    const expect = std.testing.expect;

    // Literal match
    try expect(globMatch("foo.js", "foo.js"));
    try expect(!globMatch("foo.js", "bar.js"));

    // Single star — does not cross '/'
    try expect(globMatch("*.js", "index.js"));
    try expect(!globMatch("*.js", "src/index.js"));
    try expect(globMatch("src/*.js", "src/index.js"));

    // Double star — crosses '/'
    try expect(globMatch("**/*.js", "src/index.js"));
    try expect(globMatch("**/*.js", "a/b/c/index.js"));
    try expect(globMatch("**/*.js", "index.js"));

    // Question mark
    try expect(globMatch("?.js", "a.js"));
    try expect(!globMatch("?.js", "ab.js"));
    try expect(!globMatch("?.js", "/.js"));

    // Directory prefix with double star
    try expect(globMatch("src/**", "src/foo.js"));
    try expect(globMatch("src/**", "src/a/b/c.js"));

    // Empty pattern matches empty text
    try expect(globMatch("", ""));
    try expect(!globMatch("", "a"));

    // Star matches empty string
    try expect(globMatch("*", "foo"));
    try expect(globMatch("*", ""));
}

test "parseConfigJson basic" {
    const json =
        \\{
        \\  "extends": ["recommended"],
        \\  "include": ["src/**"],
        \\  "exclude": ["dist/**"]
        \\}
    ;

    var config = try parseConfigJson(std.testing.allocator, json);
    defer config.deinit();

    // Should have include/exclude patterns.
    try std.testing.expectEqual(@as(usize, 1), config.include_patterns.len);
    try std.testing.expectEqual(@as(usize, 1), config.exclude_patterns.len);
    try std.testing.expectEqualStrings("src/**", config.include_patterns[0]);
    try std.testing.expectEqualStrings("dist/**", config.exclude_patterns[0]);
}

test "parseConfigJson with rules" {
    const json =
        \\{
        \\  "rules": {
        \\    "no-debugger": "off",
        \\    "eqeqeq": "error"
        \\  }
        \\}
    ;

    var config = try parseConfigJson(std.testing.allocator, json);
    defer config.deinit();

    // no-debugger should be off in the hashmap.
    const debugger_sev = config.rule_severities.get("no-debugger");
    try std.testing.expect(debugger_sev != null);
    try std.testing.expect(debugger_sev.? == .off);

    // eqeqeq should be error.
    const eqeqeq_sev = config.rule_severities.get("eqeqeq");
    try std.testing.expect(eqeqeq_sev != null);
    try std.testing.expect(eqeqeq_sev.? == .@"error");

    // Check that severity table reflects the override: no-debugger (index 0) is off.
    try std.testing.expect(config.rule_severity_table[0] == .off);
}

test "parseConfigJson with categories" {
    const json =
        \\{
        \\  "categories": {
        \\    "style": "off",
        \\    "correctness": "error"
        \\  }
        \\}
    ;

    var config = try parseConfigJson(std.testing.allocator, json);
    defer config.deinit();

    // All correctness rules should be error. Check no-debugger (index 0, correctness).
    try std.testing.expect(config.rule_severity_table[0] == .@"error");

    // Style rules should be off. Find the first style-category rule and
    // assert it.  (Was hardcoded to index 105 — drifts when rules change.)
    const linter_mod = @import("linter.zig");
    var first_style_idx: ?usize = null;
    for (linter_mod.rule_categories, 0..) |cat, i| {
        if (cat == .style) { first_style_idx = i; break; }
    }
    if (first_style_idx) |idx| {
        try std.testing.expect(config.rule_severity_table[idx] == .off);
    }
}

test "Config.shouldLintFile" {
    const allocator = std.testing.allocator;
    const expect = std.testing.expect;

    // Config with include and exclude patterns.
    const json =
        \\{
        \\  "include": ["src/**", "lib/**"],
        \\  "exclude": ["**/*.test.js"]
        \\}
    ;

    var config = try parseConfigJson(allocator, json);
    defer config.deinit();

    // Included files.
    try expect(config.shouldLintFile("src/index.js"));
    try expect(config.shouldLintFile("lib/utils.js"));

    // Not in include set.
    try expect(!config.shouldLintFile("dist/bundle.js"));

    // Excluded even though included.
    try expect(!config.shouldLintFile("src/app.test.js"));

    // Empty include means everything included.
    const json2 =
        \\{
        \\  "exclude": ["node_modules/**"]
        \\}
    ;

    var config2 = try parseConfigJson(allocator, json2);
    defer config2.deinit();

    try expect(config2.shouldLintFile("src/index.js"));
    try expect(!config2.shouldLintFile("node_modules/foo/index.js"));
}
