// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-global-assign

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-global-assign",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow assignments to native objects or read-only global variables",
};

pub const relevant_tags = [_]Node.Tag{};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    globalShouldNotBeModified,
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var prev_reported_node: NodeIndex = .none;
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const kind = refs.getKind(ref_id);
        if (!kind.isWrite()) continue;
        // Skip variable-declaration initializers — those write to a fresh local
        // binding, not to the global.  ESLint encodes this as reference.init=true.
        if (kind == .write_init) continue;
        const id_node = refs.getNode(ref_id);
        if (id_node == .none) continue;
        // Identifier nodes carry the name as their main-token text.
        const name = ctx.tokenText(ctx.nodeMainToken(id_node));
        if (!ctx.globalIsReadOnly(name)) continue;
        // Honour { exceptions: [...] } option — names listed there are exempt.
        if (ctx.optionArrayContains("exceptions", name)) continue;
        // Destructuring with defaults can yield two write references that share
        // their identifier node ({Foo = 0} pattern).  Suppress the duplicate.
        if (id_node == prev_reported_node) continue;
        ctx.report(id_node);
        prev_reported_node = id_node;
    }
}
