// Phase 0: JSC + Zig hello world.
//
// Goal: prove the toolchain. Create a JSGlobalContext on macOS via
// JavaScriptCore.framework, evaluate "2 + 40", read the result back as a
// double in Zig, print it.
//
// We declare the JSC C API as extern functions rather than using @cImport
// (removed in Zig 0.17). For a small embedding subset this is simpler and
// keeps the API surface explicit.
//
// Build: `zig build jsc-hello`. Run: `zig build jsc-hello-run`.

const std = @import("std");

// ── JSC C API surface (subset needed for Phase 0) ────────────────────────
// All JSC types are opaque pointers in C. We use *anyopaque on the Zig side
// for the same effect — the actual layout lives behind the JSC framework.

const JSGlobalContextRef = ?*anyopaque;
const JSContextRef = ?*anyopaque;
const JSStringRef = ?*anyopaque;
const JSValueRef = ?*anyopaque;
const JSClassRef = ?*anyopaque;

// Context lifecycle.
extern fn JSGlobalContextCreate(globalObjectClass: JSClassRef) JSGlobalContextRef;
extern fn JSGlobalContextRelease(ctx: JSGlobalContextRef) void;

// String lifecycle. JSStringRef is refcounted; create/release in pairs.
extern fn JSStringCreateWithUTF8CString(string: [*:0]const u8) JSStringRef;
extern fn JSStringRelease(string: JSStringRef) void;

// Script evaluation.
// JSEvaluateScript signature:
//   ctx, script, thisObject(null), sourceURL(null), startingLineNumber(int),
//   exception(out)
extern fn JSEvaluateScript(
    ctx: JSContextRef,
    script: JSStringRef,
    thisObject: JSValueRef,
    sourceURL: JSStringRef,
    startingLineNumber: c_int,
    exception: *JSValueRef,
) JSValueRef;

// Value coercion.
extern fn JSValueToNumber(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) f64;

// ── Main ─────────────────────────────────────────────────────────────────

pub fn main() !void {
    // Create a JSGlobalContext. Passing null for globalObjectClass uses the
    // default. JSC creates its own JSContextGroup implicitly here — perfect
    // for the embedded model where each context gets its own VM heap (no
    // inter-context heap lock contention).
    const ctx = JSGlobalContextCreate(null);
    if (ctx == null) {
        std.debug.print("JSGlobalContextCreate returned null\n", .{});
        return error.JscInitFailed;
    }
    defer JSGlobalContextRelease(ctx);

    try evalAndPrintNumber(ctx, "2 + 40", "2 + 40");
    try evalAndPrintNumber(ctx, "({ answer: 6 * 7 }).answer", "({ answer: 6 * 7 }).answer");
    try evalAndPrintNumber(ctx, "[1, 2, 3, 4].reduce((a, b) => a + b, 0)", "[1, 2, 3, 4].reduce(+,0)");

    std.debug.print("[zig] phase 0 ok\n", .{});
}

fn evalAndPrintNumber(ctx: JSGlobalContextRef, script_text: [*:0]const u8, label: []const u8) !void {
    const script = JSStringCreateWithUTF8CString(script_text);
    defer JSStringRelease(script);

    // JSC reports exceptions via the out-parameter. Zig errors don't unwind
    // across the C boundary, so we MUST check `exception` after every call
    // that takes it — #1 silent-bug source in JSC embedding.
    var exception: JSValueRef = null;
    const result = JSEvaluateScript(ctx, script, null, null, 0, &exception);
    if (exception != null) {
        std.debug.print("[zig] JS exception during eval of: {s}\n", .{label});
        return error.JsException;
    }

    const value = JSValueToNumber(ctx, result, &exception);
    if (exception != null) {
        std.debug.print("[zig] JS exception during ToNumber of: {s}\n", .{label});
        return error.JsException;
    }

    std.debug.print("[zig→jsc] {s} = {d}\n", .{ label, value });
}
