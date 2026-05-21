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

pub const relevant_tags = [_]Node.Tag{ .declarator, .assign };

pub const needs_semantic = true;

const tymod = @import("../../../checker/types.zig");

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx),
        .assign => checkAssign(node, ctx),
        else => {},
    }
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
        const sender_ty = ctx.typeOfNode(data.rhs);
        checkDestructure(lhs, sender_ty, ctx);
        return;
    }
    if (lhs_tag != .identifier) return;
    const binding_data = ctx.nodeData(lhs);
    if (binding_data.rhs == .none) return;
    if (ctx.nodeTag(binding_data.rhs) != .ts_type_annotation) return;
    const lhs_ty_node = ctx.nodeData(binding_data.rhs).lhs;
    reportIfUnsafe(node, lhs_ty_node, data.rhs, ctx);
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
        const sender_ty = ctx.typeOfNode(data.rhs);
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
                // For `[ 'x' ]: y`, key is string_literal — read its text.
                if (prop_data.lhs != .none and ctx.nodeTag(prop_data.lhs) == .string_literal) {
                    const raw_str = ctx.tokenText(ctx.nodeMainToken(prop_data.lhs));
                    if (raw_str.len >= 2) name = raw_str[1 .. raw_str.len - 1]; // strip quotes
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
    if (!ctx.typeNodeContainsAny(rhs)) return;
    if (rhsIsExplicitNonAnyCast(rhs, ctx)) return;
    ctx.reportWithMessageId(decl_node, "anyAssignment");
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
