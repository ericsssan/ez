const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("../../../parser/span.zig").Span;

pub const relevant_tags = [_]Node.Tag{ .empty_stmt, .class_body };
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-extra-semi",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow unnecessary semicolons",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    if (tag == .class_body) {
        // Semicolons in class bodies are always extra — scan tokens in the body
        const main_tok = ctx.nodeMainToken(node); // the `{` token
        const tok_count = ctx.ast.tokens.len;

        var depth: u32 = 0;
        var t: u32 = main_tok;
        while (t < tok_count) : (t += 1) {
            const tt = ctx.tokenTag(t);
            switch (tt) {
                .l_brace => depth += 1,
                .r_brace => {
                    if (depth == 0) break;
                    depth -= 1;
                    if (depth == 0) break;
                },
                .semicolon => {
                    if (depth == 1) {
                        // Only flag "extra" semicolons: those that are standalone (not terminating a property).
                        // A semicolon is extra if preceded by `{`, `}`, or another `;`.
                        // It's NOT extra if it terminates a class field (preceded by identifier, `]`, etc.)
                        if (t > 0) {
                            const prev = ctx.tokenTag(t - 1);
                            switch (prev) {
                                .l_brace, .r_brace, .semicolon => {
                                    const pos = ctx.tokenStart(t);
                                    ctx.reportSpan(.{ .start = pos, .end = pos + 1 });
                                },
                                else => {},
                            }
                        } else {
                            const pos = ctx.tokenStart(t);
                            ctx.reportSpan(.{ .start = pos, .end = pos + 1 });
                        }
                    }
                },
                else => {},
            }
        }
        return;
    }

    // An empty statement is intentional (not "extra") when it is the body of:
    // for, for-in, for-of, while, do-while, if, label, with statements.
    // In these cases, the empty statement IS the required statement.
    const parent = ctx.parentOf(node);
    if (parent != .none) {
        switch (ctx.nodeTag(parent)) {
            .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
            .while_stmt, .do_while_stmt,
            .if_stmt, .if_else_stmt,
            .labeled_stmt,
            .with_stmt,
            => return,
            else => {},
        }
    }

    ctx.report(node);
}
