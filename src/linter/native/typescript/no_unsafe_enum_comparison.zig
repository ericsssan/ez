// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-enum-comparison
//
// Reports comparisons between an enum value and a non-enum value of a
// different type, and switch-case statements where the case value is
// not from the same enum as the discriminant.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-enum-comparison",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow comparing an enum value with a non-enum value",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .less_than, .greater_than, .less_equal, .greater_equal,
    .switch_stmt,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag == .switch_stmt) {
        checkSwitch(node, ctx);
        return;
    }
    checkComparison(node, ctx);
}

fn checkComparison(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;
    if (lhs == .none or rhs == .none) return;
    const left_enum = enumNameFor(lhs, ctx);
    const right_enum = enumNameFor(rhs, ctx);
    if (left_enum == null and right_enum == null) return;
    // Same enum on both sides — no fire.
    if (left_enum) |le| if (right_enum) |re| if (std.mem.eql(u8, le, re)) return;
    // If the OTHER side is null/undefined/any, allow it (TSe convention).
    const other = if (left_enum != null) rhs else lhs;
    if (isExemptValue(other, ctx)) return;
    // If the enum side is a TYPED VARIABLE (potential any enum value)
    // and the OTHER side is a literal incompatible with the enum's
    // kind, TSe treats this as trivially false and skips.  When the
    // enum side is a specific member access (e.g. `Fruit.Apple`), the
    // comparison still fires.
    const enum_name = if (left_enum) |le| le else right_enum.?;
    const enum_side = if (left_enum != null) lhs else rhs;
    if (isVariableReference(enum_side, ctx) and
        literalIsIncompatibleWithEnum(other, enum_name, ctx)) return;
    ctx.reportWithMessageId(node, "mismatchedCondition");
}

fn isVariableReference(n: NodeIndex, ctx: *const LintContext) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    return ctx.nodeTag(node) == .identifier;
}

fn literalIsIncompatibleWithEnum(n: NodeIndex, enum_name: []const u8, ctx: *const LintContext) bool {
    const enum_kind = ctx.enumKindOf(enum_name) orelse return false;
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    const tag = ctx.nodeTag(node);
    if (tag == .number_literal or tag == .bigint_literal) {
        return enum_kind == .string; // .mixed → false
    }
    if (tag == .unary_minus or tag == .unary_plus) {
        const inner = ctx.nodeData(node).lhs;
        const it = ctx.nodeTag(inner);
        if (it == .number_literal or it == .bigint_literal) return enum_kind == .string;
    }
    if (tag == .string_literal or tag == .template_literal) {
        return enum_kind == .number; // .mixed → false
    }
    // Boolean / object / array literals — never an enum value.
    if (tag == .boolean_literal or tag == .object_literal or tag == .array_literal) return true;
    return false;
}

fn isExemptValue(n: NodeIndex, ctx: *const LintContext) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    const tag = ctx.nodeTag(node);
    if (tag == .null_literal) return true;
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (std.mem.eql(u8, name, "undefined")) return true;
        // Identifier referring to a function/class declaration → can never be enum.
        if (identifierIsFunctionRef(name, ctx)) return true;
    }
    // `as any` cast → exempt.
    if (tag == .ts_as_expr or tag == .ts_satisfies_expr or tag == .ts_type_assertion) {
        const data = ctx.nodeData(node);
        const ty_side = if (tag == .ts_type_assertion) data.lhs else data.rhs;
        if (ty_side != .none and ctx.nodeTag(ty_side) == .ts_type_reference) {
            const tname = ctx.tokenText(ctx.nodeMainToken(ty_side));
            if (std.mem.eql(u8, tname, "any") or std.mem.eql(u8, tname, "unknown")) return true;
        }
    }
    return false;
}

/// Walks the AST to find a top-level function_decl / arrow_func_decl /
/// class_decl whose name matches.  Used to detect identifiers that
/// reference a function or class — incompatible with any enum.
fn identifierIsFunctionRef(name: []const u8, ctx: *const LintContext) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t == .fn_decl or t == .async_fn_decl or t == .generator_fn_decl or t == .async_generator_fn_decl) {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ni).lhs));
            if (fd.name != .none) {
                const nm = ctx.tokenText(ctx.nodeMainToken(fd.name));
                if (std.mem.eql(u8, nm, name)) return true;
            }
        } else if (t == .class_decl) {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(ni).lhs));
            if (cd.name != .none) {
                const nm = ctx.tokenText(ctx.nodeMainToken(cd.name));
                if (std.mem.eql(u8, nm, name)) return true;
            }
        }
    }
    return false;
}

fn checkSwitch(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const disc = data.lhs;
    if (disc == .none) return;
    const disc_enum = enumNameFor(disc, ctx);
    if (data.rhs == .none) return;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return;
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (s >= e or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const case_node: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(case_node) != .switch_case) continue;
        const case_data = ctx.nodeData(case_node);
        const case_val = case_data.lhs;
        if (case_val == .none) continue; // default
        const case_enum = enumNameFor(case_val, ctx);
        // Same enum on both sides → safe.
        if (disc_enum) |de| if (case_enum) |ce|
            if (std.mem.eql(u8, de, ce)) continue;
        // Both non-enum → safe.
        if (disc_enum == null and case_enum == null) continue;
        ctx.reportWithMessageId(case_node, "mismatchedCase");
    }
}

/// Return the enum NAME if the node refers to an enum value or is
/// an identifier annotated as an enum type.  null otherwise.
fn enumNameFor(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // Direct member access EnumName.Member.
    if (tag == .member_expr or tag == .optional_member_expr) {
        const data = ctx.nodeData(n);
        if (data.lhs == .none or ctx.nodeTag(data.lhs) != .identifier) return null;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
        if (ctx.enumKindOf(obj_name)) |_| return obj_name;
        return null;
    }
    // Identifier with annotation `: EnumName` or initialized to an enum value.
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        // Try semantic-resolved first; fall back to AST-search if needed.
        if (symbolForIdent(n, ctx)) |sym| {
            const decl = ctx.semantic.symbols.getDeclNode(sym);
            if (decl != .none and ctx.nodeTag(decl) == .identifier) {
                if (enumNameFromDecl(decl, ctx)) |r| return r;
            }
        }
        // AST-search fallback: find any declarator with matching name.
        return enumNameByDeclSearch(name, ctx);
    }
    return null;
}

fn enumNameFromDecl(decl: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const ann = ctx.nodeData(decl).rhs;
    if (ann != .none and ctx.nodeTag(ann) == .ts_type_annotation) {
        const ty = ctx.nodeData(ann).lhs;
        if (enumNameFromType(ty, ctx, 0)) |r| return r;
    }
    const parent = ctx.parentOf(decl);
    if (parent != .none and ctx.nodeTag(parent) == .declarator) {
        const init = ctx.nodeData(parent).rhs;
        if (init != .none) {
            if (enumNameForExpr(init, ctx)) |name| return name;
        }
    }
    return null;
}

/// Walks a type node, returning the first enum NAME found anywhere in
/// it (including inside unions, intersections, parens, and type
/// aliases).  Returns null if the type contains a plain primitive arm
/// that would let the variable hold a non-enum value (e.g. `Foo |
/// string`) — TSe treats those as safe.  `depth` guards against alias
/// cycles.
fn enumNameFromType(node: NodeIndex, ctx: *const LintContext, depth: u8) ?[]const u8 {
    if (depth > 4) return null;
    var ty = node;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_type_reference) {
        const tname = ctx.tokenText(ctx.nodeMainToken(ty));
        if (ctx.enumKindOf(tname)) |_| return tname;
        if (typeAliasBody(tname, ctx)) |body| {
            return enumNameFromType(body, ctx, depth + 1);
        }
        return null;
    }
    if (tag == .ts_union_type) {
        const arms = directRange(ty, ctx) orelse return null;
        var first_enum: ?[]const u8 = null;
        for (arms) |raw| {
            const child: NodeIndex = @enumFromInt(raw);
            if (unionArmEscapesEnum(child, ctx)) return null;
            if (first_enum == null) {
                if (enumNameFromType(child, ctx, depth + 1)) |r| first_enum = r;
            }
        }
        return first_enum;
    }
    if (tag == .ts_intersection_type) {
        const arms = directRange(ty, ctx) orelse return null;
        for (arms) |raw| {
            const child: NodeIndex = @enumFromInt(raw);
            if (enumNameFromType(child, ctx, depth + 1)) |r| return r;
        }
    }
    return null;
}

fn directRange(node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return null;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (s > e or e > ext_len) return null;
    return ctx.ast.extra_data[s..e];
}

/// True if this union arm is a plain primitive that would let the
/// variable hold a non-enum value — e.g. `string`, `number`, `'apple'`.
/// Branded primitives like `string & { __brand: void }` do NOT count.
fn unionArmEscapesEnum(node: NodeIndex, ctx: *const LintContext) bool {
    var ty = node;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    const tag = ctx.nodeTag(ty);
    if (tag == .ts_template_literal_type) return true;
    // `string` / `number` etc. AND literal-types (`'apple'`, `0`, `-1`,
    // `true`) all parse as `ts_type_reference`; disambiguate by the
    // main token's tag.
    if (tag == .ts_type_reference) {
        const mt = ctx.nodeMainToken(ty);
        const tt = ctx.tokenTag(mt);
        if (tt == .string_literal or tt == .number_literal or tt == .bigint_literal
            or tt == .kw_true or tt == .kw_false or tt == .minus) return true;
        const tname = ctx.tokenText(mt);
        if (std.mem.eql(u8, tname, "string") or std.mem.eql(u8, tname, "number") or
            std.mem.eql(u8, tname, "boolean") or std.mem.eql(u8, tname, "bigint")) return true;
    }
    return false;
}

/// Returns the body of `type <name> = <body>` if present.
fn typeAliasBody(name: []const u8, ctx: *const LintContext) ?NodeIndex {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_alias_decl) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        const td = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
        const nm = ctx.tokenText(td.name);
        if (!std.mem.eql(u8, nm, name)) continue;
        if (td.type_node == .none) return null;
        return td.type_node;
    }
    return null;
}

fn enumNameByDeclSearch(name: []const u8, ctx: *const LintContext) ?[]const u8 {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) continue;
        return enumNameFromDecl(d.lhs, ctx);
    }
    return null;
}

/// Like enumNameFor but only checks member-access patterns (used for
/// initializer inspection — avoids infinite recursion through identifiers).
fn enumNameForExpr(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .member_expr or tag == .optional_member_expr) {
        const data = ctx.nodeData(n);
        if (data.lhs == .none or ctx.nodeTag(data.lhs) != .identifier) return null;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
        if (ctx.enumKindOf(obj_name)) |_| return obj_name;
    }
    return null;
}

fn symbolForIdent(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}
