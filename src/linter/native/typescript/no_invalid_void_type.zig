// HAND-WRITTEN.
// Rule: @typescript-eslint/no-invalid-void-type
//
// Disallow `void` type outside of generic or return types.
//
// Options:
//   allowInGenericTypeArguments: true (default) | false | string[]
//   allowAsThisParameter: false (default) | true

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-invalid-void-type",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `void` type outside of generic or return types",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_reference,
};

const GenericAllow = enum { all, none, list };

// Grandparent contexts that make a type annotation invalid (not return positions)
const invalid_annotation_grandparents = [_]Node.Tag{
    .ts_property_signature,
    .call_expr,
    .property_def,
    .computed_property_def,
    .identifier,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // void keyword type: lhs == .none, main_token tag == .kw_void
    if (data.lhs != .none) return;
    if (ctx.tokenTag(ctx.nodeMainToken(node)) != .kw_void) return;

    const generic_allow = getGenericAllow(ctx);
    const allow_this_param = ctx.getOptionBool("allowAsThisParameter", false);

    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    const parent_tag = ctx.nodeTag(parent);

    // 1. Generic type argument: parent is an outer ts_type_reference
    if (parent_tag == .ts_type_reference) {
        switch (generic_allow) {
            .all => return, // always valid
            .none => {
                reportGeneral(node, generic_allow, allow_this_param, ctx);
                return;
            },
            .list => {
                // Check if the outer type name is in the allowlist
                const outer_data = ctx.nodeData(parent);
                const name_node = outer_data.lhs;
                if (name_node != .none) {
                    const name = getTypeName(parent, ctx);
                    if (name != null and isNameAllowed(name.?, ctx)) return;
                }
                ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "invalidVoidForGeneric");
                return;
            },
        }
    }

    // 2. Type parameter constraint or default
    if (parent_tag == .ts_type_parameter) {
        const pd = ctx.nodeData(parent);
        if (pd.rhs == node) {
            // Is default type position
            switch (generic_allow) {
                .all, .list => return, // valid when generics allowed
                .none => {
                    reportGeneral(node, generic_allow, allow_this_param, ctx);
                    return;
                },
            }
        }
        // Constraint position (lhs == node) — always invalid
        reportGeneral(node, generic_allow, allow_this_param, ctx);
        return;
    }

    // 3. Union type member
    if (parent_tag == .ts_union_type) {
        if (isValidUnionType(parent, ctx)) return;
        if (isInOverloadImplReturn(parent, ctx)) return;
        // Report with union-specific message
        const msg: []const u8 = switch (generic_allow) {
            .all, .list => if (allow_this_param) "invalidVoidNotReturnOrThisParamOrGeneric" else "invalidVoidUnionConstituent",
            .none => if (allow_this_param) "invalidVoidNotReturnOrThisParam" else "invalidVoidNotReturn",
        };
        ctx.reportSpanWithMessageId(ctx.nodeSpan(node), msg);
        return;
    }

    // 4. allowAsThisParameter: `this: void` parameter
    if (allow_this_param and parent_tag == .ts_type_annotation) {
        const gp = ctx.parentOf(parent);
        if (gp != .none and ctx.nodeTag(gp) == .identifier) {
            if (ctx.tokenTag(ctx.nodeMainToken(gp)) == .kw_this) return;
        }
    }

    // 5. Type annotation — valid only when grandparent is NOT in invalidGrandParents
    if (parent_tag == .ts_type_annotation) {
        const gp = ctx.parentOf(parent);
        if (gp != .none) {
            const gp_tag = ctx.nodeTag(gp);
            for (invalid_annotation_grandparents) |bad| {
                if (gp_tag == bad) {
                    reportGeneral(node, generic_allow, allow_this_param, ctx);
                    return;
                }
            }
        }
        // Valid annotation grandparent (fn_decl, method_def, etc.) — return type position
        return;
    }

    // 6. Function/constructor type return type (void is directly under ts_function_type or ts_constructor_type)
    if (parent_tag == .ts_function_type or parent_tag == .ts_constructor_type) {
        return;
    }

    // 7. ts_instantiation_expr: new Foo<void>() vs foo<void>()
    // new_expr inner → NewExpression (valid); other inner → CallExpression (invalid)
    if (parent_tag == .ts_instantiation_expr) {
        const ie_data = ctx.nodeData(parent);
        if (ie_data.lhs != .none and ctx.nodeTag(ie_data.lhs) == .new_expr) {
            switch (generic_allow) {
                .all => return,
                .none => reportGeneral(node, generic_allow, allow_this_param, ctx),
                .list => {
                    const new_callee = ctx.nodeData(ie_data.lhs).lhs;
                    if (new_callee != .none) {
                        const name = ctx.tokenText(ctx.nodeMainToken(new_callee));
                        if (isNameAllowed(name, ctx)) return;
                    }
                    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "invalidVoidForGeneric");
                },
            }
        } else {
            reportGeneral(node, generic_allow, allow_this_param, ctx);
        }
        return;
    }

    // 8. Everything else is invalid
    reportGeneral(node, generic_allow, allow_this_param, ctx);
}

fn getGenericAllow(ctx: *const LintContext) GenericAllow {
    const opts = ctx.rule_options orelse return .all;
    if (opts.* != .object) return .all;
    const val = opts.object.get("allowInGenericTypeArguments") orelse return .all;
    return switch (val) {
        .bool => |b| if (b) .all else .none,
        .array => .list,
        else => .all,
    };
}

fn isNameAllowed(type_name: []const u8, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const val = opts.object.get("allowInGenericTypeArguments") orelse return false;
    if (val != .array) return false;
    for (val.array.items) |item| {
        if (item == .string and normalizedNamesEq(item.string, type_name)) return true;
    }
    return false;
}

fn normalizedNamesEq(a: []const u8, b: []const u8) bool {
    var ai: usize = 0;
    var bi: usize = 0;
    while (true) {
        while (ai < a.len and a[ai] == ' ') ai += 1;
        while (bi < b.len and b[bi] == ' ') bi += 1;
        if (ai >= a.len and bi >= b.len) return true;
        if (ai >= a.len or bi >= b.len) return false;
        if (a[ai] != b[bi]) return false;
        ai += 1;
        bi += 1;
    }
}

fn isVoidType(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .ts_type_reference) return false;
    const d = ctx.nodeData(node);
    return d.lhs == .none and ctx.tokenTag(ctx.nodeMainToken(node)) == .kw_void;
}

fn isNeverType(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .ts_type_reference) return false;
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs != .none) return false;
    if (ctx.nodeTag(d.lhs) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), "never");
}

fn isGenericWithVoidArg(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .ts_type_reference) return false;
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return false;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    if (sr.start >= sr.end or sr.end > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
        if (isVoidType(@enumFromInt(raw), ctx)) return true;
    }
    return false;
}

/// A union type is valid if every member is void, never, or a generic that has void as a type arg.
fn isValidUnionType(union_node: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.nodeData(union_node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (isVoidType(m, ctx)) continue;
        if (isNeverType(m, ctx)) continue;
        if (isGenericWithVoidArg(m, ctx)) continue;
        return false;
    }
    return true;
}

/// Walk up from union_node to find if it's in an implementation function's return type,
/// where the same function has overload signatures.
fn isInOverloadImplReturn(union_node: NodeIndex, ctx: *const LintContext) bool {
    var current = ctx.parentOf(union_node);
    while (current != .none) {
        const tag = ctx.nodeTag(current);
        switch (tag) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
                return checkFunctionHasOverloads(current, ctx);
            },
            .method_def, .computed_method_def => {
                const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(current).rhs));
                if (md.body == .none) return false; // overload signature itself, not impl
                return checkMethodHasOverloads(current, ctx);
            },
            // Hard stop boundaries
            .root, .class_body, .ts_type_literal,
            .ts_function_type, .ts_constructor_type,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .ts_declare_function => return false,
            else => {},
        }
        current = ctx.parentOf(current);
    }
    return false;
}

fn checkFunctionHasOverloads(fn_node: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(fn_node);
    if (parent == .none) return false;
    const parent_tag = ctx.nodeTag(parent);

    // Anonymous export default function — match any export default declare function
    if (parent_tag == .export_default_fn) {
        const gp = ctx.parentOf(parent);
        if (gp == .none) return false;
        return bodyHasExportDefaultDeclareFunction(gp, ctx);
    }

    const data = ctx.nodeData(fn_node);
    const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    if (fd.name == .none) return false;
    const fn_name = ctx.tokenText(ctx.nodeMainToken(fd.name));

    if (parent_tag == .root or parent_tag == .block_stmt) {
        return bodyHasDeclareFunction(parent, fn_name, ctx);
    }
    if (parent_tag == .export_named) {
        const gp = ctx.parentOf(parent);
        if (gp == .none) return false;
        return bodyHasExportedDeclareFunction(gp, fn_name, ctx);
    }
    return false;
}

fn bodyHasDeclareFunction(body: NodeIndex, fn_name: []const u8, ctx: *const LintContext) bool {
    const d = ctx.nodeData(body);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(member) != .ts_declare_function) continue;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(member).lhs));
        if (fd.name == .none) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(fd.name)), fn_name)) return true;
    }
    return false;
}

fn bodyHasExportedDeclareFunction(body: NodeIndex, fn_name: []const u8, ctx: *const LintContext) bool {
    const d = ctx.nodeData(body);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(member) != .export_named) continue;
        const edata = ctx.nodeData(member);
        if (edata.rhs != .none) continue; // specifiers form, not declaration
        const inner = edata.lhs;
        if (inner == .none or ctx.nodeTag(inner) != .ts_declare_function) continue;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(inner).lhs));
        if (fd.name == .none) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(fd.name)), fn_name)) return true;
    }
    return false;
}

fn bodyHasExportDefaultDeclareFunction(body: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.nodeData(body);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(member) != .export_default_fn) continue;
        const inner = ctx.nodeData(member).lhs;
        if (inner != .none and ctx.nodeTag(inner) == .ts_declare_function) return true;
    }
    return false;
}

fn checkMethodHasOverloads(method_node: NodeIndex, ctx: *const LintContext) bool {
    const key = ctx.nodeData(method_node).lhs;
    if (key == .none) return false;
    const key_name = getKeyName(key, ctx) orelse return false;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(method_node).rhs));
    const is_static = (md.modifiers & ast.ModifierBit.@"static") != 0;

    const class_body = ctx.parentOf(method_node);
    if (class_body == .none or ctx.nodeTag(class_body) != .class_body) return false;
    const bd = ctx.nodeData(class_body);
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const mtag = ctx.nodeTag(member);
        if (mtag != .method_def and mtag != .computed_method_def) continue;
        const mmd = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(member).rhs));
        if (mmd.body != .none) continue; // only overload signatures (no body)
        const member_is_static = (mmd.modifiers & ast.ModifierBit.@"static") != 0;
        if (member_is_static != is_static) continue;
        const mk = getKeyName(ctx.nodeData(member).lhs, ctx) orelse continue;
        if (std.mem.eql(u8, mk, key_name)) return true;
    }
    return false;
}

fn getKeyName(key: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (key == .none) return null;
    const text = ctx.tokenText(ctx.nodeMainToken(key));
    switch (ctx.nodeTag(key)) {
        .identifier, .property_ident => {
            if (text.len > 0 and text[0] == '#') return text[1..];
            return text;
        },
        .string_literal => {
            if (text.len >= 2) return text[1 .. text.len - 1];
            return text;
        },
        .number_literal => return text,
        .member_expr => {
            const sp = ctx.nodeSpan(key);
            return ctx.ast.source[sp.start..sp.end];
        },
        else => return null,
    }
}

/// Get the full text of the type name for a ts_type_reference node (for allowlist matching).
fn getTypeName(type_ref: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const d = ctx.nodeData(type_ref);
    if (d.lhs == .none) return null;
    const name_node = d.lhs;
    const sp = ctx.nodeSpan(name_node);
    return ctx.ast.source[sp.start..sp.end];
}

fn reportGeneral(node: NodeIndex, generic_allow: GenericAllow, allow_this_param: bool, ctx: *const LintContext) void {
    const msg: []const u8 = switch (generic_allow) {
        .all, .list => if (allow_this_param) "invalidVoidNotReturnOrThisParamOrGeneric" else "invalidVoidNotReturnOrGeneric",
        .none => if (allow_this_param) "invalidVoidNotReturnOrThisParam" else "invalidVoidNotReturn",
    };
    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), msg);
}
