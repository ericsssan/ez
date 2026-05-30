// HAND-WRITTEN.
// Rule: @typescript-eslint/no-unsafe-declaration-merging
//
// Reports when an interface and a class share the same name in the
// same scope.  Class definitions partly merge with interfaces, which
// can hide unimplemented methods at runtime.

const std = @import("std");
const parser = @import("es_parser");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-declaration-merging",
    .category = .suspicious,
    .default_severity = .@"error",
    .description = "Disallow unsafe declaration merging",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.root};

const Entry = struct {
    name: []const u8,
    name_tok: u32,
    kind: enum { class_, interface_ },
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    _ = node;
    checkScope(.root, ctx);
}

fn checkScope(scope_node: NodeIndex, ctx: *const LintContext) void {
    var entries: [128]Entry = undefined;
    var n: usize = 0;
    if (scope_node == .root) {
        const root_data = ctx.nodeData(@enumFromInt(@intFromEnum(NodeIndex.root)));
        iterateStmts(root_data.lhs, root_data.rhs, ctx, &entries, &n);
    } else {
        const bd = ctx.nodeData(scope_node);
        iterateStmts(bd.lhs, bd.rhs, ctx, &entries, &n);
    }
    var i: usize = 0;
    while (i < n) : (i += 1) {
        const a = entries[i];
        var j: usize = i + 1;
        while (j < n) : (j += 1) {
            const b = entries[j];
            if (a.kind == b.kind) continue;
            if (!std.mem.eql(u8, a.name, b.name)) continue;
            reportTok(a.name_tok, ctx);
            reportTok(b.name_tok, ctx);
        }
    }
}

fn iterateStmts(s: NodeIndex, e: NodeIndex, ctx: *const LintContext, buf: *[128]Entry, out_n: *usize) void {
    const s_idx = @intFromEnum(s);
    const e_idx = @intFromEnum(e);
    if (s_idx >= e_idx or e_idx > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[s_idx..e_idx]) |raw| {
        visit(@enumFromInt(raw), ctx, buf, out_n);
    }
}

fn reportTok(tok: u32, ctx: *const LintContext) void {
    const start = ctx.ast.tokenStart(tok);
    const len = ctx.ast.tokens.items(.len)[tok];
    ctx.reportSpanWithMessageId(.{
        .start = @intCast(start),
        .end = @intCast(start + len),
    }, "unsafeMerging");
}


fn visit(node: NodeIndex, ctx: *const LintContext, buf: *[128]Entry, out_n: *usize) void {
    if (out_n.* >= buf.len) return;
    const tag = ctx.nodeTag(node);
    switch (tag) {
        .class_decl, .class_expr => {
            const cd = ctx.extraData(ast.ClassData, @intFromEnum(ctx.nodeData(node).lhs));
            if (cd.name != .none) {
                const tok = ctx.nodeMainToken(cd.name);
                buf[out_n.*] = .{
                    .name = ctx.tokenText(tok),
                    .name_tok = tok,
                    .kind = .class_,
                };
                out_n.* += 1;
            }
        },
        .ts_interface_decl => {
            const id = ctx.extraData(ast.InterfaceData, @intFromEnum(ctx.nodeData(node).lhs));
            buf[out_n.*] = .{
                .name = ctx.tokenText(id.name),
                .name_tok = id.name,
                .kind = .interface_,
            };
            out_n.* += 1;
        },
        // Recurse into export wrappers + `declare global { ... }` etc.
        .export_named, .export_default_class, .export_default_fn => {
            const d = ctx.nodeData(node).lhs;
            if (d != .none) visit(d, ctx, buf, out_n);
        },
        .ts_module_decl, .ts_namespace_decl => {
            // Module/namespace declarations introduce a new scope.
            const body = ctx.nodeData(node).rhs;
            if (body == .none) return;
            checkScope(body, ctx);
        },
        // `declare global { ... }` parses to a bare block_stmt at the
        // top level — recurse with a fresh scope so its members don't
        // collide with the file's own top-level declarations.
        .block_stmt => checkScope(node, ctx),
        else => {},
    }
}
