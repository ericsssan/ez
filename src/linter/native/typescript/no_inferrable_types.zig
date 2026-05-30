// HAND-WRITTEN.
// Rule: @typescript-eslint/no-inferrable-types
//
// Reports `const x: T = init` declarations where TS would infer
// exactly `T` from `init`, making the annotation redundant.  We
// match the upstream rule's literal-shape inference for the common
// types (bigint, boolean, number, string, null, undefined, symbol)
// and a few canonical builder calls (`BigInt(...)`, `Boolean(...)`,
// etc.).
//
// Options:
//   - ignoreParameters: skip function parameter declarations
//   - ignoreProperties: skip class properties

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-inferrable-types",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow explicit type declarations for variables or parameters initialized to a number, string, or boolean",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .declarator,
    .property_def, .computed_property_def,
    .assignment_pattern,
};

const PrimType = enum { bigint, boolean, number, string, null, undefined, symbol, regexp };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .declarator => checkDeclarator(node, ctx),
        .property_def, .computed_property_def => checkProperty(node, ctx),
        .assignment_pattern => checkParameter(node, ctx),
        else => {},
    }
}

fn checkParameter(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.getOptionBool("ignoreParameters", true)) return;
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;
    if (ctx.nodeTag(binding) != .identifier) return;
    const bd = ctx.nodeData(binding);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return;
    const ann = bd.rhs;
    const ty = ctx.nodeData(ann).lhs;
    if (ty == .none) return;
    const declared = primFromTypeRef(ty, ctx) orelse return;
    const init_kind = primFromInit(init, ctx) orelse return;
    if (declared != init_kind) return;
    reportSpan(binding, ann, init, ctx);
}

fn checkDeclarator(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const binding = data.lhs;
    const init = data.rhs;
    if (binding == .none or init == .none) return;
    if (ctx.nodeTag(binding) != .identifier) return;
    const bd = ctx.nodeData(binding);
    if (bd.rhs == .none or ctx.nodeTag(bd.rhs) != .ts_type_annotation) return;
    const ann = bd.rhs;
    const ty = ctx.nodeData(ann).lhs;
    if (ty == .none) return;
    const declared = primFromTypeRef(ty, ctx) orelse return;
    const init_kind = primFromInit(init, ctx) orelse return;
    if (declared != init_kind) return;
    reportSpan(binding, ann, init, ctx);
}

fn checkProperty(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.getOptionBool("ignoreProperties", false)) return;
    const data = ctx.nodeData(node);
    const key = data.lhs;
    if (data.rhs == .none) return;
    const pd = ctx.extraData(ast.PropertyData, @intFromEnum(data.rhs));
    if (pd.value == .none or pd.type_annotation == .none) return;
    if (pd.optional != 0) return; // `a?: T = init` annotation isn't redundant
    // Skip readonly/declare/abstract — modifiers change the meaning.
    if (key != .none) {
        if (hasModifierKeyword(key, "readonly", ctx)) return;
        if (hasModifierKeyword(key, "declare", ctx)) return;
        if (hasModifierKeyword(key, "abstract", ctx)) return;
    }
    const ty = ctx.nodeData(pd.type_annotation).lhs;
    if (ty == .none) return;
    const declared = primFromTypeRef(ty, ctx) orelse return;
    const init_kind = primFromInit(pd.value, ctx) orelse return;
    if (declared != init_kind) return;
    reportSpanIncludeSemi(key, pd.type_annotation, pd.value, ctx);
}

fn hasModifierKeyword(key: NodeIndex, kw: []const u8, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(key);
    if (tok == 0) return false;
    var i: u32 = tok;
    var steps: u32 = 0;
    while (steps < 6 and i > 0) : (steps += 1) {
        i -= 1;
        const start = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (start + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[start .. start + len];
        if (std.mem.eql(u8, text, kw)) return true;
        if (text.len == 1 and (text[0] == '{' or text[0] == '}' or text[0] == ';')) break;
    }
    return false;
}

fn primFromTypeRef(ty: NodeIndex, ctx: *const LintContext) ?PrimType {
    var n = ty;
    if (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) != .ts_type_reference) return null;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    if (std.mem.eql(u8, name, "bigint")) return .bigint;
    if (std.mem.eql(u8, name, "boolean")) return .boolean;
    if (std.mem.eql(u8, name, "number")) return .number;
    if (std.mem.eql(u8, name, "string")) return .string;
    if (std.mem.eql(u8, name, "null")) return .null;
    if (std.mem.eql(u8, name, "undefined")) return .undefined;
    if (std.mem.eql(u8, name, "symbol")) return .symbol;
    if (std.mem.eql(u8, name, "RegExp")) return .regexp;
    return null;
}

fn primFromInit(init: NodeIndex, ctx: *const LintContext) ?PrimType {
    var n = init;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    return switch (tag) {
        .bigint_literal => .bigint,
        .boolean_literal => .boolean,
        .number_literal => .number,
        .string_literal, .template_literal => .string,
        .null_literal => .null,
        .regex_literal => .regexp,
        .new_expr => callPrim(n, ctx),
        // `undefined` identifier OR `void <expr>`.
        .identifier => blk: {
            const name = ctx.tokenText(ctx.nodeMainToken(n));
            if (std.mem.eql(u8, name, "undefined")) break :blk .undefined;
            if (std.mem.eql(u8, name, "Infinity")) break :blk .number;
            if (std.mem.eql(u8, name, "NaN")) break :blk .number;
            break :blk null;
        },
        .void_expr => .undefined,
        // -<lit>, +<lit>, !<expr>.
        .unary_minus, .unary_plus => primFromInit(ctx.nodeData(n).lhs, ctx),
        .logical_not => .boolean,
        .typeof_expr => .string,
        // BigInt(...), Boolean(...), Number(...), String(...), Symbol(...)
        // — call to global constructor (no `new`).
        .call_expr, .optional_call_expr => callPrim(n, ctx),
        // new RegExp / new Date / etc. — most won't match; only the
        // `new Number(...)` / `new String(...)` patterns map to object
        // wrappers which the rule does NOT recommend stripping for,
        // so skip.
        else => null,
    };
}

fn callPrim(call: NodeIndex, ctx: *const LintContext) ?PrimType {
    var callee = ctx.nodeData(call).lhs;
    while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
    const tag = ctx.nodeTag(callee);
    var name: []const u8 = "";
    if (tag == .identifier) {
        name = ctx.tokenText(ctx.nodeMainToken(callee));
    } else if (tag == .member_expr) {
        // `Number.NaN` etc — treated as identifier-with-property.
        const data = ctx.nodeData(callee);
        if (data.lhs == .none or ctx.nodeTag(data.lhs) != .identifier) return null;
        name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
    } else if (tag == .ts_non_null_expr) {
        var inner = ctx.nodeData(callee).lhs;
        while (ctx.nodeTag(inner) == .grouping_expr) inner = ctx.nodeData(inner).lhs;
        if (ctx.nodeTag(inner) != .identifier) return null;
        name = ctx.tokenText(ctx.nodeMainToken(inner));
    } else return null;
    if (std.mem.eql(u8, name, "BigInt")) return .bigint;
    if (std.mem.eql(u8, name, "Boolean")) return .boolean;
    if (std.mem.eql(u8, name, "Number")) return .number;
    if (std.mem.eql(u8, name, "String")) return .string;
    if (std.mem.eql(u8, name, "Symbol")) return .symbol;
    if (std.mem.eql(u8, name, "RegExp")) return .regexp;
    return null;
}

fn reportSpan(binding: NodeIndex, ann: NodeIndex, init: NodeIndex, ctx: *const LintContext) void {
    const bsp = ctx.nodeSpan(binding);
    const asp = ctx.nodeSpan(ann);
    const isp = ctx.nodeSpan(init);
    const start: u32 = @intCast(bsp.start);
    var end: u32 = @intCast(@max(@max(asp.end, isp.end), bsp.end));
    end = extendThroughInit(end, ctx);
    ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, "noInferrableType");
}

/// Extend `end` forward through trailing tokens that belong to the
/// initializer (identifier characters, BigInt `n` suffix, closing
/// brackets, balanced parens for call-style inits).  Stops before
/// statement terminators / parameter delimiters.
fn extendThroughInit(start_end: u32, ctx: *const LintContext) u32 {
    var end = start_end;
    const src = ctx.ast.source;
    var paren_depth: i32 = 0;
    while (end < src.len) {
        const c = src[end];
        if (std.ascii.isAlphanumeric(c) or c == '_' or c == '$' or c == ']') {
            end += 1;
            continue;
        }
        if (c == '(') {
            paren_depth += 1;
            end += 1;
            continue;
        }
        if (c == ')') {
            if (paren_depth == 0) break;
            paren_depth -= 1;
            end += 1;
            continue;
        }
        break;
    }
    return end;
}

fn reportSpanIncludeSemi(binding: NodeIndex, ann: NodeIndex, init: NodeIndex, ctx: *const LintContext) void {
    const bsp = ctx.nodeSpan(binding);
    const asp = ctx.nodeSpan(ann);
    const isp = ctx.nodeSpan(init);
    var start: u32 = @intCast(bsp.start);
    // Walk back past leading modifier keywords (accessor, public,
    // static, …) so the span matches @typescript-eslint's range.
    start = walkBackThroughModifiers(start, binding, ctx);
    var end: u32 = @intCast(@max(@max(asp.end, isp.end), bsp.end));
    end = extendThroughInit(end, ctx);
    const src = ctx.ast.source;
    if (end < src.len and src[end] == ';') end += 1;
    ctx.reportSpanWithMessageId(.{ .start = start, .end = end }, "noInferrableType");
}

fn walkBackThroughModifiers(start: u32, binding: NodeIndex, ctx: *const LintContext) u32 {
    const tok = ctx.nodeMainToken(binding);
    if (tok == 0) return start;
    var i: u32 = tok;
    var earliest: u32 = start;
    var steps: u32 = 0;
    while (steps < 8 and i > 0) : (steps += 1) {
        i -= 1;
        const s = ctx.ast.tokenStart(i);
        const len = ctx.ast.tokens.items(.len)[i];
        if (s + len > ctx.ast.source.len) break;
        const text = ctx.ast.source[s .. s + len];
        if (isClassMemberModifier(text)) {
            earliest = @intCast(s);
            continue;
        }
        break;
    }
    return earliest;
}

fn isClassMemberModifier(text: []const u8) bool {
    const mods = [_][]const u8{
        "accessor", "public", "private", "protected",
        "static", "readonly", "abstract", "override", "declare",
    };
    for (mods) |m| if (std.mem.eql(u8, text, m)) return true;
    return false;
}
