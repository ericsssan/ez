const std = @import("std");
const Io = std.Io;
const JSGlobalContextRef = ?*anyopaque;
const JSContextRef = ?*anyopaque;
const JSStringRef = ?*anyopaque;
const JSValueRef = ?*anyopaque;
const JSObjectRef = ?*anyopaque;
const JSClassRef = ?*anyopaque;
extern fn JSGlobalContextCreate(globalObjectClass: JSClassRef) JSGlobalContextRef;
extern fn JSGlobalContextRelease(ctx: JSGlobalContextRef) void;
extern fn JSStringCreateWithUTF8CString(string: [*:0]const u8) JSStringRef;
extern fn JSStringRelease(string: JSStringRef) void;
extern fn JSEvaluateScript(ctx: JSContextRef, script: JSStringRef, thisObject: JSValueRef, sourceURL: JSStringRef, startingLineNumber: c_int, exception: *JSValueRef) JSValueRef;
extern fn JSValueToStringCopy(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSStringRef;
extern fn JSStringGetMaximumUTF8CStringSize(string: JSStringRef) usize;
extern fn JSStringGetUTF8CString(string: JSStringRef, buffer: [*]u8, bufferSize: usize) usize;

pub fn main(_: std.process.Init) !void {
    const ctx = JSGlobalContextCreate(null);
    defer JSGlobalContextRelease(ctx);
    const scripts = [_][]const u8{
        "typeof TextDecoder",
        "typeof TextEncoder",
        "typeof console",
        "typeof Buffer",
        "typeof process",
        "typeof require",
        "typeof setTimeout",
        "typeof globalThis",
        "typeof URL",
        "typeof crypto",
    };
    for (scripts) |src| {
        var buf: [128]u8 = undefined;
        const s = std.fmt.bufPrintZ(&buf, "{s}", .{src}) catch unreachable;
        const js = JSStringCreateWithUTF8CString(s.ptr);
        defer JSStringRelease(js);
        var ex: JSValueRef = null;
        const r = JSEvaluateScript(ctx, js, null, null, 0, &ex);
        if (ex != null) { std.debug.print("{s}: ERR\n", .{src}); continue; }
        const rs = JSValueToStringCopy(ctx, r, &ex);
        defer JSStringRelease(rs);
        var out: [128]u8 = undefined;
        const wr = JSStringGetUTF8CString(rs, &out, out.len);
        std.debug.print("{s} => {s}\n", .{src, out[0..@min(wr,out.len)-|1]});
    }
}
