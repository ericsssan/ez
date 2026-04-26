const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const FnData = ast.FnData;
const MethodData = ast.MethodData;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const symbol_mod = @import("../../../parser/symbol.zig");
const SymbolId = symbol_mod.SymbolId;
const BindingKind = symbol_mod.BindingKind;
const ScopeId = @import("../../../parser/scope.zig").ScopeId;

pub const meta = RuleMeta{
    .name = "no-shadow",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow variable declarations from shadowing variables declared in the outer scope",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Sorted list of ES built-in global names (binary search).
/// Mirrors the es2022 subset of the `globals` npm package.
const BUILTIN_GLOBALS = [_][]const u8{
    "AggregateError",    "Array",           "ArrayBuffer",    "Atomics",
    "BigInt",            "BigInt64Array",   "BigUint64Array", "Boolean",
    "DataView",          "Date",            "Error",          "EvalError",
    "Float32Array",      "Float64Array",    "Function",       "Generator",
    "GeneratorFunction", "Infinity",        "Int16Array",     "Int32Array",
    "Int8Array",         "JSON",            "Map",            "Math",
    "NaN",               "Number",          "Object",         "Promise",
    "Proxy",             "RangeError",      "ReferenceError", "Reflect",
    "RegExp",            "Set",             "SharedArrayBuffer",
    "String",            "Symbol",          "SyntaxError",    "TypeError",
    "URIError",          "Uint16Array",     "Uint32Array",    "Uint8Array",
    "Uint8ClampedArray", "WeakMap",         "WeakRef",        "WeakSet",
    "clearInterval",     "clearTimeout",    "console",        "decodeURI",
    "decodeURIComponent","encodeURI",       "encodeURIComponent",
    "escape",            "eval",            "globalThis",     "isFinite",
    "isNaN",             "parseFloat",      "parseInt",       "queueMicrotask",
    "setInterval",       "setTimeout",      "undefined",      "unescape",
};

fn isBuiltinGlobal(name: []const u8) bool {
    var lo: usize = 0;
    var hi: usize = BUILTIN_GLOBALS.len;
    while (lo < hi) {
        const mid = lo + (hi - lo) / 2;
        const cmp = std.mem.order(u8, name, BUILTIN_GLOBALS[mid]);
        switch (cmp) {
            .lt => hi = mid,
            .gt => lo = mid + 1,
            .eq => return true,
        }
    }
    return false;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const total = symbols.count();
    const allocator = ctx.allocator;

    // Build scope → (name → SymbolId) in one O(n) pass.
    // Storing SymbolId allows position-based TDZ checks later.
    var scope_syms = std.AutoHashMap(ScopeId, std.StringHashMap(SymbolId)).init(allocator);
    defer {
        var it = scope_syms.valueIterator();
        while (it.next()) |m| m.deinit();
        scope_syms.deinit();
    }

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (flags.is_implicit_global) continue;
        const s_bk = symbols.getBindingKind(id);
        const s_is_ts_type = s_bk == .type_decl or s_bk == .interface_decl;
if (!flags.isDeclared() and !s_is_ts_type) continue;
        const scope_id = symbols.getScope(id);
        const name = symbols.getName(id);
        const entry = scope_syms.getOrPut(scope_id) catch continue;
        if (!entry.found_existing) {
            entry.value_ptr.* = std.StringHashMap(SymbolId).init(allocator);
        }
        entry.value_ptr.put(name, id) catch continue;
    }

    // Read rule options.
    var allow_list: ?[]const std.json.Value = null;
    // hoist: "all"|"functions"|"never"|"types"|"functions-and-types" (default: "functions")
    const hoist = ctx.getOptionString("hoist") orelse "functions";
    const hoist_all = std.mem.eql(u8, hoist, "all");
    const hoist_functions = std.mem.eql(u8, hoist, "functions") or
        std.mem.eql(u8, hoist, "functions-and-types");
    const hoist_types = std.mem.eql(u8, hoist, "types") or
        std.mem.eql(u8, hoist, "functions-and-types") or
        hoist_all;
    const ignore_on_init = ctx.getOptionBool("ignoreOnInitialization", false);
    const builtin_globals = ctx.getOptionBool("builtinGlobals", false);
    // ignoreTypeValueShadow: default true — suppress reports when one side is a TS type
    // decl and the other is a value declaration (mirrors typescript-eslint behavior).
    const ignore_type_value_shadow = ctx.getOptionBool("ignoreTypeValueShadow", true);
    // ignoreFunctionTypeParameterNameValueShadow: default true — suppress reports when
    // the inner symbol is a parameter of a bodyless method (declare class, abstract class).
    const ignore_fn_type_param = ctx.getOptionBool("ignoreFunctionTypeParameterNameValueShadow", true);

    if (ctx.rule_options) |opts| {
        if (opts.* == .object) {
            if (opts.object.get("allow")) |allow_val| {
                if (allow_val == .array) allow_list = allow_val.array.items;
            }
        }
    }

    // Check each nested-scope symbol against all ancestor scopes — O(n × depth).
    i = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (flags.is_implicit_global) continue;
        // Named fn/class-expr names with the exception flag are self-referential
        // inside their own scope and are not real shadows of outer variables.
        if (flags.is_expr_name) continue;
        const bk = symbols.getBindingKind(id);
        const is_ts_type = bk == .type_decl or bk == .interface_decl;
        if (!flags.isDeclared() and !is_ts_type) continue;

        const scope_id = symbols.getScope(id);
        const name = symbols.getName(id);

        // At depth 0 (global/module scope): only check builtinGlobals for module scope.
        // In script mode, global-scope vars ARE globals (no shadowing). In module mode,
        // module-scope vars shadow built-in globals.
        if (scopes.depth(scope_id) == 0) {
            if (builtin_globals and scopes.kind(scope_id) == .module and
                !std.mem.eql(u8, name, "this") and
                (isBuiltinGlobal(name) or ctx.globalIsExplicitlyEnabled(name)))
            {
                ctx.report(symbols.getDeclNode(id));
            }
            continue;
        }

        // TypeScript 'this' parameter is a fake type-annotation binding, not a real variable.
        if (std.mem.eql(u8, name, "this")) continue;

        // ignoreFunctionTypeParameterNameValueShadow: skip parameters that belong to a
        // bodyless function (declare function / abstract method / TS function type).
        if (ignore_fn_type_param and bk == .parameter) {
            const fn_scope = scopes.nearestFunctionScope(scope_id);
            if (fn_scope.isValid()) {
                const fn_node = scopes.nodeId(fn_scope);
                if (fn_node != .none) {
                    switch (ctx.nodeTag(fn_node)) {
                        .method_def, .computed_method_def,
                        .getter_def, .setter_def,
                        .computed_getter_def, .computed_setter_def,
                        .constructor_def,
                        => {
                            const fn_node_data = ctx.nodeData(fn_node);
                            const method_d = ctx.extraData(MethodData, @intFromEnum(fn_node_data.rhs));
                            if (method_d.body == .none) continue;
                        },
                        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                        .ts_declare_function,
                        => {
                            const fn_node_data = ctx.nodeData(fn_node);
                            const fn_d = ctx.extraData(FnData, @intFromEnum(fn_node_data.lhs));
                            if (fn_d.body == .none) continue;
                        },
                        else => {},
                    }
                }
            }
        }

        // Skip names in the allow list.
        if (allow_list) |al| {
            var allowed = false;
            for (al) |item| {
                if (item == .string and std.mem.eql(u8, item.string, name)) {
                    allowed = true;
                    break;
                }
            }
            if (allowed) continue;
        }

        var reported = false;
        var ancestor = scopes.parent(scope_id);
        while (ancestor.isValid()) : (ancestor = scopes.parent(ancestor)) {
            if (scope_syms.get(ancestor)) |sym_map| {
                if (sym_map.get(name)) |outer_id| {
                    // Suppress reports when the outer symbol is declared inside a
                    // namespace/module body (declare global / declare namespace Foo).
                    // ESLint does not consider such declarations as real outer scope
                    // bindings for shadow purposes.
                    if (scopes.getFlags(ancestor).is_namespace_body) break;
                    // ignoreTypeValueShadow: skip when one side is a TS type decl
                    // and the other is a value decl (default: true).
                    if (ignore_type_value_shadow) {
                        const outer_bk = symbols.getBindingKind(outer_id);
                        const outer_is_ts = outer_bk == .type_decl or outer_bk == .interface_decl;
                        if (is_ts_type != outer_is_ts) break;
                        // If the outer is a type-only import (import type {x} or import {type x})
                        // and the inner is a value binding, suppress — ESLint treats type-only
                        // imports as type declarations for shadow purposes.
                        if (outer_bk == .type_import_binding and !is_ts_type) break;
                    }
                    // TDZ check: if the inner declaration appears before the outer
                    // declaration in source order, ESLint (with hoist != "all") skips
                    // the shadow report. Mirrors ESLint's `isInTdz` logic.
                    if (!hoist_all) {
                        const inner_node = symbols.getDeclNode(id);
                        const outer_node = symbols.getDeclNode(outer_id);
                        if (inner_node != .none and outer_node != .none) {
                            const inner_span = ctx.nodeSpan(inner_node);
                            const outer_span = ctx.nodeSpan(outer_node);
                            if (inner_span.end <= outer_span.start) {
                                // Inner ends before outer starts in source.
                                // Hoisted declarations (functions with hoist:"functions",
                                // types with hoist:"types") are still reported.
                                const outer_flags = symbols.getFlags(outer_id);
                                const outer_is_fn_decl = outer_flags.is_hoisted and outer_flags.is_function;
                                const outer_bk_tdz = symbols.getBindingKind(outer_id);
                                const outer_is_type_decl = outer_bk_tdz == .type_decl or
                                    outer_bk_tdz == .interface_decl;
                                if ((!hoist_functions or !outer_is_fn_decl) and
                                    (!hoist_types or !outer_is_type_decl))
                                {
                                    break; // In TDZ — do not report.
                                }
                            }
                        }
                    }
                    // ignoreOnInitialization: skip when the inner function is in the
                    // outer's initializer. Three patterns:
                    //   (a) inner.id < outer.id: init parsed before declare (const a = INIT)
                    //   (b) outer is .parameter: param declared before default (func(a = INIT))
                    //   (c) ancestor is non-var scope: for-in/of binding (for(a in INIT))
                    if (ignore_on_init) {
                        const inner_fn_scope = scopes.nearestFunctionScope(scope_id);
                        if (inner_fn_scope.isValid() and scopes.parent(inner_fn_scope) == ancestor) {
                            const outer_bk = symbols.getBindingKind(outer_id);
                            const inner_before_outer = id.toInt() < outer_id.toInt();
                            const outer_is_param = outer_bk == .parameter;
                            const ancestor_is_block = !scopes.getFlags(ancestor).is_var_scope;
                            if (inner_before_outer or outer_is_param or ancestor_is_block) {
                                break; // Callback parameter in outer's initializer — skip shadow
                            }
                        }
                    }
                    ctx.report(symbols.getDeclNode(id));
                    reported = true;
                    break;
                }
            }
        }
        // builtinGlobals: report if the name shadows a known ES built-in global.
        // Require depth > 1 because semantic analysis always creates a module scope
        // at depth 1; top-level (module-scope) declarations at depth 1 correspond to
        // global-scope in script mode and should not be reported.
        // builtinGlobals: flag when symbol shadows a built-in or configured global.
        // Flag at any depth (including global/module scope — builtins can be redeclared there too).
        if (!reported and builtin_globals) {
            if (isBuiltinGlobal(name) or ctx.globalIsExplicitlyEnabled(name)) {
                ctx.report(symbols.getDeclNode(id));
                reported = true;
            }
        }

        // fn-expression-name shadow: ESLint creates a virtual fn-expression-name scope
        // (parent of the body scope) for named fn/class expressions. In our model the
        // name binding lives in the body scope itself. Simulate the parent-scope lookup
        // by checking whether the current scope was opened by a named function expression
        // and the inner declaration uses the same name.
        if (!reported) {
            const scope_node = scopes.nodeId(scope_id);
            if (scope_node != .none) {
                switch (ctx.nodeTag(scope_node)) {
                    .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => {
                        const scope_data = ctx.nodeData(scope_node);
                        const fn_d = ctx.extraData(FnData, @intFromEnum(scope_data.lhs));
                        if (fn_d.name != .none) {
                            const expr_name = ctx.tokenText(ctx.nodeMainToken(fn_d.name));
                            if (std.mem.eql(u8, expr_name, name)) {
                                ctx.report(symbols.getDeclNode(id));
                            }
                        }
                    },
                    else => {},
                }
            }
        }
    }
}
