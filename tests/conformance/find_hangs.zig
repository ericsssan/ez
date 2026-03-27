const std = @import("std");
const sx3lint = @import("sx3lint");
const Lexer = sx3lint.Lexer;
const Parser = sx3lint.Parser;
const Io = std.Io;

/// Finds files that cause excessive parsing by checking token count vs file size.
/// A file with N tokens should parse in roughly O(N) time. If the parser creates
/// way more AST nodes than tokens, something is looping.
///
/// Usage: find_hangs <filelist.txt>

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [8192]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    if (args.len < 2) {
        try stdout.print("Usage: find_hangs <filelist.txt>\n", .{});
        try stdout.flush();
        std.process.exit(1);
    }

    const list_data = Io.Dir.cwd().readFileAlloc(io, args[1], allocator, Io.Limit.limited(10 * 1024 * 1024)) catch {
        try stdout.print("Cannot read {s}\n", .{args[1]});
        try stdout.flush();
        std.process.exit(1);
    };
    defer allocator.free(list_data);

    var total: u32 = 0;
    var suspicious: u32 = 0;

    var lines = std.mem.splitScalar(u8, list_data, '\n');
    while (lines.next()) |line| {
        const path = std.mem.trim(u8, line, " \t\r");
        if (path.len == 0 or !std.mem.endsWith(u8, path, ".js")) continue;

        total += 1;

        const source = Io.Dir.cwd().readFileAlloc(io, path, allocator, Io.Limit.limited(2 * 1024 * 1024)) catch continue;
        defer allocator.free(source);

        const is_module = isModuleTest(source) or std.mem.indexOf(u8, path, "module-code/") != null;

        // Tokenize
        var tokens = Lexer.tokenizeWithLanguage(allocator, source, .js) catch continue;
        const tok_count = tokens.len;
        defer tokens.deinit(allocator);

        // Parse
        var tree = Parser.parseWithLanguage(allocator, source, tokens.slice(), .js, is_module) catch continue;
        const node_count = tree.nodes.len;
        defer tree.deinit(allocator);

        // Normal code: ~1-2x tokens. If ratio > 5, error recovery is looping.
        if (tok_count > 20 and node_count > tok_count * 5) {
            suspicious += 1;
            try stdout.print("SUSPICIOUS ({d} tokens, {d} nodes, ratio {d}): {s}\n", .{
                tok_count, node_count, node_count / tok_count, path,
            });
            try stdout.flush();
        }

        if (total % 5000 == 0) {
            try stdout.print("  ... {d} scanned\n", .{total});
            try stdout.flush();
        }
    }

    try stdout.print("\nDone: {d} files, {d} suspicious\n", .{ total, suspicious });
    try stdout.flush();
}

fn isModuleTest(source: []const u8) bool {
    const fm_start = std.mem.indexOf(u8, source, "/*---") orelse return false;
    const fm_end = std.mem.indexOfPos(u8, source, fm_start, "---*/") orelse return false;
    const fm = source[fm_start..fm_end];
    if (std.mem.indexOf(u8, fm, "flags:") == null) return false;
    return std.mem.indexOf(u8, fm, "module") != null;
}
