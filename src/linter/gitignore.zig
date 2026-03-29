const std = @import("std");

/// Pattern parsed from a .gitignore file.
const Pattern = struct {
    /// The glob-like pattern string (trimmed, without leading '!' or trailing '/').
    text: []const u8,
    /// True if the original line started with '!' (negation).
    is_negation: bool,
    /// True if the original line ended with '/' (directory-only match).
    is_dir_only: bool,
    /// True if the pattern contains a '/' (anchored to the repo root).
    is_anchored: bool,
};

/// Parses .gitignore content and matches file/directory paths against the
/// collected patterns.  Supports negation (`!`), directory-only (`/` suffix),
/// and anchored patterns (containing `/`).
///
/// Pattern matching follows simplified gitignore semantics:
///   - `*` matches any sequence of non-'/' characters
///   - `**` matches any sequence of characters including '/'
///   - `?` matches any single non-'/' character
///   - Leading `!` negates the pattern
///   - Trailing `/` restricts the match to directories
///   - Patterns containing `/` (other than a trailing one) are anchored
pub const GitIgnore = struct {
    patterns: std.ArrayList(Pattern),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) GitIgnore {
        return .{
            .patterns = .empty,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *GitIgnore) void {
        self.patterns.deinit(self.allocator);
    }

    /// Parse the raw text content of a .gitignore file and append its patterns.
    pub fn addPatterns(self: *GitIgnore, content: []const u8) !void {
        var line_start: usize = 0;
        while (line_start < content.len) {
            // Find end of line.
            var line_end = line_start;
            while (line_end < content.len and content[line_end] != '\n') {
                line_end += 1;
            }

            const raw_line = content[line_start..line_end];
            line_start = line_end + 1; // skip the '\n'

            // Strip trailing '\r' for CRLF files.
            const line = if (raw_line.len > 0 and raw_line[raw_line.len - 1] == '\r')
                raw_line[0 .. raw_line.len - 1]
            else
                raw_line;

            // Skip blank lines and comments.
            const trimmed = std.mem.trim(u8, line, " \t");
            if (trimmed.len == 0) continue;
            if (trimmed[0] == '#') continue;

            // Detect negation.
            var text = trimmed;
            const is_negation = text[0] == '!';
            if (is_negation) text = text[1..];
            if (text.len == 0) continue;

            // Detect directory-only suffix.
            const is_dir_only = text[text.len - 1] == '/';
            if (is_dir_only) text = text[0 .. text.len - 1];
            if (text.len == 0) continue;

            // Strip leading '/' — it anchors the pattern to the root but is
            // not part of the text we match against.
            const has_leading_slash = text[0] == '/';
            if (has_leading_slash) text = text[1..];
            if (text.len == 0) continue;

            // A pattern is anchored if it originally contained a '/' anywhere
            // (leading slash already stripped above counts, or any interior '/').
            const is_anchored = has_leading_slash or (std.mem.indexOf(u8, text, "/") != null);

            self.patterns.append(self.allocator, .{
                .text = text,
                .is_negation = is_negation,
                .is_dir_only = is_dir_only,
                .is_anchored = is_anchored,
            }) catch return error.OutOfMemory;
        }
    }

    /// Returns `true` if the given path should be ignored according to the
    /// loaded patterns.
    ///
    /// `path`   — forward-slash-separated path relative to the repository root.
    /// `is_dir` — whether the path refers to a directory.
    pub fn isIgnored(self: *const GitIgnore, path: []const u8, is_dir: bool) bool {
        const patterns = self.patterns.items;
        var ignored = false;

        for (patterns) |pat| {
            // Directory-only patterns cannot match files.
            if (pat.is_dir_only and !is_dir) continue;

            const matched = if (pat.is_anchored)
                globMatch(pat.text, path)
            else
                matchUnanchored(pat.text, path);

            if (matched) {
                ignored = !pat.is_negation;
            }
        }
        return ignored;
    }

    /// Match an unanchored pattern — it may match any suffix component of the
    /// path.  E.g. the pattern `build` matches `foo/build` and `build`.
    fn matchUnanchored(pattern: []const u8, path: []const u8) bool {
        // Try matching against the full path first.
        if (globMatch(pattern, path)) return true;

        // Try matching against each path suffix starting after a '/'.
        var i: usize = 0;
        while (i < path.len) : (i += 1) {
            if (path[i] == '/' and i + 1 < path.len) {
                if (globMatch(pattern, path[i + 1 ..])) return true;
            }
        }
        return false;
    }
};

// ── Glob matching ──────────────────────────────────────────────────

/// Simple glob matcher supporting `*`, `**`, and `?`.
///
/// `*`  matches zero or more characters except '/'.
/// `**` matches zero or more characters including '/'.
/// `?`  matches exactly one character except '/'.
///
/// This is intentionally a minimal implementation sufficient for common
/// .gitignore patterns.
pub fn globMatch(pattern: []const u8, text: []const u8) bool {
    return globMatchInner(pattern, text, 0);
}

fn globMatchInner(pattern: []const u8, text: []const u8, depth: u32) bool {
    // Guard against runaway recursion on pathological patterns.
    if (depth > 64) return false;

    var pi: usize = 0;
    var ti: usize = 0;

    while (pi < pattern.len) {
        if (pi + 1 < pattern.len and pattern[pi] == '*' and pattern[pi + 1] == '*') {
            // '**' — matches everything including '/'.
            // Skip any trailing '/' after '**' in the pattern (e.g. `**/`).
            var rest = pi + 2;
            if (rest < pattern.len and pattern[rest] == '/') rest += 1;

            // Try matching the remainder of the pattern at every position.
            var k = ti;
            while (k <= text.len) : (k += 1) {
                if (globMatchInner(pattern[rest..], text[k..], depth + 1)) return true;
            }
            return false;
        } else if (pattern[pi] == '*') {
            // '*' — matches everything except '/'.
            const rest = pi + 1;
            var k = ti;
            while (k <= text.len) : (k += 1) {
                if (k > ti and text[k - 1] == '/') break; // stop at '/'
                if (globMatchInner(pattern[rest..], text[k..], depth + 1)) return true;
            }
            return false;
        } else if (pattern[pi] == '?') {
            if (ti >= text.len or text[ti] == '/') return false;
            pi += 1;
            ti += 1;
        } else {
            if (ti >= text.len) return false;
            if (pattern[pi] != text[ti]) return false;
            pi += 1;
            ti += 1;
        }
    }
    return ti == text.len;
}

// ── Tests ──────────────────────────────────────────────────────────

test "globMatch basics" {
    const expect = std.testing.expect;

    // Literal
    try expect(globMatch("foo", "foo"));
    try expect(!globMatch("foo", "bar"));

    // Single star
    try expect(globMatch("*.js", "index.js"));
    try expect(!globMatch("*.js", "src/index.js"));

    // Double star
    try expect(globMatch("**/*.js", "src/index.js"));
    try expect(globMatch("**/*.js", "index.js"));

    // Question mark
    try expect(globMatch("?.js", "a.js"));
    try expect(!globMatch("?.js", "ab.js"));
}

test "gitignore pattern matching" {
    const testing = std.testing;
    var gi = GitIgnore.init(testing.allocator);
    defer gi.deinit();

    try gi.addPatterns(
        \\node_modules
        \\*.log
        \\build/
        \\!important.log
        \\
    );

    // node_modules is unanchored — matches anywhere.
    try testing.expect(gi.isIgnored("node_modules", true));
    try testing.expect(gi.isIgnored("packages/node_modules", true));

    // *.log matches files.
    try testing.expect(gi.isIgnored("debug.log", false));

    // Negation: important.log is NOT ignored.
    try testing.expect(!gi.isIgnored("important.log", false));

    // build/ is directory-only.
    try testing.expect(gi.isIgnored("build", true));
    try testing.expect(!gi.isIgnored("build", false));
}
