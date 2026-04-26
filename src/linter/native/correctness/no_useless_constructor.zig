const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ModifierBit = ast.ModifierBit;

pub const meta = RuleMeta{
    .name = "no-useless-constructor",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unnecessary constructors",
};

pub const relevant_tags = [_]Node.Tag{ .constructor_def, .method_def };
pub const needs_semantic = true;

const std = @import("std");

/// Check if any constructor parameter has a decorator (TS parameter decorators).
/// Decorators are consumed by the parser, so scan tokens in the param region.
fn hasParameterDecorators(method_data: ast.MethodData, ctx: *const LintContext) bool {
    const params = ctx.extraSlice(.{
        .start = method_data.params_start,
        .end = method_data.params_end,
    });
    if (params.len == 0) return false;
    // Check token before each param's main token for `@` sign
    for (params) |p| {
        const param: NodeIndex = @enumFromInt(p);
        if (param == .none) continue;
        const main_tok = ctx.nodeMainToken(param);
        // Scan back up to 5 tokens for `@` before this param
        var t: u32 = if (main_tok > 0) main_tok - 1 else 0;
        var d: u32 = 0;
        var paren_depth: u32 = 0;
        while (t > 0 and d < 20) : ({ t -= 1; d += 1; }) {
            const tt = ctx.tokenTag(t);
            if (tt == .at_sign) return true;
            // Track parens to skip decorator argument lists
            if (tt == .r_paren) { paren_depth += 1; continue; }
            if (tt == .l_paren) {
                if (paren_depth == 0) break; // start of param list
                paren_depth -= 1;
                continue;
            }
            // Stop at comma at paren_depth 0 (separates parameters)
            if (tt == .comma and paren_depth == 0) break;
        }
    }
    return false;
}

/// Check if the constructor has TS parameter properties (private/public/protected params).
fn hasParameterProperties(method_data: ast.MethodData, ctx: *const LintContext) bool {
    const params = ctx.extraSlice(.{
        .start = method_data.params_start,
        .end = method_data.params_end,
    });
    for (params) |p| {
        const param: NodeIndex = @enumFromInt(p);
        if (param == .none) continue;
        if (ctx.nodeTag(param) == .ts_parameter_property) return true;
    }
    return false;
}

/// Check if the class containing this constructor has a superclass (extends clause).
/// Uses source scan since TS parser sets super_class=.none even when extends is present.
fn classHasSuperclass(node: NodeIndex, ctx: *const LintContext) bool {
    return classHasSuperclassFromSource(node, ctx);
}

fn classHasSuperclassFromSource(node: NodeIndex, ctx: *const LintContext) bool {
    const src = ctx.source();
    const pos = ctx.tokenStart(ctx.nodeMainToken(node));
    if (pos == 0) return false;
    // Scan backward from constructor position to find "extends" before class opening `{`
    // Only look within 500 chars to avoid performance issues
    const scan_start = if (pos > 500) pos - 500 else 0;
    const region = src[scan_start..pos];
    // Find "extends" keyword in this region
    if (std.mem.indexOf(u8, region, "extends") != null) return true;
    return false;
}

/// Check if params list perfectly forwards to super call args.
/// True if constructor(a, b, ...c) { super(a, b, ...c) } pattern.
fn paramsPerfectlyForwardToSuper(method_data: ast.MethodData, super_args: []const u32, ctx: *const LintContext) bool {
    const params = ctx.extraSlice(.{
        .start = method_data.params_start,
        .end = method_data.params_end,
    });
    if (params.len != super_args.len) return false;
    for (params, super_args) |p, a| {
        const param: NodeIndex = @enumFromInt(p);
        const arg: NodeIndex = @enumFromInt(a);
        if (param == .none or arg == .none) return false;

        const param_tag = ctx.nodeTag(param);
        const arg_tag = ctx.nodeTag(arg);

        // param = identifier, arg = identifier with same name
        if (param_tag == .identifier and arg_tag == .identifier) {
            const pname = ctx.tokenText(ctx.nodeMainToken(param));
            const aname = ctx.tokenText(ctx.nodeMainToken(arg));
            if (!std.mem.eql(u8, pname, aname)) return false;
            continue;
        }
        // param = rest_element, arg = spread_element
        if (param_tag == .rest_element and arg_tag == .spread_element) {
            // Check if same identifier
            const rest_binding = ctx.nodeData(param).lhs;
            const spread_operand = ctx.nodeData(arg).lhs;
            if (rest_binding == .none or spread_operand == .none) return false;
            if (ctx.nodeTag(rest_binding) != .identifier or ctx.nodeTag(spread_operand) != .identifier) return false;
            const rname = ctx.tokenText(ctx.nodeMainToken(rest_binding));
            const sname = ctx.tokenText(ctx.nodeMainToken(spread_operand));
            if (!std.mem.eql(u8, rname, sname)) return false;
            continue;
        }
        return false;
    }
    return true;
}

/// Returns true if `stmt` is `super(...)` where the args perfectly delegate all constructor params.
fn isSuperDelegate(stmt: NodeIndex, method_data: ast.MethodData, ctx: *const LintContext) bool {
    if (ctx.nodeTag(stmt) != .expression_stmt) return false;
    const expr = ctx.nodeData(stmt).lhs;
    if (expr == .none or ctx.nodeTag(expr) != .call_expr) return false;

    const call_data = ctx.nodeData(expr);
    if (call_data.lhs == .none or ctx.nodeTag(call_data.lhs) != .super_expr) return false;

    if (call_data.rhs == .none) {
        // super() with no args — only useless if constructor has no params
        const params = ctx.extraSlice(.{ .start = method_data.params_start, .end = method_data.params_end });
        return params.len == 0;
    }

    const args_range = ctx.extraData(ast.SubRange, @intFromEnum(call_data.rhs));
    const args = ctx.extraSlice(args_range);

    // super(...arguments) — single spread of `arguments`
    if (args.len == 1) {
        const arg: NodeIndex = @enumFromInt(args[0]);
        if (arg != .none and ctx.nodeTag(arg) == .spread_element) {
            const operand = ctx.nodeData(arg).lhs;
            if (operand != .none and ctx.nodeTag(operand) == .identifier) {
                const name = ctx.tokenText(ctx.nodeMainToken(operand));
                if (std.mem.eql(u8, name, "arguments")) {
                    // Only useless when constructor has only simple params (no destructuring).
                    const params = ctx.extraSlice(.{ .start = method_data.params_start, .end = method_data.params_end });
                    for (params) |pp| {
                        const pn: NodeIndex = @enumFromInt(pp);
                        if (pn == .none) continue;
                        const pt = ctx.nodeTag(pn);
                        // assignment_pattern = default param (a = f()) — has side effects, not transparent
                        if (pt != .identifier and pt != .rest_element and pt != .ts_type_annotation)
                            return false; // destructuring or default param
                    }
                    return true;
                }
            }
        }
    }

    // super(a, b, ...c) — check if params perfectly forwarded
    return paramsPerfectlyForwardToSuper(method_data, args, ctx);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // method_def where key is "constructor"
    if (ctx.nodeTag(node) == .method_def) {
        const key_text = ctx.tokenText(ctx.nodeMainToken(node));
        if (!std.mem.eql(u8, key_text, "constructor")) return;
    }

    const data = ctx.nodeData(node);
    const method_data = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));

    // Skip if constructor has TS parameter properties.
    if (hasParameterProperties(method_data, ctx)) return;

    // Skip if any parameter has a decorator (TS parameter decorators).
    if (hasParameterDecorators(method_data, ctx)) return;

    const body = method_data.body;
    if (body == .none or ctx.nodeTag(body) != .block_stmt) return;

    const body_data = ctx.nodeData(body);
    const stmts = ctx.extraSlice(.{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    });

    // Skip if constructor has access modifier (private/public/protected).
    const accessibility = method_data.modifiers & ModifierBit.accessibility_mask;
    if (accessibility != 0) return;
    const main_tok = ctx.nodeMainToken(node);
    if (main_tok > 0) {
        const prev = ctx.tokenText(main_tok - 1);
        if (std.mem.eql(u8, prev, "private") or
            std.mem.eql(u8, prev, "protected") or
            std.mem.eql(u8, prev, "public")) return;
    }

    const has_super = classHasSuperclass(node, ctx);

    if (stmts.len == 0) {
        // Empty body: useless only in base class.
        if (!has_super) ctx.report(node);
        return;
    }

    if (stmts.len == 1) {
        const stmt: NodeIndex = @enumFromInt(stmts[0]);
        if (has_super and isSuperDelegate(stmt, method_data, ctx)) {
            ctx.report(node);
        }
    }
}
