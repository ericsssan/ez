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
extern fn JSValueMakeBoolean(ctx: JSContextRef, value: bool) JSValueRef;
extern fn JSValueMakeUndefined(ctx: JSContextRef) JSValueRef;

const JSTypedArrayType = enum(c_uint) { Int8 = 0, Int16 = 1, Int32 = 2, Uint8 = 3, Uint8Clamped = 4, Uint16 = 5, Uint32 = 6, Float32 = 7, Float64 = 8, ArrayBuffer = 9, None = 10, BigInt64 = 11, BigUint64 = 12 };
extern fn JSValueGetTypedArrayType(ctx: JSContextRef, value: JSValueRef, exception: *JSValueRef) JSTypedArrayType;
extern fn JSObjectGetTypedArrayBytesPtr(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) ?*anyopaque;
extern fn JSObjectGetTypedArrayLength(ctx: JSContextRef, object: JSObjectRef, exception: *JSValueRef) usize;

// ── libc bits for spawning sample(1) ──────────────────────────────────────
extern "c" fn system(command: [*:0]const u8) c_int;
extern "c" fn usleep(usec: c_uint) c_int;

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

// ── Work queue (work-stealing) ────────────────────────────────────────────
// Single shared queue of rule "batches" (each batch is a small list of rule
// names that one ezLint call processes together). Workers atomically claim
// batches via fetch-add on `next_idx`, drain until empty.
//
// Why batches, not single rules:  ezLint(...rules) builds the visitor map
// once and walks the AST once for ALL rules in that call. Pulling one rule
// at a time would force one AST walk per pull — overhead dominates. Batches
// of ~8 amortize the walk while still giving the queue enough granules
// (64 rules ÷ 8 = 8 batches across 4 workers) for stealing to rebalance
// hot batches (no-useless-assignment, etc.).
const WorkQueue = struct {
    batches: []const []const []const u8,
    next_idx: std.atomic.Value(u32) = .init(0),

    fn pull(self: *WorkQueue) ?[]const []const u8 {
        const idx = self.next_idx.fetchAdd(1, .acq_rel);
        if (idx >= self.batches.len) return null;
        return self.batches[idx];
    }

    fn reset(self: *WorkQueue) void {
        self.next_idx.store(0, .release);
    }
};

// ── Per-worker state ──────────────────────────────────────────────────────
const Job = struct {
    ast_buf: []u8, // shared, read-only after parse
    source: []const u8,
    filename: []const u8,
    queue: *WorkQueue, // shared — workers race to drain
    profile: bool = false,
};

const RuleProfile = struct {
    name: []const u8,
    ms: f64,
    diags: u32,
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
    batches_done: u32 = 0, // how many batches this worker drained last run
    // Per-worker result buffer (Zig-side copy of diag triples).
    result: std.ArrayList(u32) = .empty,
    // Per-rule profile data (filled only when job.profile=true)
    profile_data: std.ArrayList(RuleProfile) = .empty,
    // Worker-0 only: extracted from JS `__ezGetRecommended()` at init time.
    // Pool exposes this so main() doesn't have to duplicate the rule list.
    recommended_rules: ?[][]u8 = null,
    init_done: std.atomic.Value(u32) = .init(0), // 0=in-progress, 1=ok, 2=err
    init_err: ?anyerror = null,
    // Shared (passed in once at spawn)
    polyfills: []const u8,
    bundle: []const u8, // runner-iife.js (ezLint + 65 rules baked in)
    tag_names: []const [*:0]const u8,
    alloc: std.mem.Allocator,

    fn run(self: *Worker) void {
        self.run_impl() catch |err| {
            self.init_err = err;
            self.init_done.store(2, .release);
        };
    }

    fn run_impl(self: *Worker) !void {
        // Name this thread so macOS sample(1) attributes its samples to a
        // human-readable label (e.g. "ez-worker-3"). Visible in the sample
        // output's per-thread headers, lets us filter post-hoc.
        var name_buf: [32]u8 = undefined;
        const name = std.fmt.bufPrintZ(&name_buf, "ez-worker-{d}", .{self.id}) catch unreachable;
        _ = std.c.pthread_setname_np(name.ptr);

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
        // Load runner bundle (rules are bundled directly inside).
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

        // Worker 0: probe the bundle and extract the eslint:recommended rule
        // list. Done once on this worker's thread because JSC contexts are
        // thread-affine; main thread reads via pool.workers[0].recommended_rules
        // AFTER init_done.
        if (self.id == 0) {
            const probe = JSStringCreateWithUTF8CString("JSON.stringify(globalThis.__ezBundleInfo)");
            defer JSStringRelease(probe);
            const probe_r = JSEvaluateScript(ctx, probe, null, null, 0, &ex);
            if (ex == null) {
                const s = JSValueToStringCopy(ctx, probe_r, &ex);
                if (s != null) {
                    const max = JSStringGetMaximumUTF8CStringSize(s);
                    const buf = try self.alloc.alloc(u8, max);
                    defer self.alloc.free(buf);
                    const wr = JSStringGetUTF8CString(s, buf.ptr, max);
                    std.debug.print("[worker 0] bundle info: {s}\n", .{buf[0 .. @min(wr, max) -| 1]});
                    JSStringRelease(s);
                }
            }
            self.recommended_rules = try fetchRecommendedRules(ctx, self.alloc);
        }

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

        // Source / filename / profile — built once, reused for every batch.
        const src_zbuf = try self.alloc.allocSentinel(u8, job.source.len, 0);
        defer self.alloc.free(src_zbuf);
        @memcpy(src_zbuf[0..job.source.len], job.source);
        const src_jstr = JSStringCreateWithUTF8CString(src_zbuf.ptr);
        defer JSStringRelease(src_jstr);
        const src_val = JSValueMakeString(ctx, src_jstr);

        const fn_zbuf = try self.alloc.allocSentinel(u8, job.filename.len, 0);
        defer self.alloc.free(fn_zbuf);
        @memcpy(fn_zbuf[0..job.filename.len], job.filename);
        const fn_jstr = JSStringCreateWithUTF8CString(fn_zbuf.ptr);
        defer JSStringRelease(fn_jstr);
        const fn_val = JSValueMakeString(ctx, fn_jstr);

        const profile_val = if (job.profile) JSValueMakeBoolean(ctx, true) else JSValueMakeUndefined(ctx);

        self.result.clearRetainingCapacity();
        self.diags_count = 0;
        self.batches_done = 0;
        if (job.profile) self.profile_data.clearRetainingCapacity();

        // Work-stealing loop: pull batches until the queue is drained. Every
        // batch is one ezLint call (one visitor-map build + one AST walk over
        // the AST for ALL rules in that batch).
        while (job.queue.pull()) |rule_names| {
            try self.runBatch(ctx, ast_buf_val, src_val, fn_val, profile_val, rule_names, job.profile);
            self.batches_done += 1;
        }

        // Single GC at end of this worker's contribution — per-batch GC across
        // N contexts simultaneously destroyed parallelism in earlier testing.
        if (std.c.getenv("EZ_NO_GC") == null) JSGarbageCollect(ctx);

        self.last_lint_ms = msSince(t0);
    }

    fn runBatch(
        self: *Worker,
        ctx: JSGlobalContextRef,
        ast_buf_val: JSValueRef,
        src_val: JSValueRef,
        fn_val: JSValueRef,
        profile_val: JSValueRef,
        rule_names: []const []const u8,
        want_profile: bool,
    ) !void {
        var ex: JSValueRef = null;

        // Rule names array — fresh per batch.
        var rule_strs = try self.alloc.alloc(JSStringRef, rule_names.len);
        defer self.alloc.free(rule_strs);
        var rule_vals = try self.alloc.alloc(JSValueRef, rule_names.len);
        defer self.alloc.free(rule_vals);
        for (rule_names, 0..) |name, i| {
            const z = try self.alloc.allocSentinel(u8, name.len, 0);
            defer self.alloc.free(z);
            @memcpy(z[0..name.len], name);
            rule_strs[i] = JSStringCreateWithUTF8CString(z.ptr);
            rule_vals[i] = JSValueMakeString(ctx, rule_strs[i]);
        }
        defer for (rule_strs) |s| JSStringRelease(s);
        const rules_arr = JSObjectMakeArray(ctx, rule_vals.len, rule_vals.ptr, &ex);
        if (ex != null) return error.JsException;

        var args = [_]JSValueRef{ ast_buf_val, src_val, rules_arr, fn_val, profile_val };
        const result = JSObjectCallAsFunction(ctx, self.ez_lint, null, args.len, &args, &ex);
        if (ex != null) return error.JsException;

        const ta_type = JSValueGetTypedArrayType(ctx, result, &ex);
        if (ex != null or ta_type != .Uint32) return error.BadResult;
        const elem_count = JSObjectGetTypedArrayLength(ctx, result, &ex);
        if (ex != null) return error.JsException;
        self.diags_count += @as(u32, @intCast(elem_count / 3));

        // Capture the actual diag triples so `--dump-locs` mode can print them.
        const bytes_ptr = JSObjectGetTypedArrayBytesPtr(ctx, result, &ex);
        if (ex == null and bytes_ptr != null and elem_count > 0) {
            const u32s: [*]const u32 = @ptrCast(@alignCast(bytes_ptr));
            try self.result.appendSlice(self.alloc, u32s[0..elem_count]);
        }

        // Profile readback: appends to self.profile_data (don't clear).
        if (want_profile) try self.readBackProfile();
    }

    fn readBackProfile(self: *Worker) !void {
        const ctx = self.ctx;
        const global = JSContextGetGlobalObject(ctx);
        var ex: JSValueRef = null;

        const prof_name = JSStringCreateWithUTF8CString("__ezProfile");
        defer JSStringRelease(prof_name);
        const prof_val = JSObjectGetProperty(ctx, global, prof_name, &ex);
        if (ex != null or JSValueIsUndefined(ctx, prof_val)) return;

        const ta_type = JSValueGetTypedArrayType(ctx, prof_val, &ex);
        if (ex != null or ta_type != .Float64) return;
        const bytes_ptr = JSObjectGetTypedArrayBytesPtr(ctx, prof_val, &ex);
        if (ex != null) return;
        const elem_count = JSObjectGetTypedArrayLength(ctx, prof_val, &ex);
        if (ex != null) return;
        const f64s: [*]const f64 = @ptrCast(@alignCast(bytes_ptr));

        // Read diag-count array (__ezProfileDiags Uint32Array, same length).
        const diags_name = JSStringCreateWithUTF8CString("__ezProfileDiags");
        defer JSStringRelease(diags_name);
        const diags_val = JSObjectGetProperty(ctx, global, diags_name, &ex);
        var diag_ptr: ?[*]const u32 = null;
        if (ex == null and !JSValueIsUndefined(ctx, diags_val)) {
            const dta_type = JSValueGetTypedArrayType(ctx, diags_val, &ex);
            if (ex == null and dta_type == .Uint32) {
                const dbytes = JSObjectGetTypedArrayBytesPtr(ctx, diags_val, &ex);
                if (ex == null) diag_ptr = @ptrCast(@alignCast(dbytes));
            }
        }
        ex = null;

        // Read rule-name array (globalThis.__ezProfileRules) as a JS Array.
        // We just pull the .length and indexed entries.
        const names_name = JSStringCreateWithUTF8CString("__ezProfileRules");
        defer JSStringRelease(names_name);
        const names_arr = JSObjectGetProperty(ctx, global, names_name, &ex);
        if (ex != null) return;
        // Read names by element index via string-key lookup (simpler than
        // JSValueProtect/etc.). For each i in 0..elem_count, get [i] property.
        for (0..elem_count) |i| {
            var idx_buf: [16]u8 = undefined;
            const idx_str = std.fmt.bufPrintZ(&idx_buf, "{d}", .{i}) catch return;
            const idx_jstr = JSStringCreateWithUTF8CString(idx_str.ptr);
            defer JSStringRelease(idx_jstr);
            const name_val = JSObjectGetProperty(ctx, names_arr, idx_jstr, &ex);
            if (ex != null) return;
            const name_str = JSValueToStringCopy(ctx, name_val, &ex);
            if (ex != null) return;
            defer JSStringRelease(name_str);
            const max = JSStringGetMaximumUTF8CStringSize(name_str);
            const name_buf = try self.alloc.alloc(u8, max);
            const written = JSStringGetUTF8CString(name_str, name_buf.ptr, max);
            try self.profile_data.append(self.alloc, .{
                .name = name_buf[0 .. @min(written, max) -| 1],
                .ms = f64s[i],
                .diags = if (diag_ptr) |p| p[i] else 0,
            });
        }
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
        // Print the exception message for debugging.
        var ex2: JSValueRef = null;
        const ex_str = JSValueToStringCopy(ctx, ex, &ex2);
        if (ex_str != null) {
            const max = JSStringGetMaximumUTF8CStringSize(ex_str);
            const buf = std.heap.page_allocator.alloc(u8, max) catch {
                std.debug.print("[worker] eval exception in {s} (oom)\n", .{source_url});
                return error.JsException;
            };
            defer std.heap.page_allocator.free(buf);
            const written = JSStringGetUTF8CString(ex_str, buf.ptr, max);
            const slice = buf[0 .. @min(written, max) -| 1];
            std.debug.print("[worker] eval exception in {s}: {s}\n", .{ source_url, slice });
            JSStringRelease(ex_str);
        } else {
            std.debug.print("[worker] eval exception in {s} (no message)\n", .{source_url});
        }
        return error.JsException;
    }
}

// Query `globalThis.__ezGetRecommended()` and copy the JS string array into
// a Zig-owned `[][]u8`. Each slice is heap-allocated; caller frees both the
// outer array and each inner string.
//
// We extract on the WORKER's thread (JSC contexts are thread-affine) so the
// list is owned by the caller's allocator but the JSC calls happen on the
// right thread. Done once at init.
fn fetchRecommendedRules(ctx: JSContextRef, alloc: std.mem.Allocator) ![][]u8 {
    // Eval as comma-joined string — robust against escapes since rule names
    // are only [a-z0-9-]. Avoids walking the JS Array element-by-element.
    const probe = JSStringCreateWithUTF8CString("__ezGetRecommended().join(',')");
    defer JSStringRelease(probe);
    var ex: JSValueRef = null;
    const r = JSEvaluateScript(ctx, probe, null, null, 0, &ex);
    if (ex != null) return error.JsException;

    const r_str = JSValueToStringCopy(ctx, r, &ex);
    if (ex != null or r_str == null) return error.JsException;
    defer JSStringRelease(r_str);
    const max = JSStringGetMaximumUTF8CStringSize(r_str);
    const buf = try alloc.alloc(u8, max);
    defer alloc.free(buf);
    const written = JSStringGetUTF8CString(r_str, buf.ptr, max);
    const joined = buf[0 .. @min(written, max) -| 1];

    // Split by comma into owned slices.
    var count: usize = 1;
    for (joined) |c| {
        if (c == ',') count += 1;
    }
    const out = try alloc.alloc([]u8, count);
    var idx: usize = 0;
    var start: usize = 0;
    for (joined, 0..) |c, i| {
        if (c == ',') {
            const piece = joined[start..i];
            out[idx] = try alloc.alloc(u8, piece.len);
            @memcpy(out[idx], piece);
            idx += 1;
            start = i + 1;
        }
    }
    const last = joined[start..];
    out[idx] = try alloc.alloc(u8, last.len);
    @memcpy(out[idx], last);
    return out;
}

// Chunk a flat rule list into batches of `batch_size`. Returns slices INTO
// the input list — caller must keep `rules` alive for the queue's lifetime.
fn chunkRules(alloc: std.mem.Allocator, rules: []const []const u8, batch_size: u32) ![][]const []const u8 {
    if (batch_size == 0) return error.BadBatchSize;
    const n_chunks = (rules.len + batch_size - 1) / batch_size;
    const out = try alloc.alloc([]const []const u8, n_chunks);
    var i: usize = 0;
    var c: usize = 0;
    while (i < rules.len) {
        const end = @min(i + batch_size, rules.len);
        out[c] = rules[i..end];
        i = end;
        c += 1;
    }
    return out;
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
            w.profile_data.deinit(self.alloc);
            if (w.recommended_rules) |rules| {
                for (rules) |s| self.alloc.free(s);
                self.alloc.free(rules);
            }
        }
        self.alloc.free(self.workers);
    }

    /// Lint a single file by dispatching the shared work queue to all workers.
    /// `queue` is reset before dispatch; workers race to drain it.
    fn lintQueue(
        self: *Pool,
        ast_buf: []u8,
        source: []const u8,
        queue: *WorkQueue,
        filename: []const u8,
        want_profile: bool,
    ) !u32 {
        queue.reset();
        for (self.workers) |*w| {
            w.job = .{
                .ast_buf = ast_buf,
                .source = source,
                .filename = filename,
                .queue = queue,
                .profile = want_profile,
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

    // Parse args: positional source path, optional N, optional flags
    var source_path: ?[]const u8 = null;
    var n_workers: u32 = 4;
    var profile = false; // per-rule JS-side timing
    var sample_cpu = false; // macOS sample(1) CPU profiling
    var recommended = false; // run all eslint:recommended rules
    var sample_secs: u32 = 5;
    // 0 = auto: pick ceil(num_rules / n_workers) for minimum overhead.
    // Larger = fewer ezLint calls (lower setup cost), worse rebalancing.
    // Smaller = more granular stealing, but per-batch setup dominates.
    var batch_size_arg: u32 = 0;
    var positional: u32 = 0;
    for (args[1..]) |a| {
        if (std.mem.eql(u8, a, "--profile")) {
            profile = true;
        } else if (std.mem.eql(u8, a, "--sample")) {
            sample_cpu = true;
        } else if (std.mem.eql(u8, a, "--recommended")) {
            recommended = true;
        } else if (std.mem.startsWith(u8, a, "--sample-secs=")) {
            sample_secs = std.fmt.parseInt(u32, a["--sample-secs=".len..], 10) catch 5;
            sample_cpu = true;
        } else if (std.mem.startsWith(u8, a, "--batch-size=")) {
            batch_size_arg = std.fmt.parseInt(u32, a["--batch-size=".len..], 10) catch 0;
        } else if (positional == 0) {
            source_path = a;
            positional += 1;
        } else if (positional == 1) {
            n_workers = std.fmt.parseInt(u32, a, 10) catch 4;
            positional += 1;
        }
    }
    if (source_path == null) {
        std.debug.print("usage: jsc-lint-pool <source_path> [n_workers=4] [--profile] [--sample] [--sample-secs=N] [--recommended]\n", .{});
        return;
    }
    const src_path = source_path.?;
    std.debug.print("[main] n_workers={d} profile={any} sample_cpu={any} recommended={any}\n", .{ n_workers, profile, sample_cpu, recommended });

    // ── Load polyfills + runner bundle, patch the runner bundle once ─────
    const t_bundle = nanosNow();
    const polyfills = try Io.Dir.cwd().readFileAlloc(io, "src/jsc/polyfills.js", alloc, Io.Limit.limited(1024 * 1024));
    defer alloc.free(polyfills);
    const bundle_raw = try Io.Dir.cwd().readFileAlloc(io, "src/jsc/runner-iife.js", alloc, Io.Limit.limited(50 * 1024 * 1024));
    defer alloc.free(bundle_raw);
    const bundle = try patchBundleStubs(alloc, bundle_raw);
    defer alloc.free(bundle);
    std.debug.print("[main] runner bundle ready ({d:.1}MB) in {d:.1}ms\n", .{
        @as(f64, @floatFromInt(bundle.len)) / (1024.0 * 1024.0),
        msSince(t_bundle),
    });

    // ── Parse source ─────────────────────────────────────────────────────
    const source = try Io.Dir.cwd().readFileAlloc(io, src_path, alloc, Io.Limit.limited(64 * 1024 * 1024));
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
    std.debug.print("[main] parsed {s} ({d:.1}MB src) in {d:.1}ms\n", .{ src_path, @as(f64, @floatFromInt(source.len)) / (1024.0 * 1024.0), msSince(t_parse) });

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

    // ── Build the work queue ─────────────────────────────────────────────
    // Workers race to claim rule batches atomically; whoever finishes first
    // steals the next batch. Tail latency is bounded by the slowest single
    // BATCH (not the slowest worker's static assignment).
    var rules_storage = try alloc.alloc([]const u8, 0);
    defer alloc.free(rules_storage);
    // Support --rule=NAME for isolating a single rule (diagnostic / bisecting).
    var single_rule_name: ?[]const u8 = null;
    for (args[1..]) |a| {
        if (std.mem.startsWith(u8, a, "--rule=")) single_rule_name = a["--rule=".len..];
    }
    if (single_rule_name) |name| {
        alloc.free(rules_storage);
        rules_storage = try alloc.alloc([]const u8, 1);
        rules_storage[0] = name;
    } else if (recommended) {
        // Extracted by worker 0 from the JS side at init.
        const rec = pool.workers[0].recommended_rules orelse return error.NoRecommendedRules;
        alloc.free(rules_storage);
        rules_storage = try alloc.alloc([]const u8, rec.len);
        for (rec, 0..) |s, i| rules_storage[i] = s;
    } else {
        alloc.free(rules_storage);
        rules_storage = try alloc.alloc([]const u8, 1);
        rules_storage[0] = "no-debugger";
    }

    // Batch size choice (in tension):
    //   - Larger batches → fewer ezLint calls → lower per-call setup overhead
    //     (each call rebuilds the visitor map across its rule set)
    //   - Smaller batches → more queue granules → better stealing / load balance
    // Auto default: ceil(num_rules / n_workers) so each worker makes ≈1 call.
    // Stealing only kicks in on imbalance; tail latency is the slowest batch.
    const batch_size: u32 = if (batch_size_arg != 0) batch_size_arg else blk: {
        const n: u32 = @intCast(rules_storage.len);
        break :blk (n + n_workers - 1) / n_workers;
    };
    const batches = try chunkRules(alloc, rules_storage, batch_size);
    defer alloc.free(batches);
    std.debug.print("[main] queue: {d} rules in {d} batches (size {d})\n", .{ rules_storage.len, batches.len, batch_size });

    var queue: WorkQueue = .{ .batches = batches };

    // ── Optionally spawn macOS sample(1) for CPU profiling ───────────────
    // Strategy: fork sample(1) in the background BEFORE the iter loop, sample
    // window covers steady-state warm runs. Worker threads are pthread-named
    // "ez-worker-N" so the output's per-thread breakdown is filterable.
    var sample_path_buf: [128]u8 = undefined;
    var sample_path: []const u8 = "";
    if (sample_cpu) {
        const pid = std.c.getpid();
        sample_path = try std.fmt.bufPrint(&sample_path_buf, "/tmp/ez-prof-{d}.txt", .{pid});
        var cmd_buf: [512]u8 = undefined;
        // Background the sample command (`&`) so it runs concurrently with our
        // workload. Sample exits after `sample_secs` on its own and writes the
        // report file. Redirect to /dev/null so its progress chatter doesn't
        // pollute our stdout. The trailing wait is on us.
        const cmd = try std.fmt.bufPrintZ(
            &cmd_buf,
            "sample {d} {d} -file {s} > /dev/null 2>&1 &",
            .{ pid, sample_secs, sample_path },
        );
        std.debug.print("[main] launching: sample {d} {d}s → {s}\n", .{ pid, sample_secs, sample_path });
        const rc = system(cmd.ptr);
        if (rc != 0) std.debug.print("[main] WARN: system(sample) returned {d}\n", .{rc});
    }

    // ── Run lint multiple times to measure warm steady-state ─────────────
    // If sampling, run enough iters to (a) keep the sampled threads busy and
    // (b) fill the sample window. Each lint iter is ~30ms with JIT + no-debugger;
    // recommended preset is much heavier. Iter count is a rough estimate.
    const iters: usize = if (sample_cpu) 400 else if (profile or recommended) 5 else 20;
    var times_ms = try alloc.alloc(f64, iters);
    defer alloc.free(times_ms);
    var total_diags: u32 = 0;
    const t_loop = nanosNow();
    var iter: usize = 0;
    while (iter < iters) : (iter += 1) {
        // Profile only the first iter — readback is slow.
        const want_profile = profile and iter == 0;
        const t0 = nanosNow();
        total_diags = try pool.lintQueue(ast_bytes, source, &queue, src_path, want_profile);
        times_ms[iter] = msSince(t0);
        // If sampling, break out once the sample window is well-covered to
        // avoid hammering forever.
        if (sample_cpu and msSince(t_loop) > @as(f64, @floatFromInt(sample_secs * 1000 + 2000))) break;
    }
    const actual_iters = @min(iter, iters);

    std.debug.print("\n[main] lint timings (n_workers={d}, work-stealing):\n", .{n_workers});
    var sum: f64 = 0;
    for (times_ms[0..actual_iters], 0..) |t, i| {
        std.debug.print("  iter {d:>2}: {d:>6.1}ms\n", .{ i, t });
        sum += t;
    }
    // Per-worker breakdown from the LAST iter (steady state). Shows how the
    // queue distributed work — a balanced run has similar batches_done and
    // last_lint_ms across workers; large variance means stealing kicked in.
    std.debug.print("[main] last iter per-worker:\n", .{});
    for (pool.workers) |*w| {
        std.debug.print("  w{d}: batches={d:>2}  lint={d:>6.1}ms\n", .{ w.id, w.batches_done, w.last_lint_ms });
    }
    if (actual_iters > 0) {
        std.debug.print("[main] avg wall: {d:.1}ms  diags: {d}\n", .{ sum / @as(f64, @floatFromInt(actual_iters)), total_diags });
    }

    // ── Optional: dump diag triples for diff-debugging ──────────────────
    // `--dump-locs` prints `<line>:<col>` for every report from the LAST iter,
    // one per line, sorted. Used to diff against another path's output when
    // chasing a single-digit count mismatch.
    var dump_locs = false;
    for (args[1..]) |a| {
        if (std.mem.eql(u8, a, "--dump-locs")) dump_locs = true;
    }
    if (dump_locs) {
        const Loc = struct { line: u32, col: u32 };
        var locs: std.ArrayList(Loc) = .empty;
        defer locs.deinit(alloc);
        for (pool.workers) |*w| {
            const items = w.result.items;
            var i: usize = 0;
            while (i + 2 < items.len) : (i += 3) {
                try locs.append(alloc, .{ .line = items[i + 1], .col = items[i + 2] });
            }
        }
        std.mem.sort(Loc, locs.items, {}, struct {
            fn lt(_: void, a: Loc, b: Loc) bool {
                if (a.line != b.line) return a.line < b.line;
                return a.col < b.col;
            }
        }.lt);
        for (locs.items) |loc| std.debug.print("{d}:{d}\n", .{ loc.line, loc.col });

        // Also dump full descriptors for any (0,0) report — these are the
        // suspect false positives. Pull the in-context dump from worker 0.
        const w0 = &pool.workers[0];
        const ctx = w0.ctx;
        var ex: JSValueRef = null;
        const script = JSStringCreateWithUTF8CString(
            "(function(){const rs = globalThis.__ezLastReports || []; const bad = rs.filter(r => (r.line||r.loc?.start?.line||0)===0); return JSON.stringify(bad.map(r => ({ruleId:r.ruleId, message:r.message?.slice?.(0,80) ?? r.messageId ?? '', hasNode: !!r.node, hasLoc: !!r.loc, nodeType: r.node?.type, nodeStart: r.node?.start, nodeI: r.node?._i})));})()",
        );
        defer JSStringRelease(script);
        const r = JSEvaluateScript(ctx, script, null, null, 0, &ex);
        if (ex == null) {
            const s = JSValueToStringCopy(ctx, r, &ex);
            if (s != null) {
                const max = JSStringGetMaximumUTF8CStringSize(s);
                const buf = try alloc.alloc(u8, max);
                defer alloc.free(buf);
                const wr = JSStringGetUTF8CString(s, buf.ptr, max);
                std.debug.print("\n[loc=(0,0) reports]: {s}\n", .{buf[0 .. @min(wr, max) -| 1]});
                JSStringRelease(s);
            }
        }
    }

    // ── Per-rule profile dump (worker 0's batch only) ─────────────────────
    // With work-stealing each worker sees a different subset of rules, so
    // dump every worker's profile data merged. Sort by diag count (DESC) so
    // we can spot rules that are misfiring at a glance.
    if (profile) {
        var all_profiles: std.ArrayList(RuleProfile) = .empty;
        defer all_profiles.deinit(alloc);
        var total_profile_diags: u64 = 0;
        for (pool.workers) |*w| {
            for (w.profile_data.items) |rp| {
                try all_profiles.append(alloc, rp);
                total_profile_diags += rp.diags;
            }
        }
        if (all_profiles.items.len > 0) {
            std.debug.print("\n[profile] per-rule (all workers' batches merged):\n", .{});
            std.mem.sort(RuleProfile, all_profiles.items, {}, struct {
                fn lt(_: void, a: RuleProfile, b: RuleProfile) bool {
                    return a.diags > b.diags;
                }
            }.lt);
            std.debug.print("  {s:<40} {s:>8} {s:>10}\n", .{ "rule", "ms", "diags" });
            for (all_profiles.items) |rp| {
                std.debug.print("  {s:<40} {d:>7.2} {d:>10}\n", .{ rp.name, rp.ms, rp.diags });
            }
            std.debug.print("[profile] total diags (profile path): {d}\n", .{total_profile_diags});
        }
    }

    // ── Wait for sample(1) to finish writing the report ──────────────────
    if (sample_cpu) {
        const elapsed_ms = msSince(t_loop);
        const window_ms = @as(f64, @floatFromInt(sample_secs)) * 1000.0;
        if (elapsed_ms < window_ms + 1000.0) {
            const remaining_ms = window_ms + 1000.0 - elapsed_ms;
            std.debug.print("[main] waiting {d:.0}ms for sample(1) to finalize report…\n", .{remaining_ms});
            const usec: c_uint = @intFromFloat(remaining_ms * 1000.0);
            _ = usleep(usec);
        }
        std.debug.print("[main] sample report: {s}\n", .{sample_path});
        std.debug.print("[main] grep tip:    grep -A40 'ez-worker' {s} | head -200\n", .{sample_path});
    }
}
