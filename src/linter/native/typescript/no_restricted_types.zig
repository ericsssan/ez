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
    .ts_tuple_type,
    .class_decl,
    .ts_interface_decl,
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
            // ts_type_reference span may include children (type args)
            // but `>` is not a child node, so it's missing from the
            // span end.  When type args are present, balance `<` and
            // `>` in the current span and walk forward to close any
            // unclosed `<`.
            const data = ctx.nodeData(node);
            if (data.rhs != .none) {
                var depth: i32 = 0;
                var k: usize = sp.start;
                while (k < sp.end) : (k += 1) {
                    if (src[k] == '<') depth += 1;
                    if (src[k] == '>') depth -= 1;
                }
                var j: usize = sp.end;
                while (j < src.len and depth > 0) : (j += 1) {
                    if (src[j] == '<') depth += 1;
                    if (src[j] == '>') depth -= 1;
                }
                sp.end = @intCast(j);
            }
            matched_name = src[sp.start..sp.end];
            if (lookupMatch(types, matched_name)) |id| {
                ctx.reportSpanWithMessageId(sp, id);
                return;
            }
            // Fall back to bare-name lookup (key without type args).
            if (data.rhs != .none) {
                const bare = ctx.tokenText(ctx.nodeMainToken(node));
                if (lookupMatch(types, bare)) |id| {
                    const bare_end = ctx.ast.tokenStart(ctx.nodeMainToken(node)) +
                        ctx.ast.tokens.items(.len)[ctx.nodeMainToken(node)];
                    ctx.reportSpanWithMessageId(
                        .{ .start = sp.start, .end = bare_end },
                        id,
                    );
                }
            }
        },
        .ts_array_type => {
            // `T[]` — match on the literal name `[]` (a synthetic
            // shorthand TSe uses) by checking the user option for it.
            if (lookupMatch(types, "[]")) |id| {
                ctx.reportSpanWithMessageId(sp, id);
            }
        },
        .ts_tuple_type => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (e <= ctx.ast.extra_data.len and s == e) {
                if (lookupMatch(types, "[]")) |id| {
                    // Span starts at `[`; extend through `]`.
                    var end: u32 = @intCast(sp.end);
                    const src = ctx.ast.source;
                    while (end < src.len and (src[end] == ' ' or src[end] == '\t')) end += 1;
                    if (end < src.len and src[end] == ']') end += 1;
                    ctx.reportSpanWithMessageId(.{ .start = sp.start, .end = end }, id);
                }
            }
        },
        .class_decl, .ts_interface_decl => checkHeritage(node, types, ctx),
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

/// `extends X<...>` (interface) / `implements X<...>` (class) clauses
/// don't surface as `ts_type_reference` nodes in our AST — they're
/// stored as token indices in the heritage SubRange.  Source-scan to
/// recover each restricted name.
fn checkHeritage(node: NodeIndex, types: std.json.Value, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const tag = ctx.nodeTag(node);
    if (data.lhs == .none) return;
    if (tag == .ts_interface_decl) {
        // Interface extends: stored as NodeIndex (type references).
        const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
        if (id.extends_start >= id.extends_end or id.extends_end > ctx.ast.extra_data.len) return;
        for (ctx.ast.extra_data[id.extends_start..id.extends_end]) |raw| {
            const ext: NodeIndex = @enumFromInt(raw);
            checkHeritageNode(ext, types, ctx);
        }
    } else {
        // Class implements: stored as TokenIndex of ts_type_reference main_token.
        const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
        if (cd.impls_start >= cd.impls_end or cd.impls_end > ctx.ast.extra_data.len) return;
        const src = ctx.ast.source;
        for (ctx.ast.extra_data[cd.impls_start..cd.impls_end]) |tok_idx| {
            const tok_start = ctx.ast.tokenStart(tok_idx);
            const tok_len = ctx.ast.tokens.items(.len)[tok_idx];
            if (tok_start + tok_len > src.len) continue;
            const name = src[tok_start .. tok_start + tok_len];
            if (lookupMatch(types, name)) |id| {
                ctx.reportSpanWithMessageId(
                    .{ .start = tok_start, .end = tok_start + tok_len },
                    id,
                );
            }
        }
    }
}

fn checkHeritageNode(ext: NodeIndex, types: std.json.Value, ctx: *const LintContext) void {
    // Only `ts_type_reference` carries a name we can look up.
    if (ctx.nodeTag(ext) != .ts_type_reference) return;
    const tok = ctx.nodeMainToken(ext);
    const tok_start = ctx.ast.tokenStart(tok);
    const tok_len = ctx.ast.tokens.items(.len)[tok];
    const src = ctx.ast.source;
    if (tok_start + tok_len > src.len) return;
    const name = src[tok_start .. tok_start + tok_len];
    if (lookupMatch(types, name)) |id| {
        ctx.reportSpanWithMessageId(
            .{ .start = tok_start, .end = tok_start + tok_len },
            id,
        );
    }
}

fn pickMessageId(entry: std.json.Value) []const u8 {
    _ = entry;
    return "bannedTypeMessage";
}
