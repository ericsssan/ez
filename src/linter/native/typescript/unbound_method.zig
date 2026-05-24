// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/unbound-method

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "unbound-method",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unbound use of class methods",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr, .optional_member_expr,
    .object_pattern,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    if (tag == .object_pattern) {
        checkObjectPattern(node, ctx);
        return;
    }
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return;
    const prop = ctx.tokenText(ctx.nodeMainToken(d.rhs));
    if (prop.len == 0) return;

    // Skip if this member-expr is in a "safe" position.
    if (isSafePosition(node, ctx)) return;

    // Instance-method case: receiver's type has a method-defined prop.
    const recv_ty = ctx.typeOfNode(d.lhs);
    if (ctx.typeIdObjectPropertyIsMethod(recv_ty, prop)) {
        ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
        return;
    }
    // Static-method case: receiver is an Identifier that resolves to a
    // class declaration which contains a `static` method_def named
    // `prop`.  Walk the class body syntactically.
    if (staticMethodAccess(d.lhs, prop, ctx)) {
        ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
        return;
    }
}

fn staticMethodAccess(recv: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    // Resolve to the class declaration via the type-decl table.
    const class_name = ctx.tokenText(ctx.nodeMainToken(n));
    if (class_name.len == 0) return false;
    const decl = ctx.classDeclByName(class_name);
    if (decl == .none) return false;
    return classHasStaticMethod(decl, prop, ctx);
}

fn classHasStaticMethod(decl: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.body == .none) return false;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .method_def) continue;
        const md_data = ctx.nodeData(m);
        if (md_data.rhs == .none) continue;
        const meth = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
        if ((meth.modifiers & ast.ModifierBit.@"static") == 0) continue;
        if (md_data.lhs == .none) continue;
        const k = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
        if (std.mem.eql(u8, k, prop)) return true;
    }
    return false;
}

/// Destructuring `const { method } = instance` extracts methods
/// without their `this`-binding — fire on each pattern entry that
/// matches a class instance method.
fn checkObjectPattern(node: NodeIndex, ctx: *const LintContext) void {
    // Find the source of the destructuring (the declarator's init or
    // the right-hand side of an assign / for-of).
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    var source_ty: tymod.TypeId = tymod.ID_UNKNOWN;
    var have_source = false;
    switch (ctx.nodeTag(parent)) {
        .declarator => {
            const pd = ctx.nodeData(parent);
            if (pd.rhs == .none) return;
            source_ty = ctx.typeOfNode(pd.rhs);
            have_source = true;
        },
        .assign => {
            const pd = ctx.nodeData(parent);
            source_ty = ctx.typeOfNode(pd.rhs);
            have_source = true;
        },
        else => return,
    }
    if (!have_source) return;

    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const child: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(child);
        var name_node: NodeIndex = .none;
        if (tag == .shorthand_property) {
            name_node = ctx.nodeData(child).lhs;
        } else if (tag == .property or tag == .computed_property) {
            name_node = ctx.nodeData(child).lhs;
        }
        if (name_node == .none) continue;
        if (ctx.nodeTag(name_node) != .identifier) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(name_node));
        if (ctx.typeIdObjectPropertyIsMethod(source_ty, name)) {
            ctx.reportWithMessageId(name_node, "unboundWithoutThisAnnotation");
        }
    }
}

/// Member-expressions in these positions don't lose `this` binding:
///   - As the callee of a CallExpression: `obj.m()`.
///   - As the receiver of a chained member call: `obj.m.bind(obj)`.
///   - As the target of `delete` or `typeof`.
///   - As the target of an assignment (writing into the object).
fn isSafePosition(node: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(node);
    if (parent == .none) return false;
    const ptag = ctx.nodeTag(parent);
    const pd = ctx.nodeData(parent);
    // Direct call: `obj.m()` — callee position.
    if (ptag == .call_expr or ptag == .optional_call_expr or ptag == .new_expr) {
        if (pd.lhs == node) return true;
    }
    // Member chain: `obj.m.bind`, `obj.m.call`, `obj.m.apply` — receiver
    // position of a known binding helper.
    if (ptag == .member_expr or ptag == .optional_member_expr) {
        if (pd.lhs == node and pd.rhs != .none) {
            const prop = ctx.tokenText(ctx.nodeMainToken(pd.rhs));
            if (std.mem.eql(u8, prop, "bind") or
                std.mem.eql(u8, prop, "call") or
                std.mem.eql(u8, prop, "apply"))
            {
                return true;
            }
        }
    }
    // Delete / typeof are safe (they don't call the method).
    if (ptag == .delete_expr or ptag == .typeof_expr) return true;
    // `void obj.m;` voids the value — `void instance.unbound;` is
    // typically used as a "consume the reference" expression, but TSe
    // still treats it as an unbound reference.  Don't add void_expr to
    // safe positions.
    // Assignment LHS: `obj.m = ...`.
    if (isWriteOpTag(ptag) and pd.lhs == node) return true;
    // Equality compares — comparing against undefined/null/etc.: `obj.m === undefined`.
    switch (ptag) {
        .equal, .not_equal, .strict_equal, .strict_not_equal => return true,
        else => {},
    }
    // Conditional / boolean-context positions — `obj.m` used as a
    // truthiness/null test isn't called, so `this` isn't lost.
    switch (ptag) {
        .if_stmt, .while_stmt, .do_while_stmt, .for_stmt => return true,
        .conditional => return ctx.nodeData(parent).lhs == node, // cond only
        .logical_not => return true,
        .tagged_template => return true,
        else => {},
    }
    // For && / || / ?? the operand is "safe" iff the whole logical is
    // itself in a boolean-context ancestor — walk up to decide.
    if (ptag == .logical_and or ptag == .logical_or or ptag == .nullish_coalesce) {
        return ancestorIsBoolCtx(parent, ctx);
    }
    return false;
}

fn ancestorIsBoolCtx(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        const t = ctx.nodeTag(cur);
        switch (t) {
            .if_stmt, .while_stmt, .do_while_stmt, .for_stmt => return true,
            .conditional => return ctx.nodeData(cur).lhs == node,
            .logical_not => return true,
            .logical_and, .logical_or, .nullish_coalesce => {},
            .grouping_expr => {},
            else => return false,
        }
        const nxt = ctx.parentOf(cur);
        if (nxt == .none) return false;
        cur = nxt;
    }
    return false;
}

fn isWriteOpTag(tag: Node.Tag) bool {
    return switch (tag) {
        .assign,
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .shl_assign, .shr_assign, .ushr_assign,
        .and_assign, .or_assign, .xor_assign,
        .logical_and_assign, .logical_or_assign, .nullish_assign,
        .exp_assign,
        => true,
        else => false,
    };
}
