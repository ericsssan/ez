// HAND-WRITTEN.
// Rule: @typescript-eslint/no-import-type-side-effects
//
// Reports `import { type A, type B } from 'mod'` patterns where every
// named specifier carries an inline `type` qualifier — the
// declaration is then a type-only import that still produces a
// runtime side-effect (the `import` statement itself).  Prefer the
// top-level form: `import type { A, B } from 'mod'`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-import-type-side-effects",
    .category = .style,
    .default_severity = .warning,
    .description = "Enforce the use of top-level import type qualifier when an import only has specifiers with inline type qualifiers",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.import_decl};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Skip already top-level `import type {...}`.  We detect it by
    // looking at the token after `import` — when it's the `type`
    // keyword, the declaration is top-level type-only.
    const main_tok = ctx.nodeMainToken(node);
    if (tokenTextAt(main_tok + 1, ctx)) |next| {
        if (std.mem.eql(u8, next, "type")) return;
    }
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const id = ctx.extraData(ast.ImportData, @intFromEnum(data.lhs));
    if (id.specifiers_start >= id.specifiers_end or
        id.specifiers_end > ctx.ast.extra_data.len) return;
    var saw_named = false;
    var all_inline_type = true;
    for (ctx.ast.extra_data[id.specifiers_start..id.specifiers_end]) |raw| {
        const sp: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(sp) != .import_specifier) {
            // default / namespace specifier — leave alone.
            all_inline_type = false;
            continue;
        }
        saw_named = true;
        const sp_tok = ctx.nodeMainToken(sp);
        if (sp_tok == 0) { all_inline_type = false; continue; }
        // Token immediately before the imported name must be `type` to
        // qualify as an inline-type specifier.
        const prev = tokenTextAt(sp_tok - 1, ctx) orelse {
            all_inline_type = false;
            continue;
        };
        if (!std.mem.eql(u8, prev, "type")) {
            all_inline_type = false;
        }
    }
    if (!saw_named or !all_inline_type) return;
    // Extend the span to include the terminating semicolon (ESLint's
    // ImportDeclaration range includes it).
    var sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    if (sp.end < src.len and src[sp.end] == ';') sp.end += 1;
    ctx.reportSpanWithMessageId(sp, "useTopLevelQualifier");
}

fn tokenTextAt(tok_idx: u32, ctx: *const LintContext) ?[]const u8 {
    if (tok_idx >= ctx.ast.tokens.len) return null;
    const start = ctx.ast.tokenStart(tok_idx);
    const len = ctx.ast.tokens.items(.len)[tok_idx];
    if (start + len > ctx.ast.source.len) return null;
    return ctx.ast.source[start .. start + len];
}
