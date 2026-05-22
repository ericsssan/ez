// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-namespace-keyword
//
// Reports `module Foo { ... }` — TS deprecated the `module` keyword
// for non-external modules; prefer `namespace`.  Augmentations of
// existing modules (e.g. `declare module "fs" { ... }`) are exempt.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-namespace-keyword",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require using `namespace` keyword over `module` keyword to declare custom TypeScript modules",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_module_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const main_tok = ctx.nodeMainToken(node);
    // The declaration is a `module X` form only if its main_token is
    // literally `module` — `namespace X` would have main_token text
    // "namespace".  Also exempt string-name modules (those are
    // augmentations).
    const kw = ctx.tokenText(main_tok);
    if (!std.mem.eql(u8, kw, "module")) {
        // `declare module ...` parsed with `declare` as main_token —
        // scan forward to find `module` vs `namespace`.
        if (!findFollowingModule(main_tok, ctx)) return;
    }
    // Look at the name token — if it's a string literal, this is an
    // augmentation; skip.
    const data = ctx.nodeData(node);
    if (data.lhs != .none) {
        const name_tag = ctx.nodeTag(data.lhs);
        if (name_tag == .string_literal) return;
    }
    // Span: the whole declaration (including trailing `;` if any).
    var sp = ctx.nodeSpan(node);
    // nodeSpan returns only the `module`/`declare` token; extend via
    // node_max_toks if available.
    sp = extendToDeclEnd(node, sp, ctx);
    ctx.reportSpanWithMessageId(sp, "useNamespace");
}

fn findFollowingModule(start_tok: u32, ctx: *const LintContext) bool {
    // Look at the next ~3 tokens for `module`.
    var i: u32 = start_tok + 1;
    const max = @min(start_tok + 5, @as(u32, @intCast(ctx.ast.tokens.len)));
    while (i < max) : (i += 1) {
        const text = tokenText(i, ctx);
        if (text.len == 0) continue;
        if (std.mem.eql(u8, text, "module")) return true;
        if (std.mem.eql(u8, text, "namespace")) return false;
    }
    return false;
}

fn tokenText(tok: u32, ctx: *const LintContext) []const u8 {
    const start = ctx.ast.tokenStart(tok);
    const len = ctx.ast.tokens.items(.len)[tok];
    if (start + len > ctx.ast.source.len) return &.{};
    return ctx.ast.source[start .. start + len];
}

fn extendToDeclEnd(node: NodeIndex, sp: @import("../../../parser/span.zig").Span, ctx: *const LintContext) @import("../../../parser/span.zig").Span {
    var result = sp;
    // Use the LintContext span machinery which honors node_max_toks.
    const lp = ctx.nodeSpan(node);
    if (lp.end > result.end) result.end = lp.end;
    // Walk forward through whitespace and optional `;`.
    const src = ctx.ast.source;
    var i = result.end;
    while (i < src.len and (src[i] == ' ' or src[i] == '\t')) i += 1;
    if (i < src.len and src[i] == ';') result.end = i + 1;
    return result;
}
