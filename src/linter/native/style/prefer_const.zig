const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ReferenceKind = @import("../../../parser/reference.zig").ReferenceKind;
const Span = @import("../../../parser/span.zig").Span;

pub const relevant_tags = [_]Node.Tag{};
pub const needs_ref_ranges = true;

pub const meta = RuleMeta{
    .name = "prefer-const",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest using `const` for variables that are never reassigned",
};

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Walk up to find the let_decl ancestor. Returns .none if not found.
fn findLetDecl(ctx: *const LintContext, decl_node: NodeIndex) NodeIndex {
    var current = decl_node;
    var depth: u32 = 0;
    while (depth < 10) : (depth += 1) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return .none;
        switch (ctx.nodeTag(parent)) {
            .let_decl => return parent,
            .declarator, .array_pattern, .object_pattern, .assignment_pattern,
            .shorthand_property, .property, .rest_element,
            => current = parent,
            else => return .none,
        }
    }
    return .none;
}

/// Walk up to find the parent of the let_decl (the enclosing block/for-stmt/etc).
fn declParentBlock(ctx: *const LintContext, decl_node: NodeIndex) NodeIndex {
    var current = decl_node;
    var depth: u32 = 0;
    while (depth < 10) : (depth += 1) {
        const parent = ctx.parentOf(current);
        if (parent == .none) return .none;
        switch (ctx.nodeTag(parent)) {
            .var_decl, .let_decl, .const_decl => return ctx.parentOf(parent),
            .declarator, .array_pattern, .object_pattern, .assignment_pattern,
            .shorthand_property, .property, .rest_element,
            => current = parent,
            else => return .none,
        }
    }
    return .none;
}

fn isDeclInPattern(ctx: *const LintContext, decl_node: NodeIndex) bool {
    const parent = ctx.parentOf(decl_node);
    if (parent == .none) return false;
    return switch (ctx.nodeTag(parent)) {
        .array_pattern, .object_pattern, .assignment_pattern,
        .shorthand_property, .property, .rest_element,
        => true,
        else => false,
    };
}

fn writeParentBlock(ctx: *const LintContext, write_node: NodeIndex) NodeIndex {
    const assign = ctx.parentOf(write_node);
    if (assign == .none) return .none;
    switch (ctx.nodeTag(assign)) {
        .assign => {},
        else => return .none,
    }
    const expr_stmt = ctx.parentOf(assign);
    if (expr_stmt == .none) return .none;
    switch (ctx.nodeTag(expr_stmt)) {
        .expression_stmt => {},
        else => return .none,
    }
    return ctx.parentOf(expr_stmt);
}

/// Report with autofix: replace the `let` keyword with `const`.
fn reportFix(ctx: *const LintContext, report_node: NodeIndex, decl_node: NodeIndex) void {
    const let_decl = findLetDecl(ctx, decl_node);
    if (let_decl != .none) {
        const let_tok = ctx.nodeMainToken(let_decl);
        const let_start = ctx.tokenStart(let_tok);
        ctx.reportWithFix(report_node, Span{ .start = let_start, .end = let_start + 3 }, "const");
    } else {
        ctx.report(report_node);
    }
}

/// Returns true if the source has a `/*exported varName*/` directive for this symbol.
fn isExportedViaDirective(src: []const u8, sym_name: []const u8) bool {
    var i: usize = 0;
    while (i + 2 < src.len) {
        if (src[i] != '/' or src[i + 1] != '*') { i += 1; continue; }
        const start = i + 2;
        var end = start;
        while (end + 1 < src.len and !(src[end] == '*' and src[end + 1] == '/')) end += 1;
        const content = src[start..end];
        // Check for "exported varName" in the comment (with optional surrounding spaces).
        if (std.mem.indexOf(u8, content, "exported") != null) {
            if (std.mem.indexOf(u8, content, sym_name) != null) return true;
        }
        i = if (end + 2 <= src.len) end + 2 else src.len;
    }
    return false;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const symbols = ctx.symbols();
    const refs = ctx.references();
    const ref_by_sym = ctx.semantic.ref_by_sym;
    const count = symbols.count();
    const src = ctx.source();

    const destructuring_str = ctx.getOptionString("destructuring");
    const destructuring_all = if (destructuring_str) |s| std.mem.eql(u8, s, "all") else false;
    const ignore_read_before_assign = ctx.getOptionBool("ignoreReadBeforeAssign", false);

    var i: u32 = 0;
    while (i < count) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);
        if (!flags.is_let) continue;

        const ref_range = symbols.getRefRange(id);
        var init_writes: u32 = 0;
        var plain_writes: u32 = 0;
        var compound_writes: u32 = 0;

        var r = ref_range.start;
        while (r < ref_range.end) : (r += 1) {
            const ref_id = ref_by_sym[r];
            switch (refs.getKind(ref_id)) {
                .write_init => init_writes += 1,
                .write => plain_writes += 1,
                .read_write => compound_writes += 1,
                .read, .type_of => {},
            }
        }

        if (compound_writes > 0) continue;

        const decl_node = symbols.getDeclNode(id);
        const in_pattern = isDeclInPattern(ctx, decl_node);

        // Case A: no plain writes (init-only, pattern binding, or for-in/of loop var).
        if (plain_writes == 0) {
            const decl_blk = declParentBlock(ctx, decl_node);
            if (decl_blk == .none) continue;

            if (init_writes == 0 and !in_pattern) {
                switch (ctx.nodeTag(decl_blk)) {
                    .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
                        const sym_name = symbols.getName(id);
                        if (isExportedViaDirective(src, sym_name)) continue;
                        reportFix(ctx, decl_node, decl_node);
                    },
                    else => {},
                }
                continue;
            }

            if (in_pattern and destructuring_all) continue;

            switch (ctx.nodeTag(decl_blk)) {
                .for_stmt => continue,
                else => {},
            }

            const sym_name = symbols.getName(id);
            if (isExportedViaDirective(src, sym_name)) continue;

            // ignoreReadBeforeAssign: skip if any read precedes the initializer write.
            if (ignore_read_before_assign and init_writes > 0) {
                var write_pos: u32 = std.math.maxInt(u32);
                var rr = ref_range.start;
                while (rr < ref_range.end) : (rr += 1) {
                    const rref = ref_by_sym[rr];
                    if (refs.getKind(rref) == .write_init) {
                        write_pos = ctx.nodeSpan(refs.getNode(rref)).start;
                        break;
                    }
                }
                var has_early_read = false;
                rr = ref_range.start;
                while (rr < ref_range.end) : (rr += 1) {
                    const rref = ref_by_sym[rr];
                    switch (refs.getKind(rref)) {
                        .read, .type_of => {
                            if (ctx.nodeSpan(refs.getNode(rref)).start < write_pos) {
                                has_early_read = true;
                                break;
                            }
                        },
                        else => {},
                    }
                }
                if (has_early_read) continue;
            }

            reportFix(ctx, decl_node, decl_node);
            continue;
        }

        // Case B: exactly one plain write at the same block level.
        if (init_writes == 0 and plain_writes == 1 and !in_pattern) {
            const decl_blk = declParentBlock(ctx, decl_node);
            if (decl_blk == .none) continue;

            switch (ctx.nodeTag(decl_blk)) {
                .for_in_stmt, .for_of_stmt, .for_await_of_stmt, .for_stmt => continue,
                else => {},
            }

            r = ref_range.start;
            while (r < ref_range.end) : (r += 1) {
                const ref_id = ref_by_sym[r];
                if (refs.getKind(ref_id) != .write) continue;
                const write_node = refs.getNode(ref_id);
                const write_blk = writeParentBlock(ctx, write_node);
                if (write_blk != .none and write_blk == decl_blk) {
                    // ignoreReadBeforeAssign: skip if any read comes before this write.
                    if (ignore_read_before_assign) {
                        const write_pos = ctx.nodeSpan(write_node).start;
                        var has_early_read = false;
                        var rr = ref_range.start;
                        while (rr < ref_range.end) : (rr += 1) {
                            const rref = ref_by_sym[rr];
                            if (refs.getKind(rref) == .read or refs.getKind(rref) == .type_of) {
                                if (ctx.nodeSpan(refs.getNode(rref)).start < write_pos) {
                                    has_early_read = true;
                                    break;
                                }
                            }
                        }
                        if (has_early_read) break;
                    }
                    // Report at the write node (ESLint convention for Case B).
                    reportFix(ctx, write_node, decl_node);
                }
                break;
            }
        }
    }
}
