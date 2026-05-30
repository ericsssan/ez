// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-import-assign
// Source rule: tests/conformance/eslint/lib/rules/no-import-assign.js

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("es_parser").reference;
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-import-assign",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow assigning to imported bindings",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    readonly,
    readonlyMember,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const symbols = ctx.symbols();
    const count = refs.count();
    var prev_reported_node: NodeIndex = .none;
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const kind = refs.getKind(ref_id);
        // ESLint's getModifyingReferences = isWrite() && !init.
        // Our .write_init kind == ESLint's reference.init === true.
        if (!kind.isWrite()) continue;
        if (kind == .write_init) continue;
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;
        switch (symbols.getBindingKind(sym_id)) {
            .import_binding => {},
            else => continue,
        }
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        // Destructuring with defaults can yield two write references that share
        // their identifier node ({Foo = 0} pattern); suppress the duplicate.
        if (id_node == prev_reported_node) continue;
        const report_node = ctx.writeRefReportNode(id_node);
        const __name = ctx.tokenText(ctx.nodeMainToken(id_node));
        ctx.reportWithMessageIdAndData(report_node, "readonly", &[_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "name", .val = __name },
        });
        prev_reported_node = id_node;
    }
    var r2: u32 = 0;
    while (r2 < count) : (r2 += 1) {
        const ref_id = ReferenceId.fromInt(r2);
        const sym_id = refs.getSymbol(ref_id);
        if (sym_id == .none) continue;
        switch (symbols.getBindingKind(sym_id)) {
            .import_binding => {},
            else => continue,
        }
        if (!ctx.isNamespaceImportBinding(sym_id)) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        const parent = ctx.parentOf(id_node);
        if (parent == .none) continue;
        const ptag = ctx.nodeTag(parent);
        const is_member = ptag == .member_expr or ptag == .optional_member_expr
            or ptag == .computed_member_expr or ptag == .optional_computed_member_expr;
        const wkm = ctx.argOfWellKnownMutation(id_node);
        if (wkm != .none) {
            const __name_wkm = ctx.tokenText(ctx.nodeMainToken(id_node));
            ctx.reportWithMessageIdAndData(wkm, "readonlyMember", &[_]@import("../../lint_context.zig").MessageDataEntry{
                .{ .key = "name", .val = __name_wkm },
            });
            continue;
        }
        if (!is_member) continue;
        // id_node must be the OBJECT of the member access (lhs).
        if (ctx.nodeData(parent).lhs != id_node) continue;
        const qualifies = ctx.memberInWriteContext(parent);
        if (qualifies == .none) continue;
        const member_write_node = ctx.writeRefReportNode(qualifies);
        const __name = ctx.tokenText(ctx.nodeMainToken(id_node));
        ctx.reportWithMessageIdAndData(member_write_node, "readonlyMember", &[_]@import("../../lint_context.zig").MessageDataEntry{
            .{ .key = "name", .val = __name },
        });
    }
}
