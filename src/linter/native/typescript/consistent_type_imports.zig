// HAND-WRITTEN.
// Rule: @typescript-eslint/consistent-type-imports
//
// Enforces consistent use of `import type` vs value imports.
// Default (prefer: 'type-imports'):
//   - If ALL specifiers in an import are type-only → fire typeOverValue
//   - If SOME specifiers are type-only → fire someImportsAreOnlyTypes
// With prefer: 'no-type-imports':
//   - If top-level `import type` → fire avoidImportType
//   - If any specifier has inline `type` qualifier → fire avoidImportType per specifier
// disallowTypeAnnotations (default true): fire noImportTypeAnnotations on `import('mod')` in type position.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Span = @import("es_parser").span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-type-imports",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce consistent usage of type imports",
    .fixable = true,
    .lang = .ts_only,
};

pub const needs_semantic = true;
pub const needs_ref_ranges = true;

pub const relevant_tags = [_]Node.Tag{ .import_decl, .ts_import_type };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .import_decl => runImportDecl(node, ctx),
        .ts_import_type => runImportType(node, ctx),
        else => {},
    }
}

fn runImportDecl(node: NodeIndex, ctx: *const LintContext) void {
    const prefer_no_type = isPrefNoType(ctx);
    const is_top_type = ctx.importDeclIsTypeOnly(node);

    if (prefer_no_type) {
        // no-type-imports: remove all `type` qualifiers
        if (is_top_type) {
            // `import type { ... }` — report whole statement
            var sp = ctx.nodeSpan(node);
            extendSemi(&sp, ctx);
            ctx.reportSpanWithMessageId(sp, "avoidImportType");
            return;
        }
        // check per-specifier inline `type` qualifiers
        const data = ctx.nodeData(node);
        if (data.lhs == .none) return;
        const id = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
        if (id.specifiers_start >= id.specifiers_end or
            id.specifiers_end > ctx.ast.extra_data.len) return;
        for (ctx.ast.extra_data[id.specifiers_start..id.specifiers_end]) |raw| {
            const sp: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(sp) != .import_specifier) continue;
            if (!ctx.importSpecifierIsTypeOnly(sp)) continue;
            ctx.reportSpanWithMessageId(spanOfInlineTypeSpecifier(sp, ctx), "avoidImportType");
        }
        return;
    }

    // prefer: 'type-imports' (default)
    // Already an `import type` — valid, skip.
    if (is_top_type) return;

    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const id = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
    if (id.specifiers_start >= id.specifiers_end or
        id.specifiers_end > ctx.ast.extra_data.len) return;

    // Only consider specifiers that don't already have an inline `type` qualifier.
    // Inline-typed specifiers (`import { type Foo }`) are already explicitly typed
    // and are not candidates for typeOverValue / someImportsAreOnlyTypes.
    var checked_count: usize = 0;
    var type_only_count: usize = 0;

    for (ctx.ast.extra_data[id.specifiers_start..id.specifiers_end]) |raw| {
        const sp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(sp) == .import_specifier and ctx.importSpecifierIsTypeOnly(sp)) continue;
        checked_count += 1;
        if (specifierIsTypeOnly(sp, ctx)) type_only_count += 1;
    }

    if (checked_count == 0 or type_only_count == 0) return;

    var import_sp = ctx.nodeSpan(node);
    extendSemi(&import_sp, ctx);

    if (type_only_count == checked_count) {
        ctx.reportSpanWithMessageId(import_sp, "typeOverValue");
    } else {
        ctx.reportSpanWithMessageId(import_sp, "someImportsAreOnlyTypes");
    }
}

fn runImportType(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.getOptionBool("disallowTypeAnnotations", true)) return;
    ctx.reportSpanWithMessageId(spanOfTsImportType(node, ctx), "noImportTypeAnnotations");
}

fn isPrefNoType(ctx: *const LintContext) bool {
    const s = ctx.getOptionString("prefer") orelse return false;
    return std.mem.eql(u8, s, "no-type-imports");
}

/// Returns true iff all references to the specifier's local binding are in type positions.
/// Callers must pre-filter inline-typed specifiers (`import { type Foo }`) before calling this.
fn specifierIsTypeOnly(sp: NodeIndex, ctx: *const LintContext) bool {
    // Check symbol references.  The local binding node differs by specifier kind:
    //   import_specifier:           lhs=imported, rhs=local (rhs may be .none → use lhs)
    //   import_default_specifier:   lhs=local
    //   import_namespace_specifier: lhs=local
    const tag = ctx.nodeTag(sp);
    const d = ctx.nodeData(sp);
    const local: NodeIndex = switch (tag) {
        .import_specifier => if (d.rhs != .none) d.rhs else d.lhs,
        .import_default_specifier, .import_namespace_specifier => d.lhs,
        else => return false,
    };
    if (local == .none) return false;
    const sym = ctx.symbolForDeclNode(local) orelse return false;
    if (ctx.symbolIsTypeOnly(sym)) {
        // es-parser doesn't emit a `read` ref for the implicit JSX factory
        // (issue #34): when a file uses intrinsic JSX (`<div/>`), the classic
        // runtime calls `<pragma>.createElement`, but no reference is recorded
        // for the pragma binding — so a default import of the factory looks
        // type-only and would FP.  Suppress ONLY for the actual factory import:
        // a default import whose name matches the JSX pragma, in a file that
        // contains JSX elements.  A genuinely type-only default import (or any
        // import in a JSX-free file) is still reported.  The node scan is gated
        // behind the cheap name check so it runs only for that rare candidate.
        if (tag == .import_default_specifier and ctx.language.isJsx() and
            importIsJsxFactory(local, ctx) and fileHasJsxElement(ctx)) return false;
        return true;
    }
    // es-parser emits `read` (not `type_read`) for specifiers inside
    // `export type { X }` declarations (issue #33). Check if ALL the
    // non-type references to this symbol come from type-only export specifiers.
    return ctx.symbolRefsAllInTypeExports(sym);
}

/// True when `local` (a default-import binding) names the JSX factory pragma —
/// the leading identifier of the classic-runtime factory. Defaults to `React`;
/// honours `settings.react.pragma` when configured.
fn importIsJsxFactory(local: NodeIndex, ctx: *const LintContext) bool {
    const name = ctx.tokenText(ctx.nodeMainToken(local));
    return std.mem.eql(u8, name, jsxFactoryPragma(ctx));
}

fn jsxFactoryPragma(ctx: *const LintContext) []const u8 {
    const settings = ctx.getSettings() orelse return "React";
    if (settings.* != .object) return "React";
    const react = settings.object.get("react") orelse return "React";
    if (react != .object) return "React";
    const pragma = react.object.get("pragma") orelse return "React";
    if (pragma != .string) return "React";
    return pragma.string;
}

/// True when the file contains at least one JSX element / fragment — the
/// condition under which the implicit JSX-factory reference exists.
fn fileHasJsxElement(ctx: *const LintContext) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        switch (ctx.nodeTag(ni)) {
            .jsx_element, .jsx_self_closing, .jsx_fragment => return true,
            else => {},
        }
    }
    return false;
}

fn extendSemi(sp: *Span, ctx: *const LintContext) void {
    const src = ctx.ast.source;
    if (sp.end < src.len and src[sp.end] == ';') sp.end += 1;
}

/// Span of `type A` for an inline-type-qualified specifier.
/// main_token of import_specifier = imported name; `type` is at main_tok - 1.
fn spanOfInlineTypeSpecifier(sp: NodeIndex, ctx: *const LintContext) Span {
    const main_tok = ctx.nodeMainToken(sp);
    const type_tok = main_tok - 1;
    const start = ctx.ast.tokenStart(type_tok);
    const name_end = ctx.ast.tokenStart(main_tok) + ctx.ast.tokens.items(.len)[main_tok];
    return .{ .start = @intCast(start), .end = @intCast(name_end) };
}

/// Span of a `ts_import_type` node: covers `import('mod')` or `import('mod').X.Y`.
fn spanOfTsImportType(node: NodeIndex, ctx: *const LintContext) Span {
    const main_tok = ctx.nodeMainToken(node);
    const start = ctx.ast.tokenStart(main_tok);
    const src = ctx.ast.source;
    var i: usize = start;
    // Advance past `import` to find `(`
    while (i < src.len and src[i] != '(') i += 1;
    var depth: i32 = 0;
    while (i < src.len) : (i += 1) {
        const c = src[i];
        if (c == '(') {
            depth += 1;
        } else if (c == ')') {
            depth -= 1;
            if (depth == 0) {
                i += 1;
                break;
            }
        }
    }
    // Consume optional member accesses: `.Foo.Bar`
    while (i < src.len and src[i] == '.') {
        i += 1;
        while (i < src.len and isIdentChar(src[i])) i += 1;
    }
    return .{ .start = @intCast(start), .end = @intCast(i) };
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}
