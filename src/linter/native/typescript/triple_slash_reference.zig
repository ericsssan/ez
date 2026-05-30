// HAND-WRITTEN.
// Rule: @typescript-eslint/triple-slash-reference
//
// Reports `/// <reference ... />` directives based on per-attribute
// options (`path`, `types`, `lib`).  The default is to allow `path`
// always, ban `types` when followed by a matching import, and allow
// `lib` always.  Options can override per-attribute.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "triple-slash-reference",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow certain triple slash directives in favor of ES6-style import declarations",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

const Pref = enum { always, never, prefer_import };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    const path_pref = readPref(ctx, "path", .never);
    const types_pref = readPref(ctx, "types", .prefer_import);
    const lib_pref = readPref(ctx, "lib", .always);
    // Source scan — triple-slash directives only appear before the
    // first non-comment token.  We scan the entire source for `///`
    // line comments matching `/// <reference TYPE="MOD" />`.
    const src = ctx.ast.source;
    var i: usize = 0;
    var has_matching_import = std.StringHashMapUnmanaged(void){};
    defer has_matching_import.deinit(ctx.allocator);
    // Build set of imported module specifiers (first pass).
    collectImports(src, &has_matching_import, ctx.allocator);
    while (i < src.len) {
        // Skip over block comments — `///` inside `/* */` is content.
        if (i + 1 < src.len and src[i] == '/' and src[i + 1] == '*') {
            i += 2;
            while (i + 1 < src.len and !(src[i] == '*' and src[i + 1] == '/')) i += 1;
            if (i + 1 < src.len) i += 2 else i = src.len;
            continue;
        }
        if (i + 3 < src.len and src[i] == '/' and src[i + 1] == '/' and src[i + 2] == '/') {
            // Line comment starting with `///`.  Scan to EOL.
            const line_start = i;
            i += 3;
            const body_start = i;
            while (i < src.len and src[i] != '\n') i += 1;
            const body = src[body_start..i];
            // Parse `<reference TYPE="MOD" />`.
            const parsed = parseReference(body) orelse continue;
            const allowed = isAllowed(parsed.kind, parsed.value, path_pref, types_pref, lib_pref, &has_matching_import);
            if (allowed) continue;
            ctx.reportSpanWithMessageId(.{
                .start = @intCast(line_start),
                .end = @intCast(i),
            }, "tripleSlashReference");
        } else {
            // Skip strings to avoid matching `///` inside them.
            if (src[i] == '"' or src[i] == '\'' or src[i] == '`') {
                const q = src[i];
                i += 1;
                while (i < src.len) : (i += 1) {
                    if (src[i] == '\\') { i += 1; continue; }
                    if (src[i] == q) { i += 1; break; }
                }
                continue;
            }
            i += 1;
        }
    }
}

fn readPref(ctx: *const LintContext, key: []const u8, default: Pref) Pref {
    const s = ctx.getOptionString(key) orelse return default;
    if (std.mem.eql(u8, s, "always")) return .always;
    if (std.mem.eql(u8, s, "never")) return .never;
    if (std.mem.eql(u8, s, "prefer-import")) return .prefer_import;
    return default;
}

const Parsed = struct { kind: []const u8, value: []const u8 };

fn parseReference(body: []const u8) ?Parsed {
    // Trim leading whitespace.
    var s: usize = 0;
    while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
    if (s >= body.len or body[s] != '<') return null;
    s += 1;
    // Expect `reference`.
    const kw = "reference";
    if (s + kw.len > body.len) return null;
    if (!std.mem.eql(u8, body[s .. s + kw.len], kw)) return null;
    s += kw.len;
    // Find attribute name (path / types / lib).
    while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
    const name_start: usize = s;
    while (s < body.len and body[s] != '=' and body[s] != ' ' and body[s] != '\t') s += 1;
    const name = body[name_start..s];
    if (name.len == 0) return null;
    while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
    if (s >= body.len or body[s] != '=') return null;
    s += 1;
    while (s < body.len and (body[s] == ' ' or body[s] == '\t')) s += 1;
    if (s >= body.len or (body[s] != '"' and body[s] != '\'')) return null;
    const quote = body[s];
    s += 1;
    const val_start = s;
    while (s < body.len and body[s] != quote) s += 1;
    if (s >= body.len) return null;
    const value = body[val_start..s];
    return .{ .kind = name, .value = value };
}

fn isAllowed(
    kind: []const u8,
    value: []const u8,
    path_pref: Pref,
    types_pref: Pref,
    lib_pref: Pref,
    imports: *const std.StringHashMapUnmanaged(void),
) bool {
    var pref: Pref = .always;
    if (std.mem.eql(u8, kind, "path")) pref = path_pref
    else if (std.mem.eql(u8, kind, "types")) pref = types_pref
    else if (std.mem.eql(u8, kind, "lib")) pref = lib_pref;
    return switch (pref) {
        .always => true,
        .never => false,
        .prefer_import => !imports.contains(value),
    };
}

fn collectImports(src: []const u8, set: *std.StringHashMapUnmanaged(void), allocator: std.mem.Allocator) void {
    var i: usize = 0;
    while (i + 6 < src.len) : (i += 1) {
        // Match `import …from "X"`, `import "X"`, `require("X")`.
        if (matchesPrefix(src, i, "import ") or matchesPrefix(src, i, "require(")) {
            // Find first quote on this line.
            const line_start = i;
            var j: usize = i;
            while (j < src.len and src[j] != '\n') {
                if (src[j] == '"' or src[j] == '\'') {
                    const q = src[j];
                    j += 1;
                    const sp_start = j;
                    while (j < src.len and src[j] != q and src[j] != '\n') j += 1;
                    if (j >= src.len or src[j] != q) break;
                    const spec = src[sp_start..j];
                    if (spec.len > 0) {
                        set.put(allocator, spec, {}) catch {};
                    }
                    break;
                }
                j += 1;
            }
            i = if (j > line_start) j else line_start;
        }
    }
}

fn matchesPrefix(src: []const u8, at: usize, pre: []const u8) bool {
    if (at + pre.len > src.len) return false;
    return std.mem.eql(u8, src[at .. at + pre.len], pre);
}
