const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ReferenceId = @import("../../../parser/reference.zig").ReferenceId;

pub const meta = RuleMeta{
    .name = "no-undef",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow the use of undeclared variables",
};

pub const relevant_tags = [_]Node.Tag{};

const known_globals = [_][]const u8{
    "undefined",
    "NaN",
    "Infinity",
    "console",
    "setTimeout",
    "setInterval",
    "clearTimeout",
    "clearInterval",
    "Promise",
    "Array",
    "Object",
    "String",
    "Number",
    "Boolean",
    "Symbol",
    "BigInt",
    "Map",
    "Set",
    "WeakMap",
    "WeakSet",
    "Error",
    "TypeError",
    "RangeError",
    "SyntaxError",
    "ReferenceError",
    "JSON",
    "Math",
    "Date",
    "RegExp",
    "parseInt",
    "parseFloat",
    "isNaN",
    "isFinite",
    "encodeURI",
    "decodeURI",
    "encodeURIComponent",
    "decodeURIComponent",
    "globalThis",
    "window",
    "document",
    "navigator",
    "fetch",
    "URL",
    "URLSearchParams",
    "AbortController",
    "Event",
    "EventTarget",
    "TextEncoder",
    "TextDecoder",
    "atob",
    "btoa",
    "queueMicrotask",
    "structuredClone",
    "require",
    "module",
    "exports",
    "__dirname",
    "__filename",
    "process",
    "Buffer",
};

fn isKnownGlobal(name: []const u8) bool {
    for (known_globals) |global| {
        if (std.mem.eql(u8, name, global)) return true;
    }
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const ref_id = ReferenceId.fromInt(i);
        if (refs.isResolved(ref_id)) continue;
        if (refs.getKind(ref_id) == .type_of) continue;

        const node = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (isKnownGlobal(name)) continue;

        ctx.report(node, meta.name, "Variable is not defined", meta.default_severity);
    }
}
