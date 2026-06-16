// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-redundant-type-constituents
//
// Reports members of unions and intersections that do nothing or
// override their peers.  See messageIds below for the relationships.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("ez_checker").types;

pub const meta = RuleMeta{
    .name = "no-redundant-type-constituents",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow members of unions and intersections that do nothing or override others",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{ .ts_union_type, .ts_intersection_type };

const Kind = enum {
    other,
    any,
    never,
    unknown_t,
    number_prim,
    string_prim,
    boolean_prim,
    bigint_prim,
    number_literal,
    string_literal,
    boolean_literal,
    bigint_literal,
    error_type,
    /// Alias reference whose body is a UNION of literals (mixed or
    /// not).  TSe reports on the alias rather than the primitive in
    /// `T & primitive` cases.
    number_literal_alias_union,
    string_literal_alias_union,
    boolean_literal_alias_union,
    bigint_literal_alias_union,
};

const MemberInfo = struct {
    node: NodeIndex,
    kind: Kind,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    // Skip nested unions/intersections that are inside another union/intersection
    // of the SAME kind — TSe processes only the outermost.
    const parent = ctx.parentOf(node);
    if (parent != .none) {
        var p = parent;
        while (ctx.nodeTag(p) == .ts_parenthesized_type) p = ctx.parentOf(p);
        if (ctx.nodeTag(p) == tag) return;
    }
    // Skip when inside a function return type — `string | never` etc.
    // are intentional there per TSe's checker behavior.
    if (isInReturnTypePosition(node, ctx)) return;
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return;
    const raw_members = ctx.ast.extra_data[s..e];
    if (raw_members.len < 2) return;

    // For each top-level member, classify it into ONE kind for the
    // membership analysis.  Nested unions are treated as a single
    // "literal_group" if all members are literals; this lets us
    // report once on `(0 | 1)` rather than each literal individually.
    var members_buf: [64]MemberInfo = undefined;
    var members_len: usize = 0;
    for (raw_members) |raw| {
        if (members_len >= members_buf.len) break;
        const m: NodeIndex = @enumFromInt(raw);
        var n = m;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
        const k = if (ctx.nodeTag(n) == tag)
            classifyNestedUnion(n, tag, ctx)
        else
            classifyMember(n, ctx);
        // Report on `n` (parens stripped) so the diag matches the
        // inner expression rather than the surrounding parens.
        members_buf[members_len] = .{ .node = n, .kind = k };
        members_len += 1;
    }

    if (tag == .ts_union_type) {
        reportUnion(members_buf[0..members_len], ctx);
    } else {
        reportIntersection(members_buf[0..members_len], ctx);
    }
}

/// Compute the span for a ts_union_type / ts_intersection_type node
/// EXCLUDING any trailing punctuation (the parser sets main_token to
/// the token AFTER the last member, so nodeSpan includes the
/// surrounding `)` or other delimiter).  Returns span covering
/// first-member-start..last-member-end.
fn unionSpan(node: NodeIndex, ctx: *const LintContext) parser.span.Span {
    const tag = ctx.nodeTag(node);
    if (tag != .ts_union_type and tag != .ts_intersection_type) {
        return ctx.nodeSpan(node);
    }
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return ctx.nodeSpan(node);
    const first_raw = ctx.ast.extra_data[s];
    const last_raw = ctx.ast.extra_data[e - 1];
    const first_n: NodeIndex = @enumFromInt(first_raw);
    const last_n: NodeIndex = @enumFromInt(last_raw);
    const fs = ctx.nodeSpan(first_n);
    const ls = ctx.nodeSpan(last_n);
    return .{ .start = fs.start, .end = ls.end };
}

fn reportMember(m: MemberInfo, msgid: []const u8, ctx: *const LintContext) void {
    var sp = unionSpan(m.node, ctx);
    // Negative literal type `-1n` / `-1`: parser creates a ts_type_reference
    // with main_token = `-`; nodeSpan only covers `-`.  Extend through
    // the immediately-following numeric literal so the diag span
    // matches what TS reports.
    if (ctx.nodeTag(m.node) == .ts_type_reference) {
        const main_tok = ctx.nodeMainToken(m.node);
        if (ctx.ast.tokenTag(main_tok) == .minus and main_tok + 1 < ctx.ast.tokens.len) {
            const nt = ctx.ast.tokenTag(main_tok + 1);
            if (nt == .number_literal or nt == .bigint_literal) {
                const next_start = ctx.ast.tokenStart(main_tok + 1);
                const next_len = ctx.ast.tokens.items(.len)[main_tok + 1];
                sp.end = next_start + next_len;
            }
        }
    }
    ctx.reportSpanWithMessageId(sp, msgid);
}

/// Nested same-kind union/intersection: classify as the FIRST member's
/// kind if all members share a literal kind; otherwise .other.  This
/// lets `(0 | 1)` report once when surrounded by a primitive.
fn classifyNestedUnion(node: NodeIndex, expected_tag: Node.Tag, ctx: *const LintContext) Kind {
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return .other;
    var first: ?Kind = null;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        var n = m;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
        const k = if (ctx.nodeTag(n) == expected_tag)
            classifyNestedUnion(n, expected_tag, ctx)
        else
            classifyMember(n, ctx);
        // Normalize alias-union variants to their base literal kind so
        // mixed direct/aliased members of the same kind can group.
        const norm = switch (k) {
            .number_literal_alias_union => Kind.number_literal,
            .string_literal_alias_union => Kind.string_literal,
            .boolean_literal_alias_union => Kind.boolean_literal,
            .bigint_literal_alias_union => Kind.bigint_literal,
            else => k,
        };
        switch (norm) {
            .number_literal, .string_literal, .bigint_literal, .boolean_literal => {
                if (first == null) {
                    first = norm;
                } else if (first.? != norm) {
                    return .other; // mixed literal kinds — too complex
                }
            },
            else => return .other,
        }
    }
    return first orelse .other;
}

fn classifyMember(node: NodeIndex, ctx: *const LintContext) Kind {
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // Direct literal types (TS literal type position uses value-like nodes).
    if (tag == .number_literal) return .number_literal;
    if (tag == .string_literal) return .string_literal;
    if (tag == .bigint_literal) return .bigint_literal;
    if (tag == .template_literal or tag == .ts_template_literal_type) {
        return .string_literal;
    }
    if (tag == .boolean_literal) return .boolean_literal;
    if (tag == .unary_minus or tag == .unary_plus) {
        const inner = classifyMember(ctx.nodeData(n).lhs, ctx);
        if (inner == .number_literal or inner == .bigint_literal) return inner;
        return .other;
    }
    if (tag == .ts_type_reference) {
        // In TS type position, literal types (`'a'`, `0`, `42n`, `true`)
        // and keyword types (`void`, `null`) all become ts_type_reference
        // nodes whose main_token is the literal/keyword.  Inspect the
        // token tag to recover the literal kind.
        const main_tok = ctx.nodeMainToken(n);
        const tok_tag = ctx.ast.tokenTag(main_tok);
        switch (tok_tag) {
            .number_literal => return .number_literal,
            .bigint_literal => return .bigint_literal,
            .string_literal => return .string_literal,
            .kw_true, .kw_false => return .boolean_literal,
            .kw_null, .kw_void, .kw_this => return .other,
            .minus => {
                // Negative numeric literal type `-1` / `-1n`. Parser
                // points main_token at `-`; the literal follows.
                if (main_tok + 1 < ctx.ast.tokens.len) {
                    const next_tag = ctx.ast.tokenTag(main_tok + 1);
                    if (next_tag == .number_literal) return .number_literal;
                    if (next_tag == .bigint_literal) return .bigint_literal;
                }
            },
            else => {},
        }
        const name = ctx.tokenText(main_tok);
        if (std.mem.eql(u8, name, "any")) return .any;
        if (std.mem.eql(u8, name, "never")) return .never;
        if (std.mem.eql(u8, name, "unknown")) return .unknown_t;
        if (std.mem.eql(u8, name, "number")) return .number_prim;
        if (std.mem.eql(u8, name, "string")) return .string_prim;
        if (std.mem.eql(u8, name, "boolean")) return .boolean_prim;
        if (std.mem.eql(u8, name, "bigint")) return .bigint_prim;
        // null / undefined / void / symbol / object / this — built-in
        // type keywords that aren't error types but also aren't part of
        // the literal-vs-primitive analysis.
        if (std.mem.eql(u8, name, "null") or std.mem.eql(u8, name, "undefined") or
            std.mem.eql(u8, name, "void") or std.mem.eql(u8, name, "symbol") or
            std.mem.eql(u8, name, "object") or std.mem.eql(u8, name, "this") or
            std.mem.eql(u8, name, "Date") or std.mem.eql(u8, name, "Promise") or
            std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")
        ) return .other;
        // User-named type reference: look up the alias declaration's
        // body AST and classify recursively. This preserves literal
        // types (the checker widens them to primitives).
        if (aliasBodyClassification(name, n, ctx)) |k| return k;
        // No alias found — unresolved name → error type.
        return .error_type;
    }
    // Negative literal type `-1`, `-1n`: parser wraps as ts_type_reference
    // with main_token = `-`.  Already covered above.  Just in case the
    // parser produces a unary_minus structure, fall back here.
    return .other;
}

fn kindFromTypeId(id: tymod.TypeId, ctx: *const LintContext) ?Kind {
    if (ctx.typeIdIsAny(id)) return .any;
    if (id.eq(tymod.ID_NEVER)) return .never;
    if (ctx.typeIdIsUnknown(id)) return .unknown_t;
    if (id.eq(tymod.ID_NUMBER)) return .number_prim;
    if (id.eq(tymod.ID_STRING)) return .string_prim;
    if (id.eq(tymod.ID_BIGINT)) return .bigint_prim;
    if (id.eq(tymod.ID_BOOLEAN)) return .boolean_prim;
    // Unions/intersections: don't classify; the alias is too varied to
    // single-tag.  Caller treats as .other (won't participate in the
    // primitive-vs-literal analysis).
    if (ctx.typeIdIsUnion(id) or ctx.typeIdIsIntersection(id)) return null;
    // Single-literal types: id is not a primitive but typeIdIs* returns
    // true → it's a single literal of that kind.
    if (ctx.typeIdIsNumberLike(id)) return .number_literal;
    if (ctx.typeIdIsStringy(id)) return .string_literal;
    if (ctx.typeIdIsExactlyBoolean(id)) return .boolean_literal;
    return null;
}

fn reportUnion(members: []const MemberInfo, ctx: *const LintContext) void {
    // Pass 1: any/unknown override everything.
    var any_seen = false;
    var unknown_seen = false;
    for (members) |m| {
        if (m.kind == .any) any_seen = true;
        if (m.kind == .unknown_t) unknown_seen = true;
    }
    if (any_seen) {
        for (members) |m| {
            if (m.kind == .any) {
                reportMember(m, "overrides", ctx);
            }
        }
        return;
    }
    if (unknown_seen) {
        for (members) |m| {
            if (m.kind == .unknown_t) {
                reportMember(m, "overrides", ctx);
            }
        }
        return;
    }
    // Pass 2: never is overridden by anything else (union with never).
    for (members) |m| {
        if (m.kind == .never) {
            reportMember(m, "overridden", ctx);
        }
    }
    // Pass 3: literal (or literal-alias-union) vs containing primitive.
    const has_number = anyKind(members, .number_prim);
    const has_string = anyKind(members, .string_prim);
    const has_boolean = anyKind(members, .boolean_prim);
    const has_bigint = anyKind(members, .bigint_prim);
    const has_error = anyKind(members, .error_type);
    for (members) |m| {
        const msgid: ?[]const u8 = switch (m.kind) {
            .number_literal, .number_literal_alias_union => if (has_number) @as([]const u8, "literalOverridden") else null,
            .string_literal, .string_literal_alias_union => if (has_string) @as([]const u8, "literalOverridden") else null,
            .boolean_literal, .boolean_literal_alias_union => if (has_boolean) @as([]const u8, "literalOverridden") else null,
            .bigint_literal, .bigint_literal_alias_union => if (has_bigint) @as([]const u8, "literalOverridden") else null,
            else => null,
        };
        if (msgid) |id| {
            reportMember(m, id, ctx);
        }
    }
    // Pass 3b: mixed-literal nested union with primitive companion.
    // E.g. `(2 | 'other' | 3) | number` — fire on the inner union with
    // literalOverridden when the sub-union has a literal that matches
    // some primitive in the outer union AND wasn't already classified
    // as a clean alias-union or single literal kind.
    for (members) |m| {
        if (m.kind != .other) continue;
        if (ctx.nodeTag(m.node) != .ts_union_type) continue;
        if (nestedHasOverriddenLiteral(m.node, has_number, has_string, has_boolean, has_bigint, ctx)) {
            reportMember(m, "literalOverridden", ctx);
        }
    }
    // Pass 4: error type vs literal — fire on error_type with errorTypeOverrides.
    if (has_error) {
        const has_any_literal =
            anyKind(members, .number_literal) or anyKind(members, .number_literal_alias_union) or
            anyKind(members, .string_literal) or anyKind(members, .string_literal_alias_union) or
            anyKind(members, .boolean_literal) or anyKind(members, .boolean_literal_alias_union) or
            anyKind(members, .bigint_literal) or anyKind(members, .bigint_literal_alias_union);
        if (has_any_literal) {
            for (members) |m| {
                if (m.kind == .error_type) {
                    reportMember(m, "errorTypeOverrides", ctx);
                }
            }
        }
    }
}

fn reportIntersection(members: []const MemberInfo, ctx: *const LintContext) void {
    // any & T → result is any → fire on any (overrides).
    // never & T → result is never → fire on never (overrides).
    var any_seen = false;
    var never_seen = false;
    for (members) |m| {
        if (m.kind == .any) any_seen = true;
        if (m.kind == .never) never_seen = true;
    }
    if (any_seen) {
        for (members) |m| {
            if (m.kind == .any) {
                reportMember(m, "overrides", ctx);
            }
        }
        return;
    }
    if (never_seen) {
        for (members) |m| {
            if (m.kind == .never) {
                reportMember(m, "overrides", ctx);
            }
        }
        return;
    }
    // unknown & T → result is T → fire on unknown (overridden).
    for (members) |m| {
        if (m.kind == .unknown_t) {
            reportMember(m, "overridden", ctx);
        }
    }
    // primitive & literal_alias_union → fire on the alias.
    // primitive & literal (direct OR single-literal-alias) → fire on the primitive.
    const has_number_literal = anyKind(members, .number_literal) or anyKind(members, .number_literal_alias_union);
    const has_string_literal = anyKind(members, .string_literal) or anyKind(members, .string_literal_alias_union);
    const has_boolean_literal = anyKind(members, .boolean_literal) or anyKind(members, .boolean_literal_alias_union);
    const has_bigint_literal = anyKind(members, .bigint_literal) or anyKind(members, .bigint_literal_alias_union);
    const has_error = anyKind(members, .error_type);
    // First pass: alias-unions report on themselves.
    for (members) |m| {
        const needs = switch (m.kind) {
            .number_literal_alias_union => anyKind(members, .number_prim),
            .string_literal_alias_union => anyKind(members, .string_prim),
            .boolean_literal_alias_union => anyKind(members, .boolean_prim),
            .bigint_literal_alias_union => anyKind(members, .bigint_prim),
            else => false,
        };
        if (needs) reportMember(m, "primitiveOverridden", ctx);
    }
    // Second pass: direct primitives report when a non-alias-union
    // literal companion exists.
    for (members) |m| {
        const needs: bool = switch (m.kind) {
            .number_prim => anyKind(members, .number_literal),
            .string_prim => anyKind(members, .string_literal),
            .boolean_prim => anyKind(members, .boolean_literal),
            .bigint_prim => anyKind(members, .bigint_literal),
            else => false,
        };
        if (needs) reportMember(m, "primitiveOverridden", ctx);
    }
    if (has_error) {
        const has_any_literal = has_number_literal or has_string_literal or
            has_boolean_literal or has_bigint_literal;
        if (has_any_literal) {
            for (members) |m| {
                if (m.kind == .error_type) {
                    reportMember(m, "errorTypeOverrides", ctx);
                }
            }
        }
    }
}


fn anyKind(members: []const MemberInfo, k: Kind) bool {
    for (members) |m| if (m.kind == k) return true;
    return false;
}

/// Find the ts_type_alias_decl whose name matches and recursively
/// classify its body type.  Returns null if no such alias found.
fn aliasBodyClassification(name: []const u8, ref_node: NodeIndex, ctx: *const LintContext) ?Kind {
    _ = ref_node;
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_alias_decl) continue;
        const data = ctx.nodeData(ni);
        if (data.lhs == .none) continue;
        const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
        const decl_name = ctx.tokenText(ad.name);
        if (!std.mem.eql(u8, decl_name, name)) continue;
        // Found.  Classify the body type node.
        var body = ad.type_node;
        if (body == .none) return .other;
        while (ctx.nodeTag(body) == .ts_parenthesized_type) body = ctx.nodeData(body).lhs;
        // If body is a UNION (regardless of intersection nesting),
        // return the alias-union variant so TSe-style reporting can
        // fire on the alias node rather than its primitive companion.
        const bt = ctx.nodeTag(body);
        if (bt == .ts_union_type) {
            const inner = classifyNestedUnion(body, .ts_union_type, ctx);
            return switch (inner) {
                .number_literal => .number_literal_alias_union,
                .string_literal => .string_literal_alias_union,
                .boolean_literal => .boolean_literal_alias_union,
                .bigint_literal => .bigint_literal_alias_union,
                else => .other,
            };
        }
        if (bt == .ts_intersection_type) {
            return classifyNestedUnion(body, .ts_intersection_type, ctx);
        }
        return classifyMember(body, ctx);
    }
    return null;
}

fn nestedHasOverriddenLiteral(
    union_node: NodeIndex,
    has_number: bool,
    has_string: bool,
    has_boolean: bool,
    has_bigint: bool,
    ctx: *const LintContext,
) bool {
    const data = ctx.nodeData(union_node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    for (ctx.ast.extra_data[s..e]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        var n = m;
        while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
        if (ctx.nodeTag(n) == .ts_union_type) {
            if (nestedHasOverriddenLiteral(n, has_number, has_string, has_boolean, has_bigint, ctx)) return true;
            continue;
        }
        const k = classifyMember(n, ctx);
        const matches: bool = switch (k) {
            .number_literal, .number_literal_alias_union => has_number,
            .string_literal, .string_literal_alias_union => has_string,
            .boolean_literal, .boolean_literal_alias_union => has_boolean,
            .bigint_literal, .bigint_literal_alias_union => has_bigint,
            else => false,
        };
        if (matches) return true;
    }
    return false;
}

fn isInReturnTypePosition(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    var p = ctx.parentOf(n);
    while (p != .none) {
        const pt = ctx.nodeTag(p);
        if (pt == .ts_parenthesized_type or pt == .ts_union_type or
            pt == .ts_intersection_type or pt == .ts_array_type)
        {
            n = p;
            p = ctx.parentOf(p);
            continue;
        }
        if (pt == .ts_function_type or pt == .ts_constructor_type) {
            const data = ctx.nodeData(p);
            if (data.lhs == .none) return false;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            return fd.body == n;
        }
        if (pt != .ts_type_annotation) return false;
        const ann_node = p;
        const owner = ctx.parentOf(ann_node);
        if (owner == .none) return false;
        const ot = ctx.nodeTag(owner);
        switch (ot) {
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .ts_declare_function => {
                const data = ctx.nodeData(owner);
                if (data.lhs == .none) return false;
                const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
                return fd.return_type == ann_node;
            },
            .arrow_fn, .async_arrow_fn => {
                const data = ctx.nodeData(owner);
                if (data.lhs == .none) return false;
                const ad = ctx.extraData(ast.ArrowData, @intFromEnum(data.lhs));
                return ad.return_type == ann_node;
            },
            .method_def, .computed_method_def => {
                const data = ctx.nodeData(owner);
                if (data.rhs == .none) return false;
                const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
                return md.return_type == ann_node;
            },
            .ts_call_signature, .ts_construct_signature, .ts_method_signature => return true,
            else => return false,
        }
    }
    return false;
}
