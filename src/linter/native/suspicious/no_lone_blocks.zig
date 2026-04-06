const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.block_stmt};

pub const meta = RuleMeta{
    .name = "no-lone-blocks",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow unnecessary nested blocks",
};

const ParentInfo = struct {
    tag: Node.Tag,
    child_count: u32,
    child_index: u32,
};

/// Scan all nodes to find which statement-list contains `target`.
/// Returns info about the parent or null if not found in any statement list.
fn findParent(target: NodeIndex, ctx: *const LintContext) ?ParentInfo {
    const target_int = @intFromEnum(target);
    const n = ctx.nodeCount();
    var i: u32 = 0;
    while (i < n) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = ctx.nodeTag(ni);
        const data = ctx.nodeData(ni);

        switch (tag) {
            // Direct SubRange: lhs = start, rhs = end
            .root, .block_stmt, .static_block => {
                const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
                const stmts = ctx.extraSlice(range);
                for (stmts, 0..) |raw, idx| {
                    if (raw == target_int) {
                        return ParentInfo{ .tag = tag, .child_count = @intCast(stmts.len), .child_index = @intCast(idx) };
                    }
                }
            },
            // switch_case / switch_default: rhs = extra index to SubRange
            .switch_case, .switch_default => {
                if (data.rhs == .none) continue;
                const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
                const stmts = ctx.extraSlice(range);
                for (stmts, 0..) |raw, idx| {
                    if (raw == target_int) {
                        return ParentInfo{ .tag = tag, .child_count = @intCast(stmts.len), .child_index = @intCast(idx) };
                    }
                }
            },
            else => {},
        }
    }
    return null;
}

/// Returns true if the block contains any block-scoped declaration
/// (let, const, or class). Function declarations in strict mode also
/// create block scope, but we skip that check.
fn blockHasScopedDecl(node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(node);
    const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
    const stmts = ctx.extraSlice(range);
    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        switch (ctx.nodeTag(stmt)) {
            .let_decl, .const_decl, .class_decl => return true,
            else => {},
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const parent = findParent(node, ctx) orelse return;

    // Determine if this block is in a "lone" position
    const is_lone = switch (parent.tag) {
        .root, .block_stmt, .static_block => true,
        // Switch case: lone unless this block is the sole statement in the case
        .switch_case, .switch_default => !(parent.child_count == 1 and parent.child_index == 0),
        else => false,
    };

    if (!is_lone) return;

    // ES6 logic: if the block contains block-scoped declarations, it may be valid.
    // Exception: if the parent is a block/static_block with only this one child,
    // the block is still redundant (removing it is equivalent).
    const has_scoped = blockHasScopedDecl(node, ctx);
    if (has_scoped) {
        const parent_is_block = parent.tag == .block_stmt or parent.tag == .static_block;
        if (!(parent_is_block and parent.child_count == 1)) return;
    }

    ctx.report(node, meta.name, "Block is unnecessary", meta.default_severity);
}

pub fn runOnSymbols(_: *const LintContext) void {}
