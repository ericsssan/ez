const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-imports",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow duplicate module imports",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Import classification for duplicate detection.
/// ESLint tracks 4 distinct buckets per source:
/// - value (non-namespace): import X, import { X }
/// - value namespace: import * as X
/// - type (non-namespace): import type X, import type { X }, import { type X }
/// - type namespace: import type * as X
const ImportKind = enum {
    value_non_ns,
    value_ns,
    type_non_ns,
    type_ns,
};

fn isTypeOnlyToken(ctx: *const LintContext, idx: NodeIndex) bool {
    const main_tok = ctx.nodeMainToken(idx);
    if (main_tok + 1 < ctx.ast.tokens.len) {
        const next = ctx.tokenText(main_tok + 1);
        if (std.mem.eql(u8, next, "type")) return true;
    }
    return false;
}

fn classifyImport(ctx: *const LintContext, idx: NodeIndex) ImportKind {
    const is_type = isTypeOnlyToken(ctx, idx);
    const data = ctx.nodeData(idx);
    if (data.lhs == .none) return .value_non_ns;

    const import_data = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
    const specs = ctx.extraSlice(.{ .start = import_data.specifiers_start, .end = import_data.specifiers_end });

    for (specs) |s| {
        const spec: NodeIndex = @enumFromInt(s);
        if (spec == .none) continue;
        if (ctx.nodeTag(spec) == .import_namespace_specifier) {
            return if (is_type) .type_ns else .value_ns;
        }
    }
    return if (is_type) .type_non_ns else .value_non_ns;
}

fn classifyExport(ctx: *const LintContext, idx: NodeIndex) ImportKind {
    // export { X } from "src" — always value_non_ns for our purposes
    _ = ctx; _ = idx;
    return .value_non_ns;
}

/// True if two kinds conflict (would be a duplicate import).
fn kindsConflict(a: ImportKind, b: ImportKind, allow_separate_type: bool) bool {
    if (allow_separate_type) {
        // Separate buckets: only exact same kind conflicts, except type_non_ns + type_non_ns is OK
        if (a == .type_non_ns and b == .type_non_ns) return false;
        const a_type = a == .type_non_ns or a == .type_ns;
        const b_type = b == .type_non_ns or b == .type_ns;
        if (a_type != b_type) return false; // type vs value: no conflict
        return a == b; // same kind conflicts
    }
    // Without separate types:
    // Two value_non_ns → conflict
    if (a == .value_non_ns and b == .value_non_ns) return true;
    // Two value_ns → conflict
    if (a == .value_ns and b == .value_ns) return true;
    // Two type_ns → conflict
    if (a == .type_ns and b == .type_ns) return true;
    // type_ns + type_non_ns → conflict
    if ((a == .type_ns and b == .type_non_ns) or (b == .type_ns and a == .type_non_ns)) return true;
    // type_non_ns + value_non_ns → conflict (when !allowSeparateTypeImports)
    if ((a == .type_non_ns and b == .value_non_ns) or (b == .type_non_ns and a == .value_non_ns)) return true;
    // type_ns + value_ns → conflict
    if ((a == .type_ns and b == .value_ns) or (b == .type_ns and a == .value_ns)) return true;
    // value_ns + value_non_ns → NO conflict (different import styles)
    // type_non_ns + type_non_ns → NO conflict
    return false;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const allow_separate_type = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("allowSeparateTypeImports")) |v|
                if (v == .bool) break :blk v.bool;
        };
        break :blk false;
    };

    const include_exports = blk: {
        if (ctx.getOptions()) |o| if (o.* == .object) {
            if (o.object.get("includeExports")) |v|
                if (v == .bool) break :blk v.bool;
        };
        break :blk false;
    };

    const count = ctx.nodeCount();

    // Track seen imports/exports: source + kind (up to 256 unique sources × 4 kinds)
    // Use a flat array: pairs of (source, kind)
    var seen_sources: [512][]const u8 = undefined;
    var seen_kinds: [512]ImportKind = undefined;
    var seen_count: usize = 0;

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const idx = NodeIndex.fromInt(i);
        const tag = ctx.nodeTag(idx);

        const is_import = tag == .import_decl;
        const is_export_named = include_exports and tag == .export_named;
        if (!is_import and !is_export_named) continue;

        // Get source text
        const source_text = blk: {
            if (is_import) {
                const data = ctx.nodeData(idx);
                if (data.lhs == .none) continue; // TS import alias
                const import_data = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
                break :blk ctx.tokenText(ctx.ast.nodeMainToken(import_data.source));
            } else {
                // export { X } from "source" — data.rhs = source node
                const data = ctx.nodeData(idx);
                if (data.rhs == .none) continue; // no source (local re-export)
                const source_node: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
                if (source_node == .none) continue;
                // Try to get the source as a string literal
                const sn_tag = ctx.nodeTag(source_node);
                if (sn_tag == .string_literal) break :blk ctx.tokenText(ctx.nodeMainToken(source_node));
                // Otherwise try to use extra data
                continue;
            }
        };

        const kind = if (is_import) classifyImport(ctx, idx) else classifyExport(ctx, idx);

        // Check for conflict with previously seen imports/exports
        var found = false;
        for (seen_sources[0..seen_count], seen_kinds[0..seen_count]) |prev_source, prev_kind| {
            if (!std.mem.eql(u8, prev_source, source_text)) continue;
            if (kindsConflict(prev_kind, kind, allow_separate_type)) {
                ctx.report(idx);
                found = true;
                break;
            }
        }
        // Always store (even duplicates) so later imports see all previous import kinds
        if (seen_count < seen_sources.len) {
            seen_sources[seen_count] = source_text;
            seen_kinds[seen_count] = kind;
            seen_count += 1;
        }
    }
}
