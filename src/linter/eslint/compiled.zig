const std = @import("std");
const ast_mod = @import("../../parser/ast.zig");
const Node = ast_mod.Node;
const NodeIndex = ast_mod.NodeIndex;
const Ast = ast_mod.Ast;
const layout = @import("../../parser/layout.zig");
const Severity = @import("../../parser/diagnostic.zig").Severity;
const Diagnostic = @import("../../parser/diagnostic.zig").Diagnostic;
const Span = @import("../../parser/span.zig").Span;

// ── Compiled Rule ──────────────────────────────────────────────

/// A compiled ESLint rule handler. Replaces JS interpretation with
/// a flat predicate chain evaluated against SoA arrays.
pub const CompiledRule = struct {
    rule_name: []const u8,
    severity: Severity,
    predicates: []const Pred,
    report: Report,
};

pub const Report = struct {
    message_id: []const u8,
    /// Static template (resolved from messages at compile time).
    template: []const u8,
    /// Data bindings: {{key}} → node property.
    data_bindings: []const DataBinding,
};

pub const DataBinding = struct {
    key: []const u8,
    source: DataSource,
};

pub const DataSource = union(enum) {
    literal: []const u8,
    node_prop: Prop,
    parent_prop: Prop,
};

// ── Predicates ─────────────────────────────────────────────────

pub const Pred = union(enum) {
    // String property checks
    str_eq: struct { nav: Nav, prop: Prop, value: []const u8 },
    str_neq: struct { nav: Nav, prop: Prop, value: []const u8 },
    str_in: struct { nav: Nav, prop: Prop, values: []const []const u8 },
    str_not_in: struct { nav: Nav, prop: Prop, values: []const []const u8 },

    // Type checks (ESTree type name)
    type_eq: struct { nav: Nav, type_name: []const u8 },
    type_neq: struct { nav: Nav, type_name: []const u8 },

    // Boolean property checks
    bool_true: struct { nav: Nav, prop: Prop },
    bool_false: struct { nav: Nav, prop: Prop },

    // Null/existence checks
    is_null: Nav,
    is_not_null: Nav,

    // Child array length
    array_empty: struct { nav: Nav, prop: Prop },
    array_nonempty: struct { nav: Nav, prop: Prop },

    // Disjunction (any branch must pass)
    any_of: []const []const Pred,
};

/// Navigation from current node to target of a check.
pub const Nav = union(enum) {
    self,
    parent,
    lhs, // left / argument / callee / id (tag-dependent)
    rhs, // right / init / body (tag-dependent)
};

/// ESTree property mapped to SoA field.
pub const Prop = enum {
    type_name, // layout.tag_names[tag]
    operator, // operatorString(tag)
    name, // tokenText(main_token) for identifiers
    kind, // "var"/"let"/"const" for decl tags
    value, // literal value
    raw, // raw token text
    computed, // tag == .computed_*
    prefix, // tag == .prefix_*
    shorthand, // tag == .shorthand_property
};

// ── Predicate Evaluator ────────────────────────────────────────

/// Evaluate all predicates against a node. Returns true if all pass.
pub fn evalPreds(
    preds: []const Pred,
    idx: u32,
    tree: *const Ast,
    parents: []const u32,
) bool {
    for (preds) |p| {
        if (!evalOne(p, idx, tree, parents)) return false;
    }
    return true;
}

fn evalOne(pred: Pred, idx: u32, tree: *const Ast, parents: []const u32) bool {
    switch (pred) {
        .str_eq => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            const actual = getPropStr(p.prop, target, tree) orelse return false;
            return std.mem.eql(u8, actual, p.value);
        },
        .str_neq => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return true;
            const actual = getPropStr(p.prop, target, tree) orelse return true;
            return !std.mem.eql(u8, actual, p.value);
        },
        .str_in => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            const actual = getPropStr(p.prop, target, tree) orelse return false;
            for (p.values) |v| {
                if (std.mem.eql(u8, actual, v)) return true;
            }
            return false;
        },
        .str_not_in => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return true;
            const actual = getPropStr(p.prop, target, tree) orelse return true;
            for (p.values) |v| {
                if (std.mem.eql(u8, actual, v)) return false;
            }
            return true;
        },
        .type_eq => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            const tags = tree.nodes.items(.tag);
            if (target >= tags.len) return false;
            const type_name = std.mem.span(layout.sanz_tag_name(@intFromEnum(tags[target])));
            return std.mem.eql(u8, type_name, p.type_name);
        },
        .type_neq => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return true;
            const tags = tree.nodes.items(.tag);
            if (target >= tags.len) return true;
            const type_name = std.mem.span(layout.sanz_tag_name(@intFromEnum(tags[target])));
            return !std.mem.eql(u8, type_name, p.type_name);
        },
        .bool_true => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            return getPropBool(p.prop, target, tree) orelse false;
        },
        .bool_false => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            return !(getPropBool(p.prop, target, tree) orelse true);
        },
        .is_null => |nav| {
            return resolve(nav, idx, tree, parents) == null;
        },
        .is_not_null => |nav| {
            return resolve(nav, idx, tree, parents) != null;
        },
        .array_empty => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            return getArrayLen(p.prop, target, tree) == 0;
        },
        .array_nonempty => |p| {
            const target = resolve(p.nav, idx, tree, parents) orelse return false;
            return getArrayLen(p.prop, target, tree) > 0;
        },
        .any_of => |branches| {
            for (branches) |branch| {
                if (evalPreds(branch, idx, tree, parents)) return true;
            }
            return false;
        },
    }
}

// ── Navigation ─────────────────────────────────────────────────

const NONE: u32 = 0xFFFFFFFF;

fn resolve(nav: Nav, idx: u32, tree: *const Ast, parents: []const u32) ?u32 {
    return switch (nav) {
        .self => idx,
        .parent => if (idx < parents.len and parents[idx] != NONE) parents[idx] else null,
        .lhs => blk: {
            const data = tree.nodes.items(.data);
            if (idx >= data.len) break :blk null;
            const lhs = @intFromEnum(data[idx].lhs);
            break :blk if (lhs != NONE) lhs else null;
        },
        .rhs => blk: {
            const data = tree.nodes.items(.data);
            if (idx >= data.len) break :blk null;
            const rhs = @intFromEnum(data[idx].rhs);
            break :blk if (rhs != NONE) rhs else null;
        },
    };
}

// ── Property Access ────────────────────────────────────────────

fn getPropStr(prop: Prop, idx: u32, tree: *const Ast) ?[]const u8 {
    const tags = tree.nodes.items(.tag);
    if (idx >= tags.len) return null;
    const tag = tags[idx];

    return switch (prop) {
        .type_name => std.mem.span(layout.sanz_tag_name(@intFromEnum(tag))),
        .operator => operatorStr(tag),
        .name => blk: {
            if (tag != .identifier) break :blk null;
            break :blk tree.tokenText(tree.nodes.items(.main_token)[idx]);
        },
        .kind => switch (tag) {
            .var_decl => "var",
            .let_decl => "let",
            .const_decl => "const",
            else => null,
        },
        .raw, .value => tree.tokenText(tree.nodes.items(.main_token)[idx]),
        else => null,
    };
}

fn getPropBool(prop: Prop, idx: u32, tree: *const Ast) ?bool {
    const tags = tree.nodes.items(.tag);
    if (idx >= tags.len) return null;
    const tag = tags[idx];

    return switch (prop) {
        .computed => switch (tag) {
            .computed_member_expr, .optional_computed_member_expr,
            .computed_property, .computed_method_def,
            => true,
            .member_expr, .optional_member_expr,
            .property, .shorthand_property, .method_def,
            => false,
            else => null,
        },
        .prefix => switch (tag) {
            .prefix_inc, .prefix_dec => true,
            .postfix_inc, .postfix_dec => false,
            else => null,
        },
        .shorthand => tag == .shorthand_property,
        else => null,
    };
}

fn getArrayLen(prop: Prop, idx: u32, tree: *const Ast) u32 {
    _ = prop;
    const data = tree.nodes.items(.data);
    if (idx >= data.len) return 0;
    const lhs = @intFromEnum(data[idx].lhs);
    const rhs = @intFromEnum(data[idx].rhs);
    if (lhs >= tree.extra_data.len or rhs > tree.extra_data.len or rhs <= lhs) return 0;
    return rhs - lhs;
}

fn operatorStr(tag: Node.Tag) ?[]const u8 {
    return switch (tag) {
        .add => "+",
        .subtract => "-",
        .multiply => "*",
        .divide => "/",
        .modulo => "%",
        .equal => "==",
        .not_equal => "!=",
        .strict_equal => "===",
        .strict_not_equal => "!==",
        .less_than => "<",
        .greater_than => ">",
        .less_equal => "<=",
        .greater_equal => ">=",
        .logical_and => "&&",
        .logical_or => "||",
        .nullish_coalesce => "??",
        .bitwise_and => "&",
        .bitwise_or => "|",
        .bitwise_xor => "^",
        .shift_left => "<<",
        .shift_right => ">>",
        .instanceof_expr => "instanceof",
        .in_expr => "in",
        .unary_minus => "-",
        .unary_plus => "+",
        .logical_not => "!",
        .bitwise_not => "~",
        .typeof_expr => "typeof",
        .void_expr => "void",
        .delete_expr => "delete",
        .assign => "=",
        .add_assign => "+=",
        .sub_assign => "-=",
        .mul_assign => "*=",
        .div_assign => "/=",
        .prefix_inc, .postfix_inc => "++",
        .prefix_dec, .postfix_dec => "--",
        else => null,
    };
}

// ── Diagnostic Emission ────────────────────────────────────────

pub fn emitDiag(
    rule: *const CompiledRule,
    idx: u32,
    tree: *const Ast,
    parents: []const u32,
    diagnostics: *std.ArrayList(Diagnostic),
    allocator: std.mem.Allocator,
) void {
    var message = rule.report.template;

    // Substitute {{key}} placeholders
    if (rule.report.data_bindings.len > 0 and std.mem.indexOf(u8, message, "{{") != null) {
        var buf: std.ArrayList(u8) = .empty;
        var i: usize = 0;
        while (i < message.len) {
            if (i + 1 < message.len and message[i] == '{' and message[i + 1] == '{') {
                const end = std.mem.indexOfPos(u8, message, i + 2, "}}") orelse {
                    buf.append(allocator, message[i]) catch {};
                    i += 1;
                    continue;
                };
                const key = message[i + 2 .. end];
                var found = false;
                for (rule.report.data_bindings) |binding| {
                    if (std.mem.eql(u8, binding.key, key)) {
                        const val = switch (binding.source) {
                            .literal => |l| l,
                            .node_prop => |p| getPropStr(p, idx, tree) orelse "?",
                            .parent_prop => |p| blk: {
                                const pidx = if (idx < parents.len and parents[idx] != NONE) parents[idx] else idx;
                                break :blk getPropStr(p, pidx, tree) orelse "?";
                            },
                        };
                        buf.appendSlice(allocator, val) catch {};
                        found = true;
                        break;
                    }
                }
                if (!found) buf.appendSlice(allocator, key) catch {};
                i = end + 2;
            } else {
                buf.append(allocator, message[i]) catch {};
                i += 1;
            }
        }
        message = buf.items;
    }

    diagnostics.append(allocator, .{
        .message = message,
        .span = Span{ .start = idx, .end = idx },
        .severity = rule.severity,
    }) catch {};
}

// ── Compiled Dispatch Table ────────────────────────────────────

pub const CompiledDispatch = struct {
    enter: [256][]const CompiledRule,
    exit: [256][]const CompiledRule,

    pub fn init() CompiledDispatch {
        var self: CompiledDispatch = undefined;
        for (0..256) |i| {
            self.enter[i] = &.{};
            self.exit[i] = &.{};
        }
        return self;
    }
};
