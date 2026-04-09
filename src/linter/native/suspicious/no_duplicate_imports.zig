const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-duplicate-imports",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow duplicate module imports",
};

pub const relevant_tags = [_]Node.Tag{};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    // Iterate all nodes looking for import_decl
    const count = ctx.nodeCount();

    // Use a simple seen-list (bounded by actual import count which is small)
    var seen_sources: [256][]const u8 = undefined;
    var seen_count: usize = 0;

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const idx = NodeIndex.fromInt(i);
        if (ctx.nodeTag(idx) != .import_decl) continue;

        const data = ctx.nodeData(idx);
        const import_data = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
        const source_text = ctx.tokenText(import_data.source);

        // Check if we've already seen this source
        for (seen_sources[0..seen_count]) |prev| {
            if (std.mem.eql(u8, prev, source_text)) {
                ctx.report(idx);
                break;
            }
        } else {
            if (seen_count < seen_sources.len) {
                seen_sources[seen_count] = source_text;
                seen_count += 1;
            }
        }
    }
}
