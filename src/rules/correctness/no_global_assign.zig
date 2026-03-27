const std = @import("std");
const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "no-global-assign",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow assignments to native objects or read-only global variables",
};

pub const relevant_tags = [_]Node.Tag{.assign};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Check: identifier = ... where identifier is a readonly global
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    if (ctx.nodeTag(data.lhs) != .identifier) return;

    const name = ctx.ast.tokenText(ctx.ast.nodeMainToken(data.lhs));
    if (isReadonlyGlobal(name)) {
        ctx.report(node, meta.name, "Read-only global should not be modified", meta.default_severity);
    }
}

const readonly_globals = [_][]const u8{
    "undefined",
    "NaN",
    "Infinity",
    "eval",
    "isFinite",
    "isNaN",
    "parseFloat",
    "parseInt",
    "decodeURI",
    "decodeURIComponent",
    "encodeURI",
    "encodeURIComponent",
    "Object",
    "Function",
    "Boolean",
    "Symbol",
    "Error",
    "EvalError",
    "RangeError",
    "ReferenceError",
    "SyntaxError",
    "TypeError",
    "URIError",
    "Number",
    "BigInt",
    "Math",
    "Date",
    "String",
    "RegExp",
    "Array",
    "Map",
    "Set",
    "WeakMap",
    "WeakSet",
    "JSON",
    "Promise",
    "Reflect",
    "Proxy",
    "ArrayBuffer",
    "DataView",
    "globalThis",
    "Atomics",
    "console",
};

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const count = symbols.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);

        if (!symbols.isImplicitGlobal(id)) continue;

        const flags = symbols.getFlags(id);
        if (!flags.is_written) continue;

        const name = symbols.getName(id);

        if (isReadonlyGlobal(name)) {
            const decl_node = symbols.getDeclNode(id);
            ctx.report(decl_node, meta.name, "Read-only global should not be modified", meta.default_severity);
        }
    }
}

fn isReadonlyGlobal(name: []const u8) bool {
    for (readonly_globals) |global| {
        if (std.mem.eql(u8, name, global)) return true;
    }
    return false;
}

