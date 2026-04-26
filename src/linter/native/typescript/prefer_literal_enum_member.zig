const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-literal-enum-member",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require all enum members to be literal values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_member};
pub const needs_semantic = true;

fn isStaticTemplateLiteral(ctx: *const LintContext, n: NodeIndex) bool {
    const d = ctx.nodeData(n);
    const start = @intFromEnum(d.lhs);
    const end = @intFromEnum(d.rhs);
    return (end - start) == 1; // only one element = no substitutions
}

fn isLiteralInit(ctx: *const LintContext, n: NodeIndex) bool {
    if (n == .none) return false;
    return switch (ctx.nodeTag(n)) {
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal, .regex_literal,
        => true,
        .template_literal => isStaticTemplateLiteral(ctx, n),
        .unary_minus, .unary_plus => blk: {
            const d = ctx.nodeData(n);
            if (d.lhs == .none) break :blk false;
            const inner = ctx.nodeTag(d.lhs);
            break :blk inner == .number_literal or inner == .bigint_literal;
        },
        else => false,
    };
}

fn isBitwiseOp(tag: Node.Tag) bool {
    return switch (tag) {
        .shift_left, .shift_right, .unsigned_shift_right,
        .bitwise_or, .bitwise_and, .bitwise_xor,
        => true,
        else => false,
    };
}

/// Get enum member name text for a ts_enum_member node.
fn getMemberName(member: NodeIndex, ctx: *const LintContext) []const u8 {
    const d = ctx.nodeData(member);
    const name_node = d.lhs;
    if (name_node == .none) return "";
    return ctx.tokenText(ctx.nodeMainToken(name_node));
}

/// Check if `node` is a self-enum member reference in the context of `enum_decl`.
/// Returns true for:
///   - Identifier matching an enum member name (e.g. `A`)
///   - MemberExpression where object is the enum name and property is a member (e.g. `Foo.A`)
///   - ComputedMemberExpression with string key matching a member (e.g. `Foo['A']`)
fn isSelfEnumMember(
    n: NodeIndex,
    ctx: *const LintContext,
    enum_decl: NodeIndex,
    enum_name: []const u8,
) bool {
    if (n == .none) return false;
    const tag = ctx.nodeTag(n);

    if (tag == .identifier) {
        // Check if this identifier matches any member of the enum
        const name = ctx.tokenText(ctx.nodeMainToken(n));
        return enumHasMember(enum_decl, ctx, name);
    }

    if (tag == .member_expr) {
        // Foo.A — check object is enum name, property is member
        const d = ctx.nodeData(n);
        if (d.lhs == .none) return false;
        if (ctx.nodeTag(d.lhs) != .identifier) return false;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(d.lhs));
        if (!std.mem.eql(u8, obj_name, enum_name)) return false;
        const prop = ctx.memberPropertyName(d.rhs);
        return enumHasMember(enum_decl, ctx, prop);
    }

    if (tag == .computed_member_expr) {
        // Foo['A'] — check object is enum name, computed key is string
        const d = ctx.nodeData(n);
        if (d.lhs == .none) return false;
        if (ctx.nodeTag(d.lhs) != .identifier) return false;
        const obj_name = ctx.tokenText(ctx.nodeMainToken(d.lhs));
        if (!std.mem.eql(u8, obj_name, enum_name)) return false;
        // rhs is the computed key node
        if (d.rhs == .none) return false;
        if (ctx.nodeTag(d.rhs) != .string_literal) return false;
        const key_text = ctx.tokenText(ctx.nodeMainToken(d.rhs));
        if (key_text.len < 2) return false;
        const key = key_text[1 .. key_text.len - 1]; // strip quotes
        return enumHasMember(enum_decl, ctx, key);
    }

    return false;
}

/// Check if enum_decl has a member with the given name.
fn enumHasMember(enum_decl: NodeIndex, ctx: *const LintContext, name: []const u8) bool {
    if (enum_decl == .none) return false;
    const d = ctx.nodeData(enum_decl);
    const enum_data = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    const members = ctx.extraSlice(.{ .start = enum_data.members_start, .end = enum_data.members_end });
    for (members) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(member) != .ts_enum_member) continue;
        const member_name = getMemberName(member, ctx);
        if (std.mem.eql(u8, member_name, name)) return true;
    }
    return false;
}

/// Recursively check that an expression under allowBitwiseExpressions
/// consists only of: literals, self-enum member refs, unary±/~, bitwise ops.
fn isBitwiseLiteralExpr(
    ctx: *const LintContext,
    n: NodeIndex,
    enum_decl: NodeIndex,
    enum_name: []const u8,
    depth: u8,
) bool {
    if (n == .none or depth > 16) return false;
    if (isLiteralInit(ctx, n)) return true;
    const tag = ctx.nodeTag(n);
    // Self-enum member reference
    if (isSelfEnumMember(n, ctx, enum_decl, enum_name)) return true;
    // Grouping: (expr)
    if (tag == .grouping_expr) {
        const d = ctx.nodeData(n);
        return isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, depth + 1);
    }
    if (isBitwiseOp(tag)) {
        const d = ctx.nodeData(n);
        return isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, depth + 1) and
               isBitwiseLiteralExpr(ctx, d.rhs, enum_decl, enum_name, depth + 1);
    }
    if (tag == .unary_minus or tag == .unary_plus or tag == .bitwise_not) {
        const d = ctx.nodeData(n);
        return isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, depth + 1);
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const init = data.rhs;

    if (init == .none) return;

    if (isLiteralInit(ctx, init)) return;

    // allowBitwiseExpressions option
    const allow_bitwise_opt = blk: {
        if (ctx.getOptions()) |o| switch (o.*) {
            .object => |obj| {
                if (obj.get("allowBitwiseExpressions")) |v| {
                    if (v == .bool) break :blk v.bool;
                }
            },
            else => {},
        };
        break :blk false;
    };

    if (allow_bitwise_opt) {
        // Find the parent enum declaration and its name
        const enum_decl = blk: {
            var cur = ctx.parentOf(node);
            while (cur != .none) {
                if (ctx.nodeTag(cur) == .ts_enum_decl) break :blk cur;
                cur = ctx.parentOf(cur);
            }
            break :blk NodeIndex.none;
        };

        const enum_name = blk: {
            if (enum_decl == .none) break :blk @as([]const u8, "");
            const ed = ctx.nodeData(enum_decl);
            const enum_data = ctx.extraData(ast.EnumData, @intFromEnum(ed.lhs));
            break :blk ctx.tokenText(enum_data.name);
        };

        const init_tag = ctx.nodeTag(init);
        if (isBitwiseOp(init_tag)) {
            const d = ctx.nodeData(init);
            if (isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, 0) and
                isBitwiseLiteralExpr(ctx, d.rhs, enum_decl, enum_name, 0)) return;
        }
        if (init_tag == .bitwise_not) {
            const d = ctx.nodeData(init);
            if (isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, 0)) return;
        }
        if (init_tag == .grouping_expr) {
            const d = ctx.nodeData(init);
            if (isBitwiseLiteralExpr(ctx, d.lhs, enum_decl, enum_name, 0)) return;
        }
    }

    ctx.report(node);
}
