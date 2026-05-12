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

    // ── JIT-sensitivity probe ─────────────────────────────────────
    // Apple's JavaScriptCore.framework refuses to JIT in unentitled processes
    // (sandbox / hardened-runtime security). LLInt-only execution is 5-20×
    // slower than JIT'd code for hot loops. A simple sum loop: ~1-5ms with
    // JIT enabled, 50-200ms without. Run twice — second run after warmup.
    {
        const probe = JSStringCreateWithUTF8CString("(() => { let s = 0; for (let i = 0; i < 10_000_000; i++) s += i; return s; })()");
        defer JSStringRelease(probe);
        var run: u32 = 0;
        while (run < 3) : (run += 1) {
            var ex: JSValueRef = null;
            var ts1: std.c.timespec = .{ .sec = 0, .nsec = 0 };
            var ts2: std.c.timespec = .{ .sec = 0, .nsec = 0 };
            _ = std.c.clock_gettime(.MONOTONIC, &ts1);
            _ = JSEvaluateScript(ctx, probe, null, null, 0, &ex);
            _ = std.c.clock_gettime(.MONOTONIC, &ts2);
            if (ex != null) { std.debug.print("jit-probe run {d}: ERR\n", .{run}); continue; }
            const ns = (ts2.sec - ts1.sec) * 1_000_000_000 + (ts2.nsec - ts1.nsec);
            const ms = @as(f64, @floatFromInt(ns)) / 1_000_000.0;
            std.debug.print("jit-probe run {d} (10M sum): {d:.1}ms\n", .{ run, ms });
        }
        std.debug.print("(JIT enabled if <20ms steady; LLInt-only if >50ms)\n", .{});
    }
}
