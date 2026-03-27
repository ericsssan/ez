const ast = @import("../../ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const SymbolId = @import("../../symbol.zig").SymbolId;
const ScopeId = @import("../../scope.zig").ScopeId;

pub const relevant_tags = [_]Node.Tag{};

pub const meta = RuleMeta{
    .name = "no-redeclare",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow variable redeclaration in the same scope",
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const syms = ctx.symbols();
    const count = syms.count();

    // Detect duplicates by comparing each let/const symbol against others in the same scope.
    // Use a hash map keyed on owned strings (allocated from ctx.allocator).
    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer {
        // Free all owned keys
        var it = seen.keyIterator();
        while (it.next()) |key_ptr| {
            ctx.allocator.free(key_ptr.*);
        }
        seen.deinit();
    }

    var key_buf: [256]u8 = undefined;

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const kind = syms.getBindingKind(id);

        // Only check let/const redeclarations.
        switch (kind) {
            .let, .@"const" => {},
            else => continue,
        }

        const scope = syms.getScope(id);
        const name = syms.getName(id);
        const scope_int = @intFromEnum(scope);

        // Build composite key: "scope_id\x00name"
        const key = std.fmt.bufPrint(&key_buf, "{d}\x00{s}", .{ scope_int, name }) catch continue;

        const result = seen.getOrPut(key) catch continue;
        if (result.found_existing) {
            ctx.report(syms.getDeclNode(id), meta.name, "Variable is already declared in this scope", meta.default_severity);
        } else {
            // Store an owned copy so the key survives key_buf overwrites
            result.key_ptr.* = ctx.allocator.dupe(u8, key) catch continue;
        }
    }
}
