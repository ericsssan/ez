// HAND-WRITTEN.
// Rule: @typescript-eslint/no-require-imports
//
// Reports `var/let/const X = require('mod')` AND
// `import X = require('mod')` — both forms should use ES `import`
// syntax instead.  Supports the `allow` regex list and the
// `allowAsImport: true` option which suppresses `import X = require(...)`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-require-imports",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow `require` statements except in import statements",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .import_decl };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .call_expr, .optional_call_expr => checkCall(node, ctx),
        .import_decl => checkImportEquals(node, ctx),
        else => {},
    }
}

fn checkCall(node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "require")) return;
    // Skip when wrapped by an import_decl (`import X = require(...)`)
    // — handled in checkImportEquals.
    if (callIsInsideImportEquals(node, ctx)) return;
    if (requireArgIsAllowed(node, ctx)) return;
    if (requireIsShadowed(ctx)) return;
    ctx.reportWithMessageId(node, "noRequireImports");
}

fn checkImportEquals(node: NodeIndex, ctx: *const LintContext) void {
    // The import-equals form: `import X = require('...')`.  Our parser
    // stores the module ref in data.rhs when it's a `= require(...)`
    // form; data.lhs is `.none`.
    const data = ctx.nodeData(node);
    if (data.lhs != .none) return; // Regular `import { ... }` form.
    if (data.rhs == .none) return;
    // The module ref should be a call_expr to `require(...)`.
    var ref = data.rhs;
    while (ctx.nodeTag(ref) == .grouping_expr) ref = ctx.nodeData(ref).lhs;
    if (ctx.nodeTag(ref) != .call_expr) return;
    var callee = ctx.nodeData(ref).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "require")) return;
    if (ctx.getOptionBool("allowAsImport", false)) return;
    if (requireArgIsAllowed(ref, ctx)) return;
    ctx.reportWithMessageId(ref, "noRequireImports");
}

fn callIsInsideImportEquals(call: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(call);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (ctx.nodeTag(p) == .import_decl) return true;
        const t = ctx.nodeTag(p);
        if (t == .expression_stmt or t == .declarator or
            t == .block_stmt or t == .root) return false;
    }
    return false;
}

fn callIsBareStatement(call: NodeIndex, ctx: *const LintContext) bool {
    const parent = ctx.parentOf(call);
    return parent != .none and ctx.nodeTag(parent) == .expression_stmt;
}

fn requireIsShadowed(ctx: *const LintContext) bool {
    const src = ctx.ast.source;
    const patterns = [_][]const u8{
        "const require =",
        "let require =",
        "var require =",
        "function require(",
    };
    for (patterns) |p| if (std.mem.indexOf(u8, src, p) != null) return true;
    return false;
}

fn requireArgIsAllowed(call: NodeIndex, ctx: *const LintContext) bool {
    const opts = ctx.rule_options orelse return false;
    if (opts.* != .object) return false;
    const allow = opts.object.get("allow") orelse return false;
    if (allow != .array) return false;
    const arg_text = firstStringArg(call, ctx) orelse return false;
    for (allow.array.items) |entry| {
        if (entry != .string) continue;
        if (regexLiteMatches(entry.string, arg_text)) return true;
    }
    return false;
}

fn firstStringArg(call: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (e < s or e > ctx.ast.extra_data.len) return null;
    if (s == e) return null;
    const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
    const t = ctx.nodeTag(first);
    if (t != .string_literal and t != .template_literal) return null;
    const sp = ctx.nodeSpan(first);
    if (sp.end <= sp.start + 2) return null;
    const raw = ctx.ast.source[sp.start..sp.end];
    if (raw.len < 2) return null;
    return raw[1 .. raw.len - 1];
}

fn regexLiteMatches(pattern: []const u8, text: []const u8) bool {
    var pat = pattern;
    var anchored_start = false;
    var anchored_end = false;
    if (pat.len > 0 and pat[0] == '^') { anchored_start = true; pat = pat[1..]; }
    if (pat.len > 0 and pat[pat.len - 1] == '$') { anchored_end = true; pat = pat[0 .. pat.len - 1]; }
    var literal_buf: [128]u8 = undefined;
    var lit_len: usize = 0;
    var i: usize = 0;
    while (i < pat.len) : (i += 1) {
        const c = pat[i];
        if (c == '\\' and i + 1 < pat.len) {
            i += 1;
            if (lit_len < literal_buf.len) { literal_buf[lit_len] = pat[i]; lit_len += 1; }
        } else {
            if (lit_len < literal_buf.len) { literal_buf[lit_len] = c; lit_len += 1; }
        }
    }
    const lit = literal_buf[0..lit_len];
    if (anchored_start and anchored_end) return std.mem.eql(u8, text, lit);
    if (anchored_start) return std.mem.startsWith(u8, text, lit);
    if (anchored_end) return std.mem.endsWith(u8, text, lit);
    return std.mem.indexOf(u8, text, lit) != null;
}
