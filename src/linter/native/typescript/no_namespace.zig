// HAND-WRITTEN.
// Rule: @typescript-eslint/no-namespace
//
// Disallows TypeScript namespaces/internal modules.
//
// Options:
//   allowDeclarations (default: false): allow `declare namespace/module`
//   allowDefinitionFiles (default: true): allow in .d.ts definition files
//
// A namespace is exempt when:
//   - File is .d.ts and allowDefinitionFiles is true (default)
//   - Name is a string literal: `declare module 'foo'` (ambient external module)
//   - Name is `global`: `declare global {}` (global augmentation block)
//   - The namespace is inside an ambient context (ancestor has `declare`)
//   - The namespace has `declare` and allowDeclarations is true

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-namespace",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow TypeScript namespaces",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_namespace_decl, .ts_module_decl };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // allowDefinitionFiles (default true): exempt .d.ts files
    if (ctx.language == .dts) {
        if (ctx.getOptionBool("allowDefinitionFiles", true)) return;
    }

    const data = ctx.nodeData(node);
    const name_node = data.lhs;
    if (name_node == .none) return;

    // `declare module 'foo'` — string literal name is an ambient external module; always valid.
    if (ctx.nodeTag(name_node) == .string_literal) return;

    // `declare global {}` — global augmentation is always valid.
    if (ctx.nodeTag(name_node) == .identifier) {
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(name_node)), "global")) return;
    }

    // Namespaces inside an ambient context (ancestor has `declare`) are always valid.
    if (isInAmbientContext(node, ctx)) return;

    // At this point we are NOT in an ambient context.
    const has_declare = hasDeclareModifier(node, ctx);
    if (has_declare) {
        // allowDeclarations (default false): skip `declare namespace/module`
        if (ctx.getOptionBool("allowDeclarations", false)) return;
    }

    // Report the full namespace declaration span.
    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "moduleSyntaxIsPreferred");
}

/// True if `node` is nested inside an ancestor that creates an ambient context:
///   - A `ts_namespace_decl` / `ts_module_decl` with a `declare` modifier, OR
///   - A block that was the body of `declare global { ... }`.
fn isInAmbientContext(node: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        switch (ctx.nodeTag(cur)) {
            .block_stmt => {
                if (blockIsDeclareGlobal(cur, ctx)) return true;
                cur = ctx.parentOf(cur);
            },
            .ts_namespace_decl, .ts_module_decl => {
                if (hasDeclareModifier(cur, ctx)) return true;
                cur = ctx.parentOf(cur);
            },
            // Walk through export wrappers: `export namespace foo { ... }` wraps
            // the ts_namespace_decl in an export_named node.
            .export_named => cur = ctx.parentOf(cur),
            else => return false,
        }
    }
    return false;
}

/// True when a `.block` node is the body of `declare global { ... }`.
/// Detected by checking that the two tokens preceding the opening `{` are
/// `global` and `declare`.
fn blockIsDeclareGlobal(block_node: NodeIndex, ctx: *const LintContext) bool {
    const main_tok = ctx.nodeMainToken(block_node); // the `{` token
    if (main_tok < 2) return false;
    const prev1 = ctx.tokenText(main_tok - 1);
    if (!std.mem.eql(u8, prev1, "global")) return false;
    const prev2 = ctx.tokenText(main_tok - 2);
    return std.mem.eql(u8, prev2, "declare");
}

/// True when the node has a `declare` keyword in the tokens immediately preceding
/// its main_token (the `namespace` / `module` keyword).  Skips `export`.
fn hasDeclareModifier(node: NodeIndex, ctx: *const LintContext) bool {
    const main_tok = ctx.nodeMainToken(node);
    if (main_tok == 0) return false;
    var i: u32 = main_tok;
    var steps: u32 = 0;
    while (steps < 3 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, "declare")) return true;
        if (std.mem.eql(u8, text, "export")) continue;
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}
