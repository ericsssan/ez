// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-unnecessary-type-arguments
//
// Reports type arguments on a generic use site that match the
// declaration's default for that type parameter.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const TokenIndex = ast.TokenIndex;
const Node = ast.Node;
const Span = parser.span.Span;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-type-arguments",
    .category = .style,
    .default_severity = .@"error",
    .description = "Disallow type arguments that are equal to the default",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_type_reference,
    .ts_instantiation_expr,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .ts_type_reference => checkTypeRef(node, ctx),
        .ts_instantiation_expr => checkInstantiation(node, ctx),
        else => {},
    }
}

/// `T<X, Y>` in type position: type args are stored in data.rhs as a
/// SubRange of NodeIndex.
fn checkTypeRef(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const args_range = subrangeFromNode(data.rhs, ctx) orelse return;
    const args = ctx.ast.extra_data[args_range.start..args_range.end];
    if (args.len == 0) return;
    const main_tok = ctx.nodeMainToken(node);
    const name = ctx.tokenText(main_tok);
    const ctx_kind = useContext(node, ctx);
    const defaults = findDeclTypeParamDefaultsForContext(name, ctx_kind, ctx) orelse return;
    reportTrailingDefaults(args, defaults, ctx);
}

const UseContext = enum {
    type_only,    // type annotation, implements, extends-interface, type alias body
    value_only,   // extends-class, new, function call
    any_context,  // not determinable
};

/// Determine the use-site context for a ts_type_reference by source-
/// scanning the preceding keyword.
fn useContext(node: NodeIndex, ctx: *const LintContext) UseContext {
    const sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    // Walk backward over whitespace and other type references / commas
    // (for multi-impls/extends lists) until we find `implements` or
    // `extends`.  Stop at delimiters that bound the clause.
    var i: usize = sp.start;
    while (i > 0) {
        i -= 1;
        const c = src[i];
        // Stop at `{`, `}`, `;`, `=` — these bound the clause.
        if (c == '{' or c == '}' or c == ';' or c == '=' or c == '(' or c == ')') break;
        if (c == 'i' and matchKeywordAt(src, i, "implements")) return .type_only;
        if (c == 'e' and matchKeywordAt(src, i, "extends")) {
            // extends on a class is value_only, on an interface is type_only.
            return extendsContext(i, src);
        }
    }
    return .any_context;
}

fn matchKeywordAt(src: []const u8, pos: usize, kw: []const u8) bool {
    if (pos + kw.len > src.len) return false;
    if (!std.mem.eql(u8, src[pos .. pos + kw.len], kw)) return false;
    // Word boundary on left.
    if (pos > 0) {
        const p = src[pos - 1];
        if (isIdentChar(p)) return false;
    }
    // Word boundary on right.
    if (pos + kw.len < src.len) {
        const n = src[pos + kw.len];
        if (isIdentChar(n)) return false;
    }
    return true;
}

/// `extends` keyword detected at offset `pos`.  Walk back to find
/// whether this is `class X extends ...` or `interface X extends ...`.
fn extendsContext(pos: usize, src: []const u8) UseContext {
    var j: usize = pos;
    while (j > 0) {
        j -= 1;
        const c = src[j];
        if (c == '{' or c == '}' or c == ';') break;
        if (c == 'c' and matchKeywordAt(src, j, "class")) return .value_only;
        if (c == 'i' and matchKeywordAt(src, j, "interface")) return .type_only;
    }
    return .any_context;
}

fn findDeclTypeParamDefaultsForContext(
    name: []const u8,
    use_ctx: UseContext,
    ctx: *const LintContext,
) ?[]const TypeParamDefault {
    // For type_only contexts, only consider type declarations (interface,
    // type alias).  For value_only, only class/function declarations.
    return findDeclWithFilter(name, use_ctx, ctx);
}

/// `f<X, Y>` value position: parser wraps as ts_instantiation_expr.
/// data.lhs = callee, data.rhs = extra index to SubRange of type args.
fn checkInstantiation(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const args_range = subrangeFromNode(data.rhs, ctx) orelse return;
    const args = ctx.ast.extra_data[args_range.start..args_range.end];
    if (args.len == 0) return;
    // Resolve callee identifier — unwrap new_expr / grouping wrappers
    // (the parser puts `new X<T>()` together as CallExpr(InstExpr(NewExpr(X)))).
    var callee = data.lhs;
    while (true) {
        const t = ctx.nodeTag(callee);
        if (t == .grouping_expr) { callee = ctx.nodeData(callee).lhs; continue; }
        if (t == .new_expr) { callee = ctx.nodeData(callee).lhs; continue; }
        break;
    }
    if (ctx.nodeTag(callee) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(callee));
    // For instantiation expressions, we're in a value context.
    const ctx_kind: UseContext = .value_only;
    const defaults = findDeclTypeParamDefaultsForContext(name, ctx_kind, ctx) orelse return;
    reportTrailingDefaults(args, defaults, ctx);
}

/// Subrange node points to an extra index storing SubRange.start..end.
fn subrangeFromNode(idx: NodeIndex, ctx: *const LintContext) ?ast.SubRange {
    if (idx == .none) return null;
    const i = @intFromEnum(idx);
    if (i + 1 >= ctx.ast.extra_data.len) return null;
    return .{
        .start = ctx.ast.extra_data[i],
        .end = ctx.ast.extra_data[i + 1],
    };
}

/// Walk args from the right; for each trailing arg whose source text
/// matches the corresponding type-parameter's default text, report it.
fn reportTrailingDefaults(
    args: []const u32,
    defaults: []const TypeParamDefault,
    ctx: *const LintContext,
) void {
    // Walk from the rightmost (last) arg backward.  Stop at the first
    // mismatch — TSe only reports a trailing suffix that exactly
    // matches the defaults.
    var i: usize = args.len;
    while (i > 0) {
        i -= 1;
        if (i >= defaults.len) continue;
        const d = defaults[i];
        if (d.text.len == 0) break;
        const arg: NodeIndex = @enumFromInt(args[i]);
        const arg_sp = argSpan(arg, ctx);
        if (arg_sp.end > ctx.ast.source.len) break;
        const arg_text = ctx.ast.source[arg_sp.start..arg_sp.end];
        // If the arg is a bare identifier that's shadowed by a local
        // alias inside an enclosing module, skip (TSe treats them as
        // different types).
        if (argShadowedInLocalScope(arg, arg_text, ctx)) break;
        if (!sameAfterAliasResolution(arg_text, d.text, ctx)) break;
        ctx.reportSpanWithMessageId(arg_sp, "unnecessaryTypeParameter");
    }
}

/// True if the arg's source position is inside a module body that
/// declares a local type alias with the same name (TSe treats the
/// shadowed reference as a different type).  Source-scan: walk
/// backward looking for `declare module` or `namespace` boundaries.
fn argShadowedInLocalScope(arg: NodeIndex, arg_text: []const u8, ctx: *const LintContext) bool {
    const trimmed = std.mem.trim(u8, arg_text, " \t\n");
    if (trimmed.len == 0) return false;
    for (trimmed) |c| if (!isIdentChar(c)) return false;
    const arg_span = ctx.nodeSpan(arg);
    const src = ctx.ast.source;
    // Walk backward from arg position counting `{` depth until we
    // find `module` or `namespace`.  If we exit via `}` at depth 0,
    // there's no enclosing module.
    var i: usize = arg_span.start;
    var depth: i32 = 0;
    while (i > 0) {
        i -= 1;
        const c = src[i];
        if (c == '}') depth += 1;
        if (c == '{') {
            if (depth == 0) {
                // Found an unclosed `{` — look back for module/namespace keyword.
                if (precededByModuleKeyword(src, i)) {
                    // Inside a module/namespace body.  Check if a local
                    // `type NAME = ...` exists in this body.
                    if (hasLocalTypeAliasInScope(src, i, arg_span.start, trimmed)) return true;
                }
                return false;
            }
            depth -= 1;
        }
    }
    return false;
}

fn precededByModuleKeyword(src: []const u8, brace_pos: usize) bool {
    // Walk backward through whitespace, then over an identifier (module name),
    // possibly a string literal (`'name'`), and look for `module` or `namespace`.
    var i: usize = brace_pos;
    while (i > 0 and (src[i - 1] == ' ' or src[i - 1] == '\t' or src[i - 1] == '\n')) i -= 1;
    // Skip module name token(s) — identifier chars or `'...'` string.
    if (i > 0 and src[i - 1] == '\'') {
        // Skip string literal
        i -= 1;
        while (i > 0 and src[i - 1] != '\'') i -= 1;
        if (i > 0) i -= 1;
    } else {
        while (i > 0 and isIdentChar(src[i - 1])) i -= 1;
    }
    while (i > 0 and (src[i - 1] == ' ' or src[i - 1] == '\t' or src[i - 1] == '\n')) i -= 1;
    // Now check for "module" or "namespace".
    if (i >= 6 and std.mem.eql(u8, src[i - 6 .. i], "module")) return true;
    if (i >= 9 and std.mem.eql(u8, src[i - 9 .. i], "namespace")) return true;
    return false;
}

fn hasLocalTypeAliasInScope(src: []const u8, start_pos: usize, end_pos: u32, name: []const u8) bool {
    // Naive scan: look for `type NAME` between start_pos+1 and end_pos.
    var i: usize = start_pos + 1;
    while (i + 4 < end_pos and i + 4 < src.len) : (i += 1) {
        if (!std.mem.eql(u8, src[i .. i + 4], "type")) continue;
        // Word boundary before "type".
        if (i > 0 and isIdentChar(src[i - 1])) continue;
        var j: usize = i + 4;
        while (j < src.len and (src[j] == ' ' or src[j] == '\t')) j += 1;
        if (j + name.len > src.len) continue;
        if (!std.mem.eql(u8, src[j .. j + name.len], name)) continue;
        if (j + name.len < src.len and isIdentChar(src[j + name.len])) continue;
        return true;
    }
    return false;
}

fn moduleHasAlias(module_node: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // ts_module_decl / ts_namespace_decl: data.rhs = body block.
    const data = ctx.nodeData(module_node);
    if (data.rhs == .none) return false;
    const block = data.rhs;
    if (ctx.nodeTag(block) != .block_stmt) return false;
    const bd = ctx.nodeData(block);
    if (bd.lhs == .none or bd.rhs == .none) return false;
    const s = @intFromEnum(bd.lhs);
    const e = @intFromEnum(bd.rhs);
    if (s >= e or e > ctx.ast.extra_data.len) return false;
    // Walk through both immediate statements AND nested type-alias decls
    // (the parser may store them as ExpressionStatement / etc., or as
    // top-level statements with the alias as a child).
    for (ctx.ast.extra_data[s..e]) |raw| {
        const stmt: NodeIndex = @enumFromInt(raw);
        const t = ctx.nodeTag(stmt);
        if (t == .ts_type_alias_decl) {
            const sd = ctx.nodeData(stmt);
            if (sd.lhs == .none) continue;
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(sd.lhs));
            if (std.mem.eql(u8, ctx.tokenText(ad.name), name)) return true;
        }
    }
    return false;
}

/// True when two type-expression source texts are equivalent, possibly
/// after recursively resolving alias chains on either side.
fn sameAfterAliasResolution(a_in: []const u8, b_in: []const u8, ctx: *const LintContext) bool {
    const ra = resolveAliasChain(a_in, ctx);
    const rb = resolveAliasChain(b_in, ctx);
    return textEqualsIgnoringSpaces(ra, rb);
}

/// Recursively resolve `type X = ...` aliases (up to 10 levels) until
/// the text is no longer a bare identifier with an alias body.
fn resolveAliasChain(text: []const u8, ctx: *const LintContext) []const u8 {
    var cur = text;
    var depth: u32 = 0;
    while (depth < 10) : (depth += 1) {
        const next = resolveAliasText(cur, ctx) orelse break;
        if (std.mem.eql(u8, next, cur)) break;
        cur = next;
    }
    return cur;
}

/// If `text` is a bare identifier matching a type alias `type X = ...`,
/// return the alias body's source text.  Otherwise null.
fn resolveAliasText(text: []const u8, ctx: *const LintContext) ?[]const u8 {
    const trimmed = std.mem.trim(u8, text, " \t\n");
    if (trimmed.len == 0) return null;
    for (trimmed) |c| {
        if (!isIdentChar(c)) return null;
    }
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .ts_type_alias_decl) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
        const name = ctx.tokenText(ad.name);
        if (!std.mem.eql(u8, name, trimmed)) continue;
        const sp = argSpan(ad.type_node, ctx);
        if (sp.end > ctx.ast.source.len) return null;
        return ctx.ast.source[sp.start..sp.end];
    }
    return null;
}

fn isIdentChar(c: u8) bool {
    return (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
        (c >= '0' and c <= '9') or c == '_' or c == '$';
}

/// Span for a type argument; for `Foo<T>` arguments, extend through
/// unbalanced trailing `>` characters (parser omits them from nodeSpan).
fn argSpan(node: NodeIndex, ctx: *const LintContext) Span {
    var sp = ctx.nodeSpan(node);
    const src = ctx.ast.source;
    // Count `<` vs `>` within current span.  If positive, walk forward.
    var depth: i32 = 0;
    var i: usize = sp.start;
    while (i < sp.end and i < src.len) : (i += 1) {
        if (src[i] == '<') depth += 1;
        if (src[i] == '>') depth -= 1;
    }
    var j: usize = sp.end;
    while (j < src.len and depth > 0) : (j += 1) {
        if (src[j] == '<') depth += 1;
        if (src[j] == '>') depth -= 1;
    }
    sp.end = @intCast(j);
    return sp;
}

fn textEqualsIgnoringSpaces(a: []const u8, b: []const u8) bool {
    var i: usize = 0;
    var j: usize = 0;
    while (i < a.len or j < b.len) {
        // Skip whitespace in either.
        while (i < a.len and (a[i] == ' ' or a[i] == '\t' or a[i] == '\n')) i += 1;
        while (j < b.len and (b[j] == ' ' or b[j] == '\t' or b[j] == '\n')) j += 1;
        if (i == a.len and j == b.len) return true;
        if (i == a.len or j == b.len) return false;
        if (a[i] != b[j]) return false;
        i += 1;
        j += 1;
    }
    return true;
}

const TypeParamDefault = struct {
    /// Source text of the default type, or empty string if no default.
    text: []const u8,
};

fn findDeclTypeParamDefaults(name: []const u8, ctx: *const LintContext) ?[]const TypeParamDefault {
    return findDeclWithFilter(name, .any_context, ctx);
}

fn declAcceptsContext(t: Node.Tag, use_ctx: UseContext) bool {
    return switch (use_ctx) {
        .any_context => true,
        .type_only => switch (t) {
            .ts_interface_decl, .ts_type_alias_decl => true,
            else => false,
        },
        .value_only => switch (t) {
            .class_decl, .class_expr,
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .ts_declare_function => true,
            else => false,
        },
    };
}

/// Find type-parameter defaults for a declaration by name.  Scans all
/// nodes for matching fn/class/interface/type-alias decls.  When
/// multiple declarations exist (decl merging), a slot has a default
/// only if every declaration provides one; otherwise it's empty.
fn findDeclWithFilter(name: []const u8, use_ctx: UseContext, ctx: *const LintContext) ?[]const TypeParamDefault {
    // if (use_ctx == .any_context and nameHasNonTypeValueDecl(name, ctx)) return null;
    if (use_ctx == .value_only) {
        if (constructSigDefaultsForName(name, ctx)) |defaults| return defaults;
    }
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var defaults_buf: [16]TypeParamDefault = undefined;
    var slot_disabled: [16]bool = [_]bool{false} ** 16;
    var defaults_len: usize = 0;
    var found_any = false;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        const t = ctx.nodeTag(ni);
        if (!declAcceptsContext(t, use_ctx)) continue;
        const params_start_end = paramRangeFor(ni, t, ctx) orelse continue;
        const decl_name = nameOfDecl(ni, t, ctx);
        if (!std.mem.eql(u8, decl_name, name)) continue;
        const tp = ctx.ast.extra_data[params_start_end.start..params_start_end.end];
        const n = @min(tp.len, defaults_buf.len);
        if (!found_any) {
            defaults_len = n;
            var k: usize = 0;
            while (k < defaults_len) : (k += 1) defaults_buf[k] = .{ .text = &.{} };
            found_any = true;
        } else if (n != defaults_len) {
            return null;
        }
        var k: usize = 0;
        while (k < n) : (k += 1) {
            if (slot_disabled[k]) continue;
            const tp_node: NodeIndex = @enumFromInt(tp[k]);
            const td = ctx.nodeData(tp_node);
            const default_node = td.rhs;
            if (default_node == .none) {
                slot_disabled[k] = true;
                defaults_buf[k] = .{ .text = &.{} };
            } else if (defaults_buf[k].text.len == 0) {
                const sp = argSpan(default_node, ctx);
                if (sp.end > ctx.ast.source.len) continue;
                defaults_buf[k] = .{ .text = ctx.ast.source[sp.start..sp.end] };
            }
        }
    }
    if (!found_any) return null;
    return defaults_buf[0..defaults_len];
}

/// For a value declaration `declare var X: { new <T = ...>(...): any };`
/// return the type-param defaults of its first construct signature.
fn constructSigDefaultsForName(name: []const u8, ctx: *const LintContext) ?[]const TypeParamDefault {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var defaults_buf: [16]TypeParamDefault = undefined;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none) continue;
        if (ctx.nodeTag(d.lhs) != .identifier) continue;
        if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) continue;
        const ann = ctx.nodeData(d.lhs).rhs;
        if (ann == .none) continue;
        if (ctx.nodeTag(ann) != .ts_type_annotation) continue;
        var inner = ctx.nodeData(ann).lhs;
        if (inner == .none) continue;
        while (ctx.nodeTag(inner) == .ts_parenthesized_type) {
            inner = ctx.nodeData(inner).lhs;
            if (inner == .none) break;
        }
        if (inner == .none) continue;
        if (ctx.nodeTag(inner) != .ts_type_literal) continue;
        const ld = ctx.nodeData(inner);
        const s = @intFromEnum(ld.lhs);
        const e = @intFromEnum(ld.rhs);
        if (s >= e or e > ctx.ast.extra_data.len) continue;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(m) != .ts_construct_signature) continue;
            const sigd = ctx.nodeData(m);
            if (sigd.lhs == .none) continue;
            const sig_idx = @intFromEnum(sigd.lhs);
            // InterfaceSigData has 8 u32-sized fields.  Check bounds.
            if (sig_idx + 7 >= ctx.ast.extra_data.len) continue;
            const isd = ctx.extraData(ast.InterfaceSigData, sig_idx);
            if (isd.type_params >= isd.type_params_end) continue;
            if (isd.type_params_end > ctx.ast.extra_data.len) continue;
            const tp = ctx.ast.extra_data[isd.type_params..isd.type_params_end];
            const n = @min(tp.len, defaults_buf.len);
            var k: usize = 0;
            while (k < n) : (k += 1) {
                const tp_node: NodeIndex = @enumFromInt(tp[k]);
                if (ctx.nodeTag(tp_node) != .ts_type_parameter) {
                    defaults_buf[k] = .{ .text = &.{} };
                    continue;
                }
                const td = ctx.nodeData(tp_node);
                if (td.rhs == .none) {
                    defaults_buf[k] = .{ .text = &.{} };
                } else {
                    const sp = argSpan(td.rhs, ctx);
                    if (sp.end > ctx.ast.source.len) defaults_buf[k] = .{ .text = &.{} }
                    else defaults_buf[k] = .{ .text = ctx.ast.source[sp.start..sp.end] };
                }
            }
            return defaults_buf[0..n];
        }
    }
    return null;
}

/// True if any var/let/const/declarator declares a value with this name.
fn nameHasNonTypeValueDecl(name: []const u8, ctx: *const LintContext) bool {
    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ctx.nodeTag(ni) != .declarator) continue;
        const d = ctx.nodeData(ni);
        if (d.lhs == .none or ctx.nodeTag(d.lhs) != .identifier) continue;
        if (std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(d.lhs)), name)) return true;
    }
    return false;
}

fn paramRangeFor(ni: NodeIndex, t: Node.Tag, ctx: *const LintContext) ?struct { start: u32, end: u32 } {
    const data = ctx.nodeData(ni);
    return switch (t) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function => blk: {
            if (data.lhs == .none) break :blk null;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.type_params == fd.type_params_end) break :blk null;
            break :blk .{ .start = fd.type_params, .end = fd.type_params_end };
        },
        .class_decl, .class_expr => blk: {
            if (data.lhs == .none) break :blk null;
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
            if (cd.type_params == cd.type_params_end) break :blk null;
            break :blk .{ .start = cd.type_params, .end = cd.type_params_end };
        },
        .ts_interface_decl => blk: {
            if (data.lhs == .none) break :blk null;
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            if (id.type_params == id.type_params_end) break :blk null;
            break :blk .{ .start = id.type_params, .end = id.type_params_end };
        },
        .ts_type_alias_decl => blk: {
            if (data.lhs == .none) break :blk null;
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
            if (ad.type_params == ad.type_params_end) break :blk null;
            break :blk .{ .start = ad.type_params, .end = ad.type_params_end };
        },
        else => null,
    };
}

fn nameOfDecl(ni: NodeIndex, t: Node.Tag, ctx: *const LintContext) []const u8 {
    const data = ctx.nodeData(ni);
    switch (t) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function => {
            if (data.lhs == .none) return &.{};
            const fd = ctx.extraData(ast.FnData, @intFromEnum(data.lhs));
            if (fd.name == .none) return &.{};
            return ctx.tokenText(ctx.nodeMainToken(fd.name));
        },
        .class_decl, .class_expr => {
            if (data.lhs == .none) return &.{};
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(data.lhs));
            if (cd.name == .none) return &.{};
            return ctx.tokenText(ctx.nodeMainToken(cd.name));
        },
        .ts_interface_decl => {
            if (data.lhs == .none) return &.{};
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            return ctx.tokenText(id.name);
        },
        .ts_type_alias_decl => {
            if (data.lhs == .none) return &.{};
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
            return ctx.tokenText(ad.name);
        },
        else => return &.{},
    }
}
