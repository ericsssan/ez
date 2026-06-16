// HAND-WRITTEN.
// Rule: no-this-before-super
// Disallow use of `this`/`super` before calling `super()` in constructors.

const std = @import("std");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-this-before-super",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow `this`/`super` before calling `super()` in constructors.",
};

pub const relevant_tags = [_]Node.Tag{ .method_def, .constructor_def };

pub const needs_semantic = true;

fn isFnOrClassTag(tag: Node.Tag) bool {
    return switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn, .method_def, .computed_method_def,
        .getter_def, .computed_getter_def, .setter_def, .computed_setter_def,
        .constructor_def, .class_decl, .class_expr => true,
        else => false,
    };
}

fn insideNestedFnOrClass(ctx: *const LintContext, node: NodeIndex, boundary: NodeIndex) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none and cur != boundary) : (cur = ctx.parentOf(cur)) {
        if (isFnOrClassTag(ctx.nodeTag(cur))) return true;
    }
    return false;
}

/// Branch/loop/short-circuit constructs that make a contained node conditionally
/// executed relative to the construct.  `try_stmt` is handled separately because
/// whether the try block "completes" depends on the presence of a catch clause.
fn isConditionalTag(tag: Node.Tag) bool {
    return switch (tag) {
        .if_stmt, .if_else_stmt,
        .while_stmt, .do_while_stmt,
        .for_stmt, .for_in_stmt, .for_of_stmt, .for_await_of_stmt,
        .switch_stmt,
        .conditional, .logical_and, .logical_or, .nullish_coalesce,
        .logical_and_assign, .logical_or_assign, .nullish_assign => true,
        else => false,
    };
}

/// True when entering `ancestor` guarantees `node` is reached and completed
/// unconditionally — no intervening branch/loop/short-circuit, and any `try`
/// boundary in between can only be crossed by the try block actually completing.
/// `node` must be a descendant of `ancestor`.
fn unconditionalWithin(ctx: *const LintContext, node: NodeIndex, ancestor: NodeIndex) bool {
    var cur = node;
    while (cur != ancestor) {
        const parent = ctx.parentOf(cur);
        if (parent == .none) return false;
        const ptag = ctx.nodeTag(parent);
        if (ptag == .try_stmt) {
            const pd = ctx.nodeData(parent);
            const tdata = ctx.extraData(ast.TryData, @intFromEnum(pd.rhs));
            if (cur == pd.lhs) {
                // In the try block: control only continues past the `try` having
                // run the block to completion when there is no catch to swallow a
                // throw. A catch makes the block's completion conditional.
                if (tdata.catch_node != .none) return false;
            } else if (cur == tdata.catch_node) {
                return false; // catch runs only on a thrown error
            }
            // else: the finally body — always runs when the try executes.
        } else if (isConditionalTag(ptag)) {
            return false;
        }
        cur = parent;
    }
    return true;
}

/// True when `a` is guaranteed to fully execute before control reaches `n`
/// (structured-control-flow dominance), bounded by `boundary` (the constructor).
/// `a` must be a guarantor node (a super() call or an if/else whose branches all
/// call super); `n` is a this/super use.
fn dominates(ctx: *const LintContext, a: NodeIndex, n: NodeIndex, boundary: NodeIndex) bool {
    // Collect a's ancestor chain up to boundary, recording the child we came from.
    var anc: [128]NodeIndex = undefined;
    var via: [128]NodeIndex = undefined;
    var len: usize = 0;
    {
        var child = a;
        var par = ctx.parentOf(a);
        while (par != .none) {
            anc[len] = par;
            via[len] = child;
            len += 1;
            if (par == boundary or len >= anc.len) break;
            child = par;
            par = ctx.parentOf(par);
        }
    }
    // Walk n upward; the first node shared with a's chain is the LCA.
    var child_n = n;
    var par_n = ctx.parentOf(n);
    while (par_n != .none) {
        var k: usize = 0;
        while (k < len) : (k += 1) {
            if (anc[k] != par_n) continue;
            const lca = par_n;
            const child_a = via[k];
            // n is inside a's subtree (e.g. `this` in super()'s arguments), or they
            // share the same forking child — a has not completed before n.
            if (child_a == child_n) return false;
            // Only a straight-line statement sequence lets an earlier sibling
            // dominate a later one. A conditional/loop/try LCA means different paths.
            if (ctx.nodeTag(lca) != .block_stmt) return false;
            // child_a's statement must textually precede child_n's, and `a` must be
            // reached unconditionally within child_a.
            const a_sp = ctx.nodeSpan(child_a);
            const n_sp = ctx.nodeSpan(child_n);
            if (a_sp.end > n_sp.start) return false;
            return unconditionalWithin(ctx, a, child_a);
        }
        child_n = par_n;
        par_n = ctx.parentOf(par_n);
    }
    return false;
}

/// True if `branch_root` definitely calls super(): some collected super() call is
/// inside it and unconditionally reached within it.
fn branchCallsSuper(ctx: *const LintContext, branch_root: NodeIndex, supers: []const NodeIndex) bool {
    if (branch_root == .none) return false;
    const b_sp = ctx.nodeSpan(branch_root);
    for (supers) |s| {
        const s_sp = ctx.nodeSpan(s);
        if (s_sp.start < b_sp.start or s_sp.end > b_sp.end) continue;
        if (unconditionalWithin(ctx, s, branch_root)) return true;
    }
    return false;
}

/// True when an if/else statement calls super() on BOTH branches, so super is
/// guaranteed to have completed once control passes the statement.
fn bothBranchesCallSuper(ctx: *const LintContext, e: NodeIndex, supers: []const NodeIndex) bool {
    const d = ctx.nodeData(e);
    if (d.rhs == .none) return false;
    const idata = ctx.extraData(ast.IfData, @intFromEnum(d.rhs));
    return branchCallsSuper(ctx, idata.consequent, supers) and
        branchCallsSuper(ctx, idata.alternate, supers);
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.isConstructorMethod(node)) return;

    // Find the enclosing class.
    var class_node: NodeIndex = .none;
    {
        var cur = ctx.parentOf(node);
        while (cur != .none) : (cur = ctx.parentOf(cur)) {
            const t = ctx.nodeTag(cur);
            if (t == .class_decl or t == .class_expr) { class_node = cur; break; }
        }
    }
    if (class_node == .none) return;

    // Only derived classes need super() before this.
    const class_nd = ctx.nodeData(class_node);
    const class_d = ctx.extraData(ast.ClassData, @intFromEnum(class_nd.lhs));
    if (class_d.super_class == .none) return;

    // Get constructor body.
    const ndata = ctx.nodeData(node);
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ndata.rhs));
    const body = md.body;
    if (body == .none) return;

    const body_span = ctx.nodeSpan(body);
    const total: u32 = @intCast(ctx.ast.nodes.len);

    // Pass 1: collect super() calls and if/else statements inside this constructor
    // body (excluding nested functions/classes).
    const MAX = 128;
    var supers: [MAX]NodeIndex = undefined;
    var super_len: usize = 0;
    var ifelse: [MAX]NodeIndex = undefined;
    var ifelse_len: usize = 0;

    {
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            const tag = ctx.nodeTag(ni);
            const is_super_call = tag == .call_expr and blk: {
                const cd = ctx.nodeData(ni);
                break :blk cd.lhs != .none and ctx.nodeTag(cd.lhs) == .super_expr;
            };
            if (!is_super_call and tag != .if_else_stmt) continue;

            const sp = ctx.nodeSpan(ni);
            if (sp.start < body_span.start or sp.end > body_span.end) continue;
            if (insideNestedFnOrClass(ctx, ni, node)) continue;

            if (is_super_call) {
                if (super_len < MAX) { supers[super_len] = ni; super_len += 1; }
            } else {
                if (ifelse_len < MAX) { ifelse[ifelse_len] = ni; ifelse_len += 1; }
            }
        }
    }

    // Guarantors: each super() call, plus any if/else whose branches all call super
    // (after which super has definitely completed).
    var guarantors: [MAX * 2]NodeIndex = undefined;
    var g_len: usize = 0;
    for (supers[0..super_len]) |s| {
        if (g_len < guarantors.len) { guarantors[g_len] = s; g_len += 1; }
    }
    for (ifelse[0..ifelse_len]) |e| {
        if (bothBranchesCallSuper(ctx, e, supers[0..super_len])) {
            if (g_len < guarantors.len) { guarantors[g_len] = e; g_len += 1; }
        }
    }

    // Pass 2: for each `this` / `super` used as the object of a member access in
    // this constructor body (excluding nested functions/classes), flag it unless a
    // guarantor dominates it (super definitely completed before it on all paths).
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const ni_tag = ctx.nodeTag(ni);
        if (ni_tag != .this_expr and ni_tag != .super_expr) continue;

        // Must be the object (lhs) of a member-access expression. (`super()` call
        // callees have parent call_expr and are intentionally not reported.)
        const parent = ctx.parentOf(ni);
        if (parent == .none) continue;
        const ptag = ctx.nodeTag(parent);
        const is_member_obj = switch (ptag) {
            .member_expr, .optional_member_expr,
            .computed_member_expr, .optional_computed_member_expr => ctx.nodeData(parent).lhs == ni,
            else => false,
        };
        if (!is_member_obj) continue;

        const sp = ctx.nodeSpan(ni);
        if (sp.start < body_span.start or sp.end > body_span.end) continue;
        if (insideNestedFnOrClass(ctx, ni, node)) continue;

        var safe = false;
        for (guarantors[0..g_len]) |g| {
            if (dominates(ctx, g, ni, node)) { safe = true; break; }
        }
        if (!safe) ctx.reportWithMessageId(ni, "noBeforeSuper");
    }
}
