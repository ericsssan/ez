const std = @import("std");
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const Io = std.Io;

/// Fast in-process runner for Babel parser test fixtures.
/// Usage: babel_runner <fixtures-dir>

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [8192]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    if (args.len < 2) {
        try stdout.print("Usage: babel_runner <fixtures-dir>\n", .{});
        try stdout.flush();
        std.process.exit(1);
    }

    const fixtures_dir = args[1];
    const compact = args.len >= 3 and std.mem.eql(u8, args[2], "--compact");

    // Collect all input.js files and options.json with "throws"
    var valid_pass: u32 = 0;
    var valid_fail: u32 = 0;
    const valid_crash: u32 = 0;
    var invalid_pass: u32 = 0;
    var invalid_fail: u32 = 0;
    var skipped: u32 = 0;

    // Walk fixtures directory
    var files: std.ArrayList([]const u8) = .{};
    defer {
        for (files.items) |p| allocator.free(p);
        files.deinit(allocator);
    }

    const base_dir = Io.Dir.cwd().openDir(io, fixtures_dir, .{}) catch {
        try stdout.print("Cannot open {s}\n", .{fixtures_dir});
        try stdout.flush();
        std.process.exit(1);
    };
    try walkCollect(io, allocator, base_dir, fixtures_dir, &files, "input.js");

    for (files.items) |path| {
        // Skip unsupported features
        if (shouldSkip(path)) {
            skipped += 1;
            continue;
        }

        // Check if this is an error test (options.json with "throws" in same dir)
        const is_error_test = isErrorTest(io, allocator, path);

        // Detect module mode from options.json in test dir or parent dirs
        const is_module = isModuleTest(io, allocator, path);

        // Read and parse
        const source = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch continue;
        defer allocator.free(source);

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const file_alloc = arena.allocator();

        const has_error = blk: {
            var tokens = Lexer.tokenizeWithOptions(file_alloc, source, .js, is_module) catch break :blk true;
            defer tokens.deinit(file_alloc);
            var tree = Parser.parseWithLanguage(file_alloc, source, tokens.slice(), .js, is_module) catch break :blk true;
            defer tree.deinit(file_alloc);
            break :blk tree.errors.len > 0;
        };

        if (is_error_test) {
            if (has_error) invalid_pass += 1 else invalid_fail += 1;
        } else {
            if (!has_error) valid_pass += 1 else valid_fail += 1;
        }
    }

    const valid_total = valid_pass + valid_fail + valid_crash;
    const invalid_total = invalid_pass + invalid_fail;

    if (compact) {
        try stdout.print("  valid: {d}/{d}  invalid: {d}/{d} rejected  skipped: {d}\n", .{
            valid_pass, valid_total, invalid_pass, invalid_total, skipped,
        });
    } else {
        try stdout.print("Babel parser conformance tests\n\n", .{});
        try stdout.print("Valid JS (should parse without error):\n", .{});
        try stdout.print("  {d}/{d} passed ({d} failed, {d} crashed, {d} skipped)\n\n", .{
            valid_pass, valid_total, valid_fail, valid_crash, skipped,
        });
        try stdout.print("Invalid JS (should produce errors):\n", .{});
        try stdout.print("  {d}/{d} correctly rejected ({d} incorrectly accepted)\n", .{
            invalid_pass, invalid_total, invalid_fail,
        });
    }
    try stdout.flush();
}

fn shouldSkip(path: []const u8) bool {
    const skip_patterns = [_][]const u8{
        "typescript", "flow", "jsx/", "decorators", "pipeline",
        "record-and-tuple", "v8intrinsic", "hack-pipes", "module-blocks",
        "defer", "source-phase", "import-attributes", "import-assertions",
        "placeholders", "discard-binding", "explicit-resource-management",
        "do-expression", "partial-application", "throw-expression",
        "function-sent", "async-do-expression", "module-string-names",
        "export-extensions", "decimal", "module-attributes",
        "destructuring-private", "regex-modifiers",
    };
    for (skip_patterns) |pat| {
        if (std.mem.indexOf(u8, path, pat) != null) return true;
    }
    return false;
}

fn isModuleTest(io: std.Io, allocator: std.mem.Allocator, input_path: []const u8) bool {
    // Walk up the directory tree checking each options.json for sourceType: "module"
    if (!std.mem.endsWith(u8, input_path, "/input.js")) return false;
    var end = input_path.len - "/input.js".len; // point to dir before input.js

    while (end > 0) {
        // Build <dir>/options.json
        var buf: [4096]u8 = undefined;
        if (end + "/options.json".len > buf.len) break;
        @memcpy(buf[0..end], input_path[0..end]);
        @memcpy(buf[end..][0.."/options.json".len], "/options.json");
        const opts_path = buf[0 .. end + "/options.json".len];

        if (Io.Dir.cwd().readFileAlloc(io, opts_path, allocator, Io.Limit.limited(4096))) |content| {
            defer allocator.free(content);
            if (std.mem.indexOf(u8, content, "\"sourceType\": \"module\"") != null or
                std.mem.indexOf(u8, content, "\"sourceType\":\"module\"") != null)
            {
                return true;
            }
        } else |_| {}

        // Move to parent directory
        while (end > 0 and input_path[end - 1] != '/') end -= 1;
        if (end > 0) end -= 1; // skip the /
    }
    return false;
}

fn isErrorTest(io: std.Io, allocator: std.mem.Allocator, input_path: []const u8) bool {
    if (!std.mem.endsWith(u8, input_path, "input.js")) return false;
    var buf: [4096]u8 = undefined;
    const dir_len = input_path.len - "input.js".len;
    @memcpy(buf[0..dir_len], input_path[0..dir_len]);

    // Check options.json with "throws"
    const opts = "options.json";
    @memcpy(buf[dir_len..][0..opts.len], opts);
    if (Io.Dir.cwd().readFileAlloc(io, buf[0 .. dir_len + opts.len], allocator, Io.Limit.limited(64 * 1024))) |content| {
        defer allocator.free(content);
        if (std.mem.indexOf(u8, content, "\"throws\"") != null) return true;
    } else |_| {}

    // Check output.json with "errors" array
    const out = "output.json";
    @memcpy(buf[dir_len..][0..out.len], out);
    if (Io.Dir.cwd().readFileAlloc(io, buf[0 .. dir_len + out.len], allocator, Io.Limit.limited(256 * 1024))) |content| {
        defer allocator.free(content);
        if (std.mem.indexOf(u8, content, "\"errors\"") != null) return true;
    } else |_| {}

    return false;
}

const StackEntry = struct { dir: std.Io.Dir, path: []const u8 };

fn walkCollect(io: std.Io, allocator: std.mem.Allocator, base_dir: std.Io.Dir, base_path: []const u8, list: *std.ArrayList([]const u8), target_name: []const u8) !void {
    var stack: std.ArrayList(StackEntry) = .{};
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
            } else if (std.mem.eql(u8, entry.name, target_name)) {
                try list.append(allocator, try allocator.dupe(u8, full_path));
            }
        }
    }
}
