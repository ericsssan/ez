const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{ .class_decl, .class_expr };

pub const meta = RuleMeta{
    .name = "no-dupe-class-members",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate class members",
};

const MemberState = struct {
    init: bool = false,
    get: bool = false,
    set: bool = false,
};

/// Check if the key token has kw_static somewhere before it (within the class body).
fn isStaticMember(key_tok: u32, ctx: *const LintContext) bool {
    if (key_tok == 0) return false;
    var t = key_tok;
    while (t > 0) {
        t -= 1;
        const tag = ctx.tokenTag(t);
        if (tag == .kw_static) return true;
        if (tag == .l_brace or tag == .semicolon or tag == .r_brace) break;
    }
    return false;
}

/// Extract the normalized string name from a key node.
/// Returns null if the key is not statically-known (dynamic expression).
fn keyName(key_node: NodeIndex, ctx: *const LintContext, buf: []u8) ?[]const u8 {
    if (key_node == .none) return null;
    const tag = ctx.nodeTag(key_node);
    const tok = ctx.nodeMainToken(key_node);
    const text = ctx.tokenText(tok);

    switch (tag) {
        .identifier => return text,
        .string_literal => {
            if (text.len < 2) return text;
            return text[1 .. text.len - 1];
        },
        .template_literal => {
            const src = ctx.source();
            const start = ctx.tokenStart(tok);
            if (start >= src.len or src[start] != '`') return null;
            var end = start + 1;
            while (end < src.len and src[end] != '`' and src[end] != '$') : (end += 1) {}
            if (end >= src.len or src[end] != '`') return null;
            return src[start + 1 .. end];
        },
        .number_literal => {
            const n = std.fmt.parseFloat(f64, text) catch return text;
            if (n != @trunc(n) or n < 0) return null;
            const ival: u64 = @intFromFloat(n);
            return std.fmt.bufPrint(buf, "{d}", .{ival}) catch null;
        },
        else => return null,
    }
}

const Kind = enum { init, get, set };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const class_data = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));

    // class_data.body is the class_body node; its lhs/rhs is the member SubRange
    const body_data = ctx.nodeData(class_data.body);
    const sub_range = ast.SubRange{
        .start = @intFromEnum(body_data.lhs),
        .end = @intFromEnum(body_data.rhs),
    };
    const members = ctx.extraSlice(sub_range);

    var seen = std.StringHashMap(MemberState).init(ctx.allocator);
    defer seen.deinit();

    for (members) |member_idx| {
        const member_node: NodeIndex = @enumFromInt(member_idx);
        const member_tag = ctx.nodeTag(member_node);
        const member_data = ctx.nodeData(member_node);

        const is_computed = switch (member_tag) {
            .computed_method_def, .computed_property_def, .computed_getter_def, .computed_setter_def => true,
            else => false,
        };

        const key_node = switch (member_tag) {
            .method_def, .property_def => member_data.lhs,
            .getter_def => member_data.lhs,
            .setter_def => member_data.lhs,
            .constructor_def => continue, // actual constructor (keyword form) — skip
            .computed_method_def, .computed_property_def => member_data.lhs,
            .computed_getter_def => member_data.lhs,
            .computed_setter_def => member_data.lhs,
            else => continue,
        };

        if (key_node == .none) continue;

        const kind: Kind = switch (member_tag) {
            .getter_def, .computed_getter_def => .get,
            .setter_def, .computed_setter_def => .set,
            else => .init,
        };

        const key_tok = ctx.nodeMainToken(key_node);
        const is_static = isStaticMember(key_tok, ctx);
        const static_prefix: []const u8 = if (is_static) "S:" else "";

        var num_buf: [32]u8 = undefined;
        // For computed members: identifiers are dynamic (not statically known) → skip
        const name: []const u8 = if (is_computed) blk: {
            const tag = ctx.nodeTag(key_node);
            if (tag == .identifier) continue; // dynamic key like [foo]
            break :blk keyName(key_node, ctx, &num_buf) orelse continue;
        } else blk: {
            const n = keyName(key_node, ctx, &num_buf) orelse continue;
            // Non-computed method with key "constructor" → treat as constructor, skip
            if (kind == .init and std.mem.eql(u8, n, "constructor")) continue;
            break :blk n;
        };

        var map_key_buf: [300]u8 = undefined;
        const map_key = std.fmt.bufPrint(&map_key_buf, "{s}{s}", .{ static_prefix, name }) catch continue;

        const gop = seen.getOrPut(map_key) catch continue;
        if (!gop.found_existing) {
            gop.key_ptr.* = ctx.allocator.dupe(u8, map_key) catch continue;
            gop.value_ptr.* = .{};
        }

        const state = gop.value_ptr;
        const is_dup: bool = switch (kind) {
            .get => state.init or state.get,
            .set => state.init or state.set,
            .init => state.init or state.get or state.set,
        };

        switch (kind) {
            .get => state.get = true,
            .set => state.set = true,
            .init => state.init = true,
        }

        if (is_dup) {
            ctx.report(member_node);
        }
    }
}
