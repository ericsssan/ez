// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unnecessary-qualifier
//
// Flags `Foo.bar` (value-position member_expr or type-position
// ts_type_reference) when the chain is inside the namespace/enum whose
// name(s) form a suffix of the qualifier.  Example:
//
//   namespace A { export type B = number; const x: A.B = 3; }
//                                                    ^^^ unnecessary
//
// We only consider the outermost element of a member chain; nested
// member_exprs are skipped.  The root identifier of the qualifier
// chain is the report site.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unnecessary-qualifier",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow unnecessary namespace/enum qualifiers",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .member_expr,
};

pub const needs_semantic = true;

const NAME_BUF_LEN = 16;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // Skip nested member_exprs — handle only the outermost in a chain.
    const parent = ctx.parentOf(node);
    if (parent != .none) {
        const ptag = ctx.nodeTag(parent);
        if (ptag == .member_expr) return;
    }

    // Collect the qualifier chain root → tail (e.g. `A.B.C.D` → ["A","B","C","D"]).
    // The last segment is the value/type member being accessed; everything
    // before it is the qualifier path.
    var chain_buf: [NAME_BUF_LEN][]const u8 = undefined;
    const chain = collectChain(node, ctx, chain_buf[0..]) orelse return;
    if (chain.len < 2) return;

    // Walk up from `node` to collect enclosing namespace/enum names.
    var encl_buf: [NAME_BUF_LEN][]const u8 = undefined;
    const enclosing = collectEnclosing(node, ctx, encl_buf[0..]);
    if (enclosing.len == 0) return;

    const qual = chain[0 .. chain.len - 1];
    const accessed = chain[chain.len - 1];

    // The qualifier must be a contiguous prefix of the enclosing chain
    // (read outer → inner).  E.g. inside `A.B`, qual `A` or `A.B` are
    // both droppable.  `B` alone (the inner) also works when accessing
    // a B-export.
    if (!isPrefixOrInnerSuffix(enclosing, qual)) return;

    // Ensure the innermost qualifier segment's namespace actually
    // exports the accessed name — otherwise dropping the qualifier
    // would dangle (e.g. `namespace X { const z = X.y }` where `y`
    // isn't declared as an X-export).
    if (!innermostQualifierExports(node, qual, accessed, ctx)) return;

    // Shadowing check: any nested namespace between the qualifier's
    // innermost namespace and our use site that also declares
    // `accessed` would shadow the unqualified name — qualification
    // is then necessary.
    if (shadowedByInnerScope(node, qual, accessed, ctx)) return;

    // Report on the qualifier portion (everything except the accessed
    // property).  For `A.B.T`, that's the lhs of the outermost
    // member_expr = `A.B`.
    const qual_node = ctx.nodeData(node).lhs;
    ctx.reportWithMessageId(qual_node, "unnecessaryQualifier");
}

/// True when `qual` is either a prefix of `enclosing` (outer → inner)
/// or matches the innermost enclosing namespace.
fn isPrefixOrInnerSuffix(enclosing: []const []const u8, qual: []const []const u8) bool {
    if (qual.len == 0 or qual.len > enclosing.len) return false;
    // Prefix match (e.g. enclosing=A.B, qual=A → ok).
    {
        var i: usize = 0;
        while (i < qual.len) : (i += 1) {
            if (!std.mem.eql(u8, qual[i], enclosing[i])) break;
        }
        if (i == qual.len) return true;
    }
    return false;
}

/// Walk the immediate enclosing namespace/enum decl whose name matches
/// the LAST segment of the qualifier.  Check whether its body declares
/// an exported member by `name`.  Returns true (=> safe to drop) when
/// a matching declaration is found; false otherwise.
fn innermostQualifierExports(
    node: NodeIndex,
    qual: []const []const u8,
    name: []const u8,
    ctx: *const LintContext,
) bool {
    if (qual.len == 0) return false;
    const last = qual[qual.len - 1];
    // Find the nearest enclosing decl whose name matches `last`.
    var cur: NodeIndex = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        const tag = ctx.nodeTag(cur);
        if (tag == .ts_enum_decl) {
            if (std.mem.eql(u8, enumName(cur, ctx), last)) {
                return enumHasMember(cur, name, ctx);
            }
            continue;
        }
        if (tag == .ts_namespace_decl or tag == .ts_module_decl) {
            const d = ctx.nodeData(cur);
            if (namespaceInnermostName(d.lhs, ctx)) |nm| {
                if (std.mem.eql(u8, nm, last)) {
                    return namespaceExports(cur, name, ctx);
                }
            }
            continue;
        }
    }
    return false;
}

/// Walk from `node` upward.  Stop when we hit a decl whose innermost
/// name matches the qualifier's innermost segment.  Along the way, if
/// any nested namespace/enum/block declares `name`, return true (=>
/// qualification is necessary).
fn shadowedByInnerScope(
    node: NodeIndex,
    qual: []const []const u8,
    name: []const u8,
    ctx: *const LintContext,
) bool {
    if (qual.len == 0) return false;
    const inner_qual = qual[qual.len - 1];
    var cur: NodeIndex = ctx.parentOf(node);
    while (cur != .none) : (cur = ctx.parentOf(cur)) {
        const tag = ctx.nodeTag(cur);
        if (tag == .ts_namespace_decl or tag == .ts_module_decl) {
            const d = ctx.nodeData(cur);
            if (namespaceInnermostName(d.lhs, ctx)) |nm| {
                if (std.mem.eql(u8, nm, inner_qual)) return false; // reached the qualifier scope
            }
            // Check this namespace's body for a shadowing declaration.
            if (namespaceExports(cur, name, ctx)) return true;
        }
        if (tag == .ts_enum_decl) {
            if (std.mem.eql(u8, enumName(cur, ctx), inner_qual)) return false;
            if (enumHasMember(cur, name, ctx)) return true;
        }
    }
    return false;
}

fn namespaceInnermostName(name_node: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const cur = name_node;
    if (ctx.nodeTag(cur) == .member_expr) {
        const d = ctx.nodeData(cur);
        if (d.rhs == .none) return null;
        return ctx.tokenText(ctx.nodeMainToken(d.rhs));
    }
    if (ctx.nodeTag(cur) == .identifier) return ctx.tokenText(ctx.nodeMainToken(cur));
    return null;
}

fn enumHasMember(decl: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return false;
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    var i = ed.members_start;
    while (i < ed.members_end) : (i += 1) {
        const m: NodeIndex = @enumFromInt(ctx.ast.extra_data[i]);
        const md = ctx.nodeData(m);
        if (md.lhs == .none) continue;
        const tok = ctx.nodeMainToken(md.lhs);
        if (std.mem.eql(u8, ctx.tokenText(tok), name)) return true;
    }
    return false;
}

fn namespaceExports(decl: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    // Walk the namespace body's statements; look for declarations
    // whose declared name matches `name`.  Treat declarations as
    // "exports" when emitted at namespace-body scope — TSe's rule
    // only cares about reachability, so any declared name works.
    const d = ctx.nodeData(decl);
    const body = d.rhs;
    if (body == .none) return false;
    return bodyHasDeclByName(body, name, ctx);
}

fn bodyHasDeclByName(body: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    const tag = ctx.nodeTag(body);
    if (tag == .block_stmt) {
        const bd = ctx.nodeData(body);
        const s = @intFromEnum(bd.lhs);
        const e = @intFromEnum(bd.rhs);
        if (e <= s or e > ctx.ast.extra_data.len) return false;
        for (ctx.ast.extra_data[s..e]) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            if (stmtDeclaresName(stmt, name, ctx)) return true;
        }
    }
    return false;
}

fn stmtDeclaresName(stmt: NodeIndex, name: []const u8, ctx: *const LintContext) bool {
    var n = stmt;
    // `export` wrapper unwrapping.
    if (ctx.nodeTag(n) == .export_named) {
        const d = ctx.nodeData(n);
        if (d.rhs == .none) n = d.lhs;
    }
    const tag = ctx.nodeTag(n);
    switch (tag) {
        .var_decl, .let_decl, .const_decl => {
            const dd = ctx.nodeData(n);
            const s = @intFromEnum(dd.lhs);
            const e = @intFromEnum(dd.rhs);
            if (e <= s or e > ctx.ast.extra_data.len) return false;
            for (ctx.ast.extra_data[s..e]) |raw| {
                const dec: NodeIndex = @enumFromInt(raw);
                if (ctx.nodeTag(dec) != .declarator) continue;
                const binding = ctx.nodeData(dec).lhs;
                if (ctx.nodeTag(binding) == .identifier and
                    std.mem.eql(u8, ctx.tokenText(ctx.nodeMainToken(binding)), name))
                {
                    return true;
                }
            }
        },
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl => {
            // fn name is at main_token + 1; use tokenText of name token via
            // FnData — fall back to a simple identifier-after-main token.
            const fn_name = fnDeclName(n, ctx) orelse return false;
            if (std.mem.eql(u8, fn_name, name)) return true;
        },
        .class_decl => {
            const cn = classDeclName(n, ctx) orelse return false;
            if (std.mem.eql(u8, cn, name)) return true;
        },
        .ts_type_alias_decl => {
            const dn = ctx.nodeData(n);
            if (dn.lhs == .none) return false;
            const ad = ctx.extraData(ast.TypeAliasData, @intFromEnum(dn.lhs));
            if (std.mem.eql(u8, ctx.tokenText(ad.name), name)) return true;
        },
        .ts_enum_decl => {
            if (std.mem.eql(u8, enumName(n, ctx), name)) return true;
        },
        .ts_namespace_decl, .ts_module_decl => {
            const dn = ctx.nodeData(n);
            if (namespaceInnermostName(dn.lhs, ctx)) |nm| {
                if (std.mem.eql(u8, nm, name)) return true;
            }
        },
        .ts_interface_decl => {
            const id = ctx.nodeData(n);
            if (id.lhs == .none) return false;
            const idata = ctx.extraData(ast.InterfaceData, @intFromEnum(id.lhs));
            if (std.mem.eql(u8, ctx.tokenText(idata.name), name)) return true;
        },
        else => {},
    }
    return false;
}

fn fnDeclName(decl: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return null;
    const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
    if (fd.name == .none) return null;
    return ctx.tokenText(ctx.nodeMainToken(fd.name));
}

fn classDeclName(decl: NodeIndex, ctx: *const LintContext) ?[]const u8 {
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return null;
    const cd = ctx.extraData(ast.ClassData, @intFromEnum(d.lhs));
    if (cd.name == .none) return null;
    return ctx.tokenText(ctx.nodeMainToken(cd.name));
}

/// Walk a member_expr chain bottom-up, recording the property names from
/// root to the current node.  For `A.B.C`, returns ["A","B","C"].
/// Returns null if any segment isn't a simple identifier/property_ident.
fn collectChain(node: NodeIndex, ctx: *const LintContext, buf: [][]const u8) ?[][]const u8 {
    // Collect right-to-left from the outermost member_expr.
    var rev: [NAME_BUF_LEN][]const u8 = undefined;
    var n: usize = 0;
    var cur = node;
    while (true) {
        const tag = ctx.nodeTag(cur);
        if (tag == .member_expr) {
            const d = ctx.nodeData(cur);
            const prop = d.rhs;
            if (prop == .none) return null;
            const ptag = ctx.nodeTag(prop);
            if (ptag != .property_ident and ptag != .identifier) return null;
            if (n >= rev.len) return null;
            rev[n] = ctx.tokenText(ctx.nodeMainToken(prop));
            n += 1;
            cur = d.lhs;
            continue;
        }
        if (tag == .identifier) {
            if (n >= rev.len) return null;
            rev[n] = ctx.tokenText(ctx.nodeMainToken(cur));
            n += 1;
            break;
        }
        return null;
    }
    if (n > buf.len) return null;
    // Reverse into buf.
    var i: usize = 0;
    while (i < n) : (i += 1) buf[i] = rev[n - 1 - i];
    return buf[0..n];
}

fn chainRoot(node: NodeIndex, ctx: *const LintContext) NodeIndex {
    var cur = node;
    while (ctx.nodeTag(cur) == .member_expr) cur = ctx.nodeData(cur).lhs;
    return cur;
}

/// Collect the chain of enclosing namespace/enum names from outermost
/// to innermost — e.g. inside `namespace A { namespace B { ... } }`
/// returns ["A", "B"].  Flattens nested `namespace A.B` declarations.
fn collectEnclosing(node: NodeIndex, ctx: *const LintContext, buf: [][]const u8) [][]const u8 {
    var rev: [NAME_BUF_LEN][]const u8 = undefined;
    var n: usize = 0;
    var cur: NodeIndex = ctx.parentOf(node);
    while (cur != .none) {
        const tag = ctx.nodeTag(cur);
        if (tag == .ts_namespace_decl or tag == .ts_module_decl or tag == .ts_enum_decl) {
            n = appendDeclName(cur, tag, rev[0..], n, ctx);
        }
        cur = ctx.parentOf(cur);
    }
    if (n > buf.len) n = buf.len;
    // Reverse to outer-first.
    var i: usize = 0;
    while (i < n) : (i += 1) buf[i] = rev[n - 1 - i];
    return buf[0..n];
}

fn appendDeclName(
    decl: NodeIndex,
    tag: Node.Tag,
    rev: [][]const u8,
    in_n: usize,
    ctx: *const LintContext,
) usize {
    var n = in_n;
    // ts_enum_decl: lhs = extra index → EnumData with name token.
    // ts_namespace_decl: lhs = name (identifier or member_expr).
    if (tag == .ts_enum_decl) {
        // The name token is the main_token of the decl itself? Or stored
        // in EnumData.  Fall back to main_token's text.
        if (n < rev.len) {
            rev[n] = enumName(decl, ctx);
            n += 1;
        }
        return n;
    }
    const d = ctx.nodeData(decl);
    const name_node = d.lhs;
    // Flatten `namespace A.B` (name is a member_expr) — innermost-first push.
    var segs: [NAME_BUF_LEN][]const u8 = undefined;
    var sn: usize = 0;
    var cur = name_node;
    while (ctx.nodeTag(cur) == .member_expr) {
        const md = ctx.nodeData(cur);
        if (md.rhs != .none and sn < segs.len) {
            segs[sn] = ctx.tokenText(ctx.nodeMainToken(md.rhs));
            sn += 1;
        }
        cur = md.lhs;
    }
    if (ctx.nodeTag(cur) == .identifier and sn < segs.len) {
        segs[sn] = ctx.tokenText(ctx.nodeMainToken(cur));
        sn += 1;
    }
    // segs is innermost→outermost. Push to rev as innermost first (rev is
    // bottom-up); leave existing rev entries alone (they're inner-most-most).
    var i: usize = 0;
    while (i < sn and n < rev.len) : (i += 1) {
        rev[n] = segs[i];
        n += 1;
    }
    return n;
}

fn enumName(decl: NodeIndex, ctx: *const LintContext) []const u8 {
    // The enum decl's main_token is `enum`; the name follows.
    // Walk extra_data: ts_enum_decl.lhs = ExtraIndex to EnumData (name token at field 0).
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return &.{};
    const ed = ctx.extraData(ast.EnumData, @intFromEnum(d.lhs));
    return ctx.tokenText(ed.name);
}

