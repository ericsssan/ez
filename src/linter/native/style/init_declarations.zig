const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const Span = @import("es_parser").span.Span;

pub const meta = RuleMeta{
    .name = "init-declarations",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require or disallow initialization in variable declarations",
};

pub const relevant_tags = [_]Node.Tag{.declarator};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    runImpl(node, ctx, false);
}

/// Shared implementation.  `short_span` selects the report loc for the
/// uninitialized ("initialized" messageId) case:
///   - false (base `init-declarations`): ESLint reports `node: declaration`,
///     so the span is the whole declarator — which, with a TS type annotation
///     and no initializer, includes the annotation (`arr: string`).
///   - true (`@typescript-eslint/init-declarations`): the plugin overrides the
///     loc to the identifier name only (`arr`), excluding the annotation.
/// The "never" (notInitialized) case is identical for both: the declarator
/// span from the identifier through the end of the initializer.
pub fn runImpl(node: NodeIndex, ctx: *const LintContext, short_span: bool) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    if (binding == .none) return;

    const var_decl = ctx.parentOf(node);
    if (var_decl == .none) return;
    const var_tag = ctx.nodeTag(var_decl);
    // Only fire on var/let/const declaration statements.
    if (var_tag != .var_decl and var_tag != .let_decl and var_tag != .const_decl) return;

    // The base rule only reports when `id.type === "Identifier"` — destructuring
    // patterns are never flagged.
    if (ctx.nodeTag(binding) != .identifier) return;

    const never_mode = ctx.optionEqualsString("never");
    const initialized = isInitialized(node, var_decl, ctx);

    if (never_mode) {
        if (!initialized) return;
        if (var_tag == .const_decl) return;
        if (getIgnoreForLoopInit(ctx)) {
            const for_parent_tag = ctx.nodeTag(ctx.parentOf(var_decl));
            if (isForLoop(for_parent_tag)) return;
        }
        // Build the "never" span: from the binding identifier to the end of the init.
        // Use nodeSpan(init) so grouping_expr/fn_expr/block spans include closing brackets.
        const rhs = data.rhs;
        if (rhs != .none) {
            const start = ctx.tokenStart(ctx.nodeMainToken(binding));
            const end = ctx.nodeSpan(rhs).end;
            ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, "notInitialized");
        } else {
            ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "notInitialized");
        }
    } else {
        // always mode (default)
        if (initialized) return;
        if (isAmbient(var_decl, ctx)) return;
        const span = if (short_span) identifierSpan(binding, ctx) else ctx.nodeSpan(node);
        ctx.reportSpanWithMessageId(span, "initialized");
    }
}

fn isInitialized(declarator: NodeIndex, var_decl: NodeIndex, ctx: *const LintContext) bool {
    const for_parent = ctx.parentOf(var_decl);
    if (for_parent == .none) {
        return ctx.nodeData(declarator).rhs != .none;
    }
    const for_tag = ctx.nodeTag(for_parent);
    // for-in/for-of: only the binding var_decl is "initialized" by the loop.
    // A var_decl that appears in the body (not as binding) is NOT initialized.
    if (for_tag == .for_in_stmt or for_tag == .for_of_stmt or for_tag == .for_await_of_stmt) {
        const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(ctx.nodeData(for_parent).lhs));
        return for_data.binding == var_decl;
    }
    // for-stmt init: treated as initialized if this var_decl is the init part.
    if (for_tag == .for_stmt) {
        const for_data = ctx.extraData(ast.ForData, @intFromEnum(ctx.nodeData(for_parent).lhs));
        return for_data.init == var_decl;
    }
    return ctx.nodeData(declarator).rhs != .none;
}

fn isForLoop(tag: Node.Tag) bool {
    return switch (tag) {
        .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt => true,
        else => false,
    };
}

fn getIgnoreForLoopInit(ctx: *const LintContext) bool {
    const opts2 = ctx.getOptions2() orelse return false;
    if (opts2.* != .object) return false;
    const val = opts2.object.get("ignoreForLoopInit") orelse return false;
    return if (val == .bool) val.bool else false;
}

/// Check if the variable declaration is ambient (should be skipped in always mode).
/// Covers `declare var/let/const` and any ancestor `declare namespace/module { }`.
fn isAmbient(var_decl: NodeIndex, ctx: *const LintContext) bool {
    // Direct declare: `declare const foo: number;` — token before main is kw_declare.
    const vmt = ctx.nodeMainToken(var_decl);
    if (vmt > 0 and ctx.tokenTag(vmt - 1) == .kw_declare) return true;

    // Ancestor namespace/module with declare.
    var ancestor = ctx.parentOf(var_decl);
    while (ancestor != .none) {
        const tag = ctx.nodeTag(ancestor);
        if (tag == .ts_namespace_decl or tag == .ts_module_decl) {
            const mt = ctx.nodeMainToken(ancestor);
            if (mt > 0 and ctx.tokenTag(mt - 1) == .kw_declare) return true;
        }
        ancestor = ctx.parentOf(ancestor);
    }
    return false;
}

/// Return the identifier-name span only.  Both the base ESLint rule (which
/// reports `node: declaration`, whose span equals the bare identifier when
/// there is no initializer) and the @typescript-eslint variant (which
/// overrides the loc to `start + id.name.length`, deliberately excluding the
/// TS type annotation) want exactly the identifier name here.
fn identifierSpan(binding: NodeIndex, ctx: *const LintContext) Span {
    const mt = ctx.nodeMainToken(binding);
    return .{ .start = ctx.tokenStart(mt), .end = ctx.tokenEnd(mt) };
}
