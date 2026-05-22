// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-parameter-property-assignment
//
// Reports `this.foo = foo;` inside a constructor body when `foo` is
// declared as a parameter property (`constructor(public foo: …)`).
// TypeScript already assigns parameter properties automatically; the
// redundant assignment is dead code.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
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

pub const relevant_tags = [_]Node.Tag{.method_def};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Only constructor methods are interesting.
    const key = ctx.nodeData(node).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor")) return;
    // Collect parameter-property names (with their access modifier).
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.body == .none or ctx.nodeTag(md.body) != .block_stmt) return;
    var names: [16][]const u8 = undefined;
    var n_names: usize = 0;
    if (md.params_end > md.params_start) {
        for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
            if (n_names >= names.len) break;
            const p: NodeIndex = @enumFromInt(raw);
            const name = paramPropertyName(p, ctx) orelse continue;
            names[n_names] = name;
            n_names += 1;
        }
    }
    if (n_names == 0) return;
    // Walk the constructor's BLOCK body for statements of shape
    // `this.<name> = <init>;` where init resolves (after peeling
    // casts / non-null) to the parameter identifier.
    const body_data = ctx.nodeData(md.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e > s and e <= ctx.ast.extra_data.len) {
        for (ctx.ast.extra_data[s..e]) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            checkStmt(stmt, names[0..n_names], ctx);
        }
    }
}

fn paramPropertyName(p: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var inner = p;
    // Either explicit `ts_parameter_property` wrapper or a bare
    // identifier with a modifier keyword in the preceding tokens.
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

fn checkStmt(stmt: NodeIndex, names: []const []const u8, ctx: *const LintContext) void {
    if (ctx.nodeTag(stmt) != .expression_stmt) return;
    const expr = ctx.nodeData(stmt).lhs;
    if (expr == .none or ctx.nodeTag(expr) != .assign) return;
    const lhs = ctx.nodeData(expr).lhs;
    const rhs = ctx.nodeData(expr).rhs;
    if (lhs == .none or rhs == .none) return;
    if (ctx.nodeTag(lhs) != .member_expr) return;
    const member_obj = ctx.nodeData(lhs).lhs;
    if (member_obj == .none or ctx.nodeTag(member_obj) != .this_expr) return;
    const prop_name = ctx.tokenText(ctx.nodeMainToken(lhs));
    var found = false;
    for (names) |n| if (std.mem.eql(u8, n, prop_name)) { found = true; break; };
    if (!found) return;
    // RHS, peeling non-null / casts.
    var v = rhs;
    while (true) {
        const t = ctx.nodeTag(v);
        if (t == .grouping_expr or t == .ts_non_null_expr) {
            v = ctx.nodeData(v).lhs;
            continue;
        }
        if (t == .ts_as_expr or t == .ts_satisfies_expr) {
            v = ctx.nodeData(v).lhs;
            continue;
        }
        if (t == .ts_type_assertion) {
            v = ctx.nodeData(v).rhs;
            continue;
        }
        break;
    }
    if (ctx.nodeTag(v) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(v)), prop_name)) return;
    ctx.reportWithMessageId(expr, "unnecessaryAssign");
}
