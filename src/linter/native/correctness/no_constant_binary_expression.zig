const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-constant-binary-expression",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow expressions where the operation doesn't affect the value",
};

pub const relevant_tags = [_]Node.Tag{
    .equal, .not_equal, .strict_equal, .strict_not_equal,
    .logical_or, .logical_and,
};

fn isAlwaysDefined(tag: Node.Tag) bool {
    return switch (tag) {
        .number_literal, .string_literal, .boolean_literal,
        .array_literal, .object_literal, .regex_literal,
        .fn_expr, .arrow_fn, .async_fn_expr, .async_arrow_fn,
        .class_expr, .new_expr, .template_literal,
        => true,
        else => false,
    };
}

fn isNullOrUndefined(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    if (tag == .null_literal) return true;
    if (tag == .identifier) {
        return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "undefined");
    }
    return false;
}

fn isAlwaysTruthy(node: NodeIndex, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(node);
    return switch (tag) {
        .array_literal, .object_literal, .regex_literal,
        .fn_expr, .arrow_fn, .async_fn_expr, .async_arrow_fn,
        .class_expr, .new_expr, .template_literal,
        => true,
        .string_literal => {
            const text = ctx.tokenText(ctx.nodeMainToken(node));
            return text.len > 2;
        },
        .number_literal => {
            const text = ctx.tokenText(ctx.nodeMainToken(node));
            return !std.mem.eql(u8, text, "0") and !std.mem.eql(u8, text, "0.0");
        },
        .boolean_literal => {
            return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), "true");
        },
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    const rhs = data.rhs;
    if (lhs == .none or rhs == .none) return;

    switch (tag) {
        .equal, .not_equal, .strict_equal, .strict_not_equal => {
            const lhs_tag = ctx.nodeTag(lhs);
            const rhs_tag = ctx.nodeTag(rhs);
            if (isAlwaysDefined(lhs_tag) and isNullOrUndefined(rhs, ctx)) {
                ctx.report(node, meta.name, "Constant binary expression: result is always false", meta.default_severity);
                return;
            }
            if (isAlwaysDefined(rhs_tag) and isNullOrUndefined(lhs, ctx)) {
                ctx.report(node, meta.name, "Constant binary expression: result is always false", meta.default_severity);
                return;
            }
        },
        .logical_or => {
            if (isAlwaysTruthy(lhs, ctx)) {
                ctx.report(node, meta.name, "Constant binary expression: left side is always truthy, right side is never reached", meta.default_severity);
            }
        },
        .logical_and => {
            const lhs_tag = ctx.nodeTag(lhs);
            if (lhs_tag == .boolean_literal) {
                if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(lhs)), "false")) {
                    ctx.report(node, meta.name, "Constant binary expression: result is always false", meta.default_severity);
                    return;
                }
            }
            if (lhs_tag == .null_literal) {
                ctx.report(node, meta.name, "Constant binary expression: left side is always null", meta.default_severity);
            }
        },
        else => {},
    }
}
