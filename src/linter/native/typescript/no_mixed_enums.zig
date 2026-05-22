// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/no-mixed-enums
//
// Reports an enum that mixes string and number-valued members.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");

pub const meta = RuleMeta{
    .name = "no-mixed-enums",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow enums from having both number and string members",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_enum_decl};

const Kind = enum { unknown, number, string };

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(data.lhs));
    if (ed.members_start >= ed.members_end or ed.members_end > ctx.ast.extra_data.len) return;
    const enum_name = ctx.tokenText(ed.name);
    // Cross-declaration merging only applies if (a) the enum is at the
    // top level or (b) every enclosing namespace is exported (or itself
    // top-level).  Otherwise each declaration stands alone.
    var established: Kind = .unknown;
    if (declMergesCrossDecls(node, ctx)) {
        established = enumDeclaredKind(enum_name, ctx);
    }
    if (established == .unknown) {
        // Walk this enum's members from start; first concrete kind becomes
        // the established one.
        for (ctx.ast.extra_data[ed.members_start..ed.members_end]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (ctx.nodeTag(m) != .ts_enum_member) continue;
            const init = ctx.nodeData(m).rhs;
            const k = inferKind(init, ctx);
            if (k != .unknown) {
                established = k;
                break;
            }
        }
        if (established == .unknown) return;
    }
    // Walk THIS enum's members; report only the FIRST mismatching one
    // (TSe reports a single diag per enum declaration).
    for (ctx.ast.extra_data[ed.members_start..ed.members_end]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const md = ctx.nodeData(m);
        const init = md.rhs;
        const k = inferKind(init, ctx);
        if (k == .unknown) continue;
        if (k == established) continue;
        const target = if (init == .none) m else init;
        ctx.reportWithMessageId(target, "mixed");
        return;
    }
}

/// Look up the enum's overall kind across all declarations sharing this name.
fn enumDeclaredKind(name: []const u8, ctx: *const LintContext) Kind {
    if (ctx.enumKindOf(name)) |k| {
        return switch (k) {
            .number => .number,
            .string => .string,
        };
    }
    return .unknown;
}

fn isInsideNamespace(node: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none) {
        const t = ctx.nodeTag(p);
        if (t == .ts_namespace_decl or t == .ts_module_decl) return true;
        p = ctx.parentOf(p);
    }
    return false;
}

/// True when this enum's declaration merges across other declarations
/// with the same name in scope.  TS namespace-merge rules:
///   - top-level namespaces always merge across blocks
///   - nested namespaces only merge when exported
/// So the enum's chain of enclosing namespaces must all be either
/// top-level OR exported.
fn declMergesCrossDecls(node: NodeIndex, ctx: *const LintContext) bool {
    var p = ctx.parentOf(node);
    while (p != .none) {
        const t = ctx.nodeTag(p);
        if (t == .ts_namespace_decl or t == .ts_module_decl) {
            // Determine if this namespace is at top level or inside another.
            var anc = ctx.parentOf(p);
            while (anc != .none) {
                const at = ctx.nodeTag(anc);
                if (at == .ts_namespace_decl or at == .ts_module_decl) break;
                anc = ctx.parentOf(anc);
            }
            const is_top_level = anc == .none;
            if (!is_top_level and !declIsExported(p, ctx)) return false;
        }
        p = ctx.parentOf(p);
    }
    return true;
}

fn declIsExported(decl: NodeIndex, ctx: *const LintContext) bool {
    const sp = ctx.nodeSpan(decl);
    if (sp.start < 7) return false;
    const src = ctx.ast.source;
    // Walk backward over whitespace to look for `export` keyword.
    var i: usize = sp.start;
    while (i > 0 and (src[i - 1] == ' ' or src[i - 1] == '\t' or src[i - 1] == '\n')) i -= 1;
    if (i >= 6 and std.mem.eql(u8, src[i - 6 .. i], "export")) return true;
    return false;
}

fn inferKind(init: NodeIndex, ctx: *const LintContext) Kind {
    if (init == .none) return .number; // auto-increment is numeric
    var n = init;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    if (tag == .number_literal or tag == .bigint_literal) return .number;
    if (tag == .string_literal) return .string;
    if (tag == .template_literal) {
        const sp = ctx.nodeSpan(n);
        if (sp.end > sp.start) {
            const raw = ctx.ast.source[sp.start..sp.end];
            if (std.mem.indexOf(u8, raw, "${") != null) return .unknown;
        }
        return .string;
    }
    if (tag == .unary_minus or tag == .unary_plus) {
        return inferKind(ctx.nodeData(n).lhs, ctx);
    }
    // Member-access like `First.A` — look up via enum tracking.
    if (tag == .member_expr or tag == .optional_member_expr) {
        const md = ctx.nodeData(n);
        if (md.lhs != .none and ctx.nodeTag(md.lhs) == .identifier) {
            const obj_name = ctx.tokenText(ctx.nodeMainToken(md.lhs));
            if (ctx.enumKindOf(obj_name)) |k| {
                return switch (k) {
                    .number => .number,
                    .string => .string,
                };
            }
        }
    }
    // Defer to type checker for everything else (call, identifier ref, etc.).
    if (ctx.hasTypeChecker()) {
        const ty = ctx.typeOfNode(n);
        return kindFromType(ty, ctx);
    }
    return .unknown;
}

fn kindFromType(id: tymod.TypeId, ctx: *const LintContext) Kind {
    if (ctx.typeIdIsStringy(id)) return .string;
    if (ctx.typeIdIsNumberLike(id)) return .number;
    return .unknown;
}
