const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const symbol_mod = @import("es_parser").symbol;
const scope_mod = @import("es_parser").scope;
const BindingKind = symbol_mod.BindingKind;
const ScopeId = scope_mod.ScopeId;
const ScopeKind = scope_mod.ScopeKind;
const SymbolId = symbol_mod.SymbolId;

pub const meta = RuleMeta{
    .name = "no-shadow",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow variable declarations from shadowing variables declared in the outer scope",
};

pub const relevant_tags = [_]Node.Tag{};
pub const needs_semantic = true;

const Messages = enum {
    noShadow,
    noShadowGlobal,
};

fn isTypeBinding(kind: BindingKind) bool {
    return switch (kind) {
        .type_import_binding, .type_decl, .interface_decl, .namespace_decl, .type_param => true,
        else => false,
    };
}

fn skipKind(kind: BindingKind) bool {
    return kind == .implicit_global;
}

/// Skip a class_expr_name inner binding when the outer binding is a class_decl
/// pointing to the SAME class expression. This handles a semantic-analyzer artefact
/// where class expressions emit both a class_decl in the outer scope AND a
/// class_expr_name in the class's own scope; the latter must not shadow the former.
fn isClassExprNameDuplicate(
    ctx: *const LintContext,
    syms: anytype,
    inner: SymbolId,
    inner_kind: BindingKind,
    outer_kind: BindingKind,
) bool {
    if (inner_kind != .class_expr_name) return false;
    if (outer_kind != .class_decl and outer_kind != .class_expr_name) return false;
    // Both inner and outer must share the same class node.
    const inner_decl = syms.getDeclNode(inner);
    if (inner_decl == .none) return false;
    // inner_decl is the name identifier; its parent is the class expression.
    const inner_class = ctx.parentOf(inner_decl);
    if (inner_class == .none) return false;
    return true; // same class expression produces both bindings → skip
}

/// Returns true when `tag` is a function EXPRESSION node (not a declaration).
/// Matches ESLint's FUNC_EXPR_NODE_TYPES = { ArrowFunctionExpression, FunctionExpression }.
fn isFunctionExprTag(tag: Node.Tag) bool {
    return switch (tag) {
        .arrow_fn, .async_arrow_fn,
        .fn_expr, .async_fn_expr,
        .generator_fn_expr, .async_generator_fn_expr,
        => true,
        else => false,
    };
}

/// ESLint `getOuterScope`: skip function-expression-name scopes.
/// In our model we don't have fn-expr-name scopes, so parent = outer.
fn getOuterScope(scopes: anytype, scope_id: ScopeId) ScopeId {
    return scopes.parent(scope_id);
}

/// Find the nearest ancestor CallExpression or NewExpression of `start_node`.
/// Returns .none when no such ancestor exists within sentinel boundaries.
fn findCallAncestor(ctx: *const LintContext, start_node: NodeIndex) NodeIndex {
    var cur = start_node;
    var limit: u32 = 32;
    while (cur != .none and limit > 0) : (limit -= 1) {
        const tag = ctx.ast.nodeTag(cur);
        switch (tag) {
            .call_expr, .optional_call_expr, .new_expr => return cur,
            // Sentinel: stop at function/class/import/catch boundaries.
            .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .class_decl, .class_expr,
            .import_decl, .catch_clause,
            => return .none,
            else => {},
        }
        cur = ctx.parentOf(cur);
    }
    return .none;
}

/// ESLint `isInitPatternNode`: returns true when the inner binding is inside
/// a function expression that is DIRECTLY passed to a call in the initializer
/// of the outer (shadowed) variable.
///
/// The canonical pattern: `const x = fn((x) => ...)` — param `x` of the arrow
/// is directly inside `fn(...)` which IS the init of `const x`.
///
/// Crucially: if the function expression is nested (e.g. `const x = () => {
/// foo(x => x) }`), `getOuterScope(variableScope) !== outer.scope` and this
/// returns false, so the shadow IS reported.
fn isInitPatternNode(
    ctx: *const LintContext,
    scopes: anytype,
    syms: anytype,
    inner_scope: ScopeId,
    outer: SymbolId,
    outer_scope: ScopeId,
) bool {
    // Step 1: inner variable's nearest var-scope must be a function EXPRESSION scope.
    // For parameters: syms.getScope(inner) IS the function scope.
    // For let/const inside arrow: syms.getScope(inner) is already the arrow scope.
    const var_scope = scopes.nearestVarScope(inner_scope);
    if (!var_scope.isValid()) return false;

    const fn_node = scopes.nodeId(var_scope);
    if (fn_node == .none) return false;

    // Step 2: the scope's block must be a function EXPRESSION (not declaration).
    if (!isFunctionExprTag(ctx.ast.nodeTag(fn_node))) return false;

    // Step 3: getOuterScope(var_scope) must equal the outer variable's scope.
    const fn_outer = getOuterScope(scopes, var_scope);
    if (fn_outer != outer_scope) return false;

    // Step 4: find the nearest CallExpression ancestor of fn_node's parent.
    const fn_parent = ctx.parentOf(fn_node);
    if (fn_parent == .none) return false;
    const call_node = findCallAncestor(ctx, fn_parent);
    if (call_node == .none) return false;
    const call_end = ctx.nodeSpan(call_node).end;

    // Step 5: walk from outer_decl up through VariableDeclarator/AssignmentPattern.
    // If call_end falls within the init/right expression, it IS the init pattern.
    const outer_decl = syms.getDeclNode(outer);
    if (outer_decl == .none) return false;

    var node = ctx.parentOf(outer_decl);
    var limit: u32 = 16;
    while (node != .none and limit > 0) : (limit -= 1) {
        const tag = ctx.ast.nodeTag(node);
        switch (tag) {
            .declarator => {
                const init_node = ctx.ast.nodeData(node).rhs;
                if (init_node != .none) {
                    const isp = ctx.nodeSpan(init_node);
                    if (call_end > isp.start and call_end <= isp.end) return true;
                }
                // Also check for-in/of right expression.
                const var_decl = ctx.parentOf(node);
                if (var_decl != .none) {
                    const for_stmt = ctx.parentOf(var_decl);
                    if (for_stmt != .none) {
                        const ft = ctx.ast.nodeTag(for_stmt);
                        if (ft == .for_in_stmt or ft == .for_of_stmt or ft == .for_await_of_stmt) {
                            const fd = ctx.ast.extraData(ast.ForInOfData, @intFromEnum(ctx.ast.nodeData(for_stmt).lhs));
                            if (fd.expr != .none) {
                                const esp = ctx.nodeSpan(fd.expr);
                                if (call_end > esp.start and call_end <= esp.end) return true;
                            }
                        }
                    }
                }
                return false;
            },
            .assignment_pattern => {
                const rhs = ctx.ast.nodeData(node).rhs;
                if (rhs != .none) {
                    const rsp = ctx.nodeSpan(rhs);
                    if (call_end > rsp.start and call_end <= rsp.end) return true;
                }
                node = ctx.parentOf(node);
                continue;
            },
            // Sentinels: stop walking.
            .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
            .arrow_fn, .async_arrow_fn,
            .class_decl, .class_expr,
            .import_decl, .catch_clause,
            => return false,
            else => {
                node = ctx.parentOf(node);
                continue;
            },
        }
    }
    return false;
}

/// ESLint `isFunctionNameInitializerException`.
fn isFunctionNameInitException(
    ctx: *const LintContext,
    syms: anytype,
    inner: SymbolId,
    inner_kind: BindingKind,
    outer_decl: NodeIndex,
) bool {
    if (inner_kind != .fn_expr_name and inner_kind != .class_expr_name) return false;
    if (outer_decl == .none) return false;

    var outer_container = ctx.parentOf(outer_decl);
    if (outer_container == .none) outer_container = outer_decl;
    var init_node: NodeIndex = .none;
    const outer_tag = ctx.ast.nodeTag(outer_container);
    if (outer_tag == .declarator) {
        init_node = ctx.ast.nodeData(outer_container).rhs;
    } else if (outer_tag == .assignment_pattern) {
        init_node = ctx.ast.nodeData(outer_container).rhs;
    } else {
        const outer_container2 = ctx.parentOf(outer_container);
        if (outer_container2 != .none) {
            const t2 = ctx.ast.nodeTag(outer_container2);
            if (t2 == .declarator) {
                init_node = ctx.ast.nodeData(outer_container2).rhs;
            }
        }
        if (init_node == .none) return false;
    }
    if (init_node == .none) return false;

    const inner_ident = syms.getDeclNode(inner);
    if (inner_ident == .none) return false;
    const fn_or_class = ctx.parentOf(inner_ident);
    if (fn_or_class == .none) return false;

    const init_span = ctx.nodeSpan(init_node);
    const fn_span = ctx.nodeSpan(fn_or_class);
    if (fn_span.start < init_span.start or fn_span.end > init_span.end) return false;

    return unwrapToInit(ctx, fn_or_class) == init_node;
}

fn unwrapToInit(ctx: *const LintContext, start: NodeIndex) NodeIndex {
    var cur = start;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return cur;
        const ptag = ctx.ast.nodeTag(parent);
        const is_logical = ptag == .logical_and or ptag == .logical_or or ptag == .nullish_coalesce;
        const is_non_test_conditional = (ptag == .conditional) and
            (ctx.ast.nodeData(parent).lhs != cur);
        const is_grouping = ptag == .grouping_expr;
        if (is_logical or is_non_test_conditional or is_grouping) {
            cur = parent;
        } else {
            return cur;
        }
    }
}

fn isFunctionHoisted(kind: BindingKind) bool {
    return kind == .function_decl or kind == .function_decl_annex_b;
}

fn isTypeHoisted(kind: BindingKind) bool {
    return kind == .type_decl or kind == .interface_decl;
}

/// Returns true when `inner_scope` is inside a TS type-level scope:
/// ts_function_type, ts_constructor_type, ts_declare_function, ts_interface,
/// ts_method_signature, ts_call_signature, ts_construct_signature.
/// Used for `ignoreFunctionTypeParameterNameValueShadow`.
fn isInTypeLevelFunctionScope(ctx: *const LintContext, scopes: anytype, inner_scope: ScopeId) bool {
    // Walk up scope chain looking for the enclosing function scope node.
    var s = inner_scope;
    var limit: u32 = 16;
    while (s.isValid() and limit > 0) : (limit -= 1) {
        const k = scopes.kind(s);
        if (k == .function or k == .arrow_function) {
            const sn = scopes.nodeId(s);
            if (sn != .none) {
                return isTypeLevelFunctionNode(ctx.ast.nodeTag(sn));
            }
            return false;
        }
        if (k == .module or k == .global) return false;
        s = scopes.parent(s);
    }
    return false;
}

fn isTypeLevelFunctionNode(tag: Node.Tag) bool {
    return switch (tag) {
        .ts_function_type, .ts_constructor_type, .ts_declare_function,
        .ts_interface_decl, .ts_method_signature, .ts_call_signature,
        .ts_construct_signature,
        => true,
        else => false,
    };
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const scopes = ctx.scopes();

    const hoist_str = ctx.getOptionString("hoist") orelse "functions";
    const builtin_globals = ctx.getOptionBool("builtinGlobals", false);
    const ignore_type_value_shadow = ctx.getOptionBool("ignoreTypeValueShadow", true);
    const ignore_fn_type_param = ctx.getOptionBool("ignoreFunctionTypeParameterNameValueShadow", true);
    const ignore_on_init = ctx.getOptionBool("ignoreOnInitialization", false);

    const hoist_all = std.mem.eql(u8, hoist_str, "all");
    const hoist_types_decls = std.mem.eql(u8, hoist_str, "types") or
        std.mem.eql(u8, hoist_str, "functions-and-types");
    const hoist_fn_decls = std.mem.eql(u8, hoist_str, "functions") or
        std.mem.eql(u8, hoist_str, "functions-and-types");

    const sym_count = syms.count();
    var inner_id: u32 = 0;
    while (inner_id < sym_count) : (inner_id += 1) {
        const inner = SymbolId.fromInt(inner_id);
        const inner_kind = syms.getBindingKind(inner);

        if (skipKind(inner_kind)) continue;
        if (syms.isImplicitGlobal(inner)) continue;

        const inner_scope = syms.getScope(inner);
        if (!inner_scope.isValid()) continue;

        const inner_scope_kind = scopes.kind(inner_scope);
        if (inner_scope_kind == .global or inner_scope_kind == .module) {
            if (!builtin_globals) continue;
            if (ctx.language == .dts) continue;
        }

        // Skip declarations inside TS namespace/module bodies.
        {
            var ns_scope = inner_scope;
            var in_ts_ambient_ns = false;
            while (ns_scope.isValid()) : (ns_scope = scopes.parent(ns_scope)) {
                const ns_nid = scopes.nodeId(ns_scope);
                if (ns_nid != .none) {
                    const ns_tag = ctx.nodeTag(ns_nid);
                    if (ns_tag == .ts_namespace_decl or ns_tag == .ts_module_decl) {
                        in_ts_ambient_ns = true;
                        break;
                    }
                    const block_parent = ctx.parentOf(ns_nid);
                    if (block_parent != .none) {
                        const bp_tag = ctx.nodeTag(block_parent);
                        if (bp_tag == .ts_namespace_decl or bp_tag == .ts_module_decl) {
                            in_ts_ambient_ns = true;
                            break;
                        }
                    }
                }
                const sk = scopes.kind(ns_scope);
                if (sk == .global or sk == .module) break;
            }
            if (in_ts_ambient_ns) continue;
        }

        const inner_name = syms.getName(inner);
        if (inner_name.len == 0) continue;

        if (ctx.optionArrayContains("allow", inner_name)) continue;

        const inner_decl = syms.getDeclNode(inner);
        if (inner_decl == .none) continue;
        const inner_start = ctx.nodeSpan(inner_decl).start;

        // Walk ancestor scopes looking for a symbol with the same name.
        var outer_scope_id = scopes.parent(inner_scope);
        var found_outer: ?SymbolId = null;
        var outer_is_global = false;

        while (outer_scope_id.isValid()) : (outer_scope_id = scopes.parent(outer_scope_id)) {
            var j: u32 = 0;
            while (j < sym_count) : (j += 1) {
                const candidate = SymbolId.fromInt(j);
                if (syms.getScope(candidate) != outer_scope_id) continue;
                if (syms.isImplicitGlobal(candidate)) {
                    if (!builtin_globals) continue;
                    if (std.mem.eql(u8, syms.getName(candidate), inner_name)) {
                        found_outer = candidate;
                        outer_is_global = true;
                        break;
                    }
                    continue;
                }
                const candidate_kind = syms.getBindingKind(candidate);
                if (candidate_kind == .implicit_global) continue;
                if (std.mem.eql(u8, syms.getName(candidate), inner_name)) {
                    found_outer = candidate;
                    outer_is_global = false;
                    break;
                }
            }
            if (found_outer != null) break;
        }

        // For MODULE-scope inner declarations with builtinGlobals:true, also check
        // implicit globals. Global-scope declarations in script mode do NOT shadow
        // builtins (they co-exist in the global object), so we only handle module scope.
        if (found_outer == null and builtin_globals and inner_scope_kind == .module) {
            var j: u32 = 0;
            while (j < sym_count) : (j += 1) {
                const candidate = SymbolId.fromInt(j);
                if (!syms.isImplicitGlobal(candidate)) continue;
                if (std.mem.eql(u8, syms.getName(candidate), inner_name)) {
                    found_outer = candidate;
                    outer_is_global = true;
                    break;
                }
            }
        }

        const outer = found_outer orelse continue;
        const outer_kind = syms.getBindingKind(outer);
        const outer_decl = syms.getDeclNode(outer);
        if (outer_decl == .none and !outer_is_global) continue;

        // Skip class_expr_name that shadows the same class's outer class_decl binding.
        if (isClassExprNameDuplicate(ctx, syms, inner, inner_kind, outer_kind)) continue;

        // isFunctionNameInitializerException
        if (isFunctionNameInitException(ctx, syms, inner, inner_kind, outer_decl)) continue;

        // ignoreTypeValueShadow
        if (ignore_type_value_shadow) {
            const inner_is_type = isTypeBinding(inner_kind);
            const outer_is_type = isTypeBinding(outer_kind);
            if (inner_is_type != outer_is_type) continue;
        }

        // ignoreFunctionTypeParameterNameValueShadow
        // Skip when the inner binding is a parameter in a TS type-level function
        // signature (TSFunctionType, TSConstructorType, TSDeclareFunction,
        // TSCallSignatureDeclaration, TSMethodSignature, TSConstructSignatureDeclaration).
        if (ignore_fn_type_param and inner_kind == .parameter) {
            if (isInTypeLevelFunctionScope(ctx, scopes, inner_scope)) continue;
        }

        // isExternalDeclarationMerging
        if (inner_kind == .namespace_decl or inner_kind == .class_decl or
            inner_kind == .function_decl or inner_kind == .function_decl_annex_b)
        {
            const parent_of_inner = scopes.parent(inner_scope);
            if (parent_of_inner.isValid()) {
                const parent_kind = scopes.kind(parent_of_inner);
                if (parent_kind == .module or parent_kind == .global) continue;
            }
        }

        // hoist / isInTdz
        if (!hoist_all and outer_decl != .none) {
            const outer_start = ctx.nodeSpan(outer_decl).start;
            if (inner_start < outer_start) {
                const outer_hoisted = (hoist_fn_decls and isFunctionHoisted(outer_kind)) or
                    (hoist_types_decls and isTypeHoisted(outer_kind));
                if (!outer_hoisted) continue;
            }
        }

        // ignoreOnInitialization (ESLint's isInitPatternNode)
        if (ignore_on_init) {
            const outer_scope = syms.getScope(outer);
            if (isInitPatternNode(ctx, scopes, syms, inner_scope, outer, outer_scope)) continue;
        }

        // Report.
        if (outer_is_global) {
            ctx.reportWithMessageId(inner_decl, "noShadowGlobal");
        } else {
            ctx.reportWithMessageId(inner_decl, "noShadow");
        }
    }
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}
