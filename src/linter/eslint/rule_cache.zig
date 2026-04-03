const std = @import("std");
const QjsLintEngine = @import("qjs_engine.zig").QjsLintEngine;
const HandlerSource = QjsLintEngine.HandlerSource;

/// Cached rule metadata — everything needed to compile predicates
/// without running QuickJS.
pub const CachedRule = struct {
    name: []const u8,
    handlers: []const HandlerSource,
    messages: std.StringArrayHashMap([]const u8),
};

/// Write extracted rule metadata to a binary cache file.
/// Format: [rule_count:u32] [rule...]
///   rule: [name_len:u32] [name] [handler_count:u32] [handler...] [msg_count:u32] [msg...]
///   handler: [key_len:u32] [key] [src_len:u32] [src] [is_exit:u8]
///   msg: [id_len:u32] [id] [tpl_len:u32] [tpl]
pub fn writeCache(
    rules: []const CachedRule,
    path: []const u8,
) bool {
    const cstd = @cImport(@cInclude("stdio.h"));
    var pbuf: [1024]u8 = undefined;
    if (path.len >= pbuf.len) return false;
    @memcpy(pbuf[0..path.len], path);
    pbuf[path.len] = 0;

    const fp = cstd.fopen(&pbuf, "wb") orelse return false;
    defer _ = cstd.fclose(fp);

    // Magic + version
    const magic: [4]u8 = .{ 'S', 'R', 'C', 1 };
    _ = cstd.fwrite(&magic, 1, 4, fp);

    // Rule count
    const rc: u32 = @intCast(rules.len);
    _ = cstd.fwrite(std.mem.asBytes(&rc), 1, 4, fp);

    for (rules) |rule| {
        writeStr(fp, rule.name, cstd);
        const hc: u32 = @intCast(rule.handlers.len);
        _ = cstd.fwrite(std.mem.asBytes(&hc), 1, 4, fp);
        for (rule.handlers) |h| {
            writeStr(fp, h.key, cstd);
            writeStr(fp, h.source, cstd);
            const exit_byte: u8 = if (h.is_exit) 1 else 0;
            _ = cstd.fwrite(&exit_byte, 1, 1, fp);
        }
        const mc: u32 = @intCast(rule.messages.count());
        _ = cstd.fwrite(std.mem.asBytes(&mc), 1, 4, fp);
        for (rule.messages.keys(), rule.messages.values()) |k, v| {
            writeStr(fp, k, cstd);
            writeStr(fp, v, cstd);
        }
    }
    return true;
}

/// Read cached rule metadata from a binary file.
pub fn readCache(
    path: []const u8,
    allocator: std.mem.Allocator,
) ?[]CachedRule {
    const cstd = @cImport(@cInclude("stdio.h"));
    var pbuf: [1024]u8 = undefined;
    if (path.len >= pbuf.len) return null;
    @memcpy(pbuf[0..path.len], path);
    pbuf[path.len] = 0;

    const fp = cstd.fopen(&pbuf, "rb") orelse return null;
    defer _ = cstd.fclose(fp);

    // Check magic
    var magic: [4]u8 = undefined;
    if (cstd.fread(&magic, 1, 4, fp) != 4) return null;
    if (magic[0] != 'S' or magic[1] != 'R' or magic[2] != 'C' or magic[3] != 1) return null;

    var rc: u32 = 0;
    if (cstd.fread(std.mem.asBytes(&rc), 1, 4, fp) != 4) return null;

    const rules = allocator.alloc(CachedRule, rc) catch return null;
    for (rules) |*rule| {
        rule.name = readStr(fp, allocator, cstd) orelse return null;

        var hc: u32 = 0;
        if (cstd.fread(std.mem.asBytes(&hc), 1, 4, fp) != 4) return null;
        const handlers = allocator.alloc(HandlerSource, hc) catch return null;
        for (handlers) |*h| {
            h.key = readStr(fp, allocator, cstd) orelse return null;
            h.source = readStr(fp, allocator, cstd) orelse return null;
            var exit_byte: u8 = 0;
            if (cstd.fread(&exit_byte, 1, 1, fp) != 1) return null;
            h.is_exit = exit_byte != 0;
        }
        rule.handlers = handlers;

        var mc: u32 = 0;
        if (cstd.fread(std.mem.asBytes(&mc), 1, 4, fp) != 4) return null;
        rule.messages = std.StringArrayHashMap([]const u8).init(allocator);
        for (0..mc) |_| {
            const k = readStr(fp, allocator, cstd) orelse return null;
            const v = readStr(fp, allocator, cstd) orelse return null;
            rule.messages.put(k, v) catch return null;
        }
    }
    return rules;
}

fn writeStr(fp: anytype, s: []const u8, cstd: anytype) void {
    const len: u32 = @intCast(s.len);
    _ = cstd.fwrite(std.mem.asBytes(&len), 1, 4, fp);
    if (s.len > 0) _ = cstd.fwrite(s.ptr, 1, s.len, fp);
}

fn readStr(fp: anytype, allocator: std.mem.Allocator, cstd: anytype) ?[]const u8 {
    var len: u32 = 0;
    if (cstd.fread(std.mem.asBytes(&len), 1, 4, fp) != 4) return null;
    if (len == 0) return "";
    const buf = allocator.alloc(u8, len) catch return null;
    if (cstd.fread(buf.ptr, 1, len, fp) != len) return null;
    return buf;
}
