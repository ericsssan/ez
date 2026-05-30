// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-misused-promises
//
// Disallow Promises in places not designed to handle them.  Covers:
//   - conditional: Promise as the test of a conditional / logical /
//     unary-! / loop-test.
//   - voidReturnArgument: async/Promise-returning callback passed as
//     a callback argument that expects `() => void`.
//   - voidReturnVariable: async/Promise-returning function assigned
//     to a variable typed `() => void`.
//   - voidReturnProperty: async/Promise-returning function as object
//     property whose contextual type is `() => void`.
//   - voidReturnReturnValue: returning a Promise-returning function
//     from a function typed `() => () => void`.
//   - voidReturnInheritedMethod: async method that overrides a
//     parent's void method.
//   - predicate: array-predicate methods (.filter/.every/.some/.find)
//     with async callback.
//   - spread: spreading a Promise.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-misused-promises",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow Promises in places not designed to handle them",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    // Conditional contexts
    .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt, .for_stmt, .conditional, .logical_and, .logical_or, .nullish_coalesce, .logical_not,
    // Spread
    .spread_element,
    // Calls / new (for argument / predicate checks)
    .call_expr, .optional_call_expr, .new_expr,
    // Assignments and declarators (voidReturnVariable)
    .assign, .declarator,
    // Object property (voidReturnProperty)
    .property, .shorthand_property, .method_def,
    // Return statement (voidReturnReturnValue)
    .return_stmt,
    // Class / interface for inherited-method check
    .class_decl, .class_expr, .ts_interface_decl,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const cfg = readOptions(ctx);
    switch (tag) {
        .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt => if (cfg.conditionals) checkTestConditional(node, ctx),
        .for_stmt => if (cfg.conditionals) checkForTest(node, ctx),
        .conditional => if (cfg.conditionals) checkConditionalExpr(node, ctx),
        .logical_and, .logical_or, .nullish_coalesce => if (cfg.conditionals) checkLogical(node, ctx),
        .logical_not => if (cfg.conditionals) checkLogicalNot(node, ctx),
        .spread_element => if (cfg.spreads) checkSpread(node, ctx),
        .call_expr, .optional_call_expr, .new_expr => {
            if (cfg.arguments_) checkArguments(node, ctx);
            if (cfg.conditionals and (tag == .call_expr or tag == .optional_call_expr)) checkArrayPredicate(node, ctx);
        },
        .assign => if (cfg.variables) checkAssignment(node, ctx),
        .declarator => if (cfg.variables) checkDeclarator(node, ctx),
        .property => if (cfg.properties) checkProperty(node, ctx),
        .shorthand_property => if (cfg.properties) checkShorthandProperty(node, ctx),
        .method_def => if (cfg.properties) checkObjectMethod(node, ctx),
        .return_stmt => if (cfg.returns_) checkReturn(node, ctx),
        .class_decl, .class_expr => if (cfg.inherited_methods) checkInheritedMethods(node, ctx),
        .ts_interface_decl => if (cfg.inherited_methods) checkInterfaceInheritedMethods(node, ctx),
        else => {},
    }
}

const Config = struct {
    conditionals: bool = true,
    spreads: bool = true,
    arguments_: bool = true,
    properties: bool = true,
    returns_: bool = true,
    variables: bool = true,
    inherited_methods: bool = true,
    attributes: bool = true,
};

fn readOptions(ctx: *const LintContext) Config {
    var cfg = Config{};
    const opts = ctx.rule_options orelse return cfg;
    if (opts.* != .object) return cfg;
    if (opts.object.get("checksConditionals")) |v| {
        if (v == .bool) cfg.conditionals = v.bool;
    }
    if (opts.object.get("checksSpreads")) |v| {
        if (v == .bool) cfg.spreads = v.bool;
    }
    if (opts.object.get("checksVoidReturn")) |v| {
        if (v == .bool) {
            const b = v.bool;
            cfg.arguments_ = b;
            cfg.properties = b;
            cfg.returns_ = b;
            cfg.variables = b;
            cfg.inherited_methods = b;
            cfg.attributes = b;
        } else if (v == .object) {
            if (v.object.get("arguments")) |x| if (x == .bool) { cfg.arguments_ = x.bool; };
            if (v.object.get("attributes")) |x| if (x == .bool) { cfg.attributes = x.bool; };
            if (v.object.get("inheritedMethods")) |x| if (x == .bool) { cfg.inherited_methods = x.bool; };
            if (v.object.get("properties")) |x| if (x == .bool) { cfg.properties = x.bool; };
            if (v.object.get("returns")) |x| if (x == .bool) { cfg.returns_ = x.bool; };
            if (v.object.get("variables")) |x| if (x == .bool) { cfg.variables = x.bool; };
        }
    }
    return cfg;
}

// ────────────────────────────────────────────────────────────────────
// "conditional" — Promise used as a truthiness test.
// ────────────────────────────────────────────────────────────────────

fn checkTestConditional(node: NodeIndex, ctx: *const LintContext) void {
    // if_stmt: lhs = test; while_stmt: lhs = test; do_while_stmt: lhs = body, rhs = test
    const data = ctx.nodeData(node);
    const test_node = if (ctx.nodeTag(node) == .do_while_stmt) data.rhs else data.lhs;
    if (test_node == .none) return;
    reportPromiseIfFound(test_node, true, ctx);
}

fn checkForTest(node: NodeIndex, ctx: *const LintContext) void {
    // for_stmt: init/test/update in extra ForData
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
    if (fd.condition == .none) return;
    reportPromiseIfFound(fd.condition, true, ctx);
}

fn checkConditionalExpr(node: NodeIndex, ctx: *const LintContext) void {
    // conditional: lhs = condition; rhs = extra Conditional
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    reportPromiseIfFound(data.lhs, true, ctx);
}

fn checkLogicalNot(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    reportPromiseIfFound(data.lhs, true, ctx);
}

/// Logical expressions: the rule recurses through &&/|| chains.  We
/// fire on either operand only when the chain is itself in a test
/// position — to avoid double-firing inside loops/if which already
/// handle their tests, we restrict to logical_and/logical_or that are
/// themselves not in a known test slot.  Easier behavior that matches
/// TSe: fire on the left of && / || / ?? if it's Promise.  The right
/// is fired on only if the logical chain is in a test position.
fn checkLogical(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const tag = ctx.nodeTag(node);
    // For ??, only check the left side when in a test context.
    if (tag == .nullish_coalesce) {
        if (!inTestContext(node, ctx)) return;
        reportPromiseIfFound(data.lhs, true, ctx);
        if (data.rhs != .none) reportPromiseIfFound(data.rhs, true, ctx);
        return;
    }
    reportPromiseIfFound(data.lhs, true, ctx);
    if (inTestContext(node, ctx) and data.rhs != .none) reportPromiseIfFound(data.rhs, true, ctx);
}

fn inTestContext(node: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    var cur = node;
    while (p != .none) {
        const pt = ctx.nodeTag(p);
        switch (pt) {
            .if_stmt, .if_else_stmt, .while_stmt, .do_while_stmt => return true,
            .for_stmt => {
                const fd = ctx.extraData(ast.ForData, @intFromEnum(ctx.nodeData(p).lhs));
                if (fd.condition == cur) return true;
                return false;
            },
            .conditional => return ctx.nodeData(p).lhs == cur,
            .logical_and, .logical_or, .nullish_coalesce, .logical_not, .grouping_expr => {
                cur = p;
                p = ctx.parentOf(p);
            },
            else => return false,
        }
    }
    return false;
}

fn reportPromiseIfFound(node: NodeIndex, _: bool, ctx: *const LintContext) void {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // Don't recurse into logical_and/or/nullish_coalesce — those are
    // their own relevant_tags entries and get visited separately.
    if (exprIsAlwaysThenable(n, ctx)) {
        ctx.reportWithMessageId(n, "conditional");
    }
}

// ────────────────────────────────────────────────────────────────────
// "spread" — spreading a Promise.
// ────────────────────────────────────────────────────────────────────

fn checkSpread(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    if (exprIsSometimesThenable(data.lhs, ctx)) {
        // Report on the argument (TSe's convention) — peel grouping_expr.
        var n = data.lhs;
        while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
        ctx.reportWithMessageId(n, "spread");
    }
}

// ────────────────────────────────────────────────────────────────────
// "voidReturnArgument" — async callback in a void-returning slot.
// ────────────────────────────────────────────────────────────────────

fn checkArguments(node: NodeIndex, ctx: *const LintContext) void {
    // Skip Promise.x().finally(...).
    if (isPromiseFinally(node, ctx)) return;
    // For each argument, check the callee's parameter type at that
    // position.  When the parameter expects `() => void` and the
    // argument is a Promise-returning callback, fire.
    const callee = calleeOf(node, ctx);
    if (callee == .none) return;
    var args_buf: [16]NodeIndex = undefined;
    const args = callArguments(node, &args_buf, ctx);
    for (args, 0..) |arg, idx| {
        // Spread `...cbs`: check if cbs is an array of Promise-returning fns
        // and the callee's corresponding param expects void-returning.
        if (ctx.nodeTag(arg) == .spread_element) {
            const expected_void = paramExpectsVoidReturningFn(callee, idx, args.len, node, ctx);
            if (!expected_void) continue;
            if (spreadOfPromiseReturningArray(arg, ctx)) {
                ctx.reportWithMessageId(arg, "voidReturnArgument");
            }
            continue;
        }
        const expected_void = paramExpectsVoidReturningFn(callee, idx, args.len, node, ctx);
        if (!expected_void) continue;
        if (exprIsPromiseReturningFn(arg, ctx)) {
            ctx.reportSpanWithMessageId(reportSpanForArg(arg, ctx), "voidReturnArgument");
        }
    }
}

fn spreadOfPromiseReturningArray(spread_node: NodeIndex, ctx: *const LintContext) bool {
    const expr = ctx.nodeData(spread_node).lhs;
    if (expr == .none) return false;
    var e = expr;
    while (ctx.nodeTag(e) == .grouping_expr) e = ctx.nodeData(e).lhs;
    // Direct array literal of promise-returning fns.
    if (ctx.nodeTag(e) == .array_literal) {
        const arms = directRange(e, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (m == .none) continue;
            if (exprIsPromiseReturningFn(m, ctx)) return true;
        }
        return false;
    }
    // `as const` cast on array literal.
    if (ctx.nodeTag(e) == .ts_as_expr) {
        return spreadOfPromiseReturningArray(_makeSpreadOf(ctx.nodeData(e).lhs), ctx);
    }
    // Identifier referencing an array variable.
    if (ctx.nodeTag(e) == .identifier) {
        return identifierIsPromiseFnArray(e, ctx);
    }
    return false;
}

fn _makeSpreadOf(n: NodeIndex) NodeIndex {
    _ = n;
    return .none;
}

fn identifierIsPromiseFnArray(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return false;
    // Check via annotation: Array<() => Promise<X>>.
    const bd = ctx.nodeData(decl);
    if (bd.rhs != .none and ctx.nodeTag(bd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(bd.rhs).lhs;
        if (arrayElemIsPromiseReturningFn(ty, ctx)) return true;
    }
    // Otherwise check the initializer if it's an array literal.
    const parent = ctx.parentOf(decl);
    if (parent != .none and ctx.nodeTag(parent) == .declarator) {
        const init = ctx.nodeData(parent).rhs;
        if (init != .none) {
            var i = init;
            while (ctx.nodeTag(i) == .grouping_expr) i = ctx.nodeData(i).lhs;
            // `[...] as const`
            if (ctx.nodeTag(i) == .ts_as_expr) i = ctx.nodeData(i).lhs;
            if (ctx.nodeTag(i) == .array_literal) {
                const arms = directRange(i, ctx) orelse return false;
                for (arms) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (m == .none) continue;
                    if (exprIsPromiseReturningFn(m, ctx)) return true;
                }
            }
        }
    }
    return false;
}

fn arrayElemIsPromiseReturningFn(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (ctx.nodeTag(inner) == .ts_array_type) {
        return typeIsPromiseReturningFn(ctx.nodeData(inner).lhs, ctx);
    }
    if (ctx.nodeTag(inner) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
            const args = ctx.nodeData(inner).rhs;
            if (args == .none) return false;
            const idx = @intFromEnum(args);
            if (idx + 1 >= ctx.ast.extra_data.len) return false;
            const s = ctx.ast.extra_data[idx];
            const e = ctx.ast.extra_data[idx + 1];
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
            return typeIsPromiseReturningFn(first, ctx);
        }
    }
    return false;
}

fn reportSpanForArg(arg: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    var n = arg;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    var sp = ctx.nodeSpan(n);
    // For async arrow / fn expr, walk backward from sp.start through
    // any whitespace and pick up the preceding `async` keyword if found.
    if (tag == .async_arrow_fn or tag == .async_fn_expr or tag == .async_generator_fn_expr) {
        const src = ctx.ast.source;
        var i: isize = @as(isize, @intCast(sp.start)) - 1;
        // Skip whitespace.
        while (i >= 0 and (src[@intCast(i)] == ' ' or src[@intCast(i)] == '\t')) i -= 1;
        if (i >= 4) {
            const start = @as(usize, @intCast(i)) - 4;
            if (std.mem.eql(u8, src[start..start + 5], "async")) {
                // Confirm word boundary.
                if (start == 0 or !isIdentChar(src[start - 1])) {
                    sp.start = @intCast(start);
                }
            }
        }
    }
    return sp;
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_' or c == '$';
}

fn callArguments(call_node: NodeIndex, buf: []NodeIndex, ctx: *const LintContext) []NodeIndex {
    // For call_expr / optional_call_expr / new_expr: rhs is SubRange into extra of args.
    const data = ctx.nodeData(call_node);
    if (data.rhs == .none) return buf[0..0];
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return buf[0..0];
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (s >= e or e > ctx.ast.extra_data.len) return buf[0..0];
    const slice = ctx.ast.extra_data[s..e];
    var n: usize = 0;
    for (slice) |raw| {
        if (n >= buf.len) break;
        buf[n] = @enumFromInt(raw);
        n += 1;
    }
    return buf[0..n];
}

fn calleeOf(call_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    return ctx.nodeData(call_node).lhs;
}

/// Determines if the parameter at `index` expects a `() => void`.
/// Hardcoded set of well-known cases + walking the callee's signature
/// annotation when available.
fn paramExpectsVoidReturningFn(callee: NodeIndex, index: usize, _: usize, call_node: NodeIndex, ctx: *const LintContext) bool {
    _ = call_node;
    var c = callee;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    // `f<T>(...)` — peel `ts_instantiation_expr` to get the underlying
    // identifier; the type args are captured from the wrapper for
    // substitution into the param's annotation.
    var type_arg_start: u32 = 0;
    var type_arg_end: u32 = 0;
    if (ctx.nodeTag(c) == .ts_instantiation_expr) {
        const inst_data = ctx.nodeData(c);
        if (inst_data.rhs != .none) {
            const sr = ctx.extraData(ast.SubRange, @intFromEnum(inst_data.rhs));
            type_arg_start = sr.start;
            type_arg_end = sr.end;
        }
        c = inst_data.lhs;
        while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    }
    const ct = ctx.nodeTag(c);
    // `new Promise(executor)`: executor signature is `(resolve, reject) => void`.
    if (ct == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(c));
        if (std.mem.eql(u8, name, "Promise")) {
            // For `new Promise(...)`, only the first arg position is the
            // executor — and it expects void.
            if (index == 0) return true;
        }
    }
    if (ct == .member_expr or ct == .optional_member_expr) {
        const md = ctx.nodeData(c);
        if (md.rhs != .none) {
            const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
            // Array.prototype methods whose callback is void-returning.
            if (std.mem.eql(u8, m, "forEach")) return index == 0;
        }
    }
    // Resolve identifier callee to its declaration and inspect param annotation.
    if (ct == .identifier) {
        if (calleeParamIsVoidFn(c, index, type_arg_start, type_arg_end, ctx)) return true;
        // Identifier whose declared type is an interface with a call signature
        // whose Nth param expects void-returning.
        if (calleeInterfaceCallSigParamIsVoidFn(c, index, ctx)) return true;
        // `new X(...)` where X is a class with a constructor whose Nth param
        // expects void-returning.
        if (classConstructorParamIsVoidFn(c, index, ctx)) return true;
        // Overload-aware: walk peer fn_decls / ts_declare_function signatures.
        if (calleeOverloadParamIsVoidFn(c, index, ctx)) return true;
    }
    return false;
}

fn calleeOverloadParamIsVoidFn(ident: NodeIndex, index: usize, ctx: *const LintContext) bool {
    const name = ctx.tokenText(ctx.nodeMainToken(ident));
    if (name.len == 0) return false;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t != .fn_decl and t != .ts_declare_function and t != .generator_fn_decl and
            t != .async_fn_decl and t != .async_generator_fn_decl) continue;
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ni).lhs));
        if (fd.name == .none) continue;
        const peer_name = ctx.tokenText(ctx.nodeMainToken(fd.name));
        if (!std.mem.eql(u8, peer_name, name)) continue;
        if (paramIsVoidFnInSubrange(fd.params, fd.params_end, index, ctx)) return true;
    }
    return false;
}

fn calleeInterfaceCallSigParamIsVoidFn(ident: NodeIndex, index: usize, ctx: *const LintContext) bool {
    const ann = identifierAnnotation(ident, ctx);
    if (ann == .none) return false;
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(ty));
    // Capture type-argument substitution: `Foo<void>` → {T → void node}.
    var subst_names: [4][]const u8 = undefined;
    var subst_nodes: [4]NodeIndex = undefined;
    var subst_n: usize = 0;
    var any_void_only = false;
    var any_thenable = false;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_interface_decl) continue;
        const id = ctx.extraData(ast.InterfaceData, @intFromEnum(ctx.nodeData(ni).lhs));
        const iname = ctx.tokenText(id.name);
        if (!std.mem.eql(u8, iname, name)) continue;
        // Build substitution from the annotation's `<...>` args and the
        // interface's declared `<T, U, ...>` parameters.
        subst_n = collectInterfaceSubstitution(ty, id, ctx, &subst_names, &subst_nodes);
        if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) continue;
        for (ctx.ast.extra_data[id.body_start..id.body_end]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(m) != .ts_call_signature) continue;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
            if (sd.params_start >= sd.params_end or sd.params_end > ctx.ast.extra_data.len) continue;
            const params_slice = ctx.ast.extra_data[sd.params_start..sd.params_end];
            if (index >= params_slice.len) continue;
            const p: NodeIndex = @enumFromInt(params_slice[index]);
            const pann = paramAnnotation(p, ctx);
            if (pann == .none) continue;
            if (typeIsPromiseReturningFnAnnSubst(pann, subst_names[0..subst_n], subst_nodes[0..subst_n], ctx)) any_thenable = true
            else if (typeIsVoidReturningFnSubst(pann, subst_names[0..subst_n], subst_nodes[0..subst_n], ctx)) any_void_only = true;
        }
    }
    if (any_thenable) return false;
    return any_void_only;
}

/// Pair the interface's declared type parameters with the type-args
/// at the use site (`Foo<void>` → {T → void node}).  Returns the
/// number of bindings written.
fn collectInterfaceSubstitution(
    ref_node: NodeIndex,
    id: ast.InterfaceData,
    ctx: *const LintContext,
    names_out: *[4][]const u8,
    nodes_out: *[4]NodeIndex,
) usize {
    // `ts_type_reference.rhs` holds the SubRange of type args (when
    // present).  Interface's type_params SubRange holds
    // ts_type_parameter nodes.
    const ref_data = ctx.nodeData(ref_node);
    if (ref_data.rhs == .none) return 0;
    const arg_range = ctx.extraData(ast.SubRange, @intFromEnum(ref_data.rhs));
    if (arg_range.start >= arg_range.end or arg_range.end > ctx.ast.extra_data.len) return 0;
    const args = ctx.ast.extra_data[arg_range.start..arg_range.end];
    if (id.type_params_end <= id.type_params or id.type_params_end > ctx.ast.extra_data.len) return 0;
    const params = ctx.ast.extra_data[id.type_params..id.type_params_end];
    const n = @min(@min(args.len, params.len), names_out.len);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const tp: NodeIndex = @enumFromInt(params[i]);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        names_out[i] = ctx.tokenText(ctx.nodeMainToken(tp));
        nodes_out[i] = @enumFromInt(args[i]);
    }
    return n;
}

fn typeIsVoidReturningFnSubst(
    ann: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    if (names.len == 0) return typeIsVoidReturningFn(ann, ctx);
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    return typeIsVoidReturningFnInnerSubst(ty, names, nodes, ctx);
}

fn typeIsVoidReturningFnInnerSubst(
    ty: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_function_type) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(inner).lhs));
        // Substitute T in the return-type node, then check if it's void.
        const ret_sub = substituteTypeRef(fd.body, names, nodes, ctx);
        return returnTypeIsVoid(ret_sub, ctx);
    }
    return typeIsVoidReturningFnInner(inner, ctx);
}

fn typeIsPromiseReturningFnAnnSubst(
    ann: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    if (names.len == 0) return typeIsPromiseReturningFnAnn(ann, ctx);
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_function_type) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
        const ret_sub = substituteTypeRef(fd.body, names, nodes, ctx);
        return typeContainsPromiseInner(ret_sub, ctx);
    }
    return typeIsPromiseReturningFn(ty, ctx);
}

/// If `node` is a `ts_type_reference` whose name appears in `names`,
/// return the corresponding bound node.  Otherwise return `node`.
fn substituteTypeRef(
    node: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .ts_type_reference) return node;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    for (names, nodes) |k, v| {
        if (std.mem.eql(u8, k, name)) return v;
    }
    return node;
}

fn typeIsPromiseReturningFnAnn(ann: NodeIndex, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    return typeIsPromiseReturningFn(ty, ctx);
}

fn classConstructorParamIsVoidFn(ident: NodeIndex, index: usize, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    var class_node: NodeIndex = .none;
    if (ctx.nodeTag(decl) == .class_decl) class_node = decl;
    if (class_node == .none and ctx.nodeTag(decl) == .identifier) {
        const p = ctx.parentOf(decl);
        if (p != .none and ctx.nodeTag(p) == .class_decl) class_node = p;
    }
    if (class_node == .none) return false;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(class_node).lhs));
    const body = cd.body;
    if (body == .none) return false;
    const bd = ctx.nodeData(body);
    const bs = @intFromEnum(bd.lhs);
    const be = @intFromEnum(bd.rhs);
    if (bs >= be or be > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[bs..be]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .constructor_def) continue;
        const md_data = ctx.nodeData(m);
        const method_data = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
        if (paramIsVoidFnInSubrange(method_data.params_start, method_data.params_end, index, ctx)) return true;
    }
    return false;
}

/// Look up the identifier's declaration; if it's a function with a
/// typed parameter `(x: () => void) => ...`, return true.
fn calleeParamIsVoidFn(
    ident: NodeIndex,
    index: usize,
    type_arg_start: u32,
    type_arg_end: u32,
    ctx: *const LintContext,
) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dt = ctx.nodeTag(decl);
    var fn_data_node: NodeIndex = .none;
    var arrow_data_node: NodeIndex = .none;
    var explicit_ann: NodeIndex = .none;
    switch (dt) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl, .ts_declare_function => fn_data_node = decl,
        else => {},
    }
    if (fn_data_node == .none and dt == .identifier) {
        const p = ctx.parentOf(decl);
        if (p != .none) {
            const pt = ctx.nodeTag(p);
            if (pt == .fn_decl or pt == .async_fn_decl or pt == .generator_fn_decl or
                pt == .async_generator_fn_decl or pt == .ts_declare_function)
            {
                fn_data_node = p;
            } else if (pt == .declarator) {
                // const x = arrow_fn / fn_expr — use the initializer's params.
                const init = ctx.nodeData(p).rhs;
                if (init != .none) {
                    const it = ctx.nodeTag(init);
                    switch (it) {
                        .arrow_fn, .async_arrow_fn => arrow_data_node = init,
                        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => fn_data_node = init,
                        else => {},
                    }
                }
                // const x: (cb: () => void) => any — use the explicit annotation's params.
                const id_data = ctx.nodeData(decl);
                if (id_data.rhs != .none and ctx.nodeTag(id_data.rhs) == .ts_type_annotation) {
                    explicit_ann = id_data.rhs;
                }
            }
        }
    }
    if (explicit_ann != .none) {
        // `typeof Foo<Bar>` — peel the typeof and use the operand's
        // type args as if they were call-site type args on Foo.
        if (typeofWithTypeArgsParamIsVoidFn(explicit_ann, index, ctx)) return true;
        if (annotationParamIsVoidFnSubst(explicit_ann, index, type_arg_start, type_arg_end, ctx)) return true;
        return annotationParamIsVoidFn(explicit_ann, index, ctx) or
            annotationUnionParamIsVoidFn(explicit_ann, index, ctx);
    }
    if (fn_data_node != .none) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(fn_data_node).lhs));
        // Generic function declaration + explicit call-site type args
        // → build name→node bindings and apply them when checking
        // the rest-tuple / rest-array element type.
        if (type_arg_end > type_arg_start and
            fd.type_params_end > fd.type_params and
            fd.type_params_end <= ctx.ast.extra_data.len)
        {
            var names: [4][]const u8 = undefined;
            var nodes: [4]NodeIndex = undefined;
            const tp_slice = ctx.ast.extra_data[fd.type_params..fd.type_params_end];
            const ta_slice = ctx.ast.extra_data[type_arg_start..type_arg_end];
            const n = @min(@min(tp_slice.len, ta_slice.len), names.len);
            var ti: usize = 0;
            while (ti < n) : (ti += 1) {
                const tp: NodeIndex = @enumFromInt(tp_slice[ti]);
                if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
                names[ti] = ctx.tokenText(ctx.nodeMainToken(tp));
                nodes[ti] = @enumFromInt(ta_slice[ti]);
            }
            if (n > 0 and paramIsVoidFnInSubrangeSubst(fd.params, fd.params_end, index, names[0..n], nodes[0..n], ctx)) return true;
        }
        return paramIsVoidFnInSubrange(fd.params, fd.params_end, index, ctx);
    }
    if (arrow_data_node != .none) {
        const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(arrow_data_node).lhs));
        return paramIsVoidFnInSubrange(ad.params_start, ad.params_end, index, ctx);
    }
    return false;
}

fn paramIsVoidFnInSubrange(params_start: u32, params_end: u32, index: usize, ctx: *const LintContext) bool {
    if (params_start >= params_end or params_end > ctx.ast.extra_data.len) return false;
    const params_slice = ctx.ast.extra_data[params_start..params_end];
    if (index < params_slice.len) {
        const param_id: NodeIndex = @enumFromInt(params_slice[index]);
        if (ctx.nodeTag(param_id) == .rest_element) {
            return restParamElementVoid(param_id, index, index, ctx);
        }
        const ann = paramAnnotation(param_id, ctx);
        if (ann == .none) return false;
        return typeIsVoidReturningFn(ann, ctx);
    }
    // Past fixed params: check if last is rest.
    if (params_slice.len == 0) return false;
    const last_id: NodeIndex = @enumFromInt(params_slice[params_slice.len - 1]);
    if (ctx.nodeTag(last_id) != .rest_element) return false;
    return restParamElementVoid(last_id, index, params_slice.len - 1, ctx);
}

/// Substitution-aware variant of `paramIsVoidFnInSubrange`.  Walks
/// the param at `index` (or the rest param's element type at that
/// position), substituting names→nodes in the param's annotation
/// before the void-returning check.
fn paramIsVoidFnInSubrangeSubst(
    params_start: u32,
    params_end: u32,
    index: usize,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    if (params_start >= params_end or params_end > ctx.ast.extra_data.len) return false;
    const params_slice = ctx.ast.extra_data[params_start..params_end];
    if (index < params_slice.len) {
        const param_id: NodeIndex = @enumFromInt(params_slice[index]);
        if (ctx.nodeTag(param_id) == .rest_element) {
            return restParamElementVoidSubst(param_id, index, index, names, nodes, ctx);
        }
        const ann = paramAnnotation(param_id, ctx);
        if (ann == .none) return false;
        return unionAwareVoidReturningFn(substituteTypeRef(ann, names, nodes, ctx), ctx);
    }
    if (params_slice.len == 0) return false;
    const last_id: NodeIndex = @enumFromInt(params_slice[params_slice.len - 1]);
    if (ctx.nodeTag(last_id) != .rest_element) return false;
    return restParamElementVoidSubst(last_id, index, params_slice.len - 1, names, nodes, ctx);
}

fn restParamElementVoidSubst(
    rest_node: NodeIndex,
    arg_index: usize,
    rest_index: usize,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    const rd = ctx.nodeData(rest_node);
    if (rd.rhs == .none) return false;
    var ty = rd.rhs;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    // T[] → unwrap → substitute T → check.
    if (ctx.nodeTag(ty) == .ts_array_type) {
        var inner = ctx.nodeData(ty).lhs;
        while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
        // (T | string)[] — walk union members one at a time so we
        // don't have to substitute deep into the AST.
        if (ctx.nodeTag(inner) == .ts_union_type) {
            const arms = directRange(inner, ctx) orelse return false;
            var any_void = false;
            for (arms) |raw| {
                const m: NodeIndex = @enumFromInt(raw);
                const sub = substituteTypeRef(m, names, nodes, ctx);
                if (typeIsPromiseReturningFn(sub, ctx)) return false;
                if (typeIsVoidReturningFn(sub, ctx)) any_void = true;
            }
            return any_void;
        }
        const sub = substituteTypeRef(inner, names, nodes, ctx);
        return unionAwareVoidReturningFn(sub, ctx);
    }
    // (T | string)[] / Array<T | string>.  Walk to a union/array
    // element, substitute and check.
    if (ctx.nodeTag(ty) == .ts_tuple_type) {
        const arms = directRange(ty, ctx) orelse return false;
        const offset = arg_index - rest_index;
        if (offset >= arms.len) return false;
        const elem: NodeIndex = @enumFromInt(arms[offset]);
        const sub = substituteTypeRef(elem, names, nodes, ctx);
        return unionAwareVoidReturningFn(sub, ctx);
    }
    // Union member case via the existing helper after substituting
    // the tuple/array element.  For `(T | string)[]` we walk inner.
    return false;
}

/// Wrapper around `typeIsVoidReturningFnInner` that, when the given
/// node is a union, walks members and (for any function-shaped
/// arm) checks via the void-returning-fn test.
fn unionAwareVoidReturningFn(ty: NodeIndex, ctx: *const LintContext) bool {
    var n = ty;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .ts_union_type) {
        const arms = directRange(n, ctx) orelse return false;
        var any_void = false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (typeIsPromiseReturningFn(m, ctx)) return false;
            if (typeIsVoidReturningFnInner(m, ctx)) any_void = true;
        }
        return any_void;
    }
    return typeIsVoidReturningFnInner(n, ctx);
}

fn restParamElementVoid(rest_node: NodeIndex, arg_index: usize, rest_index: usize, ctx: *const LintContext) bool {
    // rest_element: rhs = type_annotation.
    const rd = ctx.nodeData(rest_node);
    if (rd.rhs == .none) return false;
    var ty = rd.rhs;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    // Array<T> / T[] → unwrap to T then test typeIsVoidReturningFn(T).
    if (ctx.nodeTag(ty) == .ts_array_type) {
        return typeIsVoidReturningFn(ctx.nodeData(ty).lhs, ctx);
    }
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
            const args = ctx.nodeData(ty).rhs;
            if (args != .none) {
                const arg_idx = @intFromEnum(args);
                if (arg_idx + 1 < ctx.ast.extra_data.len) {
                    const s = ctx.ast.extra_data[arg_idx];
                    const e = ctx.ast.extra_data[arg_idx + 1];
                    if (s < e and e <= ctx.ast.extra_data.len) {
                        const first: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
                        return typeIsVoidReturningFn(first, ctx);
                    }
                }
            }
        }
    }
    // Tuple type [A, B, C] — pick the (arg_index - rest_index)-th element.
    if (ctx.nodeTag(ty) == .ts_tuple_type) {
        const arms = directRange(ty, ctx) orelse return false;
        const offset = arg_index - rest_index;
        if (offset >= arms.len) return false;
        const elem: NodeIndex = @enumFromInt(arms[offset]);
        return typeIsVoidReturningFn(elem, ctx);
    }
    return false;
}

/// Walks a union annotation; if any arm is a function type whose Nth
/// param expects a void-returning fn, return true.
fn annotationUnionParamIsVoidFn(ann: NodeIndex, index: usize, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_union_type) return false;
    const arms = directRange(ty, ctx) orelse return false;
    for (arms) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (annotationParamIsVoidFn(m, index, ctx)) return true;
    }
    return false;
}

/// For an explicit function-type annotation like `(a, b: () => void) => any`,
/// check whether parameter `index` expects a void-returning function.
/// Handle `typeof X<Y>` annotations on the callee — find X's
/// declared generic-function annotation and use the operand's type
/// args as the binding source.  Mirrors what `f<Y>(...)` does at
/// the call site, but the type args live inside the annotation
/// rather than the call.
fn typeofWithTypeArgsParamIsVoidFn(ann: NodeIndex, index: usize, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_typeof_type and ctx.nodeTag(ty) != .ts_type_query) return false;
    const operand = ctx.nodeData(ty).lhs;
    if (operand == .none or ctx.nodeTag(operand) != .ts_type_reference) return false;
    const op_data = ctx.nodeData(operand);
    if (op_data.rhs == .none) return false;
    const arg_range = ctx.extraData(ast.SubRange, @intFromEnum(op_data.rhs));
    if (arg_range.start >= arg_range.end) return false;
    // Find the operand's value declaration's annotation.
    const name = ctx.tokenText(ctx.nodeMainToken(operand));
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) continue;
        const dn = ctx.tokenText(ctx.nodeMainToken(d.lhs));
        if (!std.mem.eql(u8, dn, name)) continue;
        const bd = ctx.nodeData(d.lhs);
        if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
        return annotationParamIsVoidFnSubst(bd.rhs, index, arg_range.start, arg_range.end, ctx);
    }
    return false;
}

/// `annotationParamIsVoidFn` variant that applies type-argument
/// substitution from the call site (`f<T>(...)`) before checking the
/// Nth param's annotation.  Lets `<T extends ...>(fn: T) => T` see
/// `T = void-returning fn` when the call is `f<() => void>(...)`.
fn annotationParamIsVoidFnSubst(
    ann: NodeIndex,
    index: usize,
    type_arg_start: u32,
    type_arg_end: u32,
    ctx: *const LintContext,
) bool {
    if (type_arg_end <= type_arg_start) return false;
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
    if (fd.params >= fd.params_end or fd.params_end > ctx.ast.extra_data.len) return false;
    // Build bindings from the function-type's declared type parameters
    // and the call-site's type arguments.
    if (fd.type_params_end <= fd.type_params or fd.type_params_end > ctx.ast.extra_data.len) return false;
    const tp_slice = ctx.ast.extra_data[fd.type_params..fd.type_params_end];
    const ta_slice = ctx.ast.extra_data[type_arg_start..type_arg_end];
    var names: [4][]const u8 = undefined;
    var nodes: [4]NodeIndex = undefined;
    const n = @min(@min(tp_slice.len, ta_slice.len), names.len);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const tp: NodeIndex = @enumFromInt(tp_slice[i]);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        names[i] = ctx.tokenText(ctx.nodeMainToken(tp));
        nodes[i] = @enumFromInt(ta_slice[i]);
    }
    if (n == 0) return false;
    const params_slice = ctx.ast.extra_data[fd.params..fd.params_end];
    if (index >= params_slice.len) return false;
    const param_id: NodeIndex = @enumFromInt(params_slice[index]);
    const param_ann = paramAnnotation(param_id, ctx);
    if (param_ann == .none) return false;
    return typeIsVoidReturningFnAnnAfterSubst(param_ann, names[0..n], nodes[0..n], ctx);
}

/// Substitute T in the param annotation, then ask "is the resulting
/// type a void-returning function?".
fn typeIsVoidReturningFnAnnAfterSubst(
    ann: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        // Direct type-param substitution: `fn: T` where T = call-site arg.
        for (names, nodes) |k, v| {
            if (std.mem.eql(u8, k, name)) {
                return typeIsVoidReturningFn(v, ctx);
            }
        }
        // Type alias — peel and recurse.
        if (typeAliasBody(name, ctx)) |body| {
            return typeIsVoidReturningFnAnnAfterSubst(body, names, nodes, ctx);
        }
    }
    return typeIsVoidReturningFn(ann, ctx);
}

fn annotationParamIsVoidFn(ann: NodeIndex, index: usize, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
    if (fd.params >= fd.params_end or fd.params_end > ctx.ast.extra_data.len) return false;
    const params_slice = ctx.ast.extra_data[fd.params..fd.params_end];
    if (index >= params_slice.len) return false;
    const param_id: NodeIndex = @enumFromInt(params_slice[index]);
    const param_ann = paramAnnotation(param_id, ctx);
    if (param_ann == .none) return false;
    return typeIsVoidReturningFn(param_ann, ctx);
}

fn paramAnnotation(param: NodeIndex, ctx: *const LintContext) NodeIndex {
    // The parameter node is typically `identifier` (with .rhs = ts_type_annotation) or `binding_*`.
    var p = param;
    if (ctx.nodeTag(p) == .ts_parameter_property) {
        // Skip parameter_property modifiers; payload param is data.rhs.
        p = ctx.nodeData(p).rhs;
    }
    if (ctx.nodeTag(p) == .identifier) {
        const d = ctx.nodeData(p);
        if (d.rhs != .none and ctx.nodeTag(d.rhs) == .ts_type_annotation) return d.rhs;
    }
    return .none;
}

/// True if the type node represents `() => void` or a union of such.
fn typeIsVoidReturningFn(ann: NodeIndex, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    return typeIsVoidReturningFnInner(ty, ctx);
}

fn typeIsVoidReturningFnInner(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const arms = directRange(inner, ctx) orelse return false;
        // For unions, every signature that's a function must return void
        // (if any union arm has a Promise-returning function, it's OK to pass async).
        var saw_void_fn = false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (typeIsVoidReturningFnInner(m, ctx)) {
                saw_void_fn = true;
            } else if (typeIsPromiseReturningFn(m, ctx)) {
                return false;
            }
        }
        return saw_void_fn;
    }
    if (tag == .ts_function_type) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(inner).lhs));
        // ts_function_type reuses `body` for its return type.
        // If the return type's union contains a Promise/thenable arm,
        // TSe treats the parameter as accepting both — not void-only.
        if (typeContainsPromiseInner(fd.body, ctx)) return false;
        return returnTypeIsVoid(fd.body, ctx);
    }
    if (tag == .ts_type_reference) {
        // Type alias?
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (typeAliasBody(name, ctx)) |body| return typeIsVoidReturningFnInner(body, ctx);
    }
    if (tag == .ts_type_literal) {
        // `{ (): void }` call signature in type literal.
        return typeLiteralHasVoidCallSignature(inner, ctx);
    }
    return false;
}

fn typeIsPromiseReturningFn(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    // Peel type-alias references so `type X = () => Promise<void>; ...; T = X`
    // is recognised as promise-returning even after substitution.
    var hop: u8 = 0;
    while (ctx.nodeTag(inner) == .ts_type_reference and hop < 6) : (hop += 1) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        const body = typeAliasBody(name, ctx) orelse break;
        inner = body;
        while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    }
    if (ctx.nodeTag(inner) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(inner).lhs));
    // ts_function_type reuses `body` for the return type.
    return typeContainsPromiseInner(fd.body, ctx);
}

fn typeLiteralHasVoidCallSignature(node: NodeIndex, ctx: *const LintContext) bool {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return false;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) == .ts_call_signature) {
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
            if (returnTypeIsVoid(sd.return_type, ctx)) return true;
        }
    }
    return false;
}

fn returnTypeIsVoid(rt: NodeIndex, ctx: *const LintContext) bool {
    if (rt == .none) return false;
    var ty = rt;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        // `void` keyword is tokenised as kw_void; the parser maps it to
        // ts_type_reference whose main_token text is "void".
        if (std.mem.eql(u8, name, "void")) return true;
    }
    if (ctx.nodeTag(ty) == .ts_union_type) {
        const arms = directRange(ty, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (returnTypeIsVoid(m, ctx)) return true;
        }
    }
    return false;
}

fn annotationContainsPromise(ann: NodeIndex, ctx: *const LintContext) bool {
    if (ann == .none) return false;
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    return typeContainsPromiseInner(ty, ctx);
}

fn typeContainsPromiseInner(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (typeContainsPromiseInner(m, ctx)) return true;
        }
        return false;
    }
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "PromiseLike") or std.mem.eql(u8, name, "Thenable"))
            return true;
        if (typeAliasBody(name, ctx)) |body| return typeContainsPromiseInner(body, ctx);
    }
    return false;
}

fn directRange(node: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return null;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    const ext_len: u32 = @intCast(ctx.ast.extra_data.len);
    if (s > e or e > ext_len) return null;
    return ctx.ast.extra_data[s..e];
}

fn typeAliasBody(name: []const u8, ctx: *const LintContext) ?NodeIndex {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_alias_decl) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        const td = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
        const nm = ctx.tokenText(td.name);
        if (!std.mem.eql(u8, nm, name)) continue;
        if (td.type_node == .none) return null;
        return td.type_node;
    }
    return null;
}

// ────────────────────────────────────────────────────────────────────
// "predicate" — array predicate with async callback.
// ────────────────────────────────────────────────────────────────────

fn checkArrayPredicate(node: NodeIndex, ctx: *const LintContext) void {
    const callee = calleeOf(node, ctx);
    if (callee == .none) return;
    var c = callee;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    if (ctx.nodeTag(c) != .member_expr and ctx.nodeTag(c) != .optional_member_expr) return;
    const md = ctx.nodeData(c);
    if (md.rhs == .none) return;
    const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const is_pred = std.mem.eql(u8, m, "filter") or std.mem.eql(u8, m, "find") or
        std.mem.eql(u8, m, "findIndex") or std.mem.eql(u8, m, "findLast") or
        std.mem.eql(u8, m, "findLastIndex") or std.mem.eql(u8, m, "every") or
        std.mem.eql(u8, m, "some");
    if (!is_pred) return;
    var args_buf: [4]NodeIndex = undefined;
    const args = callArguments(node, &args_buf, ctx);
    if (args.len == 0) return;
    const callback = args[0];
    if (exprIsPromiseReturningFn(callback, ctx)) {
        ctx.reportWithMessageId(callback, "predicate");
    }
}

// ────────────────────────────────────────────────────────────────────
// "voidReturnVariable" — async fn assigned to `() => void` variable.
// ────────────────────────────────────────────────────────────────────

fn checkAssignment(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;
    // We only fire on `=` assignments. Determining the operator is
    // implicit in tag (Ez uses .assign for `=`).
    const ann = identifierAnnotation(data.lhs, ctx);
    if (ann == .none) return;
    if (!typeIsVoidReturningFn(ann, ctx)) return;
    if (exprIsPromiseReturningFn(data.rhs, ctx)) {
        ctx.reportWithMessageId(data.rhs, "voidReturnVariable");
    }
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none or data.rhs == .none) return;
    // lhs = name (identifier with rhs = annotation), rhs = initializer.
    const ann = identifierAnnotation(data.lhs, ctx);
    if (ann == .none) return;
    if (!typeIsVoidReturningFn(ann, ctx)) return;
    if (exprIsPromiseReturningFn(data.rhs, ctx)) {
        ctx.reportWithMessageId(data.rhs, "voidReturnVariable");
    }
}

fn identifierAnnotation(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    // For member access like `obj.f`, resolve obj's type and find member.
    if (ctx.nodeTag(n) == .member_expr or ctx.nodeTag(n) == .optional_member_expr) {
        return memberAnnotation(n, ctx);
    }
    if (ctx.nodeTag(n) != .identifier) return .none;
    // Try the identifier's own rhs (decl form) first.
    const d = ctx.nodeData(n);
    if (d.rhs != .none and ctx.nodeTag(d.rhs) == .ts_type_annotation) return d.rhs;
    // Otherwise resolve via symbol → decl.
    const sym = symbolForIdent(n, ctx) orelse return .none;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none or ctx.nodeTag(decl) != .identifier) return .none;
    const dd = ctx.nodeData(decl);
    if (dd.rhs != .none and ctx.nodeTag(dd.rhs) == .ts_type_annotation) return dd.rhs;
    return .none;
}

/// Resolves `obj.f` to the annotation of `f` in obj's contextual type
/// (when obj has a type annotation describing an object).
fn memberAnnotation(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return .none;
    // The property side is a `property_ident` node — read its main token.
    if (ctx.nodeTag(d.rhs) != .property_ident and ctx.nodeTag(d.rhs) != .identifier) return .none;
    const member_name = ctx.tokenText(ctx.nodeMainToken(d.rhs));
    const obj_ann = identifierAnnotation(d.lhs, ctx);
    if (obj_ann == .none) return .none;
    var ty = obj_ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (std.mem.eql(u8, name, "Record")) {
            return recordValueType(ty, ctx) orelse .none;
        }
        if (typeAliasBody(name, ctx)) |body| ty = body;
    }
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (std.mem.eql(u8, name, "Record")) {
            return recordValueType(ty, ctx) orelse .none;
        }
    }
    if (ctx.nodeTag(ty) != .ts_type_literal) return .none;
    const td = ctx.nodeData(ty);
    if (td.lhs == .none or td.rhs == .none) return .none;
    const s = @intFromEnum(td.lhs);
    const e = @intFromEnum(td.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return .none;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_property_signature) continue;
        const md = ctx.nodeData(m);
        if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) continue;
        const mname = ctx.tokenText(ctx.nodeMainToken(md.lhs));
        if (!std.mem.eql(u8, mname, member_name)) continue;
        // ts_property_signature stores its type annotation on `rhs`.
        if (md.rhs == .none) return .none;
        return md.rhs;
    }
    return .none;
}

// ────────────────────────────────────────────────────────────────────
// "voidReturnProperty" — async fn as property of `{ ...: () => void }`.
// ────────────────────────────────────────────────────────────────────

fn checkShorthandProperty(node: NodeIndex, ctx: *const LintContext) void {
    const ident = ctx.nodeData(node).lhs;
    if (ident == .none or ctx.nodeTag(ident) != .identifier) return;
    if (!exprIsPromiseReturningFn(ident, ctx)) return;
    const ann = objectLiteralContextualPropertyType(node, ctx) orelse return;
    if (!contextNodeIsVoidReturningFn(ann, ctx)) return;
    ctx.reportWithMessageId(ident, "voidReturnProperty");
}

fn checkObjectMethod(node: NodeIndex, ctx: *const LintContext) void {
    const parent = ctx.parentOf(node);
    if (parent == .none or ctx.nodeTag(parent) != .object_literal) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(node).rhs));
    const is_async = (md.modifiers & ast.ModifierBit.@"async") != 0;
    // Parser drops the return-type annotation for object literal methods,
    // so detect by source-scanning between `)` and `{` for a Promise token.
    const ret_is_promise = annotationContainsPromise(md.return_type, ctx) or
        objectMethodSourceReturnsPromise(node, md, ctx);
    const body_returns_promise = !is_async and !ret_is_promise and bodyReturnsPromise(md.body, ctx);
    if (!is_async and !ret_is_promise and !body_returns_promise) return;
    const ann = objectLiteralContextualPropertyType(node, ctx) orelse return;
    if (!contextNodeIsVoidReturningFn(ann, ctx)) return;
    // If method has explicit return type, TSe reports on the annotation.
    if (md.return_type != .none) {
        const rt = md.return_type;
        const inner = if (ctx.nodeTag(rt) == .ts_type_annotation) ctx.nodeData(rt).lhs else rt;
        ctx.reportSpanWithMessageId(typeAnnotationSpan(inner, ctx), "voidReturnProperty");
        return;
    }
    // Parser drops return-type for object methods; scan the source.
    if (objectMethodReturnTypeSpan(node, md, ctx)) |sp| {
        ctx.reportSpanWithMessageId(sp, "voidReturnProperty");
        return;
    }
    ctx.reportSpanWithMessageId(propertyHeadSpan(node, node, ctx), "voidReturnProperty");
}

/// Scan the source between `)` and `{` for the return-type annotation.
/// Returns the span of the type (excluding the `:` and surrounding space).
/// Span of a type annotation node, extended to include trailing `>`/`]`
/// that the parser sometimes drops.
fn typeAnnotationSpan(ty: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    var sp = ctx.nodeSpan(ty);
    const src = ctx.ast.source;
    while (sp.end < src.len) {
        const c = src[sp.end];
        if (c == '>' or c == ']') { sp.end += 1; continue; }
        break;
    }
    return sp;
}

fn objectMethodReturnTypeSpan(method_node: NodeIndex, md: ast.MethodData, ctx: *const LintContext) ?@import("es_parser").span.Span {
    if (md.body == .none) return null;
    const body_start = ctx.nodeSpan(md.body).start;
    const head = ctx.nodeSpan(method_node);
    if (body_start <= head.start) return null;
    const src = ctx.ast.source;
    if (body_start > src.len) return null;
    // Find the closing `)` of the param list before body_start.
    var i: isize = @as(isize, @intCast(body_start)) - 1;
    while (i > @as(isize, @intCast(head.start)) and (src[@intCast(i)] == ' ' or src[@intCast(i)] == '\t' or src[@intCast(i)] == '\n')) : (i -= 1) {}
    // Now look backward for `:` from i.
    var colon_pos: ?usize = null;
    var depth: i32 = 0;
    while (i > @as(isize, @intCast(head.start))) : (i -= 1) {
        const c = src[@intCast(i)];
        if (c == ')' or c == '>' or c == ']') depth += 1
        else if (c == '(' or c == '<' or c == '[') {
            depth -= 1;
            if (depth < 0) return null; // before params
        }
        if (depth == 0 and c == ':') {
            colon_pos = @intCast(i);
            break;
        }
    }
    const cp = colon_pos orelse return null;
    // Walk forward from cp+1 over whitespace.
    var start: usize = cp + 1;
    while (start < body_start and (src[start] == ' ' or src[start] == '\t' or src[start] == '\n')) start += 1;
    // End at body_start, trim trailing whitespace.
    var end: usize = body_start;
    while (end > start and (src[end - 1] == ' ' or src[end - 1] == '\t' or src[end - 1] == '\n')) end -= 1;
    if (start >= end) return null;
    return .{ .start = @intCast(start), .end = @intCast(end) };
}

/// The parser doesn't store the return-type annotation for object
/// literal methods.  Inspect the source between the method head's
/// closing `)` and the opening `{` (or `;`) for any Promise/PromiseLike/
/// Thenable token.
fn objectMethodSourceReturnsPromise(method_node: NodeIndex, md: ast.MethodData, ctx: *const LintContext) bool {
    const head = ctx.nodeSpan(method_node);
    const body_start: usize = if (md.body != .none) ctx.nodeSpan(md.body).start else head.end;
    if (body_start <= head.start) return false;
    const src = ctx.ast.source;
    if (body_start > src.len) return false;
    // Search the slice between head.start and body_start.
    const slice = src[head.start..body_start];
    return std.mem.indexOf(u8, slice, "Promise") != null or
        std.mem.indexOf(u8, slice, "PromiseLike") != null or
        std.mem.indexOf(u8, slice, "Thenable") != null;
}

fn propertyHeadSpan(prop_node: NodeIndex, value: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    // TSe's getFunctionHeadLoc for Property:
    //   start = property.loc.start
    //   end = `(` of params (or `=>` for arrows w/o params).
    var prop_span = ctx.nodeSpan(prop_node);
    var val = value;
    while (ctx.nodeTag(val) == .grouping_expr) val = ctx.nodeData(val).lhs;
    const src = ctx.ast.source;
    var open_paren: ?usize = null;
    // Find `(` in source between prop_span.start and value's end.
    var i: usize = prop_span.start;
    var depth: i32 = 0;
    while (i < src.len) : (i += 1) {
        const c = src[i];
        if (c == '(') {
            if (depth == 0) {
                open_paren = i;
                break;
            }
        }
        if (c == '[') depth += 1
        else if (c == ']') depth -= 1;
        if (c == '\n') break;
    }
    if (open_paren) |op| {
        prop_span.end = @intCast(op);
    }
    return prop_span;
}

fn checkProperty(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    // Property: lhs = key, rhs = value.
    if (data.lhs == .none or data.rhs == .none) return;
    const value = data.rhs;
    if (!exprIsPromiseReturningFn(value, ctx)) return;
    const ann = objectLiteralContextualPropertyType(node, ctx) orelse return;
    if (!contextNodeIsVoidReturningFn(ann, ctx)) return;
    // TSe: if value is a function literal, report on getFunctionHeadLoc
    // (or function's return-type annotation if explicit).  Otherwise
    // (identifier reference), report on the value directly.
    var v = value;
    while (ctx.nodeTag(v) == .grouping_expr) v = ctx.nodeData(v).lhs;
    const vt = ctx.nodeTag(v);
    const is_fn_literal = vt == .arrow_fn or vt == .async_arrow_fn or
        vt == .fn_expr or vt == .async_fn_expr or
        vt == .generator_fn_expr or vt == .async_generator_fn_expr;
    if (!is_fn_literal) {
        ctx.reportWithMessageId(value, "voidReturnProperty");
        return;
    }
    // Function literal — check for explicit return type.
    const rt = functionReturnTypeAnnotation(v, ctx);
    if (rt != .none) {
        const inner = if (ctx.nodeTag(rt) == .ts_type_annotation) ctx.nodeData(rt).lhs else rt;
        ctx.reportSpanWithMessageId(typeAnnotationSpan(inner, ctx), "voidReturnProperty");
        return;
    }
    ctx.reportSpanWithMessageId(propertyHeadSpan(node, value, ctx), "voidReturnProperty");
}

fn functionReturnTypeAnnotation(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);
    return switch (tag) {
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr => blk: {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            break :blk fd.return_type;
        },
        .arrow_fn, .async_arrow_fn => blk: {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            break :blk ad.return_type;
        },
        else => .none,
    };
}

/// For an object-literal property, find the contextual annotation
/// (e.g. `const x: { f: () => void } = { f: async ... }`).
fn objectLiteralContextualPropertyType(prop: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    var p = ctx.parentOf(prop);
    while (p != .none and ctx.nodeTag(p) != .object_literal) p = ctx.parentOf(p);
    if (p == .none) return null;
    const obj = p;
    // The object literal's parent must be a declarator/assignment/return/etc.
    const parent = ctx.parentOf(obj);
    if (parent == .none) return null;
    const pt = ctx.nodeTag(parent);
    var obj_ann: NodeIndex = .none;
    if (pt == .declarator) {
        obj_ann = identifierAnnotation(ctx.nodeData(parent).lhs, ctx);
    } else if (pt == .assign) {
        obj_ann = identifierAnnotation(ctx.nodeData(parent).lhs, ctx);
    } else if (pt == .return_stmt) {
        // Containing function's return type.
        obj_ann = enclosingFunctionReturnAnnotation(obj, ctx);
    } else if (pt == .ts_as_expr or pt == .ts_satisfies_expr) {
        const cast_type = ctx.nodeData(parent).rhs;
        if (cast_type != .none) obj_ann = cast_type;
    }
    if (obj_ann == .none) return null;
    var ty = obj_ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    // Resolve to ts_type_literal or via alias / Record<>.
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        // Record<K, V> → treat each property's type as V.
        if (std.mem.eql(u8, name, "Record")) {
            const ta = recordValueType(ty, ctx) orelse return null;
            return ta;
        }
        if (typeAliasBody(name, ctx)) |body| ty = body;
    }
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    // After alias resolution, recurse on Record again.
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (std.mem.eql(u8, name, "Record")) {
            const ta = recordValueType(ty, ctx) orelse return null;
            return ta;
        }
    }
    // Union type containing a type literal: iterate.
    if (ctx.nodeTag(ty) == .ts_union_type) {
        const arms = directRange(ty, ctx) orelse return null;
        for (arms) |raw| {
            const child: NodeIndex = @enumFromInt(raw);
            var ch = child;
            while (ctx.nodeTag(ch) == .ts_parenthesized_type) ch = ctx.nodeData(ch).lhs;
            if (ctx.nodeTag(ch) == .ts_type_reference) {
                const cname = ctx.tokenText(ctx.nodeMainToken(ch));
                if (typeAliasBody(cname, ctx)) |body| ch = body;
            }
            if (ctx.nodeTag(ch) == .ts_type_literal) {
                const found = findPropTypeInTypeLiteral(prop, ch, ctx);
                if (found != null) return found;
            }
        }
        return null;
    }
    if (ctx.nodeTag(ty) != .ts_type_literal) return null;
    return findPropTypeInTypeLiteral(prop, ty, ctx);
}

fn findPropTypeInTypeLiteral(prop: NodeIndex, ty: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const data = ctx.nodeData(prop);
    if (data.lhs == .none) return null;
    if (ctx.nodeTag(data.lhs) != .identifier) return null;
    const key_name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
    const d = ctx.nodeData(ty);
    if (d.lhs == .none or d.rhs == .none) return null;
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt == .ts_property_signature) {
            const md = ctx.nodeData(m);
            if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) continue;
            const mname = ctx.tokenText(ctx.nodeMainToken(md.lhs));
            if (!std.mem.eql(u8, mname, key_name)) continue;
            if (md.rhs == .none) return null;
            return md.rhs;
        }
        if (mt == .ts_method_signature) {
            // The member describes a method type `f(...): T` — return the
            // method-signature node itself; callers translate this to a
            // "void-fn-returning" check via methodSignatureReturnsVoid.
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
            if (sd.key == .none or ctx.nodeTag(sd.key) != .identifier) continue;
            const mname = ctx.tokenText(ctx.nodeMainToken(sd.key));
            if (!std.mem.eql(u8, mname, key_name)) continue;
            return m; // ts_method_signature node itself
        }
    }
    return null;
}

/// True if the returned context node represents a method/property typed
/// as void-returning function.  Handles both ts_type_annotation
/// (property) and ts_method_signature (method shorthand) forms.
fn contextNodeIsVoidReturningFn(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) == .ts_method_signature) {
        const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(node).lhs));
        return returnTypeIsVoid(sd.return_type, ctx);
    }
    return typeIsVoidReturningFn(node, ctx);
}

fn enclosingFunctionReturnAnnotation(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var p = ctx.parentOf(node);
    while (p != .none) : (p = ctx.parentOf(p)) {
        const t = ctx.nodeTag(p);
        switch (t) {
            .fn_decl, .fn_expr, .async_fn_decl, .async_fn_expr,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr => {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(p).lhs));
                if (fd.return_type != .none) return fd.return_type;
                return contextualReturnTypeFromOuter(p, ctx);
            },
            .arrow_fn, .async_arrow_fn => {
                const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(p).lhs));
                if (ad.return_type != .none) return ad.return_type;
                return contextualReturnTypeFromOuter(p, ctx);
            },
            .method_def, .computed_method_def => {
                const md = ctx.extraData(ast.MethodData, @intFromEnum(ctx.nodeData(p).rhs));
                return md.return_type;
            },
            else => {},
        }
    }
    return .none;
}

/// When a function expression / arrow has no explicit return type, its
/// CONTEXTUAL return type may come from a surrounding declarator's
/// annotation: `const x: () => Record<...> = () => ...;`.
fn contextualReturnTypeFromOuter(fn_node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const parent = ctx.parentOf(fn_node);
    if (parent == .none) return .none;
    if (ctx.nodeTag(parent) != .declarator) return .none;
    const decl_id = ctx.nodeData(parent).lhs;
    if (decl_id == .none or ctx.nodeTag(decl_id) != .identifier) return .none;
    const id_data = ctx.nodeData(decl_id);
    if (id_data.rhs == .none or ctx.nodeTag(id_data.rhs) != .ts_type_annotation) return .none;
    var ty = ctx.nodeData(id_data.rhs).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (typeAliasBody(name, ctx)) |body| ty = body;
    }
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) != .ts_function_type) return .none;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
    // ts_function_type reuses `body` for return type.
    return fd.body;
}

// ────────────────────────────────────────────────────────────────────
// "voidReturnReturnValue" — returning async fn from `() => () => void`.
// ────────────────────────────────────────────────────────────────────

fn checkReturn(node: NodeIndex, ctx: *const LintContext) void {
    const value = ctx.nodeData(node).lhs;
    if (value == .none) return;
    if (!exprIsPromiseReturningFn(value, ctx)) return;
    const ann = enclosingFunctionReturnAnnotation(node, ctx);
    if (ann == .none) return;
    // The enclosing fn's return type should itself be `() => void`.
    if (!typeIsVoidReturningFn(ann, ctx)) return;
    ctx.reportWithMessageId(value, "voidReturnReturnValue");
}

// ────────────────────────────────────────────────────────────────────
// "voidReturnInheritedMethod" — async method overrides void method.
// ────────────────────────────────────────────────────────────────────

fn checkInheritedMethods(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
    const has_extends = cd.super_class != .none;
    const has_impls = cd.impls_start < cd.impls_end and cd.impls_end <= ctx.ast.extra_data.len;
    // For class expressions, the parser drops implements clause tracking;
    // recover by source-scanning between `class` keyword and `{`.
    var src_impls_buf: [8][]const u8 = undefined;
    const src_impls = scanSourceImplements(node, cd, &src_impls_buf, ctx);
    if (!has_extends and !has_impls and src_impls.len == 0) return;
    const body = cd.body;
    if (body == .none) return;
    const bd = ctx.nodeData(body);
    const bs = @intFromEnum(bd.lhs);
    const be = @intFromEnum(bd.rhs);
    if (bs >= be or be > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[bs..be]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        // Method definitions and accessor / regular property fields
        // that hold a function-typed value or annotation.
        var name: []const u8 = "";
        var method_span_helper: ast.MethodData = std.mem.zeroes(ast.MethodData);
        var is_async = false;
        var ret_is_promise = false;
        var is_field = false;
        if (mt == .method_def or mt == .computed_method_def) {
            const md_data = ctx.nodeData(m);
            if (md_data.lhs == .none or ctx.nodeTag(md_data.lhs) != .identifier) continue;
            name = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
            method_span_helper = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
            if ((method_span_helper.modifiers & ast.ModifierBit.@"static") != 0) continue;
            is_async = (method_span_helper.modifiers & ast.ModifierBit.@"async") != 0;
            ret_is_promise = annotationContainsPromise(method_span_helper.return_type, ctx);
        } else if (mt == .property_def or mt == .computed_property_def) {
            is_field = true;
            const pd_data = ctx.nodeData(m);
            if (pd_data.lhs == .none or ctx.nodeTag(pd_data.lhs) != .identifier) continue;
            name = ctx.tokenText(ctx.nodeMainToken(pd_data.lhs));
            // Skip static fields — they don't override an instance member.
            if (fieldIsStatic(m, ctx)) continue;
            const pd = ctx.extraData(ast.PropertyData, @intFromEnum(pd_data.rhs));
            // Property initializer is an async/arrow returning a Promise?
            if (pd.value != .none) {
                const vt = ctx.nodeTag(pd.value);
                if (vt == .async_arrow_fn) {
                    is_async = true;
                }
                if (vt == .arrow_fn or vt == .async_arrow_fn) {
                    const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(pd.value).lhs));
                    ret_is_promise = annotationContainsPromise(ad.return_type, ctx);
                } else if (vt == .fn_expr or vt == .async_fn_expr) {
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(pd.value).lhs));
                    if (vt == .async_fn_expr) is_async = true;
                    ret_is_promise = annotationContainsPromise(fd.return_type, ctx);
                }
            }
            // Explicit annotation on the field: `accessor setThing: () => Promise<void>`.
            if (!ret_is_promise and pd.type_annotation != .none) {
                ret_is_promise = annotationFunctionReturnsPromise(pd.type_annotation, ctx);
            }
        } else {
            continue;
        }
        if (!is_async and !ret_is_promise) continue;
        // Check the extends clause first, then implements.
        const report_span = if (is_field) fieldFullSpan(m, ctx) else classMemberFullSpan(m, method_span_helper, ctx);
        var fired = false;
        if (has_extends) {
            if (supeRefName(cd.super_class, ctx)) |super_name| {
                if (superclassMethodIsVoid(cd.super_class, name, ctx)) {
                    ctx.reportSpanWithMessageIdAndData(report_span, "voidReturnInheritedMethod", &[_]@import("../../lint_context.zig").MessageDataEntry{
                        .{ .key = "heritageTypeName", .val = super_name },
                    });
                    fired = true;
                }
            }
        }
        if (fired) continue;
        if (has_impls) {
            const tok_slice = ctx.ast.extra_data[cd.impls_start..cd.impls_end];
            for (tok_slice) |raw_tok| {
                const tok: ast.TokenIndex = raw_tok;
                const heritage_name = ctx.tokenText(tok);
                if (heritageMethodIsVoid(heritage_name, name, ctx)) {
                    ctx.reportSpanWithMessageIdAndData(report_span, "voidReturnInheritedMethod", &[_]@import("../../lint_context.zig").MessageDataEntry{
                        .{ .key = "heritageTypeName", .val = heritage_name },
                    });
                    fired = true;
                    break;
                }
            }
        }
        if (fired) continue;
        for (src_impls) |heritage_name| {
            if (heritageMethodIsVoid(heritage_name, name, ctx)) {
                ctx.reportSpanWithMessageIdAndData(report_span, "voidReturnInheritedMethod", &[_]@import("../../lint_context.zig").MessageDataEntry{
                    .{ .key = "heritageTypeName", .val = heritage_name },
                });
                break;
            }
        }
    }
}

/// Report span for a class field — extend backward through
/// `abstract` / `accessor` / `readonly` / access-modifier keywords
/// that appear immediately before the field's name on the same line
/// so the diagnostic span matches TSe's report node (the full
/// MethodDefinition / PropertyDefinition).
fn fieldFullSpan(m: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    const Span = @import("es_parser").span.Span;
    const base = ctx.nodeSpan(m);
    const src = ctx.ast.source;
    if (base.start == 0 or base.start > src.len) return base;
    // Extend forward to include a trailing `;` so the diagnostic
    // span lines up with TSe's report node.
    // Start the forward walk from MAX(base.end, value-node end) —
    // the parser's max_tok for property_def doesn't cover the value
    // expression for class fields with arrow-/fn-expression
    // initialisers, so we add the value node's own end explicitly.
    var end: u32 = base.end;
    const pd_data = ctx.nodeData(m);
    if (pd_data.rhs != .none) {
        const pd = ctx.extraData(ast.PropertyData, @intFromEnum(pd_data.rhs));
        if (pd.value != .none) {
            const val_end = ctx.nodeSpan(pd.value).end;
            if (val_end > end) end = val_end;
        }
        if (pd.type_annotation != .none) {
            const ann_end = ctx.nodeSpan(pd.type_annotation).end;
            if (ann_end > end) end = ann_end;
        }
    }
    // Then walk past the trailing `;` if present, balancing braces
    // in case the value's max_tok also ended mid-body.
    var depth: i32 = 0;
    while (end < src.len) : (end += 1) {
        const ch = src[end];
        if (ch == '{') { depth += 1; continue; }
        if (ch == '}') {
            if (depth == 0) break;
            depth -= 1;
            continue;
        }
        if (depth > 0) continue;
        if (ch == ';') { end += 1; break; }
    }
    // Find start of the line containing `base.start`.
    var i: usize = base.start;
    while (i > 0 and src[i - 1] != '\n') i -= 1;
    const line = src[i..base.start];
    var ws: usize = 0;
    while (ws < line.len and (line[ws] == ' ' or line[ws] == '\t')) ws += 1;
    const trimmed = line[ws..];
    const modifiers = [_][]const u8{ "public", "private", "protected", "abstract", "readonly", "accessor", "override", "declare", "static" };
    for (modifiers) |kw| {
        if (trimmed.len >= kw.len + 1 and std.mem.eql(u8, trimmed[0..kw.len], kw)) {
            return Span{ .start = @intCast(i + ws), .end = end };
        }
    }
    return Span{ .start = base.start, .end = end };
}

/// True when a class field is declared `static` — we scan the
/// source between the class body's `{` and the field's start
/// because the AST stores modifier flags only for methods.
fn fieldIsStatic(m: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(m);
    const src = ctx.ast.source;
    if (sp.start == 0 or sp.start > src.len) return false;
    // Look back for the keyword `static` immediately before the
    // field's name (skipping `public` / `private` / `protected` /
    // `accessor` / `readonly` and whitespace).  This avoids the need
    // for a parser-side modifier map.
    const slice = src[0..sp.start];
    // Walk back, splitting on whitespace.  Bound the scan to the
    // current line to avoid stepping into prior fields.
    var i: usize = slice.len;
    while (i > 0 and slice[i - 1] != '\n') i -= 1;
    const line = slice[i..];
    return std.mem.indexOf(u8, line, "static") != null;
}

/// True when an annotation describes a function type returning a
/// Promise-like.  Peels ts_type_annotation and recurses through
/// union arms.
fn annotationFunctionReturnsPromise(ann: NodeIndex, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_union_type or ctx.nodeTag(ty) == .ts_intersection_type) {
        const arms = directRange(ty, ctx) orelse return false;
        for (arms) |raw| {
            const a: NodeIndex = @enumFromInt(raw);
            if (annotationFunctionReturnsPromise(a, ctx)) return true;
        }
        return false;
    }
    if (ctx.nodeTag(ty) == .ts_function_type) {
        const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
        return typeContainsPromiseInner(fd.body, ctx);
    }
    return false;
}

/// Source-scan between `class` keyword and `{` for `implements X, Y` etc.
/// Returns identifier names that follow `implements`.
fn scanSourceImplements(class_node: NodeIndex, cd: ast.ClassData, buf: [][]const u8, ctx: *const LintContext) [][]const u8 {
    const src = ctx.ast.source;
    // Use the main token (the `class` keyword) as the start anchor —
    // nodeSpan for class_expr may include surrounding context.
    const class_tok = ctx.nodeMainToken(class_node);
    const class_start: u32 = @intCast(ctx.ast.tokenStart(class_tok));
    if (cd.body == .none) return buf[0..0];
    const body_sp = ctx.nodeSpan(cd.body);
    if (body_sp.start <= class_start) return buf[0..0];
    const slice = src[class_start..body_sp.start];
    const impl_idx = std.mem.indexOf(u8, slice, "implements") orelse return buf[0..0];
    // Walk after `implements`, collect comma-separated identifiers.
    var i: usize = impl_idx + "implements".len;
    var count: usize = 0;
    while (i < slice.len) {
        // Skip whitespace and commas.
        while (i < slice.len and (slice[i] == ' ' or slice[i] == '\t' or slice[i] == '\n' or slice[i] == ',')) i += 1;
        if (i >= slice.len) break;
        const c = slice[i];
        if (!((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_' or c == '$')) break;
        const start = i;
        while (i < slice.len) {
            const ch = slice[i];
            if ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or
                (ch >= '0' and ch <= '9') or ch == '_' or ch == '$') i += 1
            else break;
        }
        if (count < buf.len) {
            buf[count] = slice[start..i];
            count += 1;
        }
        // Skip optional type arguments `<...>`.
        if (i < slice.len and slice[i] == '<') {
            var depth: u32 = 1;
            i += 1;
            while (i < slice.len and depth > 0) : (i += 1) {
                if (slice[i] == '<') depth += 1
                else if (slice[i] == '>') depth -= 1;
            }
        }
        // Skip whitespace.
        while (i < slice.len and (slice[i] == ' ' or slice[i] == '\t' or slice[i] == '\n')) i += 1;
        if (i >= slice.len or slice[i] != ',') break;
    }
    return buf[0..count];
}

fn checkInterfaceInheritedMethods(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    if (id.extends_start >= id.extends_end or id.extends_end > ctx.ast.extra_data.len) return;
    if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) return;
    // For each method signature in the interface body that returns a Promise,
    // check if any extended type has a method with the same name returning void.
    for (ctx.ast.extra_data[id.body_start..id.body_end]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        var name: []const u8 = "";
        var promise_returning = false;
        var report_span_helper: enum { method_sig, prop_sig } = .method_sig;
        if (mt == .ts_method_signature) {
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
            const name_node = sd.key;
            if (name_node == .none or ctx.nodeTag(name_node) != .identifier) continue;
            name = ctx.tokenText(ctx.nodeMainToken(name_node));
            if (!annotationContainsPromise(sd.return_type, ctx)) continue;
            promise_returning = true;
        } else if (mt == .ts_property_signature) {
            const md = ctx.nodeData(m);
            if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) continue;
            if (md.rhs == .none) continue;
            name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
            // Inspect the property's annotation for a Promise-returning
            // function type (`name: () => Promise<void>`).
            if (!annotationFunctionReturnsPromise(md.rhs, ctx)) continue;
            promise_returning = true;
            report_span_helper = .prop_sig;
        } else {
            continue;
        }
        if (!promise_returning) continue;
        for (ctx.ast.extra_data[id.extends_start..id.extends_end]) |eraw| {
            const ref: NodeIndex = @enumFromInt(eraw);
            if (ref == .none) continue;
            var ref_root = ref;
            while (ctx.nodeTag(ref_root) == .grouping_expr) ref_root = ctx.nodeData(ref_root).lhs;
            const heritage_name: []const u8 = if (ctx.nodeTag(ref_root) == .identifier or ctx.nodeTag(ref_root) == .ts_type_reference)
                ctx.tokenText(ctx.nodeMainToken(ref_root))
            else
                continue;
            if (heritageMethodIsVoidWithRef(heritage_name, name, ref_root, ctx)) {
                const span = if (report_span_helper == .method_sig)
                    methodSignatureSpan(m, ctx)
                else
                    propertySignatureSpan(m, ctx);
                ctx.reportSpanWithMessageIdAndData(span, "voidReturnInheritedMethod", &[_]@import("../../lint_context.zig").MessageDataEntry{
                    .{ .key = "heritageTypeName", .val = heritage_name },
                });
                break;
            }
        }
    }
}

/// Report span for a `ts_property_signature` — extend forward past
/// a trailing `;` / `,` if present so the diagnostic matches TSe.
fn propertySignatureSpan(m: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    const Span = @import("es_parser").span.Span;
    const base = ctx.nodeSpan(m);
    const src = ctx.ast.source;
    var end: u32 = base.end;
    while (end < src.len) : (end += 1) {
        const ch = src[end];
        if (ch == '>' or ch == ' ' or ch == '\t') continue;
        if (ch == ';' or ch == ',') { end += 1; break; }
        break;
    }
    return Span{ .start = base.start, .end = end };
}

/// Looks for a class, interface, or type alias named `type_name` and
/// checks if it has a method `member_name` with a void return type.
/// `heritage_ref` is the original ts_type_reference (or .none) so
/// callers can supply type-argument bindings.
fn heritageMethodIsVoidWithRef(
    type_name: []const u8,
    member_name: []const u8,
    heritage_ref: NodeIndex,
    ctx: *const LintContext,
) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t == .class_decl) {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(ni).lhs));
            if (cd.name == .none) continue;
            const cname = ctx.tokenText(ctx.nodeMainToken(cd.name));
            if (!std.mem.eql(u8, cname, type_name)) continue;
            return classMethodIsVoid(cd, member_name, ctx);
        }
        if (t == .ts_interface_decl) {
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(ctx.nodeData(ni).lhs));
            const iname = ctx.tokenText(id.name);
            if (!std.mem.eql(u8, iname, type_name)) continue;
            return interfaceMethodIsVoid(id, member_name, ctx);
        }
        if (t == .ts_type_alias_decl) {
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(ctx.nodeData(ni).lhs));
            const aname = ctx.tokenText(ad.name);
            if (!std.mem.eql(u8, aname, type_name)) continue;
            // Collect alias-arg bindings from the heritage reference.
            var names: [4][]const u8 = undefined;
            var nodes: [4]NodeIndex = undefined;
            const n = collectAliasSubstitution(heritage_ref, ad, ctx, &names, &nodes);
            return aliasMethodIsVoidSubst(ad.type_node, member_name, names[0..n], nodes[0..n], ctx, 0);
        }
    }
    return false;
}

fn heritageMethodIsVoid(type_name: []const u8, member_name: []const u8, ctx: *const LintContext) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (t == .class_decl) {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(ni).lhs));
            if (cd.name == .none) continue;
            const cname = ctx.tokenText(ctx.nodeMainToken(cd.name));
            if (!std.mem.eql(u8, cname, type_name)) continue;
            return classMethodIsVoid(cd, member_name, ctx);
        }
        if (t == .ts_interface_decl) {
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(ctx.nodeData(ni).lhs));
            const iname = ctx.tokenText(id.name);
            if (!std.mem.eql(u8, iname, type_name)) continue;
            return interfaceMethodIsVoid(id, member_name, ctx);
        }
    }
    // Type alias fallback: type Foo = { ... } & { ... }.
    if (typeAliasBody(type_name, ctx)) |body| {
        return aliasMethodIsVoid(body, member_name, ctx, 0);
    }
    return false;
}

/// Pair the alias's declared type parameters with the heritage's
/// type-args, returning the count of bindings written.
fn collectAliasSubstitution(
    heritage_ref: NodeIndex,
    ad: ast.TypeAliasData,
    ctx: *const LintContext,
    names_out: *[4][]const u8,
    nodes_out: *[4]NodeIndex,
) usize {
    if (heritage_ref == .none) return 0;
    var ref = heritage_ref;
    while (ctx.nodeTag(ref) == .grouping_expr) ref = ctx.nodeData(ref).lhs;
    if (ctx.nodeTag(ref) != .ts_type_reference) return 0;
    const ref_data = ctx.nodeData(ref);
    if (ref_data.rhs == .none) return 0;
    const arg_range = ctx.extraData(ast.SubRange, @intFromEnum(ref_data.rhs));
    if (arg_range.start >= arg_range.end or arg_range.end > ctx.ast.extra_data.len) return 0;
    const args = ctx.ast.extra_data[arg_range.start..arg_range.end];
    if (ad.type_params_end <= ad.type_params or ad.type_params_end > ctx.ast.extra_data.len) return 0;
    const params = ctx.ast.extra_data[ad.type_params..ad.type_params_end];
    const n = @min(@min(args.len, params.len), names_out.len);
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const tp: NodeIndex = @enumFromInt(params[i]);
        if (ctx.nodeTag(tp) != .ts_type_parameter) continue;
        names_out[i] = ctx.tokenText(ctx.nodeMainToken(tp));
        nodes_out[i] = @enumFromInt(args[i]);
    }
    return n;
}

fn aliasMethodIsVoidSubst(
    ty: NodeIndex,
    member_name: []const u8,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
    depth: u8,
) bool {
    if (depth > 6) return false;
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    // Conditional type: `Check extends Extends ? A : B`.  Try to
    // evaluate the relation using the heritage's bindings.
    if (tag == .ts_conditional_type) {
        const d = ctx.nodeData(inner);
        const slice_start = @intFromEnum(d.lhs);
        const slice_end = @intFromEnum(d.rhs);
        if (slice_end <= slice_start or slice_end > ctx.ast.extra_data.len) return false;
        const slice = ctx.ast.extra_data[slice_start..slice_end];
        if (slice.len < 4) return false;
        const check_node: NodeIndex = @enumFromInt(slice[0]);
        const extends_node: NodeIndex = @enumFromInt(slice[1]);
        const true_arm: NodeIndex = @enumFromInt(slice[2]);
        const false_arm: NodeIndex = @enumFromInt(slice[3]);
        // Substitute check_node's type-parameter ref, then compare.
        const resolved_check = resolveBindingNode(check_node, names, nodes, ctx);
        const relation = compareTypeNodes(resolved_check, extends_node, ctx);
        if (relation == .yes) return aliasMethodIsVoidSubst(true_arm, member_name, names, nodes, ctx, depth + 1);
        if (relation == .no) return aliasMethodIsVoidSubst(false_arm, member_name, names, nodes, ctx, depth + 1);
        // Unknown — walk both arms; if either is void-matching we
        // can't safely fire, so OR them only if both agree.  Stay
        // conservative: require both arms void to fire.
        const a = aliasMethodIsVoidSubst(true_arm, member_name, names, nodes, ctx, depth + 1);
        const b = aliasMethodIsVoidSubst(false_arm, member_name, names, nodes, ctx, depth + 1);
        return a and b;
    }
    return aliasMethodIsVoid(inner, member_name, ctx, depth);
}

fn resolveBindingNode(
    node: NodeIndex,
    names: []const []const u8,
    nodes: []const NodeIndex,
    ctx: *const LintContext,
) NodeIndex {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .ts_type_reference) return node;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    for (names, nodes) |k, v| {
        if (std.mem.eql(u8, k, name)) return v;
    }
    return node;
}

const Relation = enum { yes, no, unknown };

/// Trivial type-node equality / disjointness check used by
/// conditional-type evaluation in inherited-method walks.  Handles
/// the cases the corpus exercises: literal-type-vs-literal-type,
/// keyword-vs-keyword.
fn compareTypeNodes(a: NodeIndex, b: NodeIndex, ctx: *const LintContext) Relation {
    if (a == .none or b == .none) return .unknown;
    var na = a;
    var nb = b;
    while (ctx.nodeTag(na) == .ts_parenthesized_type) na = ctx.nodeData(na).lhs;
    while (ctx.nodeTag(nb) == .ts_parenthesized_type) nb = ctx.nodeData(nb).lhs;
    if (ctx.nodeTag(na) != .ts_type_reference or ctx.nodeTag(nb) != .ts_type_reference) {
        return .unknown;
    }
    const txt_a = ctx.tokenText(ctx.nodeMainToken(na));
    const txt_b = ctx.tokenText(ctx.nodeMainToken(nb));
    if (std.mem.eql(u8, txt_a, txt_b)) return .yes;
    // `false extends true` / `true extends false` etc.
    const a_bool_lit = std.mem.eql(u8, txt_a, "true") or std.mem.eql(u8, txt_a, "false");
    const b_bool_lit = std.mem.eql(u8, txt_b, "true") or std.mem.eql(u8, txt_b, "false");
    if (a_bool_lit and b_bool_lit) return .no;
    return .unknown;
}

fn aliasMethodIsVoid(ty: NodeIndex, member_name: []const u8, ctx: *const LintContext, depth: u8) bool {
    if (depth > 4) return false;
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_type_literal) {
        const d = ctx.nodeData(inner);
        if (d.lhs == .none or d.rhs == .none) return false;
        const s = @intFromEnum(d.lhs);
        const e = @intFromEnum(d.rhs);
        if (s >= e or e > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mt = ctx.nodeTag(m);
            if (mt == .ts_method_signature) {
                const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
                if (sd.key == .none or ctx.nodeTag(sd.key) != .identifier) continue;
                const mname = ctx.tokenText(ctx.nodeMainToken(sd.key));
                if (!std.mem.eql(u8, mname, member_name)) continue;
                if (returnTypeIsVoid(sd.return_type, ctx)) return true;
                if (!annotationContainsPromise(sd.return_type, ctx)) return true;
            }
            if (mt == .ts_property_signature) {
                const md = ctx.nodeData(m);
                if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) continue;
                const mname = ctx.tokenText(ctx.nodeMainToken(md.lhs));
                if (!std.mem.eql(u8, mname, member_name)) continue;
                if (md.rhs == .none) continue;
                if (typeIsVoidReturningFn(md.rhs, ctx)) return true;
            }
        }
        return false;
    }
    if (tag == .ts_union_type or tag == .ts_intersection_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (aliasMethodIsVoid(m, member_name, ctx, depth + 1)) return true;
        }
    }
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (typeAliasBody(name, ctx)) |body| return aliasMethodIsVoid(body, member_name, ctx, depth + 1);
        if (heritageMethodIsVoid(name, member_name, ctx)) return true;
    }
    // `typeof X` — resolve to X's value type.  When X is bound to a
    // class expression, walk its members.
    if (tag == .ts_typeof_type or tag == .ts_type_query) {
        const operand_node = ctx.nodeData(inner).lhs;
        if (operand_node == .none) return false;
        var op = operand_node;
        while (ctx.nodeTag(op) == .ts_parenthesized_type) op = ctx.nodeData(op).lhs;
        if (ctx.nodeTag(op) == .ts_type_reference or ctx.nodeTag(op) == .identifier) {
            const op_name = ctx.tokenText(ctx.nodeMainToken(op));
            if (classExpressionBoundToName(op_name, ctx)) |cd| {
                if (classDataMethodIsVoid(cd, member_name, ctx)) return true;
            }
            // Or resolve to a known type alias.
            if (heritageMethodIsVoid(op_name, member_name, ctx)) return true;
        }
    }
    return false;
}

fn classMethodIsVoid(cd: ast.ClassData, name: []const u8, ctx: *const LintContext) bool {
    const body = cd.body;
    if (body == .none) return false;
    const bd = ctx.nodeData(body);
    const bs = @intFromEnum(bd.lhs);
    const be = @intFromEnum(bd.rhs);
    if (bs >= be or be > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[bs..be]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt != .method_def and mt != .computed_method_def) continue;
        const md_data = ctx.nodeData(m);
        if (md_data.lhs == .none or ctx.nodeTag(md_data.lhs) != .identifier) continue;
        const mname = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
        if (!std.mem.eql(u8, mname, name)) continue;
        const method_data = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
        if ((method_data.modifiers & ast.ModifierBit.@"static") != 0) continue;
        if (returnTypeIsVoid(method_data.return_type, ctx)) return true;
        const m_async = (method_data.modifiers & ast.ModifierBit.@"async") != 0;
        if (!m_async and !annotationContainsPromise(method_data.return_type, ctx)) return true;
    }
    return false;
}

fn interfaceMethodIsVoid(id: ast.InterfaceData, name: []const u8, ctx: *const LintContext) bool {
    if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[id.body_start..id.body_end]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt == .ts_method_signature) {
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(ctx.nodeData(m).lhs));
            const name_node = sd.key;
            if (name_node == .none or ctx.nodeTag(name_node) != .identifier) continue;
            const mname = ctx.tokenText(ctx.nodeMainToken(name_node));
            if (!std.mem.eql(u8, mname, name)) continue;
            if (returnTypeIsVoid(sd.return_type, ctx)) return true;
            if (!annotationContainsPromise(sd.return_type, ctx)) return true;
        } else if (mt == .ts_property_signature) {
            const md = ctx.nodeData(m);
            if (md.lhs == .none or ctx.nodeTag(md.lhs) != .identifier) continue;
            if (md.rhs == .none) continue;
            const pname = ctx.tokenText(ctx.nodeMainToken(md.lhs));
            if (!std.mem.eql(u8, pname, name)) continue;
            if (annotationFunctionReturnsPromise(md.rhs, ctx)) continue;
            if (annotationFunctionReturnsVoid(md.rhs, ctx)) return true;
        }
    }
    return false;
}

/// Full span of a class method_def including modifiers + body.  TSe
/// reports the entire method node for voidReturnInheritedMethod.
fn classMemberFullSpan(m: NodeIndex, method_data: ast.MethodData, ctx: *const LintContext) @import("es_parser").span.Span {
    var sp = ctx.nodeSpan(m);
    const src = ctx.ast.source;
    // Walk backward to include modifier keywords on the same line.
    var start: usize = sp.start;
    while (true) {
        var i: usize = start;
        while (i > 0 and (src[i - 1] == ' ' or src[i - 1] == '\t')) i -= 1;
        if (i == 0) break;
        const before = beforeWord(src, i) orelse break;
        if (!isClassMemberModifier(before)) break;
        start = i - before.len;
    }
    sp.start = @intCast(start);
    // Extend end to include body's closing brace if available.
    if (method_data.body != .none) {
        const body_sp = ctx.nodeSpan(method_data.body);
        if (body_sp.end > sp.end) sp.end = body_sp.end;
    }
    // For abstract / declared methods (no body), the parser's span may stop
    // before the trailing closing tokens — walk forward to include them.
    while (sp.end < src.len) {
        const c = src[sp.end];
        if (c == ' ' or c == '\t') { sp.end += 1; continue; }
        if (c == '>' or c == ';' or c == ')' or c == ']') { sp.end += 1; continue; }
        break;
    }
    return sp;
}

fn beforeWord(src: []const u8, end: usize) ?[]const u8 {
    var i: usize = end;
    while (i > 0) {
        const c = src[i - 1];
        if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_') {
            i -= 1;
        } else break;
    }
    if (i >= end) return null;
    return src[i..end];
}

fn isClassMemberModifier(word: []const u8) bool {
    const mods = [_][]const u8{ "public", "private", "protected", "static", "override", "readonly", "async", "abstract", "accessor" };
    for (mods) |w| if (std.mem.eql(u8, word, w)) return true;
    return false;
}

/// Span of a ts_method_signature including its trailing semicolon and
/// generic-close `>` (to match TSe's range).  Our parser's node span
/// often cuts off the trailing closing tokens.
fn methodSignatureSpan(node: NodeIndex, ctx: *const LintContext) @import("es_parser").span.Span {
    var sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    while (sp.end < src.len) {
        const c = src[sp.end];
        if (c == ' ' or c == '\t') { sp.end += 1; continue; }
        if (c == '>' or c == ';' or c == ')' or c == ']') { sp.end += 1; continue; }
        break;
    }
    return sp;
}

/// For `Record<K, V>` extract the V type node.
fn recordValueType(ty: NodeIndex, ctx: *const LintContext) ?NodeIndex {
    const args = ctx.nodeData(ty).rhs;
    if (args == .none) return null;
    const idx = @intFromEnum(args);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const s = ctx.ast.extra_data[idx];
    const e = ctx.ast.extra_data[idx + 1];
    if (s + 2 > e or e > ctx.ast.extra_data.len) return null;
    // V is the second arg.
    return @enumFromInt(ctx.ast.extra_data[s + 1]);
}

fn supeRefName(super_ref: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var ref = super_ref;
    while (ctx.nodeTag(ref) == .grouping_expr) ref = ctx.nodeData(ref).lhs;
    if (ctx.nodeTag(ref) != .identifier) return null;
    return ctx.tokenText(ctx.nodeMainToken(ref));
}

fn superclassMethodIsVoid(super_ref: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    if (super_ref == .none) return false;
    var ref = super_ref;
    while (ctx.nodeTag(ref) == .grouping_expr) ref = ctx.nodeData(ref).lhs;
    if (ctx.nodeTag(ref) != .identifier) return false;
    const sname = ctx.tokenText(ctx.nodeMainToken(ref));
    // First, check for a `const X = class { ... }` binding — the
    // class expression is the parent's structural shape.
    if (classExpressionBoundToName(sname, ctx)) |cd| {
        if (classDataMethodIsVoid(cd, name, ctx)) return true;
    }
    // Find class declaration with this name; walk its members for matching method.
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .class_decl) continue;
        const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(ni).lhs));
        if (cd.name == .none) continue;
        const cname = ctx.tokenText(ctx.nodeMainToken(cd.name));
        if (!std.mem.eql(u8, cname, sname)) continue;
        const body = cd.body;
        if (body == .none) return false;
        const bd = ctx.nodeData(body);
        const bs = @intFromEnum(bd.lhs);
        const be = @intFromEnum(bd.rhs);
        if (bs >= be or be > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[bs..be]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            const mt = ctx.nodeTag(m);
            if (mt == .method_def or mt == .computed_method_def) {
                const md_data = ctx.nodeData(m);
                if (md_data.lhs == .none or ctx.nodeTag(md_data.lhs) != .identifier) continue;
                const mname = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
                if (!std.mem.eql(u8, mname, name)) continue;
                const method_data = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
                if ((method_data.modifiers & ast.ModifierBit.@"static") != 0) continue;
                if (returnTypeIsVoid(method_data.return_type, ctx)) return true;
                const m_async = (method_data.modifiers & ast.ModifierBit.@"async") != 0;
                if (!m_async and !annotationContainsPromise(method_data.return_type, ctx)) return true;
                continue;
            }
            if (mt == .property_def or mt == .computed_property_def) {
                if (fieldMatchesVoidReturning(m, name, ctx)) return true;
            }
        }
        return false;
    }
    return false;
}

/// Find a `const X = class { ... }` declarator and return its
/// ClassData when X matches `name`.
fn classExpressionBoundToName(name: []const u8, ctx: *const LintContext) ?ast.ClassData {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) continue;
        const dn = ctx.tokenText(ctx.nodeMainToken(d.lhs));
        if (!std.mem.eql(u8, dn, name)) continue;
        if (d.rhs == .none) continue;
        var init = d.rhs;
        while (ctx.nodeTag(init) == .grouping_expr) init = ctx.nodeData(init).lhs;
        if (ctx.nodeTag(init) != .class_expr) continue;
        return ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(init).lhs));
    }
    return null;
}

/// Walk `cd.body` looking for a method (or void-returning field)
/// matching `name`.  Lifted from the inline loop in
/// `superclassMethodIsVoid` so the class-expression case can reuse it.
fn classDataMethodIsVoid(cd: ast.ClassData, name: []const u8, ctx: *const LintContext) bool {
    const body = cd.body;
    if (body == .none) return false;
    const bd = ctx.nodeData(body);
    const bs = @intFromEnum(bd.lhs);
    const be = @intFromEnum(bd.rhs);
    if (bs >= be or be > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[bs..be]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        const mt = ctx.nodeTag(m);
        if (mt == .method_def or mt == .computed_method_def) {
            const md_data = ctx.nodeData(m);
            if (md_data.lhs == .none or ctx.nodeTag(md_data.lhs) != .identifier) continue;
            const mname = ctx.tokenText(ctx.nodeMainToken(md_data.lhs));
            if (!std.mem.eql(u8, mname, name)) continue;
            const method_data = ctx.extraData(ast.MethodData, @intFromEnum(md_data.rhs));
            if ((method_data.modifiers & ast.ModifierBit.@"static") != 0) continue;
            if (returnTypeIsVoid(method_data.return_type, ctx)) return true;
            const m_async = (method_data.modifiers & ast.ModifierBit.@"async") != 0;
            if (!m_async and !annotationContainsPromise(method_data.return_type, ctx)) return true;
        } else if (mt == .property_def or mt == .computed_property_def) {
            if (fieldMatchesVoidReturning(m, name, ctx)) return true;
        }
    }
    return false;
}

/// True when class field `m` is named `name` and its declared /
/// initialiser type describes a void-returning function (no
/// Promise/async).
fn fieldMatchesVoidReturning(m: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    const pd_data = ctx.nodeData(m);
    if (pd_data.lhs == .none or ctx.nodeTag(pd_data.lhs) != .identifier) return false;
    const fname = ctx.tokenText(ctx.nodeMainToken(pd_data.lhs));
    if (!std.mem.eql(u8, fname, name)) return false;
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(pd_data.rhs));
    // Explicit annotation wins.
    if (pd.type_annotation != .none) {
        if (annotationFunctionReturnsPromise(pd.type_annotation, ctx)) return false;
        return annotationFunctionReturnsVoid(pd.type_annotation, ctx);
    }
    // Inferred from initialiser.
    if (pd.value != .none) {
        const vt = ctx.nodeTag(pd.value);
        if (vt == .arrow_fn) {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(pd.value).lhs));
            if (annotationContainsPromise(ad.return_type, ctx)) return false;
            return returnTypeIsVoid(ad.return_type, ctx);
        }
        if (vt == .async_arrow_fn) return false;
        if (vt == .fn_expr) {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(pd.value).lhs));
            if (annotationContainsPromise(fd.return_type, ctx)) return false;
            return returnTypeIsVoid(fd.return_type, ctx);
        }
        if (vt == .async_fn_expr) return false;
    }
    return false;
}

/// True when the annotation describes a function type whose return
/// type is `void` (peels parens / union / type-alias references).
fn annotationFunctionReturnsVoid(ann: NodeIndex, ctx: *const LintContext) bool {
    var ty = ann;
    if (ctx.nodeTag(ty) == .ts_type_annotation) ty = ctx.nodeData(ty).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (ctx.nodeTag(ty) == .ts_union_type or ctx.nodeTag(ty) == .ts_intersection_type) {
        const arms = directRange(ty, ctx) orelse return false;
        var found_void = false;
        for (arms) |raw| {
            const a: NodeIndex = @enumFromInt(raw);
            if (annotationFunctionReturnsPromise(a, ctx)) return false;
            if (annotationFunctionReturnsVoid(a, ctx)) found_void = true;
        }
        return found_void;
    }
    if (ctx.nodeTag(ty) == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(ty));
        if (typeAliasBody(name, ctx)) |body| return annotationFunctionReturnsVoid(body, ctx);
        return false;
    }
    if (ctx.nodeTag(ty) != .ts_function_type) return false;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(ty).lhs));
    return returnTypeIsVoid(fd.body, ctx);
}

// ────────────────────────────────────────────────────────────────────
// Promise / thenable detection (AST-level).
// ────────────────────────────────────────────────────────────────────

/// True if the expression is a Promise (used for conditional check —
/// must be ALWAYS thenable, not just sometimes).
fn exprIsAlwaysThenable(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .call_expr => return callReturnsPromise(n, ctx),
        // An optional call's result might be `undefined`, not always thenable.
        .optional_call_expr => return false,
        .new_expr => return newExprIsPromise(n, ctx),
        .await_expr => return false,
        .identifier => return identifierTypeIsAlwaysPromise(n, ctx),
        .ts_non_null_expr, .ts_satisfies_expr => return exprIsAlwaysThenable(ctx.nodeData(n).lhs, ctx),
        .ts_as_expr => {
            const tgt = ctx.nodeData(n).rhs;
            if (tgt != .none and tsTypeIsAlwaysPromise(tgt, ctx)) return true;
            return exprIsAlwaysThenable(ctx.nodeData(n).lhs, ctx);
        },
        // Logical / conditional are sometimes-thenable at best, not always.
        .logical_and, .logical_or, .nullish_coalesce, .conditional => return false,
        else => return false,
    }
}

fn identifierTypeIsAlwaysPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeIsAlwaysPromise(ctx.nodeData(bd.rhs).lhs, ctx);
}

/// True if every union arm is a Promise/PromiseLike/Thenable.
fn tsTypeIsAlwaysPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    const tag = ctx.nodeTag(inner);
    if (tag == .ts_union_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (!tsTypeIsAlwaysPromise(m, ctx)) return false;
        }
        return true;
    }
    if (tag == .ts_intersection_type) {
        // Intersection: each member must be compatible; if any is a Promise, the whole is thenable.
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (tsTypeIsAlwaysPromise(m, ctx)) return true;
        }
        return false;
    }
    if (tag == .ts_type_reference) {
        const name = ctx.tokenText(ctx.nodeMainToken(inner));
        if (std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "PromiseLike") or std.mem.eql(u8, name, "Thenable"))
            return true;
        if (typeAliasBody(name, ctx)) |body| return tsTypeIsAlwaysPromise(body, ctx);
    }
    return false;
}

fn exprIsSometimesThenable(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // For sometimes-thenable: any branch / arm could be a Promise.
    switch (tag) {
        .logical_and, .logical_or, .nullish_coalesce => {
            const d = ctx.nodeData(n);
            return exprIsSometimesThenable(d.lhs, ctx) or exprIsSometimesThenable(d.rhs, ctx);
        },
        .conditional => {
            const d = ctx.nodeData(n);
            const idx = @intFromEnum(d.rhs);
            if (idx + 1 >= ctx.ast.extra_data.len) return exprIsAlwaysThenable(n, ctx);
            const cond = ctx.extraData(ast.Conditional, idx);
            return exprIsSometimesThenable(cond.consequent, ctx) or exprIsSometimesThenable(cond.alternate, ctx);
        },
        .identifier => {
            if (identifierTypeIsPromise(n, ctx)) return true;
            // Sometimes thenable: Promise | undefined etc.
            return identifierTypeSometimesPromise(n, ctx);
        },
        else => return exprIsAlwaysThenable(n, ctx),
    }
}

fn identifierTypeSometimesPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return typeContainsPromiseInner(ctx.nodeData(bd.rhs).lhs, ctx);
}

/// True if the expression is a function (literal, identifier resolved
/// to a function, etc.) that returns a Promise.
fn exprIsPromiseReturningFn(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .async_fn_expr, .async_arrow_fn, .async_generator_fn_expr => return true,
        .fn_expr, .generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(n).lhs));
            if (annotationContainsPromise(fd.return_type, ctx)) return true;
            return bodyReturnsPromise(fd.body, ctx);
        },
        .arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(n).lhs));
            if (annotationContainsPromise(ad.return_type, ctx)) return true;
            if (ad.body != .none and ctx.nodeTag(ad.body) != .block_stmt) {
                return exprIsAlwaysThenable(ad.body, ctx);
            }
            return bodyReturnsPromise(ad.body, ctx);
        },
        .identifier => return identifierIsPromiseReturning(n, ctx),
        .member_expr, .optional_member_expr => return memberRefIsPromiseFn(n, ctx),
        else => return false,
    }
}

fn identifierIsPromiseReturning(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    const dt = ctx.nodeTag(decl);
    switch (dt) {
        .async_fn_decl, .async_generator_fn_decl => return true,
        .fn_decl, .generator_fn_decl, .ts_declare_function => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(decl).lhs));
            return annotationContainsPromise(fd.return_type, ctx);
        },
        else => {},
    }
    if (dt != .identifier) return false;
    const p = ctx.parentOf(decl);
    if (p != .none) {
        switch (ctx.nodeTag(p)) {
            .async_fn_decl, .async_generator_fn_decl => return true,
            .fn_decl, .generator_fn_decl, .ts_declare_function => {
                const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(p).lhs));
                return annotationContainsPromise(fd.return_type, ctx);
            },
            .declarator => {
                const init = ctx.nodeData(p).rhs;
                if (init != .none) {
                    if (initializerIsPromiseReturningFn(init, ctx)) return true;
                }
            },
            else => {},
        }
    }
    // Annotated binding: `const f: () => Promise<...>` etc.
    const dd = ctx.nodeData(decl);
    if (dd.rhs != .none and ctx.nodeTag(dd.rhs) == .ts_type_annotation) {
        const ty = ctx.nodeData(dd.rhs).lhs;
        if (annotationIsPromiseReturningFn(ty, ctx)) return true;
    }
    return false;
}

fn annotationIsPromiseReturningFn(ty: NodeIndex, ctx: *const LintContext) bool {
    if (ty == .none) return false;
    var inner = ty;
    while (ctx.nodeTag(inner) == .ts_parenthesized_type) inner = ctx.nodeData(inner).lhs;
    if (typeIsPromiseReturningFn(inner, ctx)) return true;
    if (ctx.nodeTag(inner) == .ts_union_type or ctx.nodeTag(inner) == .ts_intersection_type) {
        const arms = directRange(inner, ctx) orelse return false;
        for (arms) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (annotationIsPromiseReturningFn(m, ctx)) return true;
        }
    }
    return false;
}

fn initializerIsPromiseReturningFn(init: NodeIndex, ctx: *const LintContext) bool {
    const t = ctx.nodeTag(init);
    switch (t) {
        .async_fn_expr, .async_arrow_fn, .async_generator_fn_expr => return true,
        .fn_expr, .generator_fn_expr => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(init).lhs));
            if (annotationContainsPromise(fd.return_type, ctx)) return true;
            return bodyReturnsPromise(fd.body, ctx);
        },
        .arrow_fn => {
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(ctx.nodeData(init).lhs));
            if (annotationContainsPromise(ad.return_type, ctx)) return true;
            if (ad.body != .none and ctx.nodeTag(ad.body) != .block_stmt) {
                return exprIsAlwaysThenable(ad.body, ctx);
            }
            return bodyReturnsPromise(ad.body, ctx);
        },
        else => return false,
    }
}

/// True if at least one `return <promise>;` in `body`.
fn bodyReturnsPromise(body: NodeIndex, ctx: *const LintContext) bool {
    if (body == .none) return false;
    if (ctx.nodeTag(body) != .block_stmt) return exprIsAlwaysThenable(body, ctx);
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .return_stmt) continue;
        if (!isDescendantOf(ni, body, ctx)) continue;
        const v = ctx.nodeData(ni).lhs;
        if (v == .none) continue;
        if (exprIsAlwaysThenable(v, ctx)) return true;
    }
    return false;
}

fn isDescendantOf(node: NodeIndex, ancestor: NodeIndex, ctx: *const LintContext) bool {
    var cur = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        if (cur == ancestor) return true;
        switch (ctx.nodeTag(cur)) {
            .fn_decl, .fn_expr, .arrow_fn,
            .async_fn_decl, .async_fn_expr, .async_arrow_fn,
            .generator_fn_decl, .generator_fn_expr,
            .async_generator_fn_decl, .async_generator_fn_expr,
            .method_def, .computed_method_def,
            .class_decl, .class_expr => return false,
            else => {},
        }
    }
    return false;
}

fn memberRefIsPromiseFn(node: NodeIndex, ctx: *const LintContext) bool {
    // obj.method — without contextual info, conservatively say no.
    _ = node;
    _ = ctx;
    return false;
}

fn callReturnsPromise(call: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(call).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    if (callee == .none) return false;
    const ct = ctx.nodeTag(callee);
    if (ct == .member_expr or ct == .optional_member_expr) {
        const md = ctx.nodeData(callee);
        if (md.rhs != .none) {
            const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
            if (std.mem.eql(u8, m, "then") or std.mem.eql(u8, m, "catch") or std.mem.eql(u8, m, "finally"))
                return exprIsAlwaysThenable(md.lhs, ctx);
            if (ctx.nodeTag(md.lhs) == .identifier) {
                const obj = ctx.tokenText(ctx.nodeMainToken(md.lhs));
                if (std.mem.eql(u8, obj, "Promise")) {
                    return std.mem.eql(u8, m, "resolve") or std.mem.eql(u8, m, "reject") or
                        std.mem.eql(u8, m, "all") or std.mem.eql(u8, m, "race") or
                        std.mem.eql(u8, m, "allSettled") or std.mem.eql(u8, m, "any");
                }
            }
        }
    }
    switch (ct) {
        .async_fn_expr, .async_generator_fn_expr, .async_arrow_fn => return true,
        .identifier => return identifierIsPromiseReturning(callee, ctx),
        else => return false,
    }
}

fn newExprIsPromise(new_node: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(new_node).lhs;
    while (ctx.nodeTag(callee) == .ts_instantiation_expr) callee = ctx.nodeData(callee).lhs;
    if (ctx.nodeTag(callee) != .identifier) return false;
    return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(callee)), "Promise");
}

fn identifierTypeIsPromise(ident: NodeIndex, ctx: *const LintContext) bool {
    const sym = symbolForIdent(ident, ctx) orelse return false;
    const decl = ctx.semantic.symbols.getDeclNode(sym);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .identifier) return false;
    const bd = ctx.nodeData(decl);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return false;
    return tsTypeIsPromise(ctx.nodeData(bd.rhs).lhs, ctx);
}

fn tsTypeIsPromise(ty: NodeIndex, ctx: *const LintContext) bool {
    return typeContainsPromiseInner(ty, ctx);
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

fn isPromiseFinally(node: NodeIndex, ctx: *const LintContext) bool {
    var callee = ctx.nodeData(node).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const ct = ctx.nodeTag(callee);
    if (ct != .member_expr and ct != .optional_member_expr) return false;
    const md = ctx.nodeData(callee);
    if (md.rhs == .none) return false;
    const m = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    if (!std.mem.eql(u8, m, "finally")) return false;
    return exprIsAlwaysThenable(md.lhs, ctx);
}
