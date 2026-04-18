// Empirical measurement of event stream throughput + sizing.
// Reports per-fixture: parse time, event count, predicted size, resolveFull time,
// scan-only throughput (AoS). Answers: is ensureCapacity heuristic right?
//  How much does resolveFull cost relative to parse?  Where is the bottleneck?

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const scope_events = ez.scope_events;
const event_resolver = ez.event_resolver;

const WARMUP: u32 = 30;
const ITERATIONS: u32 = 300;
const WORKING_BUF_BYTES: usize = 32 * 1024 * 1024;

const Fixture = struct {
    name: []const u8,
    path: []const u8,
};

const FIXTURES = [_]Fixture{
    .{ .name = "react-hooks",    .path = "bench/fixtures/react-hooks.js" },
    .{ .name = "react-dom",      .path = "bench/fixtures/react-dom.js" },
    .{ .name = "jquery",         .path = "bench/fixtures/jquery.js" },
    .{ .name = "lodash",         .path = "bench/fixtures/lodash.js" },
    .{ .name = "three",          .path = "bench/fixtures/three.js" },
    .{ .name = "typescript",     .path = "bench/fixtures/typescript.js" },
};

fn median(xs: []u64) u64 {
    std.mem.sort(u64, xs, {}, std.sort.asc(u64));
    return xs[xs.len / 2];
}

fn minimum(xs: []const u64) u64 {
    var m: u64 = std.math.maxInt(u64);
    for (xs) |x| if (x != 0 and x < m) { m = x; };
    return m;
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    std.debug.print("fixture               bytes  toks     evt  evt/tok  parse_us  parseNoEvt  evt_cost%  resolve_us  scan_us  total_us  MB/s\n", .{});
    std.debug.print("-------------------- ------ ----- ------- -------- --------- ----------- ---------- ---------- -------- -------- -----\n", .{});

    for (FIXTURES) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("skip {s}: {}\n", .{ fx.name, e });
            continue;
        };
        defer gpa.free(source);

        var parse_times: [ITERATIONS]u64 = undefined;
        var parse_noevt_times: [ITERATIONS]u64 = undefined;
        var resolve_times: [ITERATIONS]u64 = undefined;
        var scan_times: [ITERATIONS]u64 = undefined;
        var total_times: [ITERATIONS]u64 = undefined;

        var tok_count: u32 = 0;
        var evt_count: u32 = 0;

        // Warmup
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            for (0..WARMUP) |_| {
                fba.reset();
                var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
                var ev: scope_events.EventStream = .{};
                var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                    .is_module = true,
                    .events_out = &ev,
                }) catch continue;
                if (event_resolver.resolveFull(fba.allocator(), &tree, ev.items(), .{})) |res| {
                    var r = res;
                    r.deinit(fba.allocator());
                } else |_| {}
                tok.deinit(fba.allocator());
                tree.deinit(fba.allocator());
                ev.deinit(fba.allocator());
            }
        }

        // Parse with events
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            for (0..ITERATIONS) |iter| {
                fba.reset();
                var tok = Lexer.tokenize(fba.allocator(), source) catch { parse_times[iter] = 0; continue; };
                tok_count = @intCast(tok.tokens.len);
                const t0 = std.Io.Timestamp.now(io, .boot);
                var ev: scope_events.EventStream = .{};
                var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                    .is_module = true,
                    .events_out = &ev,
                }) catch { parse_times[iter] = 0; continue; };
                const t1 = std.Io.Timestamp.now(io, .boot);
                evt_count = @intCast(ev.len());
                parse_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
                tree.deinit(fba.allocator());
                ev.deinit(fba.allocator());
                tok.deinit(fba.allocator());
            }
        }

        // Parse without events
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            for (0..ITERATIONS) |iter| {
                fba.reset();
                var tok = Lexer.tokenize(fba.allocator(), source) catch { parse_noevt_times[iter] = 0; continue; };
                const t0 = std.Io.Timestamp.now(io, .boot);
                var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch { parse_noevt_times[iter] = 0; continue; };
                const t1 = std.Io.Timestamp.now(io, .boot);
                parse_noevt_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
                tree.deinit(fba.allocator());
                tok.deinit(fba.allocator());
            }
        }

        // resolveFull only (time just the resolve step)
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            for (0..ITERATIONS) |iter| {
                fba.reset();
                var tok = Lexer.tokenize(fba.allocator(), source) catch { resolve_times[iter] = 0; continue; };
                var ev: scope_events.EventStream = .{};
                var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                    .is_module = true,
                    .events_out = &ev,
                }) catch { resolve_times[iter] = 0; continue; };
                const t0 = std.Io.Timestamp.now(io, .boot);
                if (event_resolver.resolveFull(fba.allocator(), &tree, ev.items(), .{})) |res| {
                    const t1 = std.Io.Timestamp.now(io, .boot);
                    resolve_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
                    var r = res;
                    r.deinit(fba.allocator());
                } else |_| { resolve_times[iter] = 0; }
                tree.deinit(fba.allocator());
                ev.deinit(fba.allocator());
                tok.deinit(fba.allocator());
            }
        }

        // Scan-only: iterate events, tally kinds.  Measures raw AoS scan speed.
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            var tok = try Lexer.tokenize(fba.allocator(), source);
            var ev: scope_events.EventStream = .{};
            var tree = try Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            });
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            defer tok.deinit(fba.allocator());
            const items = ev.items();

            for (0..WARMUP) |_| {
                var c: u64 = 0;
                for (items) |e| { c +%= @intFromEnum(e.kind); }
                std.mem.doNotOptimizeAway(c);
            }
            for (0..ITERATIONS) |iter| {
                const t0 = std.Io.Timestamp.now(io, .boot);
                var c: u64 = 0;
                for (items) |e| { c +%= @intFromEnum(e.kind); }
                std.mem.doNotOptimizeAway(c);
                const t1 = std.Io.Timestamp.now(io, .boot);
                scan_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
            }
        }

        // Full pipeline: lex+parse+resolveFull
        {
            var fba = std.heap.FixedBufferAllocator.init(working_buf);
            for (0..ITERATIONS) |iter| {
                fba.reset();
                const t0 = std.Io.Timestamp.now(io, .boot);
                var tok = Lexer.tokenize(fba.allocator(), source) catch { total_times[iter] = 0; continue; };
                var ev: scope_events.EventStream = .{};
                var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                    .is_module = true,
                    .events_out = &ev,
                }) catch { total_times[iter] = 0; continue; };
                if (event_resolver.resolveFull(fba.allocator(), &tree, ev.items(), .{})) |res| {
                    var r = res;
                    r.deinit(fba.allocator());
                } else |_| {}
                const t1 = std.Io.Timestamp.now(io, .boot);
                total_times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
                tree.deinit(fba.allocator());
                ev.deinit(fba.allocator());
                tok.deinit(fba.allocator());
            }
        }

        const parse_med = minimum(&parse_times);
        const parse_noevt_med = minimum(&parse_noevt_times);
        const resolve_med = minimum(&resolve_times);
        const scan_med = minimum(&scan_times);
        const total_med = minimum(&total_times);

        const evt_per_tok_x100: u32 = if (tok_count > 0) (evt_count * 100) / tok_count else 0;
        const evt_cost_pct: i32 = if (parse_noevt_med > 0)
            @intCast(@divTrunc((@as(i64, @intCast(parse_med)) - @as(i64, @intCast(parse_noevt_med))) * 100, @as(i64, @intCast(parse_noevt_med))))
        else 0;

        const mb_per_s: u64 = if (total_med > 0) (source.len * 1000) / total_med else 0;

        std.debug.print("{s: <20} {d:>6} {d:>5} {d:>7}  {d: >3}.{d:0>2}   {d:>7}  {d:>10}  {d:>9}%  {d:>9}  {d:>7}  {d:>7}   {d:>3}\n", .{
            fx.name, source.len, tok_count, evt_count,
            evt_per_tok_x100 / 100, evt_per_tok_x100 % 100,
            parse_med / 1000, parse_noevt_med / 1000,
            evt_cost_pct,
            resolve_med / 1000, scan_med / 1000, total_med / 1000,
            mb_per_s,
        });
    }
}
