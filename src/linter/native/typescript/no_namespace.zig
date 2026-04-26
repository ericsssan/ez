const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .ts_namespace_decl, .ts_module_decl };
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-namespace",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow TypeScript namespaces",
    .lang = .ts_only,
};

/// Scan backward from tok to find `declare` keyword before the namespace/module.
fn hasDeclareModifier(ctx: *const LintContext, main_tok: u32) bool {
    if (main_tok == 0) return false;
    var t = main_tok - 1;
    var depth: u32 = 0;
    while (depth < 8) : (depth += 1) {
        const text = ctx.tokenText(t);
        if (std.mem.eql(u8, text, "declare")) return true;
        if (!std.mem.eql(u8, text, "export") and
            !std.mem.eql(u8, text, "global"))
            break;
        if (t == 0) break;
        t -= 1;
    }
    return false;
}

/// Check if ancestor chain has a `declare` namespace/module wrapping this node,
/// OR is inside a `declare global` block.
fn isInsideDeclareNamespace(ctx: *const LintContext, node: NodeIndex) bool {
    var current = ctx.parentOf(node);
    var depth: u32 = 0;
    while (current != .none and depth < 16) : (depth += 1) {
        const tag = ctx.nodeTag(current);
        if (tag == .ts_namespace_decl or tag == .ts_module_decl) {
            if (hasDeclareModifier(ctx, ctx.nodeMainToken(current))) return true;
        }
        if (tag == .block_stmt) {
            // Check if this block is from `declare global { ... }`
            if (isBlockFromDeclareGlobal(ctx, current)) return true;
            current = ctx.parentOf(current);
            continue;
        }
        if (tag == .root) break;
        current = ctx.parentOf(current);
    }
    return false;
}

/// Check if a block_stmt node was created by `declare global { ... }`.
fn isBlockFromDeclareGlobal(ctx: *const LintContext, block_node: NodeIndex) bool {
    const open_tok = ctx.nodeMainToken(block_node);
    if (open_tok < 2) return false;
    var t = open_tok;
    var found_global = false;
    var d: u32 = 0;
    while (t > 0 and d < 5) : (d += 1) {
        t -= 1;
        const txt = ctx.tokenText(t);
        if (!found_global) {
            if (std.mem.eql(u8, txt, "global")) { found_global = true; continue; }
            break;
        } else {
            if (std.mem.eql(u8, txt, "declare")) return true;
            break;
        }
    }
    return false;
}

/// Check if namespace is inside `declare global { ... }` by scanning source text.
fn isInsideDeclareGlobal(ctx: *const LintContext, node: NodeIndex) bool {
    const src = ctx.source();
    // Get position of the `namespace`/`module` keyword.
    const ns_pos = ctx.tokenStart(ctx.nodeMainToken(node));
    if (ns_pos == 0) return false;
    // Scan backward for the `{` that opens the enclosing block.
    // Then check if `declare global` precedes it.
    var i: i64 = @intCast(ns_pos);
    var brace_pos: i64 = -1;
    i -= 1;
    while (i >= 0) : (i -= 1) {
        switch (src[@intCast(i)]) {
            '{' => { brace_pos = i; break; },
            '}' => return false, // hit another block — not inside declare global
            else => {},
        }
    }
    if (brace_pos < 0) return false;
    // Check if `declare global` immediately precedes the `{` (ignoring whitespace).
    var j: i64 = brace_pos - 1;
    // Skip whitespace
    while (j >= 0 and (src[@intCast(j)] == ' ' or src[@intCast(j)] == '\t' or
           src[@intCast(j)] == '\n' or src[@intCast(j)] == '\r')) j -= 1;
    // Check for "global"
    if (j < 5) return false;
    if (!std.mem.eql(u8, src[@intCast(j - 5)..@intCast(j + 1)], "global")) return false;
    j -= 6;
    // Skip whitespace
    while (j >= 0 and (src[@intCast(j)] == ' ' or src[@intCast(j)] == '\t' or
           src[@intCast(j)] == '\n' or src[@intCast(j)] == '\r')) j -= 1;
    // Check for "declare"
    if (j < 6) return false;
    return std.mem.eql(u8, src[@intCast(j - 6)..@intCast(j + 1)], "declare");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const allow_declarations = blk: {
        if (ctx.getOptions()) |o| switch (o.*) {
            .object => |obj| {
                if (obj.get("allowDeclarations")) |v|
                    if (v == .bool) break :blk v.bool;
            },
            else => {},
        };
        break :blk false;
    };

    const allow_def_files = blk: {
        if (ctx.getOptions()) |o| switch (o.*) {
            .object => |obj| {
                if (obj.get("allowDefinitionFiles")) |v|
                    if (v == .bool) break :blk v.bool;
            },
            else => {},
        };
        break :blk true; // default: true
    };

    // allowDefinitionFiles: check if source ends with .d.ts pattern via languageOptions
    if (allow_def_files) {
        if (ctx.getLanguageOptionString("parserOptions")) |_ | {
            // We'd check filePath here, but we don't have it directly.
            // For now: if source has "// @ts-nocheck" or is purely declarations, skip.
            _ = ctx.source();
        }
    }

    // Ambient module declarations like `declare module 'foo' {}` are always allowed.
    const name_node = ctx.nodeData(node).lhs;
    if (name_node != .none and ctx.nodeTag(name_node) == .string_literal) return;

    const main_tok = ctx.nodeMainToken(node);
    const is_declare = hasDeclareModifier(ctx, main_tok);

    if (allow_declarations) {
        if (is_declare) return;
        if (isInsideDeclareNamespace(ctx, node)) return;
        if (isInsideDeclareGlobal(ctx, node)) return;
    }

    ctx.report(node);
}
