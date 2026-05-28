// HAND-WRITTEN.
// Rule: @typescript-eslint/adjacent-overload-signatures
//
// Require overloaded function/method signatures to be adjacent.
//
// Fires when a function or method has been seen earlier in the same
// body but a different member appears between two of its overloads.
//
// Checks: Program root, block statements (function/if/etc. bodies),
// class bodies, interface bodies, and type literals.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "adjacent-overload-signatures",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require that function overload signatures be consecutive",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .root,
    .block_stmt,
    .class_body,
    .ts_interface_decl,
    .ts_type_literal,
};

const MethodInfo = struct {
    name: []const u8,
    is_static: bool,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    switch (ctx.nodeTag(node)) {
        .root, .block_stmt => {
            const data = ctx.nodeData(node);
            const s: u32 = @intFromEnum(data.lhs);
            const e: u32 = @intFromEnum(data.rhs);
            checkBody(s, e, ctx);
        },
        .class_body, .ts_type_literal => {
            const data = ctx.nodeData(node);
            const s: u32 = @intFromEnum(data.lhs);
            const e: u32 = @intFromEnum(data.rhs);
            checkBody(s, e, ctx);
        },
        .ts_interface_decl => {
            const data = ctx.nodeData(node);
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            checkBody(id.body_start, id.body_end, ctx);
        },
        else => {},
    }
}

fn checkBody(s: u32, e: u32, ctx: *const LintContext) void {
    if (s >= e or e > ctx.ast.extra_data.len) return;

    var seen_buf: [64]MethodInfo = undefined;
    var seen_count: usize = 0;
    var has_last: bool = false;
    var last: MethodInfo = undefined;

    for (ctx.ast.extra_data[s..e]) |raw| {
        const member: NodeIndex = @enumFromInt(raw);
        const maybe_method = getMemberMethod(member, ctx);

        if (maybe_method == null) {
            has_last = false;
            continue;
        }
        const method = maybe_method.?;

        var found: bool = false;
        for (seen_buf[0..seen_count]) |seen| {
            if (isSameMethod(method, seen)) {
                found = true;
                break;
            }
        }

        if (found) {
            if (!has_last or !isSameMethod(method, last)) {
                ctx.reportSpanWithMessageId(memberSpan(member, ctx), "adjacentSignature");
            }
        } else {
            if (seen_count < seen_buf.len) {
                seen_buf[seen_count] = method;
                seen_count += 1;
            }
        }

        has_last = true;
        last = method;
    }
}

/// Returns a span covering the full member declaration.
/// - Extends the START backward to include modifier keywords (static, abstract,
///   override, declare, public, protected, private) that aren't tracked as
///   child nodes in node_min_toks.
/// - Extends the END forward by scanning with bracket depth tracking to find
///   the trailing `;` or `}` that terminates the declaration (fixes node_max_toks
///   single-pass propagation stopping at inner tokens like type annotations).
fn memberSpan(member: NodeIndex, ctx: *const LintContext) @TypeOf(ctx.nodeSpan(member)) {
    const sp = ctx.nodeSpan(member);
    const src = ctx.ast.source;

    // Walk backward from sp.start to include any preceding modifier keywords.
    const modifiers = [_][]const u8{ "static", "abstract", "override", "declare", "public", "protected", "private" };
    var start: usize = sp.start;
    outer: while (true) {
        var bp: usize = start;
        while (bp > 0 and (src[bp - 1] == ' ' or src[bp - 1] == '\t')) bp -= 1;
        for (modifiers) |kw| {
            const klen = kw.len;
            if (bp >= klen and std.mem.eql(u8, src[bp - klen .. bp], kw)) {
                if (bp == klen or !isIdentChar(src[bp - klen - 1])) {
                    start = bp - klen;
                    continue :outer;
                }
            }
        }
        break;
    }

    // Scan forward from sp.start (original) to find the trailing `;` or `}`.
    var depth: i32 = 0;
    var pos: usize = sp.start;
    while (pos < src.len) : (pos += 1) {
        switch (src[pos]) {
            '{', '(', '[' => depth += 1,
            ')', ']' => {
                if (depth > 0) depth -= 1;
            },
            '}' => {
                if (depth > 0) {
                    depth -= 1;
                    if (depth == 0) return .{ .start = @intCast(start), .end = @intCast(pos + 1) };
                }
            },
            ';' => {
                if (depth == 0) return .{ .start = @intCast(start), .end = @intCast(pos + 1) };
            },
            else => {},
        }
    }
    return .{ .start = @intCast(start), .end = sp.end };
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9') or c == '_' or c == '$';
}

fn isSameMethod(a: MethodInfo, b: MethodInfo) bool {
    return a.is_static == b.is_static and std.mem.eql(u8, a.name, b.name);
}

/// Returns the method identity for a member node, or null if the member
/// is not an overloadable function/method (property, getter, setter, etc.)
/// which resets the adjacency tracking.
fn getMemberMethod(member: NodeIndex, ctx: *const LintContext) ?MethodInfo {
    const tag = ctx.nodeTag(member);
    const data = ctx.nodeData(member);

    switch (tag) {
        // Function declarations (program/block scope)
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .ts_declare_function => {
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name == .none) return null;
            const name = ctx.tokenText(ctx.nodeMainToken(fd.name));
            return .{ .name = name, .is_static = false };
        },

        // export function / export declare function
        .export_named => {
            const inner = data.lhs;
            if (inner == .none) return null;
            const inner_tag = ctx.nodeTag(inner);
            switch (inner_tag) {
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .ts_declare_function => {
                    const fd = ctx.extraData(ast.FnData, @intFromEnum(ctx.nodeData(inner).lhs));
                    if (fd.name == .none) return null;
                    const name = ctx.tokenText(ctx.nodeMainToken(fd.name));
                    return .{ .name = name, .is_static = false };
                },
                else => return null,
            }
        },

        // Class method declarations
        .method_def => {
            const key = data.lhs;
            if (key == .none) return null;
            const name = getKeyName(key, ctx) orelse return null;
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            const is_static = (md.modifiers & ast.ModifierBit.@"static") != 0;
            return .{ .name = name, .is_static = is_static };
        },

        .constructor_def => {
            return .{ .name = "constructor", .is_static = false };
        },

        .computed_method_def => {
            // Only match when the computed key is a string literal (e.g. ['foo']())
            const key = data.lhs;
            if (key == .none) return null;
            if (ctx.nodeTag(key) != .string_literal) return null;
            const name = getKeyName(key, ctx) orelse return null;
            const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
            const is_static = (md.modifiers & ast.ModifierBit.@"static") != 0;
            return .{ .name = name, .is_static = is_static };
        },

        // Getters and setters are not overloadable
        .getter_def, .setter_def, .computed_getter_def, .computed_setter_def => return null,

        // Interface/type-literal members
        .ts_method_signature => {
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(data.lhs));
            if (sd.kind != 0) return null; // getter (1) or setter (2) — not overloadable
            if (sd.key == .none) return null;
            const name = getKeyName(sd.key, ctx) orelse return null;
            return .{ .name = name, .is_static = false };
        },

        .ts_call_signature => return .{ .name = "__call", .is_static = false },

        .ts_construct_signature => return .{ .name = "__new", .is_static = false },

        // Properties, index signatures, static blocks, etc. reset tracking
        else => return null,
    }
}

/// Extract a method name from a key node following TSe's naming rules:
///   - identifier/property_ident: strip leading '#' (private identifier → name without '#')
///   - string_literal: strip surrounding quotes
///   - anything else: null (computed non-string key → unknown, skip tracking)
fn getKeyName(key: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    if (key == .none) return null;
    const text = ctx.tokenText(ctx.nodeMainToken(key));
    switch (ctx.nodeTag(key)) {
        .identifier, .property_ident => {
            // Private identifier: strip '#' so that #foo → "foo"
            if (text.len > 0 and text[0] == '#') return text[1..];
            return text;
        },
        .string_literal => {
            // Strip surrounding quote characters: 'foo' → foo, "foo" → foo
            if (text.len >= 2) return text[1 .. text.len - 1];
            return text;
        },
        else => return null,
    }
}
