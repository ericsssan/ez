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

/// Look up `target`'s parent via the pre-computed parent-indices array, then
/// locate `target` within the parent's statement list.  Returns null when the
/// parent is not a statement-list holder (e.g. body of `if`/`for`/`while`).
fn findParent(target: NodeIndex, ctx: *const LintContext) ?ParentInfo {
    const parent = ctx.parentOf(target);
    if (parent == .none) return null;
    const tag = ctx.nodeTag(parent);
    const data = ctx.nodeData(parent);

    const stmts: []const u32 = switch (tag) {
        .root, .block_stmt, .static_block => blk: {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            break :blk ctx.extraSlice(range);
        },
        .switch_case, .switch_default => blk: {
            if (data.rhs == .none) return null;
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            break :blk ctx.extraSlice(range);
        },
        else => return null,
    };

    const target_int = @intFromEnum(target);
    for (stmts, 0..) |raw, idx| {
        if (raw == target_int) {
            return ParentInfo{ .tag = tag, .child_count = @intCast(stmts.len), .child_index = @intCast(idx) };
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
            .let_decl, .const_decl, .class_decl,
            // Function declarations in blocks create block scope in strict mode
            // and are implementation-defined in sloppy mode — the block is needed.
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => return true,
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

    ctx.report(node);
}

pub fn runOnSymbols(_: *const LintContext) void {}
