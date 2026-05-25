// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-new-func
// Source rule: tests/conformance/eslint/lib/rules/no-new-func.js

const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const ref_mod = @import("../../../parser/reference.zig");
const ReferenceId = ref_mod.ReferenceId;

pub const meta = RuleMeta{
    .name = "no-new-func",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow `new` operators with the `Function` object",
};

pub const relevant_tags = [_]Node.Tag{};

pub const needs_semantic = true;

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    noFunctionConstructor,
};

const callMethods = [_][]const u8{ "apply", "bind", "call" };

const __Function_names__ = [_][]const u8{ "Function" };

fn containsStr(haystack: []const []const u8, needle: []const u8) bool {
    for (haystack) |s| if (std.mem.eql(u8, s, needle)) return true;
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

fn methodChainCall(c: *const LintContext, id_node: NodeIndex, methods: []const []const u8) NodeIndex {
    const parent = c.parentOf(id_node);
    if (parent == .none) return .none;
    const ptag = c.nodeTag(parent);
    const is_plain = ptag == .member_expr or ptag == .optional_member_expr;
    const is_computed = ptag == .computed_member_expr or ptag == .optional_computed_member_expr;
    if (!is_plain and !is_computed) return .none;
    const p_data = c.nodeData(parent);
    if (p_data.lhs != id_node) return .none;
    const prop_node = p_data.rhs;
    if (prop_node == .none) return .none;
    const prop_tag = c.nodeTag(prop_node);
    const name: []const u8 = if (is_plain) blk: {
        if (prop_tag != .property_ident) break :blk "";
        break :blk c.tokenText(c.nodeMainToken(prop_node));
    } else blk: {
        if (prop_tag != .string_literal) break :blk "";
        break :blk stripQuotes(c.tokenText(c.nodeMainToken(prop_node)));
    };
    if (name.len == 0) return .none;
    var ok = false;
    for (methods) |m| if (std.mem.eql(u8, m, name)) { ok = true; break; };
    if (!ok) return .none;
    // Skip grouping (parenthesized) wrappers when walking up.
    var wrapped = parent;
    var gp = c.parentOf(wrapped);
    while (gp != .none and c.nodeTag(gp) == .grouping_expr) {
        wrapped = gp;
        gp = c.parentOf(gp);
    }
    if (gp == .none) return .none;
    const gtag = c.nodeTag(gp);
    if (gtag != .call_expr and gtag != .optional_call_expr) return .none;
    const gp_data = c.nodeData(gp);
    if (gp_data.lhs != wrapped) return .none;
    return gp;
}

fn stripQuotes(s: []const u8) []const u8 {
    if (s.len >= 2) {
        const a = s[0]; const b = s[s.len - 1];
        if ((a == '"' and b == '"') or (a == '\'' and b == '\'')) return s[1 .. s.len - 1];
    }
    return s;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    const refs = ctx.references();
    const count = refs.count();
    var r: u32 = 0;
    while (r < count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (refs.isResolved(ref_id)) {
            const __sym = refs.getSymbol(ref_id);
            if (__sym != .none and !ctx.symbols().isImplicitGlobal(__sym)) continue;
        }
        const __ref_identifier__ = refs.getNode(ref_id);
        const __name__ = ctx.tokenText(ctx.nodeMainToken(__ref_identifier__));
        var __matches = false;
        for (__Function_names__) |__n| { if (std.mem.eql(u8, __name__, __n)) { __matches = true; break; } }
        if (!__matches) continue;
        // Respect ESLint globals:"off" (config + inline /* global X:off */)
        if (ctx.globalIsOff(__name__)) continue;
        if ((((ctx.nodeTag(ctx.parentOf(__ref_identifier__)) == .new_expr) or blk: { const __t = ctx.nodeTag(ctx.parentOf(__ref_identifier__)); break :blk (__t == .call_expr or __t == .optional_call_expr); }) and (ctx.nodeData(ctx.parentOf(__ref_identifier__)).lhs == __ref_identifier__))) {
            ctx.reportWithMessageId(ctx.parentOf(__ref_identifier__), "noFunctionConstructor");
        }
        // Method-chain invocation check: <idNode>.<method>(...) — report outer call.
        const __mc_call = methodChainCall(ctx, __ref_identifier__, callMethods[0..]);
        if (__mc_call != .none) ctx.reportWithMessageId(__mc_call, "noFunctionConstructor");
    }
}
