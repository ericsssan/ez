const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ModifierBit = ast.ModifierBit;
const TokenTag = @import("../../../parser/token.zig").Tag;

pub const meta = RuleMeta{
    .name = "no-empty-function",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow empty functions",
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl,
    .fn_expr,
    .async_fn_decl,
    .async_fn_expr,
    .generator_fn_decl,
    .generator_fn_expr,
    .async_generator_fn_decl,
    .async_generator_fn_expr,
    .arrow_fn,
    .async_arrow_fn,
    .method_def,
    .constructor_def,
    .computed_method_def,
    .getter_def,
    .setter_def,
    .computed_getter_def,
    .computed_setter_def,
};

/// Scan backward from `main_tok` to find an `@` decorator token before this member.
fn hasDecorator(ctx: *const LintContext, main_tok: u32) bool {
    if (main_tok == 0) return false;
    var t = main_tok - 1;
    var depth: u32 = 0;
    while (depth < 30) : (depth += 1) {
        const tag = ctx.tokenTag(t);
        if (tag == .at_sign) return true;
        switch (tag) {
            .l_brace, .r_brace, .semicolon => return false,
            else => {},
        }
        if (t == 0) break;
        t -= 1;
    }
    return false;
}

/// Scan backward from `tok` through class member modifiers looking for `target`.
fn tokenHasModifier(ctx: *const LintContext, tok: u32, target: []const u8) bool {
    if (tok == 0) return false;
    var t = tok - 1;
    var depth: u32 = 0;
    while (depth < 6) : (depth += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, target)) return true;
        if (!std.mem.eql(u8, txt, "static") and
            !std.mem.eql(u8, txt, "public") and
            !std.mem.eql(u8, txt, "private") and
            !std.mem.eql(u8, txt, "protected") and
            !std.mem.eql(u8, txt, "abstract") and
            !std.mem.eql(u8, txt, "override") and
            !std.mem.eql(u8, txt, "readonly") and
            !std.mem.eql(u8, txt, "declare")) break;
        if (t == 0) break;
        t -= 1;
    }
    return false;
}

fn tokenHasOverrideModifier(ctx: *const LintContext, tok: u32) bool {
    return tokenHasModifier(ctx, tok, "override");
}

fn tokenHasAccessModifier(ctx: *const LintContext, tok: u32, access: []const u8) bool {
    return tokenHasModifier(ctx, tok, access);
}

/// Returns true only when the block body has zero statements AND no comments.
/// ESLint considers a function with only comments inside as non-empty.
fn isEmptyBody(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    if (ctx.nodeTag(body) != .block_stmt) return false;

    const body_data = ctx.nodeData(body);
    const stmts = ctx.extraSlice(.{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    });
    if (stmts.len != 0) return false;

    // Scan source between '{' and '}' for comment markers.
    const open_tok = ctx.nodeMainToken(body);
    const src = ctx.source();
    const open_pos = ctx.tokenStart(open_tok);
    if (open_pos >= src.len or src[open_pos] != '{') return true;
    var i: usize = open_pos + 1;
    while (i < src.len) : (i += 1) {
        switch (src[i]) {
            '}' => return true,
            '/' => {
                if (i + 1 < src.len and (src[i + 1] == '/' or src[i + 1] == '*')) {
                    return false;
                }
            },
            else => {},
        }
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    var body: NodeIndex = .none;
    var allow_key: ?[]const u8 = null; // option key that would allow this function type

    switch (tag) {
        .fn_decl, .fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            body = fn_data.body;
            allow_key = "functions";
        },
        .async_fn_decl, .async_fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            body = fn_data.body;
            allow_key = "asyncFunctions";
        },
        .generator_fn_decl, .generator_fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            body = fn_data.body;
            allow_key = "generatorFunctions";
        },
        .async_generator_fn_decl, .async_generator_fn_expr => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            body = fn_data.body;
            // ESLint prefer-const groups async generators under asyncFunctions
            allow_key = "asyncFunctions";
        },
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            body = arrow_data.body;
            allow_key = "arrowFunctions";
        },
        .getter_def, .computed_getter_def => {
            const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            body = method_data.body;
            if (!isEmptyBody(body, ctx)) return;
            if (ctx.optionArrayContains("allow", "getters")) return;
            const is_override = (method_data.modifiers & ModifierBit.@"override" != 0) or
                tokenHasOverrideModifier(ctx, ctx.nodeMainToken(node));
            if (is_override and ctx.optionArrayContains("allow", "overrideMethods")) return;
            if (ctx.optionArrayContains("allow", "decoratedFunctions") and hasDecorator(ctx, ctx.nodeMainToken(node))) return;
            ctx.report(node);
            return;
        },
        .setter_def, .computed_setter_def => {
            const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            body = method_data.body;
            if (!isEmptyBody(body, ctx)) return;
            if (ctx.optionArrayContains("allow", "setters")) return;
            const is_override = (method_data.modifiers & ModifierBit.@"override" != 0) or
                tokenHasOverrideModifier(ctx, ctx.nodeMainToken(node));
            if (is_override and ctx.optionArrayContains("allow", "overrideMethods")) return;
            if (ctx.optionArrayContains("allow", "decoratedFunctions") and hasDecorator(ctx, ctx.nodeMainToken(node))) return;
            ctx.report(node);
            return;
        },
        .constructor_def => {
            const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            const params = ctx.extraSlice(.{
                .start = method_data.params_start,
                .end = method_data.params_end,
            });
            for (params) |p| {
                if (ctx.nodeTag(@enumFromInt(p)) == .ts_parameter_property) return;
            }
            body = method_data.body;
            if (!isEmptyBody(body, ctx)) return;
            if (ctx.optionArrayContains("allow", "constructors")) return;
            // Check accessibility: expressions.zig may not store modifiers, so scan tokens.
            const acc = method_data.modifiers & ModifierBit.accessibility_mask;
            const main_tok = ctx.nodeMainToken(node);
            const is_private = (acc == ModifierBit.acc_private) or
                (acc == 0 and tokenHasAccessModifier(ctx, main_tok, "private"));
            const is_protected = (acc == ModifierBit.acc_protected) or
                (acc == 0 and tokenHasAccessModifier(ctx, main_tok, "protected"));
            if (is_private and ctx.optionArrayContains("allow", "privateConstructors")) return;
            if (is_protected and ctx.optionArrayContains("allow", "protectedConstructors")) return;
            ctx.report(node);
            return;
        },
        .method_def, .computed_method_def => {
            const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            body = method_data.body;
            const mods = method_data.modifiers;

            // Constructor detection (method_def used by class declarations).
            if (tag == .method_def) {
                const key_tok = ctx.nodeMainToken(data.lhs);
                if (std.mem.eql(u8, ctx.tokenText(key_tok), "constructor")) {
                    const params = ctx.extraSlice(.{
                        .start = method_data.params_start,
                        .end = method_data.params_end,
                    });
                    for (params) |p| {
                        if (ctx.nodeTag(@enumFromInt(p)) == .ts_parameter_property) return;
                    }
                    if (!isEmptyBody(body, ctx)) return;
                    if (ctx.optionArrayContains("allow", "constructors")) return;
                    const acc = mods & ModifierBit.accessibility_mask;
                    if (acc == ModifierBit.acc_private and ctx.optionArrayContains("allow", "privateConstructors")) return;
                    if (acc == ModifierBit.acc_protected and ctx.optionArrayContains("allow", "protectedConstructors")) return;
                    ctx.report(node);
                    return;
                }
            }

            if (!isEmptyBody(body, ctx)) return;
            const is_async = mods & ModifierBit.@"async" != 0;
            const is_gen = mods & ModifierBit.generator != 0;
            const is_override = mods & ModifierBit.@"override" != 0;
            // `methods` covers non-async, non-generator methods (including override).
            if (!is_async and !is_gen and ctx.optionArrayContains("allow", "methods")) return;
            // Specific modifier-based keys apply independently.
            if (is_async and ctx.optionArrayContains("allow", "asyncMethods")) return;
            if (is_gen and ctx.optionArrayContains("allow", "generatorMethods")) return;
            if (is_override and ctx.optionArrayContains("allow", "overrideMethods")) return;
            if (ctx.optionArrayContains("allow", "decoratedFunctions") and hasDecorator(ctx, ctx.nodeMainToken(node))) return;
            ctx.report(node);
            return;
        },
        else => return,
    }

    // Fallback for cases that set body/allow_key via the switch above.
    if (!isEmptyBody(body, ctx)) return;
    if (allow_key != null and ctx.optionArrayContains("allow", allow_key.?)) return;
    ctx.report(node);
}
