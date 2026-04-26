const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-require-imports",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `require()` imports in favor of ES modules",
    .lang = .ts_only,
};

/// Simple pattern match: check if `path` matches a regex-like allow pattern.
/// Handles: anchors (^/$), escaped chars (\.), wildcards. Others treated as literal.
fn pathMatchesPattern(path: []const u8, pattern: []const u8) bool {
    var pat = pattern;
    var check_start = false;
    var check_end = false;

    // Strip leading/trailing `/` from patterns like `/foo/`
    if (pat.len >= 2 and pat[0] == '/' and pat[pat.len - 1] == '/') {
        pat = pat[1 .. pat.len - 1];
    }
    if (pat.len > 0 and pat[0] == '^') { check_start = true; pat = pat[1..]; }
    if (pat.len > 0 and pat[pat.len - 1] == '$') { check_end = true; pat = pat[0 .. pat.len - 1]; }

    // Build unescaped literal part for matching
    var buf: [256]u8 = undefined;
    var blen: usize = 0;
    var pi: usize = 0;
    while (pi < pat.len and blen < buf.len - 1) {
        if (pat[pi] == '\\' and pi + 1 < pat.len) {
            buf[blen] = pat[pi + 1];
            blen += 1;
            pi += 2;
        } else if (pat[pi] == '.') {
            buf[blen] = '.'; // treat as literal for simple paths
            blen += 1;
            pi += 1;
        } else {
            buf[blen] = pat[pi];
            blen += 1;
            pi += 1;
        }
    }
    const literal = buf[0..blen];
    if (literal.len == 0) return true;

    if (check_start and check_end) return std.mem.eql(u8, path, literal);
    if (check_start) return std.mem.startsWith(u8, path, literal);
    if (check_end) return std.mem.endsWith(u8, path, literal);
    return std.mem.indexOf(u8, path, literal) != null;
}

/// Check if the `require` identifier resolves to a local symbol (not global).
fn requireIsLocallyDefined(ctx: *const LintContext, callee: NodeIndex) bool {
    // Find any symbol named "require" in the symbols table that is locally declared.
    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const name = symbols.getName(id);
        if (!std.mem.eql(u8, name, "require")) continue;
        // Check if at non-global scope depth
        const scope_id = symbols.getScope(id);
        if (scopes.depth(scope_id) > 0) return true;
        // Or global scope but with a declaration (imported/defined)
        if (symbols.getFlags(id).isDeclared()) return true;
    }
    _ = callee; // might use for ref lookup in future
    return false;
}

/// Get the argument string from a require('path') call.
fn getRequireArg(ctx: *const LintContext, node: NodeIndex) ?[]const u8 {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return null;
    const args = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const items = ctx.extraSlice(args);
    if (items.len == 0) return null;
    const first_arg: NodeIndex = @enumFromInt(items[0]);
    if (first_arg == .none) return null;
    const arg_tag = ctx.nodeTag(first_arg);
    if (arg_tag == .string_literal) {
        const tok = ctx.nodeMainToken(first_arg);
        const text = ctx.tokenText(tok);
        // Strip quotes
        if (text.len >= 2) return text[1 .. text.len - 1];
    }
    // Template literal without substitutions
    if (arg_tag == .template_literal) {
        const tok = ctx.nodeMainToken(first_arg);
        const text = ctx.tokenText(tok);
        if (text.len >= 2) return text[1 .. text.len - 1];
    }
    return null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // Regular call_expr
    const callee = data.lhs;
    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    if (!std.mem.eql(u8, name, "require")) return;

    // Skip if require is locally defined (not the global require).
    if (requireIsLocallyDefined(ctx, callee)) return;

    // Parse options.
    const allow_as_import = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("allowAsImport")) |v|
                if (v == .bool) break :blk v.bool;
        };
        break :blk false;
    };

    // Check if this require() is inside `import X = require(...)`.
    if (allow_as_import) {
        const parent = ctx.parentOf(node);
        if (parent != .none) {
            const ptag = ctx.nodeTag(parent);
            // import_decl with lhs=.none is `import X = require(...)`.
            if (ptag == .import_decl and ctx.nodeData(parent).lhs == .none) return;
        }
    }

    // Check `allow` option: array of regex patterns for allowed paths.
    if (ctx.getOptions()) |opts| {
        if (opts.* == .object) {
            if (opts.object.get("allow")) |allow_val| {
                if (allow_val == .array) {
                    if (getRequireArg(ctx, node)) |path| {
                        for (allow_val.array.items) |pat_val| {
                            if (pat_val == .string and pathMatchesPattern(path, pat_val.string)) return;
                        }
                    }
                }
            }
        }
    }

    ctx.report(node);
}
