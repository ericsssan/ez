// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-restricted-globals
// Source rule: tests/conformance/eslint/lib/rules/no-restricted-globals.js

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;

pub const meta = RuleMeta{
    .name = "no-restricted-globals",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow specified global variables",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    defaultMessage,
    customMessage,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ref_mod.ReferenceId.fromInt(r);
        const ref_kind = refs.getKind(ref_id);
        if (ref_kind == .write_init) continue;
        // Skip TS type-context refs (let x: NS) — rule's
        // isInTypeContext filter.
        if (ref_kind.isTypeRef()) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        const name = ctx.tokenText(ctx.nodeMainToken(id_node));
        if (ctx.ruleOptionsIncludeName(name)) {
            // Also skip identifiers in TS type annotation positions (e.g. `let x: NS.Foo`).
            // isTypeRef() doesn't catch NS when it's the LHS of a MemberExpression inside
            // a TSTypeReference; detect it by checking for a ts_type_annotation ancestor.
            {
                var anc = ctx.parentOf(id_node);
                var in_type_ctx = false;
                while (anc != .none) : (anc = ctx.parentOf(anc)) {
                    const atag = ctx.ast.nodeTag(anc);
                    if (atag == .ts_type_annotation or atag == .ts_type_reference or
                        atag == .ts_union_type or atag == .ts_intersection_type or
                        atag == .ts_tuple_type or atag == .ts_array_type or
                        atag == .ts_function_type or atag == .ts_conditional_type)
                    {
                        in_type_ctx = true;
                        break;
                    }
                    // Stop walking at statement boundaries.
                    const atag_int = @intFromEnum(atag);
                    if (atag_int <= 25) break; // stmt tags 0-25 are statements
                }
                if (in_type_ctx) continue;
            }
            const sk_sym = refs.getSymbol(ref_id);
            if (sk_sym != .none and !ctx.symbols().isImplicitGlobal(sk_sym)) continue;
            if (ctx.ruleOptionsMessageForName(name)) |custom| {
                ctx.reportWithMessageIdAndData(id_node, "customMessage", &[_]@import("../../lint_context.zig").MessageDataEntry{
                    .{ .key = "name", .val = name },
                    .{ .key = "customMessage", .val = custom },
                });
            } else {
                ctx.reportWithMessageIdAndData(id_node, "defaultMessage", &[_]@import("../../lint_context.zig").MessageDataEntry{
                    .{ .key = "name", .val = name },
                });
            }
            continue;
        }
        // checkGlobalObject feature: when a reference is to a global
        // object (window/self/globalThis/options.globalObjects), walk up
        // through <X>.<sameName> chains, then check the trailing member
        // access for a restricted property name.
        if (!ctx.ruleOptionsCheckGlobalObject()) continue;
        if (!ctx.isRestrictedGlobalObjectName(name)) continue;
        // Only proceed if the reference actually resolves to a global
        // (matches ESLint's getVariableByName(globalScope, name) gate —
        // user-shadowed or undeclared windows/selfs aren't treated as
        // the host's global object).
        if (!refs.isResolved(ref_id)) continue;
        const sym = refs.getSymbol(ref_id);
        if (sym == .none or !ctx.symbols().isImplicitGlobal(sym)) continue;
        var cur = id_node;
        var parent = ctx.parentOf(cur);
        // Skip <X>.<sameName>.<rest> chains by walking up while parent is
        // a static member access whose property name equals our name.
        while (parent != .none) {
            const ptag_ = ctx.nodeTag(parent);
            const is_member = ptag_ == .member_expr or ptag_ == .optional_member_expr
                or ptag_ == .computed_member_expr or ptag_ == .optional_computed_member_expr;
            if (!is_member) break;
            if (ctx.nodeData(parent).lhs != cur) break;
            const pname = ctx.staticPropertyName(parent) orelse break;
            if (!std.mem.eql(u8, pname, name)) break;
            cur = parent;
            parent = ctx.parentOf(cur);
        }
        if (parent == .none) continue;
        const ptag = ctx.nodeTag(parent);
        const parent_is_member = ptag == .member_expr or ptag == .optional_member_expr
            or ptag == .computed_member_expr or ptag == .optional_computed_member_expr;
        if (!parent_is_member) continue;
        if (ctx.nodeData(parent).lhs != cur) continue;
        const prop_name = ctx.staticPropertyName(parent) orelse continue;
        if (!ctx.ruleOptionsIncludeName(prop_name)) continue;
        // ESLint's rule skips when parent.parent is AssignmentExpression
        // (no-global-assign covers that shape).
        const pp = ctx.parentOf(parent);
        if (pp != .none) {
            const ppt = ctx.nodeTag(pp);
            if (ppt == .assign or ppt == .add_assign or ppt == .sub_assign
                or ppt == .mul_assign or ppt == .div_assign or ppt == .mod_assign
                or ppt == .exp_assign or ppt == .and_assign or ppt == .or_assign
                or ppt == .xor_assign or ppt == .shl_assign or ppt == .shr_assign
                or ppt == .ushr_assign or ppt == .logical_and_assign
                or ppt == .logical_or_assign or ppt == .nullish_assign) continue;
        }
        const prop_node = ctx.nodeData(parent).rhs;
        if (prop_node == .none) continue;
        if (ctx.ruleOptionsMessageForName(prop_name)) |custom| {
            ctx.reportWithMessageIdAndData(prop_node, "customMessage", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "name", .val = prop_name },
                .{ .key = "customMessage", .val = custom },
            });
        } else {
            ctx.reportWithMessageIdAndData(prop_node, "defaultMessage", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "name", .val = prop_name },
            });
        }
    }
}
