// HAND-WRITTEN.
// Rule: @typescript-eslint/no-useless-constructor
//
// Disallow unnecessary constructors.  Extends the ESLint core rule with
// TypeScript-aware skipping:
//   - Constructors with TypeScript parameter properties are never useless
//   - Constructors with decorated parameters are never useless
//   - private / protected constructors are never useless
//   - `public` constructor with a superclass is never useless (explicit
//     visibility has semantic meaning in TS)
//
// Base rule (ESLint core no-useless-constructor):
//   - No superClass → fire if body is empty
//   - Has superClass → fire if body is a single pass-through super() call
//     (same args as params, or super(...arguments))

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const meta = RuleMeta{
    .name = "no-useless-constructor",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary constructors",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .constructor_def,
    .method_def,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // For method_def, only proceed when the method key is "constructor".
    var ctor_tok: u32 = 0;
    if (tag == .method_def) {
        const key = data.lhs;
        if (key == .none) return;
        const key_tag = ctx.nodeTag(key);
        ctor_tok = ctx.nodeMainToken(key);
        if (key_tag == .identifier) {
            if (!std.mem.eql(u8, ctx.tokenText(ctor_tok), "constructor")) return;
        } else if (key_tag == .string_literal) {
            const src = ctx.tokenText(ctor_tok);
            // 'constructor' or "constructor"
            if (src.len < 13) return;
            if (!std.mem.eql(u8, src[1 .. src.len - 1], "constructor")) return;
        } else return;
    } else {
        // constructor_def
        ctor_tok = ctx.nodeMainToken(node);
    }

    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));

    // Skip ambient declarations (no body).
    if (md.body == .none) return;

    // Skip if any param is a TS parameter property or has a decorator.
    if (md.params_start < md.params_end) {
        const params_raw = ctx.extraSlice(.{ .start = md.params_start, .end = md.params_end });
        for (params_raw) |p_raw| {
            const param: NodeIndex = @enumFromInt(p_raw);
            if (ctx.nodeTag(param) == .ts_parameter_property) return;
            if (paramHasDecorator(param, ctor_tok, ctx)) return;
        }
    }

    // Accessibility check: private/protected → never useless.
    const acc = md.modifiers & ast.ModifierBit.accessibility_mask;
    const is_private = acc == ast.ModifierBit.acc_private or
        scanHasModifier(ctor_tok, "private", ctx);
    const is_protected = acc == ast.ModifierBit.acc_protected or
        scanHasModifier(ctor_tok, "protected", ctx);
    if (is_private or is_protected) return;

    // Find the containing class to get the superclass.
    const class_body = ctx.parentOf(node);
    if (class_body == .none) return;
    const class_node = ctx.parentOf(class_body);
    if (class_node == .none) return;
    const has_super = getSuperClass(class_node, ctx) != .none;

    // public + superclass → not useless (explicit visibility is meaningful in TS).
    const is_public = acc == ast.ModifierBit.acc_public or
        scanHasModifier(ctor_tok, "public", ctx);
    if (is_public and has_super) return;

    // Check body content.
    const body_data = ctx.nodeData(md.body);
    const stmts = ctx.extraSlice(.{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    });

    const params_raw: []const u32 = if (md.params_start < md.params_end)
        ctx.extraSlice(.{ .start = md.params_start, .end = md.params_end })
    else
        &.{};

    if (!has_super) {
        if (stmts.len != 0) return;
    } else {
        if (!isRedundantSuperCall(stmts, params_raw, ctx)) return;
    }

    // Report: from first modifier/constructor keyword to end of constructor keyword.
    const start_tok = headStartTok(ctor_tok, ctx);
    const sp = Span{
        .start = ctx.tokenStart(start_tok),
        .end = ctx.tokenEnd(ctor_tok),
    };
    ctx.reportSpanWithMessageId(sp, "noUselessConstructor");
}

/// Walk backward from ctor_tok to find any access modifier or other prefix.
fn headStartTok(ctor_tok: u32, ctx: *const LintContext) u32 {
    var t = ctor_tok;
    while (t > 0) {
        const prev_text = ctx.tokenText(t - 1);
        if (std.mem.eql(u8, prev_text, "public") or
            std.mem.eql(u8, prev_text, "private") or
            std.mem.eql(u8, prev_text, "protected") or
            std.mem.eql(u8, prev_text, "override") or
            std.mem.eql(u8, prev_text, "abstract") or
            std.mem.eql(u8, prev_text, "declare"))
        {
            t -= 1;
        } else break;
    }
    return t;
}

/// Scan backward from ctor_tok up to 8 tokens for a specific modifier keyword.
fn scanHasModifier(ctor_tok: u32, target: []const u8, ctx: *const LintContext) bool {
    if (ctor_tok == 0) return false;
    var t = ctor_tok;
    var depth: u32 = 0;
    while (depth < 8 and t > 0) : (depth += 1) {
        t -= 1;
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, target)) return true;
        if (!std.mem.eql(u8, txt, "public") and
            !std.mem.eql(u8, txt, "private") and
            !std.mem.eql(u8, txt, "protected") and
            !std.mem.eql(u8, txt, "override") and
            !std.mem.eql(u8, txt, "abstract") and
            !std.mem.eql(u8, txt, "declare")) break;
    }
    return false;
}

/// Return the superclass node for a class_decl or class_expr, or .none.
fn getSuperClass(class_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const ct = ctx.nodeTag(class_node);
    if (ct != .class_decl and ct != .class_expr) return .none;
    const d = ctx.nodeData(class_node);
    if (d.lhs == .none) return .none;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    return cd.super_class;
}

/// Detect a decorator `@` immediately before the parameter's first token.
/// Scans backward from the parameter's main_token looking for at_sign.
/// Uses depth tracking to skip decorator arguments like `@Bar()`.
fn paramHasDecorator(param: NodeIndex, ctor_tok: u32, ctx: *const LintContext) bool {
    _ = ctor_tok;
    if (param == .none) return false;
    const main = ctx.nodeMainToken(param);
    if (main == 0) return false;
    var t: u32 = main;
    var depth: i32 = 0;
    var i: u32 = 0;
    while (i < 40 and t > 0) : (i += 1) {
        t -= 1;
        const ttag = ctx.tokenTag(t);
        switch (ttag) {
            .at_sign => return true,
            .r_paren, .r_bracket => depth += 1,
            .l_paren => {
                if (depth > 0) {
                    depth -= 1;
                } else {
                    return false; // hit the function params opening paren
                }
            },
            .l_bracket => {
                if (depth > 0) depth -= 1 else return false;
            },
            .comma => {
                if (depth == 0) return false;
            },
            .l_brace, .r_brace, .semicolon => return false,
            else => {},
        }
    }
    return false;
}

/// True when `body` (stmts slice) is a redundant super call:
/// - Single statement
/// - It's `super(args)` where args either spread `arguments` or
///   pass through the constructor params in the same order.
/// - All constructor params are "simple" (identifier or rest_element).
fn isRedundantSuperCall(stmts: []const u32, params_raw: []const u32, ctx: *const LintContext) bool {
    if (stmts.len != 1) return false;
    const stmt: NodeIndex = @enumFromInt(stmts[0]);
    if (ctx.nodeTag(stmt) != .expression_stmt) return false;
    const expr = ctx.nodeData(stmt).lhs;
    if (expr == .none or ctx.nodeTag(expr) != .call_expr) return false;
    const call_data = ctx.nodeData(expr);
    // Callee must be `super`.
    if (call_data.lhs == .none or ctx.nodeTag(call_data.lhs) != .super_expr) return false;
    // All constructor params must be simple (identifier or rest).
    for (params_raw) |p_raw| {
        if (!isSimpleParam(@enumFromInt(p_raw), ctx)) return false;
    }
    // Get the super call arguments.
    if (call_data.rhs == .none) {
        // No args at all: only valid when params is also empty.
        return params_raw.len == 0;
    }
    const range = ctx.extraData(SubRange, @intFromEnum(call_data.rhs));
    const call_args = ctx.extraSlice(range);

    // Check for `super(...arguments)`.
    if (call_args.len == 1) {
        const arg0: NodeIndex = @enumFromInt(call_args[0]);
        if (ctx.nodeTag(arg0) == .spread_element) {
            const spread_inner = ctx.nodeData(arg0).lhs;
            if (spread_inner != .none and ctx.nodeTag(spread_inner) == .identifier) {
                const id_text = ctx.tokenText(ctx.nodeMainToken(spread_inner));
                if (std.mem.eql(u8, id_text, "arguments")) return true;
            }
        }
    }

    // Check pass-through: same number of args, each matching param.
    return isPassingThrough(params_raw, call_args, ctx);
}

/// A "simple" param: Identifier or RestElement (no defaults, no destructuring).
fn isSimpleParam(param: NodeIndex, ctx: *const LintContext) bool {
    if (param == .none) return false;
    return switch (ctx.nodeTag(param)) {
        .identifier => true,
        .rest_element => true,
        else => false,
    };
}

/// True when ctorParams and superArgs have the same count and each pair matches.
fn isPassingThrough(params_raw: []const u32, args_raw: []const u32, ctx: *const LintContext) bool {
    if (params_raw.len != args_raw.len) return false;
    for (params_raw, args_raw) |p_raw, a_raw| {
        const p: NodeIndex = @enumFromInt(p_raw);
        const a: NodeIndex = @enumFromInt(a_raw);
        if (!isValidPair(p, a, ctx)) return false;
    }
    return true;
}

/// Matching pair: (identifier, identifier same name) or (rest, spread same name).
fn isValidPair(p: NodeIndex, a: NodeIndex, ctx: *const LintContext) bool {
    if (isValidIdentifierPair(p, a, ctx)) return true;
    if (isValidRestSpreadPair(p, a, ctx)) return true;
    return false;
}

fn isValidIdentifierPair(p: NodeIndex, a: NodeIndex, ctx: *const LintContext) bool {
    if (p == .none or a == .none) return false;
    if (ctx.nodeTag(p) != .identifier or ctx.nodeTag(a) != .identifier) return false;
    const p_name = ctx.tokenText(ctx.nodeMainToken(p));
    const a_name = ctx.tokenText(ctx.nodeMainToken(a));
    return std.mem.eql(u8, p_name, a_name);
}

fn isValidRestSpreadPair(p: NodeIndex, a: NodeIndex, ctx: *const LintContext) bool {
    if (p == .none or a == .none) return false;
    if (ctx.nodeTag(p) != .rest_element) return false;
    if (ctx.nodeTag(a) != .spread_element) return false;
    const p_inner = ctx.nodeData(p).lhs;
    const a_inner = ctx.nodeData(a).lhs;
    return isValidIdentifierPair(p_inner, a_inner, ctx);
}
