const std = @import("std");
const Io = std.Io;
const parser_root = @import("parser/root.zig");
const Lexer = parser_root.Lexer;
const parser = @import("parser/parser.zig");
const debug = parser_root.debug;
const diagnostic = parser_root.diagnostic;
const Token = parser_root.token;
const semantic = parser_root.semantic;
const linter_root = @import("linter/root.zig");
const linter = linter_root.linter;
const FileDiscovery = @import("cli/file_discovery.zig").FileDiscovery;
const GitIgnore = linter_root.gitignore.GitIgnore;
const ParallelRunner = @import("cli/parallel.zig").ParallelRunner;
const DiagnosticFormatter = @import("cli/diagnostic_formatter.zig").DiagnosticFormatter;
const Diagnostic = @import("parser/diagnostic.zig").Diagnostic;

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    var stdout_buf: [4096]u8 = undefined;
    var stdout_writer = Io.File.stdout().writer(io, &stdout_buf);
    const stdout = &stdout_writer.interface;

    // ── Parse CLI flags ──────────────────────────────────────
    var file_paths: std.ArrayList([]const u8) = .empty;
    defer file_paths.deinit(init.arena.allocator());
    var dump_tokens = false;
    var dump_ast = true;
    var json_format = false;
    var lint_mode = false;
    var config_path: ?[]const u8 = null;
    var no_config = false;
    var eslint_compat_mode = false;
    var test_quickjs = false;

    for (args[1..]) |arg| {
        if (std.mem.eql(u8, arg, "--dump-tokens")) {
            dump_tokens = true;
            dump_ast = false;
        } else if (std.mem.eql(u8, arg, "--dump-ast")) {
            dump_ast = true;
        } else if (std.mem.eql(u8, arg, "--format=json")) {
            json_format = true;
        } else if (std.mem.eql(u8, arg, "--lint")) {
            lint_mode = true;
            dump_ast = false;
        } else if (std.mem.eql(u8, arg, "--no-config")) {
            no_config = true;
        } else if (std.mem.eql(u8, arg, "--eslint-compat")) {
            eslint_compat_mode = true;
        } else if (std.mem.eql(u8, arg, "--test-quickjs")) {
            test_quickjs = true;
        } else if (std.mem.startsWith(u8, arg, "--config=")) {
            config_path = arg["--config=".len..];
        } else if (std.mem.eql(u8, arg, "--config")) {
            // Next arg is the path — but we don't have lookahead here.
            // Accept --config=path form only for simplicity.
            try stdout.print("Use --config=<path> (with =)\n", .{});
            std.process.exit(1);
        } else if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            try stdout.print(usage_text, .{});
            try stdout.flush();
            return;
        } else if (!std.mem.startsWith(u8, arg, "-")) {
            try file_paths.append(init.arena.allocator(), arg);
        } else {
            try stdout.print("Unknown option: {s}\n", .{arg});
            try stdout.print(usage_text, .{});
            try stdout.flush();
            std.process.exit(1);
        }
    }

    // ── QuickJS test ──────────────────────────────────────────
    if (test_quickjs) {
        const qjs_engine_mod = @import("linter/eslint/qjs_engine.zig");
        const posix = @cImport(@cInclude("time.h"));
        const clockNs = struct {
            fn f() u64 {
                var ts: posix.struct_timespec = undefined;
                _ = posix.clock_gettime(posix.CLOCK_MONOTONIC, &ts);
                return @intCast(@as(i64, ts.tv_sec) * 1_000_000_000 + ts.tv_nsec);
            }
        }.f;
        const t_start = clockNs();

        // ── Phase 1: Load rules (cache or QuickJS) ────────────
        const extractor = @import("linter/eslint/extractor.zig");
        const compiled_mod = @import("linter/eslint/compiled.zig");
        const rule_cache = @import("linter/eslint/rule_cache.zig");
        const layout_mod = @import("parser/layout.zig");
        const cache_path = ".sanz-cache/rules.bin";

        var cached_rules: ?[]rule_cache.CachedRule = rule_cache.readCache(cache_path, allocator);
        var rule_count: u32 = 0;
        var cache_hit = false;

        if (cached_rules) |cr| {
            rule_count = @intCast(cr.len);
            cache_hit = true;
        } else {
            // Cold path: load via QuickJS
            var lint_engine = qjs_engine_mod.QjsLintEngine.init(allocator) orelse {
                try stdout.print("Failed to init lint engine\n", .{});
                try stdout.flush();
                return;
            };
            defer lint_engine.deinit();

            var rule_dir = Io.Dir.cwd().openDir(io, "js/node_modules/eslint/lib/rules", .{ .iterate = true }) catch {
                try stdout.print("Could not open rules dir\n", .{});
                try stdout.flush();
                return;
            };
            var walker = rule_dir.walk(allocator) catch return;
            defer walker.deinit();

            while (true) {
                const entry = (walker.next(io) catch break) orelse break;
                if (entry.kind != .file) continue;
                if (!std.mem.endsWith(u8, entry.basename, ".js")) continue;
                if (std.mem.eql(u8, entry.basename, "index.js")) continue;

                const rule_src = rule_dir.readFileAlloc(io, entry.basename, allocator, Io.Limit.limited(1024 * 1024)) catch continue;
                defer allocator.free(rule_src);

                lint_engine.loadRule(entry.basename[0 .. entry.basename.len - 3], rule_src) catch continue;
                rule_count += 1;
            }

            // Extract and cache
            var cache_list: std.ArrayList(rule_cache.CachedRule) = .empty;
            for (0..lint_engine.ruleCount()) |ri| {
                const extracted = lint_engine.extractHandlerSources(ri) catch continue;
                try cache_list.append(allocator, .{
                    .name = try allocator.dupe(u8, lint_engine.rules.items[ri].name),
                    .handlers = try allocator.dupe(qjs_engine_mod.QjsLintEngine.HandlerSource, extracted.handlers.items),
                    .messages = extracted.messages,
                });
            }
            cached_rules = cache_list.toOwnedSlice(allocator) catch null;

            // Write cache (create dir if needed)
            const cstd = @cImport(@cInclude("sys/stat.h"));
            _ = cstd.mkdir(".sanz-cache", 0o755);
            if (cached_rules) |cr| _ = rule_cache.writeCache(cr, cache_path);
        }

        const t_rules_loaded = clockNs();

        // ── Phase 1b: Compile predicates ────────────────────────
        var total_handlers: u32 = 0;
        var compiled_count: u32 = 0;
        var dispatch = compiled_mod.CompiledDispatch.init();
        var enter_lists: [256]std.ArrayList(compiled_mod.CompiledRule) = undefined;
        var exit_lists: [256]std.ArrayList(compiled_mod.CompiledRule) = undefined;
        for (0..256) |i| {
            enter_lists[i] = .empty;
            exit_lists[i] = .empty;
        }

        var fail_parse: u32 = 0;
        var fail_no_body: u32 = 0;
        var fail_complex: u32 = 0;

        if (cached_rules) |rules| {
            for (rules) |*rule| {
                total_handlers += @intCast(rule.handlers.len);
                for (rule.handlers) |h| {
                    if (extractor.extract(rule.name, .@"error", h.source, &rule.messages, allocator)) |cr| {
                        compiled_count += 1;
                        for (0..layout_mod.tag_count) |t| {
                            const tn = std.mem.span(layout_mod.sanz_tag_name(@intCast(t)));
                            if (std.mem.eql(u8, tn, h.key)) {
                                if (h.is_exit) {
                                    exit_lists[t].append(allocator, cr) catch {};
                                } else {
                                    enter_lists[t].append(allocator, cr) catch {};
                                }
                            }
                        }
                    } else {
                        if (std.mem.startsWith(u8, h.source, "function ")) {
                            fail_parse += 1;
                        } else if (std.mem.startsWith(u8, h.source, "\"")) {
                            fail_no_body += 1;
                        } else {
                            fail_complex += 1;
                        }
                    }
                }
            }
        }

        for (0..256) |i| {
            dispatch.enter[i] = enter_lists[i].toOwnedSlice(allocator) catch &.{};
            dispatch.exit[i] = exit_lists[i].toOwnedSlice(allocator) catch &.{};
        }
        dispatch.finalize();

        const t_compiled = clockNs();

        // ── Phase 2: Pre-read corpus ────────────────────────────
        const corpus_dir = Io.Dir.cwd().openDir(io, "tests/conformance/test262-parser-tests/pass", .{ .iterate = true }) catch {
            try stdout.print("No corpus\n", .{});
            try stdout.flush();
            return;
        };
        var corpus_sources: std.ArrayList([]const u8) = .empty;
        {
            var cw = corpus_dir.walk(allocator) catch return;
            defer cw.deinit();
            while (true) {
                const entry = (cw.next(io) catch break) orelse break;
                if (entry.kind != .file) continue;
                if (!std.mem.endsWith(u8, entry.basename, ".js")) continue;
                if (corpus_sources.items.len >= 1983) break;
                const src = corpus_dir.readFileAlloc(io, entry.basename, allocator, Io.Limit.limited(1024 * 1024)) catch continue;
                try corpus_sources.append(allocator, src);
            }
        }

        const t_corpus_read = clockNs();

        // ── Phase 3: Lint (compiled only) ───────────────────────
        const Lexer_mod = @import("parser/lexer.zig").Lexer;
        const Parser_mod = @import("parser/parser.zig").Parser;
        const parent_builder = @import("parser/parent_builder.zig");

        var total_diags: u32 = 0;
        var compiled_diags: u32 = 0;
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);

        var skipped_files: u32 = 0;

        for (corpus_sources.items) |src| {
            const a = arena_impl.allocator();

            // Token pre-screening: skip files that can't trigger any rule
            if (!compiled_mod.quickScreenSource(src, &dispatch)) {
                skipped_files += 1;
                _ = arena_impl.reset(.retain_capacity);
                continue;
            }

            // Parse
            var tokens = Lexer_mod.tokenize(a, src) catch {
                _ = arena_impl.reset(.retain_capacity);
                continue;
            };
            var tree = Parser_mod.parse(a, src, tokens.slice()) catch {
                _ = arena_impl.reset(.retain_capacity);
                continue;
            };

            // Quick check: any active tag in this file?
            const node_tags = tree.nodes.items(.tag);
            if (!dispatch.hasRelevantNodes(node_tags)) {
                _ = arena_impl.reset(.retain_capacity);
                continue;
            }

            // Only compute parent traversal if we have rules that need it
            const traversal = parent_builder.computeTraversal(&tree, a) catch {
                _ = arena_impl.reset(.retain_capacity);
                continue;
            };

            // Inverted index scan: iterate tag array directly, not DFS
            // For enter-only rules (no exit handlers), skip DFS entirely
            for (node_tags, 0..) |tag, idx_usize| {
                const idx: u32 = @intCast(idx_usize);
                const t = @intFromEnum(tag);
                if (t >= 256) continue;
                const rules = dispatch.enter[t];
                for (rules) |*cr| {
                    if (compiled_mod.evalPreds(cr.predicates, idx, &tree, traversal.parents)) {
                        compiled_diags += 1;
                    }
                }
            }

            // Exit handlers still need DFS order (reverse traversal)
            for (traversal.dfs_events) |ev| {
                if (ev >= 0) continue; // skip enter events
                const idx: u32 = @intCast(~ev);
                if (idx >= tree.nodes.len) continue;
                const t = @intFromEnum(node_tags[idx]);
                if (t >= 256) continue;
                const rules = dispatch.exit[t];
                if (rules.len == 0) continue;
                for (rules) |*cr| {
                    if (compiled_mod.evalPreds(cr.predicates, idx, &tree, traversal.parents)) {
                        compiled_diags += 1;
                    }
                }
            }

            _ = arena_impl.reset(.retain_capacity);
        }
        arena_impl.deinit();

        const t_lint_done = clockNs();
        total_diags = compiled_diags;

        try stdout.print("{d}/{d} compiled, {d} files ({d} skipped), {d} diags {s}\n", .{
            compiled_count,
            total_handlers,
            corpus_sources.items.len,
            skipped_files,
            total_diags,
            if (cache_hit) "(cached)" else "(cold)",
        });
        try stdout.print("  load {d}ms, compile {d}ms, read {d}ms, lint {d}ms\n", .{
            (t_rules_loaded - t_start) / 1_000_000,
            (t_compiled - t_rules_loaded) / 1_000_000,
            (t_corpus_read - t_compiled) / 1_000_000,
            (t_lint_done - t_corpus_read) / 1_000_000,
        });
        try stdout.flush();
        return;
    }

    // ── Lint mode: multi-file support ────────────────────────
    if (file_paths.items.len == 0) {
        try stdout.print(usage_text, .{});
        try stdout.flush();
        return;
    }

    if (lint_mode) {
        // Resolve config once at startup.
        var resolved_config: ?*const Config = null;
        var config_resolver = ConfigResolver.init(allocator);
        defer config_resolver.deinit();

        if (!no_config) {
            if (config_path) |cp| {
                resolved_config = config_resolver.resolveFromPath(io, cp) catch null;
            } else if (eslint_compat_mode) {
                if (Io.Dir.cwd().readFileAlloc(io, ".eslintrc.json", allocator, Io.Limit.limited(1 * 1024 * 1024))) |content| {
                    defer allocator.free(content);
                    if (eslint_compat.parseEslintConfig(allocator, content)) |cfg| {
                        const heap_cfg = try allocator.create(Config);
                        heap_cfg.* = cfg;
                        resolved_config = heap_cfg;
                    } else |_| {}
                } else |_| {}
            } else {
                // Auto-detect sanz.config.json from first file path
                const paths_for_resolve = file_paths.items;
                if (paths_for_resolve.len > 0) {
                    resolved_config = config_resolver.resolveForFile(io, paths_for_resolve[0]);
                }
            }
        }

        const paths = file_paths.items;

        // For a single explicit file, use the fast path.
        if (paths.len == 1 and hasJsExtension(paths[0])) {
            try lintSingleFile(allocator, io, paths[0], resolved_config, stdout);
            return;
        }

        // Multi-file / directory mode: discover files, then lint in parallel.

        // Try to load .gitignore from cwd.
        var gitignore = GitIgnore.init(allocator);
        defer gitignore.deinit();
        if (Io.Dir.cwd().readFileAlloc(io, ".gitignore", allocator, Io.Limit.limited(1 * 1024 * 1024))) |content| {
            defer allocator.free(content);
            gitignore.addPatterns(content) catch {};
        } else |_| {}

        // Discover files.
        var discovery = FileDiscovery.init(allocator);
        defer discovery.deinit();
        discovery.setGitIgnore(&gitignore);

        for (paths) |path| {
            try discovery.addPath(io, path);
        }

        // Apply config include/exclude filtering.
        if (resolved_config) |cfg| {
            discovery.filterByConfig(cfg);
        }

        discovery.sortFiles();
        const files = discovery.getFiles();

        if (files.len == 0) {
            try stdout.print("sanz: no source files found\n", .{});
            try stdout.flush();
            return;
        }

        // Lint all files in parallel.
        var runner = ParallelRunner.init(allocator);
        defer runner.deinit();
        runner.config = resolved_config;
        try runner.lintFiles(io, files);
        runner.sortResults();

        // Output results.
        const results = runner.results.items;
        try DiagnosticFormatter.formatResults(results, stdout);

        const total_errors = runner.totalErrors();
        const total_warnings = runner.totalWarnings();
        try DiagnosticFormatter.formatSummary(
            total_errors,
            total_warnings,
            @intCast(files.len),
            stdout,
        );
        try stdout.flush();

        if (total_errors > 0 or total_warnings > 0) {
            std.process.exit(1);
        }
        return;
    }

    // ── Single-file modes (dump-tokens, dump-ast) ────────────
    // These modes only support a single file.
    const file_path = file_paths.items[0];

    // ── Read source file ─────────────────────────────────────
    const source = Io.Dir.cwd().readFileAlloc(
        io,
        file_path,
        allocator,
        Io.Limit.limited(10 * 1024 * 1024),
    ) catch |err| {
        std.debug.print("Error reading file '{s}': {}\n", .{ file_path, err });
        std.process.exit(1);
    };
    defer allocator.free(source);

    // Detect language for all modes
    const lang = Language.fromExtension(file_path) orelse .js;

    // ── Dump tokens mode ─────────────────────────────────────
    if (dump_tokens) {
        var lexer = Lexer.initWithLanguage(allocator, source, lang);
        while (true) {
            const tok = lexer.next();
            const text = tok.tag.lexeme() orelse blk: {
                const start = tok.start;
                var end = start;
                while (end < source.len and isTokenChar(source[end])) {
                    end += 1;
                }
                if (end == start and start < source.len) end = start + 1;
                break :blk source[start..end];
            };
            try stdout.print("{d:>6} {s:<30} {s}\n", .{ tok.start, @tagName(tok.tag), text });
            if (tok.tag == .eof) break;
        }
        try stdout.flush();
        return;
    }

    // ── Dump AST mode (default) ──────────────────────────────
    if (dump_ast) {
        var tokens = try Lexer.tokenizeWithOptions(allocator, source, lang, isModuleFile(file_path));
        defer tokens.deinit(allocator);

        const is_module = isModuleFile(file_path);
        var tree = try parser.Parser.parseWithLanguage(allocator, source, tokens.slice(), lang, is_module);
        defer tree.deinit(allocator);

        if (tree.errors.len > 0) {
            for (tree.errors) |err| {
                try err.format(source, file_path, stdout);
            }
        }

        if (!json_format) {
            try debug.dumpAst(&tree, stdout);
        } else {
            try diagnostic.formatJson(tree.errors, source, file_path, stdout);
        }
        try stdout.flush();
    }
}

// ── Single-file lint fast path ───────────────────────────────────

/// Lint a single file using the direct pipeline (no parallelism overhead).
fn lintSingleFile(
    allocator: std.mem.Allocator,
    io: Io,
    file_path: []const u8,
    config: ?*const Config,
    stdout: anytype,
) !void {
    const source = Io.Dir.cwd().readFileAlloc(
        io,
        file_path,
        allocator,
        Io.Limit.limited(10 * 1024 * 1024),
    ) catch |err| {
        std.debug.print("Error reading file '{s}': {}\n", .{ file_path, err });
        std.process.exit(1);
    };
    defer allocator.free(source);

    // Detect language from file extension
    const lang = Language.fromExtension(file_path) orelse .js;

    var tokens = try Lexer.tokenizeWithOptions(allocator, source, lang, isModuleFile(file_path));
    defer tokens.deinit(allocator);

    var tree = try parser.Parser.parseWithLanguage(allocator, source, tokens.slice(), lang, isModuleFile(file_path));
    defer tree.deinit(allocator);

    if (tree.errors.len > 0) {
        for (tree.errors) |err| {
            try err.format(source, file_path, stdout);
        }
    }

    var sem_result = try semantic.SemanticAnalyzer.analyze(allocator, &tree);
    defer sem_result.deinit(allocator);

    const raw_diagnostics = try linter.lint(allocator, &tree, &sem_result, config);
    defer allocator.free(raw_diagnostics);

    // Apply inline disable filtering.
    var disables = InlineDisables.parse(allocator, source) catch InlineDisables.empty();
    defer disables.deinit();
    const lint_diagnostics = try linter.filterByInlineDisables(allocator, raw_diagnostics, &disables, source);
    defer allocator.free(lint_diagnostics);

    for (lint_diagnostics) |*diag| {
        try diag.format(source, file_path, stdout);
    }
    try stdout.flush();

    if (lint_diagnostics.len > 0) {
        std.process.exit(1);
    }
}

// ── Helpers ──────────────────────────────────────────────────────

const hasJsExtension = @import("cli/file_discovery.zig").hasJsExtension;

/// Detect if a file should be parsed in module mode based on extension.
/// .mjs, .mts, and *.module.js/ts/jsx/tsx are module files.
fn isModuleFile(path: []const u8) bool {
    if (std.mem.endsWith(u8, path, ".mjs") or std.mem.endsWith(u8, path, ".mts")) return true;
    // test262-parser-tests convention: *.module.js
    if (std.mem.endsWith(u8, path, ".module.js") or std.mem.endsWith(u8, path, ".module.ts") or
        std.mem.endsWith(u8, path, ".module.jsx") or std.mem.endsWith(u8, path, ".module.tsx"))
        return true;
    return false;
}
const Language = Token.Language;
const isTokenChar = Token.isIdentChar;
const Config = linter_root.config.Config;
const ConfigResolver = linter_root.config_resolver.ConfigResolver;
const InlineDisables = linter_root.inline_disable.InlineDisables;
const eslint_compat = linter_root.eslint_compat;

const usage_text =
    \\Usage: sanz [options] <file|directory>...
    \\
    \\Options:
    \\  --lint             Run lint rules
    \\  --config=<path>    Path to sanz.config.json
    \\  --no-config        Disable config file loading (all rules on)
    \\  --eslint-compat    Read .eslintrc.json and map rules
    \\  --dump-tokens      Tokenize and print tokens
    \\  --dump-ast         Parse and print AST (default)
    \\  --format=json      Output diagnostics as JSON
    \\  --help, -h         Show this help
    \\
    \\When --lint is used with directories, all .js/.mjs/.cjs/.ts/.mts/.cts/.tsx/.jsx
    \\files are discovered recursively and linted in parallel.
    \\
    \\Configuration: Place sanz.config.json in your project root.
    \\Inline disable: // sanz-disable-next-line [rule-name]
    \\
;
