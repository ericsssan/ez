const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-explicit-any",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow the `any` type",
    .lang = .ts_only,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const token = ctx.nodeMainToken(node);
    const text = ctx.tokenText(token);
    if (!std.mem.eql(u8, text, "any")) return;

    const ignore_rest_args = blk: {
        if (ctx.getOptions()) |o| switch (o.*) {
            .object => |obj| {
                if (obj.get("ignoreRestArgs")) |v| {
                    if (v == .bool) break :blk v.bool;
                }
            },
            else => {},
        };
        break :blk false;
    };

    if (ignore_rest_args) {
        // Walk up the type tree. If we hit rest_element with an array-like wrapper, skip.
        // `ignoreRestArgs` only ignores `any` inside array types (any[], Array<any>, ReadonlyArray<any>).
        // Plain `...args: any` is still reported.
        var current = ctx.parentOf(node);
        var in_array_like = false;
        var depth: u32 = 0;
        while (current != .none and depth < 10) : (depth += 1) {
            const tag = ctx.nodeTag(current);
            if (tag == .rest_element) {
                if (in_array_like) return;
                break;
            }
            switch (tag) {
                // Array type wrappers.
                .ts_array_type, .ts_keyof_type => {
                    in_array_like = true;
                    current = ctx.parentOf(current);
                },
                // ts_type_reference: Array<any> or ReadonlyArray<any> — the `any` is a type arg.
                // The parent ts_type_reference is the Array/ReadonlyArray wrapper.
                .ts_type_reference => {
                    in_array_like = true;
                    current = ctx.parentOf(current);
                },
                .ts_type_annotation, .identifier => { current = ctx.parentOf(current); },
                else => break,
            }
        }
    }

    ctx.report(node);
}
