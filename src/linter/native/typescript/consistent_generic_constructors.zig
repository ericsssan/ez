// HAND-WRITTEN.
// Rule: @typescript-eslint/consistent-generic-constructors
//
// Enforce specifying generic type arguments on the type annotation or
// constructor name of a constructor call.
//
// Two modes:
//   constructor (default): prefer `new Foo<T>()` over `const a: Foo<T> = new Foo()`
//   type-annotation:       prefer `const a: Foo<T> = new Foo()` over `new Foo<T>()`

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-generic-constructors",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce specifying generic type arguments on type annotation or constructor name of a constructor call",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .declarator,
    .property_def,
    .computed_property_def,
    .assignment_pattern,
};

const builtin_typed_arrays = [_][]const u8{
    "Float32Array", "Float64Array", "Int16Array",  "Int32Array",
    "Int8Array",    "Uint16Array",  "Uint32Array", "Uint8Array",
    "Uint8ClampedArray",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const ta_mode = ctx.optionEqualsString("type-annotation");
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx, ta_mode),
        .property_def, .computed_property_def => checkProperty(node, ctx, ta_mode),
        .assignment_pattern => checkAssignment(node, ctx, ta_mode),
        else => {},
    }
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext, ta_mode: bool) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;
    if (ctx.nodeTag(binding) != .identifier) return;

    const ann = ctx.nodeData(binding).rhs;
    const ann_node: NodeIndex = if (ann != .none and ctx.nodeTag(ann) == .ts_type_annotation) ann else .none;

    applyCheck(node, ann_node, init, ctx, ta_mode);
}

fn checkProperty(node: NodeIndex, ctx: *const LintContext, ta_mode: bool) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
    const init = pd.value;
    if (init == .none) return;

    const ann_node = pd.type_annotation; // already a ts_type_annotation or .none

    applyCheck(node, ann_node, init, ctx, ta_mode);
}

fn checkAssignment(node: NodeIndex, ctx: *const LintContext, ta_mode: bool) void {
    // Only fire when the assignment_pattern is a direct function/method parameter,
    // not when nested inside a destructuring pattern.
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    if (!isFunctionLike(ctx.nodeTag(parent))) return;

    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;

    const ann_node = getPatternAnnotation(binding, node, ctx);
    applyCheck(node, ann_node, init, ctx, ta_mode);
}

fn applyCheck(
    report_node: NodeIndex,
    ann_node: NodeIndex, // ts_type_annotation or .none
    init: NodeIndex,
    ctx: *const LintContext,
    ta_mode: bool,
) void {
    const new_info = getNewExprInfo(init, ctx) orelse return;

    if (!ta_mode) {
        // constructor mode: lhs has Foo<T>, rhs is plain new Foo()
        if (new_info.has_type_args) return; // rhs already has type args
        const type_info = getTypeRefInfo(ann_node, ctx) orelse return;
        if (!type_info.has_type_args) return; // lhs doesn't have type args
        if (!std.mem.eql(u8, type_info.name, new_info.callee_name)) return;
        if (isBuiltInGlobalArray(type_info.name, ctx)) return;
        ctx.reportSpanWithMessageId(extendedSpan(report_node, ctx), "preferConstructor");
    } else {
        // type-annotation mode: lhs has no annotation, rhs is new Foo<T>()
        if (!new_info.has_type_args) return; // rhs has no type args
        if (ann_node != .none) return; // lhs has a type annotation
        ctx.reportSpanWithMessageId(extendedSpan(report_node, ctx), "preferTypeAnnotation");
    }
}

/// Compute the correct diagnostic span for a reported node.
/// - For property_def/computed_property_def: walks backward for modifiers
///   (accessor, static, etc.) and forward to the terminating `;`.
/// - For declarator: walks forward from sp.start to the closing `)` of the init.
/// - For assignment_pattern: walks forward from the INIT's start to its closing
///   `)` (binding may be destructured `{a}` or `[a]`, so start scanning after it).
fn extendedSpan(node: NodeIndex, ctx: *const LintContext) @TypeOf(ctx.nodeSpan(node)) {
    const tag = ctx.nodeTag(node);
    const sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;

    const is_property = (tag == .property_def or tag == .computed_property_def);

    // For property definitions: walk backward to include modifier keywords.
    const property_modifiers = [_][]const u8{
        "accessor", "static", "abstract", "override", "declare",
        "public", "protected", "private", "readonly",
    };
    var start: usize = sp.start;
    if (is_property) {
        outer: while (true) {
            var bp: usize = start;
            while (bp > 0 and (src[bp - 1] == ' ' or src[bp - 1] == '\t')) bp -= 1;
            for (property_modifiers) |kw| {
                const klen = kw.len;
                if (bp >= klen and std.mem.eql(u8, src[bp - klen .. bp], kw)) {
                    if (bp == klen or !isIdentChar(src[bp - klen - 1])) {
                        start = bp - klen;
                        continue :outer;
                    }
                }
            }
            break;
        }
    }

    // For assignment_pattern, scan forward from the init expression's start
    // to skip past the binding (which may be a destructuring `{a}` or `[a]`).
    const scan_start: usize = if (tag == .assignment_pattern) blk: {
        const init = ctx.nodeData(node).rhs;
        if (init != .none) break :blk ctx.nodeSpan(init).start;
        break :blk sp.start;
    } else sp.start;

    // Walk forward to find the proper end of the init expression.
    var depth: i32 = 0;
    var pos: usize = scan_start;
    while (pos < src.len) : (pos += 1) {
        switch (src[pos]) {
            '(', '[', '{' => depth += 1,
            ')', ']', '}' => {
                if (depth > 0) {
                    depth -= 1;
                    if (depth == 0 and !is_property) {
                        return .{ .start = @intCast(start), .end = @intCast(pos + 1) };
                    }
                }
            },
            ';' => {
                if (depth == 0) return .{ .start = @intCast(start), .end = @intCast(pos + 1) };
            },
            '\n', '\r' => {
                if (depth == 0) break;
            },
            else => {},
        }
    }
    return .{ .start = @intCast(start), .end = sp.end };
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_' or c == '$';
}

/// Resolve a ts_type_annotation (or .none) into (typeName, hasTypeArgs).
fn getTypeRefInfo(ann_node: NodeIndex, ctx: *const LintContext) ?struct { name: []const u8, has_type_args: bool } {
    if (ann_node == .none) return null;
    var ty = ann_node;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    if (ty == .none) return null;
    if (ctx.nodeTag(ty) != .ts_type_reference) return null;
    const ref_data = ctx.nodeData(ty);
    const name_node = ref_data.lhs;
    if (name_node == .none) return null;
    if (ctx.nodeTag(name_node) != .identifier) return null;
    return .{
        .name = ctx.tokenText(ctx.nodeMainToken(name_node)),
        .has_type_args = ref_data.rhs != .none,
    };
}

/// Detect both `new Foo()` and `new Foo<T>()` (which parses as
/// call_expr(ts_instantiation_expr(new_expr, typeArgs), args)).
fn getNewExprInfo(init: NodeIndex, ctx: *const LintContext) ?struct { callee_name: []const u8, has_type_args: bool } {
    if (init == .none) return null;
    const tag = ctx.nodeTag(init);

    if (tag == .new_expr) {
        const callee = ctx.nodeData(init).lhs;
        if (callee == .none or ctx.nodeTag(callee) != .identifier) return null;
        return .{ .callee_name = ctx.tokenText(ctx.nodeMainToken(callee)), .has_type_args = false };
    }

    if (tag == .call_expr) {
        const lhs = ctx.nodeData(init).lhs;
        if (lhs == .none or ctx.nodeTag(lhs) != .ts_instantiation_expr) return null;
        const inst = ctx.nodeData(lhs);
        const inner = inst.lhs;
        if (inner == .none or ctx.nodeTag(inner) != .new_expr) return null;
        if (ctx.nodeData(inner).rhs != .none) return null; // inner new_expr must have no args
        const callee = ctx.nodeData(inner).lhs;
        if (callee == .none or ctx.nodeTag(callee) != .identifier) return null;
        return .{ .callee_name = ctx.tokenText(ctx.nodeMainToken(callee)), .has_type_args = true };
    }

    return null;
}

/// Find the type annotation for a binding pattern (identifier or object/array pattern).
/// For identifiers: binding.data.rhs.
/// For patterns: scan between binding and param_node for a ts_type_annotation whose parent is binding.
fn getPatternAnnotation(binding: NodeIndex, param_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(binding);
    if (tag == .identifier) {
        const rhs = ctx.nodeData(binding).rhs;
        if (rhs != .none and ctx.nodeTag(rhs) == .ts_type_annotation) return rhs;
        return .none;
    }
    if (tag == .object_pattern or tag == .array_pattern) {
        const start = @intFromEnum(binding) + 1;
        const end = @intFromEnum(param_node);
        var i: u32 = start;
        while (i < end and i < ctx.ast.nodes.len) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (ctx.nodeTag(ni) == .ts_type_annotation and ctx.parentOf(ni) == binding) {
                return ni;
            }
        }
    }
    return .none;
}

/// Returns true when `name` is a built-in typed array AND is NOT shadowed by
/// a local class declaration (shadowing means we should still fire the rule).
fn isBuiltInGlobalArray(name: []const u8, ctx: *const LintContext) bool {
    var is_built_in = false;
    for (builtin_typed_arrays) |bn| {
        if (std.mem.eql(u8, name, bn)) { is_built_in = true; break; }
    }
    if (!is_built_in) return false;
    // Check root-level class declarations for a shadow
    const root_data = ctx.nodeData(@enumFromInt(0));
    const s = @intFromEnum(root_data.lhs);
    const e = @intFromEnum(root_data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return true;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const n: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(n) != .class_decl) continue;
        const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(n).lhs));
        if (cd.name == .none) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(cd.name)), name)) return false;
    }
    return true;
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .constructor_def, .method_def, .computed_method_def,
        .ts_declare_function => true,
        else => false,
    };
}
