// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/switch-exhaustiveness-check
//
// For each `switch (discriminant)`:
//   - When the discriminant's type is a finite literal union (string /
//     number / boolean literals, or an enum), enumerate the members
//     and compare with the switch's case literals.
//   - Missing members → `switchIsNotExhaustive`.
//
// Options (partial support):
//   - `allowDefaultCaseForExhaustiveSwitch` (default true)
//   - `considerDefaultExhaustiveForUnions` (default false)
//   - `requireDefaultForNonUnion` (default false)

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
    .name = "switch-exhaustiveness-check",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Require switch over union/enum to cover all cases",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .switch_stmt,
};

pub const needs_semantic = true;

const Options = struct {
    allow_default_case_for_exhaustive: bool = true,
    consider_default_exhaustive_for_unions: bool = false,
    require_default_for_non_union: bool = false,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("allowDefaultCaseForExhaustiveSwitch")) |x| if (x == .bool) {
        opts.allow_default_case_for_exhaustive = x.bool;
    };
    if (v.object.get("considerDefaultExhaustiveForUnions")) |x| if (x == .bool) {
        opts.consider_default_exhaustive_for_unions = x.bool;
    };
    if (v.object.get("requireDefaultForNonUnion")) |x| if (x == .bool) {
        opts.require_default_for_non_union = x.bool;
    };
    return opts;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const d = ctx.nodeData(node);
    if (d.lhs == .none or d.rhs == .none) return;
    const discriminant = d.lhs;

    // Collect cases.
    var case_buf: [64]NodeIndex = undefined;
    var case_count: usize = 0;
    var has_default = false;
    var default_node: NodeIndex = .none;
    const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
    if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
        for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
            if (case_count >= case_buf.len) break;
            const c: NodeIndex = @enumFromInt(raw);
            const ctag = ctx.nodeTag(c);
            if (ctag == .switch_default) {
                has_default = true;
                default_node = c;
                continue;
            }
            if (ctag != .switch_case) continue;
            const cd = ctx.nodeData(c);
            case_buf[case_count] = cd.lhs;
            case_count += 1;
        }
    }

    // Enumerate expected literal values from discriminant.
    var expected_buf: [64]ExpectedValue = undefined;
    var expected_count: usize = 0;
    var has_non_finite = false;
    const disc_ty = ctx.typeOfNode(discriminant);
    collectExpectedRelaxed(disc_ty, &expected_buf, &expected_count, &has_non_finite, ctx, 0);

    if (expected_count == 0 and !has_non_finite) return;

    // Count missing literals.
    var missing_count: usize = 0;
    var i: usize = 0;
    while (i < expected_count) : (i += 1) {
        if (!caseCoversExpected(case_buf[0..case_count], &expected_buf[i], ctx)) {
            missing_count += 1;
        }
    }

    // considerDefaultExhaustiveForUnions: skip if default exists.
    if (opts.consider_default_exhaustive_for_unions and has_default and expected_count > 0) return;
    // `// no default` / custom comment suppresses the diagnostic in
    // certain option modes.
    const has_no_default_comment = switchBodyHasNoDefaultComment(node, ctx);
    if (has_no_default_comment) {
        // The `no default` convention conveys "deliberately skipped" —
        // TSe treats this like a default in modes that allow defaults.
        if (opts.consider_default_exhaustive_for_unions and expected_count > 0) return;
        // For non-union require-default, the comment also suppresses.
        if (opts.require_default_for_non_union and has_non_finite and missing_count == 0) return;
    }

    if (missing_count > 0) {
        var fired: usize = 0;
        while (fired < missing_count) : (fired += 1) {
            ctx.reportWithMessageId(discriminant, "switchIsNotExhaustive");
        }
    }
    // requireDefaultForNonUnion: when discriminant has non-finite parts
    // and there's no default, fire once.
    if (has_non_finite and opts.require_default_for_non_union and !has_default) {
        ctx.reportWithMessageId(discriminant, "switchIsNotExhaustive");
    }
    // dangerousDefaultCase: when the switch IS exhaustive (no missing
    // members, finite union, no non-finite parts) and a default exists
    // (real `default:` clause OR a `// no default` comment), and the
    // option disallows it.
    if (!opts.allow_default_case_for_exhaustive and
        missing_count == 0 and
        expected_count > 0 and
        !has_non_finite)
    {
        if (has_default and default_node != .none) {
            ctx.reportWithMessageId(default_node, "dangerousDefaultCase");
        } else if (!has_default) {
            // `// no default` comment acts as a synthetic default for
            // dangerousDefaultCase reporting (matches TSe behaviour).
            if (noDefaultCommentOffset(node, ctx)) |off| {
                const src = ctx.source();
                // Find end of line (for `//`) or end of `/* ... */`.
                var end = off + 2;
                if (off + 1 < src.len and src[off + 1] == '/') {
                    while (end < src.len and src[end] != '\n') end += 1;
                } else {
                    while (end + 1 < src.len and !(src[end] == '*' and src[end + 1] == '/')) end += 1;
                    if (end + 1 < src.len) end += 2;
                }
                ctx.reportSpanWithMessageId(.{ .start = off, .end = @intCast(end) }, "dangerousDefaultCase");
            }
        }
    }
}

const ValueKind = enum { str, num, big, bool_t, enum_member, null_v, undefined_v };

const ExpectedValue = struct {
    kind: ValueKind,
    str_val: []const u8 = &.{},
    num_val: f64 = 0,
    bool_val: bool = false,
    enum_name: []const u8 = &.{},
    enum_member_name: []const u8 = &.{},
};

const parser_span = @import("es_parser").span;
const Span = parser_span.Span;

/// Look for `// no default` / `/* no default */` (case-insensitive) in the
/// switch statement's source range.  Returns the absolute byte offset of the
/// comment-start (`//` or `/*`) when found, null otherwise.
fn noDefaultCommentOffset(node: NodeIndex, ctx: *const LintContext) ?u32 {
    const src = ctx.source();
    const start = ctx.ast.tokenStart(ctx.nodeMainToken(node));
    if (start >= src.len) return null;
    const slice = src[start..];

    for ([_][]const u8{ "no default", "skip default" }) |needle| {
        const rel = findInsensitive(slice, needle) orelse continue;
        // Walk backwards from `rel` to find the comment-start (`//` or `/*`).
        var i = rel;
        while (i > 0) : (i -= 1) {
            if (i + 1 <= slice.len) {
                if (slice[i] == '/' and (i + 1 < slice.len) and
                    (slice[i + 1] == '/' or slice[i + 1] == '*')) return @intCast(start + i);
            }
        }
        // Fallback: point to "no default" itself.
        return @intCast(start + rel);
    }
    return null;
}

fn switchBodyHasNoDefaultComment(node: NodeIndex, ctx: *const LintContext) bool {
    return noDefaultCommentOffset(node, ctx) != null;
}

fn findInsensitive(haystack: []const u8, needle: []const u8) ?usize {
    if (needle.len == 0 or needle.len > haystack.len) return null;
    var i: usize = 0;
    while (i + needle.len <= haystack.len) : (i += 1) {
        var ok = true;
        var j: usize = 0;
        while (j < needle.len) : (j += 1) {
            const a = haystack[i + j];
            const b = needle[j];
            const al = if (a >= 'A' and a <= 'Z') a + 32 else a;
            const bl = if (b >= 'A' and b <= 'Z') b + 32 else b;
            if (al != bl) {
                ok = false;
                break;
            }
        }
        if (ok) return i;
    }
    return null;
}

fn collectExpectedRelaxed(
    id: TypeId,
    buf: []ExpectedValue,
    count: *usize,
    has_non_finite: *bool,
    ctx: *const LintContext,
    depth: u32,
) void {
    if (depth > 6) return;
    const kind = ctx.typeIdKind(id) orelse {
        has_non_finite.* = true;
        return;
    };
    if (kind == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            collectExpectedRelaxed(m, buf, count, has_non_finite, ctx, depth + 1);
        }
        return;
    }
    if (kind == .intersection_t) {
        // Pick any classifying member; the literal drives exhaustiveness.
        for (ctx.typeIdUnionMembers(id)) |m| {
            const before = count.*;
            collectExpectedRelaxed(m, buf, count, has_non_finite, ctx, depth + 1);
            if (count.* > before) return;
        }
        return;
    }
    if (ctx.typeIdLiteralValue(id)) |val| {
        if (count.* >= buf.len) return;
        switch (val) {
            .string => |s| {
                buf[count.*] = .{ .kind = .str, .str_val = s };
                count.* += 1;
            },
            .number => |n| {
                buf[count.*] = .{ .kind = .num, .num_val = n };
                count.* += 1;
            },
            .bigint => |b| {
                buf[count.*] = .{ .kind = .big, .str_val = b };
                count.* += 1;
            },
            .boolean => |b| {
                buf[count.*] = .{ .kind = .bool_t, .bool_val = b };
                count.* += 1;
            },
            else => {},
        }
        return;
    }
    if (kind == .type_ref) {
        const name = ctx.typeIdRefName(id);
        if (name.len > 0 and ctx.typeNameIsEnum(name)) {
            _ = collectExpectedFromEnum(name, buf, count, ctx);
            return;
        }
    }
    // boolean (the non-literal kind) covers both true and false.
    if (kind == .boolean) {
        if (count.* < buf.len) {
            buf[count.*] = .{ .kind = .bool_t, .bool_val = true };
            count.* += 1;
        }
        if (count.* < buf.len) {
            buf[count.*] = .{ .kind = .bool_t, .bool_val = false };
            count.* += 1;
        }
        return;
    }
    // null / undefined / void are singleton types — record as covered
    // literals so a `case null:` / `case undefined:` satisfies them.
    switch (kind) {
        .null_t => {
            if (count.* < buf.len) {
                buf[count.*] = .{ .kind = .null_v };
                count.* += 1;
            }
            return;
        },
        .undefined_t, .void_t => {
            if (count.* < buf.len) {
                buf[count.*] = .{ .kind = .undefined_v };
                count.* += 1;
            }
            return;
        },
        else => {},
    }
    // Any other kind (string, number, boolean, symbol, object_*, ...) counts as
    // a non-finite "rest" requiring default if requireDefaultForNonUnion.
    has_non_finite.* = true;
}

/// Recurse into the discriminant type and collect every reachable
/// literal value.  Returns false if any constituent isn't a finite
/// literal — i.e. the switch can't be exhaustively checked.
fn collectExpectedFromType(id: TypeId, buf: []ExpectedValue, count: *usize, ctx: *const LintContext) bool {
    return collectExpectedDepth(id, buf, count, ctx, 0);
}

fn collectExpectedDepth(id: TypeId, buf: []ExpectedValue, count: *usize, ctx: *const LintContext, depth: u32) bool {
    if (depth > 6) return false;
    const kind = ctx.typeIdKind(id) orelse return false;
    if (kind == .union_t) {
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (!collectExpectedDepth(m, buf, count, ctx, depth + 1)) return false;
        }
        return true;
    }
    if (kind == .intersection_t) {
        // For intersections (e.g. `'literal' & { _brand: true }`), the
        // base literal still drives exhaustiveness — pick any member
        // that classifies cleanly.
        for (ctx.typeIdUnionMembers(id)) |m| {
            if (collectExpectedDepth(m, buf, count, ctx, depth + 1)) return true;
        }
        return false;
    }
    const lv = ctx.typeIdLiteralValue(id);
    if (lv) |val| {
        if (count.* >= buf.len) return false;
        switch (val) {
            .string => |s| {
                buf[count.*] = .{ .kind = .str, .str_val = s };
                count.* += 1;
            },
            .number => |n| {
                buf[count.*] = .{ .kind = .num, .num_val = n };
                count.* += 1;
            },
            .bigint => |b| {
                buf[count.*] = .{ .kind = .big, .str_val = b };
                count.* += 1;
            },
            .boolean => |b| {
                buf[count.*] = .{ .kind = .bool_t, .bool_val = b };
                count.* += 1;
            },
            else => return false,
        }
        return true;
    }
    // Enum type_ref: look up the enum decl and enumerate its members.
    if (kind == .type_ref) {
        const name = ctx.typeIdRefName(id);
        if (name.len > 0 and ctx.typeNameIsEnum(name)) {
            return collectExpectedFromEnum(name, buf, count, ctx);
        }
    }
    return false;
}

fn collectExpectedFromEnum(name: []const u8, buf: []ExpectedValue, count: *usize, ctx: *const LintContext) bool {
    const decl = ctx.typeAliasBodyNode(name);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .ts_enum_decl) {
        // typeAliasBodyNode for enums returns the decl node itself; if
        // not, give up.
        return false;
    }
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    var i = ed.members_start;
    while (i < ed.members_end) : (i += 1) {
        if (count.* >= buf.len) return false;
        const m: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const md = ctx.nodeData(m);
        if (md.lhs == .none) continue;
        const mname = ctx.tokenText(ctx.nodeMainToken(md.lhs));
        buf[count.*] = .{
            .kind = .enum_member,
            .enum_name = name,
            .enum_member_name = mname,
        };
        count.* += 1;
    }
    return true;
}

/// Does any of the switch's case expressions match the expected value?
fn caseCoversExpected(cases: []NodeIndex, exp: *const ExpectedValue, ctx: *const LintContext) bool {
    for (cases) |c| {
        if (caseMatchesValue(c, exp, ctx)) return true;
    }
    return false;
}

fn caseMatchesValue(case_expr: NodeIndex, exp: *const ExpectedValue, ctx: *const LintContext) bool {
    var e = case_expr;
    while (ctx.nodeTag(e) == .grouping_expr) e = ctx.nodeData(e).lhs;
    const tag = ctx.nodeTag(e);
    switch (exp.kind) {
        .str => {
            if (tag == .string_literal) {
                const raw = ctx.tokenText(ctx.nodeMainToken(e));
                if (raw.len < 2) return false;
                return std.mem.eql(u8, raw[1 .. raw.len - 1], exp.str_val);
            }
            // Unique-symbol sentinel: `typeof x` where `const x = Symbol(...)`.
            // The sentinel encodes the variable name as the string value.
            // A `case x:` (identifier) covers it when the name matches.
            if (tag == .identifier) {
                const txt = ctx.tokenText(ctx.nodeMainToken(e));
                return std.mem.eql(u8, txt, exp.str_val);
            }
            // Enum-tagged string literals stored by value: `case MyEnum.Foo:`
            // where `MyEnum { Foo = 'bar' }` — compare the string initializer.
            if (tag == .member_expr) return memberExprMatchesStr(e, exp.str_val, ctx);
            return false;
        },
        .num => {
            if (numericCaseEquals(e, exp.num_val, ctx)) return true;
            // Enum-tagged numeric literals stored by value: `case MyEnum.Foo:`
            // where `MyEnum { Foo }` (value 0) — compute the member's numeric value.
            if (tag == .member_expr) return memberExprMatchesNum(e, exp.num_val, ctx);
            return false;
        },
        .big => {
            if (tag != .bigint_literal) return false;
            const raw = ctx.tokenText(ctx.nodeMainToken(e));
            // bigint literals have an 'n' suffix; compare without it.
            if (raw.len < 2 or raw[raw.len - 1] != 'n') return false;
            return std.mem.eql(u8, raw[0 .. raw.len - 1], exp.str_val);
        },
        .bool_t => {
            if (tag != .boolean_literal) return false;
            const txt = ctx.tokenText(ctx.nodeMainToken(e));
            const is_true = std.mem.eql(u8, txt, "true");
            return is_true == exp.bool_val;
        },
        .null_v => return tag == .null_literal,
        .undefined_v => {
            // `case undefined` is an identifier reference to global
            // undefined.
            if (tag == .identifier) {
                const txt = ctx.tokenText(ctx.nodeMainToken(e));
                return std.mem.eql(u8, txt, "undefined");
            }
            return false;
        },
        .enum_member => {
            // case Enum.Member or case Member (bare).
            if (tag == .member_expr) {
                const md = ctx.nodeData(e);
                if (md.rhs == .none) return false;
                const member = ctx.tokenText(ctx.nodeMainToken(md.rhs));
                if (!std.mem.eql(u8, member, exp.enum_member_name)) return false;
                // The receiver should be the enum name (best-effort).
                var recv = md.lhs;
                while (ctx.nodeTag(recv) == .grouping_expr) recv = ctx.nodeData(recv).lhs;
                if (ctx.nodeTag(recv) == .identifier) {
                    const rn = ctx.tokenText(ctx.nodeMainToken(recv));
                    return std.mem.eql(u8, rn, exp.enum_name);
                }
                return true; // member name matched
            }
            return false;
        },
    }
}

/// Resolve a `member_expr` case like `MyEnum.Foo` to its numeric enum value
/// and compare with `expected`.  Handles auto-increment and explicit number
/// or unary-minus initializers.  Returns false for complex initialisers.
fn memberExprMatchesNum(e: NodeIndex, expected: f64, ctx: *const LintContext) bool {
    const md = ctx.nodeData(e);
    if (md.rhs == .none) return false;
    var obj = md.lhs;
    while (ctx.nodeTag(obj) == .grouping_expr) obj = ctx.nodeData(obj).lhs;
    if (ctx.nodeTag(obj) != .identifier) return false;
    const enum_nm = ctx.tokenText(ctx.nodeMainToken(obj));
    const member_nm = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const decl = ctx.typeAliasBodyNode(enum_nm);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .ts_enum_decl) return false;
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    var auto_val: f64 = 0;
    var i = ed.members_start;
    while (i < ed.members_end) : (i += 1) {
        const m: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const mdata = ctx.nodeData(m);
        if (mdata.lhs == .none) continue;
        const mname = ctx.tokenText(ctx.nodeMainToken(mdata.lhs));
        var this_val: f64 = auto_val;
        if (mdata.rhs != .none) {
            var init = mdata.rhs;
            var neg = false;
            if (ctx.nodeTag(init) == .unary_minus) {
                neg = true;
                init = ctx.nodeData(init).lhs;
            }
            if (ctx.nodeTag(init) == .number_literal) {
                const txt = ctx.tokenText(ctx.nodeMainToken(init));
                this_val = std.fmt.parseFloat(f64, txt) catch auto_val;
                if (neg) this_val = -this_val;
            }
        }
        auto_val = this_val + 1;
        if (std.mem.eql(u8, mname, member_nm)) return this_val == expected;
    }
    return false;
}

/// Resolve a `member_expr` case like `MyEnum.Foo` to its string initializer
/// and compare with `expected`.
fn memberExprMatchesStr(e: NodeIndex, expected: []const u8, ctx: *const LintContext) bool {
    const md = ctx.nodeData(e);
    if (md.rhs == .none) return false;
    var obj = md.lhs;
    while (ctx.nodeTag(obj) == .grouping_expr) obj = ctx.nodeData(obj).lhs;
    if (ctx.nodeTag(obj) != .identifier) return false;
    const enum_nm = ctx.tokenText(ctx.nodeMainToken(obj));
    const member_nm = ctx.tokenText(ctx.nodeMainToken(md.rhs));
    const decl = ctx.typeAliasBodyNode(enum_nm);
    if (decl == .none) return false;
    if (ctx.nodeTag(decl) != .ts_enum_decl) return false;
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    var i = ed.members_start;
    while (i < ed.members_end) : (i += 1) {
        const m: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
        if (ctx.nodeTag(m) != .ts_enum_member) continue;
        const mdata = ctx.nodeData(m);
        if (mdata.lhs == .none) continue;
        const mname = ctx.tokenText(ctx.nodeMainToken(mdata.lhs));
        if (!std.mem.eql(u8, mname, member_nm)) continue;
        if (mdata.rhs == .none) return false;
        if (ctx.nodeTag(mdata.rhs) == .string_literal) {
            const raw = ctx.tokenText(ctx.nodeMainToken(mdata.rhs));
            if (raw.len < 2) return false;
            return std.mem.eql(u8, raw[1 .. raw.len - 1], expected);
        }
        return false;
    }
    return false;
}

fn numericCaseEquals(e: NodeIndex, expected: f64, ctx: *const LintContext) bool {
    var n = e;
    while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    var neg = false;
    if (ctx.nodeTag(n) == .unary_minus) {
        neg = true;
        n = ctx.nodeData(n).lhs;
        while (ctx.nodeTag(n) == .grouping_expr) n = ctx.nodeData(n).lhs;
    }
    if (ctx.nodeTag(n) != .number_literal) return false;
    const txt = ctx.tokenText(ctx.nodeMainToken(n));
    const v = std.fmt.parseFloat(f64, txt) catch return false;
    const final = if (neg) -v else v;
    return final == expected;
}

fn isFiniteUnion(id: TypeId, ctx: *const LintContext) bool {
    var buf: [4]ExpectedValue = undefined;
    var count: usize = 0;
    return collectExpectedFromType(id, buf[0..], &count, ctx);
}
