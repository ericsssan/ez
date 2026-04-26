const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{
    .assign,
    .logical_and_assign, .logical_or_assign, .nullish_assign,
    .call_expr, .optional_call_expr,
};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-extend-native",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow extending native object prototypes",
};

// Built-in constructors whose prototypes should not be extended.
const NATIVES = [_][]const u8{
    "AggregateError", "Array", "ArrayBuffer", "Atomics", "BigInt",
    "BigInt64Array", "BigUint64Array", "Boolean", "DataView", "Date",
    "Error", "EvalError", "Float32Array", "Float64Array", "Function",
    "Generator", "GeneratorFunction", "AsyncFunction", "AsyncGenerator",
    "Int8Array", "Int16Array", "Int32Array", "JSON", "Map", "Math",
    "Number", "Object", "Promise", "Proxy", "RangeError", "ReferenceError",
    "RegExp", "Reflect", "Set", "SharedArrayBuffer", "String", "Symbol",
    "SyntaxError", "TypeError", "URIError", "Uint8Array", "Uint8ClampedArray",
    "Uint16Array", "Uint32Array", "WeakMap", "WeakRef", "WeakSet",
    "FinalizationRegistry",
};

fn isNative(name: []const u8) bool {
    for (NATIVES) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn isGlobalIdent(name: []const u8, ctx: *const LintContext) bool {
    const symbols = ctx.symbols();
    const total = symbols.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (!std.mem.eql(u8, symbols.getName(id), name)) continue;
        if (symbols.getFlags(id).isDeclared()) return false;
    }
    return true;
}

fn isException(name: []const u8, ctx: *const LintContext) bool {
    if (ctx.getOptions()) |o| if (o.* == .object) {
        if (o.object.get("exceptions")) |exc| if (exc == .array) {
            for (exc.array.items) |item| {
                if (item == .string and std.mem.eql(u8, item.string, name)) return true;
            }
        };
    };
    return false;
}

fn getPropertyName(node: NodeIndex, tag: Node.Tag, ctx: *const LintContext) ?[]const u8 {
    if (tag == .member_expr or tag == .optional_member_expr) {
        const d = ctx.nodeData(node);
        return ctx.memberPropertyName(d.rhs);
    }
    if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
        const d = ctx.nodeData(node);
        if (d.rhs == .none) return null;
        const key_tag = ctx.nodeTag(d.rhs);
        if (key_tag == .string_literal) {
            const text = ctx.tokenText(ctx.nodeMainToken(d.rhs));
            return if (text.len >= 2) text[1 .. text.len - 1] else null;
        }
        return null;
    }
    return null;
}

/// Check if `proto_node` is `X.prototype` where X is a native.
fn isNativePrototypeArg(proto_node: NodeIndex, ctx: *const LintContext) bool {
    if (proto_node == .none) return false;
    var inner_raw = proto_node;
    while (inner_raw != .none and ctx.nodeTag(inner_raw) == .grouping_expr) {
        inner_raw = ctx.nodeData(inner_raw).lhs;
    }
    if (inner_raw == .none) return false;
    const inner_tag = ctx.nodeTag(inner_raw);
    const inner_is_member = inner_tag == .member_expr or inner_tag == .computed_member_expr or
        inner_tag == .optional_member_expr or inner_tag == .optional_computed_member_expr;
    if (!inner_is_member) return false;
    const proto_name = getPropertyName(inner_raw, inner_tag, ctx) orelse return false;
    if (!std.mem.eql(u8, proto_name, "prototype")) return false;
    var native_raw = ctx.nodeData(inner_raw).lhs;
    while (native_raw != .none and ctx.nodeTag(native_raw) == .grouping_expr) {
        native_raw = ctx.nodeData(native_raw).lhs;
    }
    if (native_raw == .none or ctx.nodeTag(native_raw) != .identifier) return false;
    const native_name = ctx.tokenText(ctx.nodeMainToken(native_raw));
    return isNative(native_name) and isGlobalIdent(native_name, ctx);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // Handle Object.defineProperty/defineProperties(X.prototype, ...)
    if (tag == .call_expr or tag == .optional_call_expr) {
        const callee_raw = data.lhs;
        if (callee_raw == .none) return;
        // Unwrap grouping
        var callee = callee_raw;
        while (callee != .none and ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        if (callee == .none) return;
        const callee_tag = ctx.nodeTag(callee);
        if (callee_tag != .member_expr and callee_tag != .optional_member_expr) return;
        const cd = ctx.nodeData(callee);
        if (cd.rhs == .none) return;
        const method = ctx.memberPropertyName(cd.rhs);
        if (!std.mem.eql(u8, method, "defineProperty") and !std.mem.eql(u8, method, "defineProperties")) return;
        // Check if callee object is Object (identifier)
        const obj = cd.lhs;
        if (obj == .none or ctx.nodeTag(obj) != .identifier) return;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(obj)), "Object")) return;
        // First argument should be X.prototype
        if (data.rhs == .none) return;
        const args_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
        const args = ctx.extraSlice(args_range);
        if (args.len < 1) return;
        const first_arg: NodeIndex = @enumFromInt(args[0]);
        if (!isNativePrototypeArg(first_arg, ctx)) return;
        // Also check exceptions via first arg
        var inner_r = first_arg;
        while (inner_r != .none and ctx.nodeTag(inner_r) == .grouping_expr) inner_r = ctx.nodeData(inner_r).lhs;
        if (inner_r != .none) {
            const inner_t = ctx.nodeTag(inner_r);
            if (inner_t == .member_expr or inner_t == .optional_member_expr) {
                var nat_r = ctx.nodeData(inner_r).lhs;
                while (nat_r != .none and ctx.nodeTag(nat_r) == .grouping_expr) nat_r = ctx.nodeData(nat_r).lhs;
                if (nat_r != .none and ctx.nodeTag(nat_r) == .identifier) {
                    const nat_n = ctx.tokenText(ctx.nodeMainToken(nat_r));
                    if (isException(nat_n, ctx)) return;
                }
            }
        }
        ctx.report(node);
        return;
    }

    const lhs = data.lhs;
    if (lhs == .none) return;

    // lhs should be `X.prototype.y` or `X['prototype'].y` or `X.prototype['y']`
    const lhs_tag = ctx.nodeTag(lhs);
    const lhs_is_member = lhs_tag == .member_expr or lhs_tag == .computed_member_expr;
    if (!lhs_is_member) return;

    // The object of lhs should be `X.prototype` or `X['prototype']` (unwrap grouping)
    var inner_raw = ctx.nodeData(lhs).lhs;
    while (inner_raw != .none and ctx.nodeTag(inner_raw) == .grouping_expr) {
        inner_raw = ctx.nodeData(inner_raw).lhs;
    }
    if (inner_raw == .none) return;
    const inner = inner_raw;
    const inner_tag = ctx.nodeTag(inner);
    const inner_is_member = inner_tag == .member_expr or inner_tag == .computed_member_expr or
        inner_tag == .optional_member_expr or inner_tag == .optional_computed_member_expr;
    if (!inner_is_member) return;

    const proto_name = getPropertyName(inner, inner_tag, ctx) orelse return;
    if (!std.mem.eql(u8, proto_name, "prototype")) return;

    // The object of inner should be a native identifier (unwrap grouping).
    var native_raw = ctx.nodeData(inner).lhs;
    while (native_raw != .none and ctx.nodeTag(native_raw) == .grouping_expr) {
        native_raw = ctx.nodeData(native_raw).lhs;
    }
    if (native_raw == .none or ctx.nodeTag(native_raw) != .identifier) return;
    const native_node = native_raw;
    const native_name = ctx.tokenText(ctx.nodeMainToken(native_node));

    if (!isNative(native_name)) return;
    if (!isGlobalIdent(native_name, ctx)) return;
    if (isException(native_name, ctx)) return;

    ctx.report(node);
}
