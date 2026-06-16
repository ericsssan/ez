// HAND-WRITTEN.
// Rule: no-duplicate-imports
// Disallow duplicate module imports.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-imports",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow duplicate module imports.",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = false;

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Import/export declaration kind, mirroring ESLint's getImportExportType().
const DeclKind = enum {
    side_effect,       // import "m"
    default,           // import x from "m"
    named,             // import { x } from "m"
    namespace,         // import * as ns from "m"
    export_specifier,  // export { x } from "m"
    export_all,        // export * from "m"
    export_namespace,  // export * as ns from "m"
};

/// Returns true when two declarations can be merged — they represent a true
/// duplicate requiring consolidation.  Mirrors isImportExportCanBeMerged().
fn canBeMerged(k1: DeclKind, k2: DeclKind) bool {
    // export * (non-namespaced) cannot merge with anything except another
    // export * or a bare side-effect import.
    if (k1 == .export_all and k2 != .export_all and k2 != .side_effect) return false;
    if (k2 == .export_all and k1 != .export_all and k1 != .side_effect) return false;

    // Namespace vs Named cannot merge.
    const k1_ns = k1 == .namespace or k1 == .export_namespace;
    const k2_ns = k2 == .namespace or k2 == .export_namespace;
    const k1_named = k1 == .named or k1 == .export_specifier;
    const k2_named = k2 == .named or k2 == .export_specifier;
    if ((k1_ns and k2_named) or (k2_ns and k1_named)) return false;

    return true;
}

/// Determine the kind for an import_decl node using its ImportData specifiers.
fn importDeclKind(ctx: *const LintContext, import_data: ast.ImportData) DeclKind {
    const spec_start = import_data.specifiers_start;
    const spec_end = import_data.specifiers_end;
    if (spec_end <= spec_start) return .side_effect;
    const sr = ast.SubRange{ .start = spec_start, .end = spec_end };
    var found_default = false;
    for (ctx.extraSlice(sr)) |raw| {
        const spec: NodeIndex = @enumFromInt(raw);
        switch (ctx.nodeTag(spec)) {
            .import_namespace_specifier => return .namespace,
            .import_specifier => return .named,
            .import_default_specifier => { found_default = true; },
            else => {},
        }
    }
    return if (found_default) .default else .side_effect;
}

/// Returns true if this export node is a declaration-level type-only export:
/// `export type { … } from "m"` or `export type * from "m"`.
/// Does NOT fire for `export { type Foo } from "m"` (inline type specifier).
fn exportIsTypeOnly(ctx: *const LintContext, node: NodeIndex) bool {
    const main_tok = ctx.nodeMainToken(node);
    if (main_tok + 1 >= @as(u32, @intCast(ctx.ast.tokens.len))) return false;
    return std.mem.eql(u8, ctx.tokenText(main_tok + 1), "type");
}

/// Recorded state for one seen import/export-from declaration.
const Entry = struct {
    specifier: []const u8,  // module string without surrounding quotes
    kind: DeclKind,
    is_type: bool,          // declaration-level type only (import type / export type)
    is_import: bool,        // true = import, false = export-from
};

/// Compute the span of an import/export statement, extending to include the
/// optional trailing semicolon (ESLint reports spans that include the `;`).
fn stmtSpan(ctx: *const LintContext, node: NodeIndex) @import("es_parser").span.Span {
    var sp = ctx.nodeSpan(node);
    if (sp.end < ctx.ast.source.len and ctx.ast.source[sp.end] == ';') {
        sp.end += 1;
    }
    return sp;
}

/// Report if `node` duplicates any already-seen entry in `entries`.
fn checkAndReport(
    ctx: *const LintContext,
    node: NodeIndex,
    entries: []const Entry,
    specifier: []const u8,
    kind: DeclKind,
    is_type: bool,
    is_import: bool,
    allow_separate_type: bool,
) void {
    var seen_import = false;
    var seen_export = false;

    for (entries) |e| {
        if (!std.mem.eql(u8, e.specifier, specifier)) continue;
        // allowSeparateTypeImports: skip comparisons between different type kinds.
        if (allow_separate_type and (is_type != e.is_type)) continue;
        // Type-only special case: both type-only + one default + one named → cannot merge.
        if (is_type and e.is_type) {
            const cur_named = kind == .named or kind == .export_specifier;
            const cur_default = kind == .default;
            const prev_named = e.kind == .named or e.kind == .export_specifier;
            const prev_default = e.kind == .default;
            if ((cur_default and prev_named) or (prev_default and cur_named)) continue;
        }
        if (!canBeMerged(kind, e.kind)) continue;
        if (e.is_import) {
            seen_import = true;
        } else {
            seen_export = true;
        }
    }

    const sp = stmtSpan(ctx, node);
    const data = [_]MessageDataEntry{.{ .key = "module", .val = specifier }};
    if (is_import) {
        if (seen_import) ctx.reportSpanWithMessageIdAndData(sp, "import", &data);
        if (seen_export) ctx.reportSpanWithMessageIdAndData(sp, "importAs", &data);
    } else {
        if (seen_export) ctx.reportSpanWithMessageIdAndData(sp, "export", &data);
        if (seen_import) ctx.reportSpanWithMessageIdAndData(sp, "exportAs", &data);
    }
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const alloc = ctx.allocator;

    // Parse options.
    var include_exports = false;
    var allow_separate_type = false;
    if (ctx.getOptions()) |o| {
        if (o.* == .object) {
            if (o.object.get("includeExports")) |ie| {
                if (ie == .bool) include_exports = ie.bool;
            }
            if (o.object.get("allowSeparateTypeImports")) |ast_opt| {
                if (ast_opt == .bool) allow_separate_type = ast_opt.bool;
            }
        }
    }

    // Get program root body.
    const root: NodeIndex = @enumFromInt(0);
    if (ctx.nodeTag(root) != .root) return;
    const d_root = ctx.nodeData(root);
    const sr = ast.SubRange{ .start = @intFromEnum(d_root.lhs), .end = @intFromEnum(d_root.rhs) };
    const stmts = ctx.extraSlice(sr);

    var entries: std.ArrayList(Entry) = .empty;
    defer entries.deinit(alloc);

    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(stmt);

        switch (tag) {
            .import_decl => {
                const d = ctx.nodeData(stmt);
                // Skip TS import alias: `import x = require(...)` has d.lhs = .none
                if (d.lhs == .none) continue;
                const extra_idx: u32 = @intFromEnum(d.lhs);
                const import_data = ctx.extraData(ast.ImportData, extra_idx);
                const source = import_data.source;
                if (source == .none) continue;
                const raw_spec = ctx.tokenText(ctx.nodeMainToken(source));
                if (raw_spec.len < 2) continue;
                const specifier = raw_spec[1 .. raw_spec.len - 1];
                const is_type = ctx.importDeclIsTypeOnly(stmt);
                const kind = importDeclKind(ctx, import_data);
                checkAndReport(ctx, stmt, entries.items, specifier, kind, is_type, true, allow_separate_type);
                entries.append(alloc, .{
                    .specifier = specifier,
                    .kind = kind,
                    .is_type = is_type,
                    .is_import = true,
                }) catch return;
            },
            .export_named_from => {
                if (!include_exports) continue;
                const d = ctx.nodeData(stmt);
                if (d.lhs == .none) continue;
                const extra_idx: u32 = @intFromEnum(d.lhs);
                const import_data = ctx.extraData(ast.ImportData, extra_idx);
                const source = import_data.source;
                if (source == .none) continue;
                const raw_spec = ctx.tokenText(ctx.nodeMainToken(source));
                if (raw_spec.len < 2) continue;
                const specifier = raw_spec[1 .. raw_spec.len - 1];
                const is_type = exportIsTypeOnly(ctx, stmt);
                const kind = DeclKind.export_specifier;
                checkAndReport(ctx, stmt, entries.items, specifier, kind, is_type, false, allow_separate_type);
                entries.append(alloc, .{
                    .specifier = specifier,
                    .kind = kind,
                    .is_type = is_type,
                    .is_import = false,
                }) catch return;
            },
            .export_all => {
                if (!include_exports) continue;
                const d = ctx.nodeData(stmt);
                // d.lhs = source node (string_literal), d.rhs = exported name (or .none)
                const source = d.lhs;
                if (source == .none) continue;
                const raw_spec = ctx.tokenText(ctx.nodeMainToken(source));
                if (raw_spec.len < 2) continue;
                const specifier = raw_spec[1 .. raw_spec.len - 1];
                const is_type = exportIsTypeOnly(ctx, stmt);
                // export * as ns → ExportNamespaceSpecifier; export * → ExportAll
                const kind: DeclKind = if (d.rhs != .none) .export_namespace else .export_all;
                checkAndReport(ctx, stmt, entries.items, specifier, kind, is_type, false, allow_separate_type);
                entries.append(alloc, .{
                    .specifier = specifier,
                    .kind = kind,
                    .is_type = is_type,
                    .is_import = false,
                }) catch return;
            },
            else => {},
        }
    }
}
