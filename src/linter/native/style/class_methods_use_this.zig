const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const TokenTag = @import("../../../parser/token.zig").Tag;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "class-methods-use-this",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce that class methods utilize `this`",
};

// Triggered once per class — inspect all members at once so we can see implements.
pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const class_data = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));

    const enforce_class_fields = ctx.getOptionBool("enforceForClassFields", true);
    const ignore_override = ctx.getOptionBool("ignoreOverrideMethods", false);
    const ignore_implements_opt = ctx.getOptionString("ignoreClassesWithImplements");
    const has_implements = class_data.impls_start != class_data.impls_end;

    const body_data = ctx.nodeData(class_data.body);
    if (body_data.lhs == .none or body_data.rhs == .none) return;
    const members = ctx.extraSlice(.{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    });

    for (members) |member_idx| {
        const member: NodeIndex = @enumFromInt(member_idx);
        const tag = ctx.nodeTag(member);

        switch (tag) {
            .constructor_def, .static_block => continue,

            .method_def, .getter_def, .setter_def,
            .computed_method_def, .computed_getter_def, .computed_setter_def,
            => checkMethod(member, tag, ctx, ignore_override, ignore_implements_opt, has_implements),

            .property_def, .computed_property_def => {
                if (enforce_class_fields) {
                    checkProperty(member, tag, ctx, ignore_override, ignore_implements_opt, has_implements);
                }
            },

            else => {},
        }
    }
}

fn checkMethod(
    node: NodeIndex,
    tag: Node.Tag,
    ctx: *const LintContext,
    ignore_override: bool,
    ignore_implements_opt: ?[]const u8,
    has_implements: bool,
) void {
    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));

    // Skip static members
    if (method_data.modifiers & ast.ModifierBit.@"static" != 0) return;

    // Skip abstract/declare (no body)
    if (method_data.body == .none) return;

    // Skip override methods if ignoreOverrideMethods
    if (ignore_override and method_data.modifiers & ast.ModifierBit.@"override" != 0) return;

    const key_node = data.lhs;

    // Skip constructor — parser.zig stores constructors as method_def (not constructor_def).
    // Detect via key name.
    if (tag == .method_def and key_node != .none) {
        const k_tag = ctx.nodeTag(key_node);
        const k_text = ctx.tokenText(ctx.nodeMainToken(key_node));
        const k_name: []const u8 = if (k_tag == .string_literal and k_text.len >= 2)
            k_text[1 .. k_text.len - 1]
        else
            k_text;
        if (std.mem.eql(u8, k_name, "constructor")) return;
    }

    // Check ignoreClassesWithImplements
    if (ignore_implements_opt) |impl_opt| {
        if (has_implements) {
            if (shouldSkipForImplements(key_node, method_data.modifiers, impl_opt, ctx)) return;
        }
    }

    // Check exceptMethods — computed methods are never excepted
    const is_computed = tag == .computed_method_def or tag == .computed_getter_def or tag == .computed_setter_def;
    if (!is_computed and key_node != .none and isExceptedMethod(key_node, tag, ctx)) return;

    // Check if body uses this/super; if not, report at the key node
    if (!usesThis(method_data.body, ctx, 0)) {
        const report_node = if (key_node != .none) key_node else node;
        ctx.report(report_node);
    }
}

fn checkProperty(
    node: NodeIndex,
    tag: Node.Tag,
    ctx: *const LintContext,
    ignore_override: bool,
    ignore_implements_opt: ?[]const u8,
    has_implements: bool,
) void {
    const data = ctx.nodeData(node);
    const prop_data = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));

    const key_node = data.lhs;

    // Skip static via backward token scan
    if (key_node != .none and isStaticProperty(key_node, ctx)) return;

    // Skip override properties if ignoreOverrideMethods (scan backward for kw_override)
    if (ignore_override and key_node != .none and isOverrideProperty(key_node, ctx)) return;

    // No value — nothing to check
    if (prop_data.value == .none) return;

    // Check ignoreClassesWithImplements (properties have no MethodData.modifiers,
    // so we derive "is private" from the key token)
    if (ignore_implements_opt) |impl_opt| {
        if (has_implements) {
            if (shouldSkipPropertyForImplements(key_node, ctx, impl_opt)) return;
        }
    }

    const value_node = prop_data.value;
    const value_tag = ctx.nodeTag(value_node);
    const value_data = ctx.nodeData(value_node);

    // Only enforce on function/arrow values
    const body: NodeIndex = switch (value_tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => blk: {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(value_data.lhs));
            break :blk fn_data.body;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(value_data.lhs));
            break :blk arrow_data.body;
        },
        else => return,
    };

    if (body == .none) return;

    // Check exceptMethods — not for computed property
    const is_computed_prop = tag == .computed_property_def;
    if (!is_computed_prop and key_node != .none and isExceptedMethod(key_node, tag, ctx)) return;

    if (!usesThis(body, ctx, 0)) {
        // Report on the function/arrow value (matching ESLint's node)
        ctx.report(value_node);
    }
}

// ── Helpers ────────────────────────────────────────────────────────────────

/// Returns true if the class member should be skipped due to ignoreClassesWithImplements.
/// `modifiers` is from MethodData. `opt` is "all" or "public-fields".
fn shouldSkipForImplements(key_node: NodeIndex, modifiers: u32, opt: []const u8, ctx: *const LintContext) bool {
    if (std.mem.eql(u8, opt, "all")) return true;
    if (std.mem.eql(u8, opt, "public-fields")) {
        // Skip only if: key is NOT a private identifier (#) AND accessibility is public/none
        const is_private_ident = isPrivateKey(key_node, ctx);
        if (is_private_ident) return false; // #name — never skip
        const accessibility = modifiers & ast.ModifierBit.accessibility_mask;
        const is_private_access = accessibility == ast.ModifierBit.acc_private or
            accessibility == ast.ModifierBit.acc_protected;
        if (is_private_access) return false; // private/protected — never skip
        return true; // public or no modifier — skip
    }
    return false;
}

/// Returns true if a property_def should be skipped for implements.
fn shouldSkipPropertyForImplements(key_node: NodeIndex, ctx: *const LintContext, opt: []const u8) bool {
    if (std.mem.eql(u8, opt, "all")) return true;
    if (std.mem.eql(u8, opt, "public-fields")) {
        // Skip only if: key is NOT a private identifier (#) AND no private/protected access modifier
        if (isPrivateKey(key_node, ctx)) return false; // private (#) — do NOT skip
        // Check for TypeScript access modifiers via backward token scan
        const acc = getPropertyAccessibility(key_node, ctx);
        if (acc == .private or acc == .protected) return false; // not public
        return true; // public/none — skip
    }
    return false;
}

/// Check if a key node is a private identifier (#name).
/// Private identifiers are stored as .identifier nodes with main_token = hash token.
fn isPrivateKey(key_node: NodeIndex, ctx: *const LintContext) bool {
    if (key_node == .none) return false;
    const main_tok = ctx.nodeMainToken(key_node);
    return ctx.tokenTag(main_tok) == .hash;
}

const Accessibility = enum { none, public, private, protected };

/// Scan backward from the key token to find a TypeScript access modifier.
fn getPropertyAccessibility(key_node: NodeIndex, ctx: *const LintContext) Accessibility {
    if (key_node == .none) return .none;
    const main_tok = ctx.nodeMainToken(key_node);
    if (main_tok == 0) return .none;
    var t: u32 = main_tok;
    while (t > 0) {
        t -= 1;
        const src = ctx.tokenText(@intCast(t));
        if (std.mem.eql(u8, src, "private")) return .private;
        if (std.mem.eql(u8, src, "protected")) return .protected;
        if (std.mem.eql(u8, src, "public")) return .public;
        // Stop at class body boundary tokens
        const tok_tag = ctx.tokenTag(@intCast(t));
        switch (tok_tag) {
            .l_brace, .r_brace, .semicolon => return .none,
            else => {},
        }
    }
    return .none;
}

/// Scan backward from the key token to find an `override` modifier.
fn isOverrideProperty(key_node: NodeIndex, ctx: *const LintContext) bool {
    if (key_node == .none) return false;
    const main_tok = ctx.nodeMainToken(key_node);
    if (main_tok == 0) return false;
    var t: u32 = main_tok;
    while (t > 0) {
        t -= 1;
        const tok_tag = ctx.tokenTag(@intCast(t));
        if (tok_tag == .kw_override) return true;
        switch (tok_tag) {
            .l_brace, .r_brace, .semicolon => return false,
            else => {},
        }
    }
    return false;
}

/// Scan backward from the key token to find a `static` modifier.
fn isStaticProperty(key_node: NodeIndex, ctx: *const LintContext) bool {
    if (key_node == .none) return false;
    const main_tok = ctx.nodeMainToken(key_node);
    if (main_tok == 0) return false;
    var t: u32 = main_tok;
    while (t > 0) {
        t -= 1;
        const tok_tag = ctx.tokenTag(@intCast(t));
        if (tok_tag == .kw_static) return true;
        switch (tok_tag) {
            .l_brace, .r_brace, .semicolon => return false,
            else => {},
        }
    }
    return false;
}

/// Check if a method name is in the exceptMethods list.
fn isExceptedMethod(key_node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) bool {
    _ = tag;
    const opts = ctx.getOptions() orelse return false;
    if (opts.* != .object) return false;
    const except_val = opts.object.get("exceptMethods") orelse return false;
    if (except_val != .array) return false;
    if (except_val.array.items.len == 0) return false;

    var name_buf: [256]u8 = undefined;
    const name = getKeyName(key_node, ctx, &name_buf) orelse return false;

    for (except_val.array.items) |item| {
        if (item != .string) continue;
        if (std.mem.eql(u8, item.string, name)) return true;
    }
    return false;
}

/// Get the string name of a class member key for exceptMethods comparison.
/// Returns null for computed (dynamic) keys.
fn getKeyName(key_node: NodeIndex, ctx: *const LintContext, buf: []u8) ?[]const u8 {
    if (key_node == .none) return null;
    const tag = ctx.nodeTag(key_node);
    const main_tok = ctx.nodeMainToken(key_node);
    const tok_tag = ctx.tokenTag(main_tok);

    switch (tag) {
        .identifier => {
            if (tok_tag == .hash) {
                // Private identifier: main_token = # token, next token = name
                // The name is "#field" — combine the two tokens
                if (main_tok + 1 < @as(u32, @intCast(ctx.ast.tokens.len))) {
                    const field_name = ctx.tokenText(main_tok + 1);
                    return std.fmt.bufPrint(buf, "#{s}", .{field_name}) catch null;
                }
                return null;
            }
            return ctx.tokenText(main_tok);
        },
        .string_literal => {
            const raw = ctx.tokenText(main_tok);
            if (raw.len >= 2) return raw[1 .. raw.len - 1]; // strip quotes
            return raw;
        },
        .number_literal => {
            // Normalize number: 42.0 → "42"
            const raw = ctx.tokenText(main_tok);
            const n = std.fmt.parseFloat(f64, raw) catch return raw;
            if (n == @trunc(n) and n >= 0) {
                const ival: u64 = @intFromFloat(n);
                return std.fmt.bufPrint(buf, "{d}", .{ival}) catch null;
            }
            return null;
        },
        else => return null, // computed key — not statically known
    }
}

/// Walk the AST looking for `this` or `super` usage.
/// Stops at regular function boundaries; continues through arrow functions.
/// Stops at nested class boundaries.
/// Returns true if this/super is found.
fn usesThis(node: NodeIndex, ctx: *const LintContext, depth: u8) bool {
    if (node == .none or depth > 48) return false;
    if (@intFromEnum(node) >= ctx.ast.nodes.len) return false;

    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        .this_expr, .super_expr => return true,

        // Stop at regular function boundaries (they have their own `this`)
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr, .async_generator_fn_decl, .async_generator_fn_expr,
        => return false,

        // Nested class: don't enter member bodies, but DO check computed keys
        // (ESLint evaluates computed keys before pushing a property context)
        .class_decl, .class_expr => {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
            const body_data = ctx.nodeData(cd.body);
            if (body_data.lhs == .none or body_data.rhs == .none) return false;
            const members = ctx.extraSlice(.{
                .start = @intFromEnum(body_data.lhs),
                .end = @intFromEnum(body_data.rhs),
            });
            for (members) |m_idx| {
                const m: NodeIndex = @enumFromInt(m_idx);
                const m_tag = ctx.nodeTag(m);
                // Traverse computed key expressions only
                switch (m_tag) {
                    .computed_method_def, .computed_getter_def, .computed_setter_def,
                    .computed_property_def,
                    => {
                        const m_data = ctx.nodeData(m);
                        if (usesThis(m_data.lhs, ctx, depth + 1)) return true;
                    },
                    else => {},
                }
            }
            return false;
        },

        // Stop at static block (its own `this`)
        .static_block => return false,

        // Continue INTO arrow functions (they inherit enclosing `this`)
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            return usesThis(arrow_data.body, ctx, depth + 1);
        },

        // block_stmt, var/let/const decls, sequence_expr: SubRange children
        .block_stmt, .var_decl, .let_decl, .const_decl, .sequence_expr => {
            if (data.lhs == .none or data.rhs == .none) return false;
            const start = @intFromEnum(data.lhs);
            const end = @intFromEnum(data.rhs);
            if (start >= end) return false;
            const range = ast.SubRange{ .start = start, .end = end };
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // if (cond) body — simple if
        .if_stmt => {
            // lhs = condition, rhs = body (consequent)
            return usesThis(data.lhs, ctx, depth + 1) or usesThis(data.rhs, ctx, depth + 1);
        },
        // if (cond) consequent else alternate
        .if_else_stmt => {
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            return usesThis(data.lhs, ctx, depth + 1) or
                usesThis(if_data.consequent, ctx, depth + 1) or
                usesThis(if_data.alternate, ctx, depth + 1);
        },

        // while (cond) body
        .while_stmt => {
            return usesThis(data.lhs, ctx, depth + 1) or usesThis(data.rhs, ctx, depth + 1);
        },
        // do body while (cond)
        .do_while_stmt => {
            return usesThis(data.lhs, ctx, depth + 1) or usesThis(data.rhs, ctx, depth + 1);
        },

        // for (init;cond;update) body
        .for_stmt => {
            const for_data = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            return usesThis(for_data.init, ctx, depth + 1) or
                usesThis(for_data.condition, ctx, depth + 1) or
                usesThis(for_data.update, ctx, depth + 1) or
                usesThis(data.rhs, ctx, depth + 1);
        },

        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            return usesThis(for_data.expr, ctx, depth + 1) or
                usesThis(for_data.body, ctx, depth + 1);
        },

        // switch (discriminant) { cases }
        .switch_stmt => {
            if (usesThis(data.lhs, ctx, depth + 1)) return true;
            if (data.rhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },
        // case expr: stmts
        .switch_case => {
            if (usesThis(data.lhs, ctx, depth + 1)) return true;
            if (data.rhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },
        // default: stmts
        .switch_default => {
            if (data.rhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // try { block } catch finally
        .try_stmt => {
            if (usesThis(data.lhs, ctx, depth + 1)) return true;
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            if (usesThis(try_data.catch_node, ctx, depth + 1)) return true;
            return usesThis(try_data.finally_body, ctx, depth + 1);
        },
        // catch (param) { body }
        .catch_clause => {
            return usesThis(data.rhs, ctx, depth + 1);
        },

        // call_expr / new_expr: lhs = callee, rhs = SubRange of args
        .call_expr, .optional_call_expr, .new_expr => {
            if (usesThis(data.lhs, ctx, depth + 1)) return true;
            if (data.rhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // array_literal: lhs = SubRange of elements
        .array_literal => {
            if (data.lhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.lhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // object_literal: lhs = SubRange of properties
        .object_literal => {
            if (data.lhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.lhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // template_literal: lhs = SubRange of parts/exprs
        .template_literal => {
            if (data.lhs == .none) return false;
            const range = ctx.extraData(ast.SubRange, @intFromEnum(data.lhs));
            for (ctx.extraSlice(range)) |item| {
                if (usesThis(@enumFromInt(item), ctx, depth + 1)) return true;
            }
            return false;
        },

        // conditional: a ? b : c
        .conditional => {
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            return usesThis(data.lhs, ctx, depth + 1) or
                usesThis(cond_data.consequent, ctx, depth + 1) or
                usesThis(cond_data.alternate, ctx, depth + 1);
        },

        // Single-child nodes (lhs = child)
        .expression_stmt,
        .return_stmt,
        .throw_stmt,
        .labeled_stmt,
        .unary_plus, .unary_minus, .bitwise_not, .logical_not,
        .typeof_expr, .void_expr, .delete_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .spread_element, .grouping_expr,
        .await_expr, .yield_expr, .yield_delegate,
        => return usesThis(data.lhs, ctx, depth + 1),

        // Two-child nodes (lhs, rhs both NodeIndex)
        .declarator,
        .assign, .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign, .shr_assign,
        .ushr_assign, .logical_and_assign, .logical_or_assign, .nullish_assign,
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .greater_than, .less_equal, .greater_equal,
        .instanceof_expr, .in_expr,
        .bitwise_and, .bitwise_or, .bitwise_xor, .shift_left, .shift_right, .unsigned_shift_right,
        .logical_and, .logical_or, .nullish_coalesce,
        .member_expr, .computed_member_expr, .optional_member_expr, .optional_computed_member_expr,
        .property, .computed_property,
        .assignment_pattern, .rest_element,
        .tagged_template,
        .with_stmt,
        => {
            if (usesThis(data.lhs, ctx, depth + 1)) return true;
            return usesThis(data.rhs, ctx, depth + 1);
        },

        // shorthand_property: lhs = identifier (no separate rhs to check for this)
        .shorthand_property => return usesThis(data.lhs, ctx, depth + 1),

        // Leaf nodes / nodes we don't recurse into
        else => return false,
    }
}
