// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/unbound-method

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
    .name = "unbound-method",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unbound use of class methods",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr, .optional_member_expr,
    .object_pattern,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const tag = ctx.nodeTag(node);
    if (tag == .object_pattern) {
        checkObjectPattern(node, ctx);
        return;
    }
    const d = ctx.nodeData(node);
    if (d.rhs == .none) return;
    const prop = ctx.tokenText(ctx.nodeMainToken(d.rhs));
    if (prop.len == 0) return;

    // Skip if this member-expr is in a "safe" position.
    if (isSafePosition(node, ctx)) return;

    const ignore_static = readIgnoreStatic(ctx);

    // `super.foo` — receiver is the parent class's instance type.
    if (ctx.nodeTag(d.lhs) == .super_expr) {
        if (superClassInstanceHasMethod(node, prop, ctx)) {
            ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
            return;
        }
    }

    // Instance-method case: receiver's type has a method-defined prop.
    const recv_ty = ctx.typeOfNode(d.lhs);
    if (ctx.typeIdObjectPropertyIsMethod(recv_ty, prop)) {
        const msg: []const u8 = if (ctx.typeIdObjectPropertyIsFnProperty(recv_ty, prop))
            "unbound"
        else
            "unboundWithoutThisAnnotation";
        ctx.reportWithMessageId(node, msg);
        return;
    }
    // Static-method case: receiver is an Identifier that resolves to a
    // class declaration which contains a `static` method_def named
    // `prop`.  Walk the class body syntactically.
    if (staticMethodAccess(d.lhs, prop, ctx)) {
        if (ignore_static) return;
        const msg: []const u8 = if (classStaticIsFnProperty(d.lhs, prop, ctx))
            "unbound"
        else
            "unboundWithoutThisAnnotation";
        ctx.reportWithMessageId(node, msg);
        return;
    }
    // Built-in lib-class instance: `foo: Number; foo.toFixed`, `foo: Date;
    // foo.getTime` — these are all `this`-binding prototype methods.
    if (isBuiltinPrototypeMethod(recv_ty, prop, ctx)) {
        ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
        return;
    }
    // Built-in static method: `Promise.all`, `Number.parseInt`,
    // `Math.floor`, etc.  Receiver is an Identifier whose name is a
    // global builtin and the property is one of its known methods.
    if (isBuiltinStaticMethod(d.lhs, prop, ctx)) {
        if (ignore_static) return;
        ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
        return;
    }
    // `Class.prototype.method` — when receiver is an X.prototype access
    // and X is a class declared in this file, treat as instance method.
    if (prototypeAccessHasInstanceMethod(d.lhs, prop, ctx)) {
        ctx.reportWithMessageId(node, "unboundWithoutThisAnnotation");
        return;
    }
}

fn superClassInstanceHasMethod(member_node: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    // Walk up to find the enclosing class.
    var cur = ctx.parentOf(member_node);
    var depth: u32 = 0;
    while (cur != .none and depth < 32) : ({ cur = ctx.parentOf(cur); depth += 1; }) {
        const tag = ctx.nodeTag(cur);
        if (tag == .class_decl or tag == .class_expr) {
            const d = ctx.nodeData(cur);
            if (d.lhs == .none) return false;
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
            if (cd.super_class == .none) return false;
            var s = cd.super_class;
            while (ctx.nodeTag(s) == .grouping_expr) s = ctx.nodeData(s).lhs;
            if (ctx.nodeTag(s) != .identifier) return false;
            const parent_name = ctx.tokenText(ctx.nodeMainToken(s));
            if (parent_name.len == 0) return false;
            const parent_decl = ctx.classDeclByName(parent_name);
            if (parent_decl == .none) {
                // Built-in superclass?
                return isKnownPrototypeMethod(parent_name, prop);
            }
            return classHasInstanceMethod(parent_decl, prop, ctx);
        }
    }
    return false;
}

fn readIgnoreStatic(ctx: *const LintContext) bool {
    const v = ctx.rule_options orelse return false;
    if (v.* != .object) return false;
    const x = v.object.get("ignoreStatic") orelse return false;
    return x == .bool and x.bool;
}

fn prototypeAccessHasInstanceMethod(recv: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .member_expr) return false;
    const md = ctx.nodeData(n);
    if (md.rhs == .none) return false;
    const inner_prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, inner_prop, "prototype")) return false;
    var cls_node = md.lhs;
    while (ctx.nodeTag(cls_node) == .grouping_expr) cls_node = ctx.nodeData(cls_node).lhs;
    if (ctx.nodeTag(cls_node) != .identifier) return false;
    const class_name = ctx.tokenText(ctx.nodeMainToken(cls_node));
    if (class_name.len == 0) return false;
    const decl = ctx.classDeclByName(class_name);
    if (decl == .none) {
        // Built-in class? Defer to prototype catalogue.
        return isKnownPrototypeMethod(class_name, prop);
    }
    // Walk class body for a non-static method_def named `prop`.
    return classHasInstanceMethod(decl, prop, ctx);
}

fn classHasInstanceMethod(decl: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.body == .none) return false;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .method_def) continue;
        const md_data = ctx.nodeData(m);
        if (md_data.rhs == .none) continue;
        const meth = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
        if ((meth.modifiers & ast.ModifierBit.@"static") != 0) continue;
        if (md_data.lhs == .none) continue;
        const k = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
        if (std.mem.eql(u8, k, prop)) return true;
    }
    return false;
}

/// `Class.prototype.method` access — TSe always flags these.
fn isPrototypeAccess(recv: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(recv) != .member_expr) return false;
    const md = ctx.nodeData(recv);
    if (md.rhs == .none) return false;
    const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    return std.mem.eql(u8, prop, "prototype");
}

fn isBuiltinPrototypeMethod(recv_ty: tymod.TypeId, prop: []const u8, ctx: *const LintContext) bool {
    // The receiver's type must be one of the standard wrapper-object
    // refs whose prototype methods rely on `this`.
    const kind = ctx.typeIdKind(recv_ty) orelse return false;
    if (kind != .type_ref) return false;
    const name = ctx.typeIdRefName(recv_ty);
    if (isThisBindingPrototypeClass(name)) {
        return isKnownPrototypeMethod(name, prop);
    }
    return false;
}

fn isBuiltinStaticMethod(recv: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    const cls = ctx.tokenText(ctx.nodeMainToken(n));
    return isKnownStaticMethod(cls, prop);
}

fn isThisBindingPrototypeClass(name: []const u8) bool {
    const list = [_][]const u8{
        "Number",   "String", "Boolean", "Date",  "Object",
        "Array",    "Map",    "Set",     "WeakMap", "WeakSet",
        "Function", "Error",  "Promise", "RegExp", "Symbol",
        "ArrayBuffer", "DataView",
    };
    inline for (list) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn isKnownPrototypeMethod(class_name: []const u8, method: []const u8) bool {
    // A small but representative catalogue of prototype methods that
    // observably need `this`.  Conservative: we only flag well-known
    // entries; anything else falls back to lenient.
    if (std.mem.eql(u8, class_name, "Number")) {
        const m = [_][]const u8{ "toFixed", "toString", "toExponential", "toLocaleString", "toPrecision", "valueOf" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "String")) {
        const m = [_][]const u8{ "charAt", "charCodeAt", "concat", "endsWith", "includes", "indexOf", "lastIndexOf", "match", "matchAll", "normalize", "padEnd", "padStart", "repeat", "replace", "replaceAll", "search", "slice", "split", "startsWith", "substr", "substring", "toLocaleLowerCase", "toLocaleUpperCase", "toLowerCase", "toString", "toUpperCase", "trim", "trimEnd", "trimStart", "valueOf", "at" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Date")) {
        const m = [_][]const u8{ "getDate", "getDay", "getFullYear", "getHours", "getMilliseconds", "getMinutes", "getMonth", "getSeconds", "getTime", "getTimezoneOffset", "getUTCDate", "getUTCDay", "getUTCFullYear", "getUTCHours", "getUTCMilliseconds", "getUTCMinutes", "getUTCMonth", "getUTCSeconds", "setDate", "setFullYear", "setHours", "setMilliseconds", "setMinutes", "setMonth", "setSeconds", "setTime", "setUTCDate", "setUTCFullYear", "setUTCHours", "setUTCMilliseconds", "setUTCMinutes", "setUTCMonth", "setUTCSeconds", "toDateString", "toISOString", "toJSON", "toLocaleDateString", "toLocaleString", "toLocaleTimeString", "toString", "toTimeString", "toUTCString", "valueOf" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Object")) {
        const m = [_][]const u8{ "hasOwnProperty", "isPrototypeOf", "propertyIsEnumerable", "toLocaleString", "toString", "valueOf" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Array")) {
        const m = [_][]const u8{ "at", "concat", "copyWithin", "entries", "every", "fill", "filter", "find", "findIndex", "findLast", "findLastIndex", "flat", "flatMap", "forEach", "includes", "indexOf", "join", "keys", "lastIndexOf", "map", "pop", "push", "reduce", "reduceRight", "reverse", "shift", "slice", "some", "sort", "splice", "toLocaleString", "toString", "unshift", "values" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Map") or std.mem.eql(u8, class_name, "WeakMap")) {
        const m = [_][]const u8{ "clear", "delete", "entries", "forEach", "get", "has", "keys", "set", "values" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Set") or std.mem.eql(u8, class_name, "WeakSet")) {
        const m = [_][]const u8{ "add", "clear", "delete", "entries", "forEach", "has", "keys", "values" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Promise")) {
        const m = [_][]const u8{ "then", "catch", "finally" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "RegExp")) {
        const m = [_][]const u8{ "exec", "test", "toString" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Function")) {
        const m = [_][]const u8{ "apply", "bind", "call", "toString" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    if (std.mem.eql(u8, class_name, "Error")) {
        const m = [_][]const u8{ "toString" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    return false;
}

fn isKnownStaticMethod(cls: []const u8, method: []const u8) bool {
    // Most JS built-in statics are pure functions that don't depend on
    // `this` — `Math.floor`, `Number.parseInt`, `Object.keys`,
    // `JSON.stringify`, `Array.from`, etc. — and TSe doesn't flag them.
    // Promise's statics internally call `this.resolve` / `this.reject`,
    // so they do need their `this` and are flagged.
    if (std.mem.eql(u8, cls, "Promise")) {
        const m = [_][]const u8{ "all", "allSettled", "any", "race", "reject", "resolve" };
        inline for (m) |x| if (std.mem.eql(u8, x, method)) return true;
        return false;
    }
    return false;
}

fn staticMethodAccess(recv: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    return staticMethodAccessAlias(recv, prop, ctx, 0);
}

fn staticMethodAccessAlias(recv: NodeIndex, prop: []const u8, ctx: *const LintContext, depth: u32) bool {
    if (depth > 4) return false;
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    const class_name = ctx.tokenText(ctx.nodeMainToken(n));
    if (class_name.len == 0) return false;
    const decl = ctx.classDeclByName(class_name);
    if (decl != .none) {
        if (classHasStaticMethod(decl, prop, ctx)) return true;
        // Walk the extends chain — a subclass of Number/String/etc.
        // inherits their static methods.
        if (classExtendsName(decl, ctx)) |parent_name| {
            // Resolve via a synthetic identifier node?  We have the
            // text; check the built-in static-method catalogue first.
            if (isBuiltinStaticMethodByName(parent_name, prop)) return true;
            // Otherwise look up the parent class declaration and recurse.
            const parent_decl = ctx.classDeclByName(parent_name);
            if (parent_decl != .none) {
                if (classHasStaticMethod(parent_decl, prop, ctx)) return true;
            }
        }
        return false;
    }
    // Not a class name directly — could be `const foo = Bar` where
    // Bar is the class.  Resolve the alias and retry.
    if (ctx.constInitializerOf(n)) |init_node| {
        return staticMethodAccessAlias(init_node, prop, ctx, depth + 1);
    }
    return false;
}

fn classExtendsName(decl: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return null;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.super_class == .none) return null;
    var s = cd.super_class;
    while (ctx.nodeTag(s) == .grouping_expr) s = ctx.nodeData(s).lhs;
    if (ctx.nodeTag(s) != .identifier) return null;
    const name = ctx.tokenText(ctx.nodeMainToken(s));
    if (name.len == 0) return null;
    return name;
}

fn isBuiltinStaticMethodByName(class_name: []const u8, prop: []const u8) bool {
    if (std.mem.eql(u8, class_name, "Number")) {
        return std.mem.eql(u8, prop, "parseInt") or
            std.mem.eql(u8, prop, "parseFloat") or
            std.mem.eql(u8, prop, "isFinite") or
            std.mem.eql(u8, prop, "isInteger") or
            std.mem.eql(u8, prop, "isNaN") or
            std.mem.eql(u8, prop, "isSafeInteger");
    }
    if (std.mem.eql(u8, class_name, "String")) {
        return std.mem.eql(u8, prop, "fromCharCode") or
            std.mem.eql(u8, prop, "fromCodePoint") or
            std.mem.eql(u8, prop, "raw");
    }
    if (std.mem.eql(u8, class_name, "Object")) {
        return std.mem.eql(u8, prop, "defineProperty") or
            std.mem.eql(u8, prop, "defineProperties") or
            std.mem.eql(u8, prop, "freeze") or
            std.mem.eql(u8, prop, "fromEntries") or
            std.mem.eql(u8, prop, "getOwnPropertyDescriptor") or
            std.mem.eql(u8, prop, "getOwnPropertyDescriptors") or
            std.mem.eql(u8, prop, "getOwnPropertyNames") or
            std.mem.eql(u8, prop, "getOwnPropertySymbols") or
            std.mem.eql(u8, prop, "getPrototypeOf") or
            std.mem.eql(u8, prop, "setPrototypeOf") or
            std.mem.eql(u8, prop, "is") or
            std.mem.eql(u8, prop, "isFrozen") or
            std.mem.eql(u8, prop, "isSealed") or
            std.mem.eql(u8, prop, "isExtensible") or
            std.mem.eql(u8, prop, "keys") or
            std.mem.eql(u8, prop, "values") or
            std.mem.eql(u8, prop, "entries") or
            std.mem.eql(u8, prop, "assign") or
            std.mem.eql(u8, prop, "create") or
            std.mem.eql(u8, prop, "seal") or
            std.mem.eql(u8, prop, "preventExtensions");
    }
    // Array statics (`from`, `of`, `isArray`) are declared in lib.d.ts
    // with `this: void` semantics — TS-eslint doesn't flag them.
    if (std.mem.eql(u8, class_name, "Promise")) {
        return std.mem.eql(u8, prop, "all") or
            std.mem.eql(u8, prop, "allSettled") or
            std.mem.eql(u8, prop, "any") or
            std.mem.eql(u8, prop, "race") or
            std.mem.eql(u8, prop, "reject") or
            std.mem.eql(u8, prop, "resolve");
    }
    if (std.mem.eql(u8, class_name, "Date")) {
        return std.mem.eql(u8, prop, "parse") or
            std.mem.eql(u8, prop, "UTC") or
            std.mem.eql(u8, prop, "now");
    }
    return false;
}

fn classHasStaticMethod(decl: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    return classFindStaticMember(decl, prop, ctx) != null;
}

/// `property_def` doesn't store modifiers in PropertyData, so detect
/// `static` by scanning a few tokens preceding the property key.
fn propertyDefIsStatic(node: NodeIndex, ctx: *const LintContext) bool {
    const main = ctx.nodeMainToken(node);
    var i: u32 = main;
    var steps: u32 = 0;
    while (i > 0 and steps < 6) : ({ i -= 1; steps += 1; }) {
        const tag = ctx.tokenTag(i);
        if (tag == .kw_static) return true;
        switch (tag) {
            .kw_declare, .kw_abstract, .kw_override, .kw_readonly,
            => continue,
            .identifier => {
                const text = ctx.tokenText(i);
                if (std.mem.eql(u8, text, "public") or
                    std.mem.eql(u8, text, "private") or
                    std.mem.eql(u8, text, "protected"))
                {
                    continue;
                }
                return false;
            },
            else => return false,
        }
    }
    return false;
}

const StaticMemberKind = enum { method_def, fn_property };

fn classFindStaticMember(decl: NodeIndex, prop: []const u8, ctx: *const LintContext) ?StaticMemberKind {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return null;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.body == .none) return null;
    const body_data = ctx.nodeData(cd.body);
    const s = @intFromEnum(body_data.lhs);
    const e = @intFromEnum(body_data.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mtag = ctx.nodeTag(m);
        const md_data = ctx.nodeData(m);
        if (mtag == .method_def) {
            if (md_data.rhs == .none) continue;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
            if ((meth.modifiers & ast.ModifierBit.@"static") == 0) continue;
            if (md_data.lhs == .none) continue;
            const k = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
            if (std.mem.eql(u8, k, prop)) return .method_def;
        } else if (mtag == .property_def) {
            if (md_data.lhs == .none) continue;
            if (md_data.rhs == .none) continue;
            if (!propertyDefIsStatic(m, ctx)) continue;
            const k = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
            if (!std.mem.eql(u8, k, prop)) continue;
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(md_data.rhs));
            if (pd.value == .none) continue;
            const vt = ctx.nodeTag(pd.value);
            if (vt == .fn_expr or vt == .async_fn_expr or
                vt == .generator_fn_expr or vt == .async_generator_fn_expr)
            {
                return .fn_property;
            }
        }
    }
    return null;
}

fn classStaticIsFnProperty(recv: NodeIndex, prop: []const u8, ctx: *const LintContext) bool {
    return classStaticIsFnPropertyAlias(recv, prop, ctx, 0);
}

fn classStaticIsFnPropertyAlias(recv: NodeIndex, prop: []const u8, ctx: *const LintContext, depth: u32) bool {
    if (depth > 4) return false;
    var n = recv;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .identifier) return false;
    const class_name = ctx.tokenText(ctx.nodeMainToken(n));
    if (class_name.len == 0) return false;
    const decl = ctx.classDeclByName(class_name);
    if (decl != .none) {
        if (classFindStaticMember(decl, prop, ctx)) |k| {
            return k == .fn_property;
        }
        return false;
    }
    if (ctx.constInitializerOf(n)) |init_node| {
        return classStaticIsFnPropertyAlias(init_node, prop, ctx, depth + 1);
    }
    return false;
}

/// Destructuring `const { method } = instance` extracts methods
/// without their `this`-binding — fire on each pattern entry that
/// matches a class instance method.
/// True when an object_pattern lives inside a declaration-only
/// position (declare function / abstract method / declare class
/// method / interface method signature).  These contexts have no
/// runtime binding so destructuring can't lose `this`.
fn patternIsInDeclarationOnly(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    var depth: u32 = 0;
    while (cur != .none and depth < 8) : ({ cur = ctx.parentOf(cur); depth += 1; }) {
        const tag = ctx.nodeTag(cur);
        switch (tag) {
            .ts_declare_function, .ts_method_signature,
            .ts_call_signature, .ts_construct_signature,
            => return true,
            .method_def, .computed_method_def => {
                // Abstract methods carry no body — same as declarations.
                const d = ctx.nodeData(cur);
                if (d.rhs == .none) return false;
                const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
                if (meth.body == .none) return true;
                if ((meth.modifiers & ast.ModifierBit.@"abstract") != 0) return true;
                return false;
            },
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            => {
                // A regular function with a body — not declaration-only.
                return false;
            },
            else => {},
        }
    }
    return false;
}

/// Locate the parser-stashed type annotation for a destructuring
/// pattern that's in parameter position.  The parser sets
/// parents[ts_type_annotation] = obj_pattern_node — scan ts_type_annotation
/// nodes whose parent is `pattern_node` and resolve their inner type.
fn patternAnnotationType(pattern_node: NodeIndex, ctx: *const LintContext) ?tymod.TypeId {
    const total = ctx.ast.nodes.len;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const n: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(n) != .ts_type_annotation) continue;
        if (ctx.parentOf(n) != pattern_node) continue;
        const inner = ctx.nodeData(n).lhs;
        if (inner == .none) continue;
        return ctx.resolveTypeAnnotationNode(inner);
    }
    return null;
}

/// Walk up from a declarator into `for (const {x} of expr) ...` and
/// return the array element type — i.e. each loop iteration's value
/// type for the destructuring source.
fn forOfElementType(decl: NodeIndex, ctx: *const LintContext) ?tymod.TypeId {
    // declarator → const_decl/let_decl/var_decl → for_of_stmt
    var cur = ctx.parentOf(decl);
    var depth: u32 = 0;
    while (cur != .none and depth < 4) : ({ cur = ctx.parentOf(cur); depth += 1; }) {
        if (ctx.nodeTag(cur) == .for_of_stmt or ctx.nodeTag(cur) == .for_await_of_stmt) {
            const d = ctx.nodeData(cur);
            if (d.lhs == .none) return null;
            const fd = ctx.extraData(ast.ForInOfData, @intFromEnum(d.lhs));
            if (fd.expr == .none) return null;
            const arr_ty = ctx.narrowedTypeOf(fd.expr);
            // Pluck the array element type.
            return ctx.typeIdArrayElement(arr_ty);
        }
    }
    return null;
}

fn checkObjectPattern(node: NodeIndex, ctx: *const LintContext) void {
    // Find the source of the destructuring (the declarator's init,
    // the right-hand side of an assignment, or the iterable of a
    // for-of loop).
    const parent = ctx.parentOf(node);
    if (parent == .none) return;
    // Skip when the pattern is in a declaration-only context (declare
    // function, abstract method, interface/declare-class member, etc.)
    // — there's no actual runtime destructuring that could lose `this`.
    if (patternIsInDeclarationOnly(node, ctx)) return;
    var source_ty: tymod.TypeId = tymod.ID_UNKNOWN;
    var init_ty: tymod.TypeId = tymod.ID_UNKNOWN;
    var have_init = false;
    var have_source = false;
    switch (ctx.nodeTag(parent)) {
        .declarator => {
            const pd = ctx.nodeData(parent);
            if (pd.rhs != .none) {
                source_ty = ctx.typeOfNode(pd.rhs);
                have_source = true;
            } else {
                // No initializer — could be `for (const {x} of arr)`.
                source_ty = forOfElementType(parent, ctx) orelse return;
                have_source = true;
            }
        },
        .assign => {
            const pd = ctx.nodeData(parent);
            source_ty = ctx.typeOfNode(pd.rhs);
            have_source = true;
        },
        else => {
            // Parameter position: the parser stashes the type
            // annotation as a sibling node whose parent is the
            // obj_pattern.  Find it.
            if (patternAnnotationType(node, ctx)) |t| {
                source_ty = t;
                have_source = true;
            }
            // Assignment-pattern parent: `{x}: T = default` — annotation
            // is on the obj_pattern; default lives in assignment_pattern.
            if (ctx.nodeTag(parent) == .assignment_pattern) {
                const pd = ctx.nodeData(parent);
                if (pd.rhs != .none) {
                    init_ty = ctx.typeOfNode(pd.rhs);
                    have_init = true;
                }
            }
        },
    }
    // Class-as-value source: when the destructured RHS is an identifier
    // referring to a class declaration, destructured names match the
    // class's STATIC methods (not instance methods).
    var class_static_decl: NodeIndex = .none;
    // Class.prototype source: destructured names match the class's
    // INSTANCE methods.
    var class_prototype_decl: NodeIndex = .none;
    // Built-in static catalogue source: e.g. `const { all } = Promise`.
    var builtin_class_name: ?[]const u8 = null;
    if (have_source) {
        const parent_data = ctx.nodeData(parent);
        const init_node = parent_data.rhs;
        if (init_node != .none) {
            if (ctx.nodeTag(init_node) == .identifier) {
                const class_name = ctx.tokenText(ctx.nodeMainToken(init_node));
                const decl = ctx.classDeclByName(class_name);
                if (decl != .none) {
                    class_static_decl = decl;
                } else if (isThisBindingPrototypeClass(class_name)) {
                    builtin_class_name = class_name;
                }
            } else if (ctx.nodeTag(init_node) == .member_expr) {
                // Recognize `X.prototype` for some class X in the file.
                const md = ctx.nodeData(init_node);
                if (md.rhs != .none) {
                    const prop = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                    if (std.mem.eql(u8, prop, "prototype") and
                        md.lhs != .none and
                        ctx.nodeTag(md.lhs) == .identifier)
                    {
                        const class_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
                        const decl = ctx.classDeclByName(class_name);
                        if (decl != .none) class_prototype_decl = decl;
                    }
                }
            }
        }
    }

    if (!have_source) return;

    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e <= s or e > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const child: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(child);
        var name_node: NodeIndex = .none;
        if (tag == .shorthand_property) {
            name_node = ctx.nodeData(child).lhs;
        } else if (tag == .property or tag == .computed_property) {
            name_node = ctx.nodeData(child).lhs;
        }
        if (name_node == .none) continue;
        if (ctx.nodeTag(name_node) != .identifier) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(name_node));
        if (class_static_decl != .none) {
            if (classFindStaticMember(class_static_decl, name, ctx)) |k| {
                const msg: []const u8 = if (k == .fn_property)
                    "unbound"
                else
                    "unboundWithoutThisAnnotation";
                ctx.reportWithMessageId(name_node, msg);
                continue;
            }
        }
        if (class_prototype_decl != .none) {
            if (classHasInstanceMethod(class_prototype_decl, name, ctx)) {
                ctx.reportWithMessageId(name_node, "unboundWithoutThisAnnotation");
                continue;
            }
        }
        if (builtin_class_name) |bcls| {
            if (isKnownStaticMethod(bcls, name)) {
                ctx.reportWithMessageId(name_node, "unboundWithoutThisAnnotation");
                continue;
            }
        }
        // ts-eslint's ObjectPattern handler: when there's an init
        // expression, FIRST check the init's type — if it has a method
        // matching the prop, fire with the init's messageId and skip
        // the annotation.  Falling through, iterate annotation's
        // union/intersection constituents.
        if (have_init and ctx.typeIdObjectPropertyIsMethod(init_ty, name)) {
            const msg: []const u8 = if (ctx.typeIdObjectPropertyIsFnProperty(init_ty, name))
                "unbound"
            else
                "unboundWithoutThisAnnotation";
            ctx.reportWithMessageId(name_node, msg);
            continue;
        }
        if (ctx.typeIdObjectPropertyIsMethod(source_ty, name)) {
            const msg: []const u8 = if (ctx.typeIdObjectPropertyIsFnProperty(source_ty, name))
                "unbound"
            else
                "unboundWithoutThisAnnotation";
            ctx.reportWithMessageId(name_node, msg);
        }
    }
}

/// Mirrors @typescript-eslint/unbound-method `isSafeUse`.
fn isSafePosition(node: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(node);
    if (parent == .none) return false;
    const ptag = ctx.nodeTag(parent);
    const pd = ctx.nodeData(parent);
    switch (ptag) {
        .if_stmt, .while_stmt, .do_while_stmt, .for_stmt,
        .switch_stmt,
        .member_expr, .optional_member_expr,
        .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec,
        => return true,
        .call_expr, .optional_call_expr, .new_expr => return pd.lhs == node,
        .conditional => return pd.lhs == node,
        .tagged_template => return pd.lhs == node,
        .logical_not, .delete_expr, .typeof_expr, .void_expr => return true,
        .equal, .not_equal, .strict_equal, .strict_not_equal, .instanceof_expr => return true,
        .assign => {
            if (pd.lhs == node) return true;
            // Special case: `this.x = super.y` saves the super method
            // to a this-bound property — not a this-loss pattern.
            const nd = ctx.nodeData(node);
            if ((ctx.nodeTag(node) == .member_expr or ctx.nodeTag(node) == .optional_member_expr) and
                nd.lhs != .none and ctx.nodeTag(nd.lhs) == .super_expr and
                pd.lhs != .none)
            {
                var lhs = pd.lhs;
                while (ctx.nodeTag(lhs) == .grouping_expr) lhs = ctx.nodeData(lhs).lhs;
                if (ctx.nodeTag(lhs) == .member_expr or ctx.nodeTag(lhs) == .optional_member_expr) {
                    const ld = ctx.nodeData(lhs);
                    if (ld.lhs != .none and ctx.nodeTag(ld.lhs) == .this_expr) return true;
                }
            }
            return false;
        },
        .grouping_expr, .ts_as_expr, .ts_non_null_expr, .ts_type_assertion, .ts_satisfies_expr
        => return isSafePosition(parent, ctx),
        .logical_and => {
            if (pd.lhs == node) return true;
            return isSafePosition(parent, ctx);
        },
        .logical_or, .nullish_coalesce => return isSafePosition(parent, ctx),
        else => return false,
    }
}

