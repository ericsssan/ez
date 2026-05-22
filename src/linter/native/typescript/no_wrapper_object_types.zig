// HAND-WRITTEN.
// Rule: @typescript-eslint/no-wrapper-object-types
//
// Reports usages of the wrapper object types (BigInt, Boolean, Number,
// Object, String, Symbol) in type position.  TS recommends lowercase
// primitives (bigint, boolean, number, object, string, symbol)
// instead — the wrapper types refer to the prototype objects, not the
// primitive value type.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-wrapper-object-types",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow using confusing built-in primitive class wrappers",
    .fixable = true,
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.ts_type_reference};

const WrapperMap = struct {
    wrapper: []const u8,
    primitive: []const u8,
};

const WRAPPERS = [_]WrapperMap{
    .{ .wrapper = "BigInt", .primitive = "bigint" },
    .{ .wrapper = "Boolean", .primitive = "boolean" },
    .{ .wrapper = "Number", .primitive = "number" },
    .{ .wrapper = "Object", .primitive = "object" },
    .{ .wrapper = "String", .primitive = "string" },
    .{ .wrapper = "Symbol", .primitive = "symbol" },
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tok = ctx.nodeMainToken(node);
    const name = ctx.tokenText(tok);
    var found: ?WrapperMap = null;
    for (WRAPPERS) |w| {
        if (std.mem.eql(u8, name, w.wrapper)) { found = w; break; }
    }
    const w = found orelse return;
    // Skip when the source declares its own version of this type.
    if (sourceShadows(w.wrapper, ctx)) return;
    ctx.reportWithMessageId(node, "bannedClassType");
    _ = w.primitive;
}

fn sourceShadows(name: []const u8, ctx: *const LintContext) bool {
    const src = ctx.ast.source;
    var buf: [80]u8 = undefined;
    // Top-level shadowing declarations.
    inline for (.{ "type ", "interface ", "class ", "namespace " }) |kw| {
        const prefix = std.fmt.bufPrint(&buf, "{s}{s}", .{ kw, name }) catch return false;
        if (matchKeyword(src, prefix)) return true;
    }
    // Type-parameter shadowing — `<Name>` or `<…, Name>` etc.
    var i: usize = 0;
    while (i + name.len < src.len) : (i += 1) {
        if (src[i] != '<') continue;
        var j: usize = i + 1;
        while (j < src.len and (src[j] == ' ' or src[j] == '\t' or src[j] == '\n')) j += 1;
        // `infer Name` form inside a type expression.
        const infer_kw = "infer ";
        if (j + infer_kw.len + name.len <= src.len and std.mem.startsWith(u8, src[j..], infer_kw)) {
            j += infer_kw.len;
        }
        if (j + name.len <= src.len and std.mem.eql(u8, src[j .. j + name.len], name)) {
            const after = j + name.len;
            if (after >= src.len) return true;
            const c = src[after];
            const is_ident = (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')
                or (c >= '0' and c <= '9') or c == '_' or c == '$';
            if (!is_ident) return true;
        }
    }
    // `infer Name` anywhere in source.
    const infer_buf = std.fmt.bufPrint(&buf, "infer {s}", .{name}) catch return false;
    if (matchKeyword(src, infer_buf)) return true;
    return false;
}

fn matchKeyword(src: []const u8, prefix: []const u8) bool {
    if (std.mem.indexOf(u8, src, prefix)) |idx| {
        const after = idx + prefix.len;
        if (after >= src.len) return true;
        const c = src[after];
        const is_ident = (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z')
            or (c >= '0' and c <= '9') or c == '_' or c == '$';
        if (!is_ident) return true;
    }
    return false;
}
