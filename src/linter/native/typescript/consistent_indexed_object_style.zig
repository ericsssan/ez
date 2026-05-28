// HAND-WRITTEN.
// Rule: @typescript-eslint/consistent-indexed-object-style
//
// Require or disallow the `Record` type.
//
// Mode "record" (default):
//   - If an interface or type literal has exactly ONE member which is an index
//     signature → prefer Record<K,V>  (messageId: preferRecord)
//   - Mapped types { [k in K]: V } that don't use the key in the value and
//     aren't circular also fire preferRecord.
//   - Circular types (the type name appears, directly or transitively, in the
//     value type through transparent type constructors) are exempt.
//
// Mode "index-signature":
//   - Record<K,V> type references (exactly 2 type args) → prefer index sig
//     (messageId: preferIndexSignature)

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "consistent-indexed-object-style",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow the `Record` type",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_interface_decl,
    .ts_type_literal,
    .ts_mapped_type,
    .ts_type_reference,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (ctx.optionEqualsString("index-signature")) {
        if (ctx.nodeTag(node) == .ts_type_reference) checkTypeRefForRecord(node, ctx);
        return;
    }
    switch (ctx.nodeTag(node)) {
        .ts_interface_decl => checkInterface(node, ctx),
        .ts_type_literal => checkTypeLiteral(node, ctx),
        .ts_mapped_type => checkMappedType(node, ctx),
        else => {},
    }
}

// ── "record" mode handlers ─────────────────────────────────────────────────

fn checkInterface(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
    if (!isSingleIndexSig(id.body_start, id.body_end, ctx)) return;
    const value_type = indexSigValueType(id.body_start, ctx);
    if (value_type == .none) return;
    const name = ctx.tokenText(id.name);
    var visited = VisitedSet.init();
    if (!isDeeplyReferencing(ctx, value_type, name, &visited)) {
        ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "preferRecord");
    }
}

fn checkTypeLiteral(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const body_start = @intFromEnum(data.lhs);
    const body_end = @intFromEnum(data.rhs);
    if (!isSingleIndexSig(body_start, body_end, ctx)) return;
    const value_type = indexSigValueType(body_start, ctx);
    if (value_type == .none) return;
    const parent_name = findParentDeclName(node, ctx);
    if (parent_name) |pname| {
        var visited = VisitedSet.init();
        if (isDeeplyReferencing(ctx, value_type, pname, &visited)) return;
    }
    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "preferRecord");
}

fn checkMappedType(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const s = @intFromEnum(data.lhs);
    const e = @intFromEnum(data.rhs);
    // SubRange layout: [key_param, constraint, as_type, value_type]
    if (e < s + 4 or e > ctx.ast.extra_data.len) return;

    const key_param: NodeIndex = @enumFromInt(ctx.ast.extra_data[s]);
    const constraint: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 1]);
    const value_type: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 3]);

    // { [k in keyof T]: V } — preserves modifiers; not equivalent to Record.
    if (constraint != .none and ctx.nodeTag(constraint) == .ts_keyof_type) return;

    // If the key param appears in the value type, it can't be replaced by Record.
    if (key_param != .none and value_type != .none) {
        const key_name = ctx.tokenText(ctx.nodeMainToken(key_param));
        if (keyAppearsInType(ctx, value_type, key_name)) return;
    }

    // Check circular reference: if the parent type alias name appears (directly
    // or transitively) in the value type, this mapped type is part of a cycle.
    const parent_name = findParentDeclName(node, ctx);
    if (parent_name) |pname| {
        var visited = VisitedSet.init();
        if (isDeeplyReferencing(ctx, value_type, pname, &visited)) return;
    }

    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "preferRecord");
}

// ── "index-signature" mode handler ─────────────────────────────────────────

fn checkTypeRefForRecord(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.lhs == .none) return;
    if (ctx.nodeTag(data.lhs) != .identifier) return;
    const name = ctx.tokenText(ctx.nodeMainToken(data.lhs));
    if (!std.mem.eql(u8, name, "Record")) return;
    if (data.rhs == .none) return;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
    if (sr.end <= sr.start or sr.end - sr.start != 2) return;
    ctx.reportSpanWithMessageId(ctx.nodeSpan(node), "preferIndexSignature");
}

// ── Helpers ────────────────────────────────────────────────────────────────

/// Returns true iff the body range [start,end) contains exactly one member
/// and that member is a ts_index_signature.
fn isSingleIndexSig(body_start: u32, body_end: u32, ctx: *const LintContext) bool {
    if (body_end <= body_start) return false;
    if (body_end > ctx.ast.extra_data.len) return false;
    const members = ctx.ast.extra_data[body_start..body_end];
    if (members.len != 1) return false;
    const member: NodeIndex = @enumFromInt(members[0]);
    return ctx.nodeTag(member) == .ts_index_signature;
}

/// Returns the actual value-type node of the index signature at body_start.
/// ts_index_signature.rhs = ts_type_annotation; ts_type_annotation.lhs = type.
fn indexSigValueType(body_start: u32, ctx: *const LintContext) NodeIndex {
    const member: NodeIndex = @enumFromInt(ctx.ast.extra_data[body_start]);
    const type_ann = ctx.nodeData(member).rhs; // ts_type_annotation wrapper
    if (type_ann == .none) return .none;
    return ctx.nodeData(type_ann).lhs; // the actual type node
}

/// Walk parent chain to find the enclosing ts_type_alias_decl name.
/// Stops (returns null) when a ts_type_annotation boundary is crossed.
fn findParentDeclName(node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    var cur = ctx.parentOf(node);
    while (cur != .none) {
        switch (ctx.nodeTag(cur)) {
            .ts_type_alias_decl => {
                const d = ctx.nodeData(cur);
                if (d.lhs == .none) return null;
                const tad = ctx.extraData(ast.TypeAliasData, @intFromEnum(d.lhs));
                return ctx.tokenText(tad.name);
            },
            .ts_type_annotation => return null,
            else => cur = ctx.parentOf(cur),
        }
    }
    return null;
}

// ── Circular-reference detection ───────────────────────────────────────────

/// Fixed-size set of type names already followed in the current traversal
/// (prevents infinite loops in mutually-recursive chains).
const VisitedSet = struct {
    names: [32][]const u8,
    len: u8,

    fn init() VisitedSet {
        return .{ .names = undefined, .len = 0 };
    }

    fn contains(self: *const VisitedSet, name: []const u8) bool {
        for (self.names[0..self.len]) |n| {
            if (std.mem.eql(u8, n, name)) return true;
        }
        return false;
    }

    fn add(self: *VisitedSet, name: []const u8) void {
        if (self.len < 32) {
            self.names[self.len] = name;
            self.len += 1;
        }
    }
};

/// Returns true when `target_name` is reachable from `node` through the
/// "transparent" subset of type constructors (union, intersection, conditional,
/// indexed access, type-literal index-signatures, mapped-type value, type
/// arguments, and direct identifier references + their file-level definitions).
///
/// "Opaque" constructors (object-literal properties, array types, function
/// types, tuple types, etc.) terminate the search — matching TSe behaviour.
fn isDeeplyReferencing(
    ctx: *const LintContext,
    node: NodeIndex,
    target_name: []const u8,
    visited: *VisitedSet,
) bool {
    if (node == .none) return false;
    switch (ctx.nodeTag(node)) {
        .identifier => {
            const name = ctx.tokenText(ctx.nodeMainToken(node));
            if (std.mem.eql(u8, name, target_name)) return true;
            return followDefinition(ctx, name, target_name, visited);
        },
        .ts_type_reference => {
            const data = ctx.nodeData(node);
            if (isDeeplyReferencing(ctx, data.lhs, target_name, visited)) return true;
            // type arguments
            if (data.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (isDeeplyReferencing(ctx, @enumFromInt(raw), target_name, visited)) return true;
                    }
                }
            }
            return false;
        },
        .ts_union_type, .ts_intersection_type => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (isDeeplyReferencing(ctx, @enumFromInt(raw), target_name, visited)) return true;
            }
            return false;
        },
        .ts_conditional_type => {
            // SubRange: [check, extends, true, false]
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s + 4 > e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (isDeeplyReferencing(ctx, @enumFromInt(raw), target_name, visited)) return true;
            }
            return false;
        },
        .ts_indexed_access_type => {
            const data = ctx.nodeData(node);
            if (isDeeplyReferencing(ctx, data.lhs, target_name, visited)) return true;
            if (isDeeplyReferencing(ctx, data.rhs, target_name, visited)) return true;
            return false;
        },
        // Only index-signature members are transparent; property signatures etc. are opaque.
        .ts_type_literal => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const member: NodeIndex = @enumFromInt(raw);
                if (ctx.nodeTag(member) == .ts_index_signature) {
                    if (isDeeplyReferencing(ctx, ctx.nodeData(member).rhs, target_name, visited)) return true;
                }
            }
            return false;
        },
        // ts_index_signature.rhs = ts_type_annotation; fall through to ts_type_annotation.
        .ts_index_signature => {
            return isDeeplyReferencing(ctx, ctx.nodeData(node).rhs, target_name, visited);
        },
        // ts_type_annotation.lhs = actual type node.
        .ts_type_annotation => {
            return isDeeplyReferencing(ctx, ctx.nodeData(node).lhs, target_name, visited);
        },
        // ts_mapped_type SubRange: [key_param, constraint, as_type, value_type]
        .ts_mapped_type => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (e < s + 4 or e > ctx.ast.extra_data.len) return false;
            const value_type: NodeIndex = @enumFromInt(ctx.ast.extra_data[s + 3]);
            return isDeeplyReferencing(ctx, value_type, target_name, visited);
        },
        .ts_parenthesized_type => {
            return isDeeplyReferencing(ctx, ctx.nodeData(node).lhs, target_name, visited);
        },
        // Everything else (array types, property signatures, function types,
        // tuple types, primitives …) is opaque — terminate the search.
        else => return false,
    }
}

/// Look up the file-level definition for `name` and check whether `target_name`
/// is reachable from its body.  Adds `name` to `visited` before recursing to
/// prevent infinite loops in mutually-recursive type chains.
fn followDefinition(
    ctx: *const LintContext,
    name: []const u8,
    target_name: []const u8,
    visited: *VisitedSet,
) bool {
    if (visited.contains(name)) return false;
    visited.add(name);

    const total: u32 = @intCast(ctx.ast.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        switch (ctx.nodeTag(ni)) {
            .ts_interface_decl => {
                const data = ctx.nodeData(ni);
                if (data.lhs == .none) continue;
                const id = ctx.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
                if (!std.mem.eql(u8, ctx.tokenText(id.name), name)) continue;
                if (id.body_start >= id.body_end or id.body_end > ctx.ast.extra_data.len) continue;
                for (ctx.ast.extra_data[id.body_start..id.body_end]) |raw| {
                    const member: NodeIndex = @enumFromInt(raw);
                    if (ctx.nodeTag(member) == .ts_index_signature) {
                        if (isDeeplyReferencing(ctx, ctx.nodeData(member).rhs, target_name, visited)) return true;
                    }
                }
            },
            .ts_type_alias_decl => {
                const data = ctx.nodeData(ni);
                if (data.lhs == .none) continue;
                const tad = ctx.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
                if (!std.mem.eql(u8, ctx.tokenText(tad.name), name)) continue;
                if (tad.type_node != .none) {
                    if (isDeeplyReferencing(ctx, tad.type_node, target_name, visited)) return true;
                }
            },
            else => {},
        }
    }
    return false;
}

/// True if `key_name` appears as an identifier anywhere within `node` (shallow
/// traversal through common type constructors).  Used to detect whether a
/// mapped type's key parameter is referenced in the value type.
fn keyAppearsInType(ctx: *const LintContext, node: NodeIndex, key_name: []const u8) bool {
    if (node == .none) return false;
    switch (ctx.nodeTag(node)) {
        .identifier => {
            return std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(node)), key_name);
        },
        .ts_type_reference => {
            const data = ctx.nodeData(node);
            if (keyAppearsInType(ctx, data.lhs, key_name)) return true;
            if (data.rhs != .none) {
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        if (keyAppearsInType(ctx, @enumFromInt(raw), key_name)) return true;
                    }
                }
            }
            return false;
        },
        .ts_union_type, .ts_intersection_type, .ts_tuple_type => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s >= e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (keyAppearsInType(ctx, @enumFromInt(raw), key_name)) return true;
            }
            return false;
        },
        .ts_conditional_type => {
            const data = ctx.nodeData(node);
            const s = @intFromEnum(data.lhs);
            const e = @intFromEnum(data.rhs);
            if (s + 4 > e or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                if (keyAppearsInType(ctx, @enumFromInt(raw), key_name)) return true;
            }
            return false;
        },
        .ts_indexed_access_type => {
            const data = ctx.nodeData(node);
            if (keyAppearsInType(ctx, data.lhs, key_name)) return true;
            if (keyAppearsInType(ctx, data.rhs, key_name)) return true;
            return false;
        },
        .ts_type_annotation, .ts_parenthesized_type, .ts_array_type,
        .ts_keyof_type, .ts_typeof_type => {
            return keyAppearsInType(ctx, ctx.nodeData(node).lhs, key_name);
        },
        else => return false,
    }
}
