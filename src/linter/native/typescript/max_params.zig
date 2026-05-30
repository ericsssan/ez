// HAND-WRITTEN.
// Rule: @typescript-eslint/max-params
//
// Reports functions whose parameter count exceeds `max` (default 3).
// Honors the TS-specific `countVoidThis` option — when false, a
// leading `this: void` parameter doesn't count.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const TokenIndex = ast.TokenIndex;
const Node = ast.Node;
const Span = parser.span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "max-params",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce a maximum number of parameters in function definitions",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
    .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
    .arrow_fn, .async_arrow_fn,
    .method_def, .computed_method_def,
    .ts_declare_function, .ts_function_type,
};

const ThisMode = enum { default_void, always, never };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const max = readMax(ctx);
    const this_mode = readThisMode(ctx);
    const params = paramsOf(node, ctx) orelse return;
    var count: u32 = 0;
    for (params) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        const is_this = isThisParam(p, ctx);
        if (is_this) {
            switch (this_mode) {
                .always => {},
                .never => continue,
                .default_void => if (isThisVoid(p, ctx)) continue,
            }
        }
        count += 1;
    }
    if (count <= max) return;
    const span = computeHeadSpan(node, ctx);
    ctx.reportSpanWithMessageId(span, "exceed");
}

fn readMax(ctx: *const LintContext) u32 {
    const opts = ctx.rule_options orelse return 3;
    if (opts.* == .object) {
        if (opts.object.get("max")) |v| {
            if (v == .integer) return @intCast(@max(0, v.integer));
        }
        if (opts.object.get("maximum")) |v| {
            if (v == .integer) return @intCast(@max(0, v.integer));
        }
    }
    if (opts.* == .integer) return @intCast(@max(0, opts.integer));
    return 3;
}

fn paramsOf(node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .ts_function_type => blk: {
            if (data.lhs == .none) break :blk null;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk paramRange(fd.params, fd.params_end, ctx);
        },
        .arrow_fn, .async_arrow_fn => blk: {
            if (data.lhs == .none) break :blk null;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk paramRange(ad.params_start, ad.params_end, ctx);
        },
        .method_def, .computed_method_def => blk: {
            if (data.rhs == .none) break :blk null;
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk paramRange(md.params_start, md.params_end, ctx);
        },
        else => null,
    };
}

fn paramRange(s: u32, e: u32, ctx: *const LintContext) ?[]const u32 {
    if (s >= e or e > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[s..e];
}

fn isThisParam(p: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(p) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(p)), "this");
}

fn isThisVoid(p: NodeIndex, ctx: *const LintContext) bool {
    const ann = ctx.nodeData(p).rhs;
    if (ann == .none or ctx.nodeTag(ann) != .ts_type_annotation) return false;
    var inner = ctx.nodeData(ann).lhs;
    if (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .ts_type_reference) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), "void");
}

fn readThisMode(ctx: *const LintContext) ThisMode {
    if (ctx.getOptionString("countThis")) |s| {
        if (std.mem.eql(u8, s, "always")) return .always;
        if (std.mem.eql(u8, s, "never")) return .never;
    }
    // TS-eslint legacy option: countVoidThis=true ⇒ count void this (same as always).
    if (ctx.getOptionBool("countVoidThis", false)) return .always;
    return .default_void;
}

fn computeHeadSpan(node: NodeIndex, ctx: *const LintContext) Span {
    const tag = ctx.nodeTag(node);
    const main = ctx.nodeMainToken(node);
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => fnHead(node, ctx, false),
        .ts_declare_function => fnHead(node, ctx, true),
        .arrow_fn, .async_arrow_fn => arrowHead(node, ctx),
        .method_def, .computed_method_def => methodHead(node, ctx),
        .ts_function_type => zeroAt(main, ctx),
        else => ctx.nodeSpan(node),
    };
}

fn fnHead(node: NodeIndex, ctx: *const LintContext, is_declare: bool) Span {
    _ = is_declare;
    const data = ctx.nodeData(node);
    const start_tok = ctx.nodeMainToken(node);
    const start = ctx.ast.tokenStart(start_tok);
    if (data.lhs == .none) return ctx.nodeSpan(node);
    const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    if (fd.name != .none) {
        const sp = ctx.nodeSpan(fd.name);
        return .{ .start = start, .end = sp.end };
    }
    // Anonymous: end at the open paren of the params.
    const paren = findOpenParen(start_tok, ctx) orelse {
        return ctx.nodeSpan(node);
    };
    return .{ .start = start, .end = ctx.ast.tokenStart(paren) };
}

fn arrowHead(node: NodeIndex, ctx: *const LintContext) Span {
    // Find the `=>` token by scanning forward from main_token.
    var t: u32 = ctx.nodeMainToken(node);
    var depth: i32 = 0;
    const total: u32 = @intCast(ctx.ast.tokens.len);
    while (t < total) : (t += 1) {
        const tag = ctx.ast.tokenTag(t);
        switch (tag) {
            .l_paren, .l_bracket, .l_brace => depth += 1,
            .r_paren, .r_bracket, .r_brace => depth -= 1,
            .arrow => if (depth <= 0) {
                return .{ .start = ctx.ast.tokenStart(t), .end = ctx.tokenEnd(t) };
            },
            else => {},
        }
    }
    return ctx.nodeSpan(node);
}

fn methodHead(node: NodeIndex, ctx: *const LintContext) Span {
    const key = ctx.nodeData(node).lhs;
    if (key == .none) return ctx.nodeSpan(node);
    return ctx.nodeSpan(key);
}

fn zeroAt(t: TokenIndex, ctx: *const LintContext) Span {
    const s = ctx.ast.tokenStart(t);
    return .{ .start = s, .end = s };
}

fn findOpenParen(start_tok: TokenIndex, ctx: *const LintContext) ?TokenIndex {
    var t: u32 = start_tok;
    var depth: i32 = 0;
    const total: u32 = @intCast(ctx.ast.tokens.len);
    while (t < total) : (t += 1) {
        const tag = ctx.ast.tokenTag(t);
        switch (tag) {
            .less_than => depth += 1,
            .greater_than => depth -= 1,
            .l_paren => if (depth <= 0) return t,
            .l_brace, .semicolon, .arrow => return null,
            else => {},
        }
    }
    return null;
}
