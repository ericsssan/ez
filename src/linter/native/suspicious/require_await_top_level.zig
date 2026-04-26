const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "require-unicode-regexp",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Enforce the use of u or v flag on RegExp",
};

pub const relevant_tags = [_]Node.Tag{ .regex_literal, .new_expr };

fn hasUnicodeFlag(text: []const u8) bool {
    // text = /pattern/flags or /pattern/
    // Find the closing / and then check flags
    if (text.len < 2) return false;
    var i: usize = 1;
    while (i < text.len) : (i += 1) {
        if (text[i] == '\\') {
            i += 1;
            continue;
        }
        if (text[i] == '/') break;
    }
    if (i >= text.len) return false; // no closing / found (malformed literal)
    i += 1; // move past closing /
    const flags = text[i..];
    return std.mem.indexOfScalar(u8, flags, 'u') != null or
           std.mem.indexOfScalar(u8, flags, 'v') != null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);

    if (tag == .regex_literal) {
        const text = ctx.tokenText(ctx.nodeMainToken(node));
        if (!hasUnicodeFlag(text)) {
            ctx.report(node);
        }
        return;
    }

    // new RegExp(pattern, flags) — check flags arg
    if (tag == .new_expr) {
        const data = ctx.nodeData(node);
        if (data.lhs == .none) return;
        if (ctx.nodeTag(data.lhs) != .identifier) return;
        const name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
        if (!std.mem.eql(u8, name, "RegExp")) return;

        if (data.rhs == .none) {
            ctx.report(node);
            return;
        }

        const range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
        const args = ctx.extraSlice(range);
        if (args.len < 2) {
            ctx.report(node);
            return;
        }

        // Check second arg (flags)
        const flags_arg: NodeIndex = @enumFromInt(args[1]);
        if (flags_arg == .none) {
            ctx.report(node);
            return;
        }
        if (ctx.nodeTag(flags_arg) != .string_literal) return; // dynamic flags — can't check

        const flags_text = ctx.tokenText(ctx.nodeMainToken(flags_arg));
        // flags_text is a quoted string like "gi" or 'u'
        if (std.mem.indexOfScalar(u8, flags_text, 'u') == null and
            std.mem.indexOfScalar(u8, flags_text, 'v') == null)
        {
            ctx.report(node);
        }
    }
}
