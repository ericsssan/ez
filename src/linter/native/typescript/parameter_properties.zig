// HAND-WRITTEN.
// Rule: @typescript-eslint/parameter-properties
//
// Default style "no-parameter-properties": flag constructors that
// declare any parameter property.  Option `prefer` flips: `prefer:
// "parameter-property"` is documented but only suppresses on
// explicitly-allowed modifiers; the default mode is what corpus
// fixtures use.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "parameter-properties",
    .category = .style,
    .default_severity = .@"error",
    .description = "Require or disallow parameter properties in class constructors",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.method_def};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // With `prefer: "parameter-property"`, the rule's expected
    // direction inverts — fire on class fields, not on parameter
    // properties.  We don't implement that path; just suppress.
    if (preferIsParameterProperty(ctx)) return;
    const key = ctx.nodeData(node).lhs;
    if (key == .none or ctx.nodeTag(key) != .identifier) return;
    if (!std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(key)), "constructor")) return;
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const md = ctx.extraData(ast.MethodData, @intFromEnum(data.rhs));
    if (md.params_end <= md.params_start or md.params_end > ctx.ast.extra_data.len) return;
    // `allow`: list of modifier names where parameter properties are OK.
    var allowed: [12][]const u8 = undefined;
    var n_allowed: usize = 0;
    collectAllowedModifiers(ctx, &allowed, &n_allowed);
    for (ctx.ast.extra_data[md.params_start..md.params_end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        const info = paramPropertyInfo(p, ctx) orelse continue;
        if (isInAllowed(info.modifier_combo, allowed[0..n_allowed])) continue;
        ctx.reportSpanWithMessageId(.{
            .start = @intCast(info.start),
            .end = @intCast(info.end),
        }, info.message_id);
    }
}

const Info = struct {
    start: u32,
    end: u32,
    modifier_combo: []const u8,
    message_id: []const u8,
};

fn paramPropertyInfo(p: NodeIndex, ctx: *const LintContext) ?Info {
    if (ctx.nodeTag(p) != .ts_parameter_property) return null;
    // Decide the actual modifier text from source.
    const sp = ctx.nodeSpan(p);
    const src = ctx.ast.source;
    var i: usize = sp.start;
    while (i < src.len and (src[i] == ' ' or src[i] == '\t')) i += 1;
    const start: usize = i;
    // Read leading keywords.
    var has_public = false;
    var has_private = false;
    var has_protected = false;
    var has_readonly = false;
    while (i < src.len) {
        // Skip whitespace.
        while (i < src.len and (src[i] == ' ' or src[i] == '\t')) i += 1;
        if (i >= src.len) break;
        // Read identifier-like token.
        const tok_start = i;
        while (i < src.len) {
            const c = src[i];
            if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or c == '_') {
                i += 1;
            } else break;
        }
        const text = src[tok_start..i];
        if (std.mem.eql(u8, text, "public")) has_public = true
        else if (std.mem.eql(u8, text, "private")) has_private = true
        else if (std.mem.eql(u8, text, "protected")) has_protected = true
        else if (std.mem.eql(u8, text, "readonly")) has_readonly = true
        else break;
    }
    // Pick a modifier-combo string and message id.
    var combo: []const u8 = "";
    var mid: []const u8 = "";
    if (has_public and has_readonly) { combo = "public readonly"; mid = "preferClassProperty"; }
    else if (has_private and has_readonly) { combo = "private readonly"; mid = "preferClassProperty"; }
    else if (has_protected and has_readonly) { combo = "protected readonly"; mid = "preferClassProperty"; }
    else if (has_readonly) { combo = "readonly"; mid = "preferClassProperty"; }
    else if (has_public) { combo = "public"; mid = "preferClassProperty"; }
    else if (has_private) { combo = "private"; mid = "preferClassProperty"; }
    else if (has_protected) { combo = "protected"; mid = "preferClassProperty"; }
    else return null;
    // Extend the end forward through the type annotation: TSe reports
    // the full `private foo: T` range, but our nodeSpan stops short.
    var end_pos: usize = sp.end;
    var depth: i32 = 0;
    while (end_pos < src.len) {
        const c = src[end_pos];
        if (c == ',' and depth == 0) break;
        if (c == ')' and depth == 0) break;
        if (c == '=' and depth == 0) break;
        if (c == '<' or c == '(' or c == '[' or c == '{') depth += 1
        else if (c == '>' or c == ')' or c == ']' or c == '}') depth -= 1;
        end_pos += 1;
    }
    // Trim trailing whitespace.
    while (end_pos > sp.end and (src[end_pos - 1] == ' ' or src[end_pos - 1] == '\t')) end_pos -= 1;
    return .{
        .start = @intCast(start),
        .end = @intCast(end_pos),
        .modifier_combo = combo,
        .message_id = mid,
    };
}

fn preferIsParameterProperty(ctx: *const LintContext) bool {
    const s = ctx.getOptionString("prefer") orelse return false;
    return std.mem.eql(u8, s, "parameter-property");
}

fn collectAllowedModifiers(ctx: *const LintContext, buf: *[12][]const u8, out_len: *usize) void {
    out_len.* = 0;
    const opts = ctx.rule_options orelse return;
    if (opts.* != .object) return;
    const allow = opts.object.get("allow") orelse return;
    if (allow != .array) return;
    for (allow.array.items) |item| {
        if (item != .string) continue;
        if (out_len.* >= buf.len) break;
        buf[out_len.*] = item.string;
        out_len.* += 1;
    }
}

fn isInAllowed(combo: []const u8, allowed: []const []const u8) bool {
    for (allowed) |a| if (std.mem.eql(u8, a, combo)) return true;
    return false;
}
