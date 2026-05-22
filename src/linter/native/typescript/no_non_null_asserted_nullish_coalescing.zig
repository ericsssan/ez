// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-asserted-nullish-coalescing
//
// Reports `<expr>! ?? <other>`: the `!` removes `null|undefined` from
// the operand, which is exactly the case `??` would have handled —
// the operator combination is contradictory.  The rule also flags
// `x!` when `x` was declared with a definite-assignment assertion
// (`let x!: T`) and used in `??`, but only the direct shape is
// caught here.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-nullish-coalescing",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions in the LHS of nullish coalescing",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.nullish_coalesce};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;
    var l = lhs;
    while (ctx.nodeTag(l) == .grouping_expr) l = ctx.nodeData(l).lhs;
    if (ctx.nodeTag(l) != .ts_non_null_expr) return;
    // Only fire when the asserted operand is provably non-nullable
    // without the `!`.  We detect the simple case: a bare identifier
    // whose declaration uses a definite-assignment marker (`let x!:`),
    // or a parameter property / field of that shape.  Member-access
    // forms (`foo.bar!`) and call results stay because the operand's
    // type may legitimately include `undefined`.
    const inner = ctx.nodeData(l).lhs;
    if (inner == .none) return;
    if (!operandIsNonNullable(inner, ctx)) return;
    ctx.reportWithMessageId(l, "noNonNullAssertedNullishCoalescing");
}

fn operandIsNonNullable(n: NodeIndex, ctx: *const LintContext) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    const tag = ctx.nodeTag(node);
    // For identifiers, fire UNLESS the declaration is a `let|var|
    // const <name>:` form with NO definite-assignment marker — TS
    // treats those uses as possibly-undefined, so the `!` is needed.
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (name.len == 0) return false;
        return !identifierDeclaredWithoutBang(name, ctx);
    }
    // Member access, call results, etc. — fire by default; the
    // property/return type is inferred.
    return true;
}

fn identifierDeclaredWithoutBang(name: []const u8, ctx: *const LintContext) bool {
    const src = ctx.ast.source;
    const kws = [_][]const u8{ "let ", "var ", "const " };
    var found_decl = false;
    var found_definite = false;
    for (kws) |kw| {
        var pos: usize = 0;
        while (pos < src.len) {
            const idx = std.mem.indexOfPos(u8, src, pos, kw) orelse break;
            const after_kw = idx + kw.len;
            if (after_kw + name.len > src.len) break;
            if (!std.mem.eql(u8, src[after_kw .. after_kw + name.len], name)) {
                pos = idx + 1;
                continue;
            }
            // Make sure this match isn't a prefix of a longer identifier.
            const after_name = after_kw + name.len;
            if (after_name < src.len) {
                const c = src[after_name];
                if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
                    (c >= '0' and c <= '9') or c == '_' or c == '$')
                {
                    pos = idx + 1;
                    continue;
                }
                found_decl = true;
                if (c == '!') found_definite = true;
            }
            pos = idx + 1;
        }
    }
    return found_decl and !found_definite;
}
