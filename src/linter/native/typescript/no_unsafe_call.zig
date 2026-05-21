// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unsafe-call
//
// Reports when a value of type `any` is invoked as a function (call_expr,
// new_expr, optional_call_expr, tagged_template).  Mirrors
// typescript-eslint's behavior:
//   * `const f: any = ...; f();`     → unsafe call
//   * `const o: any = ...; o.x();`   → unsafe call (callee is .x which propagates any)
//   * `const f: any = ...; new f();` → unsafe new
//   * tag\`x\` where tag is any      → unsafe call
//
// We do NOT fire when the callee's type resolves to anything else (number,
// unknown, an opaque type_ref).  In particular, `x.toString()` does NOT
// fire because we default unresolved property types to `unknown`, not
// `any` (see Checker.inferMember).

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-call",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow calling a value of type any",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .call_expr,
    .optional_call_expr,
    .new_expr,
    .tagged_template,
};

pub const needs_semantic = true;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const callee = calleeNode(node, ctx);
    if (callee == .none) return;
    // Fire on `any`-typed callee OR on a callee whose declared type is
    // the built-in `Function`.  TSe treats `Function` as unsafe because
    // it accepts any args and returns any.
    const is_any = ctx.typeNodeIsAny(callee);
    const is_error = !is_any and ctx.typeNodeIsError(callee);
    // The Function-detection path catches `const t: Function = ...; t()`
    // — TSe flags this because `Function` accepts any args.  Suppress
    // when the source defines its own `Function` type alias/interface
    // anywhere in scope.  Also fires when the callee's declared type is
    // a user interface that `extends Function` (transitively): TSe's
    // isBuiltinSymbolLike walks the inheritance graph; we approximate
    // by scanning for `interface X extends Function`.
    var is_function = !is_any and !is_error and ctx.typeNodeIsFunction(callee)
        and !fileShadowsFunctionType(ctx);
    if (!is_any and !is_error and !is_function) {
        const op_kind: OpKind = if (ctx.nodeTag(node) == .new_expr) .construct else .call_or_tag;
        if (inheritsFunctionByName(callee, op_kind, ctx)) is_function = true;
    }
    // Flow narrowing: `if (typeof x === 'function') { x() }` narrows
    // x from `unknown` to `Function`-callable, which TSe still treats
    // as unsafe-to-call (Function accepts any args).  Detect the
    // typeof-guard pattern when the callee is an identifier inside a
    // controlling if-statement.
    if (!is_any and !is_error and !is_function and isNarrowedToFunction(callee, ctx)) {
        is_function = true;
    }
    if (!is_any and !is_error and !is_function) return;
    const msg = if (is_error)
        switch (ctx.nodeTag(node)) {
            .new_expr => "errorNew",
            .tagged_template => "errorTemplateTag",
            else => "errorCall",
        }
    else switch (ctx.nodeTag(node)) {
        .new_expr => "unsafeNew",
        .tagged_template => "unsafeTemplateTag",
        else => "unsafeCall",
    };
    // typescript-eslint's reporting node depends on the call shape:
    //   CallExpression / TaggedTemplate → report at the callee/tag
    //     (selectors `CallExpression > *.callee` and
    //     `TaggedTemplateExpression > *.tag`).
    //   NewExpression → report at the whole `new X(...)` expression.
    const report_at = if (ctx.nodeTag(node) == .new_expr) node else callee;
    ctx.reportSpanWithMessageId(ctx.nodeSpan(report_at), msg);
}

/// True when `node` is an identifier reference that lives inside a
/// controlling `if (typeof <same-name> === 'function')` block.  Used by
/// no-unsafe-call to detect the TS narrowing pattern that converts an
/// unknown-typed binding to a Function-callable form.
///
/// Conditions checked:
///   * left side is `typeof <Name>` where Name matches our identifier
///   * comparison is === or == (TSe narrows for both)
///   * right side is the string literal `'function'` or `"function"`
///   * negation forms (`!==`, `!=`) DO NOT narrow positively — skip
///   * the identifier is in the CONSEQUENT of the if
fn isNarrowedToFunction(node: NodeIndex, ctx: *const LintContext) bool {
    if (ctx.nodeTag(node) != .identifier) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(node));
    if (name.len == 0) return false;
    var prev = node;
    var p = ctx.parentOf(node);
    while (p != .none) : ({
        prev = p;
        p = ctx.parentOf(p);
    }) {
        const tag = ctx.nodeTag(p);
        if (tag != .if_stmt and tag != .if_else_stmt) continue;
        const data = ctx.nodeData(p);
        // For if_stmt: data.lhs = condition, data.rhs = consequent.
        // For if_else_stmt: data.lhs = condition, data.rhs = extra
        // index to IfData {consequent, alternate}.  We want to know
        // which branch `prev` (the descendant we came from) is in.
        const cond = data.lhs;
        const in_consequent = blk: switch (tag) {
            .if_stmt => break :blk prev == data.rhs,
            .if_else_stmt => {
                const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
                break :blk prev == if_data.consequent;
            },
            else => break :blk false,
        };
        if (!in_consequent) continue;
        if (conditionNarrowsToFunction(cond, name, ctx)) return true;
    }
    return false;
}

/// Matches `typeof <name> === 'function'` (and the == / right-flipped /
/// parenthesized variants).
fn conditionNarrowsToFunction(cond: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var c = cond;
    while (ctx.nodeTag(c) == .grouping_expr) c = ctx.nodeData(c).lhs;
    const tag = ctx.nodeTag(c);
    if (tag != .strict_equal and tag != .equal) return false;
    const data = ctx.nodeData(c);
    return (binOpMatchesTypeofFn(data.lhs, data.rhs, name, ctx) or
        binOpMatchesTypeofFn(data.rhs, data.lhs, name, ctx));
}

fn binOpMatchesTypeofFn(left: NodeIndex, right: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var l = left;
    while (ctx.nodeTag(l) == .grouping_expr) l = ctx.nodeData(l).lhs;
    if (ctx.nodeTag(l) != .typeof_expr) return false;
    const inner = ctx.nodeData(l).lhs;
    if (ctx.nodeTag(inner) != .identifier) return false;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner)), name)) return false;
    var r = right;
    while (ctx.nodeTag(r) == .grouping_expr) r = ctx.nodeData(r).lhs;
    if (ctx.nodeTag(r) != .string_literal) return false;
    const raw = ctx.tokenText(ctx.nodeMainToken(r));
    if (raw.len < 2) return false;
    const body = raw[1 .. raw.len - 1];
    return std.mem.eql(u8, body, "function");
}

fn calleeNode(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    const data = ctx.nodeData(node);
    return switch (ctx.nodeTag(node)) {
        .call_expr, .optional_call_expr, .new_expr, .tagged_template => data.lhs,
        else => .none,
    };
}

/// Scan the AST for a user-defined `Function` type — type alias or
/// interface declaration that shadows the built-in.  Coarse: file-wide,
/// no scope analysis.  Sufficient to suppress the FP on cases like
/// `{ type Function = () => void; const t: Function = ...; t(); }`
/// without risking false negatives elsewhere — built-in Function is
/// the only common shadow target.
fn fileShadowsFunctionType(ctx: *const LintContext) bool {
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const tag = tree.nodeTag(ni);
        if (tag != .ts_type_alias_decl and tag != .ts_interface_decl) continue;
        const data = tree.nodeData(ni);
        const tok_idx: u32 = if (tag == .ts_type_alias_decl) blk: {
            const ad = tree.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
            break :blk ad.name;
        } else blk: {
            const id = tree.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            break :blk id.name;
        };
        const name = tree.tokenText(tok_idx);
        if (std.mem.eql(u8, name, "Function")) return true;
    }
    return false;
}

/// True when the callee's declared type name is a user interface that
/// (transitively) extends `Function`.  Approximates TSe's
/// isBuiltinSymbolLike walk over the inheritance graph by:
///   1. resolving the callee's declared type-ref name
///   2. scanning for `interface <Name> extends ... Function ...`
/// One-hop only — `interface A extends B; interface B extends Function`
/// won't be caught.  Coarse but enough for the common-case test fixtures.
const OpKind = enum { call_or_tag, construct };

fn inheritsFunctionByName(callee: NodeIndex, op: OpKind, ctx: *const LintContext) bool {
    const name = declaredTypeRefName(callee, ctx) orelse return false;
    if (name.len == 0) return false;
    const tree = ctx.ast;
    const total: u32 = @intCast(tree.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (tree.nodeTag(ni) != .ts_interface_decl) continue;
        const data = tree.nodeData(ni);
        const id = tree.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
        const iname = tree.tokenText(id.name);
        if (!std.mem.eql(u8, iname, name)) continue;
        const ext_start = id.extends_start;
        const ext_end = id.extends_end;
        if (ext_end <= ext_start) continue;
        const slice = tree.extra_data[ext_start..ext_end];
        var extends_function = false;
        for (slice) |tok| {
            if (std.mem.eql(u8, tree.tokenText(tok), "Function")) {
                extends_function = true;
                break;
            }
        }
        if (!extends_function) continue;
        // TSe's "safe-to-{call,construct}" check on a Function subtype:
        //   * safe-to-call (incl. template tag): any call signature
        //   * safe-to-construct: any construct signature OR a call
        //     signature with non-void return type.  TSe special-cases
        //     this because callable-only types like `(): T` can be
        //     constructed (the result is the call return type).
        const body_start = id.body_start;
        const body_end = id.body_end;
        var has_call_sig = false;
        var has_non_void_call_sig = false;
        var has_construct_sig = false;
        if (body_end > body_start) {
            const body = tree.extra_data[body_start..body_end];
            for (body) |raw| {
                const member: NodeIndex = @enumFromInt(raw);
                const mtag = tree.nodeTag(member);
                if (mtag == .ts_call_signature) {
                    has_call_sig = true;
                    if (!callSigReturnsVoid(member, tree)) has_non_void_call_sig = true;
                } else if (mtag == .ts_construct_signature) {
                    has_construct_sig = true;
                }
            }
        }
        const safe = switch (op) {
            .call_or_tag => has_call_sig,
            .construct => has_construct_sig or has_non_void_call_sig,
        };
        if (!safe) return true;
    }
    return false;
}

/// True when a `ts_call_signature` body has an explicit `: void` return
/// type.  Missing return type defaults to `any` in TS — treat as
/// non-void since `(): any` would let TSe construct.
fn callSigReturnsVoid(sig: NodeIndex, tree: *const ast.Ast) bool {
    if (tree.nodeTag(sig) != .ts_call_signature) return false;
    const sd = tree.extraData(ast.InterfaceSigData, @intFromEnum(tree.nodeData(sig).lhs));
    if (sd.return_type == .none) return false;
    if (tree.nodeTag(sd.return_type) != .ts_type_annotation) return false;
    const ty_node = tree.nodeData(sd.return_type).lhs;
    if (ty_node == .none) return false;
    if (tree.nodeTag(ty_node) != .ts_type_reference) return false;
    const name = tree.tokenText(tree.nodeMainToken(ty_node));
    return std.mem.eql(u8, name, "void");
}

/// Returns the textual name of the declared type for an expression that
/// resolves through an identifier reference annotated with a single
/// ts_type_reference.  `declare const x: Unsafe; x()` → returns "Unsafe".
/// Returns null for expressions whose declared type is more complex
/// (union, type literal, etc.).
fn declaredTypeRefName(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (ctx.nodeTag(node) != .identifier) return null;
    // Look up the symbol's declaration to find the annotation.
    const refs = &ctx.semantic.references;
    const total = refs.count();
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const rid = parser.reference.ReferenceId.fromInt(i);
        if (refs.getNode(rid) != node) continue;
        if (!refs.isResolved(rid)) return null;
        const sym = refs.getSymbol(rid);
        const decl = ctx.semantic.symbols.getDeclNode(sym);
        if (decl == .none) return null;
        if (ctx.nodeTag(decl) != .identifier) return null;
        const decl_data = ctx.nodeData(decl);
        if (decl_data.rhs == .none) return null;
        if (ctx.nodeTag(decl_data.rhs) != .ts_type_annotation) return null;
        const ty = ctx.nodeData(decl_data.rhs).lhs;
        if (ty == .none or ctx.nodeTag(ty) != .ts_type_reference) return null;
        const name_tok = ctx.nodeMainToken(ty);
        return ctx.tokenText(name_tok);
    }
    return null;
}
