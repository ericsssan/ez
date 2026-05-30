// HAND-WRITTEN.
// Rule: @typescript-eslint/prefer-literal-enum-member
//
// Reports enum members whose initializer is not a literal expression.
// "Literal" here means: string / number / boolean / null / bigint /
// template-literal-without-substitution / `-numericLiteral`.  Bitwise
// expressions over literals are accepted as a configurable extension,
// matching upstream's `allowBitwiseExpressions` option.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "prefer-literal-enum-member",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Require all enum members to be literal values",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_member};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const init = ctx.nodeData(node).rhs;
    if (init == .none) return;
    const allow_bitwise = ctx.getOptionBool("allowBitwiseExpressions", false);
    // Build a set of sibling member names so we can recognize
    // `Foo.A` / direct `A` references to peer enum members.
    var sibling_buf: [64][]const u8 = undefined;
    var sibling_len: usize = 0;
    var enum_name: []const u8 = "";
    if (resolveEnumContext(node, &sibling_buf, &sibling_len, &enum_name, ctx)) {
        // computed
    }
    const ctx_data: SiblingCtx = .{ .names = sibling_buf[0..sibling_len], .enum_name = enum_name };
    if (isLiteralEnumValue(init, allow_bitwise, ctx_data, ctx)) return;
    // Report on the member's KEY node (1-char span when the key is an
    // identifier) — TSe reports there, not on the initializer.
    const key = ctx.nodeData(node).lhs;
    const target: NodeIndex = if (key == .none) node else key;
    const message_id: []const u8 = if (allow_bitwise)
        "notLiteralOrBitwiseExpression"
    else
        "notLiteral";
    ctx.reportWithMessageId(target, message_id);
}

const SiblingCtx = struct {
    names: []const []const u8,
    enum_name: []const u8,
};

fn resolveEnumContext(
    member: NodeIndex,
    buf: *[64][]const u8,
    out_len: *usize,
    out_enum_name: *[]const u8,
    ctx: *const LintContext,
) bool {
    out_len.* = 0;
    var p = ctx.parentOf(member);
    while (p != .none) : (p = ctx.parentOf(p)) {
        if (ctx.nodeTag(p) == .ts_enum_decl) break;
    }
    if (p == .none) return false;
    const data = ctx.nodeData(p);
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));
    out_enum_name.* = ctx.tokenText(ed.name);
    if (ed.members_start >= ed.members_end or ed.members_end > ctx.ast.extra_data.len) return true;
    var n: usize = 0;
    for (ctx.ast.extra_data[ed.members_start..ed.members_end]) |raw| {
        if (n >= buf.len) break;
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const key = ctx.nodeData(m).lhs;
        if (key == .none) continue;
        const name = memberKeyText(key, ctx) orelse continue;
        buf[n] = name;
        n += 1;
    }
    out_len.* = n;
    return true;
}

fn memberKeyText(key: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const tag = ctx.nodeTag(key);
    if (tag == .identifier or tag == .property_ident or tag == .property_literal) {
        return ctx.tokenText(ctx.nodeMainToken(key));
    }
    if (tag == .string_literal) {
        const sp = ctx.nodeSpan(key);
        if (sp.end <= sp.start + 2) return null;
        const raw = ctx.ast.source[sp.start..sp.end];
        if (raw.len < 2) return null;
        return raw[1 .. raw.len - 1];
    }
    return null;
}

fn isLiteralEnumValue(node: NodeIndex, allow_bitwise: bool, sib: SiblingCtx, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    return switch (tag) {
        .string_literal,
        .number_literal,
        .bigint_literal,
        .boolean_literal,
        .null_literal,
        .regex_literal,
        => true,
        // Template literal without substitution.
        .template_literal => blk: {
            const sp = ctx.nodeSpan(n);
            if (sp.end <= sp.start + 2) break :blk false;
            const raw = ctx.ast.source[sp.start..sp.end];
            break :blk std.mem.indexOf(u8, raw, "${") == null;
        },
        // -<lit> / +<lit> — argument must be a pure literal.
        .unary_minus, .unary_plus => isPureLiteral(ctx.nodeData(n).lhs, ctx),
        // Bitwise expression — only with the option AND every operand
        // must be a literal or a sibling enum member reference.
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        => allow_bitwise
            and isBitwiseOperand(ctx.nodeData(n).lhs, sib, ctx)
            and isBitwiseOperand(ctx.nodeData(n).rhs, sib, ctx),
        .bitwise_not => allow_bitwise and isBitwiseOperand(ctx.nodeData(n).lhs, sib, ctx),
        else => false,
    };
}

fn isBitwiseOperand(node: NodeIndex, sib: SiblingCtx, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    return switch (tag) {
        .string_literal, .number_literal, .bigint_literal, .boolean_literal,
        .null_literal, .regex_literal,
        => true,
        .unary_minus, .unary_plus => isPureLiteralOrSibling(ctx.nodeData(n).lhs, sib, ctx),
        .identifier => identMatchesSibling(n, sib, ctx),
        .member_expr, .computed_member_expr => memberMatchesSibling(n, sib, ctx),
        // Nested bitwise ops are themselves valid operands.
        .bitwise_and, .bitwise_or, .bitwise_xor,
        .shift_left, .shift_right, .unsigned_shift_right,
        => isBitwiseOperand(ctx.nodeData(n).lhs, sib, ctx)
            and isBitwiseOperand(ctx.nodeData(n).rhs, sib, ctx),
        .bitwise_not => isBitwiseOperand(ctx.nodeData(n).lhs, sib, ctx),
        else => false,
    };
}

fn isPureLiteralOrSibling(node: NodeIndex, sib: SiblingCtx, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    return switch (tag) {
        .string_literal, .number_literal, .bigint_literal, .boolean_literal,
        .null_literal, .regex_literal,
        => true,
        .identifier => identMatchesSibling(n, sib, ctx),
        .member_expr, .computed_member_expr => memberMatchesSibling(n, sib, ctx),
        else => false,
    };
}

fn isPureLiteral(node: NodeIndex, ctx: *const LintContext) bool {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    return switch (ctx.nodeTag(n)) {
        .string_literal, .number_literal, .bigint_literal,
        .boolean_literal, .null_literal, .regex_literal,
        => true,
        else => false,
    };
}

fn identMatchesSibling(n: NodeIndex, sib: SiblingCtx, ctx: *const LintContext) bool {
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    if (name.len == 0) return false;
    for (sib.names) |s| if (std.mem.eql(u8, s, name)) return true;
    return false;
}

fn memberMatchesSibling(n: NodeIndex, sib: SiblingCtx, ctx: *const LintContext) bool {
    const data = ctx.nodeData(n);
    if (data.lhs == .none) return false;
    if (ctx.nodeTag(data.lhs) != .identifier) return false;
    const obj = ctx.tokenText(ctx.nodeMainToken(data.lhs));
    if (sib.enum_name.len == 0 or !std.mem.eql(u8, obj, sib.enum_name)) return false;
    const prop = if (ctx.nodeTag(n) == .member_expr)
        ctx.tokenText(ctx.nodeMainToken(n))
    else propFromComputed(data.rhs, ctx) orelse return false;
    for (sib.names) |s| if (std.mem.eql(u8, s, prop)) return true;
    return false;
}

fn propFromComputed(key: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (ctx.nodeTag(key) != .string_literal) return null;
    const sp = ctx.nodeSpan(key);
    if (sp.end <= sp.start + 2) return null;
    const raw = ctx.ast.source[sp.start..sp.end];
    if (raw.len < 2) return null;
    return raw[1 .. raw.len - 1];
}
