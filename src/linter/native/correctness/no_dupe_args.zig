const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    .fn_decl,
    .async_fn_decl,
    .generator_fn_decl,
    .async_generator_fn_decl,
    .fn_expr,
    .async_fn_expr,
    .generator_fn_expr,
    .async_generator_fn_expr,
    .arrow_fn,
    .async_arrow_fn,
};

pub const meta = RuleMeta{
    .name = "no-dupe-args",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate parameter names in function declarations",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);

    var params_start: u32 = undefined;
    var params_end: u32 = undefined;

    switch (tag) {
        .arrow_fn, .async_arrow_fn => {
            const arrow_data = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            params_start = arrow_data.params_start;
            params_end = arrow_data.params_end;
        },
        .fn_decl,
        .async_fn_decl,
        .generator_fn_decl,
        .async_generator_fn_decl,
        .fn_expr,
        .async_fn_expr,
        .generator_fn_expr,
        .async_generator_fn_expr,
        => {
            const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            params_start = fn_data.params;
            params_end = fn_data.params_end;
        },
        else => return,
    }

    if (params_start == params_end) return;

    const sub_range = ast.SubRange{ .start = params_start, .end = params_end };
    const param_indices = ctx.extraSlice(sub_range);

    var seen = std.StringHashMap(void).init(ctx.allocator);
    defer seen.deinit();

    for (param_indices) |raw_idx| {
        const param_idx: NodeIndex = @enumFromInt(raw_idx);
        const name = resolveParamName(param_idx, ctx) orelse continue;

        const result = seen.getOrPut(name) catch continue;
        if (result.found_existing) {
            ctx.report(param_idx);
        }
    }
}

fn resolveParamName(param_idx: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const param_tag = ctx.nodeTag(param_idx);
    switch (param_tag) {
        .identifier => {
            const token = ctx.nodeMainToken(param_idx);
            return ctx.tokenText(token);
        },
        .assignment_pattern => {
            // LHS of assignment pattern is the binding
            const param_data = ctx.nodeData(param_idx);
            const lhs = param_data.lhs;
            if (lhs == .none) return null;
            if (ctx.nodeTag(lhs) == .identifier) {
                const token = ctx.nodeMainToken(lhs);
                return ctx.tokenText(token);
            }
            return null;
        },
        else => return null, // destructuring patterns — skip for v0.3
    }
}
