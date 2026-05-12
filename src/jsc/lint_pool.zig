// Phase 2: multi-context JSC pool with rule-parallel fork-join.
//
// Architecture:
//   main thread (Zig)
//     ├─ parses source ONCE → ast_buffer (shared across workers, read-only)
//     ├─ partitions rules into N buckets
//     ├─ wakes N workers via ResetEvents
//     └─ waits all done, merges diag buffers
//
//   worker[i]: own OS thread, own JSGlobalContext (own JSContextGroup)
//     ├─ one-time init: create group + context, load polyfills + bundle,
//     │   push tag names
//     └─ loop: wait(work_ready) → execute rule subset → signal(work_done)
//
// JSC threading rules:
//   - Each context belongs to a JSContextGroup; the group has a heap lock,
//     only one thread can run JS in any context of the group at a time.
//   - Solution: one group per context → N independent VMs → true parallelism.
//   - Contexts are thread-affine: once thread T touches context C, only T
//     can touch C. We enforce by structure (each context lives in its
//     worker struct, only the worker thread accesses it).

const std = @import("std");
const Io = std.Io;

const ez = @import("ez");
const js_buffer = ez.js_buffer;
const parse_to_buffer = ez.parse_to_buffer;
const Language = ez.token.Language;
const layout = ez.layout;

// ── JSC C API (subset we need) ────────────────────────────────────────────
const JSGlobalContextRef = ?*anyopaque;
const JSContextRef = ?*anyopaque;
const JSContextGroupRef = ?*anyopaque;
const JSStringRef = ?*anyopaque;
const JSValueRef = ?*anyopaque;
const JSObjectRef = ?*anyopaque;
const JSClassRef = ?*anyopaque;

extern fn JSContextGroupCreate() JSContextGroupRef;
extern fn JSContextGroupRelease(group: JSContextGroupRef) void;
extern fn JSGlobalContextCreateInGroup(group: JSContextGroupRef, globalObjectClass: JSClassRef) JSGlobalContextRef;
extern fn JSGlobalContextRelease(ctx: JSGlobalContextRef) void;
extern fn JSContextGetGlobalObject(ctx: JSContextRef) JSObjectRef;
extern fn JSGarbageCollect(ctx: JSContextRef) void;

extern fn JSStringCreateWithUTF8CString(string: [*:0]const u8) JSStringRef;
extern fn JSStringRelease(string: JSStringRef) void;
extern fn JSStringGetMaximumUTF8CStringSize(string: JSStringRef) usize;
extern fn JSStringGetUTF8CString(string: JSStringRef, buffer: [*]u8, bufferSize: usize) usize;

extern fn JSEvaluateScript(
    ctx: JSContextRef,
    script: JSStringRef,
    thisObject: JSValueRef,
    sourceURL: JSStringRef,
    startingLineNumber: c_int,
    exception: *JSValueRef,
) JSValueRef;

extern fn JSValueToStringCopy(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSStringRef;
extern fn JSValueIsUndefined(ctx: JSContextRef, value: JSValueRef) bool;
extern fn JSValueMakeString(ctx: JSContextRef, string: JSStringRef) JSValueRef;
extern fn JSObjectGetProperty(ctx: JSContextRef, object: JSObjectRef, propertyName: JSStringRef, exception: *JSValueRef) JSValueRef;

extern fn JSObjectCallAsFunction(
    ctx: JSContextRef,
    object: JSObjectRef,
    thisObject: JSObjectRef,
    argumentCount: usize,
    arguments: ?[*]const JSValueRef,
    exception: *JSValueRef,
) JSValueRef;

const JSTypedArrayBytesDeallocator = ?*const fn (?*anyopaque, ?*anyopaque) callconv(.c) void;
extern fn JSObjectMakeArrayBufferWithBytesNoCopy(
    ctx: JSContextRef,
    bytes: ?*anyopaque,
    byteLength: usize,
    bytesDeallocator: JSTypedArrayBytesDeallocator,
    deallocatorContext: ?*anyopaque,
    exception: *JSValueRef,
) JSObjectRef;

extern fn JSObjectMakeArray(ctx: JSContextRef, argumentCount: usize, arguments: ?[*]const JSValueRef, exception: *JSValueRef) JSObjectRef;

const JSTypedArrayType = enum(c_uint) { Int8 = 0, Int16 = 1, Int32 = 2, Uint8 = 3, Uint8Clamped = 4, Uint16 = 5, Uint32 = 6, Float32 = 7, Float64 = 8, ArrayBuffer = 9, None = 10, BigInt64 = 11, BigUint64 = 12 };
extern fn JSValueGetTypedArrayType(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSTypedArrayType;
extern fn JSObjectGetTypedArrayBytesPtr(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) ?*anyopaque;
extern fn JSObjectGetTypedArrayLength(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) usize;

// ── Monotonic time ────────────────────────────────────────────────────────
fn nanosNow() i128 {
    var ts: std.c.timespec = undefined;
    _ = std.c.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * 1_000_000_000 + @as(i128, ts.nsec);
}
fn msSince(t0: i128) f64 {
    return @as(f64, @floatFromInt(nanosNow() - t0)) / 1_000_000.0;
}

// ── Bundle stub patcher (same as lint_one) ───────────────────────────────
fn patchBundleStubs(alloc: std.mem.Allocator, src: []const u8) ![]u8 {
    const replacements = [_]struct { from: []const u8, to: []const u8 }{
        .{ .from = "var fs = (() => ({}))", .to = "var fs = globalThis._fs    " },
        .{ .from = "const _fs = (() => ({}))", .to = "const _fs = globalThis._fs " },
        .{ .from = "const inspector = (() => ({}))", .to = "const inspector = {}                   " },
        .{ .from = "var { spawnSync } = (() => ({}))", .to = "var spawnSync = (() => ({stdout:'',status:1}))" },
    };
    var out = try alloc.alloc(u8, src.len * 2);
    var out_len: usize = 0;
    var i: usize = 0;
    outer: while (i < src.len) {
        for (replacements) |r| {
            if (i + r.from.len <= src.len and std.mem.eql(u8, src[i .. i + r.from.len], r.from)) {
                @memcpy(out[out_len .. out_len + r.to.len], r.to);
                out_len += r.to.len;
                i += r.from.len;
                continue :outer;
            }
        }
        out[out_len] = src[i];
        out_len += 1;
        i += 1;
    }

    // Append trigger to invoke the bundle's lazy entry thunk.
    var trimmed_end: usize = out_len;
    while (trimmed_end > 0 and std.ascii.isWhitespace(out[trimmed_end - 1])) trimmed_end -= 1;
    const trigger_marker = "})();";
    const trigger_call = "require_runner_entry();})();";
    const new_len = if (trimmed_end >= trigger_marker.len and std.mem.eql(u8, out[trimmed_end - trigger_marker.len .. trimmed_end], trigger_marker))
        trimmed_end - trigger_marker.len + trigger_call.len
    else
        out_len + trigger_call.len;
    if (new_len > out.len) {
        out = try alloc.realloc(out, new_len);
    }
    if (trimmed_end >= trigger_marker.len and std.mem.eql(u8, out[trimmed_end - trigger_marker.len .. trimmed_end], trigger_marker)) {
        @memcpy(out[trimmed_end - trigger_marker.len ..][0..trigger_call.len], trigger_call);
        out_len = trimmed_end - trigger_marker.len + trigger_call.len;
    } else {
        @memcpy(out[out_len..][0..trigger_call.len], trigger_call);
        out_len += trigger_call.len;
    }
    return try alloc.realloc(out, out_len);
}

// ── Per-worker state ──────────────────────────────────────────────────────
const Job = struct {
    ast_buf: []u8, // shared, read-only after parse
    source: []const u8,
    rule_names: []const []const u8, // subset for this worker
    filename: []const u8,
};

// Atomic state machine for fork-join wakeup. Replaces std.Thread.ResetEvent
// which Zig 0.17 removed. Busy-spin is fine here — main wakes workers ~once
// per file, workers signal main ~once per file. Bounded by total lint work.
const STATE_IDLE: u32 = 0;
const STATE_WORK_READY: u32 = 1;
const STATE_WORK_DONE: u32 = 2;
const STATE_SHUTDOWN: u32 = 3;

const Worker = struct {
    id: u32,
    thread: std.Thread = undefined,
    state: std.atomic.Value(u32) = .init(STATE_IDLE),
    job: ?Job = null,
    // Per-worker JSC context (only this worker's thread may touch).
    group: JSContextGroupRef = null,
    ctx: JSGlobalContextRef = null,
    ez_lint: JSObjectRef = null,
    // Per-worker timing
    init_ms: f64 = 0,
    last_lint_ms: f64 = 0,
    diags_count: u32 = 0,
    // Per-worker result buffer (Zig-side copy of diag triples).
    result: std.ArrayList(u32) = .empty,
    init_done: std.atomic.Value(u32) = .init(0), // 0=in-progress, 1=ok, 2=err
    init_err: ?anyerror = null,
    // Shared (passed in once at spawn)
    polyfills: []const u8,
    bundle: []const u8,
    tag_names: []const [*:0]const u8,
    alloc: std.mem.Allocator,

    fn run(self: *Worker) void {
        self.run_impl() catch |err| {
            self.init_err = err;
            self.init_done.store(2, .release);
        };
    }

    fn run_impl(self: *Worker) !void {
        const t_init = nanosNow();

        // Each worker creates its own group → own VM heap → no inter-worker
        // lock contention. This is the key to true parallelism in JSC.
        const group = JSContextGroupCreate();
        self.group = group;
        defer JSContextGroupRelease(group);
        const ctx = JSGlobalContextCreateInGroup(group, null);
        if (ctx == null) return error.JscInitFailed;
        self.ctx = ctx;
        defer JSGlobalContextRelease(ctx);

        // Load polyfills.
        try evalScript(ctx, self.polyfills, "polyfills.js");
        // Load runner bundle.
        try evalScript(ctx, self.bundle, "runner-iife.js");

        // Look up ezLint.
        const global = JSContextGetGlobalObject(ctx);
        const ez_lint_name = JSStringCreateWithUTF8CString("ezLint");
        defer JSStringRelease(ez_lint_name);
        var ex: JSValueRef = null;
        const ez_lint_val = JSObjectGetProperty(ctx, global, ez_lint_name, &ex);
        if (ex != null) return error.EzLintNotFound;
        if (JSValueIsUndefined(ctx, ez_lint_val)) return error.EzLintUndefined;
        self.ez_lint = ez_lint_val;

        // Push tag names.
        try pushTagNames(ctx, self.tag_names, self.alloc);

        self.init_ms = msSince(t_init);
        self.init_done.store(1, .release);

        // Work loop — busy-spin wait for state change.
        while (true) {
            // Wait for state != IDLE.
            while (true) {
                const s = self.state.load(.acquire);
                if (s == STATE_WORK_READY or s == STATE_SHUTDOWN) break;
                std.atomic.spinLoopHint();
            }
            if (self.state.load(.acquire) == STATE_SHUTDOWN) break;
            const job = self.job orelse {
                self.state.store(STATE_IDLE, .release);
                continue;
            };
            self.executeJob(job) catch |err| {
                std.debug.print("[worker {d}] error: {}\n", .{ self.id, err });
            };
            self.state.store(STATE_WORK_DONE, .release);
        }
    }

    fn executeJob(self: *Worker, job: Job) !void {
        const t0 = nanosNow();
        const ctx = self.ctx;

        // Wrap AST buffer as JSArrayBuffer (no-copy — Zig owns the bytes,
        // alive for the whole pool's lifetime). Same underlying bytes are
        // wrapped INDEPENDENTLY in each worker's context.
        var ex: JSValueRef = null;
        const ast_buf_val = JSObjectMakeArrayBufferWithBytesNoCopy(ctx, job.ast_buf.ptr, job.ast_buf.len, null, null, &ex);
        if (ex != null) return error.JsException;

        // Source string.
        const src_zbuf = try self.alloc.allocSentinel(u8, job.source.len, 0);
        defer self.alloc.free(src_zbuf);
        @memcpy(src_zbuf[0..job.source.len], job.source);
        const src_jstr = JSStringCreateWithUTF8CString(src_zbuf.ptr);
        defer JSStringRelease(src_jstr);
        const src_val = JSValueMakeString(ctx, src_jstr);

        // Rule names array.
        var rule_strs = try self.alloc.alloc(JSStringRef, job.rule_names.len);
        defer self.alloc.free(rule_strs);
        var rule_vals = try self.alloc.alloc(JSValueRef, job.rule_names.len);
        defer self.alloc.free(rule_vals);
        for (job.rule_names, 0..) |name, i| {
            const z = try self.alloc.allocSentinel(u8, name.len, 0);
            defer self.alloc.free(z);
            @memcpy(z[0..name.len], name);
            rule_strs[i] = JSStringCreateWithUTF8CString(z.ptr);
            rule_vals[i] = JSValueMakeString(ctx, rule_strs[i]);
        }
        defer for (rule_strs) |s| JSStringRelease(s);
        const rules_arr = JSObjectMakeArray(ctx, rule_vals.len, rule_vals.ptr, &ex);
        if (ex != null) return error.JsException;

        // Filename.
        const fn_zbuf = try self.alloc.allocSentinel(u8, job.filename.len, 0);
        defer self.alloc.free(fn_zbuf);
        @memcpy(fn_zbuf[0..job.filename.len], job.filename);
        const fn_jstr = JSStringCreateWithUTF8CString(fn_zbuf.ptr);
        defer JSStringRelease(fn_jstr);
        const fn_val = JSValueMakeString(ctx, fn_jstr);

        // Call ezLint(ast, src, ruleNames, filename).
        var args = [_]JSValueRef{ ast_buf_val, src_val, rules_arr, fn_val };
        const result = JSObjectCallAsFunction(ctx, self.ez_lint, null, args.len, &args, &ex);
        if (ex != null) return error.JsException;

        // Read back Uint32Array.
        const ta_type = JSValueGetTypedArrayType(ctx, result, &ex);
        if (ex != null or ta_type != .Uint32) return error.BadResult;
        const bytes_ptr = JSObjectGetTypedArrayBytesPtr(ctx, result, &ex);
        if (ex != null) return error.JsException;
        const elem_count = JSObjectGetTypedArrayLength(ctx, result, &ex);
        if (ex != null) return error.JsException;

        const u32s: [*]const u32 = @ptrCast(@alignCast(bytes_ptr));
        self.result.clearRetainingCapacity();
        try self.result.appendSlice(self.alloc, u32s[0..elem_count]);
        self.diags_count = @intCast(elem_count / 3);

        // GC controlled by env var so we can measure with/without.
        if (std.c.getenv("EZ_NO_GC") == null) JSGarbageCollect(ctx);

        self.last_lint_ms = msSince(t0);
    }
};

fn evalScript(ctx: JSContextRef, source: []const u8, source_url: []const u8) !void {
    const src_buf = try std.heap.page_allocator.alloc(u8, source.len + 1);
    defer std.heap.page_allocator.free(src_buf);
    @memcpy(src_buf[0..source.len], source);
    src_buf[source.len] = 0;
    const script = JSStringCreateWithUTF8CString(src_buf.ptr[0..source.len :0]);
    defer JSStringRelease(script);

    const url_buf = try std.heap.page_allocator.alloc(u8, source_url.len + 1);
    defer std.heap.page_allocator.free(url_buf);
    @memcpy(url_buf[0..source_url.len], source_url);
    url_buf[source_url.len] = 0;
    const url = JSStringCreateWithUTF8CString(url_buf.ptr[0..source_url.len :0]);
    defer JSStringRelease(url);

    var ex: JSValueRef = null;
    _ = JSEvaluateScript(ctx, script, null, url, 1, &ex);
    if (ex != null) {
        std.debug.print("[worker] eval exception in {s}\n", .{source_url});
        return error.JsException;
    }
}

fn pushTagNames(ctx: JSContextRef, tag_names: []const [*:0]const u8, alloc: std.mem.Allocator) !void {
    var vals = try alloc.alloc(JSValueRef, tag_names.len);
    defer alloc.free(vals);
    var strs = try alloc.alloc(JSStringRef, tag_names.len);
    defer alloc.free(strs);
    for (tag_names, 0..) |n, i| {
        strs[i] = JSStringCreateWithUTF8CString(n);
        vals[i] = JSValueMakeString(ctx, strs[i]);
    }
    defer for (strs) |s| JSStringRelease(s);

    var ex: JSValueRef = null;
    const arr = JSObjectMakeArray(ctx, vals.len, vals.ptr, &ex);
    if (ex != null) return error.JsException;
    const global = JSContextGetGlobalObject(ctx);
    const setter_name = JSStringCreateWithUTF8CString("__ezSetTagNames");
    defer JSStringRelease(setter_name);
    const setter = JSObjectGetProperty(ctx, global, setter_name, &ex);
    if (ex != null) return error.JsException;
    var args = [_]JSValueRef{arr};
    _ = JSObjectCallAsFunction(ctx, setter, null, args.len, &args, &ex);
    if (ex != null) return error.JsException;
}

// ── Pool ──────────────────────────────────────────────────────────────────
const Pool = struct {
    workers: []Worker,
    alloc: std.mem.Allocator,

    fn init(
        alloc: std.mem.Allocator,
        n_workers: u32,
        polyfills: []const u8,
        bundle: []const u8,
        tag_names: []const [*:0]const u8,
    ) !Pool {
        const workers = try alloc.alloc(Worker, n_workers);
        for (workers, 0..) |*w, i| {
            w.* = .{
                .id = @intCast(i),
                .polyfills = polyfills,
                .bundle = bundle,
                .tag_names = tag_names,
                .alloc = alloc,
            };
            w.thread = try std.Thread.spawn(.{}, Worker.run, .{w});
        }
        // Wait for all workers to finish init.
        for (workers) |*w| {
            while (w.init_done.load(.acquire) == 0) std.atomic.spinLoopHint();
            if (w.init_err) |e| return e;
        }
        return .{ .workers = workers, .alloc = alloc };
    }

    fn deinit(self: *Pool) void {
        // Signal shutdown, wake all, join.
        for (self.workers) |*w| {
            w.state.store(STATE_SHUTDOWN, .release);
        }
        for (self.workers) |*w| {
            w.thread.join();
            w.result.deinit(self.alloc);
        }
        self.alloc.free(self.workers);
    }

    /// Dispatch one lint job to each worker. Waits for all to complete.
    fn lintParallel(
        self: *Pool,
        ast_buf: []u8,
        source: []const u8,
        partitions: []const []const []const u8,
        filename: []const u8,
    ) !u32 {
        std.debug.assert(partitions.len == self.workers.len);
        for (self.workers, partitions) |*w, part| {
            w.job = .{
                .ast_buf = ast_buf,
                .source = source,
                .rule_names = part,
                .filename = filename,
            };
            w.state.store(STATE_WORK_READY, .release);
        }
        var total: u32 = 0;
        for (self.workers) |*w| {
            while (w.state.load(.acquire) != STATE_WORK_DONE) std.atomic.spinLoopHint();
            w.state.store(STATE_IDLE, .release);
            total += w.diags_count;
        }
        return total;
    }
};

// ── Main ──────────────────────────────────────────────────────────────────

pub fn main(init: std.process.Init) !void {
    const alloc = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) {
        std.debug.print("usage: jsc-lint-pool <source_path> [n_workers=4]\n", .{});
        return;
    }
    const source_path = args[1];
    const n_workers: u32 = if (args.len >= 3)
        std.fmt.parseInt(u32, args[2], 10) catch 4
    else
        4;
    std.debug.print("[main] n_workers={d}\n", .{n_workers});

    // ── Load polyfills + bundle, patch the bundle once ───────────────────
    const t_bundle = nanosNow();
    const polyfills = try Io.Dir.cwd().readFileAlloc(io, "src/jsc/polyfills.js", alloc, Io.Limit.limited(1024 * 1024));
    defer alloc.free(polyfills);
    const bundle_raw = try Io.Dir.cwd().readFileAlloc(io, "src/jsc/runner-iife.js", alloc, Io.Limit.limited(50 * 1024 * 1024));
    defer alloc.free(bundle_raw);
    const bundle = try patchBundleStubs(alloc, bundle_raw);
    defer alloc.free(bundle);
    std.debug.print("[main] bundle ready ({d:.1}MB) in {d:.1}ms\n", .{ @as(f64, @floatFromInt(bundle.len)) / (1024.0 * 1024.0), msSince(t_bundle) });

    // ── Parse source ─────────────────────────────────────────────────────
    const source = try Io.Dir.cwd().readFileAlloc(io, source_path, alloc, Io.Limit.limited(64 * 1024 * 1024));
    defer alloc.free(source);
    const source_len: u32 = @intCast(source.len);
    const bump_budget: u32 = @max(@as(u32, 4 * 1024 * 1024), source_len *| 30);
    const source_start = js_buffer.HEADER_SIZE + bump_budget;
    const total_buf_len = source_start + source_len;
    const ast_bytes = try alloc.alignedAlloc(u8, .@"16", total_buf_len);
    defer alloc.free(ast_bytes);
    @memcpy(ast_bytes[source_start .. source_start + source_len], source);
    const t_parse = nanosNow();
    var sem_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer sem_arena.deinit();
    _ = try parse_to_buffer.parseToBuffer(ast_bytes.ptr, total_buf_len, source_start, source_len, .js, true, &sem_arena);
    std.debug.print("[main] parsed {s} ({d:.1}MB src) in {d:.1}ms\n", .{ source_path, @as(f64, @floatFromInt(source.len)) / (1024.0 * 1024.0), msSince(t_parse) });

    // ── Build tag names ──────────────────────────────────────────────────
    var tag_names_buf = try alloc.alloc([*:0]const u8, layout.tag_count);
    defer alloc.free(tag_names_buf);
    for (0..layout.tag_count) |i| tag_names_buf[i] = layout.tag_names[i];

    // ── Spawn pool ───────────────────────────────────────────────────────
    const t_pool_init = nanosNow();
    var pool = try Pool.init(alloc, n_workers, polyfills, bundle, tag_names_buf);
    defer pool.deinit();
    std.debug.print("[main] pool init in {d:.1}ms (per-worker: ", .{msSince(t_pool_init)});
    for (pool.workers) |*w| std.debug.print("{d:.0}ms ", .{w.init_ms});
    std.debug.print(")\n", .{});

    // ── Build rule partitions ────────────────────────────────────────────
    // For Phase 2 initial test: same rule on all workers (over-counts diags
    // but validates the parallel mechanic). Real cost-weighted partitioning
    // across many rules is next.
    const rule = "no-debugger";
    const partitions = try alloc.alloc([]const []const u8, n_workers);
    defer alloc.free(partitions);
    const rule_slice = try alloc.alloc([]const u8, 1);
    defer alloc.free(rule_slice);
    rule_slice[0] = rule;
    // Phase-2 first test: same rule on all workers. Each worker walks the
    // AST and runs no-debugger independently. Wall time should be ≈ a single
    // worker's lint time IF JSC contexts run truly in parallel (separate VMs).
    // If wall ≈ N× single = parallelism is bottlenecked somewhere.
    for (0..n_workers) |i| partitions[i] = rule_slice;

    // ── Run lint multiple times to measure warm steady-state ─────────────
    const ITERS = 20;
    var times_ms: [ITERS]f64 = undefined;
    var total_diags: u32 = 0;
    var iter: usize = 0;
    while (iter < ITERS) : (iter += 1) {
        const t0 = nanosNow();
        total_diags = try pool.lintParallel(ast_bytes, source, partitions, source_path);
        times_ms[iter] = msSince(t0);
    }

    std.debug.print("\n[main] lint timings (n_workers={d}, only worker 0 has rules):\n", .{n_workers});
    for (times_ms, 0..) |t, i| {
        std.debug.print("  iter {d:>2}: {d:>6.1}ms  worker0_lint={d:.1}ms\n", .{ i, t, pool.workers[0].last_lint_ms });
    }
    std.debug.print("[main] diags found: {d}\n", .{total_diags});
}
