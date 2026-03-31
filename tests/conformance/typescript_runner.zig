const std = @import("std");
const sanz = @import("sanz");
const Lexer = sanz.Lexer;
const Parser = sanz.Parser;
const Io = std.Io;
const Token = sanz.token;

/// TypeScript parser conformance runner.
///
/// Uses error baselines from the TypeScript repo to classify tests:
/// - If a baseline has syntax errors (TS1xxx), the test is must-reject
/// - Otherwise, the test is must-parse
///
/// Usage: typescript_runner <conformance-dir>

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [8192]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    if (args.len < 2) {
        try stdout.print("Usage: typescript_runner <conformance-dir>\n", .{});
        try stdout.flush();
        std.process.exit(1);
    }

    const cases_dir = args[1];
    const compact = args.len >= 3 and std.mem.eql(u8, args[2], "--compact");

    // Derive baselines path from cases dir:
    // cases_dir = .../typescript/tests/cases/conformance
    // baselines = .../typescript/tests/baselines/reference
    var baselines_buf: [4096]u8 = undefined;
    const baselines_dir = blk: {
        // Walk up from conformance dir to find tests/baselines/reference
        if (std.mem.indexOf(u8, cases_dir, "/tests/cases/")) |idx| {
            const prefix = cases_dir[0..idx];
            break :blk std.fmt.bufPrint(&baselines_buf, "{s}/tests/baselines/reference", .{prefix}) catch "";
        }
        break :blk "";
    };

    var must_parse_pass: u32 = 0;
    var must_parse_fail: u32 = 0;
    var must_reject_pass: u32 = 0;
    var must_reject_fail: u32 = 0;
    var skipped: u32 = 0;

    // Collect all .ts files
    var files: std.ArrayList([]const u8) = .empty;
    defer {
        for (files.items) |p| allocator.free(p);
        files.deinit(allocator);
    }

    const base_dir = Io.Dir.cwd().openDir(io, cases_dir, .{}) catch {
        try stdout.print("Cannot open {s}\n", .{cases_dir});
        try stdout.flush();
        std.process.exit(1);
    };
    try walkTs(io, allocator, base_dir, cases_dir, &files);

    // Pre-load baseline filenames once (avoids re-scanning directory per test)
    var baseline_names: std.ArrayList([]const u8) = .empty;
    defer {
        for (baseline_names.items) |n| allocator.free(n);
        baseline_names.deinit(allocator);
    }
    if (baselines_dir.len > 0) {
        if (Io.Dir.cwd().openDir(io, baselines_dir, .{})) |bdir| {
            var biter = bdir.iterate();
            while (biter.next(io) catch null) |entry| {
                if (entry.kind == .file and std.mem.endsWith(u8, entry.name, ".errors.txt")) {
                    try baseline_names.append(allocator, try allocator.dupe(u8, entry.name));
                }
            }
        } else |_| {}
    }

    for (files.items) |path| {
        // Skip .d.ts and .tsx
        if (std.mem.endsWith(u8, path, ".d.ts") or std.mem.endsWith(u8, path, ".tsx")) {
            skipped += 1;
            continue;
        }

        const source = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch continue;
        defer allocator.free(source);

        // Skip multi-file tests
        if (std.mem.indexOf(u8, source, "// @filename:") != null or
            std.mem.indexOf(u8, source, "// @Filename:") != null)
        {
            skipped += 1;
            continue;
        }

        // Classify using error baselines
        const kind = classifyTest(io, allocator, path, source, baselines_dir, baseline_names.items);
        if (kind == .skip) {
            skipped += 1;
            continue;
        }

        const lang: Token.Language = if (std.mem.endsWith(u8, path, ".ts")) .ts else .js;
        const is_module = detectModuleMode(source);
        const is_strict = detectStrictMode(source);

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const file_alloc = arena.allocator();

        var first_error: []const u8 = "";

        // Prepend "use strict"; if the test directives enable strict mode
        const parse_source = if (is_strict and !is_module) blk: {
            const prefix = "\"use strict\";\n";
            const buf = file_alloc.alloc(u8, prefix.len + source.len) catch break :blk source;
            @memcpy(buf[0..prefix.len], prefix);
            @memcpy(buf[prefix.len..], source);
            break :blk buf;
        } else source;

        const parse_ok = parse_blk: {
            var toks = Lexer.tokenizeWithOptions(file_alloc, parse_source, lang, is_module) catch {
                first_error = "tokenize failed";
                break :parse_blk false;
            };
            defer toks.deinit(file_alloc);
            var tree = Parser.parseWithLanguage(file_alloc, parse_source, toks.slice(), lang, is_module) catch {
                first_error = "parse OOM";
                break :parse_blk false;
            };
            if (tree.errors.len > 0) {
                first_error = tree.errors[0].message;
                break :parse_blk false;
            }

            // Run semantic analysis for must-reject tests only.
            // TS allows redeclarations/patterns that JS doesn't, so skip for must-parse.
            if (kind == .must_reject) {
                var sem = sanz.semantic.SemanticAnalyzer.analyze(file_alloc, &tree) catch break :parse_blk true;
                defer sem.deinit(file_alloc);
                if (sem.diagnostics.len > 0) {
                    first_error = "semantic error";
                    break :parse_blk false;
                }
            }

            break :parse_blk true;
        };
        const has_error = !parse_ok;

        switch (kind) {
            .must_parse => {
                if (!has_error) {
                    must_parse_pass += 1;
                } else {
                    must_parse_fail += 1;
                    if (!compact) {
                        try stdout.print("  FAIL (should parse): {s} | {s}\n", .{ path, first_error });
                    }
                }
            },
            .must_reject => {
                if (has_error) {
                    must_reject_pass += 1;
                } else {
                    must_reject_fail += 1;
                    if (!compact) {
                        try stdout.print("  FAIL (should reject): {s}\n", .{path});
                    }
                }
            },
            .skip => unreachable,
        }
    }

    const parse_total = must_parse_pass + must_parse_fail;
    const reject_total = must_reject_pass + must_reject_fail;
    const overall_total = parse_total + reject_total;
    const overall_pass = must_parse_pass + must_reject_pass;

    if (compact) {
        try stdout.print("typescript:            must-parse: {d}/{d}  must-reject: {d}/{d}  skipped: {d}\n", .{
            must_parse_pass, parse_total, must_reject_pass, reject_total, skipped,
        });
    } else {
        try stdout.print("TypeScript parser conformance tests\n\n", .{});
        try stdout.print("  Must-parse:   {d} / {d}\n", .{ must_parse_pass, parse_total });
        try stdout.print("  Must-reject:  {d} / {d}\n", .{ must_reject_pass, reject_total });
        try stdout.print("  Skipped:      {d}\n", .{skipped});
        try stdout.print("  Overall:      {d} / {d}\n", .{ overall_pass, overall_total });
    }
    try stdout.flush();
}

// ── Strict mode detection ───────────────────────────────────────

fn detectStrictMode(source: []const u8) bool {
    // Detect @strict or @alwaysStrict directives in TS test comments.
    if (std.mem.indexOf(u8, source, "// @strict: true") != null) return true;
    if (std.mem.indexOf(u8, source, "// @alwaysStrict: true") != null) return true;
    // Parametric: "@alwaysStrict: true, false" — tests run in both modes
    if (std.mem.indexOf(u8, source, "// @alwaysStrict:") != null) {
        // If "true" appears in the value, the strict variant exists
        if (std.mem.indexOf(u8, source, "// @alwaysStrict: true,") != null or
            std.mem.indexOf(u8, source, "// @alwaysStrict:true") != null)
            return true;
    }
    // "@strict" without ": false" means strict is enabled
    if (std.mem.indexOf(u8, source, "// @strict\n") != null) return true;
    return false;
}

// ── Module mode detection ────────────────────────────────────────

fn detectModuleMode(source: []const u8) bool {
    // Any @module directive implies module mode for TS files
    if (std.mem.indexOf(u8, source, "// @module:") != null or
        std.mem.indexOf(u8, source, "\xef\xbb\xbf// @module:") != null)
        return true;
    // Scan for export/import at start of any line (after optional whitespace)
    var i: usize = 0;
    while (i < source.len) {
        // Skip whitespace at start of line
        while (i < source.len and (source[i] == ' ' or source[i] == '\t')) i += 1;
        // Check for export/import keyword followed by whitespace or '{'
        if (i + 6 < source.len) {
            if (std.mem.eql(u8, source[i..][0..6], "export") or
                std.mem.eql(u8, source[i..][0..6], "import"))
            {
                const next = source[i + 6];
                if (next == ' ' or next == '\t' or next == '{') return true;
            }
        }
        // Skip to next line
        while (i < source.len and source[i] != '\n') i += 1;
        if (i < source.len) i += 1;
    }
    return false;
}

// ── Test classification ──────────────────────────────────────────

const TestKind = enum { must_parse, must_reject, skip };

fn classifyTest(io: Io, allocator: std.mem.Allocator, path: []const u8, source: []const u8, baselines_dir: []const u8, baseline_names: []const []const u8) TestKind {
    // Skip pure JSON files
    if (source.len > 0 and (source[0] == '{' or (source[0] == 0xEF and source.len > 3 and source[3] == '{'))) {
        return .skip;
    }

    // Use error baselines if available: check if <testname>.errors.txt exists
    // and contains syntax errors (TS1xxx codes = parse errors)
    if (baselines_dir.len > 0) {
        if (hasSyntaxErrorBaseline(io, allocator, path, baselines_dir, baseline_names))
            return .must_reject;
    }

    // Fallback heuristics for files without baselines
    if (std.mem.indexOf(u8, path, "ErrorRecovery") != null or
        std.mem.indexOf(u8, path, "errorRecovery") != null)
        return .must_reject;

    return .must_parse;
}

/// Check if a test file has a corresponding .errors.txt baseline with syntax errors.
/// Syntax errors in TypeScript are TS1xxx codes (1000-1999 range).
fn hasSyntaxErrorBaseline(io: Io, allocator: std.mem.Allocator, test_path: []const u8, baselines_dir: []const u8, baseline_names: []const []const u8) bool {
    // Extract test name from path: .../cases/conformance/foo/bar.ts -> bar
    const basename = getBasename(test_path);
    const stem = if (std.mem.endsWith(u8, basename, ".ts"))
        basename[0 .. basename.len - 3]
    else if (std.mem.endsWith(u8, basename, ".tsx"))
        basename[0 .. basename.len - 4]
    else
        basename;

    // Check exact baseline: <stem>.errors.txt
    var buf: [4096]u8 = undefined;
    const baseline_path = std.fmt.bufPrint(&buf, "{s}/{s}.errors.txt", .{ baselines_dir, stem }) catch return false;
    if (checkBaselineForSyntaxErrors(io, allocator, baseline_path)) return true;

    // Also check parametric baselines: <stem>(<params>).errors.txt
    // TypeScript generates these for tests with multiple @target values.
    // Uses pre-cached baseline_names to avoid re-scanning the directory per test.
    for (baseline_names) |name| {
        if (!std.mem.startsWith(u8, name, stem)) continue;
        if (name.len <= stem.len or name[stem.len] != '(') continue;
        const param_path = std.fmt.bufPrint(&buf, "{s}/{s}", .{ baselines_dir, name }) catch continue;
        if (checkBaselineForSyntaxErrors(io, allocator, param_path)) return true;
    }
    return false;
}

fn checkBaselineForSyntaxErrors(io: Io, allocator: std.mem.Allocator, path: []const u8) bool {
    const content = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(256 * 1024)) catch return false;
    defer allocator.free(content);

    // Check for syntax error codes: TS1xxx (1000-1999)
    var i: usize = 0;
    while (i + 6 < content.len) : (i += 1) {
        if (content[i] == 'T' and content[i + 1] == 'S' and content[i + 2] == '1' and
            isDigit(content[i + 3]) and isDigit(content[i + 4]) and isDigit(content[i + 5]))
        {
            return true;
        }
    }
    return false;
}

fn isDigit(c: u8) bool {
    return c >= '0' and c <= '9';
}

fn getBasename(path: []const u8) []const u8 {
    if (std.mem.lastIndexOfScalar(u8, path, '/')) |i| return path[i + 1 ..];
    return path;
}

// ── Directory walker ─────────────────────────────────────────────

const StackEntry = struct { dir: std.Io.Dir, path: []const u8 };

fn walkTs(io: std.Io, allocator: std.mem.Allocator, base_dir: std.Io.Dir, base_path: []const u8, list: *std.ArrayList([]const u8)) !void {
    var stack: std.ArrayList(StackEntry) = .empty;
    defer {
        for (stack.items) |item| allocator.free(item.path);
        stack.deinit(allocator);
    }
    try stack.append(allocator, .{ .dir = base_dir, .path = try allocator.dupe(u8, base_path) });

    while (stack.items.len > 0) {
        const item = stack.pop().?;
        defer allocator.free(item.path);

        var iter = item.dir.iterate();
        while (iter.next(io) catch null) |entry| {
            var path_buf: [4096]u8 = undefined;
            const full_path = std.fmt.bufPrint(&path_buf, "{s}/{s}", .{ item.path, entry.name }) catch continue;

            if (entry.kind == .directory) {
                const sub_dir = item.dir.openDir(io, entry.name, .{}) catch continue;
                try stack.append(allocator, .{ .dir = sub_dir, .path = try allocator.dupe(u8, full_path) });
            } else if (std.mem.endsWith(u8, entry.name, ".ts") or std.mem.endsWith(u8, entry.name, ".tsx")) {
                try list.append(allocator, try allocator.dupe(u8, full_path));
            }
        }
    }
}
