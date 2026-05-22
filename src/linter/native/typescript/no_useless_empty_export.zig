// HAND-WRITTEN.
// Rule: @typescript-eslint/no-useless-empty-export
//
// Reports `export {}` in modules that already have other exports.
// The empty export's only legitimate purpose is to force a file with
// no other exports to be treated as a module; once another export
// exists, `export {}` becomes noise.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-useless-empty-export",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow empty exports that don't change anything in a module file",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    // Walk top-level statements.  Track:
    //   - empty_export_nodes: every `export {}` we see
    //   - has_other_export: at least one other export-shaped node
    var empty_buf: [16]NodeIndex = undefined;
    var empty_count: usize = 0;
    var has_other_export = false;
    const tree = ctx.ast;
    const root_data = ctx.nodeData(@enumFromInt(@intFromEnum(NodeIndex.root)));
    const r_start = @intFromEnum(root_data.lhs);
    const r_end = @intFromEnum(root_data.rhs);
    if (r_start > r_end or r_end > tree.extra_data.len) return;
    for (tree.extra_data[r_start..r_end]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const tag = ctx.nodeTag(stmt);
        switch (tag) {
            .export_named => {
                if (isEmptyNamedExport(stmt, ctx)) {
                    if (empty_count < empty_buf.len) {
                        empty_buf[empty_count] = stmt;
                        empty_count += 1;
                    }
                } else if (isRuntimeExportNamed(stmt, ctx)) {
                    has_other_export = true;
                }
            },
            .export_named_from,
            .export_default_expr, .export_default_fn, .export_default_class,
            .export_all,
            => has_other_export = true,
            // ANY import statement also makes the file a module, so
            // an additional `export {}` is redundant.
            .import_decl => has_other_export = true,
            else => {},
        }
    }
    if (!has_other_export) return;
    var i: usize = 0;
    while (i < empty_count) : (i += 1) {
        ctx.reportSpanWithMessageId(spanOfStmt(empty_buf[i], ctx), "uselessExport");
    }
}

/// True when an `export_named` carries a runtime declaration — a
/// regular `const`/`let`/`var`/`function`/`class`/`enum`/`namespace`.
/// `export declare ...`, `export type`, `export interface` etc. are
/// pure type-level exports that don't affect module-vs-script status.
fn isRuntimeExportNamed(stmt: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(stmt);
    // `export { ... }` form: lhs/rhs are range — handled by isEmptyNamedExport
    // separately, but a non-empty specifier list IS runtime (re-exports).
    if (data.rhs != .none) return true;
    // `export <decl>` form: lhs = the inner decl.
    if (data.lhs == .none) return false;
    const inner = data.lhs;
    const tag = ctx.nodeTag(inner);
    return switch (tag) {
        .var_decl, .let_decl, .const_decl, .fn_decl, .async_fn_decl,
        .generator_fn_decl, .async_generator_fn_decl,
        .class_decl, .ts_enum_decl,
        // namespace with concrete body counts as runtime, but we can't
        // distinguish declare-only from runtime structurally; accept.
        .ts_namespace_decl, .ts_module_decl,
        => !hasDeclareModifier(inner, ctx),
        // type / interface — type-only, don't count.
        .ts_type_alias_decl, .ts_interface_decl => false,
        else => true,
    };
}

fn hasDeclareModifier(decl: NodeIndex, ctx: *const LintContext) bool {
    const main_tok = ctx.nodeMainToken(decl);
    if (main_tok == 0) return false;
    // Walk back up to 3 tokens looking for `declare`.
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
        // Stop at delimiters.
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}

fn spanOfStmt(stmt: NodeIndex, ctx: *const LintContext) @import("../../../parser/span.zig").Span {
    // main_token IS the `export` keyword.  Walk forward past `{}`
    // and the optional `;`.
    const main_tok = ctx.nodeMainToken(stmt);
    const start = ctx.ast.tokenStart(main_tok);
    const src = ctx.ast.source;
    // Scan forward to find the matching `}`, then optional `;`.
    var i: usize = start;
    while (i < src.len and src[i] != '}') i += 1;
    if (i < src.len) i += 1; // include `}`
    if (i < src.len and src[i] == ';') i += 1;
    return .{ .start = @intCast(start), .end = @intCast(i) };
}

fn isEmptyNamedExport(stmt: NodeIndex, ctx: *const LintContext) bool {
    const data = ctx.nodeData(stmt);
    // `export { x, y }` form: lhs=range start, rhs=range end.  For
    // `export var/const/let/class/fn`, lhs is the decl and rhs=.none.
    if (data.rhs == .none) return false;
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    return s == e;
}
