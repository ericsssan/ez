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

        // ── Phase 1: Load rules ─────────────────────────────────
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

        var rule_count: u32 = 0;
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

        lint_engine.buildDispatch();

        // ── Phase 1b: Extract handler sources for compilation ───
        var total_handlers: u32 = 0;
        var total_messages: u32 = 0;
        for (0..lint_engine.ruleCount()) |ri| {
            const extracted = lint_engine.extractHandlerSources(ri) catch continue;
            total_handlers += @intCast(extracted.handlers.items.len);
            total_messages += @intCast(extracted.messages.count());
        }
        try stdout.print("{d} handlers extracted, {d} messages\n", .{ total_handlers, total_messages });

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

        // ── Phase 3: Lint ───────────────────────────────────────
        var total_diags: u32 = 0;
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        for (corpus_sources.items) |src| {
            total_diags += lint_engine.lintSource(src, arena_impl.allocator());
            _ = arena_impl.reset(.retain_capacity);
        }
        arena_impl.deinit();

        try stdout.print("{d} rules, {d} files, {d} diags (eval {d}ms, create {d}ms, parse {d}ms, dispatch {d}ms)\n", .{
            rule_count,
            corpus_sources.items.len,
            total_diags,
            lint_engine.eval_ns / 1_000_000,
            lint_engine.create_ns / 1_000_000,
            lint_engine.parse_ns / 1_000_000,
            lint_engine.dispatch_ns / 1_000_000,
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
