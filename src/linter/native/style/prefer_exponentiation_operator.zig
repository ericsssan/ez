const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "prefer-exponentiation-operator",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow the use of `Math.pow` in favor of the `**` operator",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };
pub const needs_semantic = true;

fn unwrap(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var current = node;
    var depth: u32 = 0;
    while (current != .none and depth < 5) : (depth += 1) {
        if (ctx.nodeTag(current) != .grouping_expr) break;
        current = ctx.nodeData(current).lhs;
    }
    return current;
}

fn isMathGlobal(ctx: *const LintContext) bool {
    const src = ctx.source();
    if (std.mem.indexOf(u8, src, "Math: off") != null or
        std.mem.indexOf(u8, src, "Math:off") != null) return false;
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), "Math")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

/// Get property name from member or computed_member with string literal key.
fn getPowName(data: Node.Data, tag: Node.Tag, ctx: *const LintContext) ?[]const u8 {
    if (tag == .member_expr or tag == .optional_member_expr) {
        if (data.rhs == .none) return null;
        return ctx.memberPropertyName(data.rhs);
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        if (data.rhs == .none) return null;
        const key_tag = ctx.nodeTag(data.rhs);
        if (key_tag == .string_literal) {
            const text = ctx.tokenText(ctx.nodeMainToken(data.rhs));
            return if (text.len >= 2) text[1 .. text.len - 1] else null;
        }
        // Static template `` `pow` ``
        if (key_tag == .template_literal) {
            const d = ctx.nodeData(data.rhs);
            if (@intFromEnum(d.rhs) - @intFromEnum(d.lhs) == 1) {
                const text = ctx.tokenText(ctx.nodeMainToken(data.rhs));
                return if (text.len >= 2) text[1 .. text.len - 1] else null;
            }
        }
        return null;
    }
    return null;
}

fn isMathIdent(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "Math");
}

fn isGlobalThisUsable(ctx: *const LintContext) bool {
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), "globalThis")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

fn isGlobalThisMath(node: NodeIndex, ctx: *const LintContext) bool {
    // globalThis.Math
    if (ctx.nodeTag(node) != .member_expr) return false;
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return false;
    if (!std.mem.eql(u8, ctx.memberPropertyName(d.rhs), "Math")) return false;
    const obj = d.lhs;
    if (obj == .none or ctx.nodeTag(obj) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "globalThis");
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee_raw = data.lhs;
    if (callee_raw == .none) return;

    const callee = unwrap(callee_raw, ctx);
    if (callee == .none) return;
    const callee_tag = ctx.nodeTag(callee);

    const callee_d = ctx.nodeData(callee);
    const pow_name = getPowName(callee_d, callee_tag, ctx) orelse return;
    if (!std.mem.eql(u8, pow_name, "pow")) return;

    // Check Math is the object: Math.pow or globalThis.Math.pow
    const object_raw = callee_d.lhs;
    if (object_raw == .none) return;
    const object = unwrap(object_raw, ctx);
    if (object == .none) return;

    const is_math = isMathIdent(object, ctx);
    // globalThis.Math.pow is only flagged when ecmaVersion >= 2020
    const is_globalthis_math = !is_math and
        isGlobalThisMath(object, ctx) and
        ctx.getEcmaVersion() >= 2020;

    if (!is_math and !is_globalthis_math) return;

    if (!isMathGlobal(ctx)) return;
    if (is_globalthis_math and !isGlobalThisUsable(ctx)) return;

    // Report at the object (Math) position for correct line number
    ctx.report(object);
}
