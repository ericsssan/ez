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

    const prof_p1_mod = b.createModule(.{
        .root_source_file = b.path("bench/profile_phase1.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
    prof_p1_mod.addImport("ez", test_mod);
    const prof_p1 = b.addExecutable(.{ .name = "profile_phase1", .root_module = prof_p1_mod });
    const prof_p1_run = b.addRunArtifact(prof_p1);
    prof_p1_run.step.dependOn(b.getInstallStep());
    const prof_p1_step = b.step("profile-phase1", "Time buildBitmaps in isolation");
    prof_p1_step.dependOn(&prof_p1_run.step);

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
    const bench_par_ez_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = .ReleaseFast,
        .strip = false,
    });
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
    if (b.args) |args| bench_par_cmd.addArgs(args);
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
    if (b.args) |args| bench_lsp_cmd.addArgs(args);
    const bench_lsp_step = b.step("bench-lsp", "Single-file latency (LSP/daemon shape): G vs G+mmap");
    bench_lsp_step.dependOn(&bench_lsp_cmd.step);

    // ── Test: typescript.js pipeline timing under different analyze options ──
    const tsp_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_ts_pipeline.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    tsp_mod.addImport("ez", test_mod);  // ← swap: use Debug ez to compare with bench_ez_parser
    const tsp = b.addExecutable(.{ .name = "test_ts_pipeline", .root_module = tsp_mod });
    const tsp_cmd = b.addRunArtifact(tsp);
    tsp_cmd.step.dependOn(b.getInstallStep());
    const tsp_step = b.step("test-ts-pipeline", "Time typescript.js pipeline under various analyze options");
    tsp_step.dependOn(&tsp_cmd.step);

    // ── Pipeline ceiling: concurrent lex+parse upper-bound ──
    const ceiling_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_pipeline_ceiling.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    ceiling_mod.addImport("ez", test_mod);
    const ceiling = b.addExecutable(.{ .name = "test_pipeline_ceiling", .root_module = ceiling_mod });
    const ceiling_cmd = b.addRunArtifact(ceiling);
    ceiling_cmd.step.dependOn(b.getInstallStep());
    const ceiling_step = b.step("test-ceiling", "Concurrent lex+parse ceiling on typescript.js");
    ceiling_step.dependOn(&ceiling_cmd.step);

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
    if (b.args) |args| tk_cmd.addArgs(args);
    const tk_step = b.step("test-k", "Run only strategy K (for profiling)");
    tk_step.dependOn(&tk_cmd.step);

    // ── Phase 1 PoC: simdjson-style bitmap construction ──
    const sj_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_simdjson_phase1.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    sj_mod.addImport("ez", test_mod);
    const sj_exe = b.addExecutable(.{ .name = "test_simdjson_phase1", .root_module = sj_mod });
    const sj_cmd = b.addRunArtifact(sj_exe);
    sj_cmd.step.dependOn(b.getInstallStep());
    const sj_step = b.step("test-sj", "Phase 1 bitmap-construction PoC (simdjson-style)");
    sj_step.dependOn(&sj_cmd.step);

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
    if (b.args) |args| pool_cmd.addArgs(args);
    const pool_step = b.step("bench-pool", "Pool vs hybrid_3stage vs ws_aio strategies");
    pool_step.dependOn(&pool_cmd.step);

    // ── Profile harness for macOS `sample` ──
    const sjp_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_simdjson_profile.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    sjp_mod.addImport("ez", test_mod);
    const sjp_exe = b.addExecutable(.{ .name = "test_simdjson_profile", .root_module = sjp_mod });
    b.installArtifact(sjp_exe);
    const sjp_cmd = b.addRunArtifact(sjp_exe);
    sjp_cmd.step.dependOn(b.getInstallStep());
    const sjp_step = b.step("test-sj-profile", "Long-running profile harness for sampling");
    sjp_step.dependOn(&sjp_cmd.step);

    // ── Parser profile harness ──
    const pp_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_parse_profile.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    pp_mod.addImport("ez", test_mod);
    const pp_exe = b.addExecutable(.{ .name = "test_parse_profile", .root_module = pp_mod });
    b.installArtifact(pp_exe);
    const pp_cmd = b.addRunArtifact(pp_exe);
    pp_cmd.step.dependOn(b.getInstallStep());
    const pp_step = b.step("test-parse-profile", "Long-running parser profile harness");
    pp_step.dependOn(&pp_cmd.step);

    // ── Sem profile harness ──
    const sm_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_sem_profile.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    sm_mod.addImport("ez", test_mod);
    const sm_exe = b.addExecutable(.{ .name = "test_sem_profile", .root_module = sm_mod });
    b.installArtifact(sm_exe);
    const sm_cmd = b.addRunArtifact(sm_exe);
    sm_cmd.step.dependOn(b.getInstallStep());
    const sm_step = b.step("test-sem-profile", "Long-running sem profile harness");
    sm_step.dependOn(&sm_cmd.step);

    // ── typescript.js semantic failure test ──
    const ts_fail_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_ts_fail.zig"),
        .target = target, .optimize = .ReleaseFast,
    });
    ts_fail_mod.addImport("ez", test_mod);
    const ts_fail_exe = b.addExecutable(.{ .name = "test_ts_fail", .root_module = ts_fail_mod });
    b.installArtifact(ts_fail_exe);
    const ts_fail_cmd = b.addRunArtifact(ts_fail_exe);
    ts_fail_cmd.step.dependOn(b.getInstallStep());
    const ts_fail_step = b.step("test-ts-fail", "Debug typescript.js semantic failure");
    ts_fail_step.dependOn(&ts_fail_cmd.step);

    // ── Full pipeline profile harness ──
    const pl_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_pipeline_profile.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    pl_mod.addImport("ez", test_mod);
    const pl_exe = b.addExecutable(.{ .name = "test_pipeline_profile", .root_module = pl_mod });
    b.installArtifact(pl_exe);
    const pl_cmd = b.addRunArtifact(pl_exe);
    pl_cmd.step.dependOn(b.getInstallStep());
    const pl_step = b.step("test-pipeline-profile", "Full pipeline profile harness for sampling");
    pl_step.dependOn(&pl_cmd.step);

    // ── Sem split parity test ──
    const sp_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_sem_split_parity.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    sp_mod.addImport("ez", test_mod);
    const sp_exe = b.addExecutable(.{ .name = "test_sem_split_parity", .root_module = sp_mod });
    b.installArtifact(sp_exe);
    const sp_cmd = b.addRunArtifact(sp_exe);
    sp_cmd.step.dependOn(b.getInstallStep());
    const sp_step = b.step("test-sem-split-parity", "Verify resolveFullScope+resolveFullCfg ≡ resolveFull");
    sp_step.dependOn(&sp_cmd.step);

    // ── Production Phase 1 timing ──
    const p1_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_phase1_prod.zig"),
        .target = target, .optimize = .ReleaseFast,
    });
    p1_mod.addImport("ez", test_mod);
    const p1_exe = b.addExecutable(.{ .name = "test_phase1_prod", .root_module = p1_mod });
    b.installArtifact(p1_exe);
    const p1_cmd = b.addRunArtifact(p1_exe);
    p1_cmd.step.dependOn(b.getInstallStep());
    const p1_step = b.step("test-phase1-prod", "Time production Phase 1 buildBitmaps");
    p1_step.dependOn(&p1_cmd.step);

    // ── Real lex-parse pipeline (with shared token buffer) ──
    const real_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_pipeline_real.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    real_mod.addImport("ez", test_mod);
    const real_exe = b.addExecutable(.{ .name = "test_pipeline_real", .root_module = real_mod });
    const real_cmd = b.addRunArtifact(real_exe);
    real_cmd.step.dependOn(b.getInstallStep());
    const real_step = b.step("test-real", "Real lex-parse pipeline benchmark");
    real_step.dependOn(&real_cmd.step);

    // ── 3-stage real pipeline (lex || parse || sem) ──
    const p3_mod = b.createModule(.{
        .root_source_file = b.path("bench/test_pipeline_3stage.zig"),
        .target = target,
        .optimize = .ReleaseFast,
    });
    p3_mod.addImport("ez", test_mod);
    const p3_exe = b.addExecutable(.{ .name = "test_pipeline_3stage", .root_module = p3_mod });
    const p3_cmd = b.addRunArtifact(p3_exe);
    p3_cmd.step.dependOn(b.getInstallStep());
    const p3_step = b.step("test-3stage", "3-stage real pipeline benchmark");
    p3_step.dependOn(&p3_cmd.step);

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
    if (b.args) |args| test_pipeline_cmd.addArgs(args);
    const test_pipeline_step = b.step("test-pipeline", "Isolate lintFilesPipelined crash (7 runs, gpa, real files)");
    test_pipeline_step.dependOn(&test_pipeline_cmd.step);

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

    // ── Bun-subprocess linter pool ───────────────────────────────
    // Zig host + N forked Bun processes; vendored Bun binary embedded via
    // @embedFile at src/bun/bun-aarch64-darwin (symlinked from
    // vendor/bun/bun-aarch64-darwin). Currently macOS-arm64 only — wider
    // platform coverage needs the per-target Bun binaries vendored.
    //
    // ReleaseFast for the host by default — Debug Zig is 5-10× slower for
    // the parser/CFG hot loops. Override with -Doptimize=Debug for host
    // debugging; the JS workers (bun-worker.js) run in Bun regardless.
    if (target.result.os.tag == .macos) {
        const bun_optimize = if (optimize == .Debug) std.builtin.OptimizeMode.ReleaseFast else optimize;

        const bun_pool_mod = b.createModule(.{
            .root_source_file = b.path("src/bun/bun_lint_pool.zig"),
            .target = target,
            .optimize = bun_optimize,
        });
        bun_pool_mod.link_libc = true;
        bun_pool_mod.addImport("ez", test_mod);
        const bun_pool = b.addExecutable(.{ .name = "bun-lint-pool", .root_module = bun_pool_mod });
        b.installArtifact(bun_pool);
    }
}
