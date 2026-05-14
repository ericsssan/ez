// ezlint — Zig host + N forked Bun processes.
//
// Architecture:
//   • Zig parses the source ONCE on the main thread.
//   • N long-lived Bun subprocesses, each running src/bun/worker.js.
//   • Each pair of pipes (host→child stdin, child→host stdout) is dedicated
//     to one worker. The host writes framed jobs, reads framed responses.
//   • Wire format: 4-byte LE length + 1 byte opcode + payload. The same
//     format the worker script uses on its end.
//   • The 8.7MB AST is published to /tmp/ez-ast-<pid>.bin once; workers
//     Bun.mmap it. No per-iter AST IPC.
//
// Why per-process (vs in-process JSC contexts): independent VMs avoid
// shared-allocator and JIT-metadata contention; each worker has its own
// GC and JIT compiler threads; no Apple JavaScriptCore.framework
// dependency; no JIT-entitlement codesign story (Bun handles JIT
// internally). Trade-off: subprocess startup is heavier (~100ms each
// in parallel) but amortized over the long-running pool.

const std = @import("std");
const Io = std.Io;

const ez = @import("ez");
const js_buffer = ez.js_buffer;
const parse_to_buffer = ez.parse_to_buffer;
const Language = ez.token.Language;
const layout = ez.layout;

// Embed the vendored Bun binary at compile time. The file lives at
// vendor/bun/bun-aarch64-darwin (committed via .gitignore stub; populated
// by `scripts/vendor-bun.sh` or `cp ~/.bun/bin/bun vendor/bun/...`). We
// access it through src/bun/bun-aarch64-darwin which is a symlink — Zig
// requires @embedFile paths to be inside the module's package, and the
// module roots at src/bun/.
const BUN_BYTES = @embedFile("./bun-aarch64-darwin");

// ── libc primitives (Zig 0.17 ships these in std.c, std.posix is too thin) ─
extern "c" fn execvp(file: [*:0]const u8, argv: [*:null]const ?[*:0]const u8) c_int;
extern "c" fn _exit(status: c_int) noreturn;
extern "c" fn waitpid(pid: i32, status: ?*c_int, options: c_int) i32;
extern "c" fn fchmod(fd: i32, mode: c_uint) c_int;
extern "c" fn getpid() i32;
extern "c" fn setenv(name: [*:0]const u8, value: [*:0]const u8, overwrite: c_int) c_int;

const STDIN_FD: i32 = 0;
const STDOUT_FD: i32 = 1;

// ── Monotonic time ────────────────────────────────────────────────────────
fn nanosNow() i128 {
    var ts: std.c.timespec = undefined;
    _ = std.c.clock_gettime(.MONOTONIC, &ts);
    return @as(i128, ts.sec) * 1_000_000_000 + @as(i128, ts.nsec);
}
fn msSince(t0: i128) f64 {
    return @as(f64, @floatFromInt(nanosNow() - t0)) / 1_000_000.0;
}

// ── Wire opcodes (must match worker.js) ───────────────────────────────────
const OP_INIT: u8 = 0x01;
const OP_LINT: u8 = 0x02;
const OP_GET_RECOMMENDED: u8 = 0x03;
const OP_SHUTDOWN: u8 = 0xFF;
const REPLY_OK: u8 = 0x00;
const REPLY_DIAGS: u8 = 0x10;
const REPLY_RULES: u8 = 0x11;
const REPLY_ERROR: u8 = 0xEE;

// ── Framed IO ─────────────────────────────────────────────────────────────
fn writeAll(fd: i32, bytes: []const u8) !void {
    var off: usize = 0;
    while (off < bytes.len) {
        const n = std.c.write(fd, bytes.ptr + off, bytes.len - off);
        if (n < 0) return error.WriteFailed;
        if (n == 0) return error.WriteShort;
        off += @intCast(n);
    }
}

fn readAll(fd: i32, buf: []u8) !void {
    var off: usize = 0;
    while (off < buf.len) {
        const n = std.c.read(fd, buf.ptr + off, buf.len - off);
        if (n < 0) return error.ReadFailed;
        if (n == 0) return error.ReadEOF;
        off += @intCast(n);
    }
}

fn writeFrame(fd: i32, opcode: u8, payload: []const u8) !void {
    var hdr: [5]u8 = undefined;
    std.mem.writeInt(u32, hdr[0..4], @intCast(payload.len), .little);
    hdr[4] = opcode;
    try writeAll(fd, &hdr);
    if (payload.len > 0) try writeAll(fd, payload);
}

const Frame = struct { opcode: u8, payload: []u8 };

fn readFrame(fd: i32, alloc: std.mem.Allocator) !Frame {
    var hdr: [5]u8 = undefined;
    try readAll(fd, &hdr);
    const len = std.mem.readInt(u32, hdr[0..4], .little);
    const opcode = hdr[4];
    const payload = try alloc.alloc(u8, len);
    if (len > 0) try readAll(fd, payload);
    return .{ .opcode = opcode, .payload = payload };
}

// ── Extract embedded Bun binary to /tmp ───────────────────────────────────
// Called once at startup. Returns the path to the extracted, executable bun.
// Path is /tmp/ez-bun-<pid> so multiple ez instances coexist; caller may
// optionally cache across invocations (mtime check) but for now we re-extract.
fn extractBun(alloc: std.mem.Allocator) ![:0]u8 {
    const pid = getpid();
    var path_buf: [128]u8 = undefined;
    const path = try std.fmt.bufPrintZ(&path_buf, "/tmp/ez-bun-{d}", .{pid});
    // Open O_WRONLY|O_CREAT|O_TRUNC mode 0o755.
    const fd = std.c.open(@ptrCast(path.ptr), .{ .ACCMODE = .WRONLY, .CREAT = true, .TRUNC = true }, @as(c_uint, 0o755));
    if (fd < 0) return error.OpenFailed;
    defer _ = std.c.close(fd);
    _ = fchmod(fd, 0o755);
    try writeAll(fd, BUN_BYTES);
    return try alloc.dupeZ(u8, path);
}

// ── Spawn a bun-worker subprocess ─────────────────────────────────────────
const SpawnResult = struct {
    pid: i32,
    fd_in: i32, // host writes here (child's stdin)
    fd_out: i32, // host reads here (child's stdout)
};

fn spawnWorker(bun_path: [:0]const u8, worker_js_path: [:0]const u8) !SpawnResult {
    var pipe_in: [2]i32 = undefined; // child's stdin
    var pipe_out: [2]i32 = undefined; // child's stdout
    if (std.c.pipe(&pipe_in) != 0) return error.PipeFailed;
    if (std.c.pipe(&pipe_out) != 0) return error.PipeFailed;

    const pid = std.c.fork();
    if (pid < 0) return error.ForkFailed;
    if (pid == 0) {
        // CHILD. Wire pipes to stdin/stdout, exec bun.
        _ = std.c.dup2(pipe_in[0], STDIN_FD);
        _ = std.c.dup2(pipe_out[1], STDOUT_FD);
        // Close all four originals — stdin/stdout are now the dup'd copies.
        _ = std.c.close(pipe_in[0]);
        _ = std.c.close(pipe_in[1]);
        _ = std.c.close(pipe_out[0]);
        _ = std.c.close(pipe_out[1]);
        // exec the worker. argv = [bun, "run", worker_js, null].
        const arg_run: [*:0]const u8 = "run";
        var argv = [_:null]?[*:0]const u8{ bun_path.ptr, arg_run, worker_js_path.ptr };
        _ = execvp(bun_path.ptr, &argv);
        // exec failed — bail without running any atexit handlers.
        _exit(127);
    }
    // PARENT. Close child-side ends of each pipe.
    _ = std.c.close(pipe_in[0]);
    _ = std.c.close(pipe_out[1]);
    return .{
        .pid = pid,
        .fd_in = pipe_in[1],
        .fd_out = pipe_out[0],
    };
}

// ── Work queue (work-stealing) ────────────────────────────────────────────
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

const STATE_IDLE: u32 = 0;
const STATE_WORK_READY: u32 = 1;
const STATE_WORK_DONE: u32 = 2;
const STATE_SHUTDOWN: u32 = 3;

const Job = struct {
    ast_buf: []const u8,
    filename: []const u8,
    queue: *WorkQueue,
    /// When non-null, workers receive the AST via Bun.mmap on this path
    /// instead of the legacy stdin-frame protocol. Eliminates 8.7MB×N of
    /// pipe traffic per iter — the mmap'd file stays in OS page cache so
    /// re-mmaps across iters are essentially free.
    ast_path: ?[:0]const u8 = null,
};

const Worker = struct {
    id: u32,
    thread: std.Thread = undefined,
    state: std.atomic.Value(u32) = .init(STATE_IDLE),
    job: ?Job = null,
    pid: i32 = 0,
    fd_in: i32 = -1,
    fd_out: i32 = -1,
    init_ms: f64 = 0,
    last_lint_ms: f64 = 0,
    diags_count: u32 = 0,
    batches_done: u32 = 0,
    init_done: std.atomic.Value(u32) = .init(0),
    init_err: ?anyerror = null,
    recommended_rules: ?[][]u8 = null, // worker-0 only
    bun_path: [:0]const u8,
    worker_js_path: [:0]const u8,
    tag_names_json: []const u8,
    alloc: std.mem.Allocator,

    fn run(self: *Worker) void {
        self.run_impl() catch |err| {
            self.init_err = err;
            self.init_done.store(2, .release);
        };
    }

    fn run_impl(self: *Worker) !void {
        var name_buf: [32]u8 = undefined;
        const name = std.fmt.bufPrintZ(&name_buf, "ez-bun-{d}", .{self.id}) catch unreachable;
        _ = std.c.pthread_setname_np(name.ptr);

        const t_init = nanosNow();

        // Spawn the child. The pid/fds are stored on the worker so main()
        // can include them in shutdown / debug output.
        const sp = try spawnWorker(self.bun_path, self.worker_js_path);
        self.pid = sp.pid;
        self.fd_in = sp.fd_in;
        self.fd_out = sp.fd_out;

        // Wait for READY (OK frame, len=0).
        const ready = try readFrame(self.fd_out, self.alloc);
        if (ready.opcode != REPLY_OK) {
            std.debug.print("[bun-worker {d}] startup error: {s}\n", .{ self.id, ready.payload });
            return error.WorkerStartupFailed;
        }
        self.alloc.free(ready.payload);

        // INIT — send tag names.
        try writeFrame(self.fd_in, OP_INIT, self.tag_names_json);
        const init_reply = try readFrame(self.fd_out, self.alloc);
        if (init_reply.opcode != REPLY_OK) return error.WorkerInitFailed;
        self.alloc.free(init_reply.payload);

        // Worker 0 fetches the recommended rule list — main() reads it back
        // after init_done. Same shape as the JSC pool.
        if (self.id == 0) {
            try writeFrame(self.fd_in, OP_GET_RECOMMENDED, "");
            const rules_reply = try readFrame(self.fd_out, self.alloc);
            if (rules_reply.opcode != REPLY_RULES) return error.WorkerRulesFailed;
            self.recommended_rules = try splitNewlines(self.alloc, rules_reply.payload);
            self.alloc.free(rules_reply.payload);
            // Print the count for debugging — parallels the JSC bundle-info probe.
            std.debug.print("[bun-worker 0] recommended rule count: {d}\n", .{self.recommended_rules.?.len});
        }

        self.init_ms = msSince(t_init);
        self.init_done.store(1, .release);

        // Work loop.
        while (true) {
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
                std.debug.print("[bun-worker {d}] job error: {}\n", .{ self.id, err });
            };
            self.state.store(STATE_WORK_DONE, .release);
        }

        // Shutdown — send SHUTDOWN opcode, then wait for child.
        writeFrame(self.fd_in, OP_SHUTDOWN, "") catch {};
        _ = std.c.close(self.fd_in);
        _ = std.c.close(self.fd_out);
        _ = waitpid(self.pid, null, 0);
    }

    fn executeJob(self: *Worker, job: Job) !void {
        const t0 = nanosNow();
        self.diags_count = 0;
        self.batches_done = 0;

        while (job.queue.pull()) |rule_names| {
            try self.runBatch(job, rule_names);
            self.batches_done += 1;
        }
        self.last_lint_ms = msSince(t0);
    }

    fn runBatch(self: *Worker, job: Job, rule_names: []const []const u8) !void {
        // Build JSON spec. Two shapes depending on AST-delivery mode:
        //   { rules:[...], filename:"...", astPath:"/tmp/..." }   (mmap mode)
        //   { rules:[...], filename:"..." }                       (frame mode)
        var spec_buf: std.ArrayList(u8) = .empty;
        defer spec_buf.deinit(self.alloc);
        try spec_buf.appendSlice(self.alloc, "{\"rules\":[");
        for (rule_names, 0..) |name, i| {
            if (i > 0) try spec_buf.append(self.alloc, ',');
            try spec_buf.append(self.alloc, '"');
            try spec_buf.appendSlice(self.alloc, name);
            try spec_buf.append(self.alloc, '"');
        }
        try spec_buf.appendSlice(self.alloc, "],\"filename\":\"");
        try spec_buf.appendSlice(self.alloc, job.filename);
        try spec_buf.append(self.alloc, '"');
        if (job.ast_path) |p| {
            try spec_buf.appendSlice(self.alloc, ",\"astPath\":\"");
            try spec_buf.appendSlice(self.alloc, p);
            try spec_buf.append(self.alloc, '"');
        }
        try spec_buf.append(self.alloc, '}');

        // Wire: LINT frame (opcode + spec JSON). When job.ast_path is null
        // we follow with a second frame containing the raw AST bytes
        // (legacy in-band delivery). When set, the worker mmaps the file —
        // no second frame needed.
        try writeFrame(self.fd_in, OP_LINT, spec_buf.items);
        if (job.ast_path == null) {
            try writeFrame(self.fd_in, OP_LINT, job.ast_buf);
        }

        // Read DIAGS reply.
        const reply = try readFrame(self.fd_out, self.alloc);
        defer self.alloc.free(reply.payload);
        if (reply.opcode == REPLY_ERROR) {
            std.debug.print("[bun-worker {d}] rule error: {s}\n", .{ self.id, reply.payload });
            return error.LintFailed;
        }
        if (reply.opcode != REPLY_DIAGS) return error.UnexpectedReply;
        self.diags_count += @intCast(reply.payload.len / 12); // 3 u32 per diag
    }
};

// Split a buffer of newline-separated strings into owned slices.
fn splitNewlines(alloc: std.mem.Allocator, src: []const u8) ![][]u8 {
    var count: usize = 1;
    for (src) |c| {
        if (c == '\n') count += 1;
    }
    const out = try alloc.alloc([]u8, count);
    var idx: usize = 0;
    var start: usize = 0;
    for (src, 0..) |c, i| {
        if (c == '\n') {
            out[idx] = try alloc.dupe(u8, src[start..i]);
            idx += 1;
            start = i + 1;
        }
    }
    out[idx] = try alloc.dupe(u8, src[start..]);
    return out;
}

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

// ── Pool ──────────────────────────────────────────────────────────────────
const Pool = struct {
    workers: []Worker,
    alloc: std.mem.Allocator,

    fn init(
        alloc: std.mem.Allocator,
        n_workers: u32,
        bun_path: [:0]const u8,
        worker_js_path: [:0]const u8,
        tag_names_json: []const u8,
    ) !Pool {
        const workers = try alloc.alloc(Worker, n_workers);
        for (workers, 0..) |*w, i| {
            w.* = .{
                .id = @intCast(i),
                .bun_path = bun_path,
                .worker_js_path = worker_js_path,
                .tag_names_json = tag_names_json,
                .alloc = alloc,
            };
            w.thread = try std.Thread.spawn(.{}, Worker.run, .{w});
        }
        for (workers) |*w| {
            while (w.init_done.load(.acquire) == 0) std.atomic.spinLoopHint();
            if (w.init_err) |e| return e;
        }
        return .{ .workers = workers, .alloc = alloc };
    }

    fn deinit(self: *Pool) void {
        for (self.workers) |*w| w.state.store(STATE_SHUTDOWN, .release);
        for (self.workers) |*w| {
            w.thread.join();
            if (w.recommended_rules) |rs| {
                for (rs) |s| self.alloc.free(s);
                self.alloc.free(rs);
            }
        }
        self.alloc.free(self.workers);
    }

    fn lintQueue(
        self: *Pool,
        ast: []const u8,
        queue: *WorkQueue,
        filename: []const u8,
        ast_path: ?[:0]const u8,
    ) !u32 {
        queue.reset();
        for (self.workers) |*w| {
            w.job = .{ .ast_buf = ast, .filename = filename, .queue = queue, .ast_path = ast_path };
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

// Publish AST bytes to a temp file so workers can Bun.mmap it — eliminates
// pipe-shipping of the AST per worker per iter. Returns the (zero-terminated)
// path; caller owns the buffer. The file path embeds our pid so multiple
// concurrent ez instances don't collide.
fn publishAstToFile(alloc: std.mem.Allocator, ast: []const u8) ![:0]u8 {
    var path_buf: [256]u8 = undefined;
    const path_z = try std.fmt.bufPrintZ(&path_buf, "/tmp/ez-ast-{d}.bin", .{getpid()});
    const fd = std.c.open(@ptrCast(path_z.ptr), .{ .ACCMODE = .WRONLY, .CREAT = true, .TRUNC = true }, @as(c_uint, 0o600));
    if (fd < 0) return error.OpenFailed;
    defer _ = std.c.close(fd);
    try writeAll(fd, ast);
    return try alloc.dupeZ(u8, path_z);
}

// ── Build tag-names JSON ──────────────────────────────────────────────────
fn buildTagNamesJson(alloc: std.mem.Allocator) ![]u8 {
    var buf: std.ArrayList(u8) = .empty;
    try buf.appendSlice(alloc, "{\"tagNames\":[");
    for (0..layout.tag_count) |i| {
        if (i > 0) try buf.append(alloc, ',');
        const name = layout.tag_names[i];
        // Each name is a [*:0]const u8 — find length.
        var len: usize = 0;
        while (name[len] != 0) len += 1;
        try buf.append(alloc, '"');
        try buf.appendSlice(alloc, name[0..len]);
        try buf.append(alloc, '"');
    }
    try buf.appendSlice(alloc, "]}");
    return buf.toOwnedSlice(alloc);
}

// ── Main ──────────────────────────────────────────────────────────────────
pub fn main(init: std.process.Init) !void {
    const alloc = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var source_path: ?[]const u8 = null;
    // Default to 2 workers — sweet spot for CI single-shot lint:
    //   1w:  908ms lint, 1.46s total (rule load not amortized at all)
    //   2w:  775ms lint, 1.29s total ← BEST
    //   4w: 1000ms lint, 1.52s total (rule-load contention dominates)
    // Worker boot ~485ms each; runs in parallel with parse + AST publish.
    var n_workers: u32 = 2;
    var recommended = false;
    var batch_size_arg: u32 = 0;
    var positional: u32 = 0;
    var trace_workers = false;
    var stats_workers = false;
    var profile_workers = false;
    var no_ast_cache = false;
    var gc_every_arg: ?[]const u8 = null;
    var iters: u32 = 1;
    for (args[1..]) |a| {
        if (std.mem.eql(u8, a, "--recommended")) {
            recommended = true;
        } else if (std.mem.startsWith(u8, a, "--batch-size=")) {
            batch_size_arg = std.fmt.parseInt(u32, a["--batch-size=".len..], 10) catch 0;
        } else if (std.mem.startsWith(u8, a, "--iters=")) {
            iters = std.fmt.parseInt(u32, a["--iters=".len..], 10) catch 1;
            if (iters == 0) iters = 1;
        } else if (std.mem.eql(u8, a, "--trace")) {
            trace_workers = true;
        } else if (std.mem.eql(u8, a, "--stats")) {
            stats_workers = true;
        } else if (std.mem.eql(u8, a, "--profile")) {
            profile_workers = true;
        } else if (std.mem.eql(u8, a, "--no-ast-cache")) {
            no_ast_cache = true;
        } else if (std.mem.startsWith(u8, a, "--gc-every=")) {
            gc_every_arg = a["--gc-every=".len..];
        } else if (positional == 0) {
            source_path = a;
            positional += 1;
        } else if (positional == 1) {
            n_workers = std.fmt.parseInt(u32, a, 10) catch 2;
            positional += 1;
        }
    }
    if (source_path == null) {
        std.debug.print(
            \\usage: ezlint <source_path> [n_workers=2] [flags]
            \\
            \\flags:
            \\  --recommended         use eslint:recommended preset (64 rules)
            \\  --batch-size=N        rules per batch (default ceil(n_rules/n_workers))
            \\  --iters=N             run lint N times (default 1; >1 for benchmarking)
            \\
            \\diagnostic flags (sets BUN_WORKER_* env on children):
            \\  --trace               per-LINT timing on stderr (read/lint/write ms)
            \\  --stats               heap + JIT compile counters at shutdown
            \\  --profile             JSC sampling profiler (~6× wall, leaf summary)
            \\
            \\tuning flags:
            \\  --no-ast-cache        disable AstView cache (strict diag-count parity)
            \\  --gc-every=N          GC every N LINT calls (default 10)
            \\
        , .{});
        return;
    }
    const src_path = source_path.?;

    // Propagate diagnostic / tuning flags to children via env. Children
    // inherit the parent's env across fork+exec, so setenv before spawning
    // is enough.
    if (trace_workers) _ = setenv("BUN_WORKER_TRACE", "1", 1);
    if (stats_workers) _ = setenv("BUN_WORKER_STATS", "1", 1);
    if (profile_workers) _ = setenv("BUN_WORKER_PROFILE", "1", 1);
    if (no_ast_cache) _ = setenv("BUN_WORKER_NO_AST_CACHE", "1", 1);
    if (gc_every_arg) |v| {
        var z: [16]u8 = undefined;
        const zs = std.fmt.bufPrintZ(&z, "{s}", .{v}) catch unreachable;
        _ = setenv("BUN_WORKER_GC_EVERY", zs.ptr, 1);
    }

    std.debug.print("[main] n_workers={d} recommended={any} trace={any} stats={any} profile={any}\n", .{
        n_workers, recommended, trace_workers, stats_workers, profile_workers,
    });

    // Extract the embedded Bun binary to /tmp.
    const t_bun = nanosNow();
    const bun_path = try extractBun(alloc);
    defer alloc.free(bun_path);
    std.debug.print("[main] extracted bun → {s} ({d:.1}MB) in {d:.1}ms\n", .{
        bun_path,
        @as(f64, @floatFromInt(BUN_BYTES.len)) / (1024.0 * 1024.0),
        msSince(t_bun),
    });

    // Path to the worker JS. Resolved against the process's cwd by the child
    // (the spawned Bun inherits our cwd). Must run ezlint from the repo
    // root for now; later we'll embed the worker JS too.
    const worker_js_path: [:0]const u8 = "src/bun/worker.js";

    // Build tag-names JSON for INIT frames. (No dependency on parse output —
    // built from a static layout constant.)
    const tag_names_json = try buildTagNamesJson(alloc);
    defer alloc.free(tag_names_json);

    // Spawn pool init in a background thread so it overlaps with parse +
    // native rules + AST publish. Worker boot is the slowest serial step
    // (~485ms cold). The OS scheduler handles the spawned children while we
    // keep parsing on the main thread.
    const t_pool_init = nanosNow();
    const PoolInitCtx = struct {
        alloc: std.mem.Allocator,
        n_workers: u32,
        bun_path: [:0]const u8,
        worker_js_path: [:0]const u8,
        tag_names_json: []const u8,
        pool: ?Pool = null,
        err: ?anyerror = null,
        done_ns: i128 = 0,
        fn run(ctx: *@This()) void {
            if (Pool.init(ctx.alloc, ctx.n_workers, ctx.bun_path, ctx.worker_js_path, ctx.tag_names_json)) |p| {
                ctx.pool = p;
            } else |e| {
                ctx.err = e;
            }
            ctx.done_ns = nanosNow();
        }
    };
    var pool_ctx: PoolInitCtx = .{
        .alloc = alloc,
        .n_workers = n_workers,
        .bun_path = bun_path,
        .worker_js_path = worker_js_path,
        .tag_names_json = tag_names_json,
    };
    const pool_thread = try std.Thread.spawn(.{}, PoolInitCtx.run, .{&pool_ctx});

    // Parse source.
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
    var native_diags: std.ArrayList(parse_to_buffer.NativeDiag) = .empty;
    _ = try parse_to_buffer.parseToBuffer(ast_bytes.ptr, total_buf_len, source_start, source_len, .js, true, &sem_arena, &native_diags);
    const native_diag_count: u32 = @intCast(native_diags.items.len);
    std.debug.print("[main] parsed {s} ({d:.1}MB src) in {d:.1}ms — {d} native diags\n", .{
        src_path,
        @as(f64, @floatFromInt(source.len)) / (1024.0 * 1024.0),
        msSince(t_parse),
        native_diag_count,
    });
    // Dump native diag locations when EZ_DUMP_NATIVE_DIAGS=1.
    if (std.c.getenv("EZ_DUMP_NATIVE_DIAGS")) |_| {
        for (native_diags.items) |nd| {
            std.debug.print("NATIVE {s}:{d}:{d} {s}\n", .{ src_path, nd.line, nd.col, nd.rule_name });
        }
    }

    // Publish the AST to /tmp. Auto-deleted on exit (defer unlink) — no
    // accumulation of orphan files in /tmp across runs. Workers Bun.mmap by
    // path; the kernel page cache keeps the bytes in RAM, so the "file" is
    // essentially a RAM-resident shared buffer for our run.
    const t_publish = nanosNow();
    const ast_path = try publishAstToFile(alloc, ast_bytes);
    defer alloc.free(ast_path);
    defer _ = std.c.unlink(@ptrCast(ast_path.ptr));
    std.debug.print("[main] published AST → {s} ({d:.1}MB) in {d:.1}ms\n", .{
        ast_path,
        @as(f64, @floatFromInt(ast_bytes.len)) / (1024.0 * 1024.0),
        msSince(t_publish),
    });

    // Wait for pool init to finish (typically already done by now).
    pool_thread.join();
    if (pool_ctx.err) |e| return e;
    var pool = pool_ctx.pool.?;
    defer pool.deinit();
    std.debug.print("[main] pool init in {d:.1}ms (per-worker: ", .{msSince(t_pool_init)});
    for (pool.workers) |*w| std.debug.print("{d:.0}ms ", .{w.init_ms});
    std.debug.print(")\n", .{});

    // Build the work queue.
    var rules_storage = try alloc.alloc([]const u8, 0);
    defer alloc.free(rules_storage);
    if (recommended) {
        const rec = pool.workers[0].recommended_rules orelse return error.NoRecommendedRules;
        alloc.free(rules_storage);
        // EZ_DUMP_JS_NUA_ONLY=1 → run only no-useless-assignment in workers
        // (so the JS rule's diag locations can be diffed against native).
        const dump_js_only = std.c.getenv("EZ_DUMP_JS_NUA_ONLY") != null;
        if (dump_js_only) {
            rules_storage = try alloc.alloc([]const u8, 1);
            rules_storage[0] = "no-useless-assignment";
        } else {
            // Drop rules that already ran natively at parse time. MUST stay
            // in sync with parse_to_buffer.NATIVE_PARSE_TIME_RULES — every
            // entry there should be in this list and vice versa, otherwise
            // we get either double-emit or missing diags.
            const NATIVE_RULES_TO_SKIP = [_][]const u8{
                "no-useless-assignment",
                "no-debugger",
                "no-with",
                "no-octal",
                "no-delete-var",
                "no-compare-neg-zero",
                "no-case-declarations",
            };
            var keep_count: usize = 0;
            for (rec) |s| {
                var skip = false;
                for (NATIVE_RULES_TO_SKIP) |n| {
                    if (std.mem.eql(u8, s, n)) { skip = true; break; }
                }
                if (!skip) keep_count += 1;
            }
            rules_storage = try alloc.alloc([]const u8, keep_count);
            var ki: usize = 0;
            for (rec) |s| {
                var skip = false;
                for (NATIVE_RULES_TO_SKIP) |n| {
                    if (std.mem.eql(u8, s, n)) { skip = true; break; }
                }
                if (skip) continue;
                rules_storage[ki] = s;
                ki += 1;
            }
        }
    } else {
        alloc.free(rules_storage);
        rules_storage = try alloc.alloc([]const u8, 1);
        rules_storage[0] = "no-debugger";
    }
    const batch_size: u32 = if (batch_size_arg != 0) batch_size_arg else blk: {
        const n: u32 = @intCast(rules_storage.len);
        break :blk (n + n_workers - 1) / n_workers;
    };
    const batches = try chunkRules(alloc, rules_storage, batch_size);
    defer alloc.free(batches);
    std.debug.print("[main] queue: {d} rules in {d} batches (size {d})\n", .{ rules_storage.len, batches.len, batch_size });

    var queue: WorkQueue = .{ .batches = batches };

    // Lint loop. Default 1 iter (real lint); set --iters=N to benchmark.
    var times_ms = try alloc.alloc(f64, iters);
    defer alloc.free(times_ms);
    var total_diags: u32 = 0;
    var iter: u32 = 0;
    while (iter < iters) : (iter += 1) {
        const t0 = nanosNow();
        total_diags = try pool.lintQueue(ast_bytes, &queue, src_path, ast_path);
        total_diags += native_diag_count;
        times_ms[iter] = msSince(t0);
    }

    if (iters == 1) {
        std.debug.print("\n[main] lint wall: {d:.1}ms  diags: {d}  (n_workers={d})\n", .{ times_ms[0], total_diags, n_workers });
        for (pool.workers) |*w| {
            std.debug.print("  w{d}: batches={d:>2}  lint={d:>6.1}ms\n", .{ w.id, w.batches_done, w.last_lint_ms });
        }
    } else {
        std.debug.print("\n[main] lint timings (n_workers={d}):\n", .{n_workers});
        var sum: f64 = 0;
        for (times_ms, 0..) |t, i| {
            std.debug.print("  iter {d:>2}: {d:>6.1}ms\n", .{ i, t });
            sum += t;
        }
        std.debug.print("[main] last iter per-worker:\n", .{});
        for (pool.workers) |*w| {
            std.debug.print("  w{d}: batches={d:>2}  lint={d:>6.1}ms\n", .{ w.id, w.batches_done, w.last_lint_ms });
        }
        std.debug.print("[main] avg wall: {d:.1}ms  diags: {d}\n", .{ sum / @as(f64, @floatFromInt(iters)), total_diags });
    }
}
