const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ── es-parser dependency (extracted parser/lexer/semantic) ──
    // The parser lives in the sibling `es-parser` repo and is consumed as a
    // Zig module named "es_parser".  Every module rooted under src/ imports it.
    // Built ReleaseFast regardless of the top-level optimize mode: the parser
    // is an external, separately-tested dependency, and the NAPI/conformance
    // path (the only consumer of writeSemanticData) has always run ReleaseFast.
    const es_parser_dep = b.dependency("es_parser", .{
        .target = target,
        .optimize = .ReleaseFast,
    });
    const es_parser_mod = es_parser_dep.module("es-parser");

    // ── Main executable ──────────────────────────────────────
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("es_parser", es_parser_mod);
    const exe = b.addExecutable(.{
        .name = "ez",
        .root_module = exe_mod,
    });
    b.installArtifact(exe);

    // Run step: zig build run -- [args]
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run ez");
    run_step.dependOn(&run_cmd.step);

    // ── Unit tests ───────────────────────────────────────────
    const test_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_mod.addImport("es_parser", es_parser_mod);
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
    // imports of the es_parser module stay within the module path (src/).
    const napi_mod = b.createModule(.{
        .root_source_file = b.path("src/napi_entry.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    napi_mod.addImport("es_parser", es_parser_mod);
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
    const bench_step = b.step("bench", "Run parser benchmarks");
    bench_step.dependOn(&bench_cmd.step);

    // ── Single-thread pipeline bench (lex+parse+sem) ──
    const bench_st_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_pipeline_st.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_st_mod.addImport("ez", test_mod);
    const bench_st = b.addExecutable(.{
        .name = "bench_pipeline_st",
        .root_module = bench_st_mod,
    });
    const bench_st_cmd = b.addRunArtifact(bench_st);
    bench_st_cmd.step.dependOn(b.getInstallStep());
    const bench_st_step = b.step("bench-pipeline-st", "Single-thread lex+parse+sem benchmark");
    bench_st_step.dependOn(&bench_st_cmd.step);

    // ── Parse stage breakdown bench ──
    const bench_stages_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_parse_stages.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_stages_mod.addImport("ez", test_mod);
    const bench_stages = b.addExecutable(.{ .name = "bench_parse_stages", .root_module = bench_stages_mod });
    const bench_stages_cmd = b.addRunArtifact(bench_stages);
    bench_stages_cmd.step.dependOn(b.getInstallStep());
    const bench_stages_step = b.step("bench-parse-stages", "Per-stage pipeline timing breakdown");
    bench_stages_step.dependOn(&bench_stages_cmd.step);

    // ── Eager type-inference probe (Path 1 transport decision) ──
    const bench_te_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_type_eager.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_te_mod.addImport("ez", test_mod);
    const bench_te = b.addExecutable(.{ .name = "bench_type_eager", .root_module = bench_te_mod });
    const bench_te_cmd = b.addRunArtifact(bench_te);
    bench_te_cmd.step.dependOn(b.getInstallStep());
    const bench_te_step = b.step("bench-type-eager", "Eager whole-file typeOf() cost + serialization sizing");
    bench_te_step.dependOn(&bench_te_cmd.step);

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

    // ── Sections bench (per-phase breakdown) ─────────────────
    const bench_sec_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_sections.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_sec_mod.addImport("ez", test_mod);
    const bench_sec = b.addExecutable(.{ .name = "bench_sections", .root_module = bench_sec_mod });
    const bench_sec_cmd = b.addRunArtifact(bench_sec);
    bench_sec_cmd.step.dependOn(b.getInstallStep());
    b.step("bench-sections", "Per-phase lexer breakdown").dependOn(&bench_sec_cmd.step);

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

    // ── Parallel scheduling bench (A: static / B: WS N_CPU / C: WS 2×N_CPU) ─
    const bench_par_ez_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    bench_par_ez_mod.addImport("es_parser", es_parser_mod);
    const bench_par_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_parallel.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    bench_par_mod.addImport("ez", bench_par_ez_mod);
    const bench_par = b.addExecutable(.{
        .name = "bench_parallel",
        .root_module = bench_par_mod,
    });
    const bench_par_cmd = b.addRunArtifact(bench_par);
    bench_par_cmd.step.dependOn(b.getInstallStep());
    const bench_par_step = b.step("bench-parallel", "Compare static-chunk vs work-stealing scheduling");
    bench_par_step.dependOn(&bench_par_cmd.step);

    // ── LSP / daemon single-file latency bench ───────────────────────────────
    const bench_lsp_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_lsp.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    bench_lsp_mod.addImport("ez", bench_par_ez_mod);
    const bench_lsp_exe = b.addExecutable(.{ .name = "bench_lsp", .root_module = bench_lsp_mod });
    const bench_lsp_cmd = b.addRunArtifact(bench_lsp_exe);
    bench_lsp_cmd.step.dependOn(b.getInstallStep());
    const bench_lsp_step = b.step("bench-lsp", "Single-file latency (LSP/daemon shape): G vs G+mmap");
    bench_lsp_step.dependOn(&bench_lsp_cmd.step);

    // ── Profiling target: run only strategy K, many iters ──
    const tk_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_k_only.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    tk_mod.addImport("ez", bench_par_ez_mod);
    const tk_exe = b.addExecutable(.{ .name = "test_k_only", .root_module = tk_mod });
    const tk_cmd = b.addRunArtifact(tk_exe);
    tk_cmd.step.dependOn(b.getInstallStep());
    const tk_step = b.step("test-k", "Run only strategy K (for profiling)");
    tk_step.dependOn(&tk_cmd.step);

    // ── Pool strategy bench ──
    const pool_mod = b.createModule(.{
        .root_source_file = b.path("bench/bench_pool.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    pool_mod.addImport("ez", test_mod);
    const pool_exe = b.addExecutable(.{ .name = "bench_pool", .root_module = pool_mod });
    b.installArtifact(pool_exe);
    const pool_cmd = b.addRunArtifact(pool_exe);
    pool_cmd.step.dependOn(b.getInstallStep());
    const pool_step = b.step("bench-pool", "Pool vs hybrid_3stage vs ws_aio strategies");
    pool_step.dependOn(&pool_cmd.step);

    // ── Pipeline crash isolation test ────────────────────────────────────────
    const test_pipeline_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_pipeline.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    test_pipeline_mod.addImport("ez", bench_par_ez_mod);
    const test_pipeline_exe = b.addExecutable(.{ .name = "test_pipeline", .root_module = test_pipeline_mod });
    const test_pipeline_cmd = b.addRunArtifact(test_pipeline_exe);
    test_pipeline_cmd.step.dependOn(b.getInstallStep());
    const test_pipeline_step = b.step("test-pipeline", "Isolate lintFilesPipelined crash (7 runs, gpa, real files)");
    test_pipeline_step.dependOn(&test_pipeline_cmd.step);

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

    // ezlint (the user-facing CLI) is no longer built by Zig.
    //
    // The previous architecture forked N Bun subprocesses from a Zig host
    // binary that embedded the Bun runtime via @embedFile.  That host
    // (src/bun/lint_pool.zig + src/bun/worker.js + vendor/bun/bun-*) was
    // replaced by a single-process Bun host (src/bun/lint.js +
    // src/bun/lint-worker.js) compiled to a self-contained executable via
    // `bun build --compile`.  See `make ezlint` for the new build target.
    //
    // What this Zig build still produces:
    //   * `ez`     — bare native CLI (src/main.zig), parser only, used by tests
    //   * `ez.node` — NAPI binding (src/cli/napi.zig), consumed by ezlint
    //                 via the standard Node N-API ABI
}
