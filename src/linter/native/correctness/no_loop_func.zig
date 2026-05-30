const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;
const symbol_mod = @import("es_parser").symbol;
const SymbolId = symbol_mod.SymbolId;
const BindingKind = symbol_mod.BindingKind;
const scope_mod = @import("es_parser").scope;
const ScopeId = scope_mod.ScopeId;

pub const meta = RuleMeta{
    .name = "no-loop-func",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow function declarations that contain unsafe references inside loop statements",
};

pub const relevant_tags = [_]Node.Tag{
    .fn_expr,
    .async_fn_expr,
    .generator_fn_expr,
    .async_generator_fn_expr,
    .fn_decl,
    .async_fn_decl,
    .generator_fn_decl,
    .async_generator_fn_decl,
    .arrow_fn,
    .async_arrow_fn,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    // Only skip sync non-generator IIFEs (async/generator IIFEs are NOT skipped per rule spec)
    const is_async = tag == .async_fn_expr or tag == .async_fn_decl or
        tag == .async_generator_fn_expr or tag == .async_generator_fn_decl or
        tag == .async_arrow_fn;
    const is_generator = tag == .generator_fn_expr or tag == .generator_fn_decl or
        tag == .async_generator_fn_expr or tag == .async_generator_fn_decl;

    if (!is_async and !is_generator and isIIFE(node, ctx)) return;

    const loop = getContainingLoop(node, ctx) orelse return;

    const fn_scope = ctx.smallestEnclosingScope(node);
    if (fn_scope == .none) return;

    const scopes = ctx.scopes();
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const loop_span = ctx.nodeSpan(loop);

    const ref_count = refs.count();
    var has_unsafe = false;

    var ri: u32 = 0;
    while (ri < ref_count) : (ri += 1) {
        const ref_id = ReferenceId.fromInt(ri);
        const ref_scope = refs.getScope(ref_id);

        // Skip if scope is not in this function's subtree
        if (!scopes.isAncestor(ref_scope, fn_scope)) continue;

        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;

        // Skip if symbol is declared inside this function (not a through reference)
        const sym_scope = symbols.getScope(sym_id);
        if (scopes.isAncestor(sym_scope, fn_scope)) continue;

        if (!isSafeSymbol(sym_id, loop, loop_span, fn_scope, scopes, symbols, refs, ctx)) {
            has_unsafe = true;
            break;
        }
    }

    if (has_unsafe) {
        ctx.reportWithMessageId(node, "unsafeRefs");
    }
}

fn isSafeSymbol(
    sym_id: SymbolId,
    loop: NodeIndex,
    loop_span: @import("es_parser").span.Span,
    fn_scope: ScopeId,
    scopes: *const scope_mod.ScopeTree,
    symbols: *const symbol_mod.SymbolTable,
    refs: *const ref_mod.ReferenceTable,
    ctx: *const LintContext,
) bool {
    _ = fn_scope;
    const kind = symbols.getBindingKind(sym_id);

    // Always safe: const, import bindings, type declarations
    switch (kind) {
        .@"const",
        .import_binding,
        .type_import_binding,
        .type_decl,
        .interface_decl,
        .enum_decl,
        .namespace_decl,
        .type_param,
        .fn_expr_name,
        .class_expr_name,
        => return true,
        else => {},
    }

    // let declared inside the loop body → safe (block-scoped per iteration)
    if (kind == .let) {
        const decl_node = symbols.getDeclNode(sym_id);
        if (decl_node != .none) {
            const decl_span = ctx.nodeSpan(decl_node);
            if (decl_span.start > loop_span.start and decl_span.end <= loop_span.end) {
                return true;
            }
        }
    }

    // Compute border: start of outermost containing loop that starts after the declaration
    const border = computeBorder(sym_id, loop, kind, symbols, ctx);

    // Get the symbol's nearest var scope
    const sym_var_scope = scopes.nearestVarScope(symbols.getScope(sym_id));

    // Check all write references to this symbol
    const range = symbols.getRefRange(sym_id);
    const sym_refs = ctx.semantic.ref_by_sym[range.start..range.end];

    for (sym_refs) |rid| {
        const ref_kind = refs.getKind(rid);
        if (!ref_kind.isWrite()) continue;

        const ref_scope = refs.getScope(rid);
        const ref_var_scope = scopes.nearestVarScope(ref_scope);

        // Write in a different variable scope (e.g. inside a nested function) → unsafe
        if (ref_var_scope != sym_var_scope) return false;

        // Write after the border in the same scope → unsafe
        const ref_node = refs.getNode(rid);
        if (ref_node != .none) {
            const ref_span = ctx.nodeSpan(ref_node);
            if (ref_span.start >= border) return false;
        }
    }

    // Special case: var declared as a for-in/of binding has an implicit per-iteration write.
    // Ez doesn't emit a write reference for this pattern, so check the declaration's parent chain.
    if (isForInOfBindingVar(sym_id, border, symbols, ctx)) return false;

    return true;
}

fn isForInOfBindingVar(
    sym_id: SymbolId,
    border: u32,
    symbols: *const symbol_mod.SymbolTable,
    ctx: *const LintContext,
) bool {
    const decl_node = symbols.getDeclNode(sym_id);
    if (decl_node == .none) return false;

    // Walk: identifier → declarator → var_decl → for_in_stmt/for_of_stmt/for_await_of_stmt
    const declarator = ctx.parentOf(decl_node);
    if (declarator == .none) return false;
    if (ctx.nodeTag(declarator) != .declarator) return false;

    const var_decl = ctx.parentOf(declarator);
    if (var_decl == .none) return false;
    const vd_tag = ctx.nodeTag(var_decl);
    if (vd_tag != .var_decl) return false;

    const for_node = ctx.parentOf(var_decl);
    if (for_node == .none) return false;
    const for_tag = ctx.nodeTag(for_node);
    if (for_tag != .for_in_stmt and for_tag != .for_of_stmt and for_tag != .for_await_of_stmt) return false;

    // The for-in/of loop must start at or after the border
    const for_span = ctx.nodeSpan(for_node);
    return for_span.start >= border;
}

fn computeBorder(
    sym_id: SymbolId,
    loop: NodeIndex,
    kind: BindingKind,
    symbols: *const symbol_mod.SymbolTable,
    ctx: *const LintContext,
) u32 {
    // For let variables, find the outermost loop that starts after the declaration
    const excluded_end: u32 = if (kind == .let) blk: {
        const decl_node = symbols.getDeclNode(sym_id);
        if (decl_node == .none) break :blk 0;
        break :blk ctx.nodeSpan(decl_node).end;
    } else 0;

    // Find the outermost loop starting at or after excluded_end that still contains our loop
    var retv = loop;
    var cur: ?NodeIndex = loop;
    while (cur) |c| {
        const span = ctx.nodeSpan(c);
        if (span.start < excluded_end) break;
        retv = c;
        cur = getContainingLoopForNode(c, ctx);
    }
    return ctx.nodeSpan(retv).start;
}

/// Find the innermost loop directly containing `node` (not crossing function boundaries).
/// Returns null if no loop contains this node.
fn getContainingLoop(node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var cur = node;
    while (ctx.parentOf(cur) != .none) {
        const parent = ctx.parentOf(cur);
        const tag = ctx.nodeTag(parent);

        switch (tag) {
            .while_stmt, .do_while_stmt => return parent,

            .for_stmt => {
                // init is outside the loop; condition/update/body are inside
                const for_data = ctx.extraData(ast.ForData, @intFromEnum(ctx.nodeData(parent).lhs));
                if (for_data.init != .none and cur == for_data.init) {
                    // We're in the init — this for_stmt doesn't contain us, but keep walking up
                    cur = parent;
                    continue;
                }
                return parent;
            },

            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                // right/expr (the iterable) is outside the loop; binding/body are inside
                const fo_data = ctx.extraData(ast.ForInOfData, @intFromEnum(ctx.nodeData(parent).lhs));
                if (fo_data.expr != .none and cur == fo_data.expr) {
                    // We're in the iterable — this for-in/of doesn't contain us, but keep walking up
                    cur = parent;
                    continue;
                }
                return parent;
            },

            // Function boundary: stop traversal (don't cross into outer functions)
            .fn_expr,
            .async_fn_expr,
            .generator_fn_expr,
            .async_generator_fn_expr,
            .fn_decl,
            .async_fn_decl,
            .generator_fn_decl,
            .async_generator_fn_decl,
            .arrow_fn,
            .async_arrow_fn,
            => return null,

            else => {},
        }

        cur = parent;
    }
    return null;
}

/// Find the loop that directly contains `loop_node`, stopping at function boundaries.
/// Used for computing the outermost loop (border).
fn getContainingLoopForNode(loop_node: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var cur = loop_node;
    while (ctx.parentOf(cur) != .none) {
        const parent = ctx.parentOf(cur);
        const tag = ctx.nodeTag(parent);

        switch (tag) {
            .while_stmt, .do_while_stmt => return parent,

            .for_stmt => {
                const for_data = ctx.extraData(ast.ForData, @intFromEnum(ctx.nodeData(parent).lhs));
                if (for_data.init != .none and cur == for_data.init) return null;
                return parent;
            },

            .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                const fo_data = ctx.extraData(ast.ForInOfData, @intFromEnum(ctx.nodeData(parent).lhs));
                if (fo_data.expr != .none and cur == fo_data.expr) return null;
                return parent;
            },

            .fn_expr,
            .async_fn_expr,
            .generator_fn_expr,
            .async_generator_fn_expr,
            .fn_decl,
            .async_fn_decl,
            .generator_fn_decl,
            .async_generator_fn_decl,
            .arrow_fn,
            .async_arrow_fn,
            => return null,

            else => {},
        }

        cur = parent;
    }
    return null;
}

/// Check if a function node is an IIFE (immediately invoked function expression).
/// Handles grouping_expr wrappers: `(function() {})()` or `(() => {})()`.
fn isIIFE(func: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(func);
    if (parent == .none) return false;
    const ptag = ctx.nodeTag(parent);
    if (ptag == .grouping_expr) {
        const gparent = ctx.parentOf(parent);
        if (gparent == .none) return false;
        const gtag = ctx.nodeTag(gparent);
        if (gtag == .call_expr or gtag == .optional_call_expr) {
            return ctx.nodeData(gparent).lhs == parent;
        }
        return false;
    }
    if (ptag == .call_expr or ptag == .optional_call_expr) {
        return ctx.nodeData(parent).lhs == func;
    }
    return false;
}
