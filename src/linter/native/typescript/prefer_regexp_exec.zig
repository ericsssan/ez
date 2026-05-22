// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-regexp-exec
//
// Reports `str.match(regex)` on string receivers when the regex has
// no global flag — `regex.exec(str)` is preferred (avoids returning
// arrays of matches).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "prefer-regexp-exec",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce RegExp#exec over String#match if no global flag is provided",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const callee = ctx.nodeData(node).lhs;
    if (callee == .none) return;
    const cb_tag = ctx.nodeTag(callee);
    if (cb_tag != .member_expr and cb_tag != .optional_member_expr) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "match")) return;
    const args = callArgs(node, ctx) orelse return;
    if (args.len != 1) return;
    const object = ctx.nodeData(callee).lhs;
    if (object == .none) return;
    if (!receiverIsString(object, ctx)) return;
    const arg: NodeIndex = @enumFromInt(args[0]);
    if (!argIsNonGlobalRegex(arg, ctx)) return;
    ctx.reportWithMessageId(node, "regExpExecOverStringMatch");
}

fn receiverIsString(node: NodeIndex, ctx: *const LintContext) bool {
    return ctx.typeIdIsStringy(ctx.typeOfNode(node));
}

fn argIsNonGlobalRegex(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .regex_literal) {
        return !regexTextHasGlobalFlag(ctx.tokenText(ctx.nodeMainToken(n)));
    }
    // A string literal argument: TS treats it as a regex pattern with
    // no flags — definitely no 'g'.  Skip when the pattern is
    // syntactically invalid — TSe doesn't rewrite calls that would
    // throw at runtime.
    if (tag == .string_literal or tag == .template_literal) {
        const pat = stringLiteralValue(n, ctx) orelse return false;
        if (!isValidRegexPattern(pat)) return false;
        return true;
    }
    // `new RegExp(pattern)` / `new RegExp(pattern, flags)`
    if (tag == .new_expr) {
        const new_callee = ctx.nodeData(n).lhs;
        if (new_callee == .none or ctx.nodeTag(new_callee) != .identifier) return false;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(new_callee)), "RegExp")) return false;
        const new_args = callArgs(n, ctx) orelse return true;
        if (new_args.len < 2) return true;
        const flag_arg: NodeIndex = @enumFromInt(new_args[1]);
        return !flagArgContainsGlobal(flag_arg, ctx);
    }
    // Variable: walk init.
    if (tag == .identifier) {
        const sym = symbolForIdent(n, ctx) orelse return false;
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
        const dparent = ctx.parentOf(decl);
        if (dparent == .none or ctx.nodeTag(dparent) != .declarator) return false;
        const init = ctx.nodeData(dparent).rhs;
        if (init == .none) return false;
        return argIsNonGlobalRegex(init, ctx);
    }
    return false;
}

fn stringLiteralValue(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const sp = ctx.nodeSpan(node);
    if (sp.end <= sp.start + 2) return null;
    const raw = ctx.ast.source[sp.start..sp.end];
    if (raw.len < 2) return null;
    return raw[1 .. raw.len - 1];
}

/// Cheap regex-pattern syntax check.  We don't care about full
/// validity — only whether unmatched brackets / parens would make TS
/// treat the construction as failing at runtime.
fn isValidRegexPattern(pat: []const u8) bool {
    var bracket_depth: i32 = 0;
    var paren_depth: i32 = 0;
    var i: usize = 0;
    while (i < pat.len) : (i += 1) {
        const c = pat[i];
        if (c == '\\') {
            if (i + 1 < pat.len) i += 1;
            continue;
        }
        if (bracket_depth > 0) {
            if (c == ']') bracket_depth -= 1;
            continue;
        }
        if (c == '[') { bracket_depth += 1; continue; }
        if (c == '(') { paren_depth += 1; continue; }
        if (c == ')') {
            if (paren_depth == 0) return false;
            paren_depth -= 1;
            continue;
        }
    }
    return bracket_depth == 0 and paren_depth == 0;
}

fn symbolForIdent(ident: NodeIndex, ctx: *const LintContext) ?parser.symbol.SymbolId {
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != ident) continue;
        if (!refs.isResolved(rid)) return null;
        return refs.getSymbol(rid);
    }
    return null;
}

fn regexTextHasGlobalFlag(text: []const u8) bool {
    // Source is like `/.../flags`.  Find the last `/` and check trailing.
    if (text.len < 2) return false;
    var last_slash: usize = text.len;
    var i: usize = text.len;
    while (i > 0) {
        i -= 1;
        if (text[i] == '/') { last_slash = i; break; }
    }
    if (last_slash >= text.len) return false;
    const flags = text[last_slash + 1 ..];
    for (flags) |c| if (c == 'g') return true;
    return false;
}

fn flagArgContainsGlobal(arg: NodeIndex, ctx: *const LintContext) bool {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // `undefined`, `null`, `void 0` — no flags.
    if (tag == .null_literal or tag == .void_expr) return false;
    if (tag == .identifier and
        std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(n)), "undefined")) return false;
    if (tag != .string_literal) {
        // Can't statically determine — be conservative and assume it
        // might contain 'g' (so we won't fire).
        return true;
    }
    const span = ctx.nodeSpan(n);
    if (span.end <= span.start + 2) return false;
    const raw = ctx.ast.source[span.start..span.end];
    for (raw) |c| if (c == 'g') return true;
    return false;
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}
