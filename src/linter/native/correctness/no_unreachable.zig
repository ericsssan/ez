const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unreachable code after return, throw, break, or continue",
};

pub const needs_semantic = true;
pub const needs_cfg = true;

pub const relevant_tags = [_]Node.Tag{.block_stmt};

/// Check if a var_decl has any initializer (var x = ...).
fn varDeclHasInitializer(node: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(node);
    const declarators = ctx.extraSlice(.{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) });
    for (declarators) |d| {
        const decl: NodeIndex = @enumFromInt(d);
        if (decl == .none) continue;
        const decl_data = ctx.nodeData(decl);
        if (decl_data.rhs != .none) return true; // has initializer
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range = SubRange{
        .start = @intFromEnum(data.lhs),
        .end = @intFromEnum(data.rhs),
    };
    const stmts = ctx.extraSlice(range);

    // Use Zig semantic analyzer's precomputed node reachability.
    // This handles all control flow: if-else, try-catch, switch, loops.
    var reported_start = false;
    for (stmts) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        if (stmt == .none) continue;

        if (!ctx.nodeReachable(stmt)) {
            // Skip function/class declarations — they're hoisted and always "reachable"
            const tag = ctx.nodeTag(stmt);
            if (tag == .fn_decl or tag == .async_fn_decl or
                tag == .generator_fn_decl or tag == .async_generator_fn_decl or
                tag == .class_decl)
            {
                continue;
            }
            // Skip var declarations without initializer — hoisted, not truly unreachable.
            // var with initializer (var x = 5) IS unreachable (the assignment part).
            if (tag == .var_decl and !varDeclHasInitializer(stmt, ctx)) continue;
            // Only report the first unreachable statement in a consecutive run
            if (!reported_start) {
                ctx.report(stmt);
                reported_start = true;
            }
        } else {
            reported_start = false;
        }
    }
}
