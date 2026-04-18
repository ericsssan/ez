const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const js_buffer = ez.js_buffer;
const semantic_mod = ez.semantic;
const parent_builder = ez.parent_builder;

// Pre-allocated working buffer replaces per-iteration GPA allocations.
// Reset between iterations is a single pointer store — no syscalls, no page faults.
// After a few warmup iterations, all output arrays are L2-resident.
const WORKING_BUF_BYTES = 6 * 1024 * 1024; // 6 MB: plenty for lex+parse+traversal+semantic

const WARMUP: u32 = 50;
const ITERATIONS: u32 = 1000;

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const file_path = "/tmp/bench_input.js";

    const source = std.Io.Dir.cwd().readFileAlloc(io, file_path, gpa, .unlimited) catch {
        std.debug.print("Could not read {s}\n", .{file_path});
        return;
    };
    defer gpa.free(source);

    // Pre-allocate working buffer once; reused across all phases and iterations.
    const working_buf = try gpa.alloc(u8, WORKING_BUF_BYTES);
    defer gpa.free(working_buf);

    // Per-iteration timings stored for min/median/mean.
    var times: [ITERATIONS]u64 = undefined;

    std.debug.print(
        "File: {s} ({d} bytes)\nWarmup: {d}, Iterations: {d}, Working buf: {d} KB\n\n",
        .{ file_path, source.len, WARMUP, ITERATIONS, WORKING_BUF_BYTES / 1024 },
    );

    // ── Phase 1: Lexer ──────────────────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            tok.deinit(fba.allocator());
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            tok.deinit(fba.allocator());
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lexer only", &times, source.len);
    }

    // ── Phase 2: Lex + Parse ────────────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            tree.deinit(fba.allocator());
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            tree.deinit(fba.allocator());
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lex + Parse", &times, source.len);
    }

    // ── Phase 3: + convertSpansToUtf16 ─────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ convertSpansToUtf16", &times, source.len);
    }

    // ── Phase 4: + computeTraversal ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch continue;
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ computeTraversal", &times, source.len);
    }

    // ── Phase 5: + SemanticAnalysis ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch continue;
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{ .build_cfg = false })) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ Sem (no CFG)", &times, source.len);
    }

    // ── Phase 6 (was): full semantic with CFG ──────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch continue;
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{ .build_cfg = false })) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = parent_builder.computeTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ Sem (with CFG)", &times, source.len);
    }

    // ── Phase 7: Zig-only pipeline (Lex + Parse + Semantic, no UTF16/traversal) ──
    // Real production flow when native rules are used — utf16 and the separate
    // traversal pass are only needed when handing the AST to the JS runner.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Zig-only (Lex+Parse+Sem)", &times, source.len);
    }

    // ── Phase 8: Zig-only without CFG (native Zig rule flow) ──────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{ .build_cfg = false })) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{ .build_cfg = false })) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Zig-only no-CFG", &times, source.len);
    }

    // ── Phase 9: Semantic sub-phase timings ──────────────────────────
    // Accumulate per-sub-phase time over ITERATIONS and report averages.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var acc = semantic_mod.SemanticAnalyzer.Timings{};
        var acc_cfg = semantic_mod.SemanticAnalyzer.Timings{};
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            var t: semantic_mod.SemanticAnalyzer.Timings = .{};
            if (semantic_mod.SemanticAnalyzer.analyzeWithTimings(fba.allocator(), &tree, .{ .build_cfg = false }, io, &t)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {}
        }
        var ran: u64 = 0;
        var ran_cfg: u64 = 0;
        // Reset lookup counter before the pass.
        semantic_mod.debug_resolve_lookups = 0;
        semantic_mod.debug_resolve_calls = 0;
        semantic_mod.debug_resolve_hits = 0;
        semantic_mod.debug_resolve_depth_sum = 0;

        // No-CFG pass
        for (0..ITERATIONS) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            var t: semantic_mod.SemanticAnalyzer.Timings = .{};
            if (semantic_mod.SemanticAnalyzer.analyzeWithTimings(fba.allocator(), &tree, .{ .build_cfg = false }, io, &t)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
                acc.presize_ns += t.presize_ns;
                acc.visit_ns += t.visit_ns;
                acc.resolve_unresolved_ns += t.resolve_unresolved_ns;
                acc.build_ref_ranges_ns += t.build_ref_ranges_ns;
                acc.build_scope_bindings_ns += t.build_scope_bindings_ns;
                acc.validate_exports_ns += t.validate_exports_ns;
                acc.cfg_finish_ns += t.cfg_finish_ns;
                acc.total_ns += t.total_ns;
                ran += 1;
            } else |_| {}
        }
        // With-CFG pass (separate, so each iter has fresh FBA state)
        for (0..ITERATIONS) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            var t2: semantic_mod.SemanticAnalyzer.Timings = .{};
            if (semantic_mod.SemanticAnalyzer.analyzeWithTimings(fba.allocator(), &tree, .{ .build_cfg = true }, io, &t2)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
                acc_cfg.presize_ns += t2.presize_ns;
                acc_cfg.visit_ns += t2.visit_ns;
                acc_cfg.resolve_unresolved_ns += t2.resolve_unresolved_ns;
                acc_cfg.build_ref_ranges_ns += t2.build_ref_ranges_ns;
                acc_cfg.build_scope_bindings_ns += t2.build_scope_bindings_ns;
                acc_cfg.validate_exports_ns += t2.validate_exports_ns;
                acc_cfg.cfg_finish_ns += t2.cfg_finish_ns;
                acc_cfg.total_ns += t2.total_ns;
                ran_cfg += 1;
            } else |err| {
                if (ran_cfg == 0) std.debug.print("CFG analyze failed: {any}\n", .{err});
            }
        }
        if (ran > 0) {
            const total_calls = semantic_mod.debug_resolve_calls;
            const total_lookups = semantic_mod.debug_resolve_lookups;
            const total_hits = semantic_mod.debug_resolve_hits;
            const depth_sum = semantic_mod.debug_resolve_depth_sum;
            const total_misses = total_calls - total_hits;
            const avg_lookups = @as(f64, @floatFromInt(total_lookups)) / @as(f64, @floatFromInt(total_calls));
            const avg_hit_depth = if (total_hits > 0) @as(f64, @floatFromInt(depth_sum)) / @as(f64, @floatFromInt(total_hits)) else 0.0;
            std.debug.print("\nresolveReference stats (per iter):\n", .{});
            std.debug.print("  calls:            {d}\n", .{ total_calls / ran });
            std.debug.print("  lookups:          {d}  (avg {d:.2}/call)\n", .{ total_lookups / ran, avg_lookups });
            std.debug.print("  hits:             {d}\n", .{ total_hits / ran });
            std.debug.print("  misses (global):  {d}  ({d:.1}%)\n", .{ total_misses / ran, 100.0 * @as(f64, @floatFromInt(total_misses)) / @as(f64, @floatFromInt(total_calls)) });
            std.debug.print("  avg hit depth:    {d:.2}  (0 = current scope)\n", .{ avg_hit_depth });
            std.debug.print("\n=== Semantic sub-phases (no CFG, avg of {d} iters, µs) ===\n", .{ran});
            std.debug.print("  presize:            {d:.2}\n", .{@as(f64, @floatFromInt(acc.presize_ns / ran)) / 1000.0});
            std.debug.print("  visit (main walk):  {d:.2}\n", .{@as(f64, @floatFromInt(acc.visit_ns / ran)) / 1000.0});
            std.debug.print("  resolveUnresolved:  {d:.2}\n", .{@as(f64, @floatFromInt(acc.resolve_unresolved_ns / ran)) / 1000.0});
            std.debug.print("  buildRefRanges:     {d:.2}\n", .{@as(f64, @floatFromInt(acc.build_ref_ranges_ns / ran)) / 1000.0});
            std.debug.print("  buildScopeBindings: {d:.2}\n", .{@as(f64, @floatFromInt(acc.build_scope_bindings_ns / ran)) / 1000.0});
            std.debug.print("  validateExports:    {d:.2}\n", .{@as(f64, @floatFromInt(acc.validate_exports_ns / ran)) / 1000.0});
            std.debug.print("  cfg_finish:         {d:.2}\n", .{@as(f64, @floatFromInt(acc.cfg_finish_ns / ran)) / 1000.0});
            std.debug.print("  total:              {d:.2}\n", .{@as(f64, @floatFromInt(acc.total_ns / ran)) / 1000.0});
        }
        if (ran_cfg > 0) {
            std.debug.print("\n=== Semantic sub-phases (WITH CFG, avg of {d} iters, µs) ===\n", .{ran_cfg});
            std.debug.print("  presize:            {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.presize_ns / ran_cfg)) / 1000.0});
            std.debug.print("  visit (main walk):  {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.visit_ns / ran_cfg)) / 1000.0});
            std.debug.print("  resolveUnresolved:  {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.resolve_unresolved_ns / ran_cfg)) / 1000.0});
            std.debug.print("  buildRefRanges:     {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.build_ref_ranges_ns / ran_cfg)) / 1000.0});
            std.debug.print("  buildScopeBindings: {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.build_scope_bindings_ns / ran_cfg)) / 1000.0});
            std.debug.print("  validateExports:    {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.validate_exports_ns / ran_cfg)) / 1000.0});
            std.debug.print("  cfg_finish:         {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.cfg_finish_ns / ran_cfg)) / 1000.0});
            std.debug.print("  total:              {d:.2}\n", .{@as(f64, @floatFromInt(acc_cfg.total_ns / ran_cfg)) / 1000.0});
        }
    }
}

fn printStats(label: []const u8, times: []u64, file_size: usize) void {
    // Sort for median/min; ignore zero entries (errors).
    std.mem.sort(u64, times, {}, std.sort.asc(u64));
    var count: usize = times.len;
    while (count > 0 and times[count - 1] == 0) count -= 1;
    if (count == 0) {
        std.debug.print("=== {s} === (all errors)\n\n", .{label});
        return;
    }
    const min_ns = times[0];
    const p50_ns = times[count / 2];
    var sum: u128 = 0;
    for (times[0..count]) |t| sum += t;
    const mean_ns = sum / count;

    const min_ms = @as(f64, @floatFromInt(min_ns)) / 1_000_000.0;
    const p50_ms = @as(f64, @floatFromInt(p50_ns)) / 1_000_000.0;
    const mean_ms = @as(f64, @floatFromInt(mean_ns)) / 1_000_000.0;
    const tput_mbs = @as(f64, @floatFromInt(file_size)) / @as(f64, @floatFromInt(p50_ns)) * 1_000.0;

    std.debug.print("=== {s} ===\n", .{label});
    std.debug.print("  min:    {d:.3} ms    p50: {d:.3} ms    mean: {d:.3} ms\n", .{ min_ms, p50_ms, mean_ms });
    std.debug.print("  Throughput (p50): {d:.0} MB/s\n\n", .{tput_mbs});
}
