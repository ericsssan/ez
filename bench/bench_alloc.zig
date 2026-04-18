// Counting-allocator bench.  Wraps a GPA and tallies alloc/resize/free
// calls + peak bytes per phase.  Answers: how many reallocs happen in
// resolveFull?  What's the heuristic miss rate?  What are actual counts
// (scopes/syms/refs/events) vs predicted?

const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const scope_events = ez.scope_events;
const event_resolver = ez.event_resolver;

const Counting = struct {
    child: std.mem.Allocator,
    allocs: u64 = 0,
    resizes: u64 = 0,
    remaps: u64 = 0,
    frees: u64 = 0,
    bytes_alloc: u64 = 0,
    bytes_free: u64 = 0,
    live_peak: u64 = 0,
    live_cur: i64 = 0,
    /// Resize size buckets: <1KB, 1-64KB, 64KB-1MB, >1MB.
    resize_by_new: [4]u64 = .{0, 0, 0, 0},
    /// Resize delta buckets (same bucketing on new_len - old_len).
    resize_grow_bytes: u64 = 0,

    pub fn reset(self: *Counting) void {
        self.allocs = 0;
        self.resizes = 0;
        self.remaps = 0;
        self.frees = 0;
        self.bytes_alloc = 0;
        self.bytes_free = 0;
        self.live_peak = 0;
        self.live_cur = 0;
        self.resize_by_new = .{0, 0, 0, 0};
        self.resize_grow_bytes = 0;
    }

    fn bucket(n: usize) usize {
        if (n < 1024) return 0;
        if (n < 64 * 1024) return 1;
        if (n < 1024 * 1024) return 2;
        return 3;
    }

    pub fn allocator(self: *Counting) std.mem.Allocator {
        return .{
            .ptr = self,
            .vtable = &.{
                .alloc = alloc,
                .resize = resize,
                .remap = remap,
                .free = free,
            },
        };
    }

    fn alloc(ctx: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
        const self: *Counting = @ptrCast(@alignCast(ctx));
        const r = self.child.rawAlloc(len, alignment, ret_addr);
        if (r != null) {
            self.allocs += 1;
            self.bytes_alloc += len;
            self.live_cur += @intCast(len);
            if (@as(u64, @intCast(self.live_cur)) > self.live_peak)
                self.live_peak = @intCast(self.live_cur);
        }
        return r;
    }

    fn resize(ctx: *anyopaque, buf: []u8, alignment: std.mem.Alignment, new_len: usize, ret_addr: usize) bool {
        const self: *Counting = @ptrCast(@alignCast(ctx));
        const ok = self.child.rawResize(buf, alignment, new_len, ret_addr);
        if (ok) {
            self.resizes += 1;
            self.resize_by_new[bucket(new_len)] += 1;
            const delta: i64 = @as(i64, @intCast(new_len)) - @as(i64, @intCast(buf.len));
            self.live_cur += delta;
            if (delta > 0) {
                self.bytes_alloc += @intCast(delta);
                self.resize_grow_bytes += @intCast(delta);
            }
            if (self.live_cur > 0 and @as(u64, @intCast(self.live_cur)) > self.live_peak)
                self.live_peak = @intCast(self.live_cur);
        }
        return ok;
    }

    fn remap(ctx: *anyopaque, buf: []u8, alignment: std.mem.Alignment, new_len: usize, ret_addr: usize) ?[*]u8 {
        const self: *Counting = @ptrCast(@alignCast(ctx));
        const r = self.child.rawRemap(buf, alignment, new_len, ret_addr);
        if (r != null) {
            self.remaps += 1;
            self.resize_by_new[bucket(new_len)] += 1;
            const delta: i64 = @as(i64, @intCast(new_len)) - @as(i64, @intCast(buf.len));
            self.live_cur += delta;
            if (delta > 0) {
                self.bytes_alloc += @intCast(delta);
                self.resize_grow_bytes += @intCast(delta);
            }
            if (self.live_cur > 0 and @as(u64, @intCast(self.live_cur)) > self.live_peak)
                self.live_peak = @intCast(self.live_cur);
        }
        return r;
    }

    fn free(ctx: *anyopaque, buf: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
        const self: *Counting = @ptrCast(@alignCast(ctx));
        self.child.rawFree(buf, alignment, ret_addr);
        self.frees += 1;
        self.bytes_free += buf.len;
        self.live_cur -= @intCast(buf.len);
    }
};

const Fixture = struct { name: []const u8, path: []const u8 };
const FIXTURES = [_]Fixture{
    .{ .name = "react-hooks",    .path = "bench/fixtures/react-hooks.js" },
    .{ .name = "react-dom",      .path = "bench/fixtures/react-dom.js" },
    .{ .name = "jquery",         .path = "bench/fixtures/jquery.js" },
    .{ .name = "lodash",         .path = "bench/fixtures/lodash.js" },
    .{ .name = "three",          .path = "bench/fixtures/three.js" },
    .{ .name = "typescript",     .path = "bench/fixtures/typescript.js" },
};

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    std.debug.print("{s: <12}  {s: >7}  {s: >6}  {s: >6}  {s: >5}  {s: >5}\n", .{
        "fixture", "evt", "pk_cfg", "pk_no", "rsz_c", "rsz_n",
    });
    std.debug.print("{s:-<12}  {s:->7}  {s:->6}  {s:->6}  {s:->5}  {s:->5}\n", .{
        "", "", "", "", "", "",
    });

    for (FIXTURES) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch |e| {
            std.debug.print("skip {s}: {}\n", .{ fx.name, e });
            continue;
        };
        defer gpa.free(source);

        // Setup: lex + parse (use GPA directly, not counted)
        var tok = try Lexer.tokenize(gpa, source);
        defer tok.deinit(gpa);
        var ev: scope_events.EventStream = .{};
        defer ev.deinit(gpa);
        var tree = try Parser.parseWithOptions(gpa, source, tok.tokens.slice(), .{
            .is_module = true,
            .events_out = &ev,
        });
        defer tree.deinit(gpa);

        var counter = Counting{ .child = gpa };
        const alloc = counter.allocator();

        counter.reset();
        var res1 = try event_resolver.resolveFull(alloc, &tree, ev.items(), .{});
        const peak_cfg = counter.live_peak;
        const rsz_cfg = counter.resizes;
        res1.deinit(alloc);

        counter.reset();
        var res2 = try event_resolver.resolveFull(alloc, &tree, ev.items(), .{ .skip_cfg = true });
        const peak_no = counter.live_peak;
        const rsz_no = counter.resizes;
        res2.deinit(alloc);

        std.debug.print("{s: <12}  {d: >7}  {d: >6}  {d: >6}  {d: >5}  {d: >5}\n", .{
            fx.name, ev.len(), peak_cfg / 1024, peak_no / 1024, rsz_cfg, rsz_no,
        });
    }
}
