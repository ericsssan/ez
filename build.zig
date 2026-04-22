const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ── Main executable ──────────────────────────────────────
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "ez",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    // Run step: zig build run -- [args]
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run ez");
    run_step.dependOn(&run_cmd.step);

    // ── Unit tests ───────────────────────────────────────────
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    const unit_tests = b.addTest(.{
        .root_module = test_mod,
    });
    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // ── Linter integration tests ────────────────────────────
    const linter_test_mod = b.createModule(.{
        .root_source_file = b.path("tests/linter_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    linter_test_mod.addImport("ez", test_mod);
    const linter_tests = b.addTest(.{
        .root_module = linter_test_mod,
    });
    const run_linter_tests = b.addRunArtifact(linter_tests);
    test_step.dependOn(&run_linter_tests.step);

    // ── Error recovery tests ────────────────────────────────
    const recovery_test_mod = b.createModule(.{
        .root_source_file = b.path("tests/error_recovery_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    recovery_test_mod.addImport("ez", test_mod);
    const recovery_tests = b.addTest(.{ .root_module = recovery_test_mod });
    test_step.dependOn(&b.addRunArtifact(recovery_tests).step);

    // ── Config integration tests ──────────────────────────────
    const config_test_mod = b.createModule(.{
        .root_source_file = b.path("tests/config_integration_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    config_test_mod.addImport("ez", test_mod);
    const config_tests = b.addTest(.{ .root_module = config_test_mod });
    test_step.dependOn(&b.addRunArtifact(config_tests).step);

    // ── Fuzz tests ────────────────────────────────────────────
    const fuzz_test_mod = b.createModule(.{
        .root_source_file = b.path("tests/fuzz_test.zig"),
        .target = target,
        .optimize = optimize,
    });
    fuzz_test_mod.addImport("ez", test_mod);
    const fuzz_tests = b.addTest(.{ .root_module = fuzz_test_mod });
    const fuzz_step = b.step("fuzz", "Run fuzz tests");
    fuzz_step.dependOn(&b.addRunArtifact(fuzz_tests).step);

    // ── NAPI shared library (JS plugin support) ────────────
    // Root is src/napi_entry.zig (in src/) so that cli/napi.zig's relative
    // imports (../parser/root.zig) stay within the module path (src/).
    const napi_mod = b.createModule(.{
        .root_source_file = b.path("src/napi_entry.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    const napi_lib = b.addLibrary(.{
        .name = "ez",
        .root_module = napi_mod,
        .linkage = .dynamic,
    });
    // NAPI symbols are resolved at load time by the JS runtime.
    napi_lib.linker_allow_shlib_undefined = true;
    // Install as ez.node (Node.js requires .node extension) in addition to the native lib name.
    const napi_install_node = b.addInstallLibFile(napi_lib.getEmittedBin(), "ez.node");
    const napi_step = b.step("napi", "Build NAPI shared library for JS plugins");
    napi_step.dependOn(&napi_install_node.step);
    // Include NAPI build in default install step so `zig build` builds everything.
    b.getInstallStep().dependOn(&napi_install_node.step);

    // QuickJS removed — pure Zig interpreter for ESLint rules

    // ── Benchmark ────────────────────────────────────────────
    const bench_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_parser.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_mod.addImport("ez", test_mod);
    const bench = b.addExecutable(.{
        .name = "bench_parser",
        .root_module = bench_mod,
    });
    const bench_cmd = b.addRunArtifact(bench);
    bench_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        bench_cmd.addArgs(args);
    }
    const bench_step = b.step("bench", "Run parser benchmarks");
    bench_step.dependOn(&bench_cmd.step);

    // ── Events bench ─────────────────────────────────────────
    const bench_evt_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_events.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_evt_mod.addImport("ez", test_mod);
    const bench_evt = b.addExecutable(.{
        .name = "bench_events",
        .root_module = bench_evt_mod,
    });
    const bench_evt_cmd = b.addRunArtifact(bench_evt);
    bench_evt_cmd.step.dependOn(b.getInstallStep());
    const bench_evt_step = b.step("bench-events", "Event stream throughput bench");
    bench_evt_step.dependOn(&bench_evt_cmd.step);

    // ── Alloc bench ──────────────────────────────────────────
    const bench_alloc_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_alloc.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_alloc_mod.addImport("ez", test_mod);
    const bench_alloc = b.addExecutable(.{
        .name = "bench_alloc",
        .root_module = bench_alloc_mod,
    });
    const bench_alloc_cmd = b.addRunArtifact(bench_alloc);
    bench_alloc_cmd.step.dependOn(b.getInstallStep());
    const bench_alloc_step = b.step("bench-alloc", "Allocation count bench");
    bench_alloc_step.dependOn(&bench_alloc_cmd.step);

    // ── Lexer bench ──────────────────────────────────────────
    const bench_lex_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_lexer.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_lex_mod.addImport("ez", test_mod);
    const bench_lex = b.addExecutable(.{
        .name = "bench_lexer",
        .root_module = bench_lex_mod,
    });
    const bench_lex_cmd = b.addRunArtifact(bench_lex);
    bench_lex_cmd.step.dependOn(b.getInstallStep());
    const bench_lex_step = b.step("bench-lexer", "Lexer throughput bench");
    bench_lex_step.dependOn(&bench_lex_cmd.step);

    // ── Profile bench ────────────────────────────────────────
    const bench_prof_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_profile.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    bench_prof_mod.addImport("ez", test_mod);
    const bench_prof = b.addExecutable(.{
        .name = "bench_profile",
        .root_module = bench_prof_mod,
    });
    const bench_prof_cmd = b.addRunArtifact(bench_prof);
    bench_prof_cmd.step.dependOn(b.getInstallStep());
    const bench_prof_step = b.step("bench-profile", "resolveFull per-phase profile");
    bench_prof_step.dependOn(&bench_prof_cmd.step);

    // ── Lint bench ───────────────────────────────────────────
    const bench_lint_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_lint.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_lint_mod.addImport("ez", test_mod);
    const bench_lint = b.addExecutable(.{
        .name = "bench_lint",
        .root_module = bench_lint_mod,
    });
    const bench_lint_cmd = b.addRunArtifact(bench_lint);
    bench_lint_cmd.step.dependOn(b.getInstallStep());
    const bench_lint_step = b.step("bench-lint", "Full Zig backend profile (lex+parse+resolve+lint)");
    bench_lint_step.dependOn(&bench_lint_cmd.step);

    // ── Parallel scheduling bench (A: static / B: WS N_CPU / C: WS 2×N_CPU) ─
    const bench_par_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_parallel.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_par_mod.addImport("ez", test_mod);
    const bench_par = b.addExecutable(.{
        .name = "bench_parallel",
        .root_module = bench_par_mod,
    });
    const bench_par_cmd = b.addRunArtifact(bench_par);
    bench_par_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| bench_par_cmd.addArgs(args);
    const bench_par_step = b.step("bench-parallel", "Compare static-chunk vs work-stealing scheduling");
    bench_par_step.dependOn(&bench_par_cmd.step);

    // ── Lexer samply profiling build (ReleaseFast + DWARF symbols) ──────────
    const bench_lex_syms_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_lexer.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    bench_lex_syms_mod.addImport("ez", test_mod);
    const bench_lex_syms = b.addExecutable(.{
        .name = "bench_lexer_syms",
        .root_module = bench_lex_syms_mod,
    });
    const bench_lex_syms_install = b.addInstallArtifact(bench_lex_syms, .{});
    const bench_lex_syms_step = b.step("bench-lexer-syms", "Build lexer bench with debug symbols for samply");
    bench_lex_syms_step.dependOn(&bench_lex_syms_install.step);

    // ── Ez full-pipeline bench (lex + parse + semantic, vs OXC) ─────────────
    const bench_ez_parser_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_ez_parser.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_ez_parser_mod.addImport("ez", test_mod);
    const bench_ez_parser = b.addExecutable(.{
        .name = "bench_ez_parser",
        .root_module = bench_ez_parser_mod,
    });
    const bench_ez_parser_cmd = b.addRunArtifact(bench_ez_parser);
    bench_ez_parser_cmd.step.dependOn(b.getInstallStep());
    const bench_ez_parser_step = b.step("bench-ez-parser", "Ez full pipeline vs OXC");

    const bench_ez_parser_syms_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_ez_parser.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    bench_ez_parser_syms_mod.addImport("ez", test_mod);
    const bench_ez_parser_syms = b.addExecutable(.{ .name = "bench_ez_parser_syms", .root_module = bench_ez_parser_syms_mod });
    const bench_ez_parser_syms_install = b.addInstallArtifact(bench_ez_parser_syms, .{});
    const bench_ez_parser_syms_step = b.step("bench-ez-parser-syms", "Build Ez parser bench with DWARF for sample");
    bench_ez_parser_syms_step.dependOn(&bench_ez_parser_syms_install.step);
    bench_ez_parser_step.dependOn(&bench_ez_parser_cmd.step);

    // ── Backend bench (production path: what NAPI exposes to JS) ──
    const bench_be_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_backend.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_be_mod.addImport("ez", test_mod);
    const bench_be = b.addExecutable(.{
        .name = "bench_backend",
        .root_module = bench_be_mod,
    });
    const bench_be_cmd = b.addRunArtifact(bench_be);
    bench_be_cmd.step.dependOn(b.getInstallStep());
    const bench_be_step = b.step("bench-backend", "Zig backend profile (lex+parse+resolve+traversal+writebuf)");
    bench_be_step.dependOn(&bench_be_cmd.step);
}
