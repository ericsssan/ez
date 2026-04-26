const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;

pub const meta = RuleMeta{
    .name = "no-inner-declarations",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow function and variable declarations in nested blocks",
};

pub const relevant_tags = [_]Node.Tag{};
pub fn run(_: NodeIndex, _: *const LintContext) void {}

fn isFnDeclTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => true,
        else => false,
    };
}

fn isFnExprOrLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .getter_def, .setter_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        .constructor_def, .static_block,
        => true,
        else => false,
    };
}

/// Find the fn_decl/fn_expr ancestor for a function name identifier.
/// Returns the first function-like ancestor, or .none if not found.
fn findFunctionAncestor(ctx: *const LintContext, decl_node: NodeIndex) NodeIndex {
    var current = ctx.parentOf(decl_node);
    var depth: u32 = 0;
    while (current != .none and depth < 10) : (depth += 1) {
        const tag = ctx.nodeTag(current);
        if (isFnDeclTag(tag) or isFnExprOrLike(tag)) return current;
        if (tag == .root) return .none;
        current = ctx.parentOf(current);
    }
    return .none;
}

/// Returns true if `fn_node` (a fn_decl or fn_expr) is nested inside a
/// control-flow structure (if/while/for/switch block or bare if-body).
/// `allow_block_scoped`: if true, skip flagging when the fn_decl is inside a `{}`
/// block (block-scoped in strict mode / ES6). Still flags bare-if contexts.
fn isNestedInControlFlow(ctx: *const LintContext, fn_node: NodeIndex, allow_block_scoped: bool) bool {
    var current = ctx.parentOf(fn_node);
    while (current != .none) {
        const tag = ctx.nodeTag(current);
        if (tag == .root) return false;
        // Crossed a function boundary — not at top of this function.
        if (isFnDeclTag(tag) or isFnExprOrLike(tag)) return false;
        // block_stmt: check if it's a function/root body (ok) or control flow (nested).
        if (tag == .block_stmt) {
            const block_parent = ctx.parentOf(current);
            if (block_parent == .none) return false;
            const bp_tag = ctx.nodeTag(block_parent);
            if (bp_tag == .root or isFnDeclTag(bp_tag) or isFnExprOrLike(bp_tag)) return false;
            // Block inside control flow.
            if (allow_block_scoped) return false;
            return true;
        }
        // Bare if/for/while body without braces — always nested.
        switch (tag) {
            .if_stmt, .if_else_stmt,
            .while_stmt, .do_while_stmt,
            .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .with_stmt,
            => return true,
            else => {},
        }
        current = ctx.parentOf(current);
    }
    return false;
}

/// Scan the start of `text` for a "use strict" directive (before any code).
fn startsWithUseStrict(text: []const u8) bool {
    var i: usize = 0;
    while (i < text.len and (text[i] == ' ' or text[i] == '\t' or text[i] == '\n' or text[i] == '\r')) i += 1;
    const t = text[i..];
    return std.mem.startsWith(u8, t, "'use strict'") or std.mem.startsWith(u8, t, "\"use strict\"");
}

/// Returns true if the nearest enclosing function body starts with "use strict".
fn enclosingFunctionHasUseStrict(ctx: *const LintContext, fn_node: NodeIndex, src: []const u8) bool {
    var current = ctx.parentOf(fn_node);
    while (current != .none) {
        const tag = ctx.nodeTag(current);
        if (tag == .root) break;
        if (isFnDeclTag(tag)) {
            // Get the body block from FnData.
            const d = ctx.nodeData(current);
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            if (fn_data.body == .none) return false;
            // Body block's main token is `{`.
            const brace_tok = ctx.nodeMainToken(fn_data.body);
            const brace_pos = ctx.tokenStart(brace_tok);
            if (brace_pos + 1 < src.len) {
                return startsWithUseStrict(src[brace_pos + 1 ..]);
            }
            return false;
        }
        if (isFnExprOrLike(tag)) {
            // For expressions and methods, do a simple token scan from the node's start.
            const start = ctx.nodeSpan(current).start;
            // Find `{` by scanning forward (functions are not too long in this context).
            var j: u32 = start;
            var depth: u32 = 0;
            while (j < src.len and depth < 500) : ({ j += 1; depth += 1; }) {
                if (src[j] == '{') {
                    return startsWithUseStrict(src[j + 1 ..]);
                }
            }
            return false;
        }
        current = ctx.parentOf(current);
    }
    return false;
}

fn isClassLike(tag: Node.Tag) bool {
    return tag == .class_decl or tag == .class_expr or tag == .class_body;
}

/// Returns true if the enclosing execution context is strict-mode.
/// Used to decide whether blockScopedFunctions:"allow" should suppress a report.
fn isEnclosingContextStrict(ctx: *const LintContext, fn_node: NodeIndex) bool {
    // Module sourceType is always strict.
    if (ctx.getLanguageOptionString("sourceType")) |st| {
        if (std.mem.eql(u8, st, "module")) return true;
    }
    // Class body is always strict — check all the way up (class may wrap a method).
    var current = ctx.parentOf(fn_node);
    while (current != .none) {
        const tag = ctx.nodeTag(current);
        if (tag == .root) break;
        if (isClassLike(tag)) return true;
        current = ctx.parentOf(current);
    }
    // Check for "use strict" at program level or in enclosing function body.
    const src = ctx.source();
    var skip: usize = 0;
    while (skip < src.len and (src[skip] == ' ' or src[skip] == '\t' or src[skip] == '\n' or src[skip] == '\r')) skip += 1;
    const trimmed = src[skip..];
    if (std.mem.startsWith(u8, trimmed, "'use strict'") or
        std.mem.startsWith(u8, trimmed, "\"use strict\"")) return true;
    // Check if enclosing function body starts with "use strict".
    return enclosingFunctionHasUseStrict(ctx, fn_node, src);
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const opts = ctx.getOptions();
    // option[0]: "functions" (default) or "both"
    const check_vars: bool = blk: {
        if (opts) |o| switch (o.*) {
            .string => |s| break :blk std.mem.eql(u8, s, "both"),
            .array => |arr| {
                if (arr.items.len > 0 and arr.items[0] == .string)
                    break :blk std.mem.eql(u8, arr.items[0].string, "both");
            },
            else => {},
        };
        break :blk false;
    };
    // option[1]: {blockScopedFunctions: "allow"} — skip fn decls inside {} blocks
    // (applies only when in block-scoped context; bare-if fn decls still flagged)
    const allow_block_scoped: bool = blk: {
        if (ctx.getOptions2()) |o2| switch (o2.*) {
            .object => |obj| {
                if (obj.get("blockScopedFunctions")) |bsf| {
                    if (bsf == .string and std.mem.eql(u8, bsf.string, "allow"))
                        break :blk true;
                }
            },
            else => {},
        };
        break :blk false;
    };

    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = symbols.getBindingKind(id);
        const decl_node = symbols.getDeclNode(id);

        if (kind == .function_decl) {
            const fn_node = findFunctionAncestor(ctx, decl_node);
            if (fn_node == .none) continue;
            // Skip named function expressions (fn_expr_like, not fn_decl).
            if (!isFnDeclTag(ctx.nodeTag(fn_node))) continue;
            // blockScopedFunctions:"allow" only suppresses in strict context.
            const effective_allow = allow_block_scoped and isEnclosingContextStrict(ctx, fn_node);
            if (isNestedInControlFlow(ctx, fn_node, effective_allow)) {
                ctx.report(decl_node);
            }
        } else if (check_vars and kind == .@"var") {
            // For var declarations, decl_node is the identifier in the declarator.
            if (isNestedInControlFlow(ctx, decl_node, false)) {
                ctx.report(decl_node);
            }
        }
    }
}
