// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/restrict-plus-operands

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("ez_checker").types;
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "restrict-plus-operands",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow + operations between mismatched / unsafe types",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .add, .add_assign,
};

pub const needs_semantic = true;

const Options = struct {
    allow_any: bool = true,
    allow_boolean: bool = true,
    allow_nullish: bool = true,
    allow_number_and_string: bool = true,
    allow_regexp: bool = true,
    skip_compound_assignments: bool = false,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("allowAny")) |x| if (x == .bool) { opts.allow_any = x.bool; };
    if (v.object.get("allowBoolean")) |x| if (x == .bool) { opts.allow_boolean = x.bool; };
    if (v.object.get("allowNullish")) |x| if (x == .bool) { opts.allow_nullish = x.bool; };
    if (v.object.get("allowNumberAndString")) |x| if (x == .bool) { opts.allow_number_and_string = x.bool; };
    if (v.object.get("allowRegExp")) |x| if (x == .bool) { opts.allow_regexp = x.bool; };
    if (v.object.get("skipCompoundAssignments")) |x| if (x == .bool) { opts.skip_compound_assignments = x.bool; };
    return opts;
}

const Family = struct {
    string: bool = false,
    number: bool = false,
    bigint: bool = false,
    invalid: bool = false,
    // True when an `any`/`unknown`/`error`/nullish constituent contributed
    // flexible (non-committed) family bits — suppresses strict
    // bigint↔number mismatching since the flexible side could supply
    // the missing family.
    flexible: bool = false,
    // True when the operand is purely a RegExp (or RegExp-only union) —
    // counts as string-side joiner ONLY; using RegExp opposite a
    // non-string side is invalid even when allowRegExp is on.
    regexp_only: bool = false,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const tag = ctx.nodeTag(node);
    if (tag == .add_assign and opts.skip_compound_assignments) return;
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;

    const lhs_fam = checkOperand(d.lhs, opts, ctx);
    const rhs_fam = checkOperand(d.rhs, opts, ctx);

    if (lhs_fam.invalid or rhs_fam.invalid) return;

    // RegExp-only operand opposite a non-string-supporting operand is
    // an invalid operand (the RegExp coerces to string only when the
    // other side does too).
    if (lhs_fam.regexp_only and !rhs_fam.string and !rhs_fam.flexible) {
        ctx.reportWithMessageId(d.lhs, "invalid");
        return;
    }
    if (rhs_fam.regexp_only and !lhs_fam.string and !lhs_fam.flexible) {
        ctx.reportWithMessageId(d.rhs, "invalid");
        return;
    }

    const l_str_only = lhs_fam.string and !lhs_fam.number and !lhs_fam.bigint;
    const r_str_only = rhs_fam.string and !rhs_fam.number and !rhs_fam.bigint;
    const l_num_only = (lhs_fam.number or lhs_fam.bigint) and !lhs_fam.string;
    const r_num_only = (rhs_fam.number or rhs_fam.bigint) and !rhs_fam.string;
    if ((l_str_only and r_num_only) or (l_num_only and r_str_only)) {
        if (!opts.allow_number_and_string) ctx.reportWithMessageId(node, "mismatched");
        return;
    }
    // BigInt + number mismatch reported with `bigintAndNumber` messageId.
    // Skip when a flexible (any/unknown/nullish) operand could supply the
    // missing family.
    const l_big = lhs_fam.bigint and !lhs_fam.number;
    const r_big = rhs_fam.bigint and !rhs_fam.number;
    const l_pure_num = lhs_fam.number and !lhs_fam.bigint;
    const r_pure_num = rhs_fam.number and !rhs_fam.bigint;
    if ((l_big and r_pure_num and !rhs_fam.flexible) or
        (r_big and l_pure_num and !lhs_fam.flexible))
    {
        ctx.reportWithMessageId(node, "bigintAndNumber");
        return;
    }
}

fn checkOperand(node: NodeIndex, opts: Options, ctx: *const LintContext) Family {
    var n = node;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    if (ctx.nodeTag(n) == .call_expr) {
        const cd = ctx.nodeData(n);
        var callee = cd.lhs;
        while (ctx.nodeTag(callee) == .grouping_expr) callee = ctx.nodeData(callee).lhs;
        if (ctx.nodeTag(callee) == .identifier) {
            const name = ctx.tokenText(ctx.nodeMainToken(callee));
            if (std.mem.eql(u8, name, "Number")) return .{ .number = true };
            if (std.mem.eql(u8, name, "BigInt")) return .{ .bigint = true };
            if (std.mem.eql(u8, name, "String")) return .{ .string = true };
            if (std.mem.eql(u8, name, "Boolean")) {
                if (opts.allow_boolean) return .{ .number = true };
                ctx.reportWithMessageId(node, "invalid");
                return .{ .invalid = true };
            }
        }
    }
    var fam = Family{};
    var probe = ProbeKind{};
    classify(ctx.typeOfNode(n), opts, &fam, 0, ctx, &probe);
    if (fam.invalid) ctx.reportWithMessageId(node, "invalid");
    // RegExp-only: only kind present was regexp.
    if (probe.has_regexp and !probe.has_committed and !probe.has_flexible) {
        fam.regexp_only = true;
    }
    return fam;
}

const ProbeKind = struct {
    has_regexp: bool = false,
    has_committed: bool = false, // string/number/bigint/boolean (commits to a family)
    has_flexible: bool = false,   // any/nullish/error
};

fn classify(id: TypeId, opts: Options, out: *Family, depth: u32, ctx: *const LintContext, probe: *ProbeKind) void {
    if (depth > 4) {
        out.invalid = true;
        return;
    }
    if (id.eq(tymod.ID_ANY)) {
        if (!opts.allow_any) {
            out.invalid = true;
            return;
        }
        out.string = true;
        out.number = true;
        out.bigint = true;
        out.flexible = true;
        probe.has_flexible = true;
        return;
    }
    if (id.eq(tymod.ID_UNKNOWN)) {
        // unknown can't be used in `+` regardless of allowAny.
        out.invalid = true;
        return;
    }
    const kind = ctx.typeIdKind(id) orelse {
        out.string = true;
        out.number = true;
        out.bigint = true;
        out.flexible = true;
        probe.has_flexible = true;
        return;
    };
    if (kind == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| classify(m, opts, out, depth + 1, ctx, probe);
        return;
    }
    if (kind == .intersection_t) {
        // Intersection: object-only "brand" members are absorbed.  Any
        // non-brand member that's `invalid` under the current options
        // taints the whole operand.
        var tried = Family{};
        var inner_probe = ProbeKind{};
        var saw_brand_only = true;
        for (ctx.typeIdUnionMembers(id)) |m| {
            const mkind = ctx.typeIdKind(m) orelse continue;
            // Brand-like members are absorbed by primitive constituents.
            if (mkind == .object_t or mkind == .object_keyword or mkind == .unknown) continue;
            saw_brand_only = false;
            classify(m, opts, &tried, depth + 1, ctx, &inner_probe);
        }
        if (saw_brand_only or tried.invalid) {
            out.invalid = true;
            return;
        }
        out.string = out.string or tried.string;
        out.number = out.number or tried.number;
        out.bigint = out.bigint or tried.bigint;
        out.flexible = out.flexible or tried.flexible;
        probe.has_committed = probe.has_committed or inner_probe.has_committed;
        probe.has_flexible = probe.has_flexible or inner_probe.has_flexible;
        probe.has_regexp = probe.has_regexp or inner_probe.has_regexp;
        return;
    }
    switch (kind) {
        .string, .string_literal => {
            out.string = true;
            probe.has_committed = true;
        },
        .number, .number_literal => {
            out.number = true;
            probe.has_committed = true;
        },
        .bigint, .bigint_literal => {
            out.bigint = true;
            probe.has_committed = true;
        },
        .boolean, .boolean_literal => {
            if (opts.allow_boolean) {
                out.number = true;
                probe.has_committed = true;
            } else out.invalid = true;
        },
        .null_t, .undefined_t, .void_t => {
            if (opts.allow_nullish) {
                out.string = true;
                out.number = true;
                out.bigint = true;
                out.flexible = true;
                probe.has_flexible = true;
            } else out.invalid = true;
        },
        .never => {
            if (!opts.allow_any) {
                out.invalid = true;
            } else {
                out.flexible = true;
                probe.has_flexible = true;
            }
        },
        .error_t => {
            // Unresolved type — treat like any (flexible) when allowAny is
            // on; invalid under strict mode.
            if (!opts.allow_any) {
                out.invalid = true;
            } else {
                out.string = true;
                out.number = true;
                out.bigint = true;
                out.flexible = true;
                probe.has_flexible = true;
            }
        },
        .unknown => out.invalid = true,
        .type_ref => {
            const name = ctx.typeIdRefName(id);
            if (std.mem.eql(u8, name, "RegExp")) {
                if (opts.allow_regexp) {
                    out.string = true;
                    probe.has_regexp = true;
                } else out.invalid = true;
                return;
            }
            out.invalid = true;
        },
        else => out.invalid = true,
    }
}
