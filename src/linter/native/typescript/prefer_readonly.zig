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
    /// Report span covers `[<modifier-tokens>...] <name>` — captured at
    /// candidate-collection time so we don't re-scan modifiers later.
    span_start: u32 = 0,
    span_end: u32 = 0,
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

    const only_inline_lambdas = optionOnlyInlineLambdas(ctx);

    var cands: [32]Candidate = undefined;
    var n_cands: usize = 0;
    for (ctx.ast.extra_data[s..e]) |raw| {
        if (n_cands >= cands.len) break;
        const member: NodeIndex = @enumFromInt(raw);
        if (collectCandidate(member, ctx)) |c| {
            if (only_inline_lambdas and !candidateHasInlineLambdaInit(member, ctx)) continue;
            cands[n_cands] = c;
            n_cands += 1;
        }
        // Parameter properties (constructor params with `private foo`).
        if (n_cands < cands.len) {
            collectParamPropCandidates(member, ctx, only_inline_lambdas, cands[0..], &n_cands);
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

    // Pre-pass: collect `const X = this` aliases anywhere in any class
    // member body, so writes via `X.field` are credited correctly.
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        collectAliases(&w, member, ctx);
    }

    // Walk each member.
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        walkMember(&w, member, ctx);
    }

    for (cands[0..n_cands]) |c| {
        if (c.bad_write) continue;
        if (c.is_static and c.has_write) continue;
        ctx.reportSpanWithMessageId(
            .{ .start = c.span_start, .end = c.span_end },
            "preferReadonly",
        );
    }
}

fn collectParamPropCandidates(
    member: NodeIndex,
    ctx: *const LintContext,
    only_inline_lambdas: bool,
    cands: []Candidate,
    n_cands: *usize,
) void {
    const tag = ctx.nodeTag(member);
    const is_ctor = tag == .constructor_def or
        (tag == .method_def and blk: {
            const d = ctx.nodeData(member);
            if (d.lhs == .none) break :blk false;
            if (ctx.nodeTag(d.lhs) != .identifier) break :blk false;
            break :blk std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), "constructor");
        });
    if (!is_ctor) return;
    const d = ctx.nodeData(member);
    if (d.rhs == .none) return;
    const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
    if (meth.params_end <= meth.params_start) return;
    if (meth.params_end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[meth.params_start..meth.params_end]) |raw| {
        if (n_cands.* >= cands.len) break;
        const p: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(p) != .ts_parameter_property) continue;
        const c = collectParamPropCandidate(p, ctx) orelse continue;
        if (only_inline_lambdas) {
            // Check if the param has an arrow default.
            const pd = ctx.nodeData(p);
            var def = pd.rhs;
            while (ctx.nodeTag(def) == .grouping_expr) def = ctx.nodeData(def).lhs;
            const dtag = ctx.nodeTag(def);
            if (dtag != .arrow_fn and dtag != .async_arrow_fn) continue;
        }
        cands[n_cands.*] = c;
        n_cands.* += 1;
    }
}

fn collectParamPropCandidate(p: NodeIndex, ctx: *const LintContext) ?Candidate {
    const d = ctx.nodeData(p);
    // The binding identifier is at d.lhs (parameter binding).  Could be
    // wrapped in assignment_pattern when there's a default; or the
    // default is at d.rhs.
    var binding = d.lhs;
    if (ctx.nodeTag(binding) == .assignment_pattern) {
        binding = ctx.nodeData(binding).lhs;
    }
    if (ctx.nodeTag(binding) != .identifier) return null;
    const name = ctx.tokenText(ctx.nodeMainToken(binding));

    // Modifier scan: walk back from the binding identifier — catches
    // all modifier tokens (`public readonly` etc.) preceding the name.
    const binding_tok_pre = ctx.nodeMainToken(binding);
    var has_private = false;
    var has_readonly = false;
    var has_accessor = false;
    var has_static = false;
    var first_mod_tok: u32 = binding_tok_pre;
    scanModifiersFull(ctx, binding_tok_pre, &has_private, &has_readonly, &has_accessor, &has_static, &first_mod_tok);
    if (has_readonly) return null;
    if (!has_private) return null;
    // Param property name span: from modifier to binding.
    const binding_tok = ctx.nodeMainToken(binding);
    const span_start = ctx.ast.tokenStart(first_mod_tok);
    const span_end = ctx.tokenEnd(binding_tok);

    return .{
        .key_node = binding,
        .name = name,
        .is_hash = false,
        .is_static = false,
        .span_start = span_start,
        .span_end = span_end,
    };
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
        // Computed key — TSe ignores computed keys with string-literal
        // values (since they can be aliased via `obj["x"]` access we
        // can't statically detect).  Skip these candidates entirely.
        var k = key;
        while (ctx.nodeTag(k) == .grouping_expr) k = ctx.nodeData(k).lhs;
        if (ctx.nodeTag(k) == .string_literal) return null;
        name = &.{};
        has_name = true;
    }

    const key_tok = ctx.nodeMainToken(key);
    // Use the member's main_token as the modifier-scan anchor — for
    // computed keys (`private [Symbol.iterator]`) the key's own
    // main_token is inside the brackets so walking back from there
    // would miss the modifier.
    const scan_anchor = ctx.nodeMainToken(member);
    var has_private = false;
    var has_readonly = false;
    var has_accessor = false;
    var has_static = false;
    var first_mod_tok: u32 = scan_anchor;
    scanModifiersFull(ctx, scan_anchor, &has_private, &has_readonly, &has_accessor, &has_static, &first_mod_tok);
    if (has_readonly or has_accessor) return null;
    if (!has_private and !is_hash) return null;
    if (!has_name) return null;

    // Span: from first modifier to end of name.
    const span_start = ctx.ast.tokenStart(first_mod_tok);
    var name_end_tok: u32 = key_tok;
    if (is_hash and key_tok + 1 < ctx.ast.tokens.len) name_end_tok = key_tok + 1;
    var span_end = ctx.tokenEnd(name_end_tok);
    // For computed keys (`[expr]`), extend the span to include the
    // closing bracket — TSe reports the full `[...]` range.
    if (tag == .computed_property_def) {
        // Find the next `]` token after key_tok.
        var t: u32 = key_tok + 1;
        while (t < ctx.ast.tokens.len and t < key_tok + 32) : (t += 1) {
            if (std.mem.eql(u8, ctx.tokenText(t), "]")) {
                span_end = ctx.tokenEnd(t);
                break;
            }
        }
    }

    return .{
        .key_node = key,
        .name = name,
        .is_hash = is_hash,
        .is_static = has_static,
        .span_start = span_start,
        .span_end = span_end,
    };
}

fn optionOnlyInlineLambdas(ctx: *const LintContext) bool {
    const v = ctx.rule_options orelse return false;
    if (v.* != .object) return false;
    if (v.object.get("onlyInlineLambdas")) |x| if (x == .bool) return x.bool;
    return false;
}

fn candidateHasInlineLambdaInit(member: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.nodeData(member);
    if (d.rhs == .none) return false;
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(d.rhs));
    if (pd.value == .none) return false;
    var v = pd.value;
    while (ctx.nodeTag(v) == .grouping_expr) v = ctx.nodeData(v).lhs;
    const tag = ctx.nodeTag(v);
    return tag == .arrow_fn or tag == .async_arrow_fn;
}

fn scanModifiersFull(
    ctx: *const LintContext,
    anchor_tok: u32,
    has_private: *bool,
    has_readonly: *bool,
    has_accessor: *bool,
    has_static: *bool,
    first_mod_tok: *u32,
) void {
    if (anchor_tok == 0) return;
    var t = anchor_tok - 1;
    var depth: u32 = 0;
    while (depth < 10) : (depth += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "private")) {
            has_private.* = true;
        } else if (std.mem.eql(u8, txt, "readonly")) {
            has_readonly.* = true;
        } else if (std.mem.eql(u8, txt, "accessor")) {
            has_accessor.* = true;
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
        first_mod_tok.* = t;
        if (t == 0) break;
        t -= 1;
    }
}

const Walker = struct {
    cands: []Candidate,
    class_name: []const u8,
    budget: u32,
    aliases: [4][]const u8 = .{ &.{}, &.{}, &.{}, &.{} },
    alias_count: u8 = 0,
};

fn addAlias(w: *Walker, name: []const u8) void {
    if (w.alias_count >= w.aliases.len) return;
    w.aliases[w.alias_count] = name;
    w.alias_count += 1;
}

fn isAlias(w: *const Walker, name: []const u8) bool {
    var i: usize = 0;
    while (i < w.alias_count) : (i += 1) {
        if (std.mem.eql(u8, w.aliases[i], name)) return true;
    }
    return false;
}

fn step(w: *Walker) bool {
    if (w.budget == 0) return false;
    w.budget -= 1;
    return true;
}

/// Recursive scan: find `const X = this` / `let X = this` declarators
/// anywhere within the class members.  Adds X to the alias list.
fn collectAliases(w: *Walker, node: NodeIndex, ctx: *const LintContext) void {
    collectAliasesDepth(w, node, ctx, 0);
}

/// True when `node` is `this`, or a TS type assertion wrapping a `this`-
/// flavored type — `({} as this & { _b: 'x' })`, `({} as typeof Class &
/// ...)`, `<this>X`, etc.  Used by alias collection to recognise
/// `const that = {} as this & ...` patterns.
fn exprIsThisLike(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (true) {
        const tag = ctx.nodeTag(n);
        if (tag == .grouping_expr) {
            n = ctx.nodeData(n).lhs;
            continue;
        }
        if (tag == .this_expr) return true;
        // TS `expr as Type` / `<Type>expr` / `expr satisfies Type` —
        // unwrap the value side and recurse on the type-position for a
        // `this`-flavored target.
        if (tag == .ts_as_expr or tag == .ts_satisfies_expr) {
            const d = ctx.nodeData(n);
            // d.rhs = type expression; if it references `this`, treat the
            // whole as a this-like alias.
            if (typeNodeMentionsThis(d.rhs, ctx, 0)) return true;
            return false;
        }
        return false;
    }
}

fn typeNodeMentionsThis(node: NodeIndex, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 8) return false;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    if (tag == .this_expr) return true;
    if (tag == .ts_type_reference) {
        // `this` keyword in type position is emitted as ts_type_reference
        // with main_token = the `this` keyword token.
        const txt = ctx.tokenText(ctx.nodeMainToken(node));
        if (std.mem.eql(u8, txt, "this")) return true;
    }
    if (tag == .ts_typeof_type) {
        // typeof ClassName — common with `static` aliases.
        return true;
    }
    if (tag == .ts_intersection_type or tag == .ts_union_type) {
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e > s and e <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[s..e]) |raw| {
                const child: NodeIndex = @enumFromInt(raw);
                if (typeNodeMentionsThis(child, ctx, depth + 1)) return true;
            }
        }
    }
    if (tag == .ts_parenthesized_type) {
        return typeNodeMentionsThis(d.lhs, ctx, depth + 1);
    }
    return false;
}

fn collectAliasesDepth(w: *Walker, node: NodeIndex, ctx: *const LintContext, depth: u32) void {
    if (node == .none or depth > 128) return;
    if (!step(w)) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    if (tag == .declarator) {
        if (d.rhs != .none and exprIsThisLike(d.rhs, ctx)) {
            if (d.lhs != .none and ctx.nodeTag(d.lhs) == .identifier) {
                addAlias(w, ctx.tokenText(ctx.nodeMainToken(d.lhs)));
            }
        }
    }
    // Descend through the same safe tag set as walkNode but ignoring
    // write-recording.  Reuse the structural recursion: enter common
    // containers and methods, skip arbitrary unknown tags.
    switch (tag) {
        .property_def, .computed_property_def => {
            if (d.rhs != .none) {
                const pd = ctx.extraData(ast.PropertyData, @intFromEnum(d.rhs));
                if (pd.value != .none) collectAliasesDepth(w, pd.value, ctx, depth + 1);
            }
        },
        .method_def, .computed_method_def, .getter_def, .computed_getter_def,
        .setter_def, .computed_setter_def, .constructor_def => {
            if (d.rhs != .none) {
                const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
                collectAliasesDepth(w, meth.body, ctx, depth + 1);
            }
        },
        .block_stmt, .var_decl, .let_decl, .const_decl, .sequence_expr,
        .array_literal, .object_literal => {
            const ss = @intFromEnum(d.lhs);
            const ee = @intFromEnum(d.rhs);
            if (ee > ss and ee <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[ss..ee]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    collectAliasesDepth(w, child, ctx, depth + 1);
                }
            }
        },
        .expression_stmt, .return_stmt, .throw_stmt, .grouping_expr,
        .void_expr, .typeof_expr, .delete_expr,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .spread_element, .yield_expr, .yield_delegate, .await_expr => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
        },
        .if_stmt, .while_stmt, .do_while_stmt, .with_stmt, .labeled_stmt, .conditional => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .for_stmt => {
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .for_in_stmt, .for_of_stmt, .try_stmt, .switch_stmt, .switch_case,
        .catch_clause => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .less_equal, .greater_than, .greater_equal,
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .logical_and, .logical_or, .nullish_coalesce,
        .in_expr, .instanceof_expr,
        .member_expr, .optional_member_expr,
        .computed_member_expr, .optional_computed_member_expr => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .and_assign, .or_assign, .xor_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign,
        .exp_assign, .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .call_expr, .optional_call_expr, .new_expr => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            if (d.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        const arg: NodeIndex = @enumFromInt(raw);
                        collectAliasesDepth(w, arg, ctx, depth + 1);
                    }
                }
            }
        },
        .declarator => {
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            collectAliasesDepth(w, fd.body, ctx, depth + 1);
        },
        .arrow_fn, .async_arrow_fn => {
            if (d.lhs == .none) return;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            collectAliasesDepth(w, ad.body, ctx, depth + 1);
        },
        .property => {
            collectAliasesDepth(w, d.lhs, ctx, depth + 1);
            collectAliasesDepth(w, d.rhs, ctx, depth + 1);
        },
        else => {},
    }
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
        // Method-shaped object-literal properties — descend into the
        // body as a nested function (writes there are "not direct
        // constructor body" but still observable for write tracking).
        .getter_def, .computed_getter_def,
        .setter_def, .computed_setter_def,
        .method_def, .computed_method_def => {
            if (d.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
            walkParams(w, meth.params_start, meth.params_end, ctx);
            walkNode(w, meth.body, false, true, ctx, depth + 1);
            return;
        },
        // Property field inside object pattern or class body if hit again.
        .property_def, .computed_property_def => {
            if (d.rhs == .none) return;
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(d.rhs));
            if (pd.value != .none) walkNode(w, pd.value, false, true, ctx, depth + 1);
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

fn recordIfDestructure(w: *Walker, node: NodeIndex, in_ctor: bool, nested_fn: bool, ctx: *const LintContext, depth: u32) void {
    if (node == .none or depth > 16) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .object_pattern, .array_pattern, .object_literal, .array_literal => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const child: NodeIndex = @enumFromInt(raw);
                    recordIfDestructure(w, child, in_ctor, nested_fn, ctx, depth + 1);
                }
            }
        },
        .property, .computed_property => {
            // value side carries the target.
            recordIfDestructure(w, d.rhs, in_ctor, nested_fn, ctx, depth + 1);
        },
        .shorthand_property => {
            recordIfDestructure(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
        },
        .rest_element, .assignment_pattern => {
            recordIfDestructure(w, d.lhs, in_ctor, nested_fn, ctx, depth + 1);
        },
        .member_expr => recordIfCandidate(w, node, in_ctor, nested_fn, ctx),
        else => {},
    }
}

fn recordIfCandidate(w: *Walker, target: NodeIndex, in_ctor: bool, nested_fn: bool, ctx: *const LintContext) void {
    if (target == .none) return;
    var t = target;
    if (ctx.nodeTag(t) == .grouping_expr) t = ctx.nodeData(t).lhs;
    const tag = ctx.nodeTag(t);
    // Destructuring target: walk pattern to discover nested `this.X` /
    // `Class.X` writes.
    if (tag == .object_pattern or tag == .array_pattern or
        tag == .rest_element or tag == .assignment_pattern or
        tag == .property or tag == .computed_property or tag == .shorthand_property or
        tag == .object_literal or tag == .array_literal)
    {
        recordIfDestructure(w, t, in_ctor, nested_fn, ctx, 0);
        return;
    }
    if (tag != .member_expr and tag != .computed_member_expr) return;
    const md = ctx.nodeData(t);
    if (md.rhs == .none) return;
    var prop_text: []const u8 = &.{};
    var prop_tok: u32 = 0;
    if (tag == .member_expr) {
        prop_tok = ctx.nodeMainToken(md.rhs);
        prop_text = ctx.tokenText(prop_tok);
    } else {
        // computed_member_expr: rhs is the [key] expression.  Accept
        // string-literal keys (`this['prop']`) — extract the inner text.
        var k = md.rhs;
        while (ctx.nodeTag(k) == .grouping_expr) k = ctx.nodeData(k).lhs;
        if (ctx.nodeTag(k) != .string_literal) return;
        const raw = ctx.tokenText(ctx.nodeMainToken(k));
        if (raw.len < 2) return;
        prop_text = raw[1 .. raw.len - 1];
        prop_tok = ctx.nodeMainToken(k);
    }

    var lhs = md.lhs;
    while (ctx.nodeTag(lhs) == .grouping_expr) lhs = ctx.nodeData(lhs).lhs;
    const lhs_tag = ctx.nodeTag(lhs);
    var is_this = lhs_tag == .this_expr;
    var matched_class = false;
    var via_alias = false;
    if (!is_this and lhs_tag == .identifier) {
        const tn = ctx.tokenText(ctx.nodeMainToken(lhs));
        if (w.class_name.len > 0 and std.mem.eql(u8, tn, w.class_name)) matched_class = true;
        // `const self = this; self.field = ...` — treat as this-receiver.
        if (!matched_class and isAlias(w, tn)) {
            is_this = true;
            via_alias = true;
        }
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
        // Alias-based accesses are treated as compatible with either
        // form (the alias could be typed as `this` or `typeof Class`).
        if (!via_alias) {
            if (c.is_static and is_this) continue;
            if (!c.is_static and !is_this) continue;
        }
        c.has_write = true;
        if (c.is_static) {
            c.bad_write = true;
            continue;
        }
        if (!(in_ctor and !nested_fn)) c.bad_write = true;
    }
}
