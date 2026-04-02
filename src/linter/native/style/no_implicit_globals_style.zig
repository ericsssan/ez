const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "vars-on-top",
    .category = .style,
    .default_severity = .warning,
    .description = "Require var declarations be placed at the top of their containing scope",
};

// Flag var declarations that are not the first statement in a function body.
// Simple check: if there are non-declaration statements before a var decl in a block.
pub const relevant_tags = [_]Node.Tag{ .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr };

fn checkVarsOnTop(body: NodeIndex, ctx: *const LintContext) void {
    if (body == .none) return;
    if (ctx.nodeTag(body) != .block_stmt) return;

    const bdata = ctx.nodeData(body);
    const start = @intFromEnum(bdata.lhs);
    const end = @intFromEnum(bdata.rhs);
    const stmts = ctx.extraSlice(.{ .start = start, .end = end });

    var seen_non_decl = false;
    for (stmts) |s_raw| {
        const stmt: NodeIndex = @enumFromInt(s_raw);
        if (stmt == .none) continue;
        const tag = ctx.nodeTag(stmt);
        switch (tag) {
            .var_decl => {
                if (seen_non_decl) {
                    ctx.report(stmt, meta.name, "var declarations should appear at the top of the function scope", meta.default_severity);
                }
            },
            // Function declarations and "use strict" are OK at top
            .fn_decl, .async_fn_decl, .generator_fn_decl => {},
            .expression_stmt => {
                // Allow "use strict"
                const edata = ctx.nodeData(stmt);
                if (edata.lhs != .none and ctx.nodeTag(edata.lhs) == .string_literal) {
                    const text = ctx.tokenText(ctx.nodeMainToken(edata.lhs));
                    if (std.mem.eql(u8, text, "\"use strict\"") or std.mem.eql(u8, text, "'use strict'")) {
                        continue;
                    }
                }
                seen_non_decl = true;
            },
            else => { seen_non_decl = true; },
        }
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const fn_data = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
    checkVarsOnTop(fn_data.body, ctx);
}
