/// Cross-file module cache for the type checker.
///
/// Parses and type-checks imported files on demand, caches results per
/// absolute path, and exposes `resolveExportedType` which clones a TypeId
/// from a foreign Checker's TypeStore into the caller's TypeStore.
///
/// Each `lintWithPath()` call creates a fresh ModuleCache — no global shared
/// state, no locking required.

const std = @import("std");
const parser_pkg = @import("es_parser");
const Ast = parser_pkg.ast.Ast;
const Language = parser_pkg.token.Language;
const Lexer = parser_pkg.Lexer;
const Parser = parser_pkg.Parser;
const SemanticAnalyzer = parser_pkg.semantic.SemanticAnalyzer;
const SemanticResult = parser_pkg.semantic.SemanticResult;
const ez_checker = @import("ez_checker");
const Checker = ez_checker.Checker;
const ModuleResolver = ez_checker.ModuleResolver;
const tymod = ez_checker.types;
const TypeId = tymod.TypeId;
const TypeStore = tymod.TypeStore;

pub const ParsedModule = struct {
    gpa: std.mem.Allocator,
    source: []u8,
    ast: Ast,
    semantic: SemanticResult,
    checker: Checker,

    pub fn deinit(self: *ParsedModule) void {
        self.checker.deinit();
        self.semantic.deinit(self.gpa);
        self.ast.deinit(self.gpa);
        self.gpa.free(self.source);
    }
};

pub const ModuleCache = struct {
    gpa: std.mem.Allocator,
    modules: std.StringHashMapUnmanaged(*ParsedModule),
    /// Set of paths currently being resolved — cycle detection.
    loading: std.StringHashMapUnmanaged(void),

    pub fn init(gpa: std.mem.Allocator) ModuleCache {
        return .{ .gpa = gpa, .modules = .empty, .loading = .empty };
    }

    pub fn deinit(self: *ModuleCache) void {
        var it = self.modules.valueIterator();
        while (it.next()) |mod_ptr| {
            mod_ptr.*.deinit();
            self.gpa.destroy(mod_ptr.*);
        }
        self.modules.deinit(self.gpa);
        self.loading.deinit(self.gpa);
    }

    /// Return a ModuleResolver vtable that delegates to this cache.
    pub fn asModuleResolver(self: *ModuleCache) ModuleResolver {
        return .{
            .ctx = @ptrCast(self),
            .resolve_fn = &resolveVtable,
            .module_source_fn = &moduleSourceVtable,
        };
    }

    fn resolveVtable(
        ctx: *anyopaque,
        from_dir: []const u8,
        module_spec: []const u8,
        export_name: []const u8,
        local_store: *TypeStore,
        gpa: std.mem.Allocator,
    ) ?TypeId {
        const mc: *ModuleCache = @ptrCast(@alignCast(ctx));
        return mc.resolveExportedType(from_dir, module_spec, export_name, local_store, gpa);
    }

    fn moduleSourceVtable(
        ctx: *anyopaque,
        from_dir: []const u8,
        module_spec: []const u8,
    ) ?[]const u8 {
        const mc: *ModuleCache = @ptrCast(@alignCast(ctx));
        const abs_path = mc.resolveModulePath(from_dir, module_spec) orelse return null;
        defer mc.gpa.free(abs_path);
        // Load and cache the module; return source slice owned by the cached entry.
        const mod = mc.loadModule(abs_path) orelse return null;
        return mod.source;
    }

    /// Load, parse, and type-check a file at `abs_path`.
    /// Returns null if the file can't be read or fails to parse.
    fn loadModule(self: *ModuleCache, abs_path: []const u8) ?*ParsedModule {
        if (self.modules.get(abs_path)) |m| return m;
        if (self.loading.contains(abs_path)) return null;
        self.loading.put(self.gpa, abs_path, {}) catch return null;
        defer _ = self.loading.remove(abs_path);

        const source = readFileAlloc(self.gpa, abs_path) catch return null;
        errdefer self.gpa.free(source);

        const lang = Language.fromExtension(abs_path) orelse .ts;
        var lex = Lexer.tokenizeWithOptions(self.gpa, source, lang, true) catch {
            self.gpa.free(source);
            return null;
        };
        defer lex.tokens.deinit(self.gpa);

        var tree = Parser.parseWithLanguage(self.gpa, source, lex.tokens.slice(), lang, true) catch {
            self.gpa.free(source);
            return null;
        };
        errdefer tree.deinit(self.gpa);

        var sem = SemanticAnalyzer.analyzeModule(self.gpa, &tree, true) catch {
            tree.deinit(self.gpa);
            self.gpa.free(source);
            return null;
        };
        errdefer sem.deinit(self.gpa);

        // Allocate the heap slot FIRST so ast/semantic live at stable addresses,
        // then init the Checker with pointers into mod.* (not into stack vars).
        const mod = self.gpa.create(ParsedModule) catch {
            sem.deinit(self.gpa);
            tree.deinit(self.gpa);
            self.gpa.free(source);
            return null;
        };
        mod.* = .{
            .gpa = self.gpa,
            .source = source,
            .ast = tree,
            .semantic = sem,
            .checker = undefined,
        };
        mod.checker = Checker.init(self.gpa, &mod.ast, &mod.semantic, .{}) catch {
            mod.ast.deinit(self.gpa);
            mod.semantic.deinit(self.gpa);
            self.gpa.free(mod.source);
            self.gpa.destroy(mod);
            return null;
        };

        self.modules.put(self.gpa, abs_path, mod) catch {
            mod.deinit();
            self.gpa.destroy(mod);
            return null;
        };
        return mod;
    }

    /// Resolve a relative module specifier from `from_dir`.
    /// Returns an owned abs path (caller must free) or null.
    fn resolveModulePath(self: *ModuleCache, from_dir: []const u8, spec: []const u8) ?[]u8 {
        if (!std.mem.startsWith(u8, spec, "./") and
            !std.mem.startsWith(u8, spec, "../")) return self.resolveNpmModulePath(from_dir, spec);

        const joined = std.fs.path.resolve(self.gpa, &.{ from_dir, spec }) catch return null;
        defer self.gpa.free(joined);

        const exts = [_][]const u8{ "", ".ts", ".tsx", ".d.ts", "/index.ts", "/index.tsx" };
        for (exts) |ext| {
            const candidate = std.mem.concat(self.gpa, u8, &.{ joined, ext }) catch continue;
            defer self.gpa.free(candidate);
            if (fileExists(candidate)) return self.gpa.dupe(u8, candidate) catch null;
        }
        return null;
    }

    /// Resolve a bare (npm) module specifier by walking up the directory tree
    /// looking for `node_modules/<spec>` and `node_modules/@types/<unscoped>`.
    /// Returns an owned abs path (caller must free) or null.
    fn resolveNpmModulePath(self: *ModuleCache, from_dir: []const u8, spec: []const u8) ?[]u8 {
        // Reject obviously non-package specifiers (relative paths were handled
        // by the caller, node: builtins aren't on disk).
        if (spec.len == 0) return null;
        if (std.mem.startsWith(u8, spec, "node:")) return null;

        // Walk up the directory tree up to 16 levels looking for node_modules.
        var cur = self.gpa.dupe(u8, from_dir) catch return null;
        defer self.gpa.free(cur);

        var hops: u32 = 0;
        while (hops < 16) : (hops += 1) {
            // Try node_modules/<spec>
            if (self.resolveInNodeModules(cur, spec)) |path| return path;

            // Try @types/<unscoped-name> for scoped packages (@scope/name → @types/scope__name)
            // or simple packages (name → @types/name).
            const unscoped = if (std.mem.startsWith(u8, spec, "@")) blk: {
                const slash = std.mem.indexOfScalar(u8, spec[1..], '/') orelse break :blk null;
                const scope = spec[1 .. slash + 1]; // without @
                const pkg = spec[slash + 2 ..]; // after @scope/
                break :blk std.mem.concat(self.gpa, u8, &.{ scope, "__", pkg }) catch null;
            } else spec;
            if (unscoped) |us| {
                defer if (us.ptr != spec.ptr) self.gpa.free(us);
                const types_spec = std.mem.concat(self.gpa, u8, &.{ "@types/", us }) catch return null;
                defer self.gpa.free(types_spec);
                if (self.resolveInNodeModules(cur, types_spec)) |path| return path;
            }

            // Move up one directory level.
            const parent = std.fs.path.dirname(cur) orelse break;
            if (std.mem.eql(u8, parent, cur)) break; // reached filesystem root
            const next = self.gpa.dupe(u8, parent) catch break;
            self.gpa.free(cur);
            cur = next;
        }
        return null;
    }

    fn resolveInNodeModules(self: *ModuleCache, dir: []const u8, spec: []const u8) ?[]u8 {
        const nm = std.mem.concat(self.gpa, u8, &.{ dir, "/node_modules/", spec }) catch return null;
        defer self.gpa.free(nm);

        // Try package.json "types"/"typings" field first.
        if (self.resolvePackageJsonTypes(nm)) |path| return path;

        // Try common entry points.
        const exts = [_][]const u8{ ".d.ts", "/index.d.ts", ".ts", "/index.ts", "/index.tsx" };
        for (exts) |ext| {
            const candidate = std.mem.concat(self.gpa, u8, &.{ nm, ext }) catch continue;
            defer self.gpa.free(candidate);
            if (fileExists(candidate)) return self.gpa.dupe(u8, candidate) catch null;
        }
        return null;
    }

    fn resolvePackageJsonTypes(self: *ModuleCache, pkg_dir: []const u8) ?[]u8 {
        const pj = std.mem.concat(self.gpa, u8, &.{ pkg_dir, "/package.json" }) catch return null;
        defer self.gpa.free(pj);
        const content = readFileAlloc(self.gpa, pj) catch return null;
        defer self.gpa.free(content);

        // Minimal JSON scan: find "types" or "typings" string key and return the value.
        for ([_][]const u8{ "\"types\"", "\"typings\"" }) |key| {
            const ki = std.mem.indexOf(u8, content, key) orelse continue;
            const after_key = content[ki + key.len ..];
            // Skip whitespace and colon.
            var pos: usize = 0;
            while (pos < after_key.len and (after_key[pos] == ' ' or after_key[pos] == '\t' or
                after_key[pos] == '\n' or after_key[pos] == '\r' or after_key[pos] == ':')) : (pos += 1) {}
            if (pos >= after_key.len or after_key[pos] != '"') continue;
            pos += 1;
            const val_start = pos;
            while (pos < after_key.len and after_key[pos] != '"') : (pos += 1) {}
            if (pos >= after_key.len) continue;
            const rel = after_key[val_start..pos];
            if (rel.len == 0) continue;
            const abs = std.mem.concat(self.gpa, u8, &.{ pkg_dir, "/", rel }) catch continue;
            defer self.gpa.free(abs);
            if (fileExists(abs)) return self.gpa.dupe(u8, abs) catch null;
        }
        return null;
    }

    /// Resolve and clone the TypeId for an exported declaration from another module.
    pub fn resolveExportedType(
        self: *ModuleCache,
        from_dir: []const u8,
        module_spec: []const u8,
        export_name: []const u8,
        local_store: *TypeStore,
        gpa: std.mem.Allocator,
    ) ?TypeId {
        const abs_path = self.resolveModulePath(from_dir, module_spec) orelse return null;
        defer self.gpa.free(abs_path);

        const mod = self.loadModule(abs_path) orelse return null;
        const foreign_id = mod.checker.resolveDeclaredTypePub(export_name) orelse return null;
        return cloneType(&mod.checker.store, foreign_id, local_store, gpa) catch null;
    }
};

// ── File helpers (posix) ──────────────────────────────────────────────────

fn fileExists(path: []const u8) bool {
    var path_buf: [std.fs.max_path_bytes]u8 = undefined;
    if (path.len >= path_buf.len) return false;
    @memcpy(path_buf[0..path.len], path);
    path_buf[path.len] = 0;
    const path_z: [*:0]const u8 = @ptrCast(&path_buf);
    const fd = std.posix.openatZ(std.posix.AT.FDCWD, path_z, .{ .ACCMODE = .RDONLY }, 0) catch return false;
    _ = std.c.close(fd);
    return true;
}

// Blocking I/O for cross-platform file reads — `std.c.fstat`/`std.fs.File`
// aren't available on this Zig's targets; `Io` is the portable path.
var g_io_threaded: std.Io.Threaded = undefined;
var g_io_ready: bool = false;
fn getIo() std.Io {
    if (!g_io_ready) {
        g_io_threaded = std.Io.Threaded.init(std.heap.c_allocator, .{});
        g_io_ready = true;
    }
    return g_io_threaded.io();
}

fn readFileAlloc(gpa: std.mem.Allocator, path: []const u8) ![]u8 {
    return std.Io.Dir.cwd().readFileAlloc(getIo(), path, gpa, std.Io.Limit.limited(16 * 1024 * 1024));
}

// ── Type cloning ─────────────────────────────────────────────────────────

/// Clone a TypeId from `src_store` into `dst_store`, delegating to ez-checker's
/// canonical `TypeStore.cloneTypeInto`.
///
/// Unlike a hand-rolled copy, `cloneTypeInto` duplicates EVERY name/literal
/// string into `dst_store`'s allocator, so the result does not alias
/// `src_store` — required here because the source module's store is freed when
/// its `ParsedModule` is deinit'd, which would otherwise leave the cloned
/// signature param names / object-prop names / literals dangling. It also caps
/// recursion depth, guarding against cyclic types.
pub fn cloneType(
    src_store: *const TypeStore,
    src_id: TypeId,
    dst_store: *TypeStore,
    gpa: std.mem.Allocator,
) std.mem.Allocator.Error!TypeId {
    _ = gpa;
    return dst_store.cloneTypeInto(src_store, src_id, 0);
}
