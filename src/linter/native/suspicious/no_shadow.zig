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

// Returns true for TS-only type-level binding kinds.
fn isTypeBinding(kind: BindingKind) bool {
    return switch (kind) {
        .type_import_binding, .type_decl, .interface_decl, .namespace_decl, .type_param => true,
        else => false,
    };
}

// Returns true for value-level binding kinds.
fn isValueBinding(kind: BindingKind) bool {
    return !isTypeBinding(kind) and kind != .implicit_global;
}

// Returns true when the INNER binding kind should be skipped unconditionally.
// fn_expr_name and class_expr_name are NOT unconditionally skipped — they may shadow
// outer bindings (e.g. (function a(){ (function a(){}) })). However they require the
// isFunctionNameInitException check to avoid false positives.
fn skipKind(kind: BindingKind) bool {
    return kind == .implicit_global;
}

/// ESLint's `isFunctionNameInitializerException`: returns true when the inner binding
/// (fn_expr_name or class_expr_name) is the function/class expression that is the
/// "unwrapped" initializer of the outer variable declaration or assignment pattern.
/// Example: `var x = fn || function x(){}` — the fn_expr_name `x` is in the init of
/// `var x`, so it doesn't count as a shadow.
fn isFunctionNameInitException(
    ctx: *const LintContext,
    syms: anytype,
    inner: SymbolId,
    inner_kind: BindingKind,
    outer_decl: NodeIndex,
) bool {
    if (inner_kind != .fn_expr_name and inner_kind != .class_expr_name) return false;
    if (outer_decl == .none) return false;

    // outer_decl is typically the Identifier node; walk up to find declarator/assignment_pattern.
    var outer_container = ctx.parentOf(outer_decl);
    if (outer_container == .none) outer_container = outer_decl;
    var init_node: NodeIndex = .none;
    const outer_tag = ctx.ast.nodeTag(outer_container);
    if (outer_tag == .declarator) {
        init_node = ctx.ast.nodeData(outer_container).rhs;
    } else if (outer_tag == .assignment_pattern) {
        init_node = ctx.ast.nodeData(outer_container).rhs;
    } else {
        // Try one more level up (e.g. Identifier → declarator → var_decl)
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

    // inner_decl is the identifier node (name of the fn/class expression).
    const inner_ident = syms.getDeclNode(inner);
    if (inner_ident == .none) return false;
    // The fn_expr or class_expr node is the parent of the name identifier.
    const fn_or_class = ctx.parentOf(inner_ident);
    if (fn_or_class == .none) return false;

    // Check that fn_or_class is inside init_node's source span.
    const init_span = ctx.nodeSpan(init_node);
    const fn_span = ctx.nodeSpan(fn_or_class);
    if (fn_span.start < init_span.start or fn_span.end > init_span.end) return false;

    // Check: unwrapExpression(fn_or_class) === init_node.
    // unwrapExpression walks up through LogicalExpression and non-test ConditionalExpression.
    return unwrapToInit(ctx, fn_or_class) == init_node;
}

fn unwrapToInit(ctx: *const LintContext, start: NodeIndex) NodeIndex {
    var cur = start;
    while (true) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return cur;
        const ptag = ctx.ast.nodeTag(parent);
        const is_logical = ptag == .logical_and or ptag == .logical_or or ptag == .nullish_coalesce;
        // ConditionalExpression: unwrap when cur is NOT the test (i.e. is consequent/alternate).
        const is_non_test_conditional = (ptag == .conditional) and
            (ctx.ast.nodeData(parent).lhs != cur); // lhs = test
        // Parentheses: always unwrap through grouping_expr.
        const is_grouping = ptag == .grouping_expr;
        if (is_logical or is_non_test_conditional or is_grouping) {
            cur = parent;
        } else {
            return cur;
        }
    }
}

// Returns true when outer binding is hoisted (function declarations).
fn isFunctionHoisted(kind: BindingKind) bool {
    return kind == .function_decl or kind == .function_decl_annex_b;
}

// Returns true when outer binding is a type-level hoisted declaration
// (TSTypeAliasDeclaration / TSInterfaceDeclaration) for hoist:"types" handling.
fn isTypeHoisted(kind: BindingKind) bool {
    return kind == .type_decl or kind == .interface_decl;
}

// For each symbol, search ancestor scopes for same-named symbol and report shadow.
pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const scopes = ctx.scopes();

    const hoist_str = ctx.getOptionString("hoist") orelse "functions";
    const builtin_globals = ctx.getOptionBool("builtinGlobals", false);
    const ignore_type_value_shadow = ctx.getOptionBool("ignoreTypeValueShadow", true);
    const ignore_fn_type_param = ctx.getOptionBool("ignoreFunctionTypeParameterNameValueShadow", true);

    const ignore_on_init = ctx.getOptionBool("ignoreOnInitialization", false);
    const hoist_all = std.mem.eql(u8, hoist_str, "all");
    // "types" and "functions-and-types" hoist type alias / interface declarations.
    const hoist_types_decls = std.mem.eql(u8, hoist_str, "types") or
        std.mem.eql(u8, hoist_str, "functions-and-types");
    // Only "functions" (default) and "functions-and-types" hoist function declarations.
    // Unknown values (e.g. "never") → false → no hoisting at all.
    const hoist_fn_decls = std.mem.eql(u8, hoist_str, "functions") or
        std.mem.eql(u8, hoist_str, "functions-and-types");

    const sym_count = syms.count();
    var inner_id: u32 = 0;
    while (inner_id < sym_count) : (inner_id += 1) {
        const inner = SymbolId.fromInt(inner_id);
        const inner_kind = syms.getBindingKind(inner);

        // Skip non-user bindings and expression-name bindings.
        if (skipKind(inner_kind)) continue;

        // Skip implicit globals (builtins).
        if (syms.isImplicitGlobal(inner)) continue;

        const inner_scope = syms.getScope(inner);
        if (!inner_scope.isValid()) continue;

        // Skip declarations in the global/module scope unless builtinGlobals is true.
        // When builtinGlobals:true, global/module-scope declarations can shadow builtin globals.
        // Exception: TypeScript declaration files (.d.ts) are ambient — all their declarations
        // are type-level and should never be flagged as shadowing globals.
        const inner_scope_kind = scopes.kind(inner_scope);
        if (inner_scope_kind == .global or inner_scope_kind == .module) {
            if (!builtin_globals) continue;
            if (ctx.language == .dts) continue;
        }

        // Skip declarations inside TS namespace/module bodies (declare namespace,
        // declare module, declare global) — those are isolated ambient contexts.
        // The namespace body is a block scope whose node's parent is the ts_namespace_decl.
        {
            var ns_scope = inner_scope;
            var in_ts_ambient_ns = false;
            while (ns_scope.isValid()) : (ns_scope = scopes.parent(ns_scope)) {
                const ns_nid = scopes.nodeId(ns_scope);
                if (ns_nid != .none) {
                    const ns_tag = ctx.nodeTag(ns_nid);
                    // Direct: scope node IS a namespace declaration.
                    if (ns_tag == .ts_namespace_decl or ns_tag == .ts_module_decl) {
                        in_ts_ambient_ns = true;
                        break;
                    }
                    // Indirect: scope node is a block whose parent is a namespace declaration.
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

        // Skip if in the allow list.
        if (ctx.optionArrayContains("allow", inner_name)) continue;

        const inner_decl = syms.getDeclNode(inner);
        if (inner_decl == .none) continue;
        const inner_start = ctx.nodeSpan(inner_decl).start;

        // Walk ancestor scopes looking for a symbol with the same name.
        var outer_scope_id = scopes.parent(inner_scope);
        var found_outer: ?SymbolId = null;
        var outer_is_global = false;

        while (outer_scope_id.isValid()) : (outer_scope_id = scopes.parent(outer_scope_id)) {
            _ = scopes.kind(outer_scope_id); // unused but kept for future outer_is_global via kind

            // Find a symbol in outer_scope_id with the same name.
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
                // For outer bindings: only skip implicit_global (handled above).
                // fn_expr_name and class_expr_name are valid outer bindings.
                if (candidate_kind == .implicit_global) continue;
                if (std.mem.eql(u8, syms.getName(candidate), inner_name)) {
                    found_outer = candidate;
                    outer_is_global = false; // user decl in outer scope, not a builtin global
                    break;
                }
            }

            if (found_outer != null) break;
        }

        // For MODULE-scope inner declarations with builtinGlobals:true, the outer scope walk
        // doesn't reach implicit globals (which live in the global scope, not above module scope
        // in our model). Check explicitly for a same-named implicit global.
        // NOTE: GLOBAL-scope declarations in script mode do NOT shadow builtins (they co-exist),
        // so we only do this for module scope, not global scope.
        if (found_outer == null and builtin_globals and inner_scope_kind == .module)
        {
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

        // --- isFunctionNameInitializerException ---
        // ESLint skips fn_expr_name/class_expr_name shadows when the inner function/class
        // expression IS the (unwrapped via LogicalExpr/ConditionalExpr) initializer of the
        // outer variable declaration. e.g. `var x = fn || function x(){}` — not a shadow.
        if (isFunctionNameInitException(ctx, syms, inner, inner_kind, outer_decl)) continue;

        // --- ignoreTypeValueShadow ---
        // When true, skip if exactly one of inner/outer is a type binding.
        if (ignore_type_value_shadow) {
            const inner_is_type = isTypeBinding(inner_kind);
            const outer_is_type = isTypeBinding(outer_kind);
            if (inner_is_type != outer_is_type) continue;
        }

        // --- ignoreFunctionTypeParameterNameValueShadow ---
        // When true, skip if the inner binding is a parameter in a TS type-level
        // function signature: TSFunctionType, TSConstructorType, TSDeclareFunction,
        // TSCallSignatureDeclaration, TSMethodSignature, TSConstructSignatureDeclaration.
        // These correspond to parameter names in function TYPES, not implementations.
        if (ignore_fn_type_param and inner_kind == .parameter) {
            const scope_node = scopes.nodeId(inner_scope);
            if (scope_node != .none) {
                const scope_tag = ctx.nodeTag(scope_node);
                if (scope_tag == .ts_function_type or scope_tag == .ts_constructor_type or
                    scope_tag == .ts_declare_function)
                {
                    continue;
                }
            }
            // Also skip parameters whose enclosing function scope node is a
            // ts_declare_function or is inside a class ambient context.
            const param_scope_node = scopes.nodeId(inner_scope);
            if (param_scope_node != .none) {
                const psn_tag = ctx.nodeTag(param_scope_node);
                if (psn_tag == .ts_declare_function or psn_tag == .class_decl or
                    psn_tag == .class_expr or psn_tag == .method_def or
                    psn_tag == .computed_method_def or psn_tag == .getter_def or
                    psn_tag == .setter_def or psn_tag == .constructor_def)
                {
                    continue;
                }
            }
        }

        // --- isExternalDeclarationMerging ---
        // Skip class/function/namespace declarations whose inner scope's parent is
        // global or module scope. These arise when a class/function is declared at
        // the top level: the parser emits the name twice — once in the outer scope
        // and once inside the class/function-expression-name scope. Without this
        // check the inner copy would falsely shadow the outer copy.
        if (inner_kind == .namespace_decl or inner_kind == .class_decl or
            inner_kind == .function_decl or inner_kind == .function_decl_annex_b)
        {
            const parent_of_inner = scopes.parent(inner_scope);
            if (parent_of_inner.isValid()) {
                const parent_kind = scopes.kind(parent_of_inner);
                if (parent_kind == .module or parent_kind == .global) continue;
            }
        }

        // --- hoist / isInTdz ---
        // ESLint's isInTdz semantics: when inner appears BEFORE outer in source,
        // check whether the inner variable is "in the TDZ" of the outer.
        //
        // ESLint suppresses (isInTdz=true → don't report) when inner comes before
        // outer AND outer is not a "hoisted" declaration for the current mode:
        //   hoist:"functions"          → outer is hoisted iff it is a FunctionDeclaration
        //   hoist:"all"                → outer is always "hoisted" → never suppress (hoist_all)
        //   hoist:"types"              → outer is hoisted iff it is TSTypeAliasDecl/TSInterfaceDecl
        //   hoist:"functions-and-types"→ outer is hoisted iff it is Function OR Type
        //
        // In other words: suppress when inner < outer AND outer is NOT hoisted.
        // Report when inner >= outer (normal order) OR outer is hoisted (ignore position).
        if (!hoist_all and outer_decl != .none) {
            const outer_start = ctx.nodeSpan(outer_decl).start;
            if (inner_start < outer_start) {
                // Inner comes before outer in source. Determine if outer is "hoisted"
                // for the current mode. If NOT hoisted → inner is in TDZ → skip report.
                const outer_hoisted = (hoist_fn_decls and isFunctionHoisted(outer_kind)) or
                    (hoist_types_decls and isTypeHoisted(outer_kind));
                if (!outer_hoisted) continue;
            }
        }

        // --- ignoreOnInitialization ---
        // Skip when the inner variable is declared inside the init expression of the
        // outer variable. Walk up from the outer's decl node to find the enclosing
        // declaration node (declarator, for-in/of, or parameter default) and check
        // if inner_decl falls within its full span.
        if (ignore_on_init and outer_decl != .none) {
            var enclosing = ctx.parentOf(outer_decl);
            var found_enclosing = false;
            while (enclosing != .none) {
                const tag = ctx.nodeTag(enclosing);
                // For for-in/of, the whole statement is the "enclosing init context".
                if (tag == .for_of_stmt or tag == .for_in_stmt) {
                    found_enclosing = true;
                    break;
                }
                // A declarator node: walk up through var/let/const decl to check for for-in/of.
                if (tag == .declarator) {
                    var p = ctx.parentOf(enclosing);
                    while (p != .none) {
                        const pt = ctx.nodeTag(p);
                        if (pt == .for_of_stmt or pt == .for_in_stmt) {
                            enclosing = p;
                            break;
                        }
                        if (pt == .var_decl or pt == .let_decl or pt == .const_decl) {
                            p = ctx.parentOf(p);
                            continue;
                        }
                        break;
                    }
                    found_enclosing = true;
                    break;
                }
                // Function parameters: walk to fn_decl to get the full span including defaults.
                if (tag == .fn_decl or tag == .async_fn_decl or tag == .fn_expr or
                    tag == .async_fn_expr or tag == .arrow_fn or tag == .async_arrow_fn or
                    tag == .generator_fn_decl or tag == .generator_fn_expr or
                    tag == .method_def or tag == .computed_method_def)
                {
                    found_enclosing = true;
                    break;
                }
                // Continue through binding pattern containers.
                if (tag == .assignment_pattern or
                    tag == .array_pattern or tag == .object_pattern or
                    tag == .rest_element or tag == .property or
                    tag == .shorthand_property or tag == .computed_property or
                    tag == .identifier or tag == .ts_type_annotation or
                    tag == .ts_parameter_property)
                {
                    enclosing = ctx.parentOf(enclosing);
                    continue;
                }
                break;
            }
            if (found_enclosing and enclosing != .none) {
                const enclosing_span = ctx.nodeSpan(enclosing);
                const outer_decl_start = ctx.nodeSpan(outer_decl).start;
                if (inner_start > outer_decl_start and inner_start < enclosing_span.end) {
                    continue;
                }
            }
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
