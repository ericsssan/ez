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
    var eslint_rules_dir: ?[]const u8 = null;

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
        } else if (std.mem.startsWith(u8, arg, "--eslint-rules=")) {
            eslint_rules_dir = arg["--eslint-rules=".len..];
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


    // ── ESLint rules mode: load rules from disk, lint with Zig interpreter ──
    if (eslint_rules_dir) |rules_dir| {
        const eslint_loader = @import("linter/eslint/loader.zig");
        const eslint_rules = @import("linter/eslint/rules.zig");
        const parent_builder = @import("parser/parent_builder.zig");
        const semantic_mod = parser_root.semantic;
        const AstQuery = @import("linter/query/ast_query.zig").AstQuery;
        const EsTreeAdapter = @import("linter/query/estree.zig").EsTreeAdapter;

        // Phase 1: Load rules from .js files on disk
        const descriptors = try eslint_loader.loadRulesFromDir(io, rules_dir, allocator);
        var rule_set = try eslint_rules.loadRules(allocator, descriptors);
        defer rule_set.deinit();

        var cached_count: usize = 0;
        var default_opts_count: usize = 0;
        var visitor_count: usize = 0;
        for (rule_set.rules) |r| {
            if (r.cached_create_fn != null) cached_count += 1;
            if (r.cached_default_options != null) default_opts_count += 1;
            visitor_count += r.visitors.len;
        }
        try stdout.print("{d} rules loaded ({d} cached, {d} with defaultOptions, {d} total visitors)\n",
            .{descriptors.len, cached_count, default_opts_count, visitor_count});

        // Phase 2: Collect all .js files (expanding directories)
        var all_files: std.ArrayList([]const u8) = .empty;
        defer all_files.deinit(allocator);
        for (file_paths.items) |path| {
            var dir = Io.Dir.cwd().openDir(io, path, .{ .iterate = true }) catch {
                try all_files.append(allocator, path);
                continue;
            };
            var walker = try dir.walk(allocator);
            defer walker.deinit();
            while (try walker.next(io)) |entry| {
                if (entry.kind != .file) continue;
                const name = entry.basename;
                if (!std.mem.endsWith(u8, name, ".js") and
                    !std.mem.endsWith(u8, name, ".mjs") and
                    !std.mem.endsWith(u8, name, ".cjs")) continue;
                const full = try std.fmt.allocPrint(allocator, "{s}/{s}", .{ path, entry.path });
                try all_files.append(allocator, full);
            }
        }

        // Phase 3: Lint each target file
        var total_diags: u32 = 0;
        var file_count: u32 = 0;
        var per_rule_counts = std.StringArrayHashMap(u32).init(allocator);
        defer per_rule_counts.deinit();

        for (all_files.items) |file_path| {
            // Use a per-file arena so all working memory is freed after each file.
            var file_arena = std.heap.ArenaAllocator.init(allocator);
            defer file_arena.deinit();
            const fa = file_arena.allocator();

            const source = Io.Dir.cwd().readFileAlloc(io, file_path, fa, Io.Limit.limited(10 * 1024 * 1024)) catch continue;

            var tokens_result = Lexer.tokenize(fa, source) catch continue;
            var tree = parser.Parser.parse(fa, source, tokens_result.slice()) catch continue;
            const traversal = parent_builder.computeTraversal(&tree, fa) catch continue;
            var sem_result = semantic_mod.SemanticAnalyzer.analyze(fa, &tree) catch continue;

            var diagnostics_list: std.ArrayList(Diagnostic) = .empty;

            // Build query + adapter for ESTree property access
            // Convert tag names to slices
            var tn_slices: [layout.tag_count][]const u8 = undefined;
            for (0..layout.tag_count) |ti| tn_slices[ti] = std.mem.span(layout.tag_names[ti]);

            // Compute min_tok / max_tok for each node so that
            // tokenBefore() / tokenAfter() work (needed by isParenthesised etc.)
            const n_nodes = tree.nodes.len;
            const main_tokens = tree.nodes.items(.main_token);
            const min_tok_arr = try fa.alloc(u32, n_nodes);
            const max_tok_arr = try fa.alloc(u32, n_nodes);
            // min_tok[i] = main_token of node i (first token heuristic)
            for (0..n_nodes) |ni| min_tok_arr[ni] = main_tokens[ni];
            // max_tok: propagate child maxes to parents using DFS exit events.
            for (0..n_nodes) |ni| max_tok_arr[ni] = main_tokens[ni];
            // DFS events: positive = enter, negative = exit (~idx).
            // Process exit events bottom-up: when we exit a node, its subtree max is finalized.
            for (traversal.dfs_events) |ev| {
                if (ev >= 0) continue; // skip enter events
                const ni: u32 = @intCast(~ev);
                if (ni >= n_nodes) continue;
                const par = traversal.parents[ni];
                const pb = @import("parser/parent_builder.zig");
                if (par != pb.NONE and par < n_nodes) {
                    if (max_tok_arr[ni] > max_tok_arr[par]) max_tok_arr[par] = max_tok_arr[ni];
                    if (min_tok_arr[ni] < min_tok_arr[par]) min_tok_arr[par] = min_tok_arr[ni];
                }
            }

            var query = AstQuery{
                .ast = &tree,
                .parents = traversal.parents,
                .min_tok = min_tok_arr,
                .max_tok = max_tok_arr,
                .tag_names = &tn_slices,
                .source = source,
            };
            var adapter = EsTreeAdapter{
                .query = &query,
                .semantic = &sem_result,
                .node_scope_ids = &.{},
                .arena = fa,
            };

            // Run rules via Zig interpreter
            const node_tags_raw = tree.nodes.items(.tag);
            var node_tags_u8 = try fa.alloc(u8, node_tags_raw.len);
            for (node_tags_raw, 0..) |t, i| node_tags_u8[i] = @intFromEnum(t);

            eslint_rules.runRulesOnFile(
                &rule_set,
                adapter.callbacks(),
                traversal.dfs_events,
                tree.nodes.len,
                node_tags_u8,
                &diagnostics_list,
                fa,
            );

            for (diagnostics_list.items) |d| {
                if (d.rule_name.len > 0) {
                    const key = try allocator.dupe(u8, d.rule_name);
                    const gop = try per_rule_counts.getOrPut(key);
                    if (gop.found_existing) {
                        allocator.free(key);
                        gop.value_ptr.* += 1;
                    } else {
                        gop.value_ptr.* = 1;
                    }
                }
                // Emit per-line diagnostic in parseable format
                const loc = @import("parser/span.zig").Location.fromOffset(source, d.span.start);
                try stdout.print("{s}:{d}:{d}: error({s}): {s}\n", .{
                    file_path, loc.line + 1, loc.column + 1, d.rule_name, d.message,
                });
            }
            total_diags += @intCast(diagnostics_list.items.len);
            file_count += 1;
            // file_arena.deinit() called by defer — frees all per-file allocations
        }

        try stdout.print("{d} files, {d} diagnostics\n", .{ file_count, total_diags });
        // Per-rule breakdown (sorted by count descending)
        const RuleCount = struct { name: []const u8, count: u32 };
        var rule_list = try allocator.alloc(RuleCount, per_rule_counts.count());
        defer allocator.free(rule_list);
        for (per_rule_counts.keys(), per_rule_counts.values(), 0..) |k, v, i| {
            rule_list[i] = .{ .name = k, .count = v };
        }
        std.mem.sort(RuleCount, rule_list, {}, struct {
            fn lt(_: void, a: RuleCount, b: RuleCount) bool { return a.count > b.count; }
        }.lt);
        for (rule_list) |rc| {
            try stdout.print("{d:>6}  {s}\n", .{ rc.count, rc.name });
        }
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
