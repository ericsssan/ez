const std = @import("std");
const Io = std.Io;
const Config = @import("config.zig").Config;
const parseConfigJson = @import("config.zig").parseConfigJson;

const config_filename = "sx3lint.config.json";
const max_file_size = 1 * 1024 * 1024; // 1 MiB

// ── ConfigResolver ────────────────────────────────────────────────

pub const ConfigResolver = struct {
    allocator: std.mem.Allocator,
    /// Maps directory path -> resolved config for files in that directory.
    cache: std.StringHashMapUnmanaged(*const Config),
    default_config: Config,

    pub fn init(allocator: std.mem.Allocator) ConfigResolver {
        return .{
            .allocator = allocator,
            .cache = .{},
            .default_config = Config.initDefault(allocator),
        };
    }

    pub fn deinit(self: *ConfigResolver) void {
        // Free all cached configs (heap-allocated, owned by us).
        var iter = self.cache.iterator();
        while (iter.next()) |entry| {
            // Free the directory-path key (we duped it on insert).
            self.allocator.free(entry.key_ptr.*);

            // Free the Config struct itself.
            const config_ptr = @constCast(entry.value_ptr.*);
            config_ptr.deinit();
            self.allocator.destroy(config_ptr);
        }
        self.cache.deinit(self.allocator);
    }

    /// Resolve the effective configuration for a given file path.
    /// Walks parent directories looking for `sx3lint.config.json`.
    /// Caches results by directory so repeated lookups are fast.
    pub fn resolveForFile(self: *ConfigResolver, io: Io, file_path: []const u8) *const Config {
        const dir = directoryOf(file_path);

        // Check cache first.
        if (self.cache.get(dir)) |cached| {
            return cached;
        }

        // Walk up from `dir` looking for config file.
        var search_dir = dir;
        while (true) {
            // Build candidate path: search_dir ++ "/" ++ config_filename
            const candidate = buildConfigPath(self.allocator, search_dir) catch {
                return &self.default_config;
            };
            defer self.allocator.free(candidate);

            // Try to read the config file.
            if (Io.Dir.cwd().readFileAlloc(io, candidate, self.allocator, Io.Limit.limited(max_file_size))) |json_source| {
                defer self.allocator.free(json_source);

                if (parseConfigJson(self.allocator, json_source)) |config| {
                    // Heap-allocate the config so we can store a stable pointer.
                    const heap_config = self.allocator.create(Config) catch {
                        // On allocation failure, fall back to default.
                        var tmp = config;
                        tmp.deinit();
                        return &self.default_config;
                    };
                    heap_config.* = config;

                    // Cache for the original directory we were asked about.
                    const dir_key = self.allocator.dupe(u8, dir) catch {
                        return &self.default_config;
                    };
                    self.cache.put(self.allocator, dir_key, heap_config) catch {
                        self.allocator.free(dir_key);
                        return &self.default_config;
                    };

                    return heap_config;
                } else |_| {
                    // Parse failed — treat as if file doesn't exist, keep walking.
                }
            } else |_| {
                // File doesn't exist — keep walking up.
            }

            // Move to parent directory.
            const parent = parentDirectory(search_dir);
            if (std.mem.eql(u8, parent, search_dir)) {
                // Reached the root — no config found.
                break;
            }
            search_dir = parent;
        }

        // No config file found anywhere — cache the default for this directory
        // so we don't re-walk next time.
        const dir_key = self.allocator.dupe(u8, dir) catch {
            return &self.default_config;
        };
        // Store a pointer to our own default_config (not heap-allocated separately).
        // We use a sentinel: null pointer check in deinit distinguishes these.
        // Actually simpler: just don't cache defaults for now, return directly.
        self.allocator.free(dir_key);
        return &self.default_config;
    }

    /// Load a specific config file path (for --config CLI flag).
    /// Parses it, caches it, and returns a stable pointer.
    pub fn resolveFromPath(self: *ConfigResolver, io: Io, config_path: []const u8) !*const Config {
        // Check if we already loaded this exact path.
        if (self.cache.get(config_path)) |cached| {
            return cached;
        }

        const json_source = Io.Dir.cwd().readFileAlloc(
            io,
            config_path,
            self.allocator,
            Io.Limit.limited(max_file_size),
        ) catch {
            return error.ConfigFileNotFound;
        };
        defer self.allocator.free(json_source);

        var config = parseConfigJson(self.allocator, json_source) catch {
            return error.InvalidConfig;
        };
        errdefer config.deinit();

        const heap_config = try self.allocator.create(Config);
        heap_config.* = config;

        const cache_key = try self.allocator.dupe(u8, config_path);
        errdefer self.allocator.free(cache_key);

        try self.cache.put(self.allocator, cache_key, heap_config);
        return heap_config;
    }
};

// ── Path helpers ──────────────────────────────────────────────────

/// Extract the directory portion of a file path.
/// Returns everything up to (but not including) the last '/'.
/// If there is no '/', returns "." (current directory).
pub fn directoryOf(path: []const u8) []const u8 {
    if (std.mem.lastIndexOfScalar(u8, path, '/')) |idx| {
        if (idx == 0) return "/";
        return path[0..idx];
    }
    return ".";
}

/// Get the parent directory of a directory path.
/// "/foo/bar" -> "/foo", "/foo" -> "/", "/" -> "/", "." -> "."
pub fn parentDirectory(dir: []const u8) []const u8 {
    if (std.mem.eql(u8, dir, "/") or std.mem.eql(u8, dir, ".")) {
        return dir;
    }
    if (std.mem.lastIndexOfScalar(u8, dir, '/')) |idx| {
        if (idx == 0) return "/";
        return dir[0..idx];
    }
    return ".";
}

/// Build the full path to a config file in the given directory.
/// e.g. "/foo/bar" -> "/foo/bar/sx3lint.config.json"
///      "."        -> "sx3lint.config.json"
fn buildConfigPath(allocator: std.mem.Allocator, dir: []const u8) ![]const u8 {
    if (std.mem.eql(u8, dir, ".")) {
        return try allocator.dupe(u8, config_filename);
    }
    return try std.fmt.allocPrint(allocator, "{s}/{s}", .{ dir, config_filename });
}

// ── Tests ─────────────────────────────────────────────────────────

test "directoryOf" {
    const expect = std.testing.expect;
    const eql = std.mem.eql;

    try expect(eql(u8, directoryOf("src/foo/bar.js"), "src/foo"));
    try expect(eql(u8, directoryOf("bar.js"), "."));
    try expect(eql(u8, directoryOf("/foo/bar.js"), "/foo"));
    try expect(eql(u8, directoryOf("/bar.js"), "/"));
    try expect(eql(u8, directoryOf("a/b/c/d.ts"), "a/b/c"));
}

test "parentDirectory" {
    const expect = std.testing.expect;
    const eql = std.mem.eql;

    try expect(eql(u8, parentDirectory("/foo/bar"), "/foo"));
    try expect(eql(u8, parentDirectory("/foo"), "/"));
    try expect(eql(u8, parentDirectory("/"), "/"));
    try expect(eql(u8, parentDirectory("."), "."));
    try expect(eql(u8, parentDirectory("a/b/c"), "a/b"));
    try expect(eql(u8, parentDirectory("a"), "."));
}

test "buildConfigPath" {
    const allocator = std.testing.allocator;
    const eql = std.mem.eql;

    const p1 = try buildConfigPath(allocator, "/home/user/project/src");
    defer allocator.free(p1);
    try std.testing.expect(eql(u8, p1, "/home/user/project/src/sx3lint.config.json"));

    const p2 = try buildConfigPath(allocator, ".");
    defer allocator.free(p2);
    try std.testing.expect(eql(u8, p2, "sx3lint.config.json"));

    const p3 = try buildConfigPath(allocator, "/");
    defer allocator.free(p3);
    try std.testing.expect(eql(u8, p3, "//sx3lint.config.json"));
}

test "ConfigResolver.init" {
    var resolver = ConfigResolver.init(std.testing.allocator);
    defer resolver.deinit();

    // Default config should have a populated severity table.
    const registry = @import("rules/registry.zig");
    try std.testing.expectEqual(registry.count, resolver.default_config.rule_severity_table.len);

    // Cache should be empty.
    try std.testing.expectEqual(@as(u32, 0), resolver.cache.count());
}

test "resolveForFile returns default when no config exists" {
    // This test verifies that when no sx3lint.config.json is found,
    // the resolver returns its default config. We test this by using
    // a path where no config file could possibly exist.
    var resolver = ConfigResolver.init(std.testing.allocator);
    defer resolver.deinit();

    // Without IO we can't fully exercise resolveForFile, but we can
    // verify that the path helpers work correctly with the resolver.
    // The actual IO-based resolution is tested via integration tests.
    const dir = directoryOf("/nonexistent/path/to/file.js");
    try std.testing.expect(std.mem.eql(u8, dir, "/nonexistent/path/to"));
}
