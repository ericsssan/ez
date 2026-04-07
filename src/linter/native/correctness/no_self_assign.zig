const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-self-assign",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow assignments where both sides are exactly the same",
};

pub const relevant_tags = [_]Node.Tag{
    .assign,
    // Logical assignments: a &&= a, a ||= a, a ??= a
    .logical_and_assign, .logical_or_assign, .nullish_assign,
};

const MSG = "'{s}' is assigned to itself";

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    checkAssignment(data.lhs, data.rhs, ctx);
}

fn checkAssignment(lhs: NodeIndex, rhs: NodeIndex, ctx: *const LintContext) void {
    if (lhs == .none or rhs == .none) return;

    const lhs_tag = ctx.nodeTag(lhs);
    const rhs_tag = ctx.nodeTag(rhs);

    // Simple identifier = identifier
    if (lhs_tag == .identifier and rhs_tag == .identifier) {
        const lhs_name = ctx.tokenText(ctx.nodeMainToken(lhs));
        const rhs_name = ctx.tokenText(ctx.nodeMainToken(rhs));
        if (std.mem.eql(u8, lhs_name, rhs_name)) {
            // Report on the lhs node
            // Use a static buffer for the message
            var buf: [128]u8 = undefined;
            const msg = std.fmt.bufPrint(&buf, MSG, .{lhs_name}) catch MSG_DEFAULT;
            _ = msg;
            ctx.report(lhs, meta.name, "'{s}' is assigned to itself", meta.default_severity);
        }
        return;
    }

    // array_pattern = array_literal: [a, b] = [a, b]
    if (lhs_tag == .array_pattern and rhs_tag == .array_literal) {
        compareArrayPatternToArray(lhs, rhs, ctx);
        return;
    }

    // object_pattern = object_literal: ({a} = {a})
    if (lhs_tag == .object_pattern and rhs_tag == .object_literal) {
        compareObjectPatternToObject(lhs, rhs, ctx);
        return;
    }

    // Member expressions: a.b = a.b, a[b] = a[b]
    const is_lhs_member = lhs_tag == .member_expr or lhs_tag == .optional_member_expr;
    const is_rhs_member = rhs_tag == .member_expr or rhs_tag == .optional_member_expr;
    const is_lhs_computed = lhs_tag == .computed_member_expr or lhs_tag == .optional_computed_member_expr;
    const is_rhs_computed = rhs_tag == .computed_member_expr or rhs_tag == .optional_computed_member_expr;

    if ((is_lhs_member and is_rhs_member) or (is_lhs_computed and is_rhs_computed)) {
        if (areSameNode(lhs, rhs, ctx)) {
            ctx.report(lhs, meta.name, "Property is assigned to itself", meta.default_severity);
        }
        return;
    }

    // Mixed member vs member (cross optional/non-optional)
    if ((is_lhs_member or is_lhs_computed) and (is_rhs_member or is_rhs_computed)) {
        if (areSameNode(lhs, rhs, ctx)) {
            ctx.report(lhs, meta.name, "Property is assigned to itself", meta.default_severity);
        }
        return;
    }
}

const MSG_DEFAULT = "'...' is assigned to itself";

/// Returns true if two AST nodes represent the exact same expression.
/// Handles identifiers, member expressions, computed member expressions, string literals.
fn areSameNode(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == .none and b == .none) return true;
    if (a == .none or b == .none) return false;

    const a_tag = ctx.nodeTag(a);
    const b_tag = ctx.nodeTag(b);
    if (a_tag != b_tag) {
        // Allow optional vs non-optional member expr to match (a.b vs a?.b)
        const a_is_member = a_tag == .member_expr or a_tag == .optional_member_expr;
        const b_is_member = b_tag == .member_expr or b_tag == .optional_member_expr;
        if (a_is_member and b_is_member) {
            // Fall through to compare data
        } else {
            return false;
        }
    }

    switch (a_tag) {
        .identifier => {
            return std.mem.eql(u8,
                ctx.tokenText(ctx.nodeMainToken(a)),
                ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .member_expr, .optional_member_expr => {
            const a_data = ctx.nodeData(a);
            const b_data = ctx.nodeData(b);
            // Object must match
            if (!areSameNode(a_data.lhs, b_data.lhs, ctx)) return false;
            // Property name is the main token of the node
            return std.mem.eql(u8,
                ctx.tokenText(ctx.nodeMainToken(a)),
                ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .computed_member_expr, .optional_computed_member_expr => {
            const a_data = ctx.nodeData(a);
            const b_data = ctx.nodeData(b);
            if (!areSameNode(a_data.lhs, b_data.lhs, ctx)) return false;
            return areSameNode(a_data.rhs, b_data.rhs, ctx);
        },
        .string_literal, .number_literal => {
            return std.mem.eql(u8,
                ctx.tokenText(ctx.nodeMainToken(a)),
                ctx.tokenText(ctx.nodeMainToken(b)));
        },
        .this_expr => return true,
        .grouping_expr => {
            // Unwrap parentheses
            const a_inner = ctx.nodeData(a).lhs;
            const b_inner = ctx.nodeData(b).lhs;
            return areSameNode(a_inner, b_inner, ctx);
        },
        else => return false,
    }
}

fn compareArrayPatternToArray(lhs_pat: NodeIndex, rhs_arr: NodeIndex, ctx: *const LintContext) void {
    const lhs_data = ctx.nodeData(lhs_pat);
    const rhs_data = ctx.nodeData(rhs_arr);

    const lhs_range = SubRange{ .start = @intFromEnum(lhs_data.lhs), .end = @intFromEnum(lhs_data.rhs) };
    const rhs_range = SubRange{ .start = @intFromEnum(rhs_data.lhs), .end = @intFromEnum(rhs_data.rhs) };

    const lhs_items = ctx.extraSlice(lhs_range);
    const rhs_items = ctx.extraSlice(rhs_range);

    const len = @min(lhs_items.len, rhs_items.len);
    var i: usize = 0;
    while (i < len) : (i += 1) {
        const lhs_elem: NodeIndex = @enumFromInt(lhs_items[i]);
        var rhs_elem: NodeIndex = @enumFromInt(rhs_items[i]);

        if (lhs_elem == .none or rhs_elem == .none) continue;

        // Unwrap assignment_pattern default: [a = 1] = [a]
        var lhs_target = lhs_elem;
        if (ctx.nodeTag(lhs_elem) == .assignment_pattern) {
            lhs_target = ctx.nodeData(lhs_elem).lhs;
        }

        // Unwrap spread_element: [...a] = [...a]
        var rhs_actual = rhs_elem;
        if (ctx.nodeTag(rhs_elem) == .spread_element) {
            rhs_actual = ctx.nodeData(rhs_elem).lhs;
        }
        var lhs_actual = lhs_target;
        if (ctx.nodeTag(lhs_target) == .rest_element) {
            lhs_actual = ctx.nodeData(lhs_target).lhs;
            // rhs must also be spread
            if (ctx.nodeTag(rhs_elem) != .spread_element) continue;
        }
        rhs_elem = rhs_actual;

        // Recurse for nested patterns
        const lhs_t = ctx.nodeTag(lhs_actual);
        const rhs_t = ctx.nodeTag(rhs_elem);
        if (lhs_t == .array_pattern and rhs_t == .array_literal) {
            compareArrayPatternToArray(lhs_actual, rhs_elem, ctx);
        } else if (lhs_t == .object_pattern and rhs_t == .object_literal) {
            compareObjectPatternToObject(lhs_actual, rhs_elem, ctx);
        } else {
            checkAssignment(lhs_actual, rhs_elem, ctx);
        }
    }
}

fn compareObjectPatternToObject(lhs_pat: NodeIndex, rhs_obj: NodeIndex, ctx: *const LintContext) void {
    // For object patterns, match properties by key
    // This is complex for computed keys; focus on simple shorthand properties
    // For now, check shorthand properties: {a, b} = {a, b}
    // We iterate lhs props and try to find matching rhs prop
    const lhs_data = ctx.nodeData(lhs_pat);
    const lhs_range = SubRange{ .start = @intFromEnum(lhs_data.lhs), .end = @intFromEnum(lhs_data.rhs) };
    const lhs_items = ctx.extraSlice(lhs_range);

    const rhs_data = ctx.nodeData(rhs_obj);
    const rhs_range = SubRange{ .start = @intFromEnum(rhs_data.lhs), .end = @intFromEnum(rhs_data.rhs) };
    const rhs_items = ctx.extraSlice(rhs_range);

    // For each lhs property (simple shorthand or keyed), find matching rhs property
    for (lhs_items) |lhs_raw| {
        const lhs_prop: NodeIndex = @enumFromInt(lhs_raw);
        if (lhs_prop == .none) continue;
        const lhs_prop_tag = ctx.nodeTag(lhs_prop);

        var lhs_key: NodeIndex = .none;
        var lhs_val: NodeIndex = .none;

        switch (lhs_prop_tag) {
            .shorthand_property => {
                // shorthand_property: lhs = key/value (same identifier)
                lhs_key = ctx.nodeData(lhs_prop).lhs;
                lhs_val = lhs_key;
            },
            .property => {
                // property: lhs = key, rhs = value
                lhs_key = ctx.nodeData(lhs_prop).lhs;
                lhs_val = ctx.nodeData(lhs_prop).rhs;
                // Unwrap assignment_pattern default: {a = 1} → value is assignment_pattern
                if (ctx.nodeTag(lhs_val) == .assignment_pattern) {
                    lhs_val = ctx.nodeData(lhs_val).lhs;
                }
            },
            .rest_element => {
                // ...a = ...a
                // Find matching rest in rhs
                const lhs_rest_arg = ctx.nodeData(lhs_prop).lhs;
                for (rhs_items) |rhs_raw| {
                    const rhs_prop: NodeIndex = @enumFromInt(rhs_raw);
                    if (rhs_prop == .none) continue;
                    if (ctx.nodeTag(rhs_prop) != .spread_element) continue;
                    const rhs_spread_arg = ctx.nodeData(rhs_prop).lhs;
                    checkAssignment(lhs_rest_arg, rhs_spread_arg, ctx);
                    break;
                }
                continue;
            },
            else => continue,
        }

        if (lhs_key == .none or lhs_val == .none) continue;

        // Find matching property in rhs by key
        for (rhs_items) |rhs_raw| {
            const rhs_prop: NodeIndex = @enumFromInt(rhs_raw);
            if (rhs_prop == .none) continue;
            const rhs_prop_tag = ctx.nodeTag(rhs_prop);

            var rhs_key: NodeIndex = .none;
            var rhs_val: NodeIndex = .none;

            switch (rhs_prop_tag) {
                .shorthand_property => {
                    rhs_key = ctx.nodeData(rhs_prop).lhs;
                    rhs_val = rhs_key;
                },
                .property => {
                    rhs_key = ctx.nodeData(rhs_prop).lhs;
                    rhs_val = ctx.nodeData(rhs_prop).rhs;
                },
                else => continue,
            }

            if (rhs_key == .none) continue;

            // Check if keys match (same identifier name or same string)
            if (keysMatch(lhs_key, rhs_key, ctx)) {
                // Recurse for value comparison
                const lhs_v_tag = ctx.nodeTag(lhs_val);
                const rhs_v_tag = ctx.nodeTag(rhs_val);
                if (lhs_v_tag == .array_pattern and rhs_v_tag == .array_literal) {
                    compareArrayPatternToArray(lhs_val, rhs_val, ctx);
                } else if (lhs_v_tag == .object_pattern and rhs_v_tag == .object_literal) {
                    compareObjectPatternToObject(lhs_val, rhs_val, ctx);
                } else {
                    checkAssignment(lhs_val, rhs_val, ctx);
                }
                break;
            }
        }
    }
}

/// Returns true if two property keys represent the same key (both identifiers with same name,
/// or one identifier and one string literal with the same content, etc.)
fn keysMatch(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) bool {
    if (a == .none or b == .none) return false;
    const a_tag = ctx.nodeTag(a);
    const b_tag = ctx.nodeTag(b);

    const a_text = blk: {
        if (a_tag == .identifier) break :blk ctx.tokenText(ctx.nodeMainToken(a));
        if (a_tag == .string_literal) {
            const t = ctx.tokenText(ctx.nodeMainToken(a));
            break :blk if (t.len >= 2) t[1 .. t.len - 1] else t;
        }
        if (a_tag == .number_literal) break :blk ctx.tokenText(ctx.nodeMainToken(a));
        return false;
    };

    const b_text = blk: {
        if (b_tag == .identifier) break :blk ctx.tokenText(ctx.nodeMainToken(b));
        if (b_tag == .string_literal) {
            const t = ctx.tokenText(ctx.nodeMainToken(b));
            break :blk if (t.len >= 2) t[1 .. t.len - 1] else t;
        }
        if (b_tag == .number_literal) break :blk ctx.tokenText(ctx.nodeMainToken(b));
        return false;
    };

    return std.mem.eql(u8, a_text, b_text);
}

pub fn runOnSymbols(_: *const LintContext) void {}
