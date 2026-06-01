// Eager whole-file type-inference cost probe — decides Path 1 transport.
//
// The A-vs-B question (eager NAPI batch vs on-demand FFI) reduces to ONE
// number: is filling the checker's node_types cache for an entire file cheap
// enough to just always do it? If yes, the eager batch wins — it avoids the
// persistent-handle lifetime redesign AND the chatty per-type FFI introspection
// that a lazy ts.Type facade would need.
//
// This probe measures, per TS fixture:
//   - parse+sem baseline (context)
//   - Checker.init cost (alloc node_types/sym_types + buildKnownTypeNames/globals)
//   - eager typeOf over ALL nodes (the eager ceiling)
//   - distinct interned types + pool bytes (serialization payload size)
//   - how many nodes yield a RICH type (object/union/fn/array/tuple/ref/literal)
//     — the only nodes whose structure the JS facade must serialize/serve
//
// Run: zig build bench-type-eager
const std = @import("std");
const ez = @import("ez");
const Lexer = ez.Lexer;
const Parser = ez.Parser;
const semantic_mod = ez.semantic;
const checker_mod = ez.checker;
const tymod = ez.checker.types;
const Language = ez.token.Language;

const Fixture = struct { path: []const u8, lang: Language = .ts, is_module: bool = true };
const fixtures = [_]Fixture{
    .{ .path = "bench/fixtures/app-render.tsx", .lang = .tsx },
    .{ .path = "bench/fixtures/angular-classes.ts" },
    .{ .path = "bench/fixtures/checker.ts" },
};

// Cold-cache is the real CLI scenario (each file linted once). Each iter resets
// the FixedBufferAllocator → the checker is rebuilt cold every time, so a small
// iter count already gives a stable cold-pass number.
const WARMUP: u32 = 0;
const ITERS: u32 = 3;

fn p50(times: *[ITERS]u64) f64 {
    var sorted = times.*;
    std.mem.sort(u64, &sorted, {}, std.sort.asc(u64));
    return @as(f64, @floatFromInt(sorted[ITERS / 2])) / 1e6;
}

fn isRich(k: tymod.TypeKind) bool {
    return switch (k) {
        .union_t, .intersection_t, .object_t, .function_t, .array_t,
        .readonly_array_t, .tuple_t, .type_ref, .type_param,
        .string_literal, .number_literal, .bigint_literal, .boolean_literal => true,
        else => false,
    };
}

pub fn main(init: std.process.Init) !void {
    const gpa = init.gpa;
    const io = init.io;

    const working = try gpa.alloc(u8, 768 * 1024 * 1024);
    defer gpa.free(working);

    std.debug.print("\nEager-vs-lazy type-inference probe (p50 over {d} cold iters)\n\n", .{ITERS});
    std.debug.print("{s:<20} {s:>6} {s:>8} {s:>9} {s:>10} {s:>10} {s:>8} {s:>9} {s:>8}\n", .{
        "fixture", "KB", "nodes", "parse+sem", "eager ms", "lazy ms", "lazy q", "eager/lazy", "poolKB",
    });
    std.debug.print("{s}\n", .{"--------------------------------------------------------------------------------------------------------------"});

    for (fixtures) |fx| {
        const source = std.Io.Dir.cwd().readFileAlloc(io, fx.path, gpa, .unlimited) catch continue;
        defer gpa.free(source);
        const name = std.fs.path.basename(fx.path);

        var t_parsesem: [ITERS]u64 = @splat(0);
        var t_init: [ITERS]u64 = @splat(0);
        var t_eager: [ITERS]u64 = @splat(0);
        var t_lazy: [ITERS]u64 = @splat(0);
        var node_count: u32 = 0;
        var query_count: u32 = 0;
        var pool_bytes: usize = 0;
        var ok: u32 = 0;

        var fba = std.heap.FixedBufferAllocator.init(working);
        for (0..WARMUP + ITERS) |iter| {
            fba.reset();
            const alloc = fba.allocator();

            const a0 = std.Io.Timestamp.now(io, .boot);
            var lex = Lexer.tokenizeWithLanguage(alloc, source, fx.lang) catch continue;
            var tree = Parser.parseWithOptions(alloc, source, lex.tokens.slice(), .{
                .language = fx.lang, .is_module = fx.is_module, .emit_events = true,
            }) catch continue;
            var sem_arena = std.heap.ArenaAllocator.init(alloc);
            var sem = semantic_mod.SemanticAnalyzer.analyzeWithGlobals(sem_arena.allocator(), &tree, &.{}) catch continue;
            const a1 = std.Io.Timestamp.now(io, .boot);

            var ckr = checker_mod.Checker.init(alloc, &tree, &sem) catch continue;
            const a2 = std.Io.Timestamp.now(io, .boot);

            const n: u32 = @intCast(tree.nodes.len);
            const tags = tree.nodes.items(.tag);
            var i: u32 = 0;
            while (i < n) : (i += 1) {
                _ = ckr.typeOf(@enumFromInt(i));
            }
            const a3 = std.Io.Timestamp.now(io, .boot);

            // ── Lazy pass: a FRESH cold checker, query ONLY the nodes the
            // biggest type-aware rule family touches (call/new/member — the
            // no-unsafe-* / no-floating-promises set). This is what an
            // on-demand bridge would actually compute per file.
            var ckr2 = checker_mod.Checker.init(alloc, &tree, &sem) catch continue;
            const b0 = std.Io.Timestamp.now(io, .boot);
            var q: u32 = 0;
            i = 0;
            while (i < n) : (i += 1) {
                switch (tags[i]) {
                    .call_expr, .optional_call_expr, .new_expr,
                    .member_expr, .computed_member_expr,
                    .optional_member_expr, .optional_computed_member_expr => {
                        _ = ckr2.typeOf(@enumFromInt(i));
                        q += 1;
                    },
                    else => {},
                }
            }
            const b1 = std.Io.Timestamp.now(io, .boot);

            if (iter >= WARMUP) {
                const k = iter - WARMUP;
                t_parsesem[k] = @intCast(a0.durationTo(a1).nanoseconds);
                t_init[k] = @intCast(a1.durationTo(a2).nanoseconds);
                t_eager[k] = @intCast(a2.durationTo(a3).nanoseconds);
                t_lazy[k] = @intCast(b0.durationTo(b1).nanoseconds);
                node_count = n;
                query_count = q;
                pool_bytes = ckr.store.type_id_pool.items.len * @sizeOf(tymod.TypeId) +
                    ckr.store.object_prop_pool.items.len * @sizeOf(tymod.ObjectProp) +
                    ckr.store.signature_pool.items.len * @sizeOf(tymod.Signature) +
                    ckr.store.signature_param_pool.items.len * @sizeOf(tymod.TypeId) +
                    ckr.store.types.items.len * @sizeOf(tymod.Type);
                ok += 1;
            }
            sem_arena.deinit();
        }

        if (ok == 0) {
            std.debug.print("{s:<22} {s}\n", .{ name, "FAILED" });
            continue;
        }
        const eager_ms = p50(&t_eager);
        const lazy_ms = p50(&t_lazy);
        const ratio = if (lazy_ms > 0.0) eager_ms / lazy_ms else 0.0;
        std.debug.print("{s:<20} {d:>6} {d:>8} {d:>9.2} {d:>10.2} {d:>10.2} {d:>8} {d:>8.0}x {d:>8}\n", .{
            name, source.len / 1024, node_count,
            p50(&t_parsesem), eager_ms, lazy_ms, query_count, ratio,
            pool_bytes / 1024,
        });
    }
    std.debug.print("\nLegend: eager ms = typeOf() over ALL nodes; lazy ms = typeOf() over only call/new/member\n", .{});
    std.debug.print("        nodes (the no-unsafe-*/floating-promises set), fresh cold checker. lazy q = #queries.\n", .{});
}
