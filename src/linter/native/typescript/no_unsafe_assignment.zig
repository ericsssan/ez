// HAND-WRITTEN — type-aware rule.  Does not fit the IR codegen pipeline
// because it queries the TS type checker; the IR has no type-level ops.
// Rule: @typescript-eslint/no-unsafe-assignment
//
// Reports when a value of type `any` (or a value reaching `any`) flows
// into a typed target.  Mirrors typescript-eslint's behavior:
//   * `const x: number = anyVal;`         → unsafe
//   * `const x: { a: number } = json;`    → unsafe (json is any)
//   * `const x: number[] = anyArr;`       → unsafe
//   * `arr[i] = anyVal;`                  → unsafe (array element assignment)
//
// Triggers on:
//   * variable declarator with an explicit type annotation
//   * assignment expressions where the LHS has a known declared type
//   * object literal properties whose declared shape carries non-any types
//
// We do NOT yet handle:
//   * function call arguments (that's no-unsafe-argument)
//   * function return values (that's no-unsafe-return)
//   * member expressions on any (that's no-unsafe-member-access)

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-assignment",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow assigning a value of type any to typed variables",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .declarator, .assign, .assignment_pattern };

pub const needs_semantic = true;

const tymod = @import("../../../checker/types.zig");

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx),
        .assign => checkAssign(node, ctx),
        .assignment_pattern => checkAssignmentPattern(node, ctx),
        else => {},
    }
}

/// Function-parameter default-value destructuring:
///   `function foo([x] = [1] as [any])` — when no arg is passed, the
///   param's value is `[1] as [any]`, so destructuring `[x]` binds `x`
///   to `any`.  TSe fires `unsafeArrayPatternFromTuple` /
///   `unsafeObjectPattern` for these positions.
///
/// We trigger on `assignment_pattern` nodes whose binding side (lhs) is
/// a destructure pattern.  Nested patterns (e.g. an element of an outer
/// pattern that itself has a default) are already handled by the outer
/// pattern walk via `peelAssignmentPattern`, so we only act when the
/// parent is a function-parameter-style context (not another pattern).
fn checkAssignmentPattern(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const pat = data.lhs;
    const ptag = ctx.nodeTag(pat);
    if (ptag != .array_pattern and ptag != .object_pattern) return;
    // Skip when an outer destructure will already walk into this.
    const parent = ctx.parentOf(node);
    if (parent != .none) {
        const ptag2 = ctx.nodeTag(parent);
        switch (ptag2) {
            .array_pattern, .object_pattern, .array_literal, .object_literal => return,
            else => {},
        }
    }
    if (data.rhs == .none) return;
    const sender_ty = senderTypeForDestructure(data.rhs, ctx);
    checkDestructure(pat, sender_ty, ctx);
}

/// Preserve `as`-cast target types: `[x] = [1] as [any]` should walk
/// against the cast TARGET, not the underlying value's inferred type.
/// The checker may not propagate ts_as_expr through structural casts.
fn senderTypeForDestructure(rhs: NodeIndex, ctx: *const LintContext) tymod.TypeId {
    const r = unwrapGroup(rhs, ctx);
    if (ctx.nodeTag(r) == .ts_as_expr) {
        const target = ctx.nodeData(r).rhs;
        if (target != .none) return ctx.resolveTypeAnnotationNode(target);
    }
    if (ctx.nodeTag(r) == .ts_type_assertion) {
        const target = ctx.nodeData(r).lhs;
        if (target != .none) return ctx.resolveTypeAnnotationNode(target);
    }
    return ctx.typeOfNode(rhs);
}

fn unwrapGroup(n: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = n;
    while (cur != .none and ctx.nodeTag(cur) == .grouping_expr) {
        cur = ctx.nodeData(cur).lhs;
    }
    return cur;
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const lhs = data.lhs;
    const lhs_tag = ctx.nodeTag(lhs);
    // Destructuring patterns: walk pattern positions against the
    // inferred RHS type.  `const [x] = sender` checks sender[0] type;
    // `const { x } = sender` checks sender.x type.  TSe fires
    // `unsafeArrayPatternFromTuple` / `unsafeObjectPattern` for these.
    if (lhs_tag == .array_pattern or lhs_tag == .object_pattern) {
        const sender_ty = senderTypeForDestructure(data.rhs, ctx);
        checkDestructure(lhs, sender_ty, ctx);
        return;
    }
    if (lhs_tag != .identifier) return;
    // `const bar = this` in a non-method function: `this` is implicit
    // any.  TSe fires `anyAssignmentThis`.
    if (initIsImplicitThis(data.rhs, node, ctx)) {
        ctx.reportWithMessageId(node, "anyAssignmentThis");
        return;
    }
    const binding_data = ctx.nodeData(lhs);
    if (binding_data.rhs == .none) return;
    if (ctx.nodeTag(binding_data.rhs) != .ts_type_annotation) return;
    const lhs_ty_node = ctx.nodeData(binding_data.rhs).lhs;
    reportIfUnsafe(node, lhs_ty_node, data.rhs, ctx);
}

/// Detect `= this` initializers where the enclosing function makes
/// `this` implicit-any.  Mirrors no-unsafe-return's heuristic.
fn initIsImplicitThis(init: NodeIndex, decl_node: NodeIndex, ctx: *const LintContext) bool {
    const r = unwrapGroup(init, ctx);
    if (ctx.nodeTag(r) != .this_expr) return false;
    // Walk up to find the enclosing function-like.
    var p = ctx.parentOf(decl_node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        switch (ctx.nodeTag(p)) {
            .arrow_fn, .async_arrow_fn => {
                // Arrow inherits parent `this`; keep walking.
                continue;
            },
            .method_def, .computed_method_def,
            .getter_def, .setter_def, .computed_getter_def, .computed_setter_def,
            .constructor_def => return false,
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => return true,
            else => continue,
        }
    }
    return false;
}

fn checkAssign(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // Destructuring assignment: `[x] = sender` / `({ x } = sender)`.
    // The parser wraps the RHS of an assign target in grouping when
    // needed; the destructuring pattern appears as the LHS directly.
    const lhs_tag = ctx.nodeTag(data.lhs);
    if (lhs_tag == .array_pattern or lhs_tag == .object_pattern or
        lhs_tag == .array_literal or lhs_tag == .object_literal)
    {
        // Note: ESTree assignment targets reuse array_literal /
        // object_literal node tags for destructuring assignments (vs
        // var declarations which use the pattern tags).  Walk either.
        const sender_ty = senderTypeForDestructure(data.rhs, ctx);
        checkDestructure(data.lhs, sender_ty, ctx);
        return;
    }
    const lhs_ty = ctx.typeOfNode(data.lhs);
    if (ctx.typeIdIsAny(lhs_ty)) return;
    if (!ctx.typeNodeContainsAny(data.rhs)) return;
    if (rhsIsExplicitNonAnyCast(data.rhs, ctx)) return;
    ctx.reportWithMessageId(node, "anyAssignment");
}

/// Walk a destructuring pattern in parallel with the sender's type.
/// For each receiver position, look up the corresponding sender slot
/// type and either fire (if any) or recurse (if nested pattern).
fn checkDestructure(receiver: NodeIndex, sender_ty: tymod.TypeId, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(receiver);
    switch (tag) {
        .array_pattern, .array_literal => checkArrayDestructure(receiver, sender_ty, ctx),
        .object_pattern, .object_literal => checkObjectDestructure(receiver, sender_ty, ctx),
        else => {},
    }
}

fn checkArrayDestructure(pattern: NodeIndex, sender_ty: tymod.TypeId, ctx: *const LintContext) void {
    const data = ctx.nodeData(pattern);
    // Pattern element range: start/end stored directly in lhs/rhs.
    if (data.lhs == .none or data.rhs == .none) return;
    const r_start = @intFromEnum(data.lhs);
    const r_end = @intFromEnum(data.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (r_start > r_end or r_end > ext_len) return;
    const elements = ctx.ast.extra_data[r_start..r_end];
    var idx: usize = 0;
    for (elements) |raw| {
        defer idx += 1;
        const elem: NodeIndex = @enumFromInt(raw);
        if (elem == .none) continue;
        // Skip rest elements — TSe does too.
        if (ctx.nodeTag(elem) == .rest_element) continue;
        // Peel assignment_pattern (default value) to get the binding side.
        const inner = peelAssignmentPattern(elem, ctx);
        const slot_ty = ctx.typeIdTupleElementAt(sender_ty, idx);
        if (ctx.typeIdIsAny(slot_ty)) {
            ctx.reportSpanWithMessageId(ctx.nodeSpan(inner), "unsafeArrayPatternFromTuple");
            continue;
        }
        // Nested pattern: recurse.
        const inner_tag = ctx.nodeTag(inner);
        if (inner_tag == .array_pattern or inner_tag == .array_literal or
            inner_tag == .object_pattern or inner_tag == .object_literal)
        {
            checkDestructure(inner, slot_ty, ctx);
        }
    }
}

fn checkObjectDestructure(pattern: NodeIndex, sender_ty: tymod.TypeId, ctx: *const LintContext) void {
    const data = ctx.nodeData(pattern);
    if (data.lhs == .none or data.rhs == .none) return;
    const r_start = @intFromEnum(data.lhs);
    const r_end = @intFromEnum(data.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (r_start > r_end or r_end > ext_len) return;
    const props = ctx.ast.extra_data[r_start..r_end];
    for (props) |raw| {
        const prop: NodeIndex = @enumFromInt(raw);
        const ptag = ctx.nodeTag(prop);
        if (ptag == .rest_element) continue;
        const prop_data = ctx.nodeData(prop);
        // Extract (key-name, binding-value) for the three property shapes:
        //   shorthand_property: `{ x }` — name and value are both `x`.
        //   property:           `{ x: y }` — key in lhs, value in rhs.
        //   computed_property:  `{ ['x']: y }` — key may be literal.
        var name: []const u8 = "";
        var value: NodeIndex = .none;
        switch (ptag) {
            .shorthand_property => {
                value = prop_data.lhs;
                if (value != .none and ctx.nodeTag(value) == .identifier) {
                    name = ctx.tokenText(ctx.nodeMainToken(value));
                }
            },
            .property => {
                value = prop_data.rhs;
                if (prop_data.lhs != .none) {
                    name = ctx.tokenText(ctx.nodeMainToken(prop_data.lhs));
                }
            },
            .computed_property => {
                value = prop_data.rhs;
                // For `[ 'x' ]: y` (string_literal) / `[ `x` ]: y`
                // (template_literal) — strip the surrounding delimiter.
                if (prop_data.lhs != .none) {
                    const ktag = ctx.nodeTag(prop_data.lhs);
                    if (ktag == .string_literal or ktag == .template_literal) {
                        const raw_str = ctx.tokenText(ctx.nodeMainToken(prop_data.lhs));
                        if (raw_str.len >= 2) name = raw_str[1 .. raw_str.len - 1];
                    }
                }
            },
            else => continue,
        }
        if (value == .none) continue;
        const inner = peelAssignmentPattern(value, ctx);
        const slot_ty = ctx.typeIdObjectPropertyType(sender_ty, name);
        if (ctx.typeIdIsAny(slot_ty)) {
            ctx.reportSpanWithMessageId(ctx.nodeSpan(inner), "unsafeObjectPattern");
            continue;
        }
        const inner_tag = ctx.nodeTag(inner);
        if (inner_tag == .array_pattern or inner_tag == .array_literal or
            inner_tag == .object_pattern or inner_tag == .object_literal)
        {
            checkDestructure(inner, slot_ty, ctx);
        }
    }
}

fn peelAssignmentPattern(n: NodeIndex, ctx: *const LintContext) NodeIndex {
    if (n != .none and ctx.nodeTag(n) == .assignment_pattern) {
        return ctx.nodeData(n).lhs;
    }
    return n;
}

fn reportIfUnsafe(
    decl_node: NodeIndex,
    lhs_ty_node: NodeIndex,
    rhs: NodeIndex,
    ctx: *const LintContext,
) void {
    const lhs_ty = ctx.resolveTypeAnnotationNode(lhs_ty_node);
    if (ctx.typeIdIsAny(lhs_ty)) return; // explicit `: any` → no warning
    if (ctx.typeIdContainsAny(lhs_ty)) {
        // Declared type itself contains any (e.g. `any[]`) — the user is
        // already opting into anyness on the LHS; suppress to match TSe.
        return;
    }
    // `unknown` (and unknown-flavored composites) are the safe sink for
    // any-typed values; typescript-eslint suppresses these.
    if (ctx.typeIdContainsUnknown(lhs_ty)) return;
    // Object-literal initializer against a structural LHS: walk each
    // property value and report at the position of any any-typed value.
    // TSe fires anyAssignment per offending property, NOT on the whole
    // declarator.
    const rhs_u = unwrapGroup(rhs, ctx);
    if (ctx.nodeTag(rhs_u) == .object_literal) {
        if (reportObjectLiteralProperties(rhs_u, lhs_ty, ctx)) return;
    }
    if (!ctx.typeNodeContainsAny(rhs)) return;
    if (rhsIsExplicitNonAnyCast(rhs, ctx)) return;
    ctx.reportWithMessageId(decl_node, "anyAssignment");
}

/// For `const foo: { a: T } = { a: <any-expr> }`: check each property
/// value against the corresponding declared property type and report
/// anyAssignment at the value's position.  Returns true when at least
/// one any-typed value was reported (caller skips the whole-declarator
/// fallback).
fn reportObjectLiteralProperties(lit: NodeIndex, lhs_ty: tymod.TypeId, ctx: *const LintContext) bool {
    const data = ctx.nodeData(lit);
    if (data.lhs == .none or data.rhs == .none) return false;
    const r_start = @intFromEnum(data.lhs);
    const r_end = @intFromEnum(data.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (r_start > r_end or r_end > ext_len) return false;
    var fired = false;
    for (ctx.ast.extra_data[r_start..r_end]) |raw| {
        const prop: NodeIndex = @enumFromInt(raw);
        const ptag = ctx.nodeTag(prop);
        const pd = ctx.nodeData(prop);
        var name: []const u8 = "";
        var value: NodeIndex = .none;
        switch (ptag) {
            .shorthand_property => {
                value = pd.lhs;
                if (value != .none and ctx.nodeTag(value) == .identifier) {
                    name = ctx.tokenText(ctx.nodeMainToken(value));
                }
            },
            .property => {
                value = pd.rhs;
                if (pd.lhs != .none) name = ctx.tokenText(ctx.nodeMainToken(pd.lhs));
            },
            else => continue,
        }
        if (value == .none or name.len == 0) continue;
        const slot_ty = ctx.typeIdObjectPropertyType(lhs_ty, name);
        if (ctx.typeIdIsAny(slot_ty)) continue; // declared `any` slot
        if (ctx.typeIdContainsUnknown(slot_ty)) continue;
        if (!ctx.typeNodeContainsAny(value)) continue;
        if (rhsIsExplicitNonAnyCast(value, ctx)) continue;
        ctx.reportWithMessageId(value, "anyAssignment");
        fired = true;
    }
    return fired;
}

fn rhsIsExplicitNonAnyCast(rhs: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(rhs);
    switch (tag) {
        .ts_as_expr, .ts_type_assertion => {
            const data = ctx.nodeData(rhs);
            const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
            const cast_ty = ctx.resolveTypeAnnotationNode(ty_node);
            // `x as any` is still unsafe; only non-any casts suppress.
            return !ctx.typeIdIsAny(cast_ty);
        },
        else => return false,
    }
}
