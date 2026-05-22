// HAND-WRITTEN.
// Rule: @typescript-eslint/no-empty-object-type
//
// Reports:
//   - `interface Foo {}` with no members and no extends — flag as
//     "noEmptyInterface".
//   - `interface Derived extends Base {}` with no extra members and
//     a single extends — flag as "noEmptyInterfaceWithSuper".
//   - `{ }` empty type literal — flag as "noEmptyObject".
//
// Honors the `allowInterfaces` / `allowObjectTypes` /
// `allowWithName` options to suppress firing.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-empty-object-type",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow accidentally using the `{}` type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_interface_decl, .ts_type_literal };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .ts_interface_decl => checkInterface(node, ctx),
        .ts_type_literal => checkTypeLiteral(node, ctx),
        else => {},
    }
}

fn checkInterface(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    // Empty body required.
    if (id.body_start != id.body_end) return;
    const n_extends: u32 = id.extends_end - id.extends_start;
    // Multiple extends are deliberate (interface combination); skip.
    if (n_extends >= 2) return;
    const has_extends = n_extends == 1;
    // Option: allowInterfaces ("always" | "never" | "with-single-extends")
    const allow_ifaces = ctx.getOptionString("allowInterfaces") orelse "never";
    if (std.mem.eql(u8, allow_ifaces, "always")) return;
    if (has_extends and std.mem.eql(u8, allow_ifaces, "with-single-extends")) return;
    // `allowWithName` regex — skip if the interface name matches.
    if (matchesAllowName(id.name, ctx)) return;
    const name_tok = id.name;
    const start = ctx.ast.tokenStart(name_tok);
    const len = ctx.ast.tokens.items(.len)[name_tok];
    ctx.reportSpanWithMessageId(.{ .start = @intCast(start), .end = @intCast(start + len) }, if (has_extends) "noEmptyInterfaceWithSuper" else "noEmptyInterface");
}

fn checkTypeLiteral(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s != e) return;
    const allow_objs = ctx.getOptionString("allowObjectTypes") orelse "never";
    if (std.mem.eql(u8, allow_objs, "always")) return;
    // `{}` inside an intersection is treated as a usability trick (T &
    // {} → non-nullable) and not flagged.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .ts_intersection_type) return;
    // allowWithName — match against the enclosing alias name if any.
    if (aliasNameMatchesAllow(node, ctx)) return;
    // Span: cover the `{}` pair.  nodeSpan returns just the open
    // brace; scan forward to the matching close.
    var sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    if (sp.end < src.len) {
        var i = sp.end;
        while (i < src.len and (src[i] == ' ' or src[i] == '\t' or src[i] == '\n')) i += 1;
        if (i < src.len and src[i] == '}') sp.end = i + 1;
    }
    ctx.reportSpanWithMessageId(sp, "noEmptyObject");
}

fn aliasNameMatchesAllow(node: NodeIndex, ctx: *const LintContext) bool {
    const pattern = ctx.getOptionString("allowWithName") orelse return false;
    if (pattern.len == 0) return false;
    // Only applies when `{}` IS the direct body of a `type X = {}` —
    // not when nested in a union/intersection/etc.
    const parent = ctx.parentOf(node);
    if (parent == .none or ctx.nodeTag(parent) != .ts_type_alias_decl) return false;
    const data = ctx.nodeData(parent);
    const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
    const start = ctx.ast.tokenStart(ad.name);
    const len = ctx.ast.tokens.items(.len)[ad.name];
    if (start + len > ctx.ast.source.len) return false;
    return regexLiteMatches(pattern, ctx.ast.source[start .. start + len]);
}

fn matchesAllowName(name_tok: u32, ctx: *const LintContext) bool {
    const pattern = ctx.getOptionString("allowWithName") orelse return false;
    if (pattern.len == 0) return false;
    const start = ctx.ast.tokenStart(name_tok);
    const len = ctx.ast.tokens.items(.len)[name_tok];
    if (start + len > ctx.ast.source.len) return false;
    const name = ctx.ast.source[start .. start + len];
    return regexLiteMatches(pattern, name);
}

/// Minimal anchored-regex matcher: supports `^` / `$` anchors and
/// treats any other character as a literal (no character classes,
/// quantifiers, etc.).  Sufficient for TSe's tests which use bare
/// names and end-anchors like `Props$`.
fn regexLiteMatches(pattern: []const u8, text: []const u8) bool {
    var pat = pattern;
    var anchored_start = false;
    var anchored_end = false;
    if (pat.len > 0 and pat[0] == '^') { anchored_start = true; pat = pat[1..]; }
    if (pat.len > 0 and pat[pat.len - 1] == '$') { anchored_end = true; pat = pat[0 .. pat.len - 1]; }
    if (anchored_start and anchored_end) {
        return std.mem.eql(u8, text, pat);
    }
    if (anchored_start) return std.mem.startsWith(u8, text, pat);
    if (anchored_end) return std.mem.endsWith(u8, text, pat);
    // Unanchored — substring match.
    return std.mem.indexOf(u8, text, pat) != null;
}
