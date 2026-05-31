const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const js_buffer = ez.js_buffer;
const semantic_mod = ez.semantic;
const parent_builder = ez.parent_builder;
const traversal_builder = ez.traversal_builder;
const scope_events = ez.scope_events;
const event_resolver = ez.event_resolver;

// Pre-allocated working buffer replaces per-iteration GPA allocations.
// Reset between iterations is a single pointer store — no syscalls, no page faults.
// After a few warmup iterations, all output arrays are L2-resident.
// 256 MB: semantic on typescript.js (~9 MB source) peaks at ~240 MB total
// (lex+parse=80 MB, ArenaAllocator-backed CPB adds ~28 MB of chunk overhead on
// top of ~18 MB of actual segment/event data, plus scope/sym/ref tables).
const WORKING_BUF_BYTES = 256 * 1024 * 1024;

const WARMUP: u32 = 5;
const ITERATIONS: u32 = 100;

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

    // ── Phase 4: + buildTraversal ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch continue;
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
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("+ buildTraversal", &times, source.len);
    }

    // ── Phase 5: + SemanticAnalysis ─────────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var sem_oom_warmup: bool = false;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch continue;
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| { sem_oom_warmup = true; }
        }
        if (sem_oom_warmup) std.debug.print("[WARN] Phase 5 warmup: semantic OOM (FBA {d} MB too small)\n", .{WORKING_BUF_BYTES / (1024 * 1024)});
        var sem_oom_count: u32 = 0;
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
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {
                sem_oom_count += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom_count > 0) std.debug.print("[WARN] Phase 5: semantic OOM in {d}/{d} iterations\n", .{ sem_oom_count, ITERATIONS });
        printStats("+ Sem (no CFG)", &times, source.len);
        {
            // One-shot: measure peak FBA usage through the full pipeline.
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch unreachable;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch unreachable;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch {};
            const after_parse = fba.end_index;
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
                var sem = sem_result;
                std.debug.print("  FBA after parse: {d} MB, after sem: {d} MB (sem used {d} MB)\n", .{
                    after_parse / (1024 * 1024),
                    fba.end_index / (1024 * 1024),
                    (fba.end_index - after_parse) / (1024 * 1024),
                });
                sem.deinit(fba.allocator());
            } else |_| {
                std.debug.print("  FBA after parse: {d} MB, sem OOM at ~{d} MB\n", .{
                    after_parse / (1024 * 1024),
                    fba.end_index / (1024 * 1024),
                });
            }
        }
    }

    // ── Phase 6: + Semantic (is_module=true) ───────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var sem_oom_warmup: bool = false;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            _ = js_buffer.convertSpansToUtf16(source, tok.tokens.slice().items(.start));
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch continue;
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| { sem_oom_warmup = true; }
        }
        if (sem_oom_warmup) std.debug.print("[WARN] Phase 6 warmup: semantic OOM (FBA {d} MB too small)\n", .{WORKING_BUF_BYTES / (1024 * 1024)});
        var sem_oom_count: u32 = 0;
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
            _ = traversal_builder.buildTraversal(&tree, fba.allocator()) catch {
                times[iter] = 0;
                continue;
            };
            if (semantic_mod.SemanticAnalyzer.analyze(fba.allocator(), &tree)) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {
                sem_oom_count += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom_count > 0) std.debug.print("[WARN] Phase 6: semantic OOM in {d}/{d} iterations\n", .{ sem_oom_count, ITERATIONS });
        printStats("+ Sem (module)", &times, source.len);
    }

    // ── Phase 7: Zig-only pipeline (Lex + Parse + Semantic, no UTF16/traversal) ──
    // Real production flow when native rules are used — utf16 and the separate
    // traversal pass are only needed when handing the AST to the JS runner.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var sem_oom: u32 = 0;
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
            } else |_| {
                sem_oom += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom > 0) std.debug.print("[WARN] Phase 7: semantic OOM in {d}/{d} iterations\n", .{ sem_oom, ITERATIONS });
        printStats("Zig-only (Lex+Parse+Sem)", &times, source.len);
    }

    // ── Phase 8: Zig-only without CFG (native Zig rule flow) ──────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var sem_oom: u32 = 0;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
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
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
            } else |_| {
                sem_oom += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom > 0) std.debug.print("[WARN] Phase 8: semantic OOM in {d}/{d} iterations\n", .{ sem_oom, ITERATIONS });
        printStats("Zig-only no-CFG", &times, source.len);
    }

    // ── Phase 9: Lex + Parse WITH event emission ──────────────────────
    // Measures the overhead of parser-side scope/reference event emission.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var events_total: u64 = 0;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch continue;
            tree.deinit(fba.allocator());
            ev.deinit(fba.allocator());
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            events_total = ev.len();
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lex + Parse (events on)", &times, source.len);
        std.debug.print("  events per iter: {d}\n\n", .{events_total});
    }

    // ── Phase 10: Event-consumer sanity (iterate the stream in a tight loop) ──
    // Measures the raw cost of consuming N events — the upper-bound speed of
    // an event-driven semantic analyzer before adding any real work.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        // Build the event stream once outside the timed loop.
        var tok = Lexer.tokenize(fba.allocator(), source) catch return;
        defer tok.deinit(fba.allocator());
        var ev: scope_events.EventStream = .{};
        defer ev.deinit(fba.allocator());
        var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
            .is_module = true,
            .events_out = &ev,
        }) catch return;
        defer tree.deinit(fba.allocator());
        const all_events = ev.items();

        // Warmup + timed loop.
        for (0..WARMUP) |_| {
            var depth: u32 = 0;
            var decls: u32 = 0;
            var refs: u32 = 0;
            for (all_events) |e| {
                switch (e.kind) {
                    .scope_open => depth += 1,
                    .scope_close => depth -|= 1,
                    .declare => decls += 1,
                    .reference => refs += 1,
                    else => {},
                }
            }
            std.mem.doNotOptimizeAway(depth);
            std.mem.doNotOptimizeAway(decls);
            std.mem.doNotOptimizeAway(refs);
        }
        for (0..ITERATIONS) |iter| {
            const t0 = std.Io.Timestamp.now(io, .boot);
            var depth: u32 = 0;
            var decls: u32 = 0;
            var refs: u32 = 0;
            for (all_events) |e| {
                switch (e.kind) {
                    .scope_open => depth += 1,
                    .scope_close => depth -|= 1,
                    .declare => decls += 1,
                    .reference => refs += 1,
                    else => {},
                }
            }
            std.mem.doNotOptimizeAway(depth);
            std.mem.doNotOptimizeAway(decls);
            std.mem.doNotOptimizeAway(refs);
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Event-stream scan only", &times, source.len);
        std.debug.print("  events: {d} ({d} bytes)\n\n", .{ all_events.len, all_events.len * @sizeOf(scope_events.Event) });

        // Event distribution
        var opens: u32 = 0;
        var closes: u32 = 0;
        var decls: u32 = 0;
        var refs: u32 = 0;
        var terms: u32 = 0;
        var branches: u32 = 0;
        for (all_events) |e| switch (e.kind) {
            .scope_open => opens += 1,
            .scope_close => closes += 1,
            .declare => decls += 1,
            .reference => refs += 1,
            .terminator => terms += 1,
            .branch_open, .branch_else, .branch_close => branches += 1,
            else => {},
        };
        std.debug.print("  distribution: {d} opens, {d} closes, {d} decls, {d} refs, {d} terms, {d} branches\n\n", .{ opens, closes, decls, refs, terms, branches });
    }

    // ── Phase 11: Event-driven scope resolver (real work) ──────────────
    // Measures: Lex + Parse (events on) + event_resolver.resolve.  This is
    // the direct apples-to-apples comparison for semantic's main visit walk,
    // which costs ~200 µs on acorn.js.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var last_res: event_resolver.Result = undefined;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch continue;
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            last_res = event_resolver.resolve(fba.allocator(), &tree, ev.items()) catch continue;
        }
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            last_res = event_resolver.resolve(fba.allocator(), &tree, ev.items()) catch {
                times[iter] = 0;
                continue;
            };
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        printStats("Lex+Parse+EventResolve", &times, source.len);
        std.debug.print("  scopes:{d} decls:{d} resolved:{d} unresolved:{d}\n\n", .{
            last_res.scope_count, last_res.binding_count, last_res.resolved, last_res.unresolved,
        });
    }

    // ── Phase 12: Full event-driven SemanticResult (production path) ──
    // Same output shape as the tree-walking analyzer (ScopeTree + SymbolTable
    // + ReferenceTable + post-passes); drop-in replacement for analyze().
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        var full_syms: u32 = 0;
        var full_refs: u32 = 0;
        var full_scopes: u32 = 0;
        var sem_oom: u32 = 0;
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch continue;
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            if (event_resolver.resolveFull(fba.allocator(), &tree, ev.items(), .{})) |res| {
                var r = res;
                r.deinit(fba.allocator());
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
            var ev: scope_events.EventStream = .{};
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .events_out = &ev,
            }) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            defer ev.deinit(fba.allocator());
            if (event_resolver.resolveFull(fba.allocator(), &tree, ev.items(), .{})) |res| {
                var r = res;
                full_syms = @intCast(r.symbols.names.items.len);
                full_refs = r.references.count();
                full_scopes = @intCast(r.scopes.kinds.items.len);
                r.deinit(fba.allocator());
            } else |_| {
                sem_oom += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom > 0) std.debug.print("[WARN] Phase 12: resolveFull OOM in {d}/{d} iterations\n", .{ sem_oom, ITERATIONS });
        printStats("Lex+Parse+ResolveFull", &times, source.len);
        std.debug.print("  scopes:{d} syms:{d} refs:{d}\n\n", .{ full_scopes, full_syms, full_refs });
    }

    // ── Phase 12b: Default-wired event path (parser emits events + analyzeWithOptions auto-dispatch) ──
    // This is what downstream callers see after the "pivot": they just call
    // parse with emit_events=true.
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        for (0..WARMUP) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .emit_events = true,
            }) catch continue;
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |res| {
                var r = res;
                r.deinit(fba.allocator());
            } else |_| {}
        }
        var sem_oom: u32 = 0;
        for (0..ITERATIONS) |iter| {
            fba.reset();
            const t0 = std.Io.Timestamp.now(io, .boot);
            var tok = Lexer.tokenize(fba.allocator(), source) catch {
                times[iter] = 0;
                continue;
            };
            defer tok.deinit(fba.allocator());
            var tree = Parser.parseWithOptions(fba.allocator(), source, tok.tokens.slice(), .{
                .is_module = true,
                .emit_events = true,
            }) catch {
                times[iter] = 0;
                continue;
            };
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |res| {
                var r = res;
                r.deinit(fba.allocator());
            } else |_| {
                sem_oom += 1;
                times[iter] = 0;
                continue;
            }
            const t1 = std.Io.Timestamp.now(io, .boot);
            times[iter] = @intCast(t0.durationTo(t1).nanoseconds);
        }
        if (sem_oom > 0) std.debug.print("[WARN] Phase 12b: semantic OOM in {d}/{d} iterations\n", .{ sem_oom, ITERATIONS });
        printStats("Zig-only (auto-dispatch)", &times, source.len);
    }

    // ── Phase 13: Equivalence check (event-driven vs tree walker) ──────
    // Runs both paths on the same input and reports count divergence.
    // Uses GPA (not FBA) — two full semantic passes on a large file exceed any
    // single FBA budget.  This is a one-shot correctness check, not timed.
    {
        var tok_eq = Lexer.tokenize(gpa, source) catch {
            std.debug.print("\n[SKIP] Phase 13: tokenize failed\n", .{});
            return;
        };
        defer tok_eq.deinit(gpa);

        // Path 1: tree walker
        var tree_a = Parser.parse(gpa, source, tok_eq.tokens.slice()) catch {
            std.debug.print("\n[SKIP] Phase 13: parse (tree walker) failed\n", .{});
            return;
        };
        defer tree_a.deinit(gpa);
        var sem_tree = semantic_mod.SemanticAnalyzer.analyzeWithOptions(gpa, &tree_a, .{}) catch {
            std.debug.print("\n[SKIP] Phase 13: semantic (tree walker) failed\n", .{});
            return;
        };
        defer sem_tree.deinit(gpa);

        // Path 2: event resolver — parse with emit_events=true so tree.scope_events
        // is populated for analyzeWithOptions (events_out routes to an external
        // stream which analyzeWithOptions never reads).
        var tree_b = Parser.parseWithOptions(gpa, source, tok_eq.tokens.slice(), .{
            .is_module = true,
            .emit_events = true,
        }) catch {
            std.debug.print("\n[SKIP] Phase 13: parse (event resolver) failed\n", .{});
            return;
        };
        defer tree_b.deinit(gpa);
        var sem_ev = semantic_mod.SemanticAnalyzer.analyzeWithOptions(gpa, &tree_b, .{}) catch {
            std.debug.print("\n[SKIP] Phase 13: semantic (event resolver) failed\n", .{});
            return;
        };
        defer sem_ev.deinit(gpa);

        const scopes_tree = sem_tree.scopes.kinds.items.len;
        const scopes_ev   = sem_ev.scopes.kinds.items.len;
        const syms_tree   = sem_tree.symbols.names.items.len;
        const syms_ev     = sem_ev.symbols.names.items.len;
        const refs_tree   = sem_tree.references.count();
        const refs_ev     = sem_ev.references.count();

        var resolved_tree: u32 = 0;
        for (sem_tree.references.symbol_ids.items) |s| if (s != .none) { resolved_tree += 1; };
        var resolved_ev: u32 = 0;
        for (sem_ev.references.symbol_ids.items) |s| if (s != .none) { resolved_ev += 1; };

        // node_reachable comparison — counts dead-code markers (0 entries).
        var dead_tree: u32 = 0;
        for (sem_tree.node_reachable) |b| if (b == 0) { dead_tree += 1; };
        var dead_ev: u32 = 0;
        for (sem_ev.node_reachable) |b| if (b == 0) { dead_ev += 1; };

        std.debug.print("\n=== Equivalence check: tree walker vs event resolver ===\n", .{});
        std.debug.print("             tree        events       delta   coverage\n", .{});
        std.debug.print("  scopes:   {d:>6}      {d:>6}     {d:>6}    {d:>4.0}%\n", .{
            scopes_tree, scopes_ev,
            @as(i64, @intCast(scopes_ev)) - @as(i64, @intCast(scopes_tree)),
            100.0 * @as(f64, @floatFromInt(scopes_ev)) / @as(f64, @floatFromInt(scopes_tree)),
        });
        std.debug.print("  symbols:  {d:>6}      {d:>6}     {d:>6}    {d:>4.0}%\n", .{
            syms_tree, syms_ev,
            @as(i64, @intCast(syms_ev)) - @as(i64, @intCast(syms_tree)),
            100.0 * @as(f64, @floatFromInt(syms_ev)) / @as(f64, @floatFromInt(syms_tree)),
        });
        std.debug.print("  refs:     {d:>6}      {d:>6}     {d:>6}    {d:>4.0}%\n", .{
            refs_tree, refs_ev,
            @as(i64, @intCast(refs_ev)) - @as(i64, @intCast(refs_tree)),
            100.0 * @as(f64, @floatFromInt(refs_ev)) / @as(f64, @floatFromInt(refs_tree)),
        });
        std.debug.print("  resolved: {d:>6}      {d:>6}     {d:>6}    {d:>4.0}%\n", .{
            resolved_tree, resolved_ev,
            @as(i64, @intCast(resolved_ev)) - @as(i64, @intCast(resolved_tree)),
            100.0 * @as(f64, @floatFromInt(resolved_ev)) / @as(f64, @floatFromInt(resolved_tree)),
        });
        std.debug.print("  dead:     {d:>6}      {d:>6}     {d:>6}\n", .{
            dead_tree, dead_ev,
            @as(i64, @intCast(dead_ev)) - @as(i64, @intCast(dead_tree)),
        });

        // Symbol diff — which (kind) are we missing?  Bucket by binding_kind.
        var tree_by_kind: [17]u32 = .{0}**17;
        var ev_by_kind: [17]u32 = .{0}**17;
        for (sem_tree.symbols.binding_kinds.items) |bk| {
            const k: u8 = @intFromEnum(bk);
            if (k < tree_by_kind.len) tree_by_kind[k] += 1;
        }
        for (sem_ev.symbols.binding_kinds.items) |bk| {
            const k: u8 = @intFromEnum(bk);
            if (k < ev_by_kind.len) ev_by_kind[k] += 1;
        }
        std.debug.print("\n  binding-kind breakdown:\n", .{});
        const kind_names = [_][]const u8{
            "var        ", "let        ", "const      ", "function_decl", "class_decl ",
            "parameter  ", "catch_param", "import     ", "type_import", "implicit   ",
            "type_decl  ", "interface  ", "enum_decl  ", "namespace  ",
            "fn_expr_name", "class_expr_name", "type_param ",
        };
        for (kind_names, 0..) |kname, i| {
            if (tree_by_kind[i] == 0 and ev_by_kind[i] == 0) continue;
            std.debug.print("    {s:<16}  tree={d:>5}  events={d:>5}  delta={d:>6}\n", .{
                kname, tree_by_kind[i], ev_by_kind[i],
                @as(i64, @intCast(ev_by_kind[i])) - @as(i64, @intCast(tree_by_kind[i])),
            });
        }
    }

    // ── Phase 9: Semantic debug counters ─────────────────────────────
    {
        var fba = std.heap.FixedBufferAllocator.init(working_buf);
        semantic_mod.debug_resolve_lookups = 0;
        semantic_mod.debug_resolve_calls = 0;
        semantic_mod.debug_resolve_hits = 0;
        semantic_mod.debug_resolve_depth_sum = 0;
        semantic_mod.debug_visit_nodes = 0;
        semantic_mod.debug_enter_scope = 0;
        semantic_mod.debug_declare_binding = 0;
        semantic_mod.debug_add_reference = 0;
        semantic_mod.debug_visit_sub_range_calls = 0;
        semantic_mod.debug_visit_sub_range_items = 0;
        for (&semantic_mod.debug_visit_tag_counts) |*c| c.* = 0;

        var ran: u64 = 0;
        var sem_oom: u32 = 0;
        for (0..ITERATIONS) |_| {
            fba.reset();
            var tok = Lexer.tokenize(fba.allocator(), source) catch continue;
            defer tok.deinit(fba.allocator());
            var tree = Parser.parse(fba.allocator(), source, tok.tokens.slice()) catch continue;
            defer tree.deinit(fba.allocator());
            if (semantic_mod.SemanticAnalyzer.analyzeWithOptions(fba.allocator(), &tree, .{})) |sem_result| {
                var sem = sem_result;
                sem.deinit(fba.allocator());
                ran += 1;
            } else |_| { sem_oom += 1; }
        }
        if (sem_oom > 0) std.debug.print("[WARN] Phase 9 debug: semantic OOM in {d}/{d} iterations\n", .{ sem_oom, ITERATIONS });
        if (ran > 0) {
            const total_calls = semantic_mod.debug_resolve_calls;
            const total_lookups = semantic_mod.debug_resolve_lookups;
            const total_hits = semantic_mod.debug_resolve_hits;
            const depth_sum = semantic_mod.debug_resolve_depth_sum;
            const total_misses = total_calls - total_hits;
            const avg_lookups = @as(f64, @floatFromInt(total_lookups)) / @as(f64, @floatFromInt(@max(total_calls, 1)));
            const avg_hit_depth = if (total_hits > 0) @as(f64, @floatFromInt(depth_sum)) / @as(f64, @floatFromInt(total_hits)) else 0.0;
            std.debug.print("\nresolveReference stats (per iter):\n", .{});
            std.debug.print("  calls:            {d}\n", .{ total_calls / ran });
            std.debug.print("  lookups:          {d}  (avg {d:.2}/call)\n", .{ total_lookups / ran, avg_lookups });
            std.debug.print("  hits:             {d}\n", .{ total_hits / ran });
            if (total_calls > 0) std.debug.print("  misses (global):  {d}  ({d:.1}%)\n", .{ total_misses / ran, 100.0 * @as(f64, @floatFromInt(total_misses)) / @as(f64, @floatFromInt(total_calls)) });
            std.debug.print("  avg hit depth:    {d:.2}  (0 = current scope)\n", .{ avg_hit_depth });

            std.debug.print("\n=== Visit-pass operation counts (per iter) ===\n", .{});
            std.debug.print("  nodes visited:          {d}\n", .{ semantic_mod.debug_visit_nodes / ran });
            std.debug.print("  enterScope calls:       {d}\n", .{ semantic_mod.debug_enter_scope / ran });
            std.debug.print("  declareBinding calls:   {d}\n", .{ semantic_mod.debug_declare_binding / ran });
            std.debug.print("  addReference calls:     {d}\n", .{ semantic_mod.debug_add_reference / ran });
            std.debug.print("  visitSubRange calls:    {d}\n", .{ semantic_mod.debug_visit_sub_range_calls / ran });
            std.debug.print("  visitSubRange items:    {d}\n", .{ semantic_mod.debug_visit_sub_range_items / ran });

            std.debug.print("\n=== Top 15 node tags visited (per iter) ===\n", .{});
            var top_tags: [16]struct { tag: usize, count: u64 } = undefined;
            for (&top_tags) |*t| t.* = .{ .tag = 0, .count = 0 };
            for (semantic_mod.debug_visit_tag_counts[0..], 0..) |cnt, i| {
                const per_iter = cnt / ran;
                if (per_iter == 0) continue;
                var ins_idx: usize = 15;
                while (ins_idx > 0 and top_tags[ins_idx - 1].count < per_iter) : (ins_idx -= 1) {}
                if (ins_idx < 15) {
                    var k: usize = 14;
                    while (k > ins_idx) : (k -= 1) top_tags[k] = top_tags[k - 1];
                    top_tags[ins_idx] = .{ .tag = i, .count = per_iter };
                }
            }
            for (top_tags[0..15]) |t| {
                if (t.count == 0) break;
                const tag_enum: @import("ez").ast.Node.Tag = @enumFromInt(t.tag);
                std.debug.print("  {d:>5}   {s}\n", .{ t.count, @tagName(tag_enum) });
            }
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
