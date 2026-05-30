// Rule: no-useless-rename
// Reports `import {x as x}`, `export {x as x}`, and `({x: x} = obj)` —
// renames where the alias matches the original name.  Detection-only.
// Mirrors: tests/conformance/eslint/lib/rules/no-useless-rename.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-rename",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow renaming import, export, and destructured assignments to the same name",
};

pub const relevant_tags = [_]Node.Tag{
    .object_pattern,
    .import_specifier,
    .export_specifier,
};

pub const needs_semantic = false;

const Options = struct {
    ignore_destructuring: bool = false,
    ignore_import: bool = false,
    ignore_export: bool = false,
};

fn readOptions(ctx: *const LintContext) Options {
    var o = Options{};
    const v = ctx.rule_options orelse return o;
    if (v.* != .object) return o;
    if (v.object.get("ignoreDestructuring")) |x| if (x == .bool) { o.ignore_destructuring = x.bool; };
    if (v.object.get("ignoreImport")) |x| if (x == .bool) { o.ignore_import = x.bool; };
    if (v.object.get("ignoreExport")) |x| if (x == .bool) { o.ignore_export = x.bool; };
    return o;
}

/// Strip grouping_expr wrappers.
fn stripGrouping(ctx: *const LintContext, node: NodeIndex) NodeIndex {
    var cur = node;
    while (cur != .none and ctx.ast.nodeTag(cur) == .grouping_expr) {
        cur = ctx.ast.nodeData(cur).lhs;
    }
    return cur;
}

/// Compute the cooked identifier name from a raw token text, decoding
/// `\uXXXX` and `\u{XXXX...}` Unicode escapes that ESLint normalises.
/// Returns the unmodified slice when no escape is present.  When an escape
/// is decoded, the result is written into `buf` (caller provides space) and
/// the returned slice points into `buf`.
fn cookedIdent(raw: []const u8, buf: []u8) ?[]const u8 {
    if (std.mem.indexOfScalar(u8, raw, '\\') == null) return raw;
    var w: usize = 0;
    var i: usize = 0;
    while (i < raw.len) {
        const c = raw[i];
        if (c != '\\') {
            if (w >= buf.len) return null;
            buf[w] = c;
            w += 1;
            i += 1;
            continue;
        }
        if (i + 1 >= raw.len or raw[i + 1] != 'u') return null;
        i += 2;
        var cp: u32 = 0;
        if (i < raw.len and raw[i] == '{') {
            i += 1;
            while (i < raw.len and raw[i] != '}') : (i += 1) {
                const d = hexDigit(raw[i]) orelse return null;
                cp = cp * 16 + d;
                if (cp > 0x10FFFF) return null;
            }
            if (i >= raw.len) return null;
            i += 1; // skip '}'
        } else {
            if (i + 4 > raw.len) return null;
            var k: usize = 0;
            while (k < 4) : (k += 1) {
                const d = hexDigit(raw[i + k]) orelse return null;
                cp = cp * 16 + d;
            }
            i += 4;
        }
        // Encode codepoint as UTF-8.
        var tmp: [4]u8 = undefined;
        const n = std.unicode.utf8Encode(@intCast(cp), &tmp) catch return null;
        if (w + n > buf.len) return null;
        @memcpy(buf[w .. w + n], tmp[0..n]);
        w += n;
    }
    return buf[0..w];
}

fn hexDigit(c: u8) ?u32 {
    return switch (c) {
        '0'...'9' => c - '0',
        'a'...'f' => c - 'a' + 10,
        'A'...'F' => c - 'A' + 10,
        else => null,
    };
}

/// Returns the cooked name of an identifier-like node into `buf`, or null
/// when the node isn't an identifier-shape we recognise.
fn cookedName(ctx: *const LintContext, node: NodeIndex, buf: []u8) ?[]const u8 {
    if (node == .none) return null;
    const tag = ctx.ast.nodeTag(node);
    if (tag == .identifier or tag == .property_ident) {
        const raw = ctx.tokenText(ctx.ast.nodeMainToken(node));
        return cookedIdent(raw, buf);
    }
    if (tag == .string_literal) {
        return ctx.nodeStaticStringValue(node);
    }
    if (tag == .property_literal) {
        // property_literal's main_token is the string token itself.
        const raw = ctx.tokenText(ctx.ast.nodeMainToken(node));
        if (raw.len < 2) return null;
        return raw[1 .. raw.len - 1];
    }
    return null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.ast.nodeTag(node);
    const opts = readOptions(ctx);
    switch (tag) {
        .object_pattern => {
            if (opts.ignore_destructuring) return;
            checkObjectPattern(node, ctx);
        },
        .import_specifier => {
            if (opts.ignore_import) return;
            checkImportSpecifier(node, ctx);
        },
        .export_specifier => {
            if (opts.ignore_export) return;
            checkExportSpecifier(node, ctx);
        },
        else => {},
    }
}

fn checkObjectPattern(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.ast.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    const props = ctx.ast.extraSlice(.{
        .start = @intFromEnum(d.lhs),
        .end = @intFromEnum(d.rhs),
    });
    for (props) |pi| {
        const p: NodeIndex = @enumFromInt(pi);
        const ptag = ctx.ast.nodeTag(p);
        if (ptag != .property) continue; // skip shorthand/computed/rest

        const pd = ctx.ast.nodeData(p);
        var key_buf: [256]u8 = undefined;
        const key_name = cookedName(ctx, pd.lhs, &key_buf) orelse continue;

        // Value side: strip grouping, then unwrap AssignmentPattern.
        var value_node = stripGrouping(ctx, pd.rhs);
        if (value_node != .none and ctx.ast.nodeTag(value_node) == .assignment_pattern) {
            value_node = stripGrouping(ctx, ctx.ast.nodeData(value_node).lhs);
        }
        var val_buf: [256]u8 = undefined;
        const value_name = cookedName(ctx, value_node, &val_buf) orelse continue;

        if (!std.mem.eql(u8, key_name, value_name)) continue;

        // Span: key.start through nodeSpan(value).end so the report covers
        // the trailing default value with its closing brackets.
        const key_span = ctx.nodeSpan(pd.lhs);
        const val_span = ctx.nodeSpan(pd.rhs);
        ctx.reportSpanWithMessageIdAndData(
            .{ .start = key_span.start, .end = val_span.end },
            "unnecessarilyRenamed",
            &.{
                .{ .key = "type", .val = "Destructuring assignment" },
                .{ .key = "name", .val = key_name },
            },
        );
    }
}

fn checkImportSpecifier(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.ast.nodeData(node);
    var imp_buf: [256]u8 = undefined;
    var loc_buf: [256]u8 = undefined;
    const imported_name = cookedName(ctx, d.lhs, &imp_buf) orelse return;
    const local_name = cookedName(ctx, d.rhs, &loc_buf) orelse return;
    // No alias means imported_tok == local_tok in our parser.  If the tokens
    // differ, an `as` alias was written.
    const imp_tok = ctx.ast.nodeMainToken(d.lhs);
    const loc_tok = ctx.ast.nodeMainToken(d.rhs);
    if (imp_tok == loc_tok) return;
    if (!std.mem.eql(u8, imported_name, local_name)) return;
    ctx.reportWithMessageIdAndData(node, "unnecessarilyRenamed", &.{
        .{ .key = "type", .val = "Import" },
        .{ .key = "name", .val = imported_name },
    });
}

fn checkExportSpecifier(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.ast.nodeData(node);
    var loc_buf: [256]u8 = undefined;
    var exp_buf: [256]u8 = undefined;
    const local_name = cookedName(ctx, d.lhs, &loc_buf) orelse return;
    const exported_name = cookedName(ctx, d.rhs, &exp_buf) orelse return;
    const loc_tok = ctx.ast.nodeMainToken(d.lhs);
    const exp_tok = ctx.ast.nodeMainToken(d.rhs);
    if (loc_tok == exp_tok) return;
    if (!std.mem.eql(u8, local_name, exported_name)) return;
    ctx.reportWithMessageIdAndData(node, "unnecessarilyRenamed", &.{
        .{ .key = "type", .val = "Export" },
        .{ .key = "name", .val = local_name },
    });
}
