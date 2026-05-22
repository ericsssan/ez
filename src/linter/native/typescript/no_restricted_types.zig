// HAND-WRITTEN.
// Rule: @typescript-eslint/no-restricted-types
//
// Reports type references whose name matches an entry in the user
// option `types`.  Each entry value is either:
//   - true              → ban the type, generic message
//   - string            → ban with custom message
//   - { message, fixWith } object → ban with optional fix text

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-restricted-types",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow certain types",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_reference,
    .ts_array_type,
    .ts_type_literal,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const opts = ctx.rule_options orelse return;
    if (opts.* != .object) return;
    const types = opts.object.get("types") orelse return;
    if (types != .object) return;
    const tag = ctx.nodeTag(node);
    var matched_name: []const u8 = "";
    var sp = ctx.nodeSpan(node);
    switch (tag) {
        .ts_type_reference => {
            // Build full source text covering the type reference for
            // matches that use a qualified name like `NS.Foo`.  The
            // basic case is a single identifier.
            sp = ctx.nodeSpan(node);
            // Extend through any qualifier (`.NS.Foo`) — `nodeSpan` only
            // reports main_token.  Scan forward through `.`/identifier.
            const src = ctx.ast.source;
            var end: usize = sp.end;
            while (end < src.len) {
                const c = src[end];
                if (c == '.' or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')
                    or (c >= '0' and c <= '9') or c == '_' or c == '$')
                {
                    end += 1;
                    continue;
                }
                break;
            }
            sp.end = @intCast(end);
            matched_name = ctx.ast.source[sp.start..sp.end];
            if (lookupMatch(types, matched_name)) |id| {
                ctx.reportSpanWithMessageId(sp, id);
            }
        },
        .ts_array_type => {
            // `T[]` — match on the literal name `[]` (a synthetic
            // shorthand TSe uses) by checking the user option for it.
            if (lookupMatch(types, "[]")) |id| {
                ctx.reportSpanWithMessageId(sp, id);
            }
        },
        .ts_type_literal => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (e <= ctx.ast.extra_data.len and s == e) {
                // Empty `{}` — synthetic key.
                if (lookupMatch(types, "{}")) |id| {
                    var end: u32 = @intCast(sp.end);
                    const src = ctx.ast.source;
                    while (end < src.len and (src[end] == ' ' or src[end] == '\t')) end += 1;
                    if (end < src.len and src[end] == '}') end += 1;
                    ctx.reportSpanWithMessageId(.{ .start = sp.start, .end = end }, id);
                }
            }
        },
        else => {},
    }
}

fn lookupMatch(types: std.json.Value, name: []const u8) ?[]const u8 {
    // Direct match first.
    if (types.object.get(name)) |entry| return pickMessageId(entry);
    // Try matching keys with surrounding whitespace trimmed.
    var iter = types.object.iterator();
    while (iter.next()) |kv| {
        const key = std.mem.trim(u8, kv.key_ptr.*, " \t");
        if (std.mem.eql(u8, key, name)) return pickMessageId(kv.value_ptr.*);
    }
    return null;
}

fn pickMessageId(entry: std.json.Value) []const u8 {
    _ = entry;
    return "bannedTypeMessage";
}
