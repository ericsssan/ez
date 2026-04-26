const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "prefer-object-spread",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `Object.assign` with an object literal as the first argument",
};

pub const relevant_tags = [_]Node.Tag{.call_expr};
pub const needs_semantic = true;

/// Check if an object literal contains any getter or setter property.
fn hasGetterOrSetter(ctx: *const LintContext, obj_node: NodeIndex) bool {
    if (obj_node == .none) return false;
    if (ctx.nodeTag(obj_node) != .object_literal) return false;
    const d = ctx.nodeData(obj_node);
    const props = ctx.extraSlice(.{ .start = @intFromEnum(d.lhs), .end = @intFromEnum(d.rhs) });
    for (props) |p| {
        const prop: NodeIndex = @enumFromInt(p);
        if (prop == .none) continue;
        const tag = ctx.nodeTag(prop);
        if (tag == .getter_def or tag == .setter_def or
            tag == .computed_getter_def or tag == .computed_setter_def) return true;
    }
    return false;
}

fn isObjectGlobalUsable(ctx: *const LintContext) bool {
    const src = ctx.source();
    if (std.mem.indexOf(u8, src, "Object: off") != null or
        std.mem.indexOf(u8, src, "Object:off") != null) return false;
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), "Object")) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;

    if (ctx.nodeTag(callee) != .member_expr) return;
    const member_data = ctx.nodeData(callee);
    const obj = member_data.lhs;
    if (obj == .none or member_data.rhs == .none) return;
    if (ctx.nodeTag(obj) != .identifier) return;

    const obj_name = ctx.tokenText(ctx.nodeMainToken(obj));
    if (!std.mem.eql(u8, obj_name, "Object")) return;

    const prop_name = ctx.memberPropertyName(member_data.rhs);
    if (!std.mem.eql(u8, prop_name, "assign")) return;

    // Skip if Object is not the global Object.
    if (!isObjectGlobalUsable(ctx)) return;

    if (data.rhs == .none) return;
    const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    const args = ctx.extraSlice(range);
    if (args.len == 0) return;

    const first_arg: NodeIndex = @enumFromInt(args[0]);
    if (first_arg == .none) return;
    if (ctx.nodeTag(first_arg) != .object_literal) return;

    // Skip if any argument is a spread element (`...x`) — already using spread.
    for (args) |a| {
        const arg: NodeIndex = @enumFromInt(a);
        if (arg != .none and ctx.nodeTag(arg) == .spread_element) return;
    }

    // Skip if any argument (object literal) has getters or setters.
    for (args) |a| {
        const arg: NodeIndex = @enumFromInt(a);
        if (hasGetterOrSetter(ctx, arg)) return;
    }

    ctx.report(node);
}
