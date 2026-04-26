const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .equal, .not_equal, .strict_equal, .strict_not_equal };

pub const meta = RuleMeta{
    .name = "eqeqeq",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require the use of === and !== instead of == and !=",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);

    // Parse options. ESLint eqeqeq options:
    //   "always" | "smart" | "allow-null" (first arg)
    //   {"null": "always"|"ignore"|"never"} (second arg)
    const opts = ctx.getOptions();
    var mode_smart = false;
    var null_skip = false; // true = allow == null (ignore or never)
    var null_never = false; // true = flag === null (never option)

    if (opts) |o| {
        switch (o.*) {
            .string => |s| {
                if (std.mem.eql(u8, s, "smart")) mode_smart = true;
                if (std.mem.eql(u8, s, "allow-null")) null_skip = true;
            },
            else => {},
        }
    }
    // null option may be in options2 (second element of rule config array)
    // or directly as the first option object.
    const null_obj = ctx.getOptions2() orelse opts;
    if (null_obj) |o2| {
        if (o2.* == .object) {
            if (o2.object.get("null")) |nv| {
                if (nv == .string) {
                    const ns = nv.string;
                    if (std.mem.eql(u8, ns, "ignore") or std.mem.eql(u8, ns, "never"))
                        null_skip = true;
                    // "never": also flag === with null (covered by null_never below)
                    null_never = std.mem.eql(u8, ns, "never");
                }
            }
        }
    }

    const tag = ctx.nodeTag(node);
    const is_strict = tag == .strict_equal or tag == .strict_not_equal;
    const is_loose = tag == .equal or tag == .not_equal;

    // For strict === / !==: only care when null: "never" requires == for null.
    if (is_strict) {
        if (null_never and (isNullOrUndefined(ctx, data.lhs) or isNullOrUndefined(ctx, data.rhs))) {
            ctx.report(node);
        }
        return;
    }

    // For loose == / !=:
    if (!is_loose) return;

    // Skip null comparisons when option says so.
    if (null_skip or mode_smart) {
        if (isNullOrUndefined(ctx, data.lhs) or isNullOrUndefined(ctx, data.rhs)) return;
    }

    if (mode_smart) {
        // allow when: either side is typeof, comparing null/undefined, or same-type literals
        if (ctx.nodeTag(data.lhs) == .typeof_expr or ctx.nodeTag(data.rhs) == .typeof_expr) return;
        // Null/undefined comparisons already handled by null_skip above
        if (sameLiteralType(ctx, data.lhs, data.rhs)) return;
    }

    ctx.report(node);
}

/// Returns the "type bucket" for a literal node: 0=not-literal, 1=null/undefined, 2=number, 3=string, 4=boolean, 5=bigint.
fn literalTypeBucket(ctx: *const LintContext, idx: NodeIndex) u8 {
    if (idx == .none) return 0;
    return switch (ctx.nodeTag(idx)) {
        .null_literal => 1,
        .number_literal => 2,
        .string_literal => 3,
        .boolean_literal => 4,
        .bigint_literal => 5,
        .identifier => blk: {
            if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(idx)), "undefined")) break :blk 1;
            break :blk 0;
        },
        else => 0,
    };
}

/// Returns true if both nodes are literals of the same primitive type.
fn sameLiteralType(ctx: *const LintContext, a: NodeIndex, b: NodeIndex) bool {
    const ta = literalTypeBucket(ctx, a);
    const tb = literalTypeBucket(ctx, b);
    return ta != 0 and ta == tb;
}

fn isNullOrUndefined(ctx: *const LintContext, idx: NodeIndex) bool {
    if (idx == .none) return false;
    const t = ctx.nodeTag(idx);
    if (t == .null_literal) return true;
    if (t == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(idx));
        return std.mem.eql(u8, name, "undefined");
    }
    return false;
}


fn isLiteral(ctx: *const LintContext, idx: NodeIndex) bool {
    if (idx == .none) return false;
    return switch (ctx.nodeTag(idx)) {
        .string_literal, .number_literal, .boolean_literal, .null_literal, .bigint_literal => true,
        else => false,
    };
}
