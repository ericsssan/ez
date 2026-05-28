// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-obj-calls

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-obj-calls",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow calling global object properties as functions",
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr, .new_expr };

pub const needs_semantic = true;

const allNonCallableGlobals = [_][]const u8{ "Math", "JSON", "Reflect", "Atomics", "Intl" };

const es2015Globals = [_][]const u8{ "Reflect", "Intl" };

const es2017Globals = [_][]const u8{ "Atomics" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

fn isNonCallableGlobal(name: []const u8, ctx: *const LintContext) bool {
    for (allNonCallableGlobals) |n| {
        if (!std.mem.eql(u8, name, n)) continue;
        if (ctx.globalIsOff(name)) return false;
        if (containsStr(es2015Globals[0..], name) and
            ctx.getEcmaVersion() < 2015 and
            !ctx.globalIsExplicitlyEnabled(name)) return false;
        if (containsStr(es2017Globals[0..], name) and
            ctx.getEcmaVersion() < 2017 and
            !ctx.globalIsExplicitlyEnabled(name)) return false;
        return true;
    }
    return false;
}

/// True for `globalThis`, `window`, `self`, `global` identifiers that are the
/// global object (not locally shadowed). `globalThis` requires ES2020+.
fn isGlobalObjectRef(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (std.mem.eql(u8, name, "globalThis")) {
        if (ctx.getEcmaVersion() < 2020) return false;
        if (ctx.identifierShadowsBindingOrGlobal(node)) return false;
        if (ctx.globalIsExplicitlyDisabled("globalThis")) return false;
        return true;
    }
    if (!std.mem.eql(u8, name, "window") and
        !std.mem.eql(u8, name, "self") and
        !std.mem.eql(u8, name, "global")) return false;
    if (ctx.identifierShadowsBindingOrGlobal(node)) return false;
    return true;
}

/// Check if an expression is a non-callable global reference:
/// - Direct identifier: `JSON`, `Math`, etc.
/// - Member: `globalThis.JSON`, `window.Atomics`, etc.
/// - Ternary: either branch matches (may-analysis)
fn exprIsNonCallableGlobal(expr: NodeIndex, ctx: *const LintContext) bool {
    if (expr == .none) return false;
    var n = expr;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    switch (ctx.nodeTag(n)) {
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(n));
            if (!isNonCallableGlobal(name, ctx)) return false;
            // Must be the implicit global, not a local variable
            const ref_id = ctx.nodeRefId(n);
            if (ref_id == .none) return true; // unresolved = global
            const sym = ctx.references().getSymbol(ref_id);
            if (sym == .none or ctx.symbols().isImplicitGlobal(sym)) return true;
            return false;
        },
        .member_expr, .optional_member_expr => {
            const obj = ctx.nodeData(n).lhs;
            if (obj == .none) return false;
            if (!isGlobalObjectRef(obj, ctx)) return false;
            const prop = ctx.tokenText(ctx.nodeMainToken(n));
            return isNonCallableGlobal(prop, ctx);
        },
        .conditional => {
            const idx = @intFromEnum(ctx.nodeData(n).rhs);
            if (idx + 1 >= ctx.ast.extra_data.len) return false;
            const cond = ctx.extraData(ast.Conditional, idx);
            return exprIsNonCallableGlobal(cond.consequent, ctx) or
                exprIsNonCallableGlobal(cond.alternate, ctx);
        },
        else => return false,
    }
}

/// Unwrap grouping, then check if the callee is `globalThis.Math` etc.
fn isGlobalThisCallCallee(raw_callee: NodeIndex, ctx: *const LintContext) bool {
    var callee = raw_callee;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;

    switch (ctx.nodeTag(callee)) {
        .member_expr, .optional_member_expr => {
            const obj = ctx.nodeData(callee).lhs;
            if (obj == .none) return false;
            if (!isGlobalObjectRef(obj, ctx)) return false;
            const prop = ctx.tokenText(ctx.nodeMainToken(callee));
            return isNonCallableGlobal(prop, ctx);
        },
        else => return false,
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const raw_callee = ctx.nodeData(node).lhs;
    if (raw_callee == .none) return;
    if (isGlobalThisCallCallee(raw_callee, ctx)) {
        ctx.reportWithMessageId(node, "unexpectedCall");
    }
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        const ref_identifier = refs.getNode(ref_id);
        const name = ctx.tokenText(ctx.nodeMainToken(ref_identifier));

        // Case 1: direct call of an implicit global (Math(), JSON(), etc.)
        if (refs.isResolved(ref_id)) {
            const sym = refs.getSymbol(ref_id);
            if (sym == .none or !ctx.symbols().isImplicitGlobal(sym)) {
                // Resolved to a local — check for unexpectedRefCall (variable aliasing)
                if (sym != .none) {
                    const parent = ctx.parentOfSkipGrouping(ref_identifier);
                    const pt = ctx.nodeTag(parent);
                    const is_call = (pt == .call_expr or pt == .optional_call_expr or pt == .new_expr) and
                        ctx.calleeOf(parent) == ref_identifier;
                    if (is_call) {
                        if (ctx.constInitializerOf(ref_identifier)) |init| {
                            if (exprIsNonCallableGlobal(init, ctx)) {
                                ctx.reportWithMessageId(parent, "unexpectedRefCall");
                            }
                        }
                    }
                }
                continue;
            }
        }

        if (!isNonCallableGlobal(name, ctx)) continue;
        const parent = ctx.parentOfSkipGrouping(ref_identifier);
        const pt = ctx.nodeTag(parent);
        const is_call = (pt == .call_expr or pt == .optional_call_expr or pt == .new_expr) and
            ctx.calleeOf(parent) == ref_identifier;
        if (is_call) {
            ctx.reportWithMessageId(parent, "unexpectedCall");
        }
    }
}
