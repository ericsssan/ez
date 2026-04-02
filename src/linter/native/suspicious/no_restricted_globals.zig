const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const relevant_tags = [_]Node.Tag{};

pub const meta = RuleMeta{
    .name = "no-restricted-globals",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow specified global variables",
};

const restricted = [_][]const u8{
    "event",
    "fdescribe",
    "fit",
    "xdescribe",
    "xit",
    "name",
    "length",
    "status",
    "origin",
    "close",
    "open",
    "stop",
    "blur",
    "focus",
    "scroll",
    "find",
    "print",
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const count = syms.count();

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = syms.getBindingKind(id);
        if (kind != .implicit_global) continue;

        const name = syms.getName(id);
        for (restricted) |r| {
            if (std.mem.eql(u8, name, r)) {
                const decl_node = syms.getDeclNode(id);
                ctx.report(decl_node, meta.name, "Unexpected use of restricted global variable", meta.default_severity);
                break;
            }
        }
    }
}
