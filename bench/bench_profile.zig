// Long-running harness for external sampling profilers (macOS `sample`,
// Linux `perf`, cross-platform `samply`).  Loops resolveFull for ~10s
// so the sampler can collect enough stacks.
//
// Usage:
//   zig build bench-profile &
//   sample $(pgrep -f bench_profile) 5 -file /tmp/ez.sample
//   wait
//   less /tmp/ez.sample
//
// Or:
//   samply record zig build bench-profile
//
// The harness prints its PID on startup so you can attach quickly.

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const scope_events = ez.scope_events;
const event_resolver = ez.event_resolver;

const WORKING_BUF_BYTES: usize = 512 * 1024 * 1024;
const FIXTURE_PATH = "bench/fixtures/typescript.js";
const ITERATIONS: u32 = 1000;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    const source = try std.Io.Dir.cwd().readFileAlloc(io, FIXTURE_PATH, gpa, .unlimited);
    defer gpa.free(source);

    std.debug.print("PID: {d}\n", .{std.c.getpid()});
    std.debug.print("Fixture: {s} ({d} bytes)\n", .{ FIXTURE_PATH, source.len });
    std.debug.print("Looping resolveFull x {d} — attach `sample $PID 10` now...\n\n", .{ITERATIONS});

    // Parse once; reuse the AST + event stream across iterations so the
    // sampler sees only resolveFull on the stack.
    var tok = try Lexer.tokenize(gpa, source);
    defer tok.deinit(gpa);
    var ev: scope_events.EventStream = .{};
    defer ev.deinit(gpa);
    var tree = try Parser.parseWithOptions(gpa, source, tok.tokens.slice(), .{
        .is_module = true,
        .events_out = &ev,
    });
    defer tree.deinit(gpa);

    const events = ev.items();
    std.debug.print("Events: {d}\n", .{events.len});

    // Count events by kind so we can see what dominates the stream.
    {
        const EventKind = scope_events.EventKind;
        var counts = [_]u32{0} ** (@typeInfo(EventKind).@"enum".fields.len);
        for (events) |e| counts[@intFromEnum(e.kind)] += 1;
        std.debug.print("Event breakdown:\n", .{});
        inline for (@typeInfo(EventKind).@"enum".fields) |f| {
            const n = counts[f.value];
            if (n > 0) std.debug.print("  {s: <24} {d:>7}  ({d:.1}%)\n", .{ f.name, n, @as(f64, @floatFromInt(n)) * 100.0 / @as(f64, @floatFromInt(events.len)) });
        }
        std.debug.print("\n", .{});
    }

    var total_ns: u64 = 0;
    for (0..ITERATIONS) |iter| {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        const t0 = std.Io.Timestamp.now(io, .boot);
        var res = try event_resolver.resolveFull(fba.allocator(), &tree, events, .{});
        const t1 = std.Io.Timestamp.now(io, .boot);
        total_ns += @intCast(t0.durationTo(t1).nanoseconds);
        res.deinit(fba.allocator());

        if (iter % 100 == 99) {
            std.debug.print("  iter {d}/{d}, avg {d} us\n", .{ iter + 1, ITERATIONS, (total_ns / (iter + 1)) / 1000 });
        }
    }
    std.debug.print("\nmean resolveFull: {d} us\n", .{(total_ns / ITERATIONS) / 1000});
}
