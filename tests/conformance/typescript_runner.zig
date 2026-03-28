const std = @import("std");
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const Io = std.Io;
const Token = sx3lint.token;

/// Fast in-process runner for TypeScript parser conformance tests.
/// Usage: typescript_runner <cases-dir>

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [8192]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    if (args.len < 2) {
        try stdout.print("Usage: typescript_runner <cases-dir>\n", .{});
        try stdout.flush();
        std.process.exit(1);
    }

    const cases_dir = args[1];
    const compact = args.len >= 3 and std.mem.eql(u8, args[2], "--compact");

    var pass: u32 = 0;
    var fail: u32 = 0;
    const crash: u32 = 0;
    var skipped: u32 = 0;

    // Collect all .ts files
    var files: std.ArrayList([]const u8) = .{};
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

    for (files.items) |path| {
        // Skip .d.ts and .tsx
        if (std.mem.endsWith(u8, path, ".d.ts")) {
            skipped += 1;
            continue;
        }
        if (std.mem.endsWith(u8, path, ".tsx")) {
            skipped += 1;
            continue;
        }

        const source = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch continue;
        defer allocator.free(source);

        // Detect language from extension
        const lang: Token.Language = if (std.mem.endsWith(u8, path, ".ts")) .ts else .js;

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        const file_alloc = arena.allocator();

        const parsed_ok = blk: {
            var tokens = Lexer.tokenizeWithLanguage(file_alloc, source, lang) catch break :blk false;
            defer tokens.deinit(file_alloc);
            _ = Parser.parseWithLanguage(file_alloc, source, tokens.slice(), lang, false) catch break :blk false;
            break :blk true;
        };

        if (parsed_ok) {
            pass += 1;
        } else {
            // Distinguish crash (OOM) from parse errors
            fail += 1;
        }
    }

    const total = pass + fail + crash;

    if (compact) {
        try stdout.print("  parsed: {d}/{d}  errors: {d}  skipped: {d}\n", .{ pass, total, fail, skipped });
    } else {
        try stdout.print("TypeScript parser conformance tests\n\n", .{});
        try stdout.print("Results: {d}/{d} parsed ({d} with errors, {d} timeouts, {d} skipped)\n", .{
            pass, total, fail, crash, skipped,
        });
    }
    try stdout.flush();
}

const StackEntry = struct { dir: std.Io.Dir, path: []const u8 };

fn walkTs(io: std.Io, allocator: std.mem.Allocator, base_dir: std.Io.Dir, base_path: []const u8, list: *std.ArrayList([]const u8)) !void {
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
            } else if (std.mem.endsWith(u8, entry.name, ".ts") or std.mem.endsWith(u8, entry.name, ".tsx")) {
                try list.append(allocator, try allocator.dupe(u8, full_path));
            }
        }
    }
}
