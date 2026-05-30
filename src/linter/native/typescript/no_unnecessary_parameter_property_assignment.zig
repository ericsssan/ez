// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-parameter-property-assignment
//
// Reports `this.foo = foo;` inside a constructor body when `foo` is
// declared as a parameter property (`constructor(public foo: …)`).
// TypeScript already assigns parameter properties automatically; the
// redundant assignment is dead code.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-parameter-property-assignment",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow unnecessary assignment of constructor property parameter",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .method_def, .constructor_def };

const MAX_PROPS = 16;

// Operators that the rule treats as "unnecessary" reassignments:
//   =  ??=  &&=  ||=
fn isUnnecessaryOp(tag: Node.Tag) bool {
    return switch (tag) {
        .assign, .nullish_assign, .logical_and_assign, .logical_or_assign => true,
        else => false,
    };
}

// Compound write operators (not in the unnecessary set): += -= *= etc.
// Seeing one of these marks the property as "mutated before the redundant assign".
fn isCompoundWrite(tag: Node.Tag) bool {
    return switch (tag) {
        .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
        .exp_assign, .and_assign, .or_assign, .xor_assign,
        .shl_assign, .shr_assign, .ushr_assign => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only constructor methods.
    const key = ctx.nodeData(node).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor")) return;

    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.body == .none or ctx.nodeTag(md.body) != .block_stmt) return;

    // Collect parameter-property names (at most MAX_PROPS).
    var names: [MAX_PROPS][]const u8 = undefined;
    var n_names: usize = 0;
    if (md.params_end > md.params_start) {
        for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
            if (n_names >= MAX_PROPS) break;
            const p: NodeIndex = @enumFromInt(raw);
            const name = paramPropertyName(p, ctx) orelse continue;
            names[n_names] = name;
            n_names += 1;
        }
    }
    if (n_names == 0) return;

    // Scan class field initializers: if one writes to this.<name>, the explicit
    // assignment in the constructor restores the parameter value intentionally.
    const class_field_bits: u16 = classFieldBits(node, names[0..n_names], ctx);

    // Walk constructor body; track compound-written properties in assigned_before.
    var assigned_before: u16 = 0;
    walkBlock(md.body, names[0..n_names], &assigned_before, class_field_bits, 0, ctx);
}

fn paramPropertyName(p: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var inner = p;
    if (ctx.nodeTag(inner) == .ts_parameter_property) {
        const inner_data = ctx.nodeData(inner);
        if (inner_data.lhs == .none) return null;
        inner = inner_data.lhs;
        if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) != .identifier) return null;
        return ctx.tokenText(ctx.nodeMainToken(inner));
    }
    if (ctx.nodeTag(inner) == .assignment_pattern) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) != .identifier) return null;
    if (!hasParamPropModifier(inner, ctx)) return null;
    return ctx.tokenText(ctx.nodeMainToken(inner));
}

fn hasParamPropModifier(ident: NodeIndex, ctx: *const LintContext) bool {
    const mods = [_][]const u8{ "public", "private", "protected", "readonly" };
    for (mods) |m| if (hasModifierBefore(ident, m, ctx)) return true;
    return false;
}

fn hasModifierBefore(id: NodeIndex, kw: []const u8, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(id);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 4 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, kw)) return true;
        if (text.len == 1 and (text[0] == '(' or text[0] == ',')) break;
    }
    return false;
}

// Returns the static property name if `lhs` is `this.foo` or `this['foo']`.
fn propFromThisMember(lhs: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.nodeTag(lhs);
    if (tag != .member_expr and tag != .computed_member_expr) return null;
    const obj = ctx.nodeData(lhs).lhs;
    if (obj == .none or ctx.nodeTag(obj) != .this_expr) return null;
    return ctx.staticPropertyName(lhs);
}

fn nameIndex(name: []const u8, names: []const []const u8) ?usize {
    for (names, 0..) |n, i| {
        if (std.mem.eql(u8, n, name)) return i;
    }
    return null;
}

// Scan class field initializers for any assignment to this.<param_name>.
// Returns a bitset: bit i set means names[i] was written in a class field.
fn classFieldBits(ctor: NodeIndex, names: []const []const u8, ctx: *const LintContext) u16 {
    var bits: u16 = 0;
    const class_body = ctx.parentOf(ctor);
    if (class_body == .none or ctx.nodeTag(class_body) != .class_body) return bits;
    const body_data = ctx.nodeData(class_body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return bits;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(member);
        if (mt != .property_def and mt != .computed_property_def) continue;
        const pd = ctx.extraData(ast.PropertyData, @intFromEnum(ctx.nodeData(member).rhs));
        if (pd.value == .none) continue;
        scanExprForThisAssign(pd.value, names, &bits, ctx);
    }
    return bits;
}

// Recursively scan `expr` for any assignment whose LHS is this.<name>.
fn scanExprForThisAssign(expr: NodeIndex, names: []const []const u8, bits: *u16, ctx: *const LintContext) void {
    if (expr == .none) return;
    const tag = ctx.nodeTag(expr);
    const data = ctx.nodeData(expr);
    if (isUnnecessaryOp(tag) or isCompoundWrite(tag)) {
        if (data.lhs != .none) {
            if (propFromThisMember(data.lhs, ctx)) |name| {
                if (nameIndex(name, names)) |i| bits.* |= @as(u16, 1) << @intCast(i);
            }
        }
        if (data.rhs != .none) scanExprForThisAssign(data.rhs, names, bits, ctx);
        return;
    }
    switch (tag) {
        .grouping_expr, .ts_non_null_expr, .ts_as_expr, .ts_satisfies_expr,
        .logical_not, .bitwise_not, .typeof_expr, .void_expr, .delete_expr,
        .unary_plus, .unary_minus,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        .await_expr, .yield_expr, .spread_element => {
            if (data.lhs != .none) scanExprForThisAssign(data.lhs, names, bits, ctx);
        },
        .ts_type_assertion => {
            if (data.rhs != .none) scanExprForThisAssign(data.rhs, names, bits, ctx);
        },
        .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .logical_and, .logical_or, .nullish_coalesce,
        .equal, .not_equal, .strict_equal, .strict_not_equal,
        .less_than, .less_equal, .greater_than, .greater_equal,
        .shift_left, .shift_right, .unsigned_shift_right,
        .in_expr, .instanceof_expr, .sequence_expr => {
            if (data.lhs != .none) scanExprForThisAssign(data.lhs, names, bits, ctx);
            if (data.rhs != .none) scanExprForThisAssign(data.rhs, names, bits, ctx);
        },
        .member_expr, .computed_member_expr,
        .optional_member_expr, .optional_computed_member_expr => {
            if (data.lhs != .none) scanExprForThisAssign(data.lhs, names, bits, ctx);
        },
        .call_expr, .optional_call_expr => {
            if (data.lhs != .none) {
                var callee = data.lhs;
                while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) {
                    callee = ctx.nodeData(callee).lhs;
                }
                if (callee != .none and
                    (ctx.nodeTag(callee) == .arrow_fn or ctx.nodeTag(callee) == .async_arrow_fn))
                {
                    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(callee).lhs));
                    if (ad.body != .none) scanExprOrBlockForThisAssign(ad.body, names, bits, ctx);
                } else {
                    scanExprForThisAssign(data.lhs, names, bits, ctx);
                }
            }
        },
        else => {},
    }
}

fn scanExprOrBlockForThisAssign(node: NodeIndex, names: []const []const u8, bits: *u16, ctx: *const LintContext) void {
    if (node == .none) return;
    if (ctx.nodeTag(node) == .block_stmt) {
        const d = ctx.nodeData(node);
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (e <= s or e > ctx.ast.extra_data.len) return;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(stmt) == .expression_stmt) {
                const inner = ctx.nodeData(stmt).lhs;
                if (inner != .none) scanExprForThisAssign(inner, names, bits, ctx);
            }
        }
    } else {
        scanExprForThisAssign(node, names, bits, ctx);
    }
}

fn peelCasts(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var v = node;
    while (v != .none) {
        switch (ctx.nodeTag(v)) {
            .grouping_expr, .ts_non_null_expr, .ts_as_expr, .ts_satisfies_expr => {
                v = ctx.nodeData(v).lhs;
            },
            .ts_type_assertion => {
                v = ctx.nodeData(v).rhs;
            },
            else => break,
        }
    }
    return v;
}

// Returns a bitmask of which names[i] are declared by var/let/const in `stmt`.
fn declsInStmt(stmt: NodeIndex, names: []const []const u8, ctx: *const LintContext) u16 {
    var bits: u16 = 0;
    const tag = ctx.nodeTag(stmt);
    if (tag != .var_decl and tag != .let_decl and tag != .const_decl) return bits;
    const data = ctx.nodeData(stmt);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return bits;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const decl: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(decl) != .declarator) continue;
        const binding = ctx.nodeData(decl).lhs;
        if (binding == .none or ctx.nodeTag(binding) != .identifier) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(binding));
        if (nameIndex(name, names)) |i| bits |= @as(u16, 1) << @intCast(i);
    }
    return bits;
}

// shadows: bitmask of parameter property names shadowed by local declarations.
fn walkBlock(block: NodeIndex, names: []const []const u8, ab: *u16, cfb: u16, inherited_shadows: u16, ctx: *const LintContext) void {
    const data = ctx.nodeData(block);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    // Collect declarations in this block to detect shadowed parameter names.
    var shadows = inherited_shadows;
    for (ctx.ast.extra_data[s..e]) |raw| {
        shadows |= declsInStmt(@enumFromInt(raw), names, ctx);
    }
    for (ctx.ast.extra_data[s..e]) |raw| {
        walkStmt(@enumFromInt(raw), names, ab, cfb, shadows, ctx);
    }
}

fn walkStmt(stmt: NodeIndex, names: []const []const u8, ab: *u16, cfb: u16, shadows: u16, ctx: *const LintContext) void {
    if (stmt == .none) return;
    switch (ctx.nodeTag(stmt)) {
        .expression_stmt => {
            const expr = ctx.nodeData(stmt).lhs;
            if (expr != .none) walkExpr(expr, names, ab, cfb, shadows, ctx);
        },
        .block_stmt => walkBlock(stmt, names, ab, cfb, shadows, ctx),
        else => {},
    }
}

fn walkExpr(expr: NodeIndex, names: []const []const u8, ab: *u16, cfb: u16, shadows: u16, ctx: *const LintContext) void {
    if (expr == .none) return;
    const tag = ctx.nodeTag(expr);
    const data = ctx.nodeData(expr);

    if (isCompoundWrite(tag)) {
        if (data.lhs != .none) {
            if (propFromThisMember(data.lhs, ctx)) |name| {
                if (nameIndex(name, names)) |i| ab.* |= @as(u16, 1) << @intCast(i);
            }
        }
        return;
    }

    if (isUnnecessaryOp(tag)) {
        if (data.lhs != .none and data.rhs != .none) {
            if (propFromThisMember(data.lhs, ctx)) |name| {
                if (nameIndex(name, names)) |i| {
                    const v = peelCasts(data.rhs, ctx);
                    if (ctx.nodeTag(v) == .identifier and
                        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(v)), name))
                    {
                        const mask = @as(u16, 1) << @intCast(i);
                        if ((ab.* & mask) == 0 and (cfb & mask) == 0 and (shadows & mask) == 0) {
                            ctx.reportWithMessageId(expr, "unnecessaryAssign");
                        }
                    }
                }
            }
        }
        return;
    }

    // Arrow IIFE: (() => { ... })() — same this-binding, treat as inline body.
    if (tag == .call_expr or tag == .optional_call_expr) {
        if (data.lhs != .none) {
            var callee = data.lhs;
            while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) {
                callee = ctx.nodeData(callee).lhs;
            }
            if (callee != .none and
                (ctx.nodeTag(callee) == .arrow_fn or ctx.nodeTag(callee) == .async_arrow_fn))
            {
                const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(callee).lhs));
                if (ad.body != .none) {
                    if (ctx.nodeTag(ad.body) == .block_stmt) {
                        walkBlock(ad.body, names, ab, cfb, shadows, ctx);
                    } else {
                        walkExpr(ad.body, names, ab, cfb, shadows, ctx);
                    }
                }
            }
        }
    }
}
