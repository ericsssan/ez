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
const layout = @import("parser/layout.zig");

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
    var profile_phases = false;
    var rule_filter: ?[]const u8 = null;

    var arg_i: usize = 1;
    while (arg_i < args.len) : (arg_i += 1) {
        const arg = args[arg_i];
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
        } else if (std.mem.eql(u8, arg, "--profile-phases")) {
            profile_phases = true;
        } else if (std.mem.eql(u8, arg, "--eslint-compat")) {
            eslint_compat_mode = true;
        } else if (std.mem.startsWith(u8, arg, "--config=")) {
            config_path = arg["--config=".len..];
        } else if (std.mem.eql(u8, arg, "--config")) {
            try stdout.print("Use --config=<path> (with =)\n", .{});
            std.process.exit(1);
        } else if (std.mem.startsWith(u8, arg, "--rule=")) {
            rule_filter = arg["--rule=".len..];
        } else if (std.mem.eql(u8, arg, "--rule")) {
            arg_i += 1;
            if (arg_i >= args.len) {
                try stdout.print("--rule: expected rule name\n", .{});
                std.process.exit(1);
            }
            rule_filter = args[arg_i];
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

        // --rule: build a config with only the named rule enabled; all others off.
        var single_rule_config: ?Config = null;
        defer if (single_rule_config) |*c| c.deinit();
        if (rule_filter) |name| {
            var cfg = Config.initAllOff(allocator);
            const linter_mod = @import("linter/linter.zig");
            for (0..linter_root.rules.count) |i| {
                if (std.mem.eql(u8, linter_mod.rule_names[i], name)) {
                    cfg.rule_severity_table[i] = linter_mod.default_severities[i];
                }
            }
            single_rule_config = cfg;
            resolved_config = &single_rule_config.?;
        }

        if (!no_config and rule_filter == null) {
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
                // Auto-detect ez.config.json from first file path
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
            try stdout.print("ez: no source files found\n", .{});
            try stdout.flush();
            return;
        }

        // Lint all files in parallel.
        var runner = ParallelRunner.init(allocator);
        defer runner.deinit();
        runner.config = resolved_config;
        runner.profile_phases = profile_phases;
        try runner.lintFiles(io, files);
        runner.sortResults();
        if (profile_phases) runner.printTimings();

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
        var lex_result = try Lexer.tokenizeWithOptions(allocator, source, lang, isModuleFile(file_path));
        defer lex_result.deinit(allocator);
        const tok_tags = lex_result.tokens.items(.tag);
        const tok_starts = lex_result.tokens.items(.start);
        for (tok_tags, tok_starts) |tag, start| {
            const text = tag.lexeme() orelse blk: {
                var end = start;
                while (end < source.len and isTokenChar(source[end])) end += 1;
                if (end == start and start < source.len) end = start + 1;
                break :blk source[start..end];
            };
            try stdout.print("{d:>6} {s:<30} {s}\n", .{ start, @tagName(tag), text });
        }
        try stdout.flush();
        return;
    }

    // ── Dump AST mode (default) ──────────────────────────────
    if (dump_ast) {
        const is_module = isModuleFile(file_path);
        var lex = try Lexer.tokenizeWithOptions(allocator, source, lang, is_module);
        defer lex.deinit(allocator);

        var tree = try parser.Parser.parseWithLanguage(allocator, source, lex.tokens.slice(), lang, is_module);
        defer tree.deinit(allocator);

        if (tree.errors.len > 0) {
            for (tree.errors) |err| {
                try err.format(lex.line_starts, source, file_path, stdout);
            }
        }

        if (!json_format) {
            try debug.dumpAst(&tree, stdout);
        } else {
            try diagnostic.formatJson(tree.errors, lex.line_starts, source, file_path, stdout);
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

    var lex_result = try Lexer.tokenizeWithOptions(allocator, source, lang, isModuleFile(file_path));
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;

    var tree = try parser.Parser.parseWithLanguage(allocator, source, tokens.slice(), lang, isModuleFile(file_path));
    defer tree.deinit(allocator);

    if (tree.errors.len > 0) {
        for (tree.errors) |err| {
            try err.format(lex_result.line_starts, source, file_path, stdout);
        }
    }

    var sem_result = try semantic.SemanticAnalyzer.analyzeWithOptions(allocator, &tree, .{
        .build_parents = true,
        .build_ref_ranges = linter.configNeedsRefRanges(config),
    });
    defer sem_result.deinit(allocator);

    const raw_diagnostics = try linter.lint(allocator, &tree, &sem_result, config, lang);
    defer allocator.free(raw_diagnostics);

    // Apply inline disable filtering.  Reuse the lexer's comment list instead
    // of re-scanning the source.
    var disables = InlineDisables.parseFromComments(
        allocator,
        source,
        lex_result.comment_starts,
        lex_result.comment_ends,
        lex_result.comment_kinds,
    ) catch InlineDisables.empty();
    defer disables.deinit();
    const lint_diagnostics = try linter.filterByInlineDisables(allocator, raw_diagnostics, &disables, lex_result.line_starts, source);
    defer allocator.free(lint_diagnostics);

    for (lint_diagnostics) |*diag| {
        try diag.format(lex_result.line_starts, source, file_path, &linter.rule_names, stdout);
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
    \\Usage: ez [options] <file|directory>...
    \\
    \\Options:
    \\  --lint             Run lint rules
    \\  --rule <name>      Run only this rule (overrides config)
    \\  --config=<path>    Path to ez.config.json
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
    \\Configuration: Place ez.config.json in your project root.
    \\Inline disable: // ez-disable-next-line [rule-name]
    \\
;
