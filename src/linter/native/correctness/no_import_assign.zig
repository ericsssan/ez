// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-import-assign
// Source rule: tests/conformance/eslint/lib/rules/no-import-assign.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
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
        ctx.reportWithMessageId(id_node, "readonly");
        prev_reported_node = id_node;
    }
}
