const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;

pub const meta = RuleMeta{
    .name = "vars-on-top",
    .category = .style,
    .default_severity = .warning,
    .description = "Require var declarations be placed at the top of their containing scope",
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
    .generator_fn_decl, .generator_fn_expr,
    .async_generator_fn_decl, .async_generator_fn_expr,
    .arrow_fn, .async_arrow_fn,
    .method_def, .getter_def, .setter_def,
    .computed_method_def, .computed_getter_def, .computed_setter_def,
    .constructor_def,
    .root,
    .static_block,
};

fn isDirectiveStmt(ctx: *const LintContext, stmt: NodeIndex) bool {
    if (ctx.nodeTag(stmt) != .expression_stmt) return false;
    const edata = ctx.nodeData(stmt);
    if (edata.lhs == .none) return false;
    return ctx.nodeTag(edata.lhs) == .string_literal;
}

fn checkImmediateVarsOnTop(body: NodeIndex, ctx: *const LintContext) void {
    checkImmediateVarsOnTopEx(body, ctx, true);
}

fn isFunctionLike(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .method_def, .getter_def, .setter_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        .constructor_def,
        => true,
        else => false,
    };
}

/// Check immediate children of `body` (block_stmt or root) for out-of-order var declarations.
/// `allow_directives`: when false (static blocks), string literals are not directives.
fn checkImmediateVarsOnTopEx(body: NodeIndex, ctx: *const LintContext, allow_directives: bool) void {
    if (body == .none) return;
    const body_tag = ctx.nodeTag(body);
    const stmts = switch (body_tag) {
        .block_stmt, .root, .static_block => blk: {
            const d = ctx.nodeData(body);
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (s >= e) return;
            break :blk ctx.extraSlice(.{ .start = s, .end = e });
        },
        else => return,
    };

    var seen_non_decl = false;
    var seen_var = false;
    for (stmts) |s_raw| {
        const stmt: NodeIndex = @enumFromInt(s_raw);
        if (stmt == .none) continue;
        const tag = ctx.nodeTag(stmt);
        switch (tag) {
            .var_decl => {
                if (seen_non_decl) ctx.report(stmt);
                seen_var = true;
            },
            .expression_stmt => {
                if (allow_directives and !seen_var and !seen_non_decl and isDirectiveStmt(ctx, stmt)) continue;
                seen_non_decl = true;
            },
            // let/const/class declarations are not "code" — they don't block vars.
            .let_decl, .const_decl, .class_decl => {},
            .import_decl => {},
            .export_named => {
                const ed = ctx.nodeData(stmt);
                if (ed.lhs != .none and ctx.nodeTag(ed.lhs) == .var_decl) {
                    if (seen_non_decl) ctx.report(ed.lhs);
                    seen_var = true;
                } else seen_non_decl = true;
            },
            else => { seen_non_decl = true; },
        }
    }
}

/// Find the body block of the function node.
fn getFunctionBody(tag: Node.Tag, data: Node.Data, ctx: *const LintContext) NodeIndex {
    return switch (tag) {
        .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
        .generator_fn_decl, .generator_fn_expr,
        .async_generator_fn_decl, .async_generator_fn_expr,
        => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.body;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk ad.body;
        },
        .method_def, .getter_def, .setter_def,
        .computed_method_def, .computed_getter_def, .computed_setter_def,
        .constructor_def,
        => blk: {
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            break :blk md.body;
        },
        else => .none,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    if (tag == .root) {
        checkImmediateVarsOnTop(node, ctx);
        return;
    }
    if (tag == .static_block) {
        // Static blocks: string literals are NOT directives (static blocks are always strict).
        checkImmediateVarsOnTopEx(node, ctx, false);
        return;
    }
    const data = ctx.nodeData(node);
    const body = getFunctionBody(tag, data, ctx);
    checkImmediateVarsOnTop(body, ctx);
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const total = symbols.count();

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        if (symbols.getBindingKind(id) != .@"var") continue;

        const decl_node = symbols.getDeclNode(id);
        if (decl_node == .none) continue;

        // Walk up from decl_node to find the nearest var_decl ancestor.
        var var_decl_node: NodeIndex = .none;
        var current = decl_node;
        var depth: u32 = 0;
        while (current != .none and depth < 8) : (depth += 1) {
            if (ctx.nodeTag(current) == .var_decl) {
                var_decl_node = current;
                break;
            }
            current = ctx.parentOf(current);
        }
        if (var_decl_node == .none) continue;

        // Get the parent of the var_decl — if it's NOT the direct function/root body, flag it.
        const var_parent = ctx.parentOf(var_decl_node);
        if (var_parent == .none) continue;

        const var_parent_tag = ctx.nodeTag(var_parent);
        switch (var_parent_tag) {
            .block_stmt, .root => {
                // Direct child of function/root body → handled by checkImmediateVarsOnTop.
                const block_parent = ctx.parentOf(var_parent);
                if (block_parent == .none) continue;
                const bp_tag = ctx.nodeTag(block_parent);
                if (bp_tag == .root or isFunctionLike(bp_tag)) continue;
                // Nested block (inside if/for/switch/try) → var is not on top.
                ctx.report(var_decl_node);
            },
            // Vars at the immediate top of a static block → handled by run().
            .static_block => continue,
            // export var x: export_named wraps the var, treat as function-level.
            .export_named => continue,
            // Vars in for-init, for-in binding, try, etc. — not at top.
            else => {
                ctx.report(var_decl_node);
            },
        }
    }
}
