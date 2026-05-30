// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/use-unknown-in-catch-callback-variable
//
// Reports `.catch((err: T) => ...)` and `.then(_, (err: T) => ...)`
// where `T` isn't `unknown` — promise rejection values should always
// be typed as `unknown` for safety.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const Span = parser.span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "use-unknown-in-catch-callback-variable",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Enforce typing arguments in Promise rejection callbacks as `unknown`",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .call_expr, .optional_call_expr };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const callee = data.lhs;
    if (callee == .none) return;
    // Skip if any argument is a spread element — the rejection
    // callback position becomes ambiguous.
    if (anyArgIsSpread(node, ctx)) return;
    const ct = ctx.nodeTag(callee);
    var fn_name: []const u8 = "";
    switch (ct) {
        .member_expr, .optional_member_expr => {
            fn_name = ctx.tokenText(ctx.nodeMainToken(callee));
        },
        .computed_member_expr, .optional_computed_member_expr => {
            const md = ctx.nodeData(callee);
            if (md.rhs == .none) return;
            // Static string-literal key.
            if (ctx.nodeTag(md.rhs) == .string_literal) {
                const raw = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                if (raw.len < 2) return;
                fn_name = raw[1 .. raw.len - 1];
            } else if (ctx.nodeTag(md.rhs) == .identifier) {
                // Identifier reference — try resolving its initializer
                // if it's a `const x = 'catch'` style.
                const name = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                if (resolveStringConst(name, ctx)) |val| fn_name = val
                else return;
            } else return;
        },
        else => return,
    }
    var args_start: usize = 0;
    if (std.mem.eql(u8, fn_name, "catch")) {
        args_start = 0;
    } else if (std.mem.eql(u8, fn_name, "then")) {
        args_start = 1;
    } else return;
    // Skip if receiver isn't a known Promise (heuristic — only call on
    // expressions that LOOK like Promise chains).
    if (!receiverIsPromiseLike(callee, ctx)) return;
    const args = callArgs(node, ctx) orelse return;
    if (args.len <= args_start) return;
    const cb: NodeIndex = @enumFromInt(args[args_start]);
    visitCallbackExpression(cb, ctx);
}

/// Walk through conditional / logical / sequence wrappers to find
/// the inner function callback(s) and check each.
fn visitCallbackExpression(node: NodeIndex, ctx: *const LintContext) void {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .conditional => {
            // cond ? consequent : alternate.  Check both branches.
            const data = ctx.nodeData(n);
            if (data.rhs == .none) return;
            const cd = ctx.extraData(ast.Conditional, @intFromEnum(data.rhs));
            visitCallbackExpression(cd.consequent, ctx);
            visitCallbackExpression(cd.alternate, ctx);
        },
        .logical_or, .logical_and, .nullish_coalesce => {
            const data = ctx.nodeData(n);
            visitCallbackExpression(data.lhs, ctx);
            visitCallbackExpression(data.rhs, ctx);
        },
        .sequence_expr => {
            // Sequence value is the LAST expression.
            const data = ctx.nodeData(n);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return;
            const items = ctx.ast.extra_data[s..e];
            if (items.len == 0) return;
            const last: NodeIndex = @enumFromInt(items[items.len - 1]);
            visitCallbackExpression(last, ctx);
        },
        else => checkCallback(n, ctx),
    }
}

fn checkCallback(cb: NodeIndex, ctx: *const LintContext) void {
    var n = cb;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    var params_start: u32 = 0;
    var params_end: u32 = 0;
    switch (tag) {
        .arrow_fn, .async_arrow_fn => {
            const data = ctx.nodeData(n);
            if (data.lhs == .none) return;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
            params_start = ad.params_start;
            params_end = ad.params_end;
        },
        .fn_expr, .async_fn_expr => {
            const data = ctx.nodeData(n);
            if (data.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            params_start = fd.params;
            params_end = fd.params_end;
        },
        else => return,
    }
    if (params_start >= params_end or params_end > ctx.ast.extra_data.len) return;
    const params = ctx.ast.extra_data[params_start..params_end];
    if (params.len == 0) return;
    // First param OR first rest param.
    const first: NodeIndex = @enumFromInt(params[0]);
    reportParamIfTyped(first, ctx);
}

fn reportParamIfTyped(param: NodeIndex, ctx: *const LintContext) void {
    var ann: NodeIndex = .none;
    var is_rest = false;
    var inner_id: NodeIndex = param;
    if (ctx.nodeTag(param) == .rest_element) {
        is_rest = true;
        const rd = ctx.nodeData(param);
        inner_id = rd.lhs;
        ann = rd.rhs;
    }
    if (ann == .none and ctx.nodeTag(inner_id) == .identifier) {
        ann = ctx.nodeData(inner_id).rhs;
    }
    const inner_tag = ctx.nodeTag(inner_id);
    const is_destructure = inner_tag == .array_pattern or inner_tag == .object_pattern;
    // If we have an annotation, check it first.  Even for destructuring
    // patterns, `[err]: [unknown]` doesn't fire because the inner type
    // is `unknown`.
    if (ann != .none and ctx.nodeTag(ann) == .ts_type_annotation) {
        var ty = ctx.nodeData(ann).lhs;
        while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
        if (typeIsExactlyUnknown(ty, ctx)) return;
        if (is_rest and restTypeIsUnknown(ann, ctx)) return;
        // If destructuring with annotation: TSe rule still fires for
        // destructuring patterns BUT uses different messageIds.  And
        // for rest+destructure of unknown[], TSe doesn't fire.
    }
    if (is_destructure) {
        // Rest+destructure uses generic `useUnknown`; plain destructure
        // uses destructuring-specific messageIds.  Destructuring patterns
        // ALWAYS fire (regardless of annotation type) — TSe wants
        // `err: unknown` then destructure inside the body.
        const msg: []const u8 = if (is_rest)
            "useUnknown"
        else if (inner_tag == .array_pattern)
            "useUnknownArrayDestructuringPattern"
        else
            "useUnknownObjectDestructuringPattern";
        const report_target = if (is_rest) param else inner_id;
        var sp = paramSpan(report_target, ctx);
        if (!is_rest) sp = extendThroughAnnotation(sp, ctx);
        ctx.reportSpanWithMessageId(sp, msg);
        return;
    }
    // Plain identifier path.
    if (ann == .none) {
        var sp = paramSpan(param, ctx);
        sp = extendThroughAnnotation(sp, ctx);
        ctx.reportSpanWithMessageId(sp, "useUnknown");
        return;
    }
    if (ctx.nodeTag(ann) != .ts_type_annotation) return;
    var ty = ctx.nodeData(ann).lhs;
    while (ctx.nodeTag(ty) == .ts_parenthesized_type) ty = ctx.nodeData(ty).lhs;
    if (typeIsExactlyUnknown(ty, ctx)) return;
    if (is_rest and restTypeIsUnknown(ann, ctx)) return;
    var sp = paramSpan(param, ctx);
    sp = extendThroughAnnotation(sp, ctx);
    ctx.reportSpanWithMessageId(sp, "useUnknown");
}

fn typeIsExactlyUnknown(ty: NodeIndex, ctx: *const LintContext) bool {
    var n = ty;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    return std.mem.eql(u8, name, "unknown");
}

/// For rest params, accept the annotation when its FIRST element type
/// (or array element type) is `unknown` — that's the type of args[0]
/// which is the rejection value.  Handles `unknown[]`,
/// `readonly unknown[]`, `[unknown]`, `[unknown, ...]`,
/// `[a: unknown, ...]`.
fn restTypeIsUnknown(ann: NodeIndex, ctx: *const LintContext) bool {
    const sp = balanceSpan(ctx.nodeSpan(ann), ctx);
    if (sp.end > ctx.ast.source.len) return false;
    const text = ctx.ast.source[sp.start..sp.end];
    var i: usize = 0;
    while (i < text.len and (text[i] == ':' or text[i] == ' ' or text[i] == '\t' or text[i] == '\n')) i += 1;
    if (i >= text.len) return false;
    var rest = text[i..];
    // Optional `readonly` prefix.
    if (rest.len >= 9 and std.mem.eql(u8, rest[0..9], "readonly ")) rest = rest[9..];
    // Trim leading whitespace.
    while (rest.len > 0 and (rest[0] == ' ' or rest[0] == '\t' or rest[0] == '\n')) rest = rest[1..];
    // `unknown[]` form.
    if (rest.len >= 9 and std.mem.eql(u8, rest[0..9], "unknown[]")) return true;
    // `Array<unknown>` form.
    if (rest.len >= 14 and std.mem.eql(u8, rest[0..14], "Array<unknown>")) return true;
    // Tuple form — find the first element and check it's `unknown`.
    if (rest.len > 0 and rest[0] == '[') {
        // Skip `[`, skip whitespace, optional label `name: `.
        var j: usize = 1;
        while (j < rest.len and (rest[j] == ' ' or rest[j] == '\t' or rest[j] == '\n')) j += 1;
        // Possibly a labeled element: `name: unknown` or `name?: unknown`.
        // Skip ident, optional `?`, then `:`.
        const ident_start = j;
        while (j < rest.len and isIdentChar(rest[j])) j += 1;
        if (j > ident_start) {
            // Check if followed by `?:` or `:`.
            var k: usize = j;
            while (k < rest.len and (rest[k] == ' ' or rest[k] == '\t')) k += 1;
            if (k < rest.len and rest[k] == '?') k += 1;
            if (k < rest.len and rest[k] == ':') {
                k += 1;
                while (k < rest.len and (rest[k] == ' ' or rest[k] == '\t')) k += 1;
                j = k;
            } else {
                // No label — back to ident start, that's the type itself.
                j = ident_start;
            }
        }
        // Check `unknown` at j.
        if (j + 7 <= rest.len and std.mem.eql(u8, rest[j .. j + 7], "unknown")) {
            // Verify boundary — next char is `]`, `,`, or whitespace.
            if (j + 7 >= rest.len) return true;
            const c = rest[j + 7];
            if (c == ']' or c == ',' or c == ' ' or c == '\t' or c == '\n' or c == '?') return true;
        }
    }
    return false;
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}

/// True if the receiver chain looks Promise-like: starts from
/// `Promise.xxx(...)`, `new Promise(...)`, `await`, or another
/// `.then`/`.catch`/`.finally` chain.
fn receiverIsPromiseLike(callee: NodeIndex, ctx: *const LintContext) bool {
    const md = ctx.nodeData(callee);
    var recv = md.lhs;
    if (recv == .none) return false;
    while (true) {
        const t = ctx.nodeTag(recv);
        if (t == .grouping_expr) { recv = ctx.nodeData(recv).lhs; continue; }
        if (t == .await_expr) return true;
        if (t == .new_expr) {
            const nd = ctx.nodeData(recv);
            if (nd.lhs == .none) return false;
            if (ctx.nodeTag(nd.lhs) == .identifier and
                std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(nd.lhs)), "Promise"))
            {
                return true;
            }
            return false;
        }
        if (t == .call_expr or t == .optional_call_expr) {
            const cd = ctx.nodeData(recv);
            const inner = cd.lhs;
            if (inner == .none) return false;
            const it = ctx.nodeTag(inner);
            // `Promise.<staticMethod>(...)` — receiver of inner member is Promise.
            if (it == .member_expr or it == .optional_member_expr) {
                const inner_md = ctx.nodeData(inner);
                if (inner_md.lhs != .none and ctx.nodeTag(inner_md.lhs) == .identifier and
                    std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(inner_md.lhs)), "Promise"))
                {
                    return true;
                }
                // Otherwise it could be a chained `.then`/`.catch` — recurse.
                const inner_method = ctx.tokenText(ctx.nodeMainToken(inner));
                if (std.mem.eql(u8, inner_method, "then") or
                    std.mem.eql(u8, inner_method, "catch") or
                    std.mem.eql(u8, inner_method, "finally"))
                {
                    recv = inner;
                    continue;
                }
            }
            return false;
        }
        // Plain identifier — accept conservatively only when the name
        // looks like a Promise variable (camelCase ending in "Promise").
        return false;
    }
}

fn anyArgIsSpread(call: NodeIndex, ctx: *const LintContext) bool {
    const args = callArgs(call, ctx) orelse return false;
    for (args) |raw| {
        const a: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(a) == .spread_element) return true;
    }
    return false;
}

/// True if a destructure pattern's source-following annotation is
/// `: unknown[]` / `: [unknown]` / etc.  Used as fallback when parser
/// drops the annotation.
fn destructureSourceAnnotationIsUnknown(pattern: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(pattern);
    const src = ctx.ast.source;
    var i: usize = sp.end;
    while (i < src.len and (src[i] == ' ' or src[i] == '\t' or src[i] == '\n')) i += 1;
    if (i >= src.len or src[i] != ':') return false;
    // Build a fake annotation text: `: <rest>` until the matching `)` of the param.
    var j: usize = i + 1;
    var depth: i32 = 0;
    while (j < src.len) : (j += 1) {
        const c = src[j];
        if (c == '(' or c == '[' or c == '{' or c == '<') depth += 1;
        if (c == ')' or c == ']' or c == '}' or c == '>') {
            if (depth == 0) break;
            depth -= 1;
        }
        if (depth == 0 and (c == ',' or c == '=')) break;
    }
    const text = src[i..j];
    return isUnknownTypeText(text);
}

fn isUnknownTypeText(text: []const u8) bool {
    var rest = text;
    while (rest.len > 0 and (rest[0] == ':' or rest[0] == ' ' or rest[0] == '\t' or rest[0] == '\n')) rest = rest[1..];
    if (rest.len >= 9 and std.mem.eql(u8, rest[0..9], "readonly ")) rest = rest[9..];
    while (rest.len > 0 and (rest[0] == ' ' or rest[0] == '\t' or rest[0] == '\n')) rest = rest[1..];
    if (rest.len == 7 and std.mem.eql(u8, rest, "unknown")) return true;
    if (rest.len >= 9 and std.mem.eql(u8, rest[0..9], "unknown[]")) return true;
    if (rest.len >= 14 and std.mem.eql(u8, rest[0..14], "Array<unknown>")) return true;
    if (rest.len > 0 and rest[0] == '[') {
        // Tuple: check first element is unknown.
        var j: usize = 1;
        while (j < rest.len and (rest[j] == ' ' or rest[j] == '\t' or rest[j] == '\n')) j += 1;
        const id_start = j;
        while (j < rest.len and isIdentChar(rest[j])) j += 1;
        // Optional label "name:".
        if (j > id_start) {
            var k: usize = j;
            while (k < rest.len and (rest[k] == ' ' or rest[k] == '\t')) k += 1;
            if (k < rest.len and rest[k] == '?') k += 1;
            if (k < rest.len and rest[k] == ':') {
                k += 1;
                while (k < rest.len and (rest[k] == ' ' or rest[k] == '\t')) k += 1;
                j = k;
            } else j = id_start;
        }
        if (j + 7 <= rest.len and std.mem.eql(u8, rest[j .. j + 7], "unknown")) {
            if (j + 7 >= rest.len) return true;
            const c = rest[j + 7];
            if (c == ']' or c == ',' or c == ' ' or c == '\t' or c == '\n') return true;
        }
    }
    return false;
}

fn extendThroughAnnotation(in_sp: Span, ctx: *const LintContext) Span {
    var sp = in_sp;
    const src = ctx.ast.source;
    var i: usize = sp.end;
    while (i < src.len and (src[i] == ' ' or src[i] == '\t' or src[i] == '\n')) i += 1;
    if (i >= src.len or src[i] != ':') return sp;
    // Walk through the type expression until `)`, `,`, or `=` at the
    // OUTER paren/bracket/brace level.  Don't treat `>` as a closer
    // (would break on `=>` arrows or type-arg `<T>`).
    var j: usize = i;
    var depth: i32 = 0;
    while (j < src.len) : (j += 1) {
        const c = src[j];
        if (c == '(' or c == '[' or c == '{') depth += 1;
        if (c == ')' or c == ']' or c == '}') {
            if (depth == 0) break;
            depth -= 1;
        }
        if (depth == 0 and (c == ',' or c == '=')) break;
    }
    sp.end = @intCast(j);
    return sp;
}

fn paramSpan(param: NodeIndex, ctx: *const LintContext) Span {
    var sp = balanceSpan(ctx.nodeSpan(param), ctx);
    const src = ctx.ast.source;
    // Trim a trailing `)` that's unmatched within the current span —
    // that's the outer param list paren, not part of the param.
    if (sp.end > sp.start) {
        var d: i32 = 0;
        var k: usize = sp.start;
        while (k < sp.end) : (k += 1) {
            if (src[k] == '(') d += 1;
            if (src[k] == ')') d -= 1;
        }
        while (sp.end > sp.start and d < 0 and src[sp.end - 1] == ')') {
            sp.end -= 1;
            d += 1;
        }
    }
    // Extend through `?` (optional param).
    if (sp.end < src.len and src[sp.end] == '?') sp.end += 1;
    return sp;
}

fn balanceSpan(in_sp: Span, ctx: *const LintContext) Span {
    var sp = in_sp;
    const src = ctx.ast.source;
    var d_brack: i32 = 0;
    var d_brace: i32 = 0;
    var d_angle: i32 = 0;
    var d_paren: i32 = 0;
    var k: usize = sp.start;
    while (k < sp.end) : (k += 1) {
        switch (src[k]) {
            '[' => d_brack += 1,
            ']' => d_brack -= 1,
            '{' => d_brace += 1,
            '}' => d_brace -= 1,
            '<' => d_angle += 1,
            '>' => d_angle -= 1,
            '(' => d_paren += 1,
            ')' => d_paren -= 1,
            else => {},
        }
    }
    // Only extend forward if there are unbalanced opens INSIDE the span.
    // Don't extend if already balanced (avoids consuming outer wrap).
    var j: usize = sp.end;
    while (j < src.len) : (j += 1) {
        if (d_brack <= 0 and d_brace <= 0 and d_angle <= 0 and d_paren <= 0) break;
        switch (src[j]) {
            '[' => d_brack += 1,
            ']' => d_brack -= 1,
            '{' => d_brace += 1,
            '}' => d_brace -= 1,
            '<' => d_angle += 1,
            '>' => d_angle -= 1,
            '(' => d_paren += 1,
            ')' => d_paren -= 1,
            else => {},
        }
    }
    sp.end = @intCast(j);
    return sp;
}

fn resolveStringConst(name: []const u8, ctx: *const LintContext) ?[]const u8 {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        if (ctx.nodeTag(d.lhs) != .identifier) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) continue;
        if (d.rhs == .none or ctx.nodeTag(d.rhs) != .string_literal) continue;
        const raw = ctx.tokenText(ctx.nodeMainToken(d.rhs));
        if (raw.len < 2) return null;
        return raw[1 .. raw.len - 1];
    }
    return null;
}

fn callArgs(call: NodeIndex, ctx: *const LintContext) ?[]const u32 {
    const data = ctx.nodeData(call);
    if (data.rhs == .none) return null;
    const idx = @intFromEnum(data.rhs);
    if (idx + 1 >= ctx.ast.extra_data.len) return null;
    const start = ctx.ast.extra_data[idx];
    const end = ctx.ast.extra_data[idx + 1];
    if (end < start or end > ctx.ast.extra_data.len) return null;
    return ctx.ast.extra_data[start..end];
}
