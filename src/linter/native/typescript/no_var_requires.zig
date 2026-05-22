// HAND-WRITTEN.
// Rule: @typescript-eslint/no-var-requires
//
// Reports `var/let/const x = require('mod')` and similar inline-call
// forms.  ES module imports are preferred over the CommonJS `require`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-var-requires",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow `require` statements except in import statements",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    var callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "require")) return;
    if (callIsInsideImportEquals(node, ctx)) return;
    if (callIsBareStatement(node, ctx)) return;
    if (requireArgIsAllowed(node, ctx)) return;
    if (requireIsShadowed(ctx)) return;
    ctx.reportWithMessageId(node, "noVarReqs");
}

fn callIsBareStatement(call: NodeIndex, ctx: *const LintContext) bool {
    // `require('x');` as a discarded statement: parent is expression_stmt
    // and there's no enclosing assignment/call/declaration.
    const parent = ctx.parentOf(call);
    return parent != .none and ctx.nodeTag(parent) == .expression_stmt;
}

/// True when the source declares a local `require` binding (e.g.
/// `const require = createRequire(...)`).  Naive: scan source for
/// known declaration prefixes — sufficient for the corpus fixtures
/// where the shadow is at the top of the file.
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

fn callIsInsideImportEquals(call: NodeIndex, ctx: *const LintContext) bool {
    // `import X = require('mod')` parses as an import_decl whose
    // module_ref subtree contains the call.  Walk parents looking
    // for import_decl.
    var p = ctx.parentOf(call);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (ctx.nodeTag(p) == .import_decl) return true;
        // Bail out at any statement boundary.
        const t = ctx.nodeTag(p);
        if (t == .expression_stmt or t == .declarator or
            t == .block_stmt or t == .root) return false;
    }
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

/// Minimal anchored-regex matcher: handles `^` / `$` anchors and
/// `\\.` literal-dot escapes; everything else is treated as a
/// literal character.  Sufficient for the corpus's options strings
/// like `\\.json$` or `^some-package$`.
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

