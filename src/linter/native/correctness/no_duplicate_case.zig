const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.switch_stmt};

pub const meta = RuleMeta{
    .name = "no-duplicate-case",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate case labels in switch statements",
};

/// Append a canonical representation of `node` to `buf` by recursively
/// concatenating token texts separated by `|` (tag separator) and `/` (node separator).
/// This mirrors ESLint's equalTokens() which compares type+value of all tokens.
fn appendKey(node: NodeIndex, ctx: *const LintContext, buf: *std.ArrayListUnmanaged(u8), allocator: std.mem.Allocator) void {
    if (node == .none) return;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    // Append the main token text (represents the node's primary operator/name/value)
    const tok_text = ctx.tokenText(ctx.nodeMainToken(node));
    buf.appendSlice(allocator, tok_text) catch return;
    buf.append(allocator, '|') catch return;

    switch (tag) {
        // Leaf nodes: main token is everything
        .identifier, .this_expr, .super_expr,
        .number_literal, .string_literal, .boolean_literal,
        .null_literal, .bigint_literal, .regex_literal,
        => {},

        // Template literals
        .template_literal => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| {
                appendKey(@enumFromInt(raw), ctx, buf, allocator);
            }
        },

        // Member expressions: recurse into object, property is a real node in rhs
        .member_expr, .optional_member_expr => {
            appendKey(data.lhs, ctx, buf, allocator);
            const prop = ctx.memberPropertyName(data.rhs);
            buf.appendSlice(allocator, prop) catch return;
            buf.append(allocator, '|') catch return;
        },
        .computed_member_expr, .optional_computed_member_expr => {
            appendKey(data.lhs, ctx, buf, allocator);
            appendKey(data.rhs, ctx, buf, allocator);
        },

        // Call expressions
        .call_expr, .optional_call_expr, .new_expr => {
            appendKey(data.lhs, ctx, buf, allocator);
            if (data.rhs != .none) {
                const r = ctx.extraData(SubRange, @intFromEnum(data.rhs));
                for (ctx.extraSlice(r)) |raw| {
                    appendKey(@enumFromInt(raw), ctx, buf, allocator);
                }
            }
        },

        // Unary expressions
        .unary_plus, .unary_minus, .logical_not, .bitwise_not,
        .void_expr, .typeof_expr, .delete_expr,
        .spread_element, .await_expr,
        => appendKey(data.lhs, ctx, buf, allocator),

        // Conditional: lhs=condition, rhs=extra index to Conditional
        .conditional => {
            const cond_data = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            appendKey(data.lhs, ctx, buf, allocator);
            appendKey(cond_data.consequent, ctx, buf, allocator);
            appendKey(cond_data.alternate, ctx, buf, allocator);
        },

        // Sequence: direct SubRange
        .sequence_expr => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| appendKey(@enumFromInt(raw), ctx, buf, allocator);
        },

        // Grouping: just recurse into lhs
        .grouping_expr => appendKey(data.lhs, ctx, buf, allocator),

        // Array/object literals: lhs=range.start, rhs=range.end (direct SubRange)
        .array_literal, .object_literal => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| appendKey(@enumFromInt(raw), ctx, buf, allocator);
        },

        // Binary and logical
        else => {
            if (data.lhs != .none) appendKey(data.lhs, ctx, buf, allocator);
            if (data.rhs != .none) appendKey(data.rhs, ctx, buf, allocator);
        },
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;

    const sub_range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
    const cases = ctx.extraSlice(sub_range);

    // Build keys for each case expression and compare
    // Using ArrayList of strings since N is small
    var keys: std.ArrayList([]u8) = .empty;
    defer {
        for (keys.items) |k| ctx.allocator.free(k);
        keys.deinit(ctx.allocator);
    }

    for (cases) |case_idx| {
        const case_node: NodeIndex = @enumFromInt(case_idx);
        const case_tag = ctx.nodeTag(case_node);
        if (case_tag != .switch_case) continue;

        const test_expr = ctx.nodeData(case_node).lhs;
        if (test_expr == .none) continue;

        // Build key for this case expression
        var buf: std.ArrayListUnmanaged(u8) = .empty;
        appendKey(test_expr, ctx, &buf, ctx.allocator);
        const key = buf.toOwnedSlice(ctx.allocator) catch continue;

        // Check for duplicate
        var is_dup = false;
        for (keys.items) |prev_key| {
            if (std.mem.eql(u8, prev_key, key)) {
                is_dup = true;
                break;
            }
        }

        if (is_dup) {
            ctx.allocator.free(key);
            ctx.report(case_node);
        } else {
            keys.append(ctx.allocator, key) catch {
                ctx.allocator.free(key);
            };
        }
    }
}

pub fn runOnSymbols(_: *const LintContext) void {}
