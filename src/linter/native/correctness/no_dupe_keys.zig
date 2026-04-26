const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.object_literal};

pub const meta = RuleMeta{
    .name = "no-dupe-keys",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow duplicate keys in object literals",
};

const PropKind = enum { init, get, set };

const SeenEntry = struct {
    has_init: bool = false,
    has_get: bool = false,
    has_set: bool = false,
    report_node: NodeIndex = .none,
};

fn stripQuotes(s: []const u8) []const u8 {
    if (s.len >= 2 and (s[0] == '"' or s[0] == '\'' or s[0] == '`')) {
        return s[1 .. s.len - 1];
    }
    return s;
}

/// Normalize a numeric key to decimal string for comparison.
/// Handles hex (0x...), octal (0...), binary (0b...), decimal.
fn normalizeNumericKey(text: []const u8, buf: []u8) ?[]const u8 {
    if (text.len == 0) return null;
    // Try parsing as integer
    const val = if (std.mem.startsWith(u8, text, "0x") or std.mem.startsWith(u8, text, "0X"))
        std.fmt.parseInt(u64, text[2..], 16) catch return null
    else if (std.mem.startsWith(u8, text, "0b") or std.mem.startsWith(u8, text, "0B"))
        std.fmt.parseInt(u64, text[2..], 2) catch return null
    else if (std.mem.startsWith(u8, text, "0o") or std.mem.startsWith(u8, text, "0O"))
        std.fmt.parseInt(u64, text[2..], 8) catch return null
    else if (text.len > 1 and text[0] == '0' and !std.mem.containsAtLeast(u8, text, 1, "."))
        std.fmt.parseInt(u64, text, 8) catch
            std.fmt.parseInt(u64, text, 10) catch return null
    else
        std.fmt.parseInt(u64, text, 10) catch return null;
    return std.fmt.bufPrint(buf, "{d}", .{val}) catch null;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const range_start = @intFromEnum(data.lhs);
    const range_end = @intFromEnum(data.rhs);
    if (range_start == range_end) return;

    const props = ctx.extraSlice(.{ .start = range_start, .end = range_end });

    var seen = std.StringHashMap(SeenEntry).init(ctx.allocator);
    defer seen.deinit();

    for (props) |raw_idx| {
        const prop_idx: NodeIndex = @enumFromInt(raw_idx);
        const prop_tag = ctx.nodeTag(prop_idx);
        const prop_data = ctx.nodeData(prop_idx);

        var key_text: ?[]const u8 = null;
        var kind: PropKind = .init;

        switch (prop_tag) {
            .property, .shorthand_property, .method_def => {
                const key = prop_data.lhs;
                if (key == .none) continue;
                key_text = ctx.tokenText(ctx.nodeMainToken(key));
                kind = .init;
            },
            .getter_def => {
                const key = prop_data.lhs;
                if (key == .none) continue;
                key_text = ctx.tokenText(ctx.nodeMainToken(key));
                kind = .get;
            },
            .setter_def => {
                const key = prop_data.lhs;
                if (key == .none) continue;
                key_text = ctx.tokenText(ctx.nodeMainToken(key));
                kind = .set;
            },
            .computed_property => {
                // Only check when key is a string/template literal
                const key = prop_data.lhs;
                if (key == .none) continue;
                const key_tag = ctx.nodeTag(key);
                if (key_tag == .string_literal or key_tag == .template_literal) {
                    const tok_text = ctx.tokenText(ctx.nodeMainToken(key));
                    // Static template check for template_literal
                    if (key_tag == .template_literal) {
                        const kd = ctx.nodeData(key);
                        if (@intFromEnum(kd.rhs) - @intFromEnum(kd.lhs) != 1) continue; // has substitutions
                    }
                    key_text = tok_text;
                    kind = .init;
                }
            },
            else => continue,
        }

        if (key_text == null) continue;
        const raw_name = key_text.?;
        var num_buf: [32]u8 = undefined;
        const normalized_base = stripQuotes(raw_name);
        // Normalize numeric keys for comparison (0x1 == 1, 012 == 10, etc.)
        const normalized = normalizeNumericKey(normalized_base, &num_buf) orelse normalized_base;

        // __proto__ has special semantics in object literals — skip to avoid false positives.
        if (std.mem.eql(u8, normalized, "__proto__")) continue;

        const entry_result = seen.getOrPut(normalized) catch continue;
        if (!entry_result.found_existing) {
            entry_result.value_ptr.* = .{ .report_node = prop_idx };
        }
        const entry = entry_result.value_ptr;

        const is_dup = switch (kind) {
            .init => entry.has_init or entry.has_get or entry.has_set,
            .get => entry.has_init or entry.has_get,
            .set => entry.has_init or entry.has_set,
        };

        if (is_dup) {
            ctx.report(prop_idx);
        }

        switch (kind) {
            .init => { entry.has_init = true; entry.report_node = prop_idx; },
            .get => { entry.has_get = true; },
            .set => { entry.has_set = true; },
        }
    }
}
