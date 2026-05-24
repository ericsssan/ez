// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/restrict-template-expressions
//
// Reports each ${expr} in a tagged-or-untagged template_literal whose
// type contains a member not in the allow-set.  Allow flags default to
// the TSe defaults (allowNumber=true, allowBoolean=true, allowNullish=true,
// allowAny=true, allowRegExp=true, allowNever=true, allowArray=false).
//
// String types are always allowed.  Each constituent of a top-level
// union is checked independently — any disallowed member fires.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "restrict-template-expressions",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Restrict ${expr} interpolations to safely-stringifiable types",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .template_literal,
};

pub const needs_semantic = true;

const Options = struct {
    allow_any: bool = true,
    allow_array: bool = false,
    allow_boolean: bool = true,
    allow_never: bool = true,
    allow_nullish: bool = true,
    allow_number: bool = true,
    allow_regexp: bool = true,
    // Names from the `allow` option (or the rule's default lib-allows
    // `Error`, `URL`, `URLSearchParams` when no override is supplied).
    // We only honour string names — full `{from, name}` matching against
    // declaration files would need cross-file symbol resolution.
    allow_names: ?*const std.json.Value = null,
    use_default_allow: bool = true,
};

const DEFAULT_ALLOW: []const []const u8 = &.{ "Error", "URL", "URLSearchParams" };

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("allowAny")) |x| if (x == .bool) { opts.allow_any = x.bool; };
    if (v.object.get("allowArray")) |x| if (x == .bool) { opts.allow_array = x.bool; };
    if (v.object.get("allowBoolean")) |x| if (x == .bool) { opts.allow_boolean = x.bool; };
    if (v.object.get("allowNever")) |x| if (x == .bool) { opts.allow_never = x.bool; };
    if (v.object.get("allowNullish")) |x| if (x == .bool) { opts.allow_nullish = x.bool; };
    if (v.object.get("allowNumber")) |x| if (x == .bool) { opts.allow_number = x.bool; };
    if (v.object.get("allowRegExp")) |x| if (x == .bool) { opts.allow_regexp = x.bool; };
    if (v.object.getPtr("allow")) |arr_ptr| {
        opts.allow_names = arr_ptr;
        opts.use_default_allow = false;
    }
    return opts;
}

/// Syntactic fallback: accept an interpolation whose value is an
/// Identifier or `new X(...)` / `X()` whose root name resolves to an
/// allowed type-name (the `allow` option, or the default lib allow-set).
/// Skips through `?.`, calls, member-access for one hop.
/// Check if the type's declared name (or any ancestor in its inheritance
/// chain) is in the allow list.  Uses `typeIdInheritsFrom` for true class/
/// interface chains.  Also iterates the allow names and asks the checker
/// `resolveDeclaredTypeByName` to see if our id corresponds to a known
/// declared type by that name.
fn typeMatchesAllowByInheritance(id: TypeId, opts: Options, ctx: *const LintContext) bool {
    // Walk every allow name and ask checker.
    const allow_list = if (opts.use_default_allow) DEFAULT_ALLOW_LIST else namesFromOption(opts);
    for (allow_list) |name| {
        if (ctx.typeIdInheritsFrom(id, name)) return true;
        if (ctx.resolveDeclaredTypeByName(name)) |declared_id| {
            if (typeIdIsOrUnionMember(id, declared_id, ctx)) return true;
        }
    }
    return false;
}

fn typeIdIsOrUnionMember(id: TypeId, target: TypeId, ctx: *const LintContext) bool {
    if (id.eq(target)) return true;
    const kind = ctx.typeIdKind(id) orelse return false;
    if (kind == .union_t or kind == .intersection_t) {
        for (ctx.typeIdUnionMembers(id)) |m| if (m.eq(target)) return true;
    }
    return false;
}

const DEFAULT_ALLOW_LIST: []const []const u8 = DEFAULT_ALLOW;

/// Iterate the user-supplied allow list, yielding the `name` string of
/// each entry (object form's `name` field, or string entries directly).
/// Returns an empty slice if the option isn't present or is not an array.
const NAME_BUF_LEN = 16;
threadlocal var name_buf: [NAME_BUF_LEN][]const u8 = undefined;
fn namesFromOption(opts: Options) []const []const u8 {
    const arr_v = opts.allow_names orelse return &.{};
    if (arr_v.* != .array) return &.{};
    var n: usize = 0;
    for (arr_v.array.items) |entry| {
        if (n >= NAME_BUF_LEN) break;
        switch (entry) {
            .string => |s| {
                name_buf[n] = s;
                n += 1;
            },
            .object => |obj| {
                const nm = obj.get("name") orelse continue;
                if (nm != .string) continue;
                name_buf[n] = nm.string;
                n += 1;
            },
            else => {},
        }
    }
    return name_buf[0..n];
}

/// `declare const obj: Custom; ${obj}` — look at the declarator's
/// type-annotation Identifier and check against the allow list.
fn matchesAllowedByBindingAnnotation(expr: NodeIndex, opts: Options, ctx: *const LintContext) bool {
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    const ann = ctx.bindingTypeAnnotationOf(n) orelse return false;
    // The annotation may be a ts_type_annotation wrapping a
    // ts_type_reference.  Extract the inner name identifier.
    const name = typeAnnotationName(ann, ctx) orelse return false;
    return nameOrAncestorAllowed(name, opts, ctx);
}

fn typeAnnotationName(ann: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var n = ann;
    // Unwrap ts_type_annotation if present.
    if (ctx.nodeTag(n) == .ts_type_annotation) n = ctx.nodeData(n).lhs;
    // ts_type_reference: lhs = name identifier (or qualified-name member).
    const tag = ctx.nodeTag(n);
    if (tag == .ts_type_reference) {
        const inner = ctx.nodeData(n).lhs;
        if (ctx.nodeTag(inner) == .identifier) {
            return ctx.tokenText(ctx.nodeMainToken(inner));
        }
    }
    // Bare identifier as type position (unusual).
    if (tag == .identifier) {
        return ctx.tokenText(ctx.nodeMainToken(n));
    }
    return null;
}

fn matchesAllowedConstructor(expr: NodeIndex, opts: Options, ctx: *const LintContext) bool {
    return matchesAllowedConstructorDepth(expr, opts, ctx, 0);
}

fn matchesAllowedConstructorDepth(expr: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (depth > 2) return false;
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .new_expr or tag == .call_expr or tag == .optional_call_expr) {
        var callee = ctx.nodeData(n).lhs;
        while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        const ctag = ctx.nodeTag(callee);
        if (ctag == .identifier) {
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            if (nameOrAncestorAllowed(name, opts, ctx)) return true;
        }
        // `Promise.resolve()` / `URL.parse()` etc. — receiver name.
        if (ctag == .member_expr or ctag == .optional_member_expr) {
            var recv = ctx.nodeData(callee).lhs;
            while (ctx.nodeTag(recv) == .grouping_expr) recv = ctx.nodeData(recv).lhs;
            if (ctx.nodeTag(recv) == .identifier) {
                const name = ctx.tokenText(ctx.nodeMainToken(recv));
                if (nameOrAncestorAllowed(name, opts, ctx)) return true;
            }
        }
        return false;
    }
    if (tag == .identifier) {
        // Resolve to const-binding initializer; treat as fallback for
        // `const e = new Error(); ${e}` shape.
        if (ctx.constInitializerOf(n)) |init| {
            return matchesAllowedConstructorDepth(init, opts, ctx, depth + 1);
        }
    }
    return false;
}

/// True when `name` is directly in the allow list, or when a declared
/// type by that name inherits from any allowed name.
fn nameOrAncestorAllowed(name: []const u8, opts: Options, ctx: *const LintContext) bool {
    if (nameIsAllowed(name, opts)) return true;
    const allow_list = if (opts.use_default_allow) DEFAULT_ALLOW_LIST else namesFromOption(opts);
    for (allow_list) |base| {
        if (ctx.declaredTypeInheritsFrom(name, base)) return true;
    }
    return false;
}

fn nameIsAllowed(name: []const u8, opts: Options) bool {
    if (opts.use_default_allow) {
        for (DEFAULT_ALLOW) |n| if (std.mem.eql(u8, n, name)) return true;
        return false;
    }
    const arr_v = opts.allow_names orelse return false;
    if (arr_v.* != .array) return false;
    for (arr_v.array.items) |entry| {
        switch (entry) {
            .string => |s| if (std.mem.eql(u8, s, name)) return true,
            .object => |obj| {
                const nm = obj.get("name") orelse continue;
                if (nm != .string) continue;
                if (std.mem.eql(u8, nm.string, name)) return true;
            },
            else => {},
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    // Skip tagged templates — the tag handles stringification.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .tagged_template) return;
    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const part: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(part) == .template_element) continue;
        const ty = ctx.typeOfNode(part);
        if (isAllowed(ty, opts, ctx)) continue;
        // Inheritance fallback: if the expression's type is — or extends —
        // an allowed declared name, accept.
        if (typeMatchesAllowByInheritance(ty, opts, ctx)) continue;
        // Type-side fallback: when the checker can't resolve the
        // expression's type (error_t / unresolved object), allow it if
        // the expression is syntactically a constructor call to a name
        // in the `allow` list (default `Error` / `URL` / `URLSearchParams`).
        if (matchesAllowedConstructor(part, opts, ctx)) continue;
        // Annotation fallback: `declare const obj: Custom; ${obj}` —
        // look at the binding's declared type-annotation name.
        if (matchesAllowedByBindingAnnotation(part, opts, ctx)) continue;
        ctx.reportWithMessageId(part, "invalidType");
    }
}

/// Top-level recursion: expand union constituents; every constituent must
/// be allowed.  For non-union types defer to `singleAllowed`.
fn isAllowed(id: TypeId, opts: Options, ctx: *const LintContext) bool {
    return isAllowedDepth(id, opts, ctx, 0);
}

fn isAllowedDepth(id: TypeId, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (depth > 6) return true; // defensive cap; treat as allowed
    const kind = ctx.typeIdKind(id) orelse return true;
    if (kind == .union_t) {
        const ms = ctx.typeIdUnionMembers(id);
        if (ms.len == 0) return true;
        for (ms) |m| if (!isAllowedDepth(m, opts, ctx, depth + 1)) return false;
        return true;
    }
    // Intersection: an intersection like `string & Brand` should be
    // accepted when one constituent is string-like.  Fall back to
    // structural check.
    if (kind == .intersection_t) {
        const ms = ctx.typeIdUnionMembers(id);
        if (ms.len == 0) return true;
        for (ms) |m| if (isAllowedDepth(m, opts, ctx, depth + 1)) return true;
        return false;
    }
    return singleAllowed(id, kind, opts, ctx, depth);
}

fn singleAllowed(id: TypeId, kind: tymod.TypeKind, opts: Options, ctx: *const LintContext, depth: u32) bool {
    return switch (kind) {
        .string, .string_literal => true,
        .number, .number_literal, .bigint, .bigint_literal => opts.allow_number,
        .boolean, .boolean_literal => opts.allow_boolean,
        .null_t, .undefined_t, .void_t => opts.allow_nullish,
        .any => opts.allow_any,
        .never => opts.allow_never,
        .error_t, .unknown => false,
        .array_t, .readonly_array_t => blk: {
            if (!opts.allow_array) break :blk false;
            const el = ctx.typeIdArrayElement(id) orelse break :blk true;
            break :blk isAllowedDepth(el, opts, ctx, depth + 1);
        },
        .tuple_t => blk: {
            if (!opts.allow_array) break :blk false;
            const els = ctx.typeIdTupleElements(id);
            for (els) |el| if (!isAllowedDepth(el, opts, ctx, depth + 1)) break :blk false;
            break :blk true;
        },
        .type_ref => blk: {
            const name = ctx.typeIdRefName(id);
            if (std.mem.eql(u8, name, "RegExp")) break :blk opts.allow_regexp;
            if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
                if (!opts.allow_array) break :blk false;
                const el = ctx.typeIdArrayElement(id) orelse break :blk true;
                break :blk isAllowedDepth(el, opts, ctx, depth + 1);
            }
            if (nameIsAllowed(name, opts)) break :blk true;
            break :blk false;
        },
        else => false,
    };
}
