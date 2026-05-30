// HAND-WRITTEN.
// Rule: no-use-before-define
//
// Flags identifier references that appear textually before the declaration
// of the variable/function/class they resolve to.  Mirrors ESLint's
// no-use-before-define rule including all TS extensions (enums, typedefs,
// ignoreTypeReferences, allowNamedExports).
//
// Algorithm:
//  1. Iterate every reference in the file.
//  2. For each resolved reference (not write_init, not implicit_global):
//     a. Apply shouldCheck filters (options, TS modifiers, decorator guard).
//     b. Flag if ref.end < decl.end  (textually before the declaration), OR
//        isEvaluatedDuringInitialization(ref) is true.
//
// Mirrors: tests/conformance/eslint/lib/rules/no-use-before-define.js

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;
const symbol_mod = parser.symbol;
const scope_mod = parser.scope;
const reference_mod = parser.reference;
const BindingKind = symbol_mod.BindingKind;
const ScopeId = scope_mod.ScopeId;
const ScopeKind = scope_mod.ScopeKind;
const SymbolId = symbol_mod.SymbolId;
const ReferenceId = reference_mod.ReferenceId;
const ReferenceKind = reference_mod.ReferenceKind;

pub const meta = RuleMeta{
    .name = "no-use-before-define",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow the use of variables before they are defined.",
};

pub const relevant_tags = [_]Node.Tag{};
pub const needs_semantic = true;

// No-op node visitor — all logic is in runOnSymbols.
pub fn run(_: NodeIndex, _: *const LintContext) void {}

// ── Options ────────────────────────────────────────────────────────────────

const Options = struct {
    functions: bool = true,
    classes: bool = true,
    variables: bool = true,
    allow_named_exports: bool = false,
    enums: bool = true,
    typedefs: bool = true,
    ignore_type_refs: bool = true,
};

fn parseOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    // String form: "nofunc"
    if (ctx.optionEqualsString("nofunc")) {
        opts.functions = false;
        return opts;
    }
    opts.functions = ctx.getOptionBool("functions", true);
    opts.classes = ctx.getOptionBool("classes", true);
    opts.variables = ctx.getOptionBool("variables", true);
    opts.allow_named_exports = ctx.getOptionBool("allowNamedExports", false);
    opts.enums = ctx.getOptionBool("enums", true);
    opts.typedefs = ctx.getOptionBool("typedefs", true);
    opts.ignore_type_refs = ctx.getOptionBool("ignoreTypeReferences", true);
    return opts;
}

// ── Sentinel types (stop walking up the parent chain) ─────────────────────

fn isSentinelTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .fn_expr,
        .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .class_decl, .class_expr,
        .import_decl, .export_named, .export_named_from,
        => true,
        else => false,
    };
}

// ── isFromSeparateExecutionContext ─────────────────────────────────────────
//
// Returns true when the reference is in a different execution context from
// the declaration.  Class static initializers and static blocks are treated
// as part of the parent execution context (they run during class definition).

fn isStaticClassFieldInitScope(ctx: *const LintContext, scope_id: ScopeId) bool {
    // The scope's node_id is the VALUE expression of the PropertyDefinition.
    const scopes = ctx.scopes();
    if (scopes.kind(scope_id) != .class_field_initializer) return false;
    const val_node = scopes.nodeId(scope_id);
    if (val_node == .none) return false;
    const prop_def = ctx.parentOf(val_node);
    if (prop_def == .none) return false;
    return ctx.classMemberIsStatic(prop_def);
}

fn isFromSeparateExecutionContext(ctx: *const LintContext, ref_scope: ScopeId, sym_scope: ScopeId) bool {
    const scopes = ctx.scopes();
    var cur_var = scopes.nearestVarScope(ref_scope);
    const def_var = scopes.nearestVarScope(sym_scope);
    while (cur_var != def_var) {
        if (!cur_var.isValid()) return true;
        const k = scopes.kind(cur_var);
        const is_static_init = (k == .static_block) or isStaticClassFieldInitScope(ctx, cur_var);
        if (!is_static_init) return true;
        const upper = scopes.parent(cur_var);
        if (!upper.isValid()) return true;
        cur_var = scopes.nearestVarScope(upper);
    }
    return false;
}

// ── isInClassStaticInitializerRange ───────────────────────────────────────
//
// Returns true when `location` falls inside a static field initializer or
// static block of the given class node.

fn isInClassStaticInitRange(ctx: *const LintContext, class_node: NodeIndex, loc: u32) bool {
    const cd = ctx.ast.extraData(ast.ClassData, @intFromEnum(ctx.ast.nodeData(class_node).lhs));
    const body = cd.body;
    if (body == .none or ctx.ast.nodeTag(body) != .class_body) return false;
    const bd = ctx.ast.nodeData(body);
    const members = ctx.ast.extraSlice(.{
        .start = @intFromEnum(bd.lhs),
        .end = @intFromEnum(bd.rhs),
    });
    for (members) |mi| {
        const member: NodeIndex = @enumFromInt(mi);
        const tag = ctx.ast.nodeTag(member);
        if (tag == .static_block) {
            const sp = ctx.nodeSpan(member);
            if (loc > sp.start and loc <= sp.end) return true;
            continue;
        }
        if (tag == .property_def or tag == .computed_property_def) {
            if (!ctx.classMemberIsStatic(member)) continue;
            const d = ctx.ast.nodeData(member);
            const pd = ctx.ast.extraData(ast.PropertyData, @intFromEnum(d.rhs));
            if (pd.value == .none) continue;
            const sp = ctx.nodeSpan(pd.value);
            if (loc > sp.start and loc <= sp.end) return true;
        }
    }
    return false;
}

// ── isEvaluatedDuringInitialization ───────────────────────────────────────

fn isEvaluatedDuringInitialization(
    ctx: *const LintContext,
    ref_scope: ScopeId,
    sym_scope: ScopeId,
    sym_id: SymbolId,
    ref_end: u32,
) bool {
    if (isFromSeparateExecutionContext(ctx, ref_scope, sym_scope)) return false;

    const syms = ctx.symbols();
    const decl_node = syms.getDeclNode(sym_id);
    const binding_kind = syms.getBindingKind(sym_id);

    // ClassName: class is in range AND not in static initializer
    if (binding_kind == .class_decl or binding_kind == .class_expr_name) {
        const class_node = ctx.parentOf(decl_node);
        if (class_node == .none) return false;
        const sp = ctx.nodeSpan(class_node);
        if (ref_end < sp.start or ref_end > sp.end) return false;
        return !isInClassStaticInitRange(ctx, class_node, ref_end);
    }

    // Walk from decl identifier up through the parent chain
    var node = ctx.parentOf(decl_node);
    while (node != .none) {
        const tag = ctx.ast.nodeTag(node);
        switch (tag) {
            .declarator => {
                // Check init (rhs of declarator)
                const init_node = ctx.ast.nodeData(node).rhs;
                if (init_node != .none) {
                    const isp = ctx.nodeSpan(init_node);
                    if (ref_end > isp.start and ref_end <= isp.end) return true;
                }
                // Check for-in/of right side
                const var_decl = ctx.parentOf(node);
                if (var_decl != .none) {
                    const for_stmt = ctx.parentOf(var_decl);
                    if (for_stmt != .none) {
                        const ft = ctx.ast.nodeTag(for_stmt);
                        if (ft == .for_in_stmt or ft == .for_of_stmt or ft == .for_await_of_stmt) {
                            const fd = ctx.ast.extraData(ast.ForInOfData, @intFromEnum(ctx.ast.nodeData(for_stmt).lhs));
                            if (fd.expr != .none) {
                                const esp = ctx.nodeSpan(fd.expr);
                                if (ref_end > esp.start and ref_end <= esp.end) return true;
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
                    if (ref_end > rsp.start and ref_end <= rsp.end) return true;
                }
                node = ctx.parentOf(node);
            },
            else => {
                if (isSentinelTag(tag)) return false;
                node = ctx.parentOf(node);
            },
        }
    }
    return false;
}

// ── isClassRefInClassDecorator ─────────────────────────────────────────────
//
// Skip references to a class that appear in the class's own decorators.
// Decorators come before the `class` keyword in source but are transpiled
// to run after the class is defined, so no "use before define" applies.

fn isClassRefInClassDecorator(ctx: *const LintContext, sym_id: SymbolId, ref_span_end: u32) bool {
    const syms = ctx.symbols();
    if (syms.getBindingKind(sym_id) != .class_decl) return false;

    const decl_node = syms.getDeclNode(sym_id);
    const class_node = ctx.parentOf(decl_node);
    if (class_node == .none) return false;
    if (ctx.ast.nodeTag(class_node) != .class_decl) return false;

    const class_kw_tok = ctx.nodeMainToken(class_node);
    const class_kw_start = ctx.tokenStart(class_kw_tok);

    // Reference must appear before the class keyword.
    if (ref_span_end > class_kw_start) return false;

    // Scan backward from the class keyword.  If we encounter a `@` token
    // before reaching the reference position, the reference is inside a
    // class-level decorator.
    // Scan backward from the class keyword to find '@'.  Key insight:
    //   - If the reference is INSIDE a decorator, '@' comes BEFORE it in source.
    //   - If the reference is standalone code, any decorator '@' comes BETWEEN
    //     the reference and the class keyword (AFTER the reference in source).
    // So: track whether we've passed the reference token in the backward scan.
    // If we find '@' AFTER passing the reference → reference is inside decorator.
    // If we find '@' BEFORE passing the reference → reference is NOT in decorator.
    var passed_ref = false;
    var t = class_kw_tok;
    var scan_limit: u32 = 512;
    while (t > 0 and scan_limit > 0) : (scan_limit -= 1) {
        t -= 1;
        const tok_start = ctx.tokenStart(t);
        const text = ctx.ast.tokenText(t);
        if (!passed_ref) {
            const tok_end = tok_start + @as(u32, @intCast(text.len));
            if (tok_end <= ref_span_end) passed_ref = true;
        }
        if (text.len == 1 and text[0] == '@') {
            return passed_ref; // '@' after passing ref → in decorator; before → not in decorator
        }
    }
    return false;
}

// ── shouldCheck ────────────────────────────────────────────────────────────

fn isExportSpecifierLocal(ctx: *const LintContext, ref_node: NodeIndex) bool {
    const parent = ctx.parentOf(ref_node);
    if (parent == .none) return false;
    if (ctx.ast.nodeTag(parent) != .export_specifier) return false;
    // export_specifier lhs = local, rhs = exported
    return ctx.ast.nodeData(parent).lhs == ref_node;
}

fn isNestedNamespaceAliasRhs(ctx: *const LintContext, ref_node: NodeIndex) bool {
    // In a TSQualifiedName (member_expr in type position), the right-hand
    // identifiers (Foo.Bar) are not real variable references — skip them.
    // Only the leftmost qualifier is an actual reference.
    const parent = ctx.parentOf(ref_node);
    if (parent == .none) return false;
    const ptag = ctx.ast.nodeTag(parent);
    if (ptag != .member_expr) return false;
    // If the ref is the RHS (property) of a member expression that's inside a type position,
    // it's not a real reference.  We use ref kind: the property identifier in a member_expr
    // in type context would be .property_ident, not a real identifier reference.
    // Actually, for nested qualifiers like Foo.Bar.Baz in type context:
    // - Foo would be identifier with type_read ref
    // - .Bar, .Baz would be property_ident nodes (no reference emitted)
    // So we don't need special handling here; the right identifiers don't have refs.
    return false;
}

fn shouldCheck(
    ctx: *const LintContext,
    ref_id: ReferenceId,
    sym_id: SymbolId,
    ref_node: NodeIndex,
    opts: Options,
) bool {
    const syms = ctx.symbols();
    const refs = ctx.references();
    const binding_kind = syms.getBindingKind(sym_id);

    // Implicit globals (undeclared) have no real definition.
    if (binding_kind == .implicit_global) return false;

    // Type bindings not visible to this option.
    if (binding_kind == .type_param) return false;

    // function_decl: if functions:false, UNCONDITIONALLY skip (they're hoisted).
    if (binding_kind == .function_decl or binding_kind == .function_decl_annex_b) {
        if (!opts.functions) return false;
    }

    // variables: if variables:false and from separate exec context, skip.
    // "Variable" in ESLint = var + let + const (all VariableDeclaration kinds).
    const is_variable = binding_kind == .@"var" or binding_kind == .let or binding_kind == .@"const";
    if (is_variable and !opts.variables) {
        const ref_scope = refs.getScope(ref_id);
        const sym_scope = syms.getScope(sym_id);
        if (isFromSeparateExecutionContext(ctx, ref_scope, sym_scope)) return false;
    }

    // classes:false → skip only when the reference is from a separate execution
    // context (mirrors ESLint's behaviour: identical to variables:false, NOT
    // identical to functions:false which is unconditional).
    if ((binding_kind == .class_decl or binding_kind == .class_expr_name) and !opts.classes) {
        const ref_scope = refs.getScope(ref_id);
        const sym_scope = syms.getScope(sym_id);
        if (isFromSeparateExecutionContext(ctx, ref_scope, sym_scope)) return false;
    }

    // enums
    if (!opts.enums and binding_kind == .enum_decl) return false;

    // typedefs
    if (!opts.typedefs and (binding_kind == .type_decl or binding_kind == .interface_decl or
        binding_kind == .namespace_decl)) return false;

    // ignoreTypeReferences: skip references that are in type positions.
    if (opts.ignore_type_refs) {
        const rk = refs.getKind(ref_id);
        // Enum names are also values (Foo.BAR in expressions), so a type_read ref
        // kind on an enum may be a semantic over-classification. Fall through to the
        // parent walk to distinguish true type positions from value positions.
        const is_enum = binding_kind == .enum_decl;
        if (rk == .type_read and !is_enum) return false;
        // Walk up a few levels looking for a type container node.
        // Handles `typeof Foo.FOO` where Foo's immediate parent is member_expr
        // (not ts_typeof_type), but the grandparent is ts_typeof_type.
        // Also handles enum refs that appear in type annotations (args: Foo).
        var p = ctx.parentOf(ref_node);
        var depth: u32 = 3;
        while (p != .none and depth > 0) : (depth -= 1) {
            const pt = ctx.ast.nodeTag(p);
            if (pt == .ts_type_reference or pt == .ts_typeof_type or
                pt == .ts_type_annotation or pt == .ts_type_alias_decl or
                pt == .ts_interface_decl)
            {
                return false;
            }
            // Stop at expression boundaries.
            if (pt == .call_expr or pt == .optional_call_expr or
                pt == .new_expr or pt == .arrow_fn or pt == .fn_expr or
                pt == .class_decl or pt == .class_expr)
            {
                break;
            }
            p = ctx.parentOf(p);
        }
    }

    // allowNamedExports: skip local of an export specifier
    if (opts.allow_named_exports and isExportSpecifierLocal(ctx, ref_node)) return false;

    // isClassRefInClassDecorator: skip refs to a class from within its own decorator.
    const ref_span_end = ctx.nodeSpan(ref_node).end;
    if (isClassRefInClassDecorator(ctx, sym_id, ref_span_end)) return false;

    return true;
}

// ── Main entry point ───────────────────────────────────────────────────────

pub fn runWithMessageId(ctx: *const LintContext, message_id: []const u8) void {
    const opts = parseOptions(ctx);
    const refs = ctx.references();
    const syms = ctx.symbols();
    const n = refs.symbol_ids.items.len;

    for (0..n) |i| {
        const ref_id = ReferenceId.fromInt(@intCast(i));
        const rk = refs.getKind(ref_id);

        // Skip write_init (the binding itself).
        if (rk == .write_init) continue;

        // Skip unresolved references.
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;

        const ref_node = refs.getNode(ref_id);
        if (ref_node == .none) continue;

        if (!shouldCheck(ctx, ref_id, sym_id, ref_node, opts)) continue;

        const decl_node = syms.getDeclNode(sym_id);
        if (decl_node == .none) continue;

        const ref_end = ctx.nodeSpan(ref_node).end;
        const decl_end = ctx.nodeSpan(decl_node).end;

        const should_flag = (ref_end < decl_end) or blk: {
            const ref_scope = refs.getScope(ref_id);
            const sym_scope = syms.getScope(sym_id);
            const is_init = isEvaluatedDuringInitialization(ctx, ref_scope, sym_scope, sym_id, ref_end);
            // ESLint: isEvaluatedDuringInitialization AND parent.type !== "TSTypeReference"
            if (!is_init) break :blk false;
            const parent = ctx.parentOf(ref_node);
            if (parent != .none and ctx.ast.nodeTag(parent) == .ts_type_reference) break :blk false;
            break :blk true;
        };

        if (should_flag) {
            const name = ctx.tokenText(ctx.nodeMainToken(ref_node));
            ctx.reportWithMessageIdAndData(ref_node, message_id, &[_]MessageDataEntry{
                .{ .key = "name", .val = name },
            });
        }
    }
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    runWithMessageId(ctx, "usedBeforeDefined");
}
