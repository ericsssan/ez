const std = @import("std");
const Io = std.Io;
const parser = @import("../parser/root.zig");
const Lexer = parser.Lexer;
const parser_mod = @import("../parser/parser.zig");
const semantic_mod = parser.semantic;
const Location = parser.span.Location;
const Severity = parser.diagnostic.Severity;
const Language = parser.token.Language;
const linter = @import("../linter/root.zig");
const linter_mod = linter.linter;
const lint_context_mod = linter.lint_context;
const LintDiagnostic = lint_context_mod.LintDiagnostic;
const Config = linter.config.Config;
const InlineDisables = linter.inline_disable.InlineDisables;

/// Simple spin-lock mutex using std.atomic.Mutex.
/// Provides a blocking `lock()` via busy-wait on `tryLock()`.
const SpinLock = struct {
    inner: std.atomic.Mutex = .unlocked,

    pub fn lock(self: *SpinLock) void {
        while (!self.inner.tryLock()) {
            // Spin until the lock is acquired.
            std.atomic.spinLoopHint();
        }
    }

    pub fn unlock(self: *SpinLock) void {
        self.inner.unlock();
    }
};

/// Result of linting a single file.
pub const FileResult = struct {
    file_path: []const u8,
    /// Pre-formatted diagnostic lines (owned by shared allocator).
    output: []const u8,
    error_count: u32,
    warning_count: u32,
    /// True if the file could not be read or parsed.
    had_error: bool,
};

/// Runs the full lint pipeline (lex -> parse -> semantic -> lint) on
/// multiple files in parallel, collecting formatted results.
pub const ParallelRunner = struct {
    allocator: std.mem.Allocator,
    results: std.ArrayList(FileResult),
    mutex: SpinLock,
    config: ?*const Config = null,

    pub fn init(allocator: std.mem.Allocator) ParallelRunner {
        return .{
            .allocator = allocator,
            .results = .empty,
            .mutex = .{},
        };
    }

    pub fn deinit(self: *ParallelRunner) void {
        for (self.results.items) |r| {
            if (r.output.len > 0) self.allocator.free(r.output);
        }
        self.results.deinit(self.allocator);
    }

    /// Lint all files, distributing work across threads.
    pub fn lintFiles(self: *ParallelRunner, io: Io, files: []const []const u8) !void {
        if (files.len == 0) return;

        const cpu_count = std.Thread.getCpuCount() catch 1;
        const thread_count = @min(files.len, cpu_count);

        if (thread_count <= 1) {
            // Single-threaded fast path.
            for (files) |path| {
                self.lintOneFile(io, path);
            }
            return;
        }

        // Divide files across threads.
        const threads = try self.allocator.alloc(std.Thread, thread_count);
        defer self.allocator.free(threads);

        const chunk_size = (files.len + thread_count - 1) / thread_count;
        var spawned: usize = 0;

        for (0..thread_count) |t| {
            const start = t * chunk_size;
            if (start >= files.len) break;
            const end = @min(start + chunk_size, files.len);
            const chunk = files[start..end];

            threads[t] = std.Thread.spawn(.{}, threadWorker, .{ self, io, chunk }) catch {
                // If we can't spawn, run in current thread.
                for (chunk) |path| {
                    self.lintOneFile(io, path);
                }
                continue;
            };
            spawned += 1;
        }

        // Join all threads.
        for (threads[0..spawned]) |thread| {
            thread.join();
        }
    }

    fn threadWorker(self: *ParallelRunner, io: Io, files: []const []const u8) void {
        for (files) |path| {
            self.lintOneFile(io, path);
        }
    }

    fn lintOneFile(self: *ParallelRunner, io: Io, file_path: []const u8) void {
        // Use a per-file arena for all temporary allocations.
        var arena_impl = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena_impl.deinit();
        const arena = arena_impl.allocator();

        const source = Io.Dir.cwd().readFileAlloc(
            io,
            file_path,
            arena,
            Io.Limit.limited(10 * 1024 * 1024),
        ) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: could not read file\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };

        const lang = Language.fromExtension(file_path) orelse .js;

        var tokens = (Lexer.tokenizeWithLanguage(arena, source, lang) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: tokenization failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        }).tokens;

        const is_module = std.mem.endsWith(u8, file_path, ".mjs") or std.mem.endsWith(u8, file_path, ".mts");
        var tree = parser_mod.Parser.parseWithLanguage(arena, source, tokens.slice(), lang, is_module) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: parsing failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };

        var sem_result = semantic_mod.SemanticAnalyzer.analyze(arena, &tree) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: semantic analysis failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };

        const raw_diagnostics = linter_mod.lint(arena, &tree, &sem_result, self.config) catch {
            const msg = std.fmt.allocPrint(
                self.allocator,
                "{s}: error: linting failed\n",
                .{file_path},
            ) catch "";
            self.appendResult(.{
                .file_path = file_path,
                .output = msg,
                .error_count = 1,
                .warning_count = 0,
                .had_error = true,
            });
            return;
        };

        // Filter by inline disable comments.
        var disables = InlineDisables.parse(arena, source) catch InlineDisables.empty();
        const diagnostics = linter_mod.filterByInlineDisables(arena, raw_diagnostics, &disables, source) catch raw_diagnostics;

        // Count total diagnostics (parse errors + lint diagnostics).
        const total_count = tree.errors.len + diagnostics.len;
        if (total_count == 0) {
            self.appendResult(.{
                .file_path = file_path,
                .output = "",
                .error_count = 0,
                .warning_count = 0,
                .had_error = false,
            });
            return;
        }

        // Format all diagnostics into a single output string.
        var error_count: u32 = 0;
        var warning_count: u32 = 0;

        var output_buf: std.ArrayList(u8) = .empty;

        // Parse errors (always severity "error").
        for (tree.errors) |*err| {
            const loc = Location.fromOffset(source, err.span.start);
            const line = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}: {s}\n", .{
                file_path,
                loc.line + 1,
                loc.column + 1,
                err.severity.symbol(),
                err.message,
            }) catch continue;
            output_buf.appendSlice(arena, line) catch {};
            error_count += 1;
        }

        // Lint diagnostics.
        for (diagnostics) |*diag| {
            switch (diag.severity) {
                .@"error" => error_count += 1,
                .warning => warning_count += 1,
                else => {},
            }
            const loc = Location.fromOffset(source, diag.span.start);
            const line = std.fmt.allocPrint(arena, "{s}:{d}:{d}: {s}({s}): {s}\n", .{
                file_path,
                loc.line + 1,
                loc.column + 1,
                diag.severity.symbol(),
                diag.rule_name,
                diag.message,
            }) catch continue;
            output_buf.appendSlice(arena, line) catch {};
        }

        // Copy the formatted output to the shared allocator so it survives
        // the arena cleanup.
        const buf_slice = output_buf.items;
        const owned_output = if (buf_slice.len > 0)
            self.allocator.dupe(u8, buf_slice) catch ""
        else
            @as([]const u8, "");

        self.appendResult(.{
            .file_path = file_path,
            .output = owned_output,
            .error_count = error_count,
            .warning_count = warning_count,
            .had_error = false,
        });
    }

    fn appendResult(self: *ParallelRunner, result: FileResult) void {
        self.mutex.lock();
        defer self.mutex.unlock();
        self.results.append(self.allocator, result) catch {};
    }

    /// Sort results by file path for deterministic output.
    pub fn sortResults(self: *ParallelRunner) void {
        const items = self.results.items;
        std.sort.pdq(FileResult, items, {}, struct {
            fn lessThan(_: void, a: FileResult, b: FileResult) bool {
                return std.mem.order(u8, a.file_path, b.file_path) == .lt;
            }
        }.lessThan);
    }

    /// Total errors across all files.
    pub fn totalErrors(self: *const ParallelRunner) u32 {
        var n: u32 = 0;
        for (self.results.items) |r| n += r.error_count;
        return n;
    }

    /// Total warnings across all files.
    pub fn totalWarnings(self: *const ParallelRunner) u32 {
        var n: u32 = 0;
        for (self.results.items) |r| n += r.warning_count;
        return n;
    }
};
