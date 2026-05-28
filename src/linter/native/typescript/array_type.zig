// HAND-WRITTEN.
// Rule: @typescript-eslint/array-type
//
// Enforces consistent use of T[] vs Array<T> syntax.
// Options:
//   - `default`: "array" | "array-simple" | "generic" (default: "array")
//   - `readonly`: same enum, defaults to same value as `default`

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "array-type",
    .category = .style,
    .default_severity = .warning,
    .description = "Require consistently using either T[] or Array<T> for arrays",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_reference,
    .ts_array_type,
    .ts_keyof_type,
};

const Mode = enum { array, array_simple, generic };

fn parseMode(s: []const u8) Mode {
    if (std.mem.eql(u8, s, "array")) return .array;
    if (std.mem.eql(u8, s, "generic")) return .generic;
    return .array_simple;
}

fn defaultMode(ctx: *const LintContext) Mode {
    const s = ctx.getOptionString("default") orelse return .array;
    return parseMode(s);
}

fn readonlyMode(ctx: *const LintContext) Mode {
    const def = defaultMode(ctx);
    const s = ctx.getOptionString("readonly") orelse return def;
    return parseMode(s);
}

/// Mirrors TSe's `isSimpleType` function:
///   - TSArrayType (T[]) → simple
///   - TS keyword types and bare identifier type refs → simple
///   - TSQualifiedName (member_expr) → simple
///   - TSTypeReference named "Array" with one simple type arg → simple
///   - TSTypeReference without type args → simple
///   - Everything else → not simple
fn isSimpleType(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .ts_array_type => return true,
        .ts_parenthesized_type => return isSimpleType(ctx.nodeData(node).lhs, ctx),
        .identifier, .member_expr => return true,
        .ts_type_reference => {
            const d = ctx.nodeData(node);
            const name_text = ctx.tokenText(ctx.nodeMainToken(node));
            if (std.mem.eql(u8, name_text, "Array")) {
                if (d.rhs == .none) return true;
                const elem = firstTypeArg(node, ctx);
                if (elem == .none) return true;
                return isSimpleType(elem, ctx);
            }
            if (d.rhs != .none) return false; // has type args → not simple
            // Bare type ref (keyword or identifier): check name node
            if (d.lhs != .none) return isSimpleType(d.lhs, ctx);
            return true; // keyword type ref with no name node
        },
        else => return false,
    }
}

/// Get source text of a node.
fn nodeText(node: NodeIndex, ctx: *const LintContext) []const u8 {
    const sp = ctx.nodeSpan(node);
    return ctx.ast.source[sp.start..sp.end];
}

/// Get the first type arg of a `ts_type_reference` (rhs is extra SubRange index).
fn firstTypeArg(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return .none;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return .none;
    return @enumFromInt(ctx.ast.extra_data[sr.start]);
}

/// Report helper. `msg_id` is the messageId; `type_str` and `alt_str` are the
/// interpolation values. They just need to be valid through this call — they
/// are duplicated by the lint context allocator inside reportWithMessageIdAndData.
fn reportNode(
    node: NodeIndex,
    msg_id: []const u8,
    type_str: []const u8,
    alt_str: []const u8,
    ctx: *const LintContext,
) void {
    ctx.reportWithMessageIdAndData(node, msg_id, &[_]MessageDataEntry{
        .{ .key = "type", .val = type_str },
        .{ .key = "alternative", .val = alt_str },
    });
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .ts_type_reference => checkTypeRef(node, ctx),
        .ts_array_type => checkArrayType(node, ctx),
        .ts_keyof_type => checkReadonlyArray(node, ctx),
        else => {},
    }
}

/// Handle `Array<T>`, `ReadonlyArray<T>`, and `Readonly<T[]>` type references.
fn checkTypeRef(node: NodeIndex, ctx: *const LintContext) void {
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (std.mem.eql(u8, name, "Array")) {
        checkGenericArrayRef(node, name, false, ctx);
    } else if (std.mem.eql(u8, name, "ReadonlyArray")) {
        checkGenericArrayRef(node, name, true, ctx);
    } else if (std.mem.eql(u8, name, "Readonly")) {
        checkReadonlyUtil(node, ctx);
    }
}

/// Handle `Array<T>` (is_readonly=false) or `ReadonlyArray<T>` (is_readonly=true).
/// In array/array-simple mode these should be rewritten to `T[]` or `readonly T[]`.
fn checkGenericArrayRef(node: NodeIndex, _: []const u8, is_readonly: bool, ctx: *const LintContext) void {
    const mode = if (is_readonly) readonlyMode(ctx) else defaultMode(ctx);
    if (mode == .generic) return; // Generic syntax is preferred — don't flag.

    const elem_node = firstTypeArg(node, ctx);
    if (elem_node == .none) return; // Bare `Array` without type args — not our concern.

    const simple = isSimpleType(elem_node, ctx);
    if (mode == .array_simple and !simple) return; // array-simple only flags simple types here.

    // Build type/alternative strings.
    var type_buf: [512]u8 = undefined;
    var alt_buf: [512]u8 = undefined;

    const elem_text: []const u8 = if (simple) nodeText(elem_node, ctx) else "T";

    const type_str = if (simple)
        nodeText(node, ctx) // e.g. "Array<number>" or "ReadonlyArray<number>"
    else if (!is_readonly)
        std.fmt.bufPrint(&type_buf, "Array<T>", .{}) catch return
    else
        std.fmt.bufPrint(&type_buf, "ReadonlyArray<T>", .{}) catch return;

    const alt_str = if (!is_readonly)
        std.fmt.bufPrint(&alt_buf, "{s}[]", .{elem_text}) catch return
    else
        std.fmt.bufPrint(&alt_buf, "readonly {s}[]", .{elem_text}) catch return;

    const msg_id: []const u8 = if (mode == .array_simple)
        "errorStringArraySimple"
    else
        "errorStringArray";

    reportNode(node, msg_id, type_str, alt_str, ctx);
}

/// Handle `Readonly<T[]>` — transforms to `readonly T[]` when array/array-simple mode.
fn checkReadonlyUtil(node: NodeIndex, ctx: *const LintContext) void {
    const mode = readonlyMode(ctx);
    if (mode == .generic) return;

    const inner = firstTypeArg(node, ctx);
    if (inner == .none) return;
    if (ctx.nodeTag(inner) != .ts_array_type) return;

    // The element type is what's inside the inner array.
    const elem_node = ctx.nodeData(inner).lhs;
    const simple = isSimpleType(elem_node, ctx);
    if (mode == .array_simple and !simple) return;

    var alt_buf: [512]u8 = undefined;
    const elem_text: []const u8 = if (simple) nodeText(elem_node, ctx) else "T";
    const type_str = nodeText(node, ctx); // e.g. "Readonly<string[]>"
    const alt_str = std.fmt.bufPrint(&alt_buf, "readonly {s}[]", .{elem_text}) catch return;

    const msg_id: []const u8 = if (mode == .array_simple)
        "errorStringArraySimpleReadonly"
    else
        "errorStringArrayReadonly";

    reportNode(node, msg_id, type_str, alt_str, ctx);
}

/// Handle `T[]` (ts_array_type). In generic/array-simple (non-simple) mode it should
/// be rewritten to `Array<T>`.
fn checkArrayType(node: NodeIndex, ctx: *const LintContext) void {
    // If the parent is `ts_keyof_type` with `readonly`, the whole `readonly T[]` is
    // handled by checkReadonlyArray — don't double-fire on the inner array.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .ts_keyof_type) {
        if (ctx.tokenTag(ctx.nodeMainToken(parent)) == .kw_readonly) return;
    }

    const mode = defaultMode(ctx);
    if (mode == .array) return; // Array syntax preferred — don't flag T[].

    const elem_node = ctx.nodeData(node).lhs;
    if (elem_node == .none) return;
    const simple = isSimpleType(elem_node, ctx);
    if (mode == .array_simple and simple) return; // array-simple only flags non-simple types here.

    var type_buf: [512]u8 = undefined;
    var alt_buf: [512]u8 = undefined;

    const elem_text: []const u8 = if (simple) nodeText(elem_node, ctx) else "T";

    const type_str = if (simple)
        nodeText(node, ctx) // e.g. "number[]"
    else
        std.fmt.bufPrint(&type_buf, "T[]", .{}) catch return;

    const alt_str = std.fmt.bufPrint(&alt_buf, "Array<{s}>", .{elem_text}) catch return;

    const msg_id: []const u8 = if (mode == .array_simple)
        "errorStringGenericSimple"
    else
        "errorStringGeneric";

    reportNode(node, msg_id, type_str, alt_str, ctx);
}

/// Handle `readonly T[]` (ts_keyof_type with readonly operator).
/// In generic/array-simple (non-simple) mode rewrite to `ReadonlyArray<T>`.
fn checkReadonlyArray(node: NodeIndex, ctx: *const LintContext) void {
    // Only fire on `readonly` type operator, not `keyof`.
    if (ctx.tokenTag(ctx.nodeMainToken(node)) != .kw_readonly) return;

    const inner = ctx.nodeData(node).lhs;
    if (inner == .none) return;
    if (ctx.nodeTag(inner) != .ts_array_type) return;

    const mode = readonlyMode(ctx);
    if (mode == .array) return; // array mode prefers readonly T[] — don't flag.

    const elem_node = ctx.nodeData(inner).lhs;
    if (elem_node == .none) return;
    const simple = isSimpleType(elem_node, ctx);
    if (mode == .array_simple and simple) return; // array-simple only flags non-simple here.

    var type_buf: [512]u8 = undefined;
    var alt_buf: [512]u8 = undefined;

    const elem_text: []const u8 = if (simple) nodeText(elem_node, ctx) else "T";

    const type_str = if (simple)
        nodeText(node, ctx) // e.g. "readonly number[]"
    else
        std.fmt.bufPrint(&type_buf, "readonly T[]", .{}) catch return;

    const alt_str = std.fmt.bufPrint(&alt_buf, "ReadonlyArray<{s}>", .{elem_text}) catch return;

    const msg_id: []const u8 = if (mode == .array_simple)
        "errorStringGenericSimple"
    else
        "errorStringGeneric";

    reportNode(node, msg_id, type_str, alt_str, ctx);
}
