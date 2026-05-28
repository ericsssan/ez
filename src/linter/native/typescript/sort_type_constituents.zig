const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "sort-type-constituents",
    .category = .style,
    .default_severity = .@"error",
    .description = "Enforce constituents of a type union/intersection to be sorted alphabetically",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .ts_union_type,
    .ts_intersection_type,
};

// Default group order (index = priority, lower = earlier in sorted output):
// named=0, keyword=1, operator=2, literal=3, function=4, import=5,
// conditional=6, object=7, tuple=8, intersection=9, union=10, nullish=11
const GROUP_NAMES = [_][]const u8{
    "named", "keyword", "operator", "literal", "function", "import",
    "conditional", "object", "tuple", "intersection", "union", "nullish",
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const is_union = (tag == .ts_union_type);

    if (is_union and !getOptionBool(ctx, "checkUnions")) return;
    if (!is_union and !getOptionBool(ctx, "checkIntersections")) return;

    const case_sensitive = getOptionBool(ctx, "caseSensitive");

    // Members are stored inline as SubRange: data.lhs=start, data.rhs=end.
    const data = ctx.nodeData(node);
    const sr_start = @intFromEnum(data.lhs);
    const sr_end = @intFromEnum(data.rhs);
    if (sr_end <= sr_start or sr_end > ctx.ast.extra_data.len) return;
    const count = sr_end - sr_start;
    if (count < 2) return;

    var prev_group: u8 = 0;
    var prev_text: []const u8 = "";
    var prev_cat: u8 = 0;

    for (sr_start..sr_end) |i| {
        const mi: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
        const cur_group = getOrderedGroup(mi, ctx);
        const span = ctx.nodeSpan(mi);
        const cur_text = ctx.ast.source[span.start..span.end];
        const cur_cat = textCategory(cur_text);

        if (i > sr_start) {
            if (!lessOrEqual(prev_group, prev_text, prev_cat, cur_group, cur_text, cur_cat, case_sensitive)) {
                reportOnNode(node, is_union, ctx);
                return;
            }
        }
        prev_group = cur_group;
        prev_text = cur_text;
        prev_cat = cur_cat;
    }
}

fn reportOnNode(node: NodeIndex, is_union: bool, ctx: *const LintContext) void {
    const span = ctx.nodeSpan(node);
    // Use "notSortedNamed" when directly inside a type alias declaration.
    const parent = ctx.parentOf(node);
    if (parent != .none and ctx.nodeTag(parent) == .ts_type_alias_decl) {
        _ = is_union;
        ctx.reportSpanWithMessageId(span, "notSortedNamed");
    } else {
        ctx.reportSpanWithMessageId(span, "notSorted");
    }
}

fn lessOrEqual(ag: u8, at: []const u8, ac: u8, bg: u8, bt: []const u8, bc: u8, case_sensitive: bool) bool {
    if (ag != bg) return ag < bg;
    // Same group: compare by text category (punctuation < alphanumeric in Unicode collation).
    if (ac != bc) return ac < bc;
    // Same category: compare text.
    if (case_sensitive) return std.mem.lessThan(u8, at, bt) or std.mem.eql(u8, at, bt);
    // Case-insensitive comparison.
    var i: usize = 0;
    while (i < at.len and i < bt.len) : (i += 1) {
        const a = std.ascii.toLower(at[i]);
        const b = std.ascii.toLower(bt[i]);
        if (a < b) return true;
        if (a > b) return false;
    }
    return at.len <= bt.len;
}

/// Category for text sorting: 0 = starts with non-alphanumeric (punct/bracket),
/// 1 = starts with alphanumeric. Unicode collation puts punctuation before letters.
fn textCategory(text: []const u8) u8 {
    if (text.len == 0) return 0;
    const c = text[0];
    if (std.ascii.isAlphanumeric(c) or c == '_' or c == '$') return 1;
    return 0;
}

/// Returns true when the option key is true (or defaults to true when absent).
fn getOptionBool(ctx: *const LintContext, key: []const u8) bool {
    const opts = ctx.getOptions() orelse return true;
    if (opts.* != .object) return true;
    const val = opts.object.get(key) orelse return true;
    return if (val == .bool) val.bool else true;
}

/// Get the group index for a node, applying custom groupOrder if present.
fn getOrderedGroup(n: NodeIndex, ctx: *const LintContext) u8 {
    const base = getBaseGroup(n, ctx);
    const opts = ctx.getOptions() orelse return base;
    if (opts.* != .object) return base;
    const go_val = opts.object.get("groupOrder") orelse return base;
    if (go_val != .array) return base;
    const name = GROUP_NAMES[base];
    for (go_val.array.items, 0..) |item, idx| {
        if (item == .string and std.mem.eql(u8, item.string, name)) {
            return @intCast(idx);
        }
    }
    return 99; // not listed in custom groupOrder
}

fn getBaseGroup(n: NodeIndex, ctx: *const LintContext) u8 {
    const tag = ctx.nodeTag(n);
    return switch (tag) {
        .ts_type_reference => {
            const mt = ctx.nodeMainToken(n);
            const tok_tag = ctx.tokenTag(mt);
            return switch (tok_tag) {
                .kw_void, .kw_null => 11, // nullish
                .kw_this => 1,            // keyword (this type)
                // Literal types: `1`, `"foo"`, `true`, `false`, `1n` all
                // produce ts_type_reference nodes with literal token tags.
                .number_literal, .bigint_literal, .string_literal,
                .kw_true, .kw_false => 3, // literal
                .identifier => {
                    const text = ctx.tokenText(mt);
                    if (isKeywordTypeName(text)) return 1;     // keyword
                    if (std.mem.eql(u8, text, "undefined")) return 11; // nullish
                    return 0; // named
                },
                else => 0, // fallback to named
            };
        },
        .ts_array_type, .ts_indexed_access_type, .ts_infer_type => 0, // named
        .ts_keyof_type, .ts_typeof_type, .ts_type_query => 2,          // operator
        .string_literal, .number_literal, .boolean_literal,
        .bigint_literal, .ts_template_literal_type => 3,               // literal
        .ts_function_type, .ts_constructor_type => 4,                   // function
        .ts_import_type => 5,                                           // import
        .ts_conditional_type => 6,                                      // conditional
        .ts_type_literal, .ts_mapped_type => 7,                         // object
        .ts_tuple_type => 8,                                            // tuple
        .ts_intersection_type => 9,                                     // intersection
        .ts_union_type => 10,                                           // union
        // Parenthesized types like `(A | B)`, `(() => T)`, `(T extends U ? A : B)`.
        // The Ez parser produces ts_parenthesized_type with data.lhs = inner node.
        // Special: `(| A)` and `(& A)` have a leading `|`/`&` that gets consumed
        // and is not reflected in the inner node — detect via the next token.
        .ts_parenthesized_type => {
            const inner = ctx.nodeData(n).lhs;
            if (inner == .none) return 0;
            const mt = ctx.nodeMainToken(n);
            if (mt + 1 < ctx.ast.tokens.len) {
                const next = ctx.tokenTag(mt + 1);
                if (next == .pipe) return 10;      // (| ...) → union group
                if (next == .ampersand) return 9;  // (& ...) → intersection group
            }
            return getBaseGroup(inner, ctx);
        },
        else => 0, // default: named
    };
}

fn isKeywordTypeName(text: []const u8) bool {
    return std.mem.eql(u8, text, "any") or
        std.mem.eql(u8, text, "bigint") or
        std.mem.eql(u8, text, "boolean") or
        std.mem.eql(u8, text, "intrinsic") or
        std.mem.eql(u8, text, "never") or
        std.mem.eql(u8, text, "number") or
        std.mem.eql(u8, text, "object") or
        std.mem.eql(u8, text, "string") or
        std.mem.eql(u8, text, "symbol") or
        std.mem.eql(u8, text, "unknown");
}
