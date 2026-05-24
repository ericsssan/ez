// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-readonly
//
// Flags TS-private (`private foo = ...`) and hash-private (`#foo = ...`)
// class fields without the `readonly` modifier that have no writes
// outside the constructor's direct lexical body (instance) or no
// writes at all (static).
//
// Tag-explicit body walk avoids the unsafe "descend through arbitrary
// lhs/rhs" pattern that mis-treats extra-data indices as NodeIndex.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-readonly",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest readonly for never-mutated private class members",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .class_decl, .class_expr,
};

pub const needs_semantic = false;

const Candidate = struct {
    key_node: NodeIndex,
    name: []const u8,
    is_hash: bool,
    is_static: bool,
    bad_write: bool = false,
    has_write: bool = false,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const d = ctx.nodeData(node);
    if (d.lhs == .none) return;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.body == .none) return;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;

    var cands: [32]Candidate = undefined;
    var n_cands: usize = 0;
    for (ctx.ast.extra_data[s..e]) |raw| {
        if (n_cands >= cands.len) break;
        const member: NodeIndex = @enumFromInt(raw);
        if (collectCandidate(member, ctx)) |c| {
            cands[n_cands] = c;
            n_cands += 1;
        }
    }
    if (n_cands == 0) return;

    var class_name: []const u8 = &.{};
    if (cd.name != .none) class_name = ctx.tokenText(ctx.nodeMainToken(cd.name));

    var w = Walker{
        .cands = cands[0..n_cands],
        .class_name = class_name,
        .budget = 50000,
    };

    // Walk each member.
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        walkMember(&w, member, ctx);
    }

    for (cands[0..n_cands]) |c| {
        if (c.bad_write) continue;
        if (c.is_static and c.has_write) continue;
        ctx.reportWithMessageId(c.key_node, "preferReadonly");
    }
}

fn collectCandidate(member: NodeIndex, ctx: *const LintContext) ?Candidate {
    const tag = ctx.nodeTag(member);
    if (tag != .property_def and tag != .computed_property_def) return null;
    const d = ctx.nodeData(member);
    const key = d.lhs;
    if (key == .none) return null;

    const key_tag = ctx.nodeTag(key);
    var name: []const u8 = undefined;
    var is_hash: bool = false;
    var has_name: bool = false;
    if (key_tag == .identifier) {
        const tok = ctx.nodeMainToken(key);
        const text = ctx.tokenText(tok);
        if (text.len > 0 and text[0] == '#') {
            is_hash = true;
            if (text.len > 1) {
                name = text[1..];
                has_name = true;
            } else if (tok + 1 < ctx.ast.tokens.len) {
                name = ctx.tokenText(tok + 1);
                has_name = true;
            }
        } else {
            name = text;
            has_name = true;
        }
    } else if (tag == .computed_property_def) {
        // Computed key — we still recognise the field but skip name-based
        // write tracking (the rule still fires when there are no writes).
        name = &.{};
        has_name = true;
    }

    const key_tok = ctx.nodeMainToken(key);
    var has_private = false;
    var has_readonly = false;
    var has_static = false;
    scanModifiers(ctx, key_tok, &has_private, &has_readonly, &has_static);
    if (has_readonly) return null;
    if (!has_private and !is_hash) return null;
    if (!has_name) return null;

    return .{
        .key_node = key,
        .name = name,
        .is_hash = is_hash,
        .is_static = has_static,
    };
}

fn scanModifiers(
    ctx: *const LintContext,
    key_tok: u32,
    has_private: *bool,
    has_readonly: *bool,
    has_static: *bool,
) void {
    if (key_tok == 0) return;
    var t = key_tok - 1;
    var depth: u32 = 0;
    while (depth < 8) : (depth += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "private")) {
            has_private.* = true;
        } else if (std.mem.eql(u8, txt, "readonly")) {
            has_readonly.* = true;
        } else if (std.mem.eql(u8, txt, "static")) {
            has_static.* = true;
        } else if (!std.mem.eql(u8, txt, "public") and
            !std.mem.eql(u8, txt, "protected") and
            !std.mem.eql(u8, txt, "abstract") and
            !std.mem.eql(u8, txt, "override") and
            !std.mem.eql(u8, txt, "declare"))
        {
            break;
        }
        if (t == 0) break;
        t -= 1;
    }
}

const Walker = struct {
    cands: []Candidate,
    class_name: []const u8,
    budget: u32,
};

fn step(w: *Walker) bool {
    if (w.budget == 0) return false;
    w.budget -= 1;
    return true;
}

fn walkMember(w: *Walker, member: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(member);
    switch (tag) {
        .property_def, .computed_property_def => {
            const d = ctx.nodeData(member);
            if (d.rhs == .none) return;
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(d.rhs));
            // Field initializer — non-constructor context, would-be bad_write.
            if (pd.value != .none) walkNode(w, pd.value, false, false, ctx, 0);
        },
        .method_def, .computed_method_def => {
            const d = ctx.nodeData(member);
            if (d.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
            // Detect constructor-named method_def — our parser emits
            // .method_def with key="constructor" for in-class constructor
            // bodies (only stub no-body constructors get .constructor_def).
            var is_ctor = false;
            if (d.lhs != .none and ctx.nodeTag(d.lhs) == .identifier) {
                const k = ctx.tokenText(ctx.nodeMainToken(d.lhs));
                if (std.mem.eql(u8, k, "constructor")) is_ctor = true;
            }
            walkParams(w, meth.params_start, meth.params_end, ctx);
            walkNode(w, meth.body, is_ctor, !is_ctor, ctx, 0);
        },
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def => {
            const d = ctx.nodeData(member);
            if (d.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
            walkParams(w, meth.params_start, meth.params_end, ctx);
            walkNode(w, meth.body, false, true, ctx, 0);
        },
        .constructor_def => {
            const d = ctx.nodeData(member);
            if (d.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
            walkParams(w, meth.params_start, meth.params_end, ctx);
            // Constructor body — direct context allows writes.
            walkNode(w, meth.body, true, false, ctx, 0);
        },
        else => {},
    }
}

fn walkParams(w: *Walker, start: u32, end: u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        walkNode(w, p, false, false, ctx, 0);
    }
}

/// Tag-allowlist walker.  Only descends into known statement/expression
/// tags; for unknown tags it leaves descent to the caller (no-op).  This
/// prevents the unsafe "treat extra-data offsets as NodeIndex" descent
/// that the earlier generic walker performed.
fn walkNode(w: *Walker, node: NodeIndex, in_ctor: bool, nested_fn: bool, ctx: *const LintContext, depth: u32) void {
    if (node == .none) return;
    if (depth > 128) return;
    if (!step(w)) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);

    // Write operations.
    if (isWriteOpTag(tag)) {
        recordIfCandidate(w, d.lhs, in_ctor, nested_fn, ctx);
        walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
        walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
        return;
    }
    if (tag == .delete_expr) {
        recordIfCandidate(w, d.lhs, in_ctor, nested_fn, ctx);
        walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
        return;
    }

    // Functional barriers — nested fn/class contexts.
    if (isFunctionLike(tag)) {
        walkFnLikeBody(w, node, in_ctor, true, ctx, depth + 1);
        return;
    }
    if (tag == .class_decl or tag == .class_expr) {
        // Inner classes are independent for this rule — we don't track
        // their fields under the OUTER candidate set.  Skip descent.
        return;
    }

    // Statement containers.
    switch (tag) {
        .block_stmt => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    walkNode(w, child, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
            return;
        },
        .expression_stmt, .return_stmt, .throw_stmt, .grouping_expr,
        .void_expr, .delete_expr, .typeof_expr,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .spread_element, .yield_expr, .yield_delegate, .await_expr,
        => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .if_stmt, .while_stmt, .do_while_stmt, .with_stmt, .labeled_stmt,
        .conditional,
        => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .for_stmt => {
            // lhs = extra ForData index; rhs = body.
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .for_in_stmt, .for_of_stmt => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .try_stmt => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .switch_stmt => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .switch_case => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            // rhs is SubRange of stmts.
            const ss = @intFromEnum(d.rhs);
            // Best-effort: skip; case body walk is uncommon for this rule.
            _ = ss;
            return;
        },
        .catch_clause => {
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        // Binary / logical operators — descend both.
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .less_equal, .greater_than, .greater_equal,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .logical_and, .logical_or, .nullish_coalesce,
        .in_expr, .instanceof_expr,
        => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        // Member / call: walk object/callee + args.
        .member_expr, .optional_member_expr => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            // rhs is property_ident node — no descent needed for our purpose.
            return;
        },
        .computed_member_expr, .optional_computed_member_expr => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .call_expr, .optional_call_expr, .new_expr => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        const arg: NodeIndex = @enumFromInt(raw);
                        walkNode(w, arg, in_ctor, nested_fn, ctx, depth + 1);
                    }
                }
            }
            return;
        },
        .var_decl, .let_decl, .const_decl => {
            const ss = @intFromEnum(d.lhs);
            const ee = @intFromEnum(d.rhs);
            if (ee > ss and ee <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[ss..ee]) |raw| {
                    const dec: NodeIndex = @enumFromInt(raw);
                    walkNode(w, dec, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
            return;
        },
        .declarator => {
            // lhs = binding (may have annotation in rhs slot of identifier);
            // rhs = init expression.
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .sequence_expr => {
            const ss = @intFromEnum(d.lhs);
            const ee = @intFromEnum(d.rhs);
            if (ee > ss and ee <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[ss..ee]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    walkNode(w, child, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
            return;
        },
        .array_literal => {
            const ss = @intFromEnum(d.lhs);
            const ee = @intFromEnum(d.rhs);
            if (ee > ss and ee <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[ss..ee]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    walkNode(w, child, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
            return;
        },
        .object_literal => {
            const ss = @intFromEnum(d.lhs);
            const ee = @intFromEnum(d.rhs);
            if (ee > ss and ee <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[ss..ee]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    walkNode(w, child, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
            return;
        },
        .property => {
            walkNode(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
            walkNode(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
            return;
        },
        .template_literal, .tagged_template => {
            // Skip — string-only walks; can't contain `this.X = X` writes.
            return;
        },
        else => return,
    }
}

fn walkFnLikeBody(w: *Walker, node: NodeIndex, in_ctor: bool, nested_fn: bool, ctx: *const LintContext, depth: u32) void {
    _ = in_ctor;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            walkParams(w, fd.params, fd.params_end, ctx);
            walkNode(w, fd.body, false, nested_fn, ctx, depth);
        },
        .arrow_fn, .async_arrow_fn => {
            if (d.lhs == .none) return;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            walkParams(w, ad.params_start, ad.params_end, ctx);
            walkNode(w, ad.body, false, nested_fn, ctx, depth);
        },
        else => {},
    }
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        => true,
        else => false,
    };
}

fn isWriteOpTag(tag: Node.Tag) bool {
    return switch (tag) {
        .assign,
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .and_assign, .or_assign, .xor_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign,
        .exp_assign,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        => true,
        else => false,
    };
}

fn recordIfCandidate(w: *Walker, target: NodeIndex, in_ctor: bool, nested_fn: bool, ctx: *const LintContext) void {
    if (target == .none) return;
    var t = target;
    if (ctx.nodeTag(t) == .grouping_expr) t = ctx.nodeData(t).lhs;
    const tag = ctx.nodeTag(t);
    if (tag != .member_expr) return;
    const md = ctx.nodeData(t);
    if (md.rhs == .none) return;
    const prop_tok = ctx.nodeMainToken(md.rhs);
    const prop_text = ctx.tokenText(prop_tok);

    var lhs = md.lhs;
    while (ctx.nodeTag(lhs) == .grouping_expr) lhs = ctx.nodeData(lhs).lhs;
    const lhs_tag = ctx.nodeTag(lhs);
    const is_this = lhs_tag == .this_expr;
    var matched_class = false;
    if (!is_this and lhs_tag == .identifier) {
        const tn = ctx.tokenText(ctx.nodeMainToken(lhs));
        if (w.class_name.len > 0 and std.mem.eql(u8, tn, w.class_name)) matched_class = true;
    }
    if (!is_this and !matched_class) return;

    for (w.cands) |*c| {
        var match = false;
        if (c.is_hash) {
            if (prop_text.len >= 1 and prop_text[0] == '#') {
                if (prop_text.len > 1) {
                    if (std.mem.eql(u8, prop_text[1..], c.name)) match = true;
                } else if (prop_tok + 1 < ctx.ast.tokens.len) {
                    const next = ctx.tokenText(prop_tok + 1);
                    if (std.mem.eql(u8, next, c.name)) match = true;
                }
            }
            // Hash fields can be accessed via `this.#x` (instance/static) or
            // `ClassName.#x` (static).  Both are valid contexts here.
        } else {
            if (std.mem.eql(u8, prop_text, c.name)) match = true;
        }
        if (!match) continue;
        // Instance fields accessed via `this.X`; static via `Class.X`.
        if (c.is_static and is_this) continue;
        if (!c.is_static and !is_this) continue;
        c.has_write = true;
        if (c.is_static) {
            c.bad_write = true;
            continue;
        }
        if (!(in_ctor and !nested_fn)) c.bad_write = true;
    }
}
