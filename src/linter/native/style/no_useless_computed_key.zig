const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    .computed_property,
    .computed_method_def,
    .computed_property_def,
    .computed_getter_def,
    .computed_setter_def,
};
pub const needs_semantic = true;

pub const meta = RuleMeta{
    .name = "no-useless-computed-key",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary computed property keys (e.g., `{[\"x\"]: y}`)",
};

/// Unwrap parentheses to find the actual key expression.
fn unwrapGrouping(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var current = node;
    var depth: u32 = 0;
    while (current != .none and depth < 5) : (depth += 1) {
        if (ctx.nodeTag(current) != .grouping_expr) break;
        current = ctx.nodeData(current).lhs;
    }
    return current;
}

fn isClassMemberTag(tag: Node.Tag) bool {
    return switch (tag) {
        .computed_method_def, .computed_property_def,
        .computed_getter_def, .computed_setter_def,
        => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    const key = data.lhs;
    if (key == .none) return;

    // For class members, check `enforceForClassMembers` option (default: false).
    if (isClassMemberTag(tag)) {
        const enforce = blk: {
            if (ctx.getOptions()) |o| if (o.* == .object) {
                if (o.object.get("enforceForClassMembers")) |v|
                    if (v == .bool) break :blk v.bool;
            };
            break :blk false; // default: false (don't check class members)
        };
        if (!enforce) return;
    }

    // Unwrap grouping: [('x')] → x
    const key_inner = unwrapGrouping(key, ctx);
    if (key_inner == .none) return;

    const key_tag = ctx.nodeTag(key_inner);
    if (key_tag != .string_literal and key_tag != .number_literal) return;

    const key_text = blk: {
        const tok_text = ctx.tokenText(ctx.nodeMainToken(key_inner));
        // Strip quotes for string literals.
        if (key_tag == .string_literal and tok_text.len >= 2)
            break :blk tok_text[1 .. tok_text.len - 1];
        break :blk tok_text;
    };

    // Special keys in object literals: __proto__ sets the prototype — don't simplify.
    if (tag == .computed_property) {
        if (std.mem.eql(u8, key_text, "__proto__")) {
            // In object LITERAL (not destructuring), __proto__ has special meaning.
            // In destructuring (object_pattern), it's just a property name.
            const parent = ctx.parentOf(node);
            const is_literal = parent != .none and ctx.nodeTag(parent) == .object_literal;
            if (is_literal) return;
        }
    }

    // Special keys in class members: constructor (non-static) and static prototype.
    if (isClassMemberTag(tag)) {
        const main_tok = ctx.nodeMainToken(node);
        const is_static = main_tok > 0 and
            std.mem.eql(u8, ctx.tokenText(main_tok - 1), "static");

        // Non-static `constructor` in a class: reserved name.
        if (!is_static and std.mem.eql(u8, key_text, "constructor")) return;
        // `static prototype` in a class: reserved name.
        if (is_static and std.mem.eql(u8, key_text, "prototype")) return;
        // `static constructor` as a CLASS FIELD (not method): reserved.
        if (is_static and std.mem.eql(u8, key_text, "constructor") and
            tag == .computed_property_def) return;
    }

    ctx.report(node);
}
