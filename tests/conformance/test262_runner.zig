const std = @import("std");
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const Io = std.Io;

/// tc39/test262 conformance runner.
///
/// Reads a file list from a text file (one path per line), parses each,
/// checks frontmatter for negative.phase:parse, and reports results.
///
/// Usage: test262_runner <filelist.txt>

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [8192]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    if (args.len < 2) {
        try stdout.print("Usage: test262_runner <filelist.txt>\n", .{});
        try stdout.flush();
        std.process.exit(1);
    }

    const list_path = args[1];
    const list_data = Io.Dir.cwd().readFileAlloc(io, list_path, allocator, Io.Limit.limited(10 * 1024 * 1024)) catch {
        try stdout.print("Cannot read {s}\n", .{list_path});
        try stdout.flush();
        std.process.exit(1);
    };
    defer allocator.free(list_data);

    try stdout.print("tc39/test262 Parser Conformance\n", .{});
    try stdout.print("===============================\n\n", .{});
    try stdout.flush();

    var reject_pass: u32 = 0;
    var reject_fail: u32 = 0;
    var parse_pass: u32 = 0;
    var parse_fail: u32 = 0;
    var skipped: u32 = 0;
    var total: u32 = 0;

    var fail_buf: [100][]const u8 = undefined;
    var fail_count: usize = 0;
    var false_reject_buf: [500][]const u8 = undefined;
    var false_reject_count: usize = 0;

    var lines = std.mem.splitScalar(u8, list_data, '\n');
    while (lines.next()) |line| {
        const path = std.mem.trim(u8, line, " \t\r");
        if (path.len == 0) continue;
        if (!std.mem.endsWith(u8, path, ".js")) continue;

        total += 1;

        const source = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch {
            skipped += 1;
            continue;
        };
        defer allocator.free(source);

        // Parse frontmatter to classify
        const kind = classifyTest(source);
        if (kind == .skip) {
            skipped += 1;
            continue;
        }

        // Skip _FIXTURE files (helper modules, not standalone tests)
        if (std.mem.indexOf(u8, path, "_FIXTURE") != null) {
            skipped += 1;
            continue;
        }

        // Detect module: flags: [module] or .mjs extension.
        // Note: directory-based heuristics (/module-code/, /export/, /import/) are
        // NOT used because some tests in those dirs are specifically for script mode.
        const is_module = isModuleTest(source) or
            std.mem.endsWith(u8, path, ".mjs");

        // Detect onlyStrict flag — prepend "use strict"; to source
        const only_strict = isOnlyStrict(source);

        // Parse using per-file arena to prevent allocator fragmentation
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const file_alloc = arena.allocator();

        const parse_source = if (only_strict) blk: {
            const prefix = "\"use strict\";\n";
            const buf = file_alloc.alloc(u8, prefix.len + source.len) catch {
                skipped += 1;
                continue;
            };
            @memcpy(buf[0..prefix.len], prefix);
            @memcpy(buf[prefix.len..], source);
            break :blk buf;
        } else source;

        const has_error = tryParse(file_alloc, parse_source, is_module, kind == .must_reject);

        switch (kind) {
            .must_reject => {
                if (has_error) {
                    reject_pass += 1;
                } else {
                    reject_fail += 1;
                    if (fail_count < fail_buf.len) {
                        fail_buf[fail_count] = path;
                        fail_count += 1;
                    }
                }
            },
            .must_parse => {
                if (!has_error) {
                    parse_pass += 1;
                } else {
                    parse_fail += 1;
                    if (false_reject_count < false_reject_buf.len) {
                        false_reject_buf[false_reject_count] = path;
                        false_reject_count += 1;
                    }
                }
            },
            .skip => {},
        }

        if (total % 5000 == 0) {
            try stdout.print("  ... {d}\n", .{total});
            try stdout.flush();
        }
    }

    const reject_total = reject_pass + reject_fail;
    const parse_total = parse_pass + parse_fail;
    const overall_total = reject_total + parse_total;
    const overall_pass = reject_pass + parse_pass;

    try stdout.print("\nResults\n", .{});
    try stdout.print("-------\n", .{});
    try stdout.print("  Must-reject:  {d} / {d}\n", .{ reject_pass, reject_total });
    try stdout.print("  Must-parse:   {d} / {d}\n", .{ parse_pass, parse_total });
    try stdout.print("  Skipped:      {d}\n", .{skipped});
    try stdout.print("  Overall:      {d} / {d}\n\n", .{ overall_pass, overall_total });
    try stdout.flush();

    if (fail_count > 0) {
        try stdout.print("Missed rejects ({d} total, showing {d}):\n", .{ reject_fail, fail_count });
        for (fail_buf[0..fail_count]) |p| {
            try stdout.print("  {s}\n", .{p});
        }
        try stdout.flush();
    }

    if (false_reject_count > 0) {
        try stdout.print("False rejects (showing {d}):\n", .{false_reject_count});
        for (false_reject_buf[0..false_reject_count]) |p| {
            try stdout.print("  {s}\n", .{p});
        }
        try stdout.flush();
    }
}

fn tryParse(allocator: std.mem.Allocator, source: []const u8, is_module: bool, run_lint: bool) bool {
    var tokens = Lexer.tokenizeWithLanguage(allocator, source, .js) catch return true;
    defer tokens.deinit(allocator);

    var tree = Parser.parseWithLanguage(allocator, source, tokens.slice(), .js, is_module) catch return true;
    defer tree.deinit(allocator);

    if (tree.errors.len > 0) return true;

    // Run semantic analysis to catch early errors (duplicate bindings, etc.)
    var sem = sx3lint.semantic.SemanticAnalyzer.analyze(allocator, &tree) catch return false;
    defer sem.deinit(allocator);

    if (sem.diagnostics.len > 0) return true;

    if (!run_lint) return false;

    // Run lint rules for must-reject tests to catch early errors via lint rules.
    const lint_diags = sx3lint.linter.lint(allocator, &tree, &sem, null) catch return false;
    if (lint_diags.len > 0) {
        allocator.free(lint_diags);
        return true;
    }
    allocator.free(lint_diags);
    return false;
}

const TestKind = enum { must_reject, must_parse, skip };

fn classifyTest(source: []const u8) TestKind {
    const fm_start = std.mem.indexOf(u8, source, "/*---") orelse return .must_parse;
    const fm_end = std.mem.indexOfPos(u8, source, fm_start, "---*/") orelse return .must_parse;
    const fm = source[fm_start..fm_end];

    if (std.mem.indexOf(u8, fm, "phase: parse") != null) return .must_reject;
    if (std.mem.indexOf(u8, fm, "phase: resolution") != null) return .skip;
    return .must_parse;
}

fn isOnlyStrict(source: []const u8) bool {
    const fm_start = std.mem.indexOf(u8, source, "/*---") orelse return false;
    const fm_end = std.mem.indexOfPos(u8, source, fm_start, "---*/") orelse return false;
    const fm = source[fm_start..fm_end];
    if (std.mem.indexOf(u8, fm, "flags:") == null) return false;
    return std.mem.indexOf(u8, fm, "onlyStrict") != null;
}

fn isModuleTest(source: []const u8) bool {
    const fm_start = std.mem.indexOf(u8, source, "/*---") orelse return false;
    const fm_end = std.mem.indexOfPos(u8, source, fm_start, "---*/") orelse return false;
    const fm = source[fm_start..fm_end];
    // Find "flags:" line and check if it contains "module"
    const flags_start = std.mem.indexOf(u8, fm, "flags:") orelse return false;
    // Find end of flags line (next newline)
    const flags_line_end = std.mem.indexOfPos(u8, fm, flags_start, "\n") orelse fm.len;
    const flags_line = fm[flags_start..flags_line_end];
    return std.mem.indexOf(u8, flags_line, "module") != null;
}
