const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "valid-typeof",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Enforce comparing typeof expressions against valid strings",
};

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal, .strict_equal, .strict_not_equal };
pub const needs_semantic = true;

const valid_typeof_values = [_][]const u8{
    "undefined",
    "object",
    "boolean",
    "number",
    "string",
    "function",
    "symbol",
    "bigint",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const require_string_literals = ctx.getOptionBool("requireStringLiterals", false);

    // Check both orientations: typeof on left or right
    const pairs = [_][2]NodeIndex{ .{ data.lhs, data.rhs }, .{ data.rhs, data.lhs } };
    for (pairs) |pair| {
        if (isTypeofExpr(pair[0], ctx) and isInvalidComparisonValue(pair[1], ctx, require_string_literals)) {
            ctx.report(node);
            return;
        }
    }
}

fn isTypeofExpr(idx: NodeIndex, ctx: *const LintContext) bool {
    if (idx == .none) return false;
    return ctx.nodeTag(idx) == .typeof_expr;
}

/// Returns true if the node is an invalid value to compare typeof against.
fn isInvalidComparisonValue(idx: NodeIndex, ctx: *const LintContext, require_string_literals: bool) bool {
    if (idx == .none) return false;
    const tag = ctx.nodeTag(idx);

    // String literal: check if content is a valid typeof value
    if (tag == .string_literal) {
        const raw = ctx.tokenText(ctx.nodeMainToken(idx));
        if (raw.len < 2) return true;
        const inner = raw[1 .. raw.len - 1];
        for (valid_typeof_values) |valid| {
            if (std.mem.eql(u8, inner, valid)) return false;
        }
        return true;
    }

    // Template literal: check for static vs dynamic templates
    if (tag == .template_literal) {
        const tok = ctx.nodeMainToken(idx);
        const src = ctx.source();
        const start = ctx.tokenStart(tok);
        if (start >= src.len or src[start] != '`') return require_string_literals;
        var end = start + 1;
        while (end < src.len and src[end] != '`' and src[end] != '$') : (end += 1) {}
        // If we hit '$' (substitution) → dynamic template
        if (end >= src.len or src[end] != '`') return require_string_literals;
        // Static template: check if value is valid
        const inner = src[start + 1 .. end];
        for (valid_typeof_values) |valid| {
            if (std.mem.eql(u8, inner, valid)) return false;
        }
        return true;
    }

    // Identifier named 'undefined' that is the global undefined (not locally redefined)
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(idx));
        if (std.mem.eql(u8, name, "undefined")) {
            // Check if it resolves to an implicit global (not declared in source)
            const refs = ctx.references();
            var i: u32 = 0;
            while (i < refs.count()) : (i += 1) {
                const ref_id = @import("../../../parser/reference.zig").ReferenceId.fromInt(i);
                if (refs.getNode(ref_id) != idx) continue;
                // If the reference is unresolved, it's the global undefined
                if (!refs.isResolved(ref_id)) return true;
                // Resolved = locally defined
                return false;
            }
            // No reference found → treat as implicit global
            return true;
        }
        // Any other identifier with requireStringLiterals: true should be flagged
        return require_string_literals;
    }

    // typeof expressions are valid to compare against (e.g. typeof foo === typeof bar)
    if (tag == .typeof_expr) return false;

    // Any other non-string value: flag if requireStringLiterals is true
    return require_string_literals;
}
