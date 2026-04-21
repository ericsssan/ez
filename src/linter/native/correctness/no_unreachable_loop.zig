const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unreachable-loop",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow loops with a body that allows only one iteration",
};

pub const needs_semantic = true;
pub const needs_cfg = true;

pub const relevant_tags = [_]Node.Tag{
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
    .for_await_of_stmt,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Check the `ignore` option: list of loop type names to skip.
    if (ctx.rule_options) |opts| {
        if (opts.* == .object) {
            if (opts.object.get("ignore")) |ignore_val| {
                if (ignore_val == .array) {
                    const tag = ctx.nodeTag(node);
                    for (ignore_val.array.items) |item| {
                        if (item != .string) continue;
                        if (tagMatchesIgnoreName(tag, item.string)) return;
                    }
                }
            }
        }
    }

    // Use the Zig semantic analyzer's precomputed loop_exit_reachable.
    // body_alive = false means the loop body always exits on every path
    // (all paths return/throw, nested infinite loops, switch with all cases returning).
    // body_alive = true means the body CAN complete and loop back for another iteration.
    if (!ctx.loopBodyCanIterate(node)) {
        ctx.report(node);
    }
}

fn tagMatchesIgnoreName(tag: Node.Tag, name: []const u8) bool {
    return switch (tag) {
        .while_stmt => std.mem.eql(u8, name, "WhileStatement"),
        .do_while_stmt => std.mem.eql(u8, name, "DoWhileStatement"),
        .for_stmt => std.mem.eql(u8, name, "ForStatement"),
        .for_in_stmt => std.mem.eql(u8, name, "ForInStatement"),
        .for_of_stmt, .for_await_of_stmt => std.mem.eql(u8, name, "ForOfStatement"),
        else => false,
    };
}
