// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-type-parameters
//
// Fires `sole` on a type parameter `T` when its weighted usage count in
// the owning container's *signature region* is exactly one.  Class /
// interface property types contribute weight=2 (read + write); every
// other position contributes weight=1.  Method/function bodies are NOT
// part of the signature region and are skipped.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-parameters",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow type parameters that aren't used more than once",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_parameter,
};

pub const needs_semantic = false;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Skip type params declared inside infer-types / mapped-types — those
    // aren't function/class type params and have different semantics.
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    const ptag = ctx.nodeTag(parent);
    if (ptag == .ts_infer_type or ptag == .ts_mapped_type) return;

    const name = ctx.tokenText(ctx.nodeMainToken(node));
    // Owning container — walk up until we find one we know how to handle.
    const container = findOwner(node, ctx) orelse return;
    var count: u32 = 0;
    countInContainer(container, name, &count, ctx);
    if (count == 1) {
        ctx.reportWithMessageId(node, "sole");
    }
}

/// Walk up parents until we hit a recognised type-param-bearing
/// container.  Returns the container node, or null if the type param
/// is in an unrecognised position.
fn findOwner(tp: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var cur: NodeIndex = ctx.parentOf(tp);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        switch (ctx.nodeTag(cur)) {
            .fn_decl,
            .async_fn_decl,
            .generator_fn_decl,
            .async_generator_fn_decl,
            .fn_expr,
            .async_fn_expr,
            .generator_fn_expr,
            .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .method_def,
            .computed_method_def,
            .constructor_def,
            .ts_declare_function,
            .ts_method_signature,
            .ts_call_signature,
            .ts_construct_signature,
            .class_decl,
            .class_expr,
            .ts_interface_decl,
            .ts_type_alias_decl,
            .ts_function_type,
            .ts_constructor_type,
            => return cur,
            else => {},
        }
    }
    return null;
}

/// Dispatch on container kind and walk its signature region.
fn countInContainer(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(container);
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function => countFnLike(container, name, count, ctx),
        .arrow_fn, .async_arrow_fn => countArrow(container, name, count, ctx),
        .method_def, .computed_method_def => countMethod(container, name, count, ctx),
        .constructor_def => countMethod(container, name, count, ctx),
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => countInterfaceSig(container, name, count, ctx),
        .ts_function_type, .ts_constructor_type => countFnType(container, name, count, ctx),
        .class_decl, .class_expr => countClass(container, name, count, ctx),
        .ts_interface_decl => countInterface(container, name, count, ctx),
        .ts_type_alias_decl => countTypeAlias(container, name, count, ctx),
        else => {},
    }
}

fn countFnLike(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
    countParams(fd.params, fd.params_end, name, count, ctx);
    countTypeNode(fd.return_type, name, count, ctx, false);
}

fn countArrow(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
    countParams(ad.params_start, ad.params_end, name, count, ctx);
    countTypeNode(ad.return_type, name, count, ctx, false);
    // Arrow type params live in extra slots; not modelled here but the
    // ts_type_parameter visitor catches each one via its parent — we
    // don't need to enumerate them.
}

fn countMethod(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
    countParams(md.params_start, md.params_end, name, count, ctx);
    countTypeNode(md.return_type, name, count, ctx, false);
}

fn countInterfaceSig(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
    countTypeParamConstraints(sd.type_params, sd.type_params_end, name, count, ctx);
    countParams(sd.params_start, sd.params_end, name, count, ctx);
    countTypeNode(sd.return_type, name, count, ctx, false);
}

fn countFnType(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    // ts_function_type / ts_constructor_type — lhs = extra index to FnData.
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
    countParams(fd.params, fd.params_end, name, count, ctx);
    countTypeNode(fd.return_type, name, count, ctx, false);
}

fn countClass(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    countTypeParamConstraints(cd.type_params, cd.type_params_end, name, count, ctx);
    if (cd.body == .none) return;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        countClassMember(m, name, count, ctx);
    }
}

fn countClassMember(m: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(m);
    switch (tag) {
        .property_def, .computed_property_def => {
            const pd = ctx.nodeData(m);
            if (pd.rhs == .none) return;
            const data = ctx.extraData(ast.PropertyData, @intFromEnum(pd.rhs));
            // Property type annotation contributes weight 2 (read + write).
            countTypeNode(data.type_annotation, name, count, ctx, true);
        },
        .method_def, .computed_method_def => {
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            // If the method has its own type param shadowing `name`, skip.
            if (containerShadowsName(m, name, ctx)) return;
            countParams(meth.params_start, meth.params_end, name, count, ctx);
            countTypeNode(meth.return_type, name, count, ctx, false);
        },
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def => {
            // Treat as fn-like via FnData.
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            countParams(meth.params_start, meth.params_end, name, count, ctx);
            countTypeNode(meth.return_type, name, count, ctx, false);
        },
        .constructor_def => {
            const md = ctx.nodeData(m);
            if (md.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md.rhs));
            countParams(meth.params_start, meth.params_end, name, count, ctx);
        },
        else => {},
    }
}

fn countInterface(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(d.lhs));
    countTypeParamConstraints(id.type_params, id.type_params_end, name, count, ctx);
    // Members iteration
    const s = id.body_start;
    const e = id.body_end;
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        countInterfaceMember(m, name, count, ctx);
    }
}

fn countInterfaceMember(m: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(m);
    switch (tag) {
        .ts_property_signature => {
            // lhs = name node, rhs = type annotation.
            const d = ctx.nodeData(m);
            countTypeNode(d.rhs, name, count, ctx, true);
        },
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => {
            const d = ctx.nodeData(m);
            if (d.lhs == .none) return;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
            if (containerShadowsName(m, name, ctx)) return;
            countParams(sd.params_start, sd.params_end, name, count, ctx);
            countTypeNode(sd.return_type, name, count, ctx, false);
        },
        .ts_index_signature => {
            const d = ctx.nodeData(m);
            // lhs = param identifier (with type annotation in rhs), rhs = value type.
            const param = d.lhs;
            const ann = if (param != .none and ctx.nodeTag(param) == .identifier)
                ctx.nodeData(param).rhs
            else
                .none;
            countTypeNode(ann, name, count, ctx, false);
            countTypeNode(d.rhs, name, count, ctx, false);
        },
        else => {},
    }
}

fn countTypeAlias(container: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    const d = ctx.nodeData(container);
    if (d.lhs == .none) return;
    const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
    countTypeParamConstraints(ad.type_params, ad.type_params_end, name, count, ctx);
    countTypeNode(ad.type_node, name, count, ctx, false);
}

fn countTypeParamConstraints(start: u32, end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const tp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        const td = ctx.nodeData(tp);
        // Self-reference on the type param's own name isn't counted —
        // we want references in OTHER type params' constraints/defaults.
        const tp_name = ctx.tokenText(ctx.nodeMainToken(tp));
        if (std.mem.eql(u8, tp_name, name)) continue;
        countTypeNode(td.lhs, name, count, ctx, false);
        countTypeNode(td.rhs, name, count, ctx, false);
    }
}

fn countParams(start: u32, end: u32, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (end <= start or end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const param: NodeIndex = @enumFromInt(raw);
        countParam(param, name, count, ctx);
    }
}

fn countParam(param: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (param == .none) return;
    var n = param;
    if (ctx.nodeTag(n) == .assignment_pattern) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .rest_element) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .identifier) {
        const ann = ctx.nodeData(n).rhs;
        countTypeNode(ann, name, count, ctx, false);
    } else if (ctx.nodeTag(n) == .object_pattern or ctx.nodeTag(n) == .array_pattern) {
        // Pattern bindings — their annotation is attached to the pattern
        // via data.rhs on identifier sub-nodes, or unattached for now.
        // Approximate: walk the pattern subtree.
        walkAnnotations(n, name, count, ctx);
    }
}

fn walkAnnotations(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext) void {
    if (node == .none) return;
    walkAnnotationsDepth(node, name, count, ctx, 0);
}

fn walkAnnotationsDepth(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, depth: u32) void {
    if (depth > 16) return;
    const tag = ctx.nodeTag(node);
    if (tag == .ts_type_annotation) {
        countTypeNode(node, name, count, ctx, false);
        return;
    }
    if (tag == .identifier) {
        countTypeNode(ctx.nodeData(node).rhs, name, count, ctx, false);
        return;
    }
    // Strictly walk known pattern containers only.
    if (tag != .object_pattern and tag != .array_pattern and
        tag != .assignment_pattern and tag != .rest_element)
        return;
    const d = ctx.nodeData(node);
    // For object/array patterns, lhs is an extra SubRange index — descend
    // through elements safely.
    if (tag == .object_pattern or tag == .array_pattern) {
        const start = @intFromEnum(d.lhs);
        const end = @intFromEnum(d.rhs);
        if (end > start and end <= ctx.ast.extra_data.len) {
            for (ctx.ast.extra_data[start..end]) |raw| {
                const child: NodeIndex = @enumFromInt(raw);
                walkAnnotationsDepth(child, name, count, ctx, depth + 1);
            }
        }
        return;
    }
    if (d.lhs != .none) walkAnnotationsDepth(d.lhs, name, count, ctx, depth + 1);
    if (d.rhs != .none) walkAnnotationsDepth(d.rhs, name, count, ctx, depth + 1);
}

/// Walk a type-position AST subtree, counting `ts_type_reference` nodes
/// whose name matches `name`.  Stops descending into inner containers
/// that shadow `name` via their own type params.
fn countTypeNode(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, in_property: bool) void {
    if (node == .none) return;
    countTypeNodeDepth(node, name, count, ctx, in_property, 0);
}

fn countTypeNodeDepth(node: NodeIndex, name: []const u8, count: *u32, ctx: *const LintContext, in_property: bool, depth: u32) void {
    if (depth > 64) return;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    switch (tag) {
        .ts_type_annotation => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, depth + 1),
        .ts_function_type, .ts_constructor_type => {
            if (containerShadowsName(node, name, ctx)) return;
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            countParams(fd.params, fd.params_end, name, count, ctx);
            countTypeNode(fd.return_type, name, count, ctx, in_property);
            countTypeParamConstraints(fd.type_params, fd.type_params_end, name, count, ctx);
        },
        .ts_type_reference => {
            const inner = d.lhs;
            if (inner != .none and ctx.nodeTag(inner) == .identifier) {
                const ref_name = ctx.tokenText(ctx.nodeMainToken(inner));
                if (std.mem.eql(u8, ref_name, name)) {
                    count.* += if (in_property) @as(u32, 2) else @as(u32, 1);
                }
            }
            const args_extra = d.rhs;
            if (args_extra != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(args_extra));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        const t: NodeIndex = @enumFromInt(raw);
                        countTypeNodeDepth(t, name, count, ctx, in_property, depth + 1);
                    }
                }
            }
        },
        .ts_union_type, .ts_intersection_type, .ts_tuple_type => {
            if (d.lhs == .none) return;
            const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.lhs));
            if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                    const t: NodeIndex = @enumFromInt(raw);
                    countTypeNodeDepth(t, name, count, ctx, in_property, depth + 1);
                }
            }
        },
        .ts_array_type => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, depth + 1),
        .ts_parenthesized_type => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, depth + 1),
        .ts_keyof_type, .ts_typeof_type => countTypeNodeDepth(d.lhs, name, count, ctx, in_property, depth + 1),
        .ts_indexed_access_type => {
            countTypeNodeDepth(d.lhs, name, count, ctx, in_property, depth + 1);
            countTypeNodeDepth(d.rhs, name, count, ctx, in_property, depth + 1);
        },
        .ts_type_predicate => {
            // `x is T` — only the type side carries type-param refs.
            countTypeNodeDepth(d.rhs, name, count, ctx, in_property, depth + 1);
        },
        .ts_conditional_type => {
            // lhs = extra index to ConditionalTypeData.  Walk all four parts.
            // We don't know the exact layout; walk via extra data SubRange when valid.
            // Fall back: skip.
        },
        .ts_type_literal => {
            // { members } — members are type-position element nodes.
            if (d.lhs == .none) return;
            const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.lhs));
            if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    countInterfaceMember(m, name, count, ctx);
                }
            }
        },
        .ts_mapped_type => {
            // mapped types declare an inner type param via ts_type_parameter
            // — the inner visitor takes care of self-references; we just
            // walk the contained type.  Layout extra SubRange; skip for now.
        },
        else => {},
    }
}

/// True when `container` declares a type parameter named `name` itself.
fn containerShadowsName(container: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // Find the type-param SubRange of the container; if `name` appears,
    // recursion into this container would shadow.
    const tag = ctx.nodeTag(container);
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .ts_function_type, .ts_constructor_type => {
            const d = ctx.nodeData(container);
            if (d.lhs == .none) return false;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            return rangeHasName(fd.type_params, fd.type_params_end, name, ctx);
        },
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => {
            const d = ctx.nodeData(container);
            if (d.lhs == .none) return false;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
            return rangeHasName(sd.type_params, sd.type_params_end, name, ctx);
        },
        else => return false,
    }
}

fn rangeHasName(start: u32, end: u32, name: []const u8, ctx: *const LintContext) bool {
    if (end <= start or end > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[start..end]) |raw| {
        const tp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        const tp_name = ctx.tokenText(ctx.nodeMainToken(tp));
        if (std.mem.eql(u8, tp_name, name)) return true;
    }
    return false;
}
