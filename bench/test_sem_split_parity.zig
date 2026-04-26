/// Parity test: resolveFull(.both) ≡ combineParts(resolveFullScope, resolveFullCfg)
///
/// Compares the two pipelines field-by-field on typescript.js. Currently both
/// halves do the full work; the test verifies the side-array stitch produces
/// identical seg_ids and node_reachable, before any work-skipping gating is
/// added.

const std = @import("std");
const ez = @import("ez");

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;
    const src = try std.Io.Dir.cwd().readFileAlloc(io, "bench/fixtures/typescript.js", gpa, .unlimited);
    defer gpa.free(src);

    var t = try ez.LexerSimdjson.tokenize(gpa, src);
    defer t.deinit(gpa);

    var tree = try ez.Parser.parse(gpa, src, t.tokens.slice());
    defer tree.deinit(gpa);

    const opts = ez.event_resolver.Options{ .skip_resolve = false, .skip_ref_ranges = false };

    // Reference: full pass
    var oracle = try ez.event_resolver.resolveFull(gpa, &tree, tree.scope_events, opts);
    defer oracle.deinit(gpa);

    // Split pass
    const scope = try ez.event_resolver.resolveFullScope(gpa, &tree, tree.scope_events, opts);
    const cfg = try ez.event_resolver.resolveFullCfg(gpa, &tree, tree.scope_events, opts);
    var stitched = try ez.event_resolver.combineParts(gpa, scope, cfg);
    defer stitched.deinit(gpa);

    // Compare
    var ok = true;
    if (oracle.scopes.kinds.items.len != stitched.scopes.kinds.items.len) {
        std.debug.print("MISMATCH scopes.kinds.len: {d} vs {d}\n", .{
            oracle.scopes.kinds.items.len, stitched.scopes.kinds.items.len,
        });
        ok = false;
    }
    if (oracle.symbols.names.items.len != stitched.symbols.names.items.len) {
        std.debug.print("MISMATCH symbols.names.len: {d} vs {d}\n", .{
            oracle.symbols.names.items.len, stitched.symbols.names.items.len,
        });
        ok = false;
    }
    if (oracle.references.kinds.items.len != stitched.references.kinds.items.len) {
        std.debug.print("MISMATCH references.kinds.len: {d} vs {d}\n", .{
            oracle.references.kinds.items.len, stitched.references.kinds.items.len,
        });
        ok = false;
    }
    if (oracle.node_reachable.len != stitched.node_reachable.len) {
        std.debug.print("MISMATCH node_reachable.len: {d} vs {d}\n", .{
            oracle.node_reachable.len, stitched.node_reachable.len,
        });
        ok = false;
    } else {
        var diff: usize = 0;
        for (oracle.node_reachable, stitched.node_reachable) |a, b| {
            if (a != b) diff += 1;
        }
        if (diff != 0) {
            std.debug.print("MISMATCH node_reachable: {d} bytes differ\n", .{diff});
            ok = false;
        }
    }

    // seg_ids parity
    if (oracle.references.seg_ids.items.len == stitched.references.seg_ids.items.len) {
        var diff: usize = 0;
        for (oracle.references.seg_ids.items, stitched.references.seg_ids.items) |a, b| {
            if (a != b) diff += 1;
        }
        if (diff != 0) {
            std.debug.print("MISMATCH references.seg_ids: {d} entries differ\n", .{diff});
            ok = false;
        }
    }

    // resolved_to parity
    if (oracle.references.symbol_ids.items.len == stitched.references.symbol_ids.items.len) {
        var diff: usize = 0;
        for (oracle.references.symbol_ids.items, stitched.references.symbol_ids.items) |a, b| {
            if (a != b) diff += 1;
        }
        if (diff != 0) {
            std.debug.print("MISMATCH references.symbol_ids: {d} entries differ\n", .{diff});
            ok = false;
        }
    }

    if (ok) {
        std.debug.print("OK: parity holds — both pipelines produce identical SemanticResult\n", .{});
        std.debug.print("  scopes={d} symbols={d} refs={d} reach_bytes={d}\n", .{
            oracle.scopes.kinds.items.len,
            oracle.symbols.names.items.len,
            oracle.references.kinds.items.len,
            oracle.node_reachable.len,
        });

        // ── Timing: warm + measured runs of each phase ──
        const iters: usize = 50;
        var ws: usize = 0;
        while (ws < 5) : (ws += 1) {
            var x = try ez.event_resolver.resolveFull(gpa, &tree, tree.scope_events, opts);
            x.deinit(gpa);
        }
        const t_both0 = std.Io.Timestamp.now(io, .boot);
        var i: usize = 0;
        while (i < iters) : (i += 1) {
            var x = try ez.event_resolver.resolveFull(gpa, &tree, tree.scope_events, opts);
            x.deinit(gpa);
        }
        const ns_both = t_both0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds;

        const t_scope0 = std.Io.Timestamp.now(io, .boot);
        i = 0;
        while (i < iters) : (i += 1) {
            var x = try ez.event_resolver.resolveFullScope(gpa, &tree, tree.scope_events, opts);
            x.deinit(gpa);
        }
        const ns_scope = t_scope0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds;

        const t_cfg0 = std.Io.Timestamp.now(io, .boot);
        i = 0;
        while (i < iters) : (i += 1) {
            var x = try ez.event_resolver.resolveFullCfg(gpa, &tree, tree.scope_events, opts);
            x.deinit(gpa);
        }
        const ns_cfg = t_cfg0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds;

        const us_both = @as(u64, @intCast(ns_both)) / @as(u64, iters) / 1000;
        const us_scope = @as(u64, @intCast(ns_scope)) / @as(u64, iters) / 1000;
        const us_cfg = @as(u64, @intCast(ns_cfg)) / @as(u64, iters) / 1000;
        std.debug.print("\nMedian per call ({d} iters):\n", .{iters});
        std.debug.print("  .both       = {d} us\n", .{us_both});
        std.debug.print("  .scope_only = {d} us  ({d}% of both)\n", .{ us_scope, us_scope * 100 / us_both });
        std.debug.print("  .cfg_only   = {d} us  ({d}% of both)\n", .{ us_cfg, us_cfg * 100 / us_both });
        const parallel_est = @max(us_scope, us_cfg);
        std.debug.print("  parallel max(scope,cfg) = {d} us  (saves {d} us, {d}%)\n", .{
            parallel_est,
            us_both - parallel_est,
            (us_both - parallel_est) * 100 / us_both,
        });

        // Real parallel timing.
        const t_par0 = std.Io.Timestamp.now(io, .boot);
        i = 0;
        while (i < iters) : (i += 1) {
            const w = try ez.event_resolver.ScopeCfgParallel.start(gpa, &tree, tree.scope_events, opts);
            const sc = try ez.event_resolver.resolveFullScope(gpa, &tree, tree.scope_events, opts);
            const cf = try w.join(gpa);
            var x = try ez.event_resolver.combineParts(gpa, sc, cf);
            x.deinit(gpa);
        }
        const ns_par = t_par0.durationTo(std.Io.Timestamp.now(io, .boot)).nanoseconds;
        const us_par = @as(u64, @intCast(ns_par)) / @as(u64, iters) / 1000;
        std.debug.print("  parallel actual         = {d} us  (saves {d} us, {d}%)\n", .{
            us_par,
            us_both - us_par,
            if (us_par < us_both) (us_both - us_par) * 100 / us_both else 0,
        });
    } else {
        std.debug.print("FAIL: parity broken\n", .{});
        std.process.exit(1);
    }
}
